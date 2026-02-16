"""Subscription endpoints (API_DESIGN.md — Subscription).

GET  /api/v1/subscriptions/plans    — Plan list (no auth)
POST /api/v1/subscriptions/checkout — Stripe Checkout session create
GET  /api/v1/subscriptions/me       — Current subscription status
POST /api/v1/subscriptions/cancel   — Cancel subscription (period end)
POST /api/v1/subscriptions/webhook  — Stripe webhook handler

BUSINESS_RULES.md §9:
  - subscription_tier update ONLY via webhook (SSOT)
  - cancel → cancel_at_period_end = true
  - Stripe mock mode when STRIPE_SECRET_KEY not set
"""

import json
import logging
import uuid
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, Request, status
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from config import settings
from database import get_db
from models.profile import Profile
from models.subscription import Subscription
from schemas.common import SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/subscriptions", tags=["subscriptions"])

# ── Mock mode detection ────────────────────────────────────────────────

_mock_mode = not bool(settings.STRIPE_SECRET_KEY)

if _mock_mode:
    logger.warning("STRIPE_SECRET_KEY not set — running in Stripe MOCK mode.")


# ── Plan definitions ───────────────────────────────────────────────────

PLANS = [
    {
        "id": "premium_monthly",
        "name": "Premium",
        "price": 500,
        "currency": "jpy",
        "interval": "month",
        "stripe_price_id": settings.STRIPE_PREMIUM_PRICE_ID,
        "tier": "premium",
        "features": [
            "Unlimited AI chat",
            "30 document scans/month",
            "Community Q&A posting",
            "Visa Navigator personalisation",
            "No ads",
        ],
    },
    {
        "id": "premium_plus_monthly",
        "name": "Premium+",
        "price": 1500,
        "currency": "jpy",
        "interval": "month",
        "stripe_price_id": settings.STRIPE_PREMIUM_PLUS_PRICE_ID,
        "tier": "premium_plus",
        "features": [
            "Everything in Premium",
            "Unlimited document scans",
            "Priority AI responses",
            "Early access to new features",
        ],
    },
]


# ── Schemas ────────────────────────────────────────────────────────────


class CheckoutRequest(BaseModel):
    plan_id: str = Field(...)
    success_url: str = Field(default="https://app.gaijin-navi.com/subscription/success")
    cancel_url: str = Field(default="https://app.gaijin-navi.com/subscription/cancel")


# ── Helpers ────────────────────────────────────────────────────────────


def _find_plan(plan_id: str) -> dict | None:
    for plan in PLANS:
        if plan["id"] == plan_id:
            return plan
    return None


def _tier_from_price_id(price_id: str) -> str:
    """Resolve subscription tier from Stripe price ID."""
    if price_id == settings.STRIPE_PREMIUM_PRICE_ID:
        return "premium"
    elif price_id == settings.STRIPE_PREMIUM_PLUS_PRICE_ID:
        return "premium_plus"
    return "premium"


def _subscription_to_dict(sub: Subscription | None) -> dict:
    if sub is None:
        return {
            "tier": "free",
            "status": None,
            "current_period_end": None,
            "cancel_at_period_end": False,
        }
    return {
        "id": sub.id,
        "tier": sub.tier,
        "status": sub.status,
        "stripe_customer_id": sub.stripe_customer_id,
        "stripe_subscription_id": sub.stripe_subscription_id,
        "current_period_start": sub.current_period_start.isoformat() if sub.current_period_start else None,
        "current_period_end": sub.current_period_end.isoformat() if sub.current_period_end else None,
        "cancel_at_period_end": sub.cancel_at_period_end,
        "cancelled_at": sub.cancelled_at.isoformat() if sub.cancelled_at else None,
        "created_at": sub.created_at.isoformat() if sub.created_at else None,
    }


# ── Endpoints ──────────────────────────────────────────────────────────


@router.get("/plans")
async def list_plans() -> dict:
    """Available subscription plans — no auth required."""
    # Return plan info without internal stripe_price_id
    public_plans = []
    for p in PLANS:
        public_plans.append({
            "id": p["id"],
            "name": p["name"],
            "price": p["price"],
            "currency": p["currency"],
            "interval": p["interval"],
            "features": p["features"],
        })
    return SuccessResponse(data=public_plans).model_dump()


