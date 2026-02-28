"""Usage tracking service — checks and enforces tier-based chat limits.

Tier limits (from PHASE0_DESIGN.md / Z decision 2026-02-18):
  • free         → 10 chats total (lifetime, no daily reset)
  • standard     → 300 chats / month
  • premium      → unlimited
  • premium_plus → unlimited
  • guest        → 5 chats total (lifetime, 概要級 only)

The service operates on the existing ``daily_usage`` table, performing an
atomic get-or-create + check + increment inside the caller's DB session.
"""

from __future__ import annotations

import logging
import uuid
from dataclasses import dataclass
from datetime import date

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from models.daily_usage import DailyUsage

logger = logging.getLogger(__name__)


# ── Result dataclass ───────────────────────────────────────────────────


@dataclass(frozen=True, slots=True)
class UsageCheck:
    """Result of a usage-limit check."""

    allowed: bool
    used: int
    limit: int | None  # None ⇒ unlimited
    tier: str


# ── Tier configuration ─────────────────────────────────────────────────

# Each entry: (max_count, period)  —  None max ⇒ unlimited, 0 ⇒ blocked.
_TIER_LIMITS: dict[str, tuple[int | None, str | None]] = {
    "free": (10, "lifetime"),
    "standard": (300, "month"),
    "premium": (None, None),
    "premium_plus": (None, None),
    "guest": (5, "lifetime"),
}


# ── Internal helpers ───────────────────────────────────────────────────


async def _get_or_create_today(
    db: AsyncSession,
    user_id: str,
) -> DailyUsage:
    """Return today's DailyUsage row, creating one if absent."""
    today = date.today()
    stmt = select(DailyUsage).where(
        DailyUsage.user_id == user_id,
        DailyUsage.usage_date == today,
    )
    result = await db.execute(stmt)
    record = result.scalar_one_or_none()

    if record is None:
        record = DailyUsage(
            id=str(uuid.uuid4()),
            user_id=user_id,
            usage_date=today,
            chat_count=0,
            scan_count_monthly=0,
        )
        db.add(record)
        await db.flush()

    return record


async def _lifetime_chat_count(
    db: AsyncSession,
    user_id: str,
) -> int:
    """Sum ``chat_count`` across ALL daily_usage rows for this user (lifetime total)."""
    stmt = (
        select(func.coalesce(func.sum(DailyUsage.chat_count), 0))
        .where(DailyUsage.user_id == user_id)
    )
    result = await db.execute(stmt)
    return result.scalar_one()


async def _monthly_chat_count(
    db: AsyncSession,
    user_id: str,
) -> int:
    """Sum ``chat_count`` across all daily_usage rows for the current month."""
    today = date.today()
    first_of_month = today.replace(day=1)
    stmt = (
        select(func.coalesce(func.sum(DailyUsage.chat_count), 0))
        .where(
            DailyUsage.user_id == user_id,
            DailyUsage.usage_date >= first_of_month,
            DailyUsage.usage_date <= today,
        )
    )
    result = await db.execute(stmt)
    return result.scalar_one()


# ── Public API ─────────────────────────────────────────────────────────


async def check_and_increment(
    db: AsyncSession,
    user_id: str,
    tier: str,
) -> UsageCheck:
    """Check the user's usage against their tier limit and increment.

    The increment happens *only* when the check passes (``allowed=True``).
    All DB work uses the caller's session — commit/rollback is the caller's
    responsibility (handled by ``get_db`` dependency).
    """
    max_count, period = _TIER_LIMITS.get(tier, (0, None))

    # ── Guest / unknown tier: always blocked ───────────────────────────
    if max_count is not None and max_count <= 0:
        return UsageCheck(allowed=False, used=0, limit=0, tier=tier)

    # ── Unlimited tiers ────────────────────────────────────────────────
    if max_count is None:
        record = await _get_or_create_today(db, user_id)
        record.chat_count += 1
        await db.flush()
        # Report monthly total for informational purposes
        monthly = await _monthly_chat_count(db, user_id)
        return UsageCheck(allowed=True, used=monthly, limit=None, tier=tier)

    # ── Lifetime limit (free tier — 20 total, no reset) ──────────────
    if period == "lifetime":
        total = await _lifetime_chat_count(db, user_id)
        if total >= max_count:
            return UsageCheck(
                allowed=False, used=total, limit=max_count, tier=tier,
            )
        record = await _get_or_create_today(db, user_id)
        record.chat_count += 1
        await db.flush()
        return UsageCheck(
            allowed=True, used=total + 1, limit=max_count, tier=tier,
        )

    # ── Daily limit (legacy, kept for future use) ──────────────────────
    if period == "day":
        record = await _get_or_create_today(db, user_id)
        if record.chat_count >= max_count:
            return UsageCheck(
                allowed=False, used=record.chat_count, limit=max_count, tier=tier,
            )
        record.chat_count += 1
        await db.flush()
        return UsageCheck(
            allowed=True, used=record.chat_count, limit=max_count, tier=tier,
        )

    # ── Monthly limit (standard tier) ──────────────────────────────────
    if period == "month":
        monthly = await _monthly_chat_count(db, user_id)
        if monthly >= max_count:
            return UsageCheck(
                allowed=False, used=monthly, limit=max_count, tier=tier,
            )
        record = await _get_or_create_today(db, user_id)
        record.chat_count += 1
        await db.flush()
        return UsageCheck(
            allowed=True, used=monthly + 1, limit=max_count, tier=tier,
        )

    # ── Fallback: deny ─────────────────────────────────────────────────
    logger.warning("Unhandled tier/period combination: tier=%s, period=%s", tier, period)
    return UsageCheck(allowed=False, used=0, limit=0, tier=tier)
