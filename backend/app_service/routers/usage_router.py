"""Usage & Plan & Credits endpoints.

GET  /api/v1/usage           — Current usage stats (auth required)
GET  /api/v1/plans           — Available subscription plans (public)
GET  /api/v1/credits/balance — Credit balance by source (auth required)
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
from services.credits import get_balance

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
            "ai_queries_limit": 10,
            "ai_queries_period": "lifetime",
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
    "/api/v1/credits/balance",
    response_model=SuccessResponse,
    responses={404: {"model": ErrorResponse}},
)
async def get_credit_balance(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Get credit balance breakdown by source for the authenticated user."""
    # Determine tier
    if current_user.is_anonymous:
        tier = "guest"
    else:
        profile = await db.get(Profile, current_user.uid)
        if profile is None or profile.deleted_at is not None:
            tier = "free"
        else:
            tier = profile.subscription_tier or "free"

    balance = await get_balance(db, current_user.uid)

    # Format expiry dates
    def _fmt_dt(dt: datetime | None) -> str | None:
        if dt is None:
            return None
        return dt.isoformat().replace("+00:00", "Z") if dt.tzinfo else dt.isoformat() + "Z"

    # Find next expiry across all sources
    expiries = [
        dt
        for dt in [
            balance.subscription_expires_at,
            balance.grant_expires_at,
            balance.purchase_expires_at,
        ]
        if dt is not None
    ]
    next_expiry = min(expiries) if expiries else None

    return SuccessResponse(
        data={
            "total_remaining": balance.total_remaining,
            "breakdown": {
                "subscription": {
                    "remaining": balance.subscription_remaining,
                    "expires_at": _fmt_dt(balance.subscription_expires_at),
                },
                "grant": {
                    "remaining": balance.grant_remaining,
                    "expires_at": _fmt_dt(balance.grant_expires_at),
                },
                "purchase": {
                    "remaining": balance.purchase_remaining,
                    "expires_at": _fmt_dt(balance.purchase_expires_at),
                },
            },
            "next_expiry": _fmt_dt(next_expiry),
            "tier": tier,
        }
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
    """Get current usage stats for the authenticated user.

    Now includes credit balance information alongside legacy usage data.
    """
    # Determine tier — anonymous Firebase users are "guest"
    if current_user.is_anonymous:
        tier = "guest"
    else:
        profile = await db.get(Profile, current_user.uid)
        if profile is None or profile.deleted_at is not None:
            tier = "free"
        else:
            tier = profile.subscription_tier or "free"

    # Get credit balance
    balance = await get_balance(db, current_user.uid)

    # Today's usage (analytics)
    today = datetime.now(timezone.utc).date()
    usage_stmt = select(DailyUsage).where(
        DailyUsage.user_id == current_user.uid,
        DailyUsage.usage_date == today,
    )
    result = await db.execute(usage_stmt)
    daily = result.scalars().first()
    queries_used_today = daily.deep_count if daily else 0

    # For premium users, remaining is unlimited
    if tier in ("premium", "premium_plus"):
        remaining = None
        limit = None
        period = None
    else:
        remaining = balance.total_remaining
        limit = balance.total_remaining  # Dynamic based on credits
        period = None  # Credit system doesn't use period

    return SuccessResponse(
        data={
            "tier": tier,
            "used": 0,  # Not meaningful in credit system
            "limit": limit,
            "period": period,
            "remaining": remaining,
            "queries_used_today": queries_used_today,
            # Credit-specific fields
            "credits": {
                "total_remaining": balance.total_remaining,
                "subscription": balance.subscription_remaining,
                "grant": balance.grant_remaining,
                "purchase": balance.purchase_remaining,
            },
        }
    ).model_dump()
