"""Navigator & Emergency endpoints — serve static knowledge guides.

GET  /api/v1/navigator/domains                  — List all domains
GET  /api/v1/navigator/{domain}/guides           — List guides for a domain
GET  /api/v1/navigator/{domain}/guides/{slug}    — Get specific guide
GET  /api/v1/emergency                           — Emergency contacts (public)
"""

import logging
import re
from pathlib import Path
from typing import Any

import yaml
from fastapi import APIRouter, Depends, HTTPException, Request, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from schemas.common import ErrorResponse, SuccessResponse

logger = logging.getLogger(__name__)

router = APIRouter(tags=["navigator"])

# ── Domain → knowledge directory mapping ───────────────────────────────

_AGENTS_ROOT = Path("/root/.openclaw/agents")

DOMAIN_CONFIG: dict[str, dict[str, Any]] = {
    "banking": {
        "label": "Banking & Finance",
        "icon": "🏦",
        "status": "active",
        "knowledge_path": _AGENTS_ROOT / "svc-banking" / "workspace" / "knowledge",
    },
    "visa": {
        "label": "Visa & Immigration",
        "icon": "🛂",
        "status": "active",
        "knowledge_path": _AGENTS_ROOT / "svc-visa" / "workspace" / "knowledge",
    },
    "medical": {
        "label": "Medical & Health",
        "icon": "🏥",
        "status": "active",
        "knowledge_path": _AGENTS_ROOT / "svc-medical" / "workspace" / "knowledge",
    },
    "concierge": {
        "label": "Life & General",
        "icon": "🗾",
        "status": "active",
        "knowledge_path": _AGENTS_ROOT / "svc-concierge" / "workspace" / "knowledge",
    },
    "housing": {
        "label": "Housing & Utilities",
        "icon": "🏠",
        "status": "coming_soon",
        "knowledge_path": None,
    },
    "employment": {
        "label": "Employment & Tax",
        "icon": "💼",
        "status": "coming_soon",
        "knowledge_path": None,
    },
    "education": {
        "label": "Education & Childcare",
        "icon": "🎓",
        "status": "coming_soon",
        "knowledge_path": None,
    },
    "legal": {
        "label": "Legal & Insurance",
        "icon": "⚖️",
        "status": "coming_soon",
        "knowledge_path": None,
    },
}


# ── Frontmatter parser ─────────────────────────────────────────────────


def _parse_frontmatter(text: str) -> tuple[dict[str, Any], str]:
    """Parse YAML frontmatter from markdown text.

    Returns a tuple of (metadata_dict, body_without_frontmatter).
    If no frontmatter is present, returns ({}, original_text).
    """
    if not text.startswith("---\n"):
        return {}, text

    # Find closing ---
    end_idx = text.find("\n---\n", 4)
    if end_idx == -1:
        # Check if --- is on the very last line
        end_idx = text.find("\n---", 4)
        if end_idx == -1 or text[end_idx + 4:].strip():
            return {}, text

    yaml_block = text[4:end_idx]
    body = text[end_idx + 4:].lstrip("\n")  # skip closing ---\n

    try:
        meta = yaml.safe_load(yaml_block)
        if not isinstance(meta, dict):
            return {}, text
    except yaml.YAMLError:
        return {}, text

    return meta, body


# ── Markdown helpers ───────────────────────────────────────────────────

# Regex patterns for stripping markdown syntax
_MD_STRIP_PATTERNS = [
    (re.compile(r"^#{1,6}\s+", re.MULTILINE), ""),      # headings
    (re.compile(r"\*\*(.+?)\*\*"), r"\1"),                # bold
    (re.compile(r"\*(.+?)\*"), r"\1"),                    # italic
    (re.compile(r"`(.+?)`"), r"\1"),                      # inline code
    (re.compile(r"\[(.+?)\]\(.+?\)"), r"\1"),             # links
    (re.compile(r"^>\s?", re.MULTILINE), ""),             # blockquotes
    (re.compile(r"^[-*+]\s", re.MULTILINE), ""),          # list items
    (re.compile(r"^\d+\.\s", re.MULTILINE), ""),          # ordered list items
    (re.compile(r"^[-*_]{3,}$", re.MULTILINE), ""),       # horizontal rules
]


def _strip_markdown(text: str) -> str:
    """Remove common markdown formatting from text."""
    result = text
    for pattern, replacement in _MD_STRIP_PATTERNS:
        result = pattern.sub(replacement, result)
    return result.strip()


