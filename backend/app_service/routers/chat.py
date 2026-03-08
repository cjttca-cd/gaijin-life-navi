"""Chat endpoint — the primary conversational interface (API_DESIGN.md §1).

POST /api/v1/chat

Flow:
  1. Authenticate user via Firebase ID token
  2. Look up subscription tier from profile (default "free")
  3. Check & enforce usage limit
  4. Route message to the appropriate domain agent
  5. Call agent, parse structured blocks from response text
  6. Increment usage counter
  7. Return structured ChatResponse
"""

from __future__ import annotations

import base64
import logging
import re
import time
import uuid
from pathlib import Path
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.profile import Profile
from schemas.common import SuccessResponse
from services.auth import FirebaseUser, get_current_user
from services.usage import UsageCheck, check_and_consume

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1", tags=["chat"])


# ── Request / Response schemas ─────────────────────────────────────────


class ContextMessage(BaseModel):
    """A single prior conversation turn sent by the frontend."""

    role: str = Field(..., pattern="^(user|assistant)$")
    text: str = Field(..., max_length=8000)


class ChatRequest(BaseModel):
    """POST /api/v1/chat request body."""

    message: str = Field(..., min_length=1, max_length=4000)
    image: str | None = Field(default=None, description="Base64 image")
    domain: str | None = Field(
        default=None,
        description="Domain hint: finance, tax, visa, medical, life, legal",
    )
    locale: str = Field(default="en", max_length=10)
    context: list[ContextMessage] | None = Field(
        default=None,
        description="Prior conversation history from frontend (max 100 messages)",
        max_length=100,
    )


class UsageInfo(BaseModel):
    """Usage information returned with every chat response."""

    used: int
    limit: int | None = None  # None ⇒ unlimited
    tier: str
    period: str | None = None  # "lifetime" | "month" | None(unlimited)
    credit_used_from: str | None = None  # source of consumed credit
    total_remaining: int = 0


class ChatResponse(BaseModel):
    """POST /api/v1/chat response body."""

    reply: str
    domain: str
    sources: list[dict[str, Any]] = Field(default_factory=list)
    actions: list[dict[str, Any]] = Field(default_factory=list)
    tracker_items: list[dict[str, Any]] = Field(default_factory=list)
    usage: UsageInfo


# ── Response-text parsers ──────────────────────────────────────────────

# Agent responses may embed structured blocks like:
#   [SOURCES]
#   - title: Some Page | url: https://...
#   [/SOURCES]
#
#   [TRACKER]
#   - type: deadline | title: Visa renewal | date: 2025-04-01
#   [/TRACKER]

_SOURCES_RE = re.compile(
    r"\[SOURCES\]\s*\n(.*?)\n\s*\[/SOURCES\]", re.DOTALL | re.IGNORECASE,
)
_TRACKER_RE = re.compile(
    r"(?:\[TRACKER\]|---\s*TRACKER\s*---)\s*\n(.*?)(?:\n\s*\[/TRACKER\]|\n\s*---\s*(?:END[_ ]?TRACKER|TRACKER)\s*---|\Z)",
    re.DOTALL | re.IGNORECASE,
)
_ACTIONS_RE = re.compile(
    r"\[ACTIONS\]\s*\n(.*?)\n\s*\[/ACTIONS\]", re.DOTALL | re.IGNORECASE,
)


def _parse_kv_lines(block: str) -> list[dict[str, str]]:
    """Parse tracker lines in two formats:

    KV format:  ``- type: deadline | title: Visa renewal | date: 2025-04-01``
    Plain text: ``□ Go to city hall (within 14 days)``

    Returns list[dict] with at least ``type`` and ``title`` keys.
    """
    import unicodedata

    items: list[dict[str, str]] = []
    for line in block.strip().splitlines():
        line = line.strip()
        if not line:
            continue

        # Strip leading bullet markers: □ ☐ ☑ ✅ - [ ] - [x] •  numbered (1. 2.)
        cleaned = re.sub(
            r"^(?:[□☐☑✅•]|\d+[.):]|[-*]\s*\[[ x]?\]|[-*])\s*",
            "",
            line,
        ).strip()
        if not cleaned:
            continue

        # Try KV format first (contains | separator with key: value pairs)
        if "|" in cleaned and ":" in cleaned:
            pairs = [seg.strip() for seg in cleaned.split("|")]
            item: dict[str, str] = {}
            for pair in pairs:
                if ":" in pair:
                    k, v = pair.split(":", 1)
                    item[k.strip()] = v.strip()
            if item:
                items.append(item)
                continue

        # Plain text format — extract date if present, rest is title
        date_match = re.search(
            r"[（(](.*?(?:\d{4}[-/]\d{1,2}[-/]\d{1,2}).*?)[）)]",
            cleaned,
        )
        date_str = ""
        if date_match:
            # Extract just the date portion
            inner = date_match.group(1)
            d = re.search(r"\d{4}[-/]\d{1,2}[-/]\d{1,2}", inner)
            if d:
                date_str = d.group(0)

        items.append({
            "type": "task",
            "title": cleaned,
            **({"date": date_str} if date_str else {}),
        })

    return items


