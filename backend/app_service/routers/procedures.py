"""Admin Procedure Tracker endpoints (API_DESIGN.md — Admin Procedure Tracker).

GET    /api/v1/procedures/templates   — Template list (auth required)
GET    /api/v1/procedures/my          — User's tracked procedures (auth required)
POST   /api/v1/procedures/my          — Add procedure to tracking (Free: max 3)
PATCH  /api/v1/procedures/my/:id      — Update status
DELETE /api/v1/procedures/my/:id      — Soft-delete
"""

import json
import logging
import uuid
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel, Field
from sqlalchemy import select, func as sa_func
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.admin_procedure import AdminProcedure
from models.profile import Profile
from models.user_procedure import UserProcedure
from models.visa_procedure import VisaProcedure
from schemas.common import SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/procedures", tags=["procedures"])

# ── Tier limits (BUSINESS_RULES.md §2) ─────────────────────────────────
FREE_PROCEDURE_LIMIT = 3


# ── Schemas ────────────────────────────────────────────────────────────


class AddProcedureRequest(BaseModel):
    """POST /api/v1/procedures/my request body."""

    procedure_ref_type: str = Field(..., pattern=r"^(admin|visa)$")
    procedure_ref_id: str
    due_date: str | None = None  # YYYY-MM-DD
    notes: str | None = None


class UpdateProcedureRequest(BaseModel):
    """PATCH /api/v1/procedures/my/:id request body."""

    status: str | None = Field(
        default=None, pattern=r"^(not_started|in_progress|completed)$"
    )
    due_date: str | None = None
    notes: str | None = None


# ── Helpers ────────────────────────────────────────────────────────────


def _parse_json(value: str | None):
    if value is None:
        return None
    if isinstance(value, str):
        return json.loads(value)
    return value


def _localize(value: str | None, lang: str) -> str:
    data = _parse_json(value)
    if isinstance(data, dict):
        return data.get(lang, data.get("en", ""))
    return ""


def _template_to_dict(proc: AdminProcedure, lang: str) -> dict:
    return {
        "id": proc.id,
        "procedure_code": proc.procedure_code,
        "procedure_name": _localize(proc.procedure_name, lang),
        "category": proc.category,
        "description": _localize(proc.description, lang),
        "is_arrival_essential": proc.is_arrival_essential,
        "sort_order": proc.sort_order,
        "deadline_rule": _parse_json(proc.deadline_rule),
    }


def _user_procedure_to_dict(up: UserProcedure, title: str = "") -> dict:
    return {
        "id": up.id,
        "procedure_ref_type": up.procedure_ref_type,
        "procedure_ref_id": up.procedure_ref_id,
        "title": title,
        "status": up.status,
        "due_date": str(up.due_date) if up.due_date else None,
        "notes": up.notes,
        "completed_at": up.completed_at.isoformat() if up.completed_at else None,
        "created_at": up.created_at.isoformat() if up.created_at else None,
        "updated_at": up.updated_at.isoformat() if up.updated_at else None,
    }


async def _resolve_procedure_title(
    db: AsyncSession,
    ref_type: str,
    ref_id: str,
    lang: str = "en",
) -> str:
    """Resolve the display title from the referenced procedure."""
    if ref_type == "admin":
        ref = await db.get(AdminProcedure, ref_id)
        if ref:
            return _localize(ref.procedure_name, lang)
    elif ref_type == "visa":
        ref = await db.get(VisaProcedure, ref_id)
        if ref:
            return _localize(ref.title, lang)
    return ""


def _calculate_due_date(deadline_rule: dict | None, arrival_date=None):
    """Calculate due date from deadline_rule (BUSINESS_RULES.md §8)."""
    if deadline_rule is None or arrival_date is None:
        return None
    rule_type = deadline_rule.get("type")
    if rule_type == "within_days_of_arrival":
        days = deadline_rule.get("days", 0)
        return arrival_date + timedelta(days=days)
    return None


# ── Endpoints ──────────────────────────────────────────────────────────


