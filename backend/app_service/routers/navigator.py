"""Navigator & Emergency endpoints — serve static guides.

Guides are sourced from each agent's workspace/guides/ directory.
Agent-internal knowledge (workspace/knowledge/) is NOT exposed via this API.

GET  /api/v1/navigator/domains                  — List all domains
GET  /api/v1/navigator/{domain}/guides           — List guides for a domain
GET  /api/v1/navigator/{domain}/guides/{slug}    — Get specific guide
GET  /api/v1/emergency                           — Emergency contacts (public)

All guide endpoints accept an optional ``lang`` query parameter (e.g. ``zh``,
``ja``).  When the requested language is unavailable for a given guide the
server falls back to ``ja`` (Japanese).
"""

import logging
import re
from pathlib import Path
from typing import Any

import yaml
from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from config import settings
from schemas.common import ErrorResponse, SuccessResponse

logger = logging.getLogger(__name__)

router = APIRouter(tags=["navigator"])

# ── Constants ──────────────────────────────────────────────────────────

_FALLBACK_LANG = "ja"
_SUPPORTED_LANGS = {"zh", "ja", "en", "vi", "pt", "ko"}

# ── Domain → guides directory mapping ──────────────────────────────────

_AGENTS_ROOT = Path("/root/.openclaw/agents")

DOMAIN_CONFIG: dict[str, dict[str, Any]] = {
    "finance": {
        "label": "Finance & Banking",
        "icon": "💰",
        "status": "active",
        "guides_path": _AGENTS_ROOT / "svc-finance" / "workspace" / "guides",
        "description": {
            "ja": "銀行口座・送金・保険・年金",
            "zh": "银行开户・汇款・保险・年金",
        },
    },
    "tax": {
        "label": "Tax & Social Insurance",
        "icon": "📊",
        "status": "active",
        "guides_path": _AGENTS_ROOT / "svc-tax" / "workspace" / "guides",
        "description": {
            "ja": "確定申告・源泉徴収・控除・住民税",
            "zh": "报税・源泉税・扣除・住民税",
        },
    },
    "visa": {
        "label": "Visa & Immigration",
        "icon": "🛂",
        "status": "active",
        "guides_path": _AGENTS_ROOT / "svc-visa" / "workspace" / "guides",
        "description": {
            "ja": "在留資格・更新・変更・永住",
            "zh": "签证类型・更新・变更・永住",
        },
    },
    "medical": {
        "label": "Medical & Health",
        "icon": "🏥",
        "status": "active",
        "guides_path": _AGENTS_ROOT / "svc-medical" / "workspace" / "guides",
        "description": {
            "ja": "健康保険・病院・薬局・救急",
            "zh": "健康保险・就医・药店・急救",
        },
    },
    "life": {
        "label": "Daily Life",
        "icon": "🌏",
        "status": "active",
        "guides_path": _AGENTS_ROOT / "svc-life" / "workspace" / "guides",
        "description": {
            "ja": "引越し・届出・運転免許・防災",
            "zh": "搬家・行政手续・驾照・防災",
        },
    },
    "legal": {
        "label": "Legal & Rights",
        "icon": "⚖️",
        "status": "active",
        "guides_path": _AGENTS_ROOT / "svc-legal" / "workspace" / "guides",
        "description": {
            "ja": "労働法・契約・相談窓口・権利",
            "zh": "劳动法・合同・咨询窗口・权利",
        },
    },
}


# ── Language-aware file helpers ────────────────────────────────────────

# Filename pattern: {slug}.{lang}.md  (e.g. bank-account-opening.zh.md)
_LANG_FILE_RE = re.compile(r"^(.+)\.([a-z]{2})\.md$")


def _parse_guide_filename(filename: str) -> tuple[str, str | None]:
    """Extract (slug, lang) from a guide filename.

    Returns (slug, lang) for language-suffixed files like ``foo.zh.md``,
    or (stem, None) for legacy files like ``foo.md``.
    """
    m = _LANG_FILE_RE.match(filename)
    if m:
        return m.group(1), m.group(2)
    # Legacy format (no language suffix)
    if filename.endswith(".md"):
        return filename[:-3], None
    return filename, None


def _resolve_guide_file(
    guides_dir: Path, slug: str, lang: str,
) -> Path | None:
    """Resolve the best matching guide file for *slug* and *lang*.

    Priority: {slug}.{lang}.md → {slug}.ja.md (fallback) → None.
    """
    # Try requested language first
    candidate = guides_dir / f"{slug}.{lang}.md"
    if candidate.is_file():
        return candidate

    # Fallback to Japanese
    if lang != _FALLBACK_LANG:
        fallback = guides_dir / f"{slug}.{_FALLBACK_LANG}.md"
        if fallback.is_file():
            return fallback

    # Legacy: {slug}.md (no language suffix)
    legacy = guides_dir / f"{slug}.md"
    if legacy.is_file():
        return legacy

    return None


