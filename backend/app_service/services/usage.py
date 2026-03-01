"""Usage tracking service — checks and enforces tier-based chat limits.

Tier limits (from BUSINESS_RULES.md §2 — SSOT):
  • guest        → 概要級 5 chats total (lifetime)
  • free         → 深度級 5 (lifetime) then 概要級 3 (lifetime)
  • standard     → 深度級 300 chats / month
  • premium      → 深度級 unlimited
  • premium_plus → 深度級 unlimited

Deep/summary counter mapping:
  • deep_count column  → 深度級 usage
  • chat_count column  → 概要級 usage

The service operates on the ``daily_usage`` table, performing an
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
    period: str | None = None  # "lifetime" | "month" | None(unlimited)
    depth_level: str = "deep"  # "deep" | "summary"


# ── Tier configuration ─────────────────────────────────────────────────

# Each tier maps to {"deep": (max, period), "summary": (max, period)}.
# None max ⇒ unlimited;  0 max ⇒ unavailable for that depth level.
_TIER_LIMITS: dict[str, dict[str, tuple[int | None, str | None]]] = {
    "guest":        {"deep": (0, None),      "summary": (5, "lifetime")},
    "free":         {"deep": (5, "lifetime"), "summary": (3, "lifetime")},
    "standard":     {"deep": (300, "month"),  "summary": (0, None)},
    "premium":      {"deep": (None, None),    "summary": (0, None)},
    "premium_plus": {"deep": (None, None),    "summary": (0, None)},
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


async def _lifetime_chat_count(
    db: AsyncSession,
    user_id: str,
) -> int:
    """Sum ``chat_count`` across ALL daily_usage rows (概要級 lifetime total)."""
    stmt = (
        select(func.coalesce(func.sum(DailyUsage.chat_count), 0))
        .where(DailyUsage.user_id == user_id)
    )
    result = await db.execute(stmt)
    return result.scalar_one()


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


async def _monthly_chat_count(
    db: AsyncSession,
    user_id: str,
) -> int:
    """Sum ``chat_count`` across daily_usage rows for the current month."""
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

    Consumption order (BUSINESS_RULES.md §2):
      Guest       → 概要級 only (5 lifetime)
      Free        → 深度級 first (5 lifetime) → 概要級 fallback (3 lifetime)
      Standard    → 深度級 only (300/month)
      Premium(+)  → 深度級 unlimited

    The increment happens *only* when the check passes (``allowed=True``).
    All DB work uses the caller's session — commit/rollback is the caller's
    responsibility (handled by ``get_db`` dependency).
    """
    tier_cfg = _TIER_LIMITS.get(tier)
    if tier_cfg is None:
        logger.warning("Unknown tier '%s'; treating as blocked", tier)
        return UsageCheck(
            allowed=False, used=0, limit=0, tier=tier,
            period=None, depth_level="summary",
        )

    deep_max, deep_period = tier_cfg["deep"]
    summ_max, summ_period = tier_cfg["summary"]

    # ── Try 深度級 first ───────────────────────────────────────────────

    if deep_max is None:
        # Unlimited deep (premium / premium_plus)
        record = await _get_or_create_today(db, user_id)
        record.deep_count += 1
        await db.flush()
        monthly = await _monthly_deep_count(db, user_id)
        return UsageCheck(
            allowed=True, used=monthly, limit=None, tier=tier,
            period=None, depth_level="deep",
        )

    if deep_max > 0:
        if deep_period == "lifetime":
            deep_used = await _lifetime_deep_count(db, user_id)
            if deep_used < deep_max:
                record = await _get_or_create_today(db, user_id)
                record.deep_count += 1
                await db.flush()
                return UsageCheck(
                    allowed=True, used=deep_used + 1, limit=deep_max,
                    tier=tier, period="lifetime", depth_level="deep",
                )
            # Deep exhausted — fall through to summary

        elif deep_period == "month":
            deep_used = await _monthly_deep_count(db, user_id)
            if deep_used < deep_max:
                record = await _get_or_create_today(db, user_id)
                record.deep_count += 1
                await db.flush()
                return UsageCheck(
                    allowed=True, used=deep_used + 1, limit=deep_max,
                    tier=tier, period="month", depth_level="deep",
                )
            # Deep exhausted — fall through to summary

    # ── Try 概要級 ─────────────────────────────────────────────────────

    if summ_max is None:
        # Unlimited summary (not in current design but handled gracefully)
        record = await _get_or_create_today(db, user_id)
        record.chat_count += 1
        await db.flush()
        lifetime = await _lifetime_chat_count(db, user_id)
        return UsageCheck(
            allowed=True, used=lifetime, limit=None, tier=tier,
            period=None, depth_level="summary",
        )

    if summ_max > 0:
        if summ_period == "lifetime":
            summ_used = await _lifetime_chat_count(db, user_id)
            if summ_used < summ_max:
                record = await _get_or_create_today(db, user_id)
                record.chat_count += 1
                await db.flush()
                return UsageCheck(
                    allowed=True, used=summ_used + 1, limit=summ_max,
                    tier=tier, period="lifetime", depth_level="summary",
                )

    # ── Both exhausted → blocked ───────────────────────────────────────

    if deep_max > 0 and summ_max is not None and summ_max > 0:
        # Free tier — report combined deep + summary usage
        d = await _lifetime_deep_count(db, user_id) if deep_period == "lifetime" else 0
        s = await _lifetime_chat_count(db, user_id) if summ_period == "lifetime" else 0
        return UsageCheck(
            allowed=False, used=d + s, limit=deep_max + summ_max,
            tier=tier, period="lifetime", depth_level="summary",
        )

    if deep_max > 0:
        # Standard — only deep was available
        used = (
            await _monthly_deep_count(db, user_id)
            if deep_period == "month"
            else await _lifetime_deep_count(db, user_id)
        )
        return UsageCheck(
            allowed=False, used=used, limit=deep_max,
            tier=tier, period=deep_period, depth_level="deep",
        )

    # Guest or summary-only tier
    used = (
        await _lifetime_chat_count(db, user_id)
        if summ_period == "lifetime"
        else 0
    )
    return UsageCheck(
        allowed=False, used=used, limit=summ_max or 0,
        tier=tier, period=summ_period, depth_level="summary",
    )
