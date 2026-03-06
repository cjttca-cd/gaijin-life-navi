"""Credit Ledger service — grant, consume, balance, and re-engagement.

Provides the core credit operations for the Chat Credits system:
  - grant_credits(): Create a new credit row
  - consume_credit(): Consume 1 credit using priority ordering
  - get_balance(): Get remaining credits by source
  - check_reengagement(): Auto-grant re-engagement credits

See: tasks/chat-credits-design.md §3–5
"""

from __future__ import annotations

import logging
import uuid
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone

from sqlalchemy import case, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from config import REENGAGE_CONFIG
from models.chat_credit import ChatCredit

logger = logging.getLogger(__name__)


# ── Result dataclasses ─────────────────────────────────────────────────


@dataclass(frozen=True, slots=True)
class CreditBalance:
    """Aggregated credit balance for a user."""

    total_remaining: int
    subscription_remaining: int
    grant_remaining: int
    purchase_remaining: int
    subscription_expires_at: datetime | None
    grant_expires_at: datetime | None
    purchase_expires_at: datetime | None


@dataclass(frozen=True, slots=True)
class ConsumeResult:
    """Result of a credit consumption attempt."""

    consumed: bool
    source: str | None  # Which source was consumed from
    total_remaining: int


# ── Helpers ────────────────────────────────────────────────────────────


def _now_utc() -> datetime:
    """Return current UTC datetime."""
    return datetime.now(timezone.utc)


def _active_credits_query(user_id: str):
    """Base query for active (non-expired, remaining > 0) credits."""
    now = _now_utc()
    return select(ChatCredit).where(
        ChatCredit.user_id == user_id,
        ChatCredit.remaining > 0,
        (ChatCredit.expires_at.is_(None)) | (ChatCredit.expires_at > now),
    )


# ── Source tiebreaker for ordering ─────────────────────────────────────

_SOURCE_ORDER = case(
    (ChatCredit.source == "grant", 0),
    (ChatCredit.source == "subscription", 1),
    (ChatCredit.source == "purchase", 2),
    else_=3,
)


# ── Public API ─────────────────────────────────────────────────────────


async def grant_credits(
    db: AsyncSession,
    *,
    user_id: str,
    source: str,
    amount: int,
    source_detail: str | None = None,
    expires_at: datetime | None = None,
) -> ChatCredit:
    """Create a new credit row (grant/subscription/purchase).

    Args:
        db: Async database session.
        user_id: Target user ID.
        source: Credit source ('subscription', 'grant', or 'purchase').
        amount: Number of credits to grant.
        source_detail: Optional detail label (e.g. 'standard-monthly').
        expires_at: Optional expiration datetime (None = no expiry).

    Returns:
        The created ChatCredit row.
    """
    credit = ChatCredit(
        id=str(uuid.uuid4()),
        user_id=user_id,
        source=source,
        source_detail=source_detail,
        initial_amount=amount,
        remaining=amount,
        expires_at=expires_at,
    )
    db.add(credit)
    await db.flush()
    logger.info(
        "Granted %d %s credits to user %s (detail=%s, expires=%s)",
        amount,
        source,
        user_id,
        source_detail,
        expires_at,
    )
    return credit


async def consume_credit(db: AsyncSession, user_id: str) -> ConsumeResult:
    """Consume 1 credit from the user's ledger.

    Priority: expires_at ASC NULLS LAST → source tiebreaker
    (grant=0, subscription=1, purchase=2) → created_at ASC.

    Returns:
        ConsumeResult with consumed=True/False and remaining balance.
    """
    # Find the best credit row to consume from
    stmt = (
        _active_credits_query(user_id)
        .order_by(
            ChatCredit.expires_at.asc().nulls_last(),
            _SOURCE_ORDER,
            ChatCredit.created_at.asc(),
        )
        .limit(1)
    )
    result = await db.execute(stmt)
    credit = result.scalar_one_or_none()

    if credit is None:
        # No active credits — check total remaining for the response
        balance = await get_balance(db, user_id)
        return ConsumeResult(
            consumed=False,
            source=None,
            total_remaining=balance.total_remaining,
        )

    # Consume 1 credit
    credit.remaining -= 1
    credit.updated_at = _now_utc()
    await db.flush()

    # Get updated balance
    balance = await get_balance(db, user_id)
    return ConsumeResult(
        consumed=True,
        source=credit.source,
        total_remaining=balance.total_remaining,
    )