def _generate_excerpt(body: str, max_chars: int = 300) -> str:
    """Generate an excerpt from markdown body.

    Takes the first 3 non-empty, non-heading lines, up to max_chars.
    """
    lines: list[str] = []
    for line in body.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        # Skip markdown headings
        if stripped.startswith("#"):
            continue
        lines.append(stripped)
        if len(lines) >= 3:
            break

    raw = " ".join(lines)
    cleaned = _strip_markdown(raw)

    if len(cleaned) > max_chars:
        cleaned = cleaned[:max_chars].rstrip() + "…"

    return cleaned


def _parse_md_file(file_path: Path) -> dict[str, Any]:
    """Parse a markdown file — extract frontmatter, title, summary, excerpt, and content."""
    try:
        text = file_path.read_text(encoding="utf-8")
    except OSError:
        return {"title": file_path.stem, "summary": "", "content": "", "access": "public", "body": "", "excerpt": ""}

    meta, body = _parse_frontmatter(text)
    access = meta.get("access", "public")

    # Title: first line starting with #
    title = file_path.stem.replace("-", " ").title()
    for line in body.splitlines():
        stripped = line.strip()
        if stripped.startswith("# "):
            title = stripped.lstrip("# ").strip()
            break

    # Summary: first non-empty, non-heading, non-blockquote paragraph
    summary = ""
    for line in body.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith("#") or stripped.startswith(">"):
            continue
        if re.match(r"^[-*_]{3,}$", stripped):
            continue
        summary = stripped
        break

    excerpt = _generate_excerpt(body, max_chars=200)

    return {
        "title": title,
        "summary": summary,
        "content": text,
        "body": body,
        "access": access,
        "excerpt": excerpt,
    }


# ── Optional authentication ───────────────────────────────────────────

_bearer_scheme = HTTPBearer(auto_error=False)


async def _get_optional_tier(
    request: Request,
    credentials: HTTPAuthorizationCredentials | None = Depends(_bearer_scheme),
) -> str | None:
    """Extract user subscription tier from an optional Bearer token.

    Returns the tier string (e.g. "free", "premium") if a valid token
    is provided, or None if no Authorization header is present.
    Silently returns None on any auth error (invalid/expired token).
    """
    if credentials is None:
        return None

    try:
        from services.auth import _verify_token
        user = _verify_token(credentials.credentials)
    except Exception:
        # Invalid token → treat as guest (no tier)
        return None

    # Look up profile to get tier
    try:
        from database import async_session_factory
        from models.profile import Profile

        async with async_session_factory() as db:
            profile = await db.get(Profile, user.uid)
            if profile is None or profile.deleted_at is not None:
                return "free"
            return profile.subscription_tier or "free"
    except Exception:
        logger.warning("Failed to look up tier for uid=%s", user.uid, exc_info=True)
        return "free"


# ── Endpoints ──────────────────────────────────────────────────────────


@router.get(
    "/api/v1/navigator/domains",
    response_model=SuccessResponse,
)
async def list_domains() -> dict:
    """List all navigation domains with status."""
    domains = []
    for key, cfg in DOMAIN_CONFIG.items():
        guide_count = 0
        if cfg["knowledge_path"] and Path(cfg["knowledge_path"]).is_dir():
            # Count guides excluding agent-only files
            for md_file in Path(cfg["knowledge_path"]).glob("*.md"):
                parsed = _parse_md_file(md_file)
                if parsed["access"] != "agent-only":
                    guide_count += 1
        domains.append(
            {
                "id": key,
                "label": cfg["label"],
                "icon": cfg["icon"],
                "status": cfg["status"],
                "guide_count": guide_count,
            }
        )
    return SuccessResponse(data={"domains": domains}).model_dump()


@router.get(
    "/api/v1/navigator/{domain}/guides",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def list_guides(domain: str) -> dict:
    """List available guides for a domain.

    Excludes agent-only guides. Includes access level and excerpt.
    """
    cfg = DOMAIN_CONFIG.get(domain)
    if cfg is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": f"Domain '{domain}' not found.",
                    "details": {},
                }
            },
        )

    if cfg["status"] == "coming_soon" or cfg["knowledge_path"] is None:
        return SuccessResponse(
            data={"domain": domain, "status": "coming_soon", "guides": []}
        ).model_dump()

    knowledge_dir = Path(cfg["knowledge_path"])
    if not knowledge_dir.is_dir():
        return SuccessResponse(
            data={"domain": domain, "guides": []}
        ).model_dump()

    guides = []
    for md_file in sorted(knowledge_dir.glob("*.md")):
        parsed = _parse_md_file(md_file)

        # Exclude agent-only guides from the listing
        if parsed["access"] == "agent-only":
            continue

        guides.append(
            {
                "slug": md_file.stem,
                "title": parsed["title"],
                "summary": parsed["summary"],
                "access": parsed["access"],
                "excerpt": parsed["excerpt"],
            }
        )

    return SuccessResponse(
        data={"domain": domain, "guides": guides}
    ).model_dump()