def _collect_guide_slugs(guides_dir: Path) -> set[str]:
    """Return the set of unique guide slugs in a directory.

    Deduplicates across languages — ``foo.zh.md`` and ``foo.ja.md`` both
    contribute slug ``foo`` (counted once).
    """
    slugs: set[str] = set()
    for md_file in guides_dir.glob("*.md"):
        slug, _ = _parse_guide_filename(md_file.name)
        slugs.add(slug)
    return slugs


def _list_guides_for_lang(
    guides_dir: Path, lang: str,
) -> list[tuple[str, Path]]:
    """Return a sorted list of (slug, file_path) for the requested language.

    For each unique slug, resolves via ``_resolve_guide_file`` so the
    fallback logic is applied consistently.
    """
    slugs = sorted(_collect_guide_slugs(guides_dir))
    results: list[tuple[str, Path]] = []
    for slug in slugs:
        resolved = _resolve_guide_file(guides_dir, slug, lang)
        if resolved is not None:
            results.append((slug, resolved))
    return results


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


def _estimate_reading_time(body: str) -> int:
    """Estimate reading time in minutes.

    CJK-heavy text (≥30% ideographic chars): ~500 chars/min.
    Latin text: ~200 words/min.
    Always returns at least 1.
    """
    import unicodedata

    cjk_count = sum(1 for c in body if unicodedata.category(c).startswith("Lo"))
    if cjk_count > len(body) * 0.3:  # Primarily CJK text
        return max(1, cjk_count // 500)
    else:
        return max(1, len(body.split()) // 200)


def _parse_md_file(file_path: Path) -> dict[str, Any]:
    """Parse a markdown file — extract frontmatter, title, summary, excerpt, and content."""
    try:
        text = file_path.read_text(encoding="utf-8")
    except OSError:
        return {"title": file_path.stem, "summary": "", "content": "", "access": "public", "body": "", "excerpt": ""}

    meta, body = _parse_frontmatter(text)
    access = meta.get("access", "public")

    # Title: prefer frontmatter title, then first # heading, then filename
    title = meta.get("title", "")
    if not title:
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
        "lang": meta.get("lang"),
        "tags": meta.get("tags", []),
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
async def list_domains(
    lang: str = Query(default=_FALLBACK_LANG, description="Language code (e.g. zh, ja)"),
) -> dict:
    """List all navigation domains with status and guide count.

    Guide count is deduplicated across languages (each slug counted once).
    """
    domains = []
    for key, cfg in DOMAIN_CONFIG.items():
        guide_count = 0
        if cfg["guides_path"] and Path(cfg["guides_path"]).is_dir():
            guides_dir = Path(cfg["guides_path"])
            # Count unique slugs that are accessible (not agent-only)
            for slug, fpath in _list_guides_for_lang(guides_dir, lang):
                parsed = _parse_md_file(fpath)
                if parsed["access"] != "agent-only":
                    guide_count += 1
        # Resolve description: ja/zh have specific values; others fall back to ja.
        desc_map = cfg.get("description", {})
        description = desc_map.get(lang) or desc_map.get(_FALLBACK_LANG, "")
        domains.append(
            {
                "id": key,
                "label": cfg["label"],
                "icon": cfg["icon"],
                "status": cfg["status"],
                "guide_count": guide_count,
                "description": description,
            }
        )
    return SuccessResponse(data={"domains": domains}).model_dump()


@router.get(
    "/api/v1/navigator/{domain}/guides",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def list_guides(
    domain: str,
    lang: str = Query(default=_FALLBACK_LANG, description="Language code (e.g. zh, ja)"),
) -> dict:
    """List available guides for a domain in the requested language.

    Deduplicates by slug.  Falls back to ``ja`` when the requested
    language is unavailable for a given guide.
    Excludes agent-only guides.
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

    if cfg["status"] == "coming_soon" or cfg["guides_path"] is None:
        return SuccessResponse(
            data={"domain": domain, "status": "coming_soon", "guides": []}
        ).model_dump()

    guides_dir = Path(cfg["guides_path"])
    if not guides_dir.is_dir():
        return SuccessResponse(
            data={"domain": domain, "guides": []}
        ).model_dump()

    guides = []
    for slug, fpath in _list_guides_for_lang(guides_dir, lang):
        parsed = _parse_md_file(fpath)

        # Exclude agent-only guides from the listing
        if parsed["access"] == "agent-only":
            continue

        # Report the actual language served (may differ from requested if fallback)
        served_lang = parsed.get("lang") or _FALLBACK_LANG

        guides.append(
            {
                "slug": slug,
                "title": parsed["title"],
                "summary": parsed["summary"],
                "access": parsed["access"],
                "excerpt": parsed["excerpt"],
                "lang": served_lang,
                "tags": parsed["tags"],
            }
        )

    return SuccessResponse(
        data={"domain": domain, "lang": lang, "guides": guides}
    ).model_dump()


@router.get(
    "/api/v1/navigator/{domain}/guides/{slug}",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def get_guide(
    domain: str,
    slug: str,
    lang: str = Query(default=_FALLBACK_LANG, description="Language code (e.g. zh, ja)"),
    tier: str | None = Depends(_get_optional_tier),
) -> dict:
    """Get a specific guide with tier-based access control.

    Resolves the guide file for the requested language, falling back to
    ``ja`` when unavailable.

    - agent-only → 404 (defensive; should not exist in guides/)
    - free → full content for everyone
    - registered/premium → full content for logged-in users; excerpt + locked for guests
    """
    cfg = DOMAIN_CONFIG.get(domain)
    if cfg is None or cfg["guides_path"] is None:
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

    file_path = _resolve_guide_file(Path(cfg["guides_path"]), slug, lang)
    if file_path is None:
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
    served_lang = parsed.get("lang") or _FALLBACK_LANG

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

    # Plan C: any registered user can read all guides.
    # tier=None → guest (not logged in); tier!=None → registered user.
    # TestFlight mode: all guides visible to everyone (bypass access control).
    is_registered = tier is not None or settings.TESTFLIGHT_MODE

    # free/public → full content for everyone
    if access in ("public", "free"):
        return SuccessResponse(
            data={
                "domain": domain,
                "slug": slug,
                "lang": served_lang,
                "title": parsed["title"],
                "access": access,
                "locked": False,
                "summary": parsed["summary"],
                "content": parsed["body"],
                "tags": parsed["tags"],
                "reading_time_min": _estimate_reading_time(parsed["body"]),
            }
        ).model_dump()

    # premium / registered → full content for logged-in users;
    # excerpt + register CTA for guests.
    # "registered" is treated identically to "premium" (BUSINESS_RULES.md §2).
    if access in ("premium", "registered"):
        if is_registered:
            return SuccessResponse(
                data={
                    "domain": domain,
                    "slug": slug,
                    "lang": served_lang,
                    "title": parsed["title"],
                    "access": access,
                    "locked": False,
                    "summary": parsed["summary"],
                    "content": parsed["body"],
                    "tags": parsed["tags"],
                    "reading_time_min": _estimate_reading_time(parsed["body"]),
                }
            ).model_dump()

        # Guest → excerpt only + locked
        excerpt = _generate_excerpt(parsed["body"], max_chars=300)
        return SuccessResponse(
            data={
                "domain": domain,
                "slug": slug,
                "lang": served_lang,
                "title": parsed["title"],
                "access": access,
                "locked": True,
                "excerpt": excerpt,
                "register_cta": True,
                "tags": parsed["tags"],
                "reading_time_min": _estimate_reading_time(parsed["body"]),
            }
        ).model_dump()

    # Unknown access type → treat as restricted (same as premium)
    logger.warning(
        "Unknown access type '%s' for guide %s/%s; treating as restricted",
        access, domain, slug,
    )
    if is_registered:
        return SuccessResponse(
            data={
                "domain": domain,
                "slug": slug,
                "lang": served_lang,
                "title": parsed["title"],
                "access": access,
                "locked": False,
                "summary": parsed["summary"],
                "content": parsed["body"],
                "tags": parsed["tags"],
                "reading_time_min": _estimate_reading_time(parsed["body"]),
            }
        ).model_dump()

    excerpt = _generate_excerpt(parsed["body"], max_chars=300)
    return SuccessResponse(
        data={
            "domain": domain,
            "slug": slug,
            "lang": served_lang,
            "title": parsed["title"],
            "access": access,
            "locked": True,
            "excerpt": excerpt,
            "register_cta": True,
            "tags": parsed["tags"],
            "reading_time_min": _estimate_reading_time(parsed["body"]),
        }
    ).model_dump()


@router.get(
    "/api/v1/emergency",
    response_model=SuccessResponse,
)
async def emergency_info() -> dict:
    """Emergency contacts and quick guide — always public, no auth required."""
    emergency_path = _AGENTS_ROOT / "svc-medical" / "workspace" / "guides" / "emergency.md"

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
