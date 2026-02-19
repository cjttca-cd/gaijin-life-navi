"""Profile endpoints (simplified for Phase 0).

GET  /api/v1/profile  — Get authenticated user's profile
PUT  /api/v1/profile  — Update profile
"""

import logging
from datetime import date, datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.profile import Profile
from schemas.common import ErrorResponse, SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(tags=["profile"])


# ── Request / response schemas ─────────────────────────────────────────


class ProfileUpdate(BaseModel):
    """Fields the user can update on their profile."""

    display_name: str | None = None
    preferred_language: str | None = None  # en, zh, ja, ko, vi, etc.
    nationality: str | None = None
    residence_status: str | None = None
    visa_expiry: str | None = None  # YYYY-MM-DD


class ProfileOut(BaseModel):
    """Profile data returned to the client.

    Field names unified with /users/me (ProfileResponse) for consistency:
      uid → id, visa_type → residence_status.
    """

    id: str
    display_name: str
    email: str
    preferred_language: str | None
    nationality: str | None
    residence_status: str | None
    visa_expiry: str | None
    subscription_tier: str
    onboarding_completed: bool
    created_at: str

    model_config = {"from_attributes": True}


# ── Helpers ────────────────────────────────────────────────────────────


def _profile_to_out(profile: Profile) -> dict:
    """Convert a Profile ORM instance to a response dict.

    Field names unified with /users/me (ProfileResponse):
      uid → id, visa_type → residence_status.
    """
    return {
        "id": profile.id,
        "display_name": profile.display_name or "",
        "email": profile.email,
        "preferred_language": profile.preferred_language,
        "nationality": profile.nationality,
        "residence_status": profile.residence_status,
        "visa_expiry": profile.visa_expiry.isoformat() if profile.visa_expiry else None,
        "subscription_tier": profile.subscription_tier or "free",
        "onboarding_completed": profile.onboarding_completed,
        "created_at": profile.created_at.isoformat() if profile.created_at else None,
    }


async def _get_or_create_profile(user: FirebaseUser, db: AsyncSession) -> Profile:
    """Get existing profile or create a minimal one for the Firebase user."""
    profile = await db.get(Profile, user.uid)
    if profile is not None and profile.deleted_at is None:
        return profile

    # Auto-create profile on first access
    profile = Profile(
        id=user.uid,
        email=user.email,
        display_name=user.name or "",
        preferred_language="en",
    )
    db.add(profile)
    await db.flush()

    # #30: Abuse prevention — if a soft-deleted profile with the same
    # email exists, exhaust the free-tier chat allowance so the
    # re-registering user does not get another 20 free chats.
    if user.email:
        from sqlalchemy import select as sa_select
        prev_deleted = await db.execute(
            sa_select(Profile).where(
                Profile.email == user.email,
                Profile.id != user.uid,
                Profile.deleted_at.isnot(None),
            )
        )
        if prev_deleted.scalars().first() is not None:
            import uuid as _uuid
            from models.daily_usage import DailyUsage
            exhaustion_record = DailyUsage(
                id=str(_uuid.uuid4()),
                user_id=user.uid,
                usage_date=date.today(),
                chat_count=20,  # exhaust free-tier 20 lifetime chats
                scan_count_monthly=0,
            )
            db.add(exhaustion_record)
            await db.flush()
            logger.warning(
                "Re-registration detected for email=%s (new uid=%s). "
                "Free-tier chats exhausted.",
                user.email,
                user.uid,
            )

    return profile


# ── Endpoints ──────────────────────────────────────────────────────────


@router.get(
    "/api/v1/profile",
    response_model=SuccessResponse,
    responses={401: {"model": ErrorResponse}},
)
async def get_profile(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Get the authenticated user's profile."""
    profile = await _get_or_create_profile(current_user, db)
    return SuccessResponse(data=_profile_to_out(profile)).model_dump()


@router.put(
    "/api/v1/profile",
    response_model=SuccessResponse,
    responses={401: {"model": ErrorResponse}},
)
async def update_profile(
    body: ProfileUpdate,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Update the authenticated user's profile."""
    profile = await _get_or_create_profile(current_user, db)

    if body.display_name is not None:
        profile.display_name = body.display_name
    if body.preferred_language is not None:
        profile.preferred_language = body.preferred_language
    if body.nationality is not None:
        profile.nationality = body.nationality
    if body.residence_status is not None:
        profile.residence_status = body.residence_status
    if body.visa_expiry is not None:
        try:
            profile.visa_expiry = date.fromisoformat(body.visa_expiry)
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail={
                    "error": {
                        "code": "VALIDATION_ERROR",
                        "message": "visa_expiry must be YYYY-MM-DD format.",
                        "details": {},
                    }
                },
            )

    profile.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(data=_profile_to_out(profile)).model_dump()
