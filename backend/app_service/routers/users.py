"""User profile endpoints (API_DESIGN.md — User Profile section).

GET   /api/v1/users/me            — Get current user profile
PATCH /api/v1/users/me            — Update profile
POST  /api/v1/users/me/onboarding — Complete onboarding
"""

import logging
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.profile import Profile
from schemas.common import ErrorResponse, SuccessResponse
from schemas.users import OnboardingRequest, ProfileResponse, UpdateProfileRequest
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/users", tags=["users"])


async def _get_active_profile(
    user_id: str, db: AsyncSession
) -> Profile:
    """Fetch profile or raise 404. Excludes soft-deleted records."""
    profile = await db.get(Profile, user_id)
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
    return profile


@router.get(
    "/me",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def get_me(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Return the authenticated user's profile."""
    profile = await _get_active_profile(current_user.uid, db)
    return SuccessResponse(
        data=ProfileResponse.model_validate(profile).model_dump()
    ).model_dump()


@router.patch(
    "/me",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}, 422: {"model": ErrorResponse}},
)
async def update_me(
    body: UpdateProfileRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Update the authenticated user's profile (partial update)."""
    profile = await _get_active_profile(current_user.uid, db)

    update_data = body.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(profile, field, value)

    profile.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(
        data=ProfileResponse.model_validate(profile).model_dump()
    ).model_dump()


@router.post(
    "/me/onboarding",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def complete_onboarding(
    body: OnboardingRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Complete onboarding — update profile fields and set onboarding_completed=True.

    Processing (per BUSINESS_RULES.md §8):
    1. Update profile fields from request body
    2. Set onboarding_completed = True
    3. (Future) Auto-add 5 essential admin procedures to user_procedures
    """
    profile = await _get_active_profile(current_user.uid, db)

    # Update profile fields
    if body.nationality is not None:
        profile.nationality = body.nationality
    if body.residence_status is not None:
        profile.residence_status = body.residence_status
    if body.residence_region is not None:
        profile.residence_region = body.residence_region
    if body.arrival_date is not None:
        profile.arrival_date = body.arrival_date
    profile.preferred_language = body.preferred_language
    profile.onboarding_completed = True
    profile.updated_at = datetime.now(timezone.utc)
    await db.flush()

    # TODO: Auto-add 5 essential admin procedures to user_procedures
    # (resident_registration, address_update, health_insurance,
    #  national_pension, bank_account)
    # This requires admin_procedures + user_procedures tables which are
    # not in the MVP scaffold scope.

    return SuccessResponse(
        data=ProfileResponse.model_validate(profile).model_dump()
    ).model_dump()