async def get_balance(db: AsyncSession, user_id: str) -> CreditBalance:
    """Get the user's aggregated credit balance by source.

    Returns remaining credits broken down by source type, along with
    the earliest expiry date for each source.
    """
    now = _now_utc()
    stmt = select(
        func.coalesce(func.sum(ChatCredit.remaining), 0).label("total"),
        func.coalesce(
            func.sum(
                case(
                    (ChatCredit.source == "subscription", ChatCredit.remaining),
                    else_=0,
                )
            ),
            0,
        ).label("sub"),
        func.coalesce(
            func.sum(
                case(
                    (ChatCredit.source == "grant", ChatCredit.remaining),
                    else_=0,
                )
            ),
            0,
        ).label("grant"),
        func.coalesce(
            func.sum(
                case(
                    (ChatCredit.source == "purchase", ChatCredit.remaining),
                    else_=0,
                )
            ),
            0,
        ).label("purchase"),
    ).where(
        ChatCredit.user_id == user_id,
        ChatCredit.remaining > 0,
        (ChatCredit.expires_at.is_(None)) | (ChatCredit.expires_at > now),
    )
    result = await db.execute(stmt)
    row = result.one()

    # Get earliest expiry per source
    sub_expires = await _earliest_expiry(db, user_id, "subscription")
    grant_expires = await _earliest_expiry(db, user_id, "grant")
    purchase_expires = await _earliest_expiry(db, user_id, "purchase")

    return CreditBalance(
        total_remaining=row.total,
        subscription_remaining=row.sub,
        grant_remaining=row.grant,
        purchase_remaining=row.purchase,
        subscription_expires_at=sub_expires,
        grant_expires_at=grant_expires,
        purchase_expires_at=purchase_expires,
    )


async def _earliest_expiry(
    db: AsyncSession, user_id: str, source: str
) -> datetime | None:
    """Get the earliest expiry date for a given source type."""
    now = _now_utc()
    stmt = (
        select(func.min(ChatCredit.expires_at))
        .where(
            ChatCredit.user_id == user_id,
            ChatCredit.source == source,
            ChatCredit.remaining > 0,
            ChatCredit.expires_at.is_not(None),
            ChatCredit.expires_at > now,
        )
    )
    result = await db.execute(stmt)
    return result.scalar_one_or_none()


async def check_reengagement(
    db: AsyncSession,
    user_id: str,
    tier: str,
) -> ChatCredit | None:
    """Check if the user qualifies for re-engagement and auto-grant if so.

    Conditions (all must be met):
      1. Re-engagement is enabled in config
      2. User's tier is in eligible_tiers
      3. User has zero active credits
      4. Last re-engagement grant was > cooldown_days ago (or never)

    Returns:
        The created ChatCredit if granted, None otherwise.
    """
    if not REENGAGE_CONFIG.get("enabled", False):
        return None

    eligible_tiers = REENGAGE_CONFIG.get("eligible_tiers", [])
    if tier not in eligible_tiers:
        return None

    # Check if user has any active credits
    balance = await get_balance(db, user_id)
    if balance.total_remaining > 0:
        return None

    # Check cooldown: find the last re-engagement grant
    cooldown_days = REENGAGE_CONFIG.get("cooldown_days", 30)
    source_detail = REENGAGE_CONFIG.get("source_detail", "re-engagement")

    stmt = (
        select(ChatCredit.created_at)
        .where(
            ChatCredit.user_id == user_id,
            ChatCredit.source == "grant",
            ChatCredit.source_detail.like(f"{source_detail}%"),
        )
        .order_by(ChatCredit.created_at.desc())
        .limit(1)
    )
    result = await db.execute(stmt)
    last_grant_at = result.scalar_one_or_none()

    if last_grant_at is not None:
        # Make last_grant_at timezone-aware if it isn't already
        if last_grant_at.tzinfo is None:
            last_grant_at = last_grant_at.replace(tzinfo=timezone.utc)
        cutoff = _now_utc() - timedelta(days=cooldown_days)
        if last_grant_at > cutoff:
            return None

    # All conditions met — grant re-engagement credits
    grant_amount = REENGAGE_CONFIG.get("grant_amount", 1)
    grant_expires_days = REENGAGE_CONFIG.get("grant_expires_days", 30)
    expires_at = _now_utc() + timedelta(days=grant_expires_days)

    # Use a dated source_detail for tracking
    now = _now_utc()
    detail = f"{source_detail}-{now.strftime('%Y-%m')}"

    credit = await grant_credits(
        db,
        user_id=user_id,
        source="grant",
        amount=grant_amount,
        source_detail=detail,
        expires_at=expires_at,
    )
    logger.info("Re-engagement grant for user %s: %d credits", user_id, grant_amount)
    return credit
