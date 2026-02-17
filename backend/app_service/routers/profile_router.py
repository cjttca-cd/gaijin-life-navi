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
    visa_type: str | None = None  # stored in residence_status
    arrival_date: str | None = None  # YYYY-MM-DD


class ProfileOut(BaseModel):
    """Profile data returned to the client."""

    uid: str
    display_name: str
    email: str
    preferred_language: str
    nationality: str | None
    visa_type: str | None  # maps to residence_status
    arrival_date: str | None
    subscription_tier: str
    onboarding_completed: bool
    created_at: str

    model_config = {"from_attributes": True}


# ── Helpers ────────────────────────────────────────────────────────────


def _profile_to_out(profile: Profile) -> dict:
    """Convert a Profile ORM instance to a response dict."""
    return {
        "uid": profile.id,
        "display_name": profile.display_name or "",
        "email": profile.email,
        "preferred_language": profile.preferred_language or "en",
        "nationality": profile.nationality,
        "visa_type": profile.residence_status,
        "arrival_date": profile.arrival_date.isoformat() if profile.arrival_date else None,
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
    if body.visa_type is not None:
        profile.residence_status = body.visa_type
    if body.arrival_date is not None:
        try:
            profile.arrival_date = date.fromisoformat(body.arrival_date)
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail={
                    "error": {
                        "code": "VALIDATION_ERROR",
                        "message": "arrival_date must be YYYY-MM-DD format.",
                        "details": {},
                    }
                },
            )

    profile.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(data=_profile_to_out(profile)).model_dump()
