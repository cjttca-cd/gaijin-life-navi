"""Usage tracking service — checks and enforces tier-based chat limits.

Tier limits (from BUSINESS_RULES.md §2 — SSOT):
  • guest        → AI Chat 利用不可 (403)
  • free         → 深度級 5 (lifetime)
  • standard     → 深度級 300 chats / month
  • premium      → 深度級 unlimited
  • premium_plus → 深度級 unlimited

Counter mapping:
  • deep_count column  → 深度級 usage

Note: chat_count column remains in daily_usage table (DB migration not
required) but is no longer referenced by application code.  概要級 was
deprecated in 2026-03-03.
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
    period: str | None = None  # "lifetime" | "month" | None(unlimited)


# ── Tier configuration ─────────────────────────────────────────────────

# Each tier maps to (max_deep, period).
# None max ⇒ unlimited;  0 max ⇒ chat unavailable (403).
_TIER_LIMITS: dict[str, tuple[int | None, str | None]] = {
    "guest":        (0, None),           # AI Chat 利用不可 → 403
    "free":         (5, "lifetime"),      # 深度級 5回/lifetime
    "standard":     (300, "month"),       # 深度級 300回/month
    "premium":      (None, None),         # 深度級 unlimited
    "premium_plus": (None, None),         # 深度級 unlimited
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
            deep_count=0,
            scan_count_monthly=0,
        )
        db.add(record)
        await db.flush()

    return record


async def _lifetime_deep_count(
    db: AsyncSession,
    user_id: str,
) -> int:
    """Sum ``deep_count`` across ALL daily_usage rows (深度級 lifetime total)."""
    stmt = (
        select(func.coalesce(func.sum(DailyUsage.deep_count), 0))
        .where(DailyUsage.user_id == user_id)
    )
    result = await db.execute(stmt)
    return result.scalar_one()


async def _monthly_deep_count(
    db: AsyncSession,
    user_id: str,
) -> int:
    """Sum ``deep_count`` across daily_usage rows for the current month."""
    today = date.today()
    first_of_month = today.replace(day=1)
    stmt = (
        select(func.coalesce(func.sum(DailyUsage.deep_count), 0))
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

    All tiers use 深度級 only (概要級 was deprecated 2026-03-03):
      Guest       → blocked (0 deep, returns 403 in router)
      Free        → 深度級 5 (lifetime)
      Standard    → 深度級 300/month
      Premium(+)  → 深度級 unlimited

    The increment happens *only* when the check passes (``allowed=True``).
    All DB work uses the caller's session — commit/rollback is the caller's
    responsibility (handled by ``get_db`` dependency).
    """
    tier_cfg = _TIER_LIMITS.get(tier)
    if tier_cfg is None:
        logger.warning("Unknown tier '%s'; treating as blocked", tier)
        return UsageCheck(
            allowed=False, used=0, limit=0, tier=tier, period=None,
        )

    deep_max, deep_period = tier_cfg

    # ── Unlimited (premium / premium_plus) ─────────────────────────────

    if deep_max is None:
        record = await _get_or_create_today(db, user_id)
        record.deep_count += 1
        await db.flush()
        monthly = await _monthly_deep_count(db, user_id)
        return UsageCheck(
            allowed=True, used=monthly, limit=None, tier=tier, period=None,
        )

    # ── No access (guest: deep_max == 0) ───────────────────────────────

    if deep_max == 0:
        return UsageCheck(
            allowed=False, used=0, limit=0, tier=tier, period=None,
        )

    # ── Limited access ─────────────────────────────────────────────────

    if deep_period == "lifetime":
        deep_used = await _lifetime_deep_count(db, user_id)
        if deep_used < deep_max:
            record = await _get_or_create_today(db, user_id)
            record.deep_count += 1
            await db.flush()
            return UsageCheck(
                allowed=True, used=deep_used + 1, limit=deep_max,
                tier=tier, period="lifetime",
            )
        # Exhausted
        return UsageCheck(
            allowed=False, used=deep_used, limit=deep_max,
            tier=tier, period="lifetime",
        )

    if deep_period == "month":
        deep_used = await _monthly_deep_count(db, user_id)
        if deep_used < deep_max:
            record = await _get_or_create_today(db, user_id)
            record.deep_count += 1
            await db.flush()
            return UsageCheck(
                allowed=True, used=deep_used + 1, limit=deep_max,
                tier=tier, period="month",
            )
        # Exhausted
        return UsageCheck(
            allowed=False, used=deep_used, limit=deep_max,
            tier=tier, period="month",
        )

    # Fallback — should not reach here
    return UsageCheck(
        allowed=False, used=0, limit=0, tier=tier, period=deep_period,
    )
