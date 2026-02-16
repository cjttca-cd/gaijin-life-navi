"""Visa Navigator endpoints (API_DESIGN.md — Visa Navigator).

GET /api/v1/visa/procedures          — Procedure list (auth required)
GET /api/v1/visa/procedures/:id      — Procedure detail (auth required, tier-gated)
"""

import json
import logging

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.profile import Profile
from models.visa_procedure import VisaProcedure
from schemas.common import SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/visa", tags=["visa"])

# ── Disclaimer (BUSINESS_RULES.md §6 — mandatory) ─────────────────────

VISA_DISCLAIMER = (
    "IMPORTANT: This is general information about visa procedures and does not "
    "constitute immigration advice. Immigration laws and procedures may change. "
    "Always consult the Immigration Services Agency or a qualified immigration "
    "lawyer (行政書士) for your specific situation."
)


# ── Helpers ────────────────────────────────────────────────────────────


def _parse_json(value: str | None) -> dict | list | None:
    if value is None:
        return None
    if isinstance(value, str):
        return json.loads(value)
    return value


def _localize_json(value: str | None, lang: str) -> str:
    """Extract lang key from a JSONB multilingual field."""
    data = _parse_json(value)
    if isinstance(data, dict):
        return data.get(lang, data.get("en", ""))
    return ""


def _localize_doc_list(value: str | None, lang: str) -> list[dict]:
    """Localize required_documents list entries."""
    data = _parse_json(value)
    if not isinstance(data, list):
        return []
    result = []
    for item in data:
        if isinstance(item, dict):
            localized = {}
            for k, v in item.items():
                if isinstance(v, dict):
                    localized[k] = v.get(lang, v.get("en", ""))
                else:
                    localized[k] = v
            result.append(localized)
        else:
            result.append(item)
    return result


def _localize_steps(value: str | None, lang: str) -> list[dict]:
    """Localize steps list entries."""
    data = _parse_json(value)
    if not isinstance(data, list):
        return []
    result = []
    for step in data:
        if isinstance(step, dict):
            localized = {}
            for k, v in step.items():
                if isinstance(v, dict):
                    localized[k] = v.get(lang, v.get("en", ""))
                else:
                    localized[k] = v
            result.append(localized)
        else:
            result.append(step)
    return result


def _procedure_basic(proc: VisaProcedure, lang: str) -> dict:
    """Basic procedure info (visible to all tiers)."""
    return {
        "id": proc.id,
        "procedure_type": proc.procedure_type,
        "title": _localize_json(proc.title, lang),
        "description": _localize_json(proc.description, lang),
        "estimated_duration": proc.estimated_duration,
        "applicable_statuses": _parse_json(proc.applicable_statuses) or [],
        "sort_order": proc.sort_order,
    }


def _procedure_full(proc: VisaProcedure, lang: str) -> dict:
    """Full procedure info (Premium/Premium+)."""
    data = _procedure_basic(proc, lang)
    data["required_documents"] = _localize_doc_list(proc.required_documents, lang)
    data["steps"] = _localize_steps(proc.steps, lang)
    data["fees"] = _parse_json(proc.fees)
    data["deadline_rule"] = _parse_json(proc.deadline_rule)
    data["tips"] = _localize_json(proc.tips, lang) if proc.tips else None
    return data


# ── Endpoints ──────────────────────────────────────────────────────────


@router.get("/procedures")
async def list_procedures(
    lang: str = Query(default="en", max_length=5),
    status_filter: str | None = Query(default=None, alias="status"),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Visa procedure list — auth required."""
    stmt = (
        select(VisaProcedure)
        .where(VisaProcedure.is_active == True)  # noqa: E712
        .order_by(VisaProcedure.sort_order)
    )
    result = await db.execute(stmt)
    procedures = result.scalars().all()

    # Optional filter by applicable residence status
    if status_filter:
        procedures = [
            p
            for p in procedures
            if status_filter in (p.get_applicable_statuses())
        ]

    return SuccessResponse(
        data=[_procedure_basic(p, lang) for p in procedures],
    ).model_dump()


@router.get("/procedures/{procedure_id}")
async def get_procedure(
    procedure_id: str,
    lang: str = Query(default="en", max_length=5),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Visa procedure detail — Free=basic, Premium=full, disclaimer always."""
    proc = await db.get(VisaProcedure, procedure_id)
    if proc is None or not proc.is_active:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Visa procedure not found.",
                    "details": {},
                }
            },
        )

    # Check user tier
    profile = await db.get(Profile, current_user.uid)
    tier = profile.subscription_tier if profile else "free"

    if tier in ("premium", "premium_plus"):
        data = _procedure_full(proc, lang)
    else:
        data = _procedure_basic(proc, lang)

    data["disclaimer"] = VISA_DISCLAIMER

    return SuccessResponse(data=data).model_dump()
