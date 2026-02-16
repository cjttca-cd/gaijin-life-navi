"""User profile endpoints (API_DESIGN.md — User Profile section).

GET   /api/v1/users/me            — Get current user profile
PATCH /api/v1/users/me            — Update profile
POST  /api/v1/users/me/onboarding — Complete onboarding
"""

import json
import logging
import uuid
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.admin_procedure import AdminProcedure
from models.profile import Profile
from models.user_procedure import UserProcedure
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

    # Auto-add essential admin procedures to user_procedures (BUSINESS_RULES.md §8)
    essential_stmt = (
        select(AdminProcedure)
        .where(
            AdminProcedure.is_arrival_essential == True,  # noqa: E712
            AdminProcedure.is_active == True,  # noqa: E712
        )
        .order_by(AdminProcedure.sort_order)
    )
    essential_result = await db.execute(essential_stmt)
    essential_procedures = essential_result.scalars().all()

    for proc in essential_procedures:
        # Skip if already tracking
        existing_stmt = select(UserProcedure).where(
            UserProcedure.user_id == current_user.uid,
            UserProcedure.procedure_ref_type == "admin",
            UserProcedure.procedure_ref_id == proc.id,
            UserProcedure.deleted_at == None,  # noqa: E711
        )
        existing_result = await db.execute(existing_stmt)
        if existing_result.scalars().first() is not None:
            continue

        # Calculate due_date from deadline_rule
        due_date = None
        if proc.deadline_rule and profile.arrival_date:
            try:
                rule = json.loads(proc.deadline_rule) if isinstance(proc.deadline_rule, str) else proc.deadline_rule
                if rule.get("type") == "within_days_of_arrival":
                    due_date = profile.arrival_date + timedelta(days=rule.get("days", 0))
            except (json.JSONDecodeError, TypeError):
                pass

        up = UserProcedure(
            id=str(uuid.uuid4()),
            user_id=current_user.uid,
            procedure_ref_type="admin",
            procedure_ref_id=proc.id,
            status="not_started",
            due_date=due_date,
        )
        db.add(up)

    await db.flush()

    return SuccessResponse(
        data=ProfileResponse.model_validate(profile).model_dump()
    ).model_dump()
