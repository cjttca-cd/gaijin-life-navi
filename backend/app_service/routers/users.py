"""User profile endpoints (API_DESIGN.md — User Profile section).

GET    /api/v1/users/me            — Get current user profile
PATCH  /api/v1/users/me            — Update profile
DELETE /api/v1/users/me            — Soft-delete account + cancel subscription
POST   /api/v1/users/me/onboarding — Complete onboarding
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
from models.subscription import Subscription
from models.user_procedure import UserProcedure
from schemas.common import ErrorResponse, SuccessResponse
from schemas.users import OnboardingRequest, ProfileResponse, UpdateProfileRequest
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/users", tags=["users"])


async def _get_active_profile(
    user_id: str, db: AsyncSession, *, user: FirebaseUser | None = None
) -> Profile:
    """Fetch profile or auto-create on first access. Excludes soft-deleted records."""
    profile = await db.get(Profile, user_id)
    if profile is not None and profile.deleted_at is not None:
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
    if profile is None:
        # Auto-create profile on first access (consistent with /profile endpoint)
        profile = Profile(
            id=user_id,
            email=user.email if user else "",
            display_name=user.name if user else "",
            preferred_language="en",
        )
        db.add(profile)
        await db.flush()
        logger.info("Auto-created profile for user %s", user_id)

        # #30: Abuse prevention — if a soft-deleted profile with the same
        # email exists, exhaust the free-tier chat allowance so the
        # re-registering user does not get another 20 free chats.
        email = user.email if user else ""
        if email:
            prev_deleted = await db.execute(
                select(Profile).where(
                    Profile.email == email,
                    Profile.id != user_id,
                    Profile.deleted_at.isnot(None),
                )
            )
            if prev_deleted.scalars().first() is not None:
                from models.daily_usage import DailyUsage
                exhaustion_record = DailyUsage(
                    id=str(uuid.uuid4()),
                    user_id=user_id,
                    usage_date=datetime.now(timezone.utc).date(),
                    chat_count=20,  # exhaust free-tier 20 lifetime chats
                    scan_count_monthly=0,
                )
                db.add(exhaustion_record)
                await db.flush()
                logger.warning(
                    "Re-registration detected for email=%s (new uid=%s). "
                    "Free-tier chats exhausted.",
                    email,
                    user_id,
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
    profile = await _get_active_profile(current_user.uid, db, user=current_user)
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
    profile = await _get_active_profile(current_user.uid, db, user=current_user)

    update_data = body.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(profile, field, value)

    profile.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(
        data=ProfileResponse.model_validate(profile).model_dump()
    ).model_dump()


@router.delete(
    "/me",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def delete_me(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Soft-delete the user profile and cancel subscription.

    Processing:
    1. Set profiles.deleted_at
    2. If active subscription → set cancel_at_period_end=true
    3. Delete Firebase Auth account (best-effort)
    """
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

    now = datetime.now(timezone.utc)
    profile.deleted_at = now
    await db.flush()

    # Cancel active subscription
    sub_stmt = select(Subscription).where(Subscription.user_id == current_user.uid)
    sub_result = await db.execute(sub_stmt)
    sub = sub_result.scalars().first()

    if sub and sub.status in ("active", "past_due"):
        sub.cancel_at_period_end = True
        sub.cancelled_at = now
        sub.updated_at = now
        await db.flush()

        try:
            from config import settings as _s

            if _s.STRIPE_SECRET_KEY and sub.stripe_subscription_id:
                import stripe

                stripe.api_key = _s.STRIPE_SECRET_KEY
                stripe.Subscription.modify(
                    sub.stripe_subscription_id,
                    cancel_at_period_end=True,
                )
        except Exception:
            logger.exception("Failed to cancel Stripe subscription (non-fatal).")

    # Delete Firebase Auth account (best-effort)
    try:
        from config import settings as _s

        if _s.FIREBASE_CREDENTIALS:
            from firebase_admin import auth as fb_auth  # type: ignore[import-untyped]

            fb_auth.delete_user(current_user.uid)
    except Exception:
        logger.exception("Failed to delete Firebase Auth account (non-fatal).")

    return SuccessResponse(data={"message": "Account deleted"}).model_dump()


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
    profile = await _get_active_profile(current_user.uid, db, user=current_user)

    # Update profile fields
    if body.nationality is not None:
        profile.nationality = body.nationality
    if body.residence_status is not None:
        profile.residence_status = body.residence_status
    if body.residence_region is not None:
        profile.residence_region = body.residence_region
    if body.visa_expiry is not None:
        profile.visa_expiry = body.visa_expiry
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
        if proc.deadline_rule:
            try:
                rule = json.loads(proc.deadline_rule) if isinstance(proc.deadline_rule, str) else proc.deadline_rule
                if rule.get("type") == "within_days_of_arrival":
                    # arrival_date no longer tracked; use today as fallback
                    due_date = datetime.now(timezone.utc).date() + timedelta(days=rule.get("days", 0))
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
