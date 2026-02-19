"""Auth endpoints (API_DESIGN.md — Auth section).

POST /api/v1/auth/register   — Create profile after Firebase Auth sign-up
POST /api/v1/auth/delete-account — Soft-delete profile + cancel subscription + delete Firebase account
"""

import logging
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.profile import Profile
from models.subscription import Subscription
from schemas.auth import RegisterRequest, RegisterResponse, UserInRegisterResponse
from schemas.common import ErrorResponse, SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/auth", tags=["auth"])


@router.get(
    "/me",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def get_me(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Return the authenticated user's profile (same as /users/me)."""
    from schemas.users import ProfileResponse as PR

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
    return SuccessResponse(
        data=PR.model_validate(profile).model_dump()
    ).model_dump()


@router.post(
    "/register",
    response_model=SuccessResponse,
    status_code=status.HTTP_201_CREATED,
    responses={409: {"model": ErrorResponse}},
)
async def register(
    body: RegisterRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Create a new user profile from Firebase ID Token.

    The client calls this immediately after Firebase Auth sign-up.
    """
    # Check if profile already exists
    existing = await db.get(Profile, current_user.uid)
    if existing is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={
                "error": {
                    "code": "CONFLICT",
                    "message": "Profile already exists for this account.",
                    "details": {},
                }
            },
        )

    profile = Profile(
        id=current_user.uid,
        email=current_user.email,
        display_name=body.display_name or current_user.name or "",
        preferred_language=body.preferred_language,
    )
    db.add(profile)
    await db.flush()

    # #30: Abuse prevention — if a soft-deleted profile with the same
    # email exists, exhaust the free-tier chat allowance so the
    # re-registering user does not get another 20 free chats.
    if current_user.email:
        prev_deleted = await db.execute(
            select(Profile).where(
                Profile.email == current_user.email,
                Profile.id != current_user.uid,
                Profile.deleted_at.isnot(None),
            )
        )
        if prev_deleted.scalars().first() is not None:
            import uuid as _uuid
            from datetime import date

            from models.daily_usage import DailyUsage
            exhaustion_record = DailyUsage(
                id=str(_uuid.uuid4()),
                user_id=current_user.uid,
                usage_date=date.today(),
                chat_count=20,  # exhaust free-tier 20 lifetime chats
                scan_count_monthly=0,
            )
            db.add(exhaustion_record)
            await db.flush()
            logger.warning(
                "Re-registration detected for email=%s (new uid=%s). "
                "Free-tier chats exhausted.",
                current_user.email,
                current_user.uid,
            )

    user_data = UserInRegisterResponse(
        id=profile.id,
        email=profile.email,
        display_name=profile.display_name,
        preferred_language=profile.preferred_language,
        subscription_tier=profile.subscription_tier,
        onboarding_completed=profile.onboarding_completed,
    )

    return SuccessResponse(data=RegisterResponse(user=user_data)).model_dump()


@router.post(
    "/delete-account",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def delete_account(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Soft-delete the user profile, cancel Stripe subscription, and delete Firebase Auth account.

    Processing (per API_DESIGN.md):
    1. Set profiles.deleted_at
    2. If active subscription exists → set cancel_at_period_end=true
    3. Delete Firebase Auth account via Admin SDK (best-effort)
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

    # Soft-delete profile
    profile.deleted_at = now
    await db.flush()

    # Cancel subscription if active (BUSINESS_RULES.md §9)
    sub_stmt = select(Subscription).where(
        Subscription.user_id == current_user.uid,
    )
    sub_result = await db.execute(sub_stmt)
    sub = sub_result.scalars().first()

    if sub and sub.status in ("active", "past_due"):
        sub.cancel_at_period_end = True
        sub.cancelled_at = now
        sub.updated_at = now
        await db.flush()

        # Attempt Stripe API cancel (best-effort)
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

    # Attempt to delete Firebase Auth account (best-effort)
    try:
        from config import settings as _s

        if _s.FIREBASE_CREDENTIALS:
            from firebase_admin import auth as fb_auth  # type: ignore[import-untyped]

            fb_auth.delete_user(current_user.uid)
    except Exception:
        # Log but do not fail — profile is already soft-deleted
        logger.exception("Failed to delete Firebase Auth account (non-fatal).")

    return SuccessResponse(data={"message": "Account deleted"}).model_dump()