@router.post("/checkout")
async def create_checkout(
    body: CheckoutRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Create a Stripe Checkout session — auth required."""
    plan = _find_plan(body.plan_id)
    if plan is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Plan not found.", "details": {}}},
        )

    if _mock_mode:
        # Mock mode: return a test checkout URL
        mock_session_id = f"cs_test_{uuid.uuid4().hex[:24]}"
        return SuccessResponse(
            data={
                "checkout_url": f"https://checkout.stripe.com/test/{mock_session_id}",
                "session_id": mock_session_id,
                "mock": True,
            }
        ).model_dump()

    # Real Stripe mode
    import stripe

    stripe.api_key = settings.STRIPE_SECRET_KEY

    # Find or create Stripe customer
    sub_stmt = select(Subscription).where(Subscription.user_id == current_user.uid)
    sub_result = await db.execute(sub_stmt)
    existing_sub = sub_result.scalars().first()

    customer_id = existing_sub.stripe_customer_id if existing_sub else None

    if not customer_id:
        customer = stripe.Customer.create(
            email=current_user.email,
            metadata={"firebase_uid": current_user.uid},
        )
        customer_id = customer.id

    session = stripe.checkout.Session.create(
        customer=customer_id,
        payment_method_types=["card"],
        line_items=[
            {
                "price": plan["stripe_price_id"],
                "quantity": 1,
            }
        ],
        mode="subscription",
        success_url=body.success_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url=body.cancel_url,
        metadata={
            "firebase_uid": current_user.uid,
            "plan_id": body.plan_id,
        },
    )

    return SuccessResponse(
        data={
            "checkout_url": session.url,
            "session_id": session.id,
        }
    ).model_dump()


@router.get("/me")
async def get_my_subscription(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Current subscription status — auth required."""
    sub_stmt = select(Subscription).where(Subscription.user_id == current_user.uid)
    sub_result = await db.execute(sub_stmt)
    sub = sub_result.scalars().first()

    return SuccessResponse(data=_subscription_to_dict(sub)).model_dump()


@router.post("/cancel")
async def cancel_subscription(
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Cancel subscription — sets cancel_at_period_end=true (BUSINESS_RULES.md §9)."""
    sub_stmt = select(Subscription).where(Subscription.user_id == current_user.uid)
    sub_result = await db.execute(sub_stmt)
    sub = sub_result.scalars().first()

    if sub is None or sub.status not in ("active", "past_due"):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "No active subscription found.",
                    "details": {},
                }
            },
        )

    now = datetime.now(timezone.utc)

    if not _mock_mode and sub.stripe_subscription_id:
        import stripe

        stripe.api_key = settings.STRIPE_SECRET_KEY
        stripe.Subscription.modify(
            sub.stripe_subscription_id,
            cancel_at_period_end=True,
        )

    # Update local record
    sub.cancel_at_period_end = True
    sub.cancelled_at = now
    sub.updated_at = now
    await db.flush()

    return SuccessResponse(
        data={
            "status": sub.status,
            "cancel_at_period_end": sub.cancel_at_period_end,
            "current_period_end": sub.current_period_end.isoformat() if sub.current_period_end else None,
        }
    ).model_dump()


@router.post("/webhook")
async def stripe_webhook(request: Request) -> dict:
    """Stripe webhook handler — processes 5 event types per BUSINESS_RULES.md §9.

    In mock mode, signature verification is skipped.
    """
    body = await request.body()

    if not _mock_mode:
        import stripe

        stripe.api_key = settings.STRIPE_SECRET_KEY
        sig = request.headers.get("stripe-signature", "")
        try:
            event = stripe.Webhook.construct_event(
                body, sig, settings.STRIPE_WEBHOOK_SECRET
            )
        except Exception as exc:
            logger.warning("Stripe webhook signature verification failed: %s", exc)
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail={"error": {"code": "VALIDATION_ERROR", "message": "Invalid signature.", "details": {}}},
            )
    else:
        # Mock mode: parse JSON directly, skip signature verification
        try:
            event = json.loads(body)
        except Exception:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail={"error": {"code": "VALIDATION_ERROR", "message": "Invalid JSON.", "details": {}}},
            )

    event_type = event.get("type", "")
    data_obj = event.get("data", {}).get("object", {})

    logger.info("Stripe webhook received: %s", event_type)

    # Get a fresh DB session for webhook processing
    from database import async_session_factory

    async with async_session_factory() as db:
        try:
            if event_type == "checkout.session.completed":
                await _handle_checkout_completed(db, data_obj)
            elif event_type == "customer.subscription.updated":
                await _handle_subscription_updated(db, data_obj)
            elif event_type == "customer.subscription.deleted":
                await _handle_subscription_deleted(db, data_obj)
            elif event_type == "invoice.payment_failed":
                await _handle_payment_failed(db, data_obj)
            elif event_type == "invoice.payment_succeeded":
                await _handle_payment_succeeded(db, data_obj)
            else:
                logger.info("Unhandled webhook event type: %s", event_type)

            await db.commit()
        except Exception:
            await db.rollback()
            raise

    return {"received": True}


# ── Webhook Handlers ───────────────────────────────────────────────────


async def _handle_checkout_completed(db: AsyncSession, data: dict) -> None:
    """checkout.session.completed → create subscription + update profile tier."""
    firebase_uid = data.get("metadata", {}).get("firebase_uid", "")
    plan_id = data.get("metadata", {}).get("plan_id", "")
    customer_id = data.get("customer", "")
    subscription_id = data.get("subscription", "")

    if not firebase_uid:
        logger.warning("checkout.session.completed missing firebase_uid in metadata")
        return

    plan = _find_plan(plan_id)
    tier = plan["tier"] if plan else "premium"
    now = datetime.now(timezone.utc)

    # Check if subscription already exists for this user
    sub_stmt = select(Subscription).where(Subscription.user_id == firebase_uid)
    sub_result = await db.execute(sub_stmt)
    existing_sub = sub_result.scalars().first()

    if existing_sub:
        existing_sub.stripe_customer_id = customer_id or existing_sub.stripe_customer_id
        existing_sub.stripe_subscription_id = subscription_id or existing_sub.stripe_subscription_id
        existing_sub.tier = tier
        existing_sub.status = "active"
        existing_sub.current_period_start = now
        existing_sub.current_period_end = now + timedelta(days=30)
        existing_sub.cancel_at_period_end = False
        existing_sub.cancelled_at = None
        existing_sub.updated_at = now
    else:
        new_sub = Subscription(
            id=str(uuid.uuid4()),
            user_id=firebase_uid,
            stripe_customer_id=customer_id or f"cus_mock_{uuid.uuid4().hex[:12]}",
            stripe_subscription_id=subscription_id,
            tier=tier,
            status="active",
            current_period_start=now,
            current_period_end=now + timedelta(days=30),
            cancel_at_period_end=False,
        )
        db.add(new_sub)

    # Update profile tier (SSOT: webhook is the only place that updates tier)
    profile = await db.get(Profile, firebase_uid)
    if profile:
        profile.subscription_tier = tier
        profile.updated_at = now

    logger.info("checkout.session.completed: user=%s tier=%s", firebase_uid, tier)


async def _handle_subscription_updated(db: AsyncSession, data: dict) -> None:
    """customer.subscription.updated → sync status + tier + period."""
    stripe_sub_id = data.get("id", "")
    customer_id = data.get("customer", "")
    status_val = data.get("status", "active")
    cancel_at_period_end = data.get("cancel_at_period_end", False)

    # Resolve tier from items
    items = data.get("items", {}).get("data", [])
    price_id = items[0].get("price", {}).get("id", "") if items else ""
    tier = _tier_from_price_id(price_id)

    # Map Stripe status to our status
    status_map = {
        "active": "active",
        "past_due": "past_due",
        "canceled": "expired",
        "unpaid": "past_due",
        "trialing": "active",
    }
    local_status = status_map.get(status_val, "active")

    now = datetime.now(timezone.utc)

    sub_stmt = select(Subscription).where(
        Subscription.stripe_subscription_id == stripe_sub_id
    )
    sub_result = await db.execute(sub_stmt)
    sub = sub_result.scalars().first()

    if sub:
        sub.tier = tier
        sub.status = local_status
        sub.cancel_at_period_end = cancel_at_period_end
        # Update period if provided
        period_start = data.get("current_period_start")
        period_end = data.get("current_period_end")
        if period_start:
            sub.current_period_start = datetime.fromtimestamp(period_start, tz=timezone.utc)
        if period_end:
            sub.current_period_end = datetime.fromtimestamp(period_end, tz=timezone.utc)
        sub.updated_at = now

        # Sync profile tier
        profile = await db.get(Profile, sub.user_id)
        if profile:
            profile.subscription_tier = tier
            profile.updated_at = now

    logger.info("subscription.updated: sub_id=%s tier=%s status=%s", stripe_sub_id, tier, local_status)


async def _handle_subscription_deleted(db: AsyncSession, data: dict) -> None:
    """customer.subscription.deleted → status='expired', profile tier='free'."""
    stripe_sub_id = data.get("id", "")
    now = datetime.now(timezone.utc)

    sub_stmt = select(Subscription).where(
        Subscription.stripe_subscription_id == stripe_sub_id
    )
    sub_result = await db.execute(sub_stmt)
    sub = sub_result.scalars().first()

    if sub:
        sub.status = "expired"
        sub.updated_at = now

        profile = await db.get(Profile, sub.user_id)
        if profile:
            profile.subscription_tier = "free"
            profile.updated_at = now

    logger.info("subscription.deleted: sub_id=%s → expired/free", stripe_sub_id)


async def _handle_payment_failed(db: AsyncSession, data: dict) -> None:
    """invoice.payment_failed → status='past_due'."""
    subscription_id = data.get("subscription", "")
    now = datetime.now(timezone.utc)

    if subscription_id:
        sub_stmt = select(Subscription).where(
            Subscription.stripe_subscription_id == subscription_id
        )
        sub_result = await db.execute(sub_stmt)
        sub = sub_result.scalars().first()
        if sub:
            sub.status = "past_due"
            sub.updated_at = now

    logger.info("invoice.payment_failed: sub=%s → past_due", subscription_id)


async def _handle_payment_succeeded(db: AsyncSession, data: dict) -> None:
    """invoice.payment_succeeded → status='active' (recovery from past_due)."""
    subscription_id = data.get("subscription", "")
    now = datetime.now(timezone.utc)

    if subscription_id:
        sub_stmt = select(Subscription).where(
            Subscription.stripe_subscription_id == subscription_id
        )
        sub_result = await db.execute(sub_stmt)
        sub = sub_result.scalars().first()
        if sub and sub.status == "past_due":
            sub.status = "active"
            sub.updated_at = now

    logger.info("invoice.payment_succeeded: sub=%s → active", subscription_id)
