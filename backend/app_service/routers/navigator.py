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

from fastapi import APIRouter, HTTPException, status

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


# ── Markdown helpers ───────────────────────────────────────────────────


def _parse_md_file(file_path: Path) -> dict[str, str]:
    """Parse a markdown file — extract title (first # heading) and summary (first paragraph)."""
    try:
        text = file_path.read_text(encoding="utf-8")
    except OSError:
        return {"title": file_path.stem, "summary": "", "content": ""}

    # Title: first line starting with #
    title = file_path.stem.replace("-", " ").title()
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("# "):
            title = stripped.lstrip("# ").strip()
            break

    # Summary: first non-empty, non-heading, non-blockquote paragraph
    summary = ""
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith("#") or stripped.startswith(">"):
            continue
        # Skip horizontal rules
        if re.match(r"^[-*_]{3,}$", stripped):
            continue
        summary = stripped
        break

    return {"title": title, "summary": summary, "content": text}


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
            guide_count = len(list(Path(cfg["knowledge_path"]).glob("*.md")))
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
    """List available guides for a domain."""
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
        guides.append(
            {
                "slug": md_file.stem,
                "title": parsed["title"],
                "summary": parsed["summary"],
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
async def get_guide(domain: str, slug: str) -> dict:
    """Get the full content of a specific guide."""
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
    return SuccessResponse(
        data={
            "domain": domain,
            "slug": slug,
            "title": parsed["title"],
            "summary": parsed["summary"],
            "content": parsed["content"],
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
            "content": parsed["content"],
        }
    ).model_dump()
