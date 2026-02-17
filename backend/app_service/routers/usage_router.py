"""Usage & Plan endpoints.

GET  /api/v1/usage  — Current usage stats (auth required)
GET  /api/v1/plans  — Available subscription plans (public)
"""

import logging
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.daily_usage import DailyUsage
from models.profile import Profile
from schemas.common import ErrorResponse, SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(tags=["usage"])

# ── Plan definitions (PHASE0_DESIGN.md) ────────────────────────────────

PLANS = [
    {
        "id": "free",
        "name": "Free",
        "price": 0,
        "currency": "JPY",
        "billing_period": None,
        "features": {
            "ai_queries_limit": 5,
            "ai_queries_period": "day",
            "tracker_items": 3,
            "ads": True,
            "priority_support": False,
        },
    },
    {
        "id": "standard",
        "name": "Standard",
        "price": 720,
        "currency": "JPY",
        "billing_period": "month",
        "features": {
            "ai_queries_limit": 300,
            "ai_queries_period": "month",
            "tracker_items": -1,  # unlimited
            "ads": False,
            "priority_support": False,
        },
    },
    {
        "id": "premium",
        "name": "Premium",
        "price": 1360,
        "currency": "JPY",
        "billing_period": "month",
        "features": {
            "ai_queries_limit": -1,  # unlimited
            "ai_queries_period": "month",
            "tracker_items": -1,
            "ads": False,
            "priority_support": True,
        },
    },
]

CHARGE_PACKS = [
    {
        "id": "pack_100",
        "name": "100 AI Queries",
        "queries": 100,
        "price": 360,
        "currency": "JPY",
    },
    {
        "id": "pack_50",
        "name": "50 AI Queries",
        "queries": 50,
        "price": 180,
        "currency": "JPY",
    },
]


# ── Endpoints ──────────────────────────────────────────────────────────


@router.get(
    "/api/v1/plans",
    response_model=SuccessResponse,
)
async def list_plans() -> dict:
    """List available subscription plans and charge packs. Public, no auth."""
    return SuccessResponse(
        data={"plans": PLANS, "charge_packs": CHARGE_PACKS}
    ).model_dump()


@router.get(
    "/api/v1/usage",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def get_usage(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Get current usage stats for the authenticated user."""
    # Fetch profile for subscription tier
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

    tier = profile.subscription_tier or "free"

    # Today's usage
    today = datetime.now(timezone.utc).date()
    usage_stmt = select(DailyUsage).where(
        DailyUsage.user_id == current_user.uid,
        DailyUsage.usage_date == today,
    )
    result = await db.execute(usage_stmt)
    daily = result.scalars().first()

    queries_used_today = daily.chat_count if daily else 0

    # Determine limit from tier
    tier_limits = {
        "free": {"daily_limit": 5, "monthly_limit": None},
        "standard": {"daily_limit": None, "monthly_limit": 300},
        "premium": {"daily_limit": None, "monthly_limit": None},
    }
    limits = tier_limits.get(tier, tier_limits["free"])

    return SuccessResponse(
        data={
            "tier": tier,
            "queries_used_today": queries_used_today,
            "daily_limit": limits["daily_limit"],
            "monthly_limit": limits["monthly_limit"],
        }
    ).model_dump()
