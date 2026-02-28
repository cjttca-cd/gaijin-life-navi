"""Usage & Plan endpoints.

GET  /api/v1/usage  — Current usage stats (auth required)
GET  /api/v1/plans  — Available subscription plans (public)
"""

import logging
from datetime import datetime, timezone

from fastapi import APIRouter, Depends
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
            "ai_queries_limit": 20,
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
    # Determine tier — anonymous Firebase users are "guest"
    if current_user.is_anonymous:
        tier = "guest"
    else:
        profile = await db.get(Profile, current_user.uid)
        if profile is None or profile.deleted_at is not None:
            tier = "free"
        else:
            tier = profile.subscription_tier or "free"

    # Plan C tier limits (SSOT: BUSINESS_RULES.md §2)
    tier_limits = {
        "guest": {"limit": 5, "period": "lifetime"},
        "free": {"limit": 10, "period": "lifetime"},
        "standard": {"limit": 300, "period": "month"},
        "premium": {"limit": None, "period": None},
        "premium_plus": {"limit": None, "period": None},
    }
    limits = tier_limits.get(tier, tier_limits["free"])
    period = limits["period"]
    limit = limits["limit"]

    # Today's usage
    today = datetime.now(timezone.utc).date()
    usage_stmt = select(DailyUsage).where(
        DailyUsage.user_id == current_user.uid,
        DailyUsage.usage_date == today,
    )
    result = await db.execute(usage_stmt)
    daily = result.scalars().first()
    queries_used_today = daily.chat_count if daily else 0

    # Compute lifetime total
    from sqlalchemy import func as sqlfunc
    lifetime_stmt = (
        select(sqlfunc.coalesce(sqlfunc.sum(DailyUsage.chat_count), 0))
        .where(DailyUsage.user_id == current_user.uid)
    )
    lifetime_result = await db.execute(lifetime_stmt)
    lifetime_total = lifetime_result.scalar_one()

    # Compute monthly total (for month-based tiers)
    first_of_month = today.replace(day=1)
    monthly_stmt = (
        select(sqlfunc.coalesce(sqlfunc.sum(DailyUsage.chat_count), 0))
        .where(
            DailyUsage.user_id == current_user.uid,
            DailyUsage.usage_date >= first_of_month,
            DailyUsage.usage_date <= today,
        )
    )
    monthly_result = await db.execute(monthly_stmt)
    monthly_total = monthly_result.scalar_one()

    # Pick used count based on period
    if period == "lifetime":
        used = lifetime_total
    elif period == "month":
        used = monthly_total
    else:
        used = monthly_total  # unlimited — report monthly for info

    remaining = (limit - used) if limit is not None else None

    return SuccessResponse(
        data={
            "tier": tier,
            "used": used,
            "limit": limit,
            "period": period,
            "remaining": remaining,
            "queries_used_today": queries_used_today,
        }
    ).model_dump()
