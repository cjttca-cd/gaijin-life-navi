"""Auth endpoints (API_DESIGN.md — Auth section).

POST /api/v1/auth/register   — Create profile after Firebase Auth sign-up
POST /api/v1/auth/delete-account — Soft-delete profile + delete Firebase account
"""

import logging
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.profile import Profile
from schemas.auth import RegisterRequest, RegisterResponse, UserInRegisterResponse
from schemas.common import ErrorResponse, SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/auth", tags=["auth"])


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
    """Soft-delete the user profile and delete the Firebase Auth account.

    Processing:
    1. Set profiles.deleted_at
    2. (Future) Cancel Stripe subscription if active
    3. Delete Firebase Auth account via Admin SDK
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

    # Soft-delete
    profile.deleted_at = datetime.now(timezone.utc)
    await db.flush()

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