@router.get(
    "/api/v1/navigator/{domain}/guides/{slug}",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def get_guide(
    domain: str,
    slug: str,
    tier: str | None = Depends(_get_optional_tier),
) -> dict:
    """Get a specific guide with tier-based access control.

    - agent-only → 404
    - public → full content for everyone
    - premium → full content for standard/premium; excerpt + locked for free/guest
    """
    cfg = DOMAIN_CONFIG.get(domain)
    if cfg is None or cfg["knowledge_path"] is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": f"Domain '{domain}' not found.",
                    "details": {},
                }
            },
        )

    file_path = Path(cfg["knowledge_path"]) / f"{slug}.md"
    if not file_path.is_file():
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": f"Guide '{slug}' not found in domain '{domain}'.",
                    "details": {},
                }
            },
        )

    parsed = _parse_md_file(file_path)
    access = parsed["access"]

    # agent-only → 404 (not exposed via API)
    if access == "agent-only":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": f"Guide '{slug}' not found in domain '{domain}'.",
                    "details": {},
                }
            },
        )

    # Determine if user has premium access
    premium_tiers = {"standard", "premium", "premium_plus"}
    has_premium_access = tier is not None and tier in premium_tiers

    # public → full content for everyone
    if access == "public":
        return SuccessResponse(
            data={
                "domain": domain,
                "slug": slug,
                "title": parsed["title"],
                "access": access,
                "locked": False,
                "summary": parsed["summary"],
                "content": parsed["body"],
            }
        ).model_dump()

    # premium → check tier
    if has_premium_access:
        # Full access
        return SuccessResponse(
            data={
                "domain": domain,
                "slug": slug,
                "title": parsed["title"],
                "access": access,
                "locked": False,
                "summary": parsed["summary"],
                "content": parsed["body"],
            }
        ).model_dump()

    # Free / guest / None → excerpt only + locked
    excerpt = _generate_excerpt(parsed["body"], max_chars=300)
    return SuccessResponse(
        data={
            "domain": domain,
            "slug": slug,
            "title": parsed["title"],
            "access": access,
            "locked": True,
            "excerpt": excerpt,
            "upgrade_cta": True,
        }
    ).model_dump()


@router.get(
    "/api/v1/emergency",
    response_model=SuccessResponse,
)
async def emergency_info() -> dict:
    """Emergency contacts and quick guide — always public, no auth required."""
    emergency_path = _AGENTS_ROOT / "svc-medical" / "workspace" / "knowledge" / "emergency.md"

    if not emergency_path.is_file():
        # Return hardcoded essentials as fallback
        return SuccessResponse(
            data={
                "title": "Emergency Contacts — Japan",
                "contacts": [
                    {"name": "Police", "number": "110", "note": ""},
                    {"name": "Fire / Ambulance", "number": "119", "note": ""},
                    {"name": "Emergency (English)", "number": "#7119", "note": "Medical consultation"},
                    {"name": "TELL Japan", "number": "03-5774-0992", "note": "Mental health"},
                    {"name": "Japan Helpline", "number": "0570-064-211", "note": "24h, multilingual"},
                ],
                "content": None,
            }
        ).model_dump()

    parsed = _parse_md_file(emergency_path)
    return SuccessResponse(
        data={
            "title": parsed["title"],
            "contacts": [
                {"name": "Police", "number": "110", "note": ""},
                {"name": "Fire / Ambulance", "number": "119", "note": ""},
                {"name": "Emergency (English)", "number": "#7119", "note": "Medical consultation"},
                {"name": "TELL Japan", "number": "03-5774-0992", "note": "Mental health"},
                {"name": "Japan Helpline", "number": "0570-064-211", "note": "24h, multilingual"},
            ],
            "content": parsed["body"],
        }
    ).model_dump()
