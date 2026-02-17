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

import logging
import re
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.profile import Profile
from schemas.common import SuccessResponse
from services.auth import FirebaseUser, get_current_user
from services.usage import UsageCheck, check_and_increment

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1", tags=["chat"])


# ── Request / Response schemas ─────────────────────────────────────────


class ChatRequest(BaseModel):
    """POST /api/v1/chat request body."""

    message: str = Field(..., min_length=1, max_length=4000)
    image: str | None = Field(default=None, description="Base64 image (Phase 1)")
    domain: str | None = Field(
        default=None,
        description="Domain hint: banking, visa, medical, concierge",
    )
    locale: str = Field(default="en", max_length=10)


class UsageInfo(BaseModel):
    """Usage information returned with every chat response."""

    used: int
    limit: int | None = None  # None ⇒ unlimited
    tier: str


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
    r"\[TRACKER\]\s*\n(.*?)\n\s*\[/TRACKER\]", re.DOTALL | re.IGNORECASE,
)
_ACTIONS_RE = re.compile(
    r"\[ACTIONS\]\s*\n(.*?)\n\s*\[/ACTIONS\]", re.DOTALL | re.IGNORECASE,
)


def _parse_kv_lines(block: str) -> list[dict[str, str]]:
    """Parse lines like ``- key: val | key2: val2`` into list[dict]."""
    items: list[dict[str, str]] = []
    for line in block.strip().splitlines():
        line = line.strip().lstrip("- ").strip()
        if not line:
            continue
        pairs = [seg.strip() for seg in line.split("|")]
        item: dict[str, str] = {}
        for pair in pairs:
            if ":" in pair:
                k, v = pair.split(":", 1)
                item[k.strip()] = v.strip()
        if item:
            items.append(item)
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


# ── Helpers ────────────────────────────────────────────────────────────


async def _get_user_tier(db: AsyncSession, uid: str) -> str:
    """Return the user's subscription tier, defaulting to 'free'."""
    profile = await db.get(Profile, uid)
    if profile is None or profile.deleted_at is not None:
        return "free"
    return profile.subscription_tier or "free"


def _usage_to_info(uc: UsageCheck) -> UsageInfo:
    return UsageInfo(used=uc.used, limit=uc.limit, tier=uc.tier)


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
        from services.agent import build_session_id, call_agent, route_to_agent
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
    tier = await _get_user_tier(db, uid)

    # 2. Check usage limit (and increment atomically if allowed)
    usage = await check_and_increment(db, uid, tier)
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

    # 3. Route to agent domain (LLM-based classification)
    domain = await route_to_agent(body.message, current_domain=body.domain)

    # 4. Build session ID & call agent
    agent_id = domain  # route_to_agent already returns "svc-xxx" format
    domain_short = domain.removeprefix("svc-")  # for session ID and response
    session_id = build_session_id(uid, domain_short)

    # Prepend locale hint if not English
    agent_message = body.message
    if body.locale and body.locale != "en":
        agent_message = f"[User language: {body.locale}] {body.message}"

    agent_resp = await call_agent(
        agent_id=agent_id,
        session_id=session_id,
        message=agent_message,
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

    # 5. Parse structured blocks from agent response
    reply, sources, actions, tracker_items = _extract_blocks(agent_resp.text)

    # 6. Build response
    response = ChatResponse(
        reply=reply,
        domain=domain_short,
        sources=sources,
        actions=actions,
        tracker_items=tracker_items,
        usage=_usage_to_info(usage),
    )

    return SuccessResponse(data=response.model_dump()).model_dump()