def _extract_blocks(text: str) -> tuple[str, list[dict], list[dict], list[dict]]:
    """Extract SOURCES, ACTIONS, and TRACKER blocks from agent text.

    Returns (clean_reply, sources, actions, tracker_items).
    The clean reply has the raw blocks stripped out.
    """
    sources: list[dict] = []
    actions: list[dict] = []
    tracker_items: list[dict] = []

    for match in _SOURCES_RE.finditer(text):
        sources.extend(_parse_kv_lines(match.group(1)))

    for match in _ACTIONS_RE.finditer(text):
        actions.extend(_parse_kv_lines(match.group(1)))

    for match in _TRACKER_RE.finditer(text):
        tracker_items.extend(_parse_kv_lines(match.group(1)))

    # Strip the raw blocks from the reply shown to the user
    clean = _SOURCES_RE.sub("", text)
    clean = _ACTIONS_RE.sub("", clean)
    clean = _TRACKER_RE.sub("", clean)
    clean = clean.strip()

    return clean, sources, actions, tracker_items


# ── Image upload helpers ────────────────────────────────────────────────

_MAX_IMAGE_BYTES = 5 * 1024 * 1024  # 5 MB
_UPLOAD_MAX_AGE_SECS = 3600  # 1 hour


def _detect_image_ext(data: bytes) -> str:
    """Detect image format from magic bytes. Returns file extension."""
    if data[:8] == b"\x89PNG\r\n\x1a\n":
        return "png"
    if data[:2] == b"\xff\xd8":
        return "jpg"
    if data[:4] == b"GIF8":
        return "gif"
    if data[:4] == b"RIFF" and data[8:12] == b"WEBP":
        return "webp"
    # Default to jpg for unrecognised formats.
    return "jpg"


def _save_image_to_workspace(
    agent_id: str, image_b64: str,
) -> str:
    """Decode base64 image, validate size, save to agent workspace.

    Returns the absolute filesystem path of the saved file.
    Raises ``HTTPException`` on validation failure.
    """
    try:
        image_data = base64.b64decode(image_b64, validate=True)
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "error": {
                    "code": "INVALID_IMAGE",
                    "message": "Image data is not valid base64.",
                    "details": {},
                }
            },
        )

    if len(image_data) > _MAX_IMAGE_BYTES:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail={
                "error": {
                    "code": "IMAGE_TOO_LARGE",
                    "message": f"Image exceeds maximum size of {_MAX_IMAGE_BYTES // (1024 * 1024)}MB.",
                    "details": {"max_bytes": _MAX_IMAGE_BYTES, "actual_bytes": len(image_data)},
                }
            },
        )

    ext = _detect_image_ext(image_data)
    filename = f"{uuid.uuid4().hex}_{int(time.time())}.{ext}"
    uploads_dir = Path(f"/root/.openclaw/agents/{agent_id}/workspace/uploads")
    uploads_dir.mkdir(parents=True, exist_ok=True)

    file_path = uploads_dir / filename
    file_path.write_bytes(image_data)
    logger.info("Saved uploaded image: %s (%d bytes)", file_path, len(image_data))

    return str(file_path)


def _cleanup_old_uploads(agent_id: str) -> None:
    """Delete upload files older than _UPLOAD_MAX_AGE_SECS."""
    uploads_dir = Path(f"/root/.openclaw/agents/{agent_id}/workspace/uploads")
    if not uploads_dir.exists():
        return
    cutoff = time.time() - _UPLOAD_MAX_AGE_SECS
    for f in uploads_dir.iterdir():
        if f.is_file() and f.stat().st_mtime < cutoff:
            try:
                f.unlink()
                logger.debug("Cleaned up old upload: %s", f)
            except OSError:
                pass


# ── Helpers ────────────────────────────────────────────────────────────


async def _get_user_tier(db: AsyncSession, uid: str, is_anonymous: bool = False) -> str:
    """Return the user's subscription tier.

    Anonymous Firebase users (no account) → 'guest'.
    Registered users without profile → 'free'.
    """
    if is_anonymous:
        return "guest"
    profile = await db.get(Profile, uid)
    if profile is None or profile.deleted_at is not None:
        return "free"
    return profile.subscription_tier or "free"


def _usage_to_info(uc: UsageCheck) -> UsageInfo:
    return UsageInfo(
        used=uc.used, limit=uc.limit, tier=uc.tier,
        period=uc.period,
        credit_used_from=uc.credit_used_from,
        total_remaining=uc.total_remaining,
    )


# ── Endpoint ───────────────────────────────────────────────────────────