@router.get("/templates")
async def list_templates(
    lang: str = Query(default="en", max_length=5),
    category: str | None = Query(default=None),
    arrival_essential: bool | None = Query(default=None),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Admin procedure template list — auth required."""
    stmt = (
        select(AdminProcedure)
        .where(AdminProcedure.is_active == True)  # noqa: E712
        .order_by(AdminProcedure.sort_order)
    )
    if category:
        stmt = stmt.where(AdminProcedure.category == category)
    if arrival_essential is not None:
        stmt = stmt.where(AdminProcedure.is_arrival_essential == arrival_essential)

    result = await db.execute(stmt)
    templates = result.scalars().all()

    return SuccessResponse(
        data=[_template_to_dict(t, lang) for t in templates]
    ).model_dump()


@router.get("/my")
async def list_my_procedures(
    status_filter: str | None = Query(default=None, alias="status"),
    lang: str = Query(default="en", max_length=5),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """User's tracked procedures — auth required."""
    stmt = (
        select(UserProcedure)
        .where(
            UserProcedure.user_id == current_user.uid,
            UserProcedure.deleted_at == None,  # noqa: E711
        )
        .order_by(UserProcedure.created_at)
    )
    if status_filter:
        stmt = stmt.where(UserProcedure.status == status_filter)

    result = await db.execute(stmt)
    procedures = result.scalars().all()

    # Get user tier for meta
    profile = await db.get(Profile, current_user.uid)
    tier = profile.subscription_tier if profile else "free"
    limit = FREE_PROCEDURE_LIMIT if tier == "free" else None

    # Resolve titles from referenced procedures
    data = []
    for p in procedures:
        title = await _resolve_procedure_title(
            db, p.procedure_ref_type, p.procedure_ref_id, lang
        )
        data.append(_user_procedure_to_dict(p, title=title))

    return SuccessResponse(data=data).model_dump()


@router.post("/my", status_code=status.HTTP_201_CREATED)
async def add_procedure(
    body: AddProcedureRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Add procedure to tracking — Free: max 3 active."""
    # Check profile & tier
    profile = await db.get(Profile, current_user.uid)
    if profile is None or profile.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Profile not found.",
                    "details": {},
                }
            },
        )

    tier = profile.subscription_tier

    # Check Free tier limit (BUSINESS_RULES.md §2)
    if tier == "free":
        count_stmt = (
            select(sa_func.count())
            .select_from(UserProcedure)
            .where(
                UserProcedure.user_id == current_user.uid,
                UserProcedure.deleted_at == None,  # noqa: E711
            )
        )
        count_result = await db.execute(count_stmt)
        current_count = count_result.scalar() or 0
        if current_count >= FREE_PROCEDURE_LIMIT:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail={
                    "error": {
                        "code": "TIER_LIMIT_EXCEEDED",
                        "message": "You have reached the limit for tracked procedures. Upgrade to Premium for unlimited access.",
                        "details": {
                            "feature": "admin_tracker",
                            "current_count": current_count,
                            "limit": FREE_PROCEDURE_LIMIT,
                            "tier": "free",
                            "upgrade_url": "/subscription",
                        },
                    }
                },
            )

    # Resolve preferred language for title
    ref_title = ""

    # Verify referenced procedure exists
    if body.procedure_ref_type == "admin":
        ref = await db.get(AdminProcedure, body.procedure_ref_id)
        if ref is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail={
                    "error": {
                        "code": "NOT_FOUND",
                        "message": "Admin procedure not found.",
                        "details": {},
                    }
                },
            )
        ref_title = _localize(ref.procedure_name, profile.preferred_language or "en")
    elif body.procedure_ref_type == "visa":
        ref = await db.get(VisaProcedure, body.procedure_ref_id)
        if ref is None:
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
        ref_title = _localize(ref.title, profile.preferred_language or "en")

    # Check for duplicate
    dup_stmt = select(UserProcedure).where(
        UserProcedure.user_id == current_user.uid,
        UserProcedure.procedure_ref_type == body.procedure_ref_type,
        UserProcedure.procedure_ref_id == body.procedure_ref_id,
        UserProcedure.deleted_at == None,  # noqa: E711
    )
    dup_result = await db.execute(dup_stmt)
    if dup_result.scalars().first() is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={
                "error": {
                    "code": "CONFLICT",
                    "message": "You are already tracking this procedure.",
                    "details": {},
                }
            },
        )

    # Parse due_date
    due_date = None
    if body.due_date:
        from datetime import date as dt_date

        try:
            due_date = dt_date.fromisoformat(body.due_date)
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail={
                    "error": {
                        "code": "VALIDATION_ERROR",
                        "message": "Invalid date format. Use YYYY-MM-DD.",
                        "details": {"field": "due_date"},
                    }
                },
            )

    up = UserProcedure(
        id=str(uuid.uuid4()),
        user_id=current_user.uid,
        procedure_ref_type=body.procedure_ref_type,
        procedure_ref_id=body.procedure_ref_id,
        status="not_started",
        due_date=due_date,
        notes=body.notes,
    )
    db.add(up)
    await db.flush()

    return SuccessResponse(
        data=_user_procedure_to_dict(up, title=ref_title)
    ).model_dump()


@router.patch("/my/{procedure_id}")
async def update_procedure(
    procedure_id: str,
    body: UpdateProcedureRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Update tracked procedure status/due_date/notes."""
    up = await db.get(UserProcedure, procedure_id)
    if up is None or up.deleted_at is not None or up.user_id != current_user.uid:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Tracked procedure not found.",
                    "details": {},
                }
            },
        )

    now = datetime.now(timezone.utc)

    if body.status is not None:
        up.status = body.status
        # BUSINESS_RULES.md §8: set completed_at when completed
        if body.status == "completed":
            up.completed_at = now
        else:
            up.completed_at = None

    if body.due_date is not None:
        from datetime import date as dt_date

        try:
            up.due_date = dt_date.fromisoformat(body.due_date)
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail={
                    "error": {
                        "code": "VALIDATION_ERROR",
                        "message": "Invalid date format. Use YYYY-MM-DD.",
                        "details": {"field": "due_date"},
                    }
                },
            )

    if body.notes is not None:
        up.notes = body.notes

    up.updated_at = now
    await db.flush()

    title = await _resolve_procedure_title(
        db, up.procedure_ref_type, up.procedure_ref_id
    )
    return SuccessResponse(
        data=_user_procedure_to_dict(up, title=title)
    ).model_dump()


@router.delete("/my/{procedure_id}")
async def delete_procedure(
    procedure_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Soft-delete a tracked procedure."""
    up = await db.get(UserProcedure, procedure_id)
    if up is None or up.deleted_at is not None or up.user_id != current_user.uid:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Tracked procedure not found.",
                    "details": {},
                }
            },
        )

    up.deleted_at = datetime.now(timezone.utc)
    up.updated_at = up.deleted_at
    await db.flush()

    return SuccessResponse(data={"message": "Procedure tracking removed."}).model_dump()
