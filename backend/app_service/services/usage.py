"""Usage tracking service — Credit Ledger based chat limit enforcement.

Tier behavior (from BUSINESS_RULES.md §2 — SSOT):
  • guest        → AI Chat 利用不可 (403)
  • free         → Credit Ledger (initial 5 lifetime + re-engagement grants)
  • standard     → Credit Ledger (300/month subscription credits)
  • premium      → unlimited (no credits consumed)
  • premium_plus → unlimited (no credits consumed)

Counter mapping:
  • chat_credits table → Credit Ledger (source of truth for limits)
  • deep_count column  → analytics/legacy (incremented but not used for limits)

Note: chat_count column remains in daily_usage table (DB migration not
required) but is no longer referenced by application code.  概要級 was
deprecated in 2026-03-03.
"""

from __future__ import annotations

import logging
import uuid
from dataclasses import dataclass
from datetime import date

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from models.daily_usage import DailyUsage
from services.credits import check_reengagement, consume_credit, get_balance

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
    credit_used_from: str | None = None  # source of the consumed credit
    total_remaining: int = 0


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


async def _increment_deep_count(
    db: AsyncSession,
    user_id: str,
) -> None:
    """Increment deep_count for analytics/legacy tracking."""
    record = await _get_or_create_today(db, user_id)
    record.deep_count += 1
    await db.flush()


# ── Public API ─────────────────────────────────────────────────────────


async def check_and_consume(
    db: AsyncSession,
    user_id: str,
    tier: str,
) -> UsageCheck:
    """Check the user's credit balance and consume 1 credit if allowed.

    Flow (design doc §3.2):
      1. guest → 403 (CHAT_REQUIRES_AUTH)
      2. premium/premium_plus → unlimited (no credit consumed)
      3. Try to consume 1 credit from ledger
         → Found → allowed=True
         → Not found → Try re-engagement → allowed or 429
      4. Always increment deep_count for analytics

    The consume happens *only* when the check passes (``allowed=True``).
    All DB work uses the caller's session — commit/rollback is the caller's
    responsibility (handled by ``get_db`` dependency).
    """
    # ── Guest: no access ───────────────────────────────────────────────
    #    TestFlight mode: guest is promoted to "free" in chat.py before reaching here.
    if tier == "guest":
        return UsageCheck(
            allowed=False, used=0, limit=0, tier=tier, period=None,
        )

    # ── Unknown tier: blocked ──────────────────────────────────────────
    known_tiers = {"free", "standard", "premium", "premium_plus"}
    if tier not in known_tiers:
        logger.warning("Unknown tier '%s'; treating as blocked", tier)
        return UsageCheck(
            allowed=False, used=0, limit=0, tier=tier, period=None,
        )

    # ── Unlimited (premium / premium_plus) ─────────────────────────────
    if tier in ("premium", "premium_plus"):
        # Increment analytics counter but don't consume credits
        await _increment_deep_count(db, user_id)
        return UsageCheck(
            allowed=True, used=0, limit=None, tier=tier, period=None,
            credit_used_from=None, total_remaining=0,
        )

    # ── Credit-based tiers (free / standard) ───────────────────────────

    # Try to consume 1 credit
    consume_result = await consume_credit(db, user_id)

    if consume_result.consumed:
        # Success — also increment analytics counter
        await _increment_deep_count(db, user_id)
        return UsageCheck(
            allowed=True,
            used=0,  # Not meaningful in credit system
            limit=None,  # Will be overridden by total_remaining in API
            tier=tier,
            period=None,
            credit_used_from=consume_result.source,
            total_remaining=consume_result.total_remaining,
        )

    # No credits available — try re-engagement
    reengage_credit = await check_reengagement(db, user_id, tier)
    if reengage_credit is not None:
        # Re-engagement granted — now consume from it
        consume_result = await consume_credit(db, user_id)
        if consume_result.consumed:
            await _increment_deep_count(db, user_id)
            return UsageCheck(
                allowed=True,
                used=0,
                limit=None,
                tier=tier,
                period=None,
                credit_used_from=consume_result.source,
                total_remaining=consume_result.total_remaining,
            )

    # Truly exhausted — 429
    balance = await get_balance(db, user_id)
    return UsageCheck(
        allowed=False,
        used=0,
        limit=0,
        tier=tier,
        period=None,
        total_remaining=balance.total_remaining,
    )


# ── Backward compatibility alias ──────────────────────────────────────

# Legacy callers that used check_and_increment will now use the credit system.
check_and_increment = check_and_consume