@router.post("/chat")
async def chat(
    body: ChatRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Main conversational endpoint.

    Authenticates, checks usage, calls the domain agent, parses
    structured blocks, increments usage, and returns a ChatResponse.
    """
    # Late imports — agent service may not exist yet during early dev
    try:
        from services.agent import call_agent, route_to_agent
    except ImportError:
        logger.warning("services.agent not available — returning stub response")
        raise HTTPException(
            status_code=status.HTTP_501_NOT_IMPLEMENTED,
            detail={
                "error": {
                    "code": "NOT_IMPLEMENTED",
                    "message": "Agent service is not yet available.",
                    "details": {},
                }
            },
        )

    uid = current_user.uid

    # 1. Get user tier
    tier = await _get_user_tier(db, uid, is_anonymous=current_user.is_anonymous)

    # 2. Guest users cannot use AI Chat (403)
    #    TestFlight mode: allow anonymous users for testing.
    if tier == "guest":
        from config import settings
        if not settings.TESTFLIGHT_MODE:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail={
                    "error": {
                        "code": "CHAT_REQUIRES_AUTH",
                        "message": "AI Chat requires a registered account. Please sign up to continue.",
                        "details": {},
                    }
                },
            )
        # TestFlight: treat guest as free tier for credit check
        tier = "free"
        # Auto-grant trial credits if anonymous user has none
        from services.credits import get_balance, grant_credits
        balance = await get_balance(db, uid)
        if balance.total_remaining == 0:
            await grant_credits(
                db,
                user_id=uid,
                source="grant",
                amount=5,
                source_detail="testflight-trial",
                expires_at=None,
            )

    # 3. Check usage limit (and increment atomically if allowed)
    usage = await check_and_consume(db, uid, tier)
    if not usage.allowed:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail={
                "error": {
                    "code": "USAGE_LIMIT_EXCEEDED",
                    "message": (
                        f"Chat limit reached for your {tier} plan. "
                        f"Used {usage.used}/{usage.limit} chats."
                    ),
                    "details": {
                        "usage": _usage_to_info(usage).model_dump(),
                    },
                }
            },
        )

    # 4. Build context early — needed for both routing and agent call.
    context_dicts = None
    if body.context:
        context_dicts = [{"role": m.role, "text": m.text} for m in body.context]

    # 5. Route to agent domain (LLM-based classification with conversation context)
    domain = await route_to_agent(
        body.message,
        current_domain=body.domain,
        context=context_dicts,
    )
    agent_id = domain  # route_to_agent already returns "svc-xxx" format
    domain_short = domain.removeprefix("svc-")

    # 6. Build message with locale hint
    agent_message = body.message
    if body.locale and body.locale != "en":
        agent_message = f"[User language: {body.locale}] {body.message}"

    # 7. Handle image upload — decode, save, pass path to agent.
    image_path: str | None = None
    if body.image:
        image_path = _save_image_to_workspace(agent_id, body.image)
        # Clean up old uploads in the background (best-effort).
        _cleanup_old_uploads(agent_id)

    # 8. Fetch user profile for agent personalisation
    profile = await db.get(Profile, uid)
    user_profile: dict | None = None
    if profile and profile.deleted_at is None:
        user_profile = {
            "display_name": profile.display_name or None,
            "subscription_tier": profile.subscription_tier or "free",
            "nationality": profile.nationality,
            "residence_status": profile.residence_status,
            "visa_expiry": str(profile.visa_expiry) if profile.visa_expiry else None,
            "residence_region": profile.residence_region,
            "preferred_language": profile.preferred_language,
        }
        # Only pass if at least one field is non-empty
        if not any(user_profile.values()):
            user_profile = None

    # Guest users (anonymous auth) still need tier info
    if user_profile is None:
        user_profile = {"subscription_tier": tier}

    # 9. Call agent (stateless with /reset, context already built in step 3)
    agent_resp = await call_agent(
        agent_id=agent_id,
        message=agent_message,
        context=context_dicts,
        image_path=image_path,
        user_profile=user_profile,
    )

    if agent_resp.status != "ok":
        logger.error(
            "Agent call failed: user=%s domain=%s error=%s",
            uid, domain, agent_resp.error,
        )
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail={
                "error": {
                    "code": "AGENT_ERROR",
                    "message": "The AI agent encountered an error. Please try again.",
                    "details": {"agent_error": agent_resp.error or "unknown"},
                }
            },
        )

    # 10. Parse structured blocks from agent response
    reply, sources, actions, tracker_items = _extract_blocks(agent_resp.text)

    # 11. Build response
    response = ChatResponse(
        reply=reply,
        domain=domain_short,
        sources=sources,
        actions=actions,
        tracker_items=tracker_items,
        usage=_usage_to_info(usage),
    )

    return SuccessResponse(data=response.model_dump()).model_dump()
