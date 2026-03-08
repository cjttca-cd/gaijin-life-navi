"""Unit + integration tests for the Credit Ledger system.

Tests cover:
  1. Credit consumption: earliest expiry first
  2. Credit consumption: same-day expiry tiebreaker (grant→subscription→purchase)
  3. Credit consumption: skip expired rows
  4. Credit consumption: zero balance → 429
  5. Re-engagement: conditions met → auto-grant
  6. Re-engagement: cooldown period → denied
  7. Re-engagement: ineligible tier → denied
  8. Premium: unlimited pass (no credits needed)
  9. Guest: 403
  10. Balance query: accurate per-source aggregation

Integration tests:
  11. Free user: 5 consumes → 429 → re-engagement → 1 consume
  12. Standard: monthly + grant credits, consumption order
  13. Migration: daily_usage → chat_credits conversion accuracy
"""

from __future__ import annotations

import uuid
from datetime import datetime, timedelta, timezone

import pytest

from models.chat_credit import ChatCredit
from models.daily_usage import DailyUsage
from models.profile import Profile
from services.credits import (
    check_reengagement,
    consume_credit,
    get_balance,
    grant_credits,
)
from services.usage import check_balance, consume_after_success


# ── Helpers ────────────────────────────────────────────────────────────


def _now() -> datetime:
    return datetime.now(timezone.utc)


async def _seed_profile(db, user_id: str, tier: str = "free") -> Profile:
    """Create a minimal profile for testing."""
    profile = Profile(
        id=user_id,
        email=f"{user_id}@example.com",
        display_name="Test User",
        subscription_tier=tier,
    )
    db.add(profile)
    await db.flush()
    return profile


async def _seed_credit(
    db,
    user_id: str,
    *,
    source: str = "grant",
    source_detail: str | None = None,
    initial_amount: int = 5,
    remaining: int | None = None,
    expires_at: datetime | None = None,
    created_at: datetime | None = None,
) -> ChatCredit:
    """Insert a credit row directly for testing."""
    credit = ChatCredit(
        id=str(uuid.uuid4()),
        user_id=user_id,
        source=source,
        source_detail=source_detail,
        initial_amount=initial_amount,
        remaining=remaining if remaining is not None else initial_amount,
        expires_at=expires_at,
        created_at=created_at or _now(),
    )
    db.add(credit)
    await db.flush()
    return credit


# ══════════════════════════════════════════════════════════════════════
# UNIT TESTS (10 items)
# ══════════════════════════════════════════════════════════════════════


# 1. Credit consumption: earliest expiry first
@pytest.mark.asyncio
async def test_consume_earliest_expiry_first(db_session) -> None:
    uid = "u_expiry_order"
    await _seed_profile(db_session, uid)

    far = _now() + timedelta(days=30)
    near = _now() + timedelta(days=5)
    await _seed_credit(db_session, uid, source="grant", expires_at=far, initial_amount=3)
    near_credit = await _seed_credit(
        db_session, uid, source="grant", expires_at=near, initial_amount=2
    )

    result = await consume_credit(db_session, uid)
    assert result.consumed is True
    assert result.source == "grant"

    # Verify the near-expiry credit was consumed
    await db_session.refresh(near_credit)
    assert near_credit.remaining == 1


# 2. Credit consumption: same-day expiry tiebreaker (grant→subscription→purchase)
@pytest.mark.asyncio
async def test_consume_tiebreaker_source_order(db_session) -> None:
    uid = "u_tiebreaker"
    await _seed_profile(db_session, uid)

    same_expiry = _now() + timedelta(days=10)
    purchase = await _seed_credit(
        db_session, uid, source="purchase", expires_at=same_expiry, initial_amount=1,
        created_at=_now() - timedelta(hours=3),
    )
    subscription = await _seed_credit(
        db_session, uid, source="subscription", expires_at=same_expiry, initial_amount=1,
        created_at=_now() - timedelta(hours=2),
    )
    grant = await _seed_credit(
        db_session, uid, source="grant", expires_at=same_expiry, initial_amount=1,
        created_at=_now() - timedelta(hours=1),
    )

    # First consume → should use grant (tiebreaker = 0)
    result = await consume_credit(db_session, uid)
    assert result.consumed is True
    assert result.source == "grant"
    await db_session.refresh(grant)
    assert grant.remaining == 0

    # Second consume → should use subscription (tiebreaker = 1)
    result = await consume_credit(db_session, uid)
    assert result.consumed is True
    assert result.source == "subscription"
    await db_session.refresh(subscription)
    assert subscription.remaining == 0

    # Third consume → should use purchase (tiebreaker = 2)
    result = await consume_credit(db_session, uid)
    assert result.consumed is True
    assert result.source == "purchase"
    await db_session.refresh(purchase)
    assert purchase.remaining == 0


# 3. Credit consumption: skip expired rows
@pytest.mark.asyncio
async def test_consume_skip_expired(db_session) -> None:
    uid = "u_skip_expired"
    await _seed_profile(db_session, uid)

    # Expired credit
    await _seed_credit(
        db_session, uid, source="grant", initial_amount=10,
        expires_at=_now() - timedelta(days=1),
    )
    # Valid credit
    valid = await _seed_credit(
        db_session, uid, source="subscription", initial_amount=3,
        expires_at=_now() + timedelta(days=30),
    )

    result = await consume_credit(db_session, uid)
    assert result.consumed is True
    assert result.source == "subscription"
    await db_session.refresh(valid)
    assert valid.remaining == 2


# 4. Credit consumption: zero balance → not consumed
@pytest.mark.asyncio
async def test_consume_zero_balance(db_session) -> None:
    uid = "u_zero_balance"
    await _seed_profile(db_session, uid)

    # All credits exhausted (remaining=0)
    await _seed_credit(
        db_session, uid, source="grant", initial_amount=5, remaining=0,
    )

    result = await consume_credit(db_session, uid)
    assert result.consumed is False
    assert result.source is None
    assert result.total_remaining == 0


# 5. Re-engagement: conditions met → auto-grant
@pytest.mark.asyncio
async def test_reengagement_grant_on_exhaustion(db_session) -> None:
    uid = "u_reengage_ok"
    await _seed_profile(db_session, uid, tier="free")

    # Exhausted credits
    await _seed_credit(db_session, uid, source="grant", initial_amount=5, remaining=0)

    credit = await check_reengagement(db_session, uid, "free")
    assert credit is not None
    assert credit.source == "grant"
    assert credit.remaining == 1
    assert credit.source_detail is not None
    assert credit.source_detail.startswith("re-engagement")
    assert credit.expires_at is not None


# 6. Re-engagement: cooldown period → denied
@pytest.mark.asyncio
async def test_reengagement_cooldown_denied(db_session) -> None:
    uid = "u_reengage_cooldown"
    await _seed_profile(db_session, uid, tier="free")

    # Exhausted credits
    await _seed_credit(db_session, uid, source="grant", initial_amount=5, remaining=0)

    # Recent re-engagement grant (within cooldown)
    await _seed_credit(
        db_session, uid, source="grant", source_detail="re-engagement-2026-02",
        initial_amount=1, remaining=0,
        created_at=_now() - timedelta(days=5),  # Only 5 days ago
    )

    credit = await check_reengagement(db_session, uid, "free")
    assert credit is None


# 7. Re-engagement: ineligible tier → denied
@pytest.mark.asyncio
async def test_reengagement_ineligible_tier(db_session) -> None:
    uid = "u_reengage_tier"
    await _seed_profile(db_session, uid, tier="standard")

    # Exhausted credits
    await _seed_credit(db_session, uid, source="subscription", initial_amount=300, remaining=0)

    credit = await check_reengagement(db_session, uid, "standard")
    assert credit is None


# 8. Premium: unlimited pass (no credits needed)
@pytest.mark.asyncio
async def test_premium_unlimited(db_session) -> None:
    uid = "u_premium"
    await _seed_profile(db_session, uid, tier="premium")

    result = await check_balance(db_session, uid, "premium")
    assert result.allowed is True
    assert result.limit is None
    assert result.credit_used_from is None


# 9. Guest: 403
@pytest.mark.asyncio
async def test_guest_blocked(db_session) -> None:
    result = await check_balance(db_session, "guest_user", "guest")
    assert result.allowed is False
    assert result.limit == 0
    assert result.tier == "guest"


# 10. Balance query: accurate per-source aggregation
@pytest.mark.asyncio
async def test_balance_per_source(db_session) -> None:
    uid = "u_balance"
    await _seed_profile(db_session, uid)

    await _seed_credit(
        db_session, uid, source="subscription", initial_amount=300, remaining=250,
        expires_at=_now() + timedelta(days=30),
    )
    await _seed_credit(
        db_session, uid, source="grant", initial_amount=5, remaining=3,
    )
    await _seed_credit(
        db_session, uid, source="purchase", initial_amount=50, remaining=50,
    )
    # Expired — should not count
    await _seed_credit(
        db_session, uid, source="grant", initial_amount=10, remaining=10,
        expires_at=_now() - timedelta(days=1),
    )

    balance = await get_balance(db_session, uid)
    assert balance.total_remaining == 303  # 250 + 3 + 50
    assert balance.subscription_remaining == 250
    assert balance.grant_remaining == 3
    assert balance.purchase_remaining == 50


# ══════════════════════════════════════════════════════════════════════
# INTEGRATION TESTS (3 items)
# ══════════════════════════════════════════════════════════════════════


# 11. Free user: 5 consumes → 429 → re-engagement → 1 consume
@pytest.mark.asyncio
async def test_integration_free_user_lifecycle(db_session) -> None:
    uid = "u_int_free"
    await _seed_profile(db_session, uid, tier="free")

    # Grant initial 5 lifetime credits
    await grant_credits(
        db_session, user_id=uid, source="grant",
        amount=5, source_detail="migration-free-5",
    )

    # Use all 5 credits (check + consume)
    for i in range(5):
        result = await check_balance(db_session, uid, "free")
        assert result.allowed is True, f"Should be allowed on use {i+1}"
        consume = await consume_after_success(db_session, uid, "free")
        assert consume.credit_used_from is not None

    # 6th use → check_balance triggers re-engagement
    result = await check_balance(db_session, uid, "free")
    # Re-engagement should kick in for free tier
    assert result.allowed is True  # Re-engagement auto-granted
    consume = await consume_after_success(db_session, uid, "free")
    assert consume.credit_used_from == "grant"

    # Now truly exhausted (re-engagement cooldown prevents another grant)
    result = await check_balance(db_session, uid, "free")
    assert result.allowed is False


# 12. Standard: monthly + grant credits, consumption order
@pytest.mark.asyncio
async def test_integration_standard_consumption_order(db_session) -> None:
    uid = "u_int_standard"
    await _seed_profile(db_session, uid, tier="standard")

    # Monthly subscription credits (expires end of month)
    month_end = _now() + timedelta(days=25)
    await grant_credits(
        db_session, user_id=uid, source="subscription",
        amount=300, source_detail="standard-monthly",
        expires_at=month_end,
    )
    # Campaign grant (expires sooner)
    grant_expiry = _now() + timedelta(days=7)
    await grant_credits(
        db_session, user_id=uid, source="grant",
        amount=3, source_detail="spring-campaign-2026",
        expires_at=grant_expiry,
    )

    # First consume — should use grant (expires sooner)
    result = await check_balance(db_session, uid, "standard")
    assert result.allowed is True
    consume = await consume_after_success(db_session, uid, "standard")
    assert consume.credit_used_from == "grant"

    # Continue consuming grants
    await check_balance(db_session, uid, "standard")
    consume = await consume_after_success(db_session, uid, "standard")
    assert consume.credit_used_from == "grant"
    await check_balance(db_session, uid, "standard")
    consume = await consume_after_success(db_session, uid, "standard")
    assert consume.credit_used_from == "grant"

    # Grants exhausted, now uses subscription
    result = await check_balance(db_session, uid, "standard")
    assert result.allowed is True
    consume = await consume_after_success(db_session, uid, "standard")
    assert consume.credit_used_from == "subscription"


# 13. Migration: daily_usage → chat_credits conversion accuracy
@pytest.mark.asyncio
async def test_integration_migration_conversion(db_session) -> None:
    """Verify that existing daily_usage data can be accurately converted
    to chat_credits entries (simulating migration logic)."""
    uid = "u_int_migration"
    await _seed_profile(db_session, uid, tier="free")

    # Simulate existing daily_usage: user has used 3 deep chats over 2 days
    from datetime import date

    db_session.add(DailyUsage(
        id=str(uuid.uuid4()), user_id=uid,
        usage_date=date(2026, 3, 1), chat_count=0, deep_count=2, scan_count_monthly=0,
    ))
    db_session.add(DailyUsage(
        id=str(uuid.uuid4()), user_id=uid,
        usage_date=date(2026, 3, 2), chat_count=0, deep_count=1, scan_count_monthly=0,
    ))
    await db_session.flush()

    # Simulate migration logic: grant 5 lifetime credits minus used
    from sqlalchemy import func, select

    total_deep_stmt = (
        select(func.coalesce(func.sum(DailyUsage.deep_count), 0))
        .where(DailyUsage.user_id == uid)
    )
    result = await db_session.execute(total_deep_stmt)
    total_used = result.scalar_one()
    assert total_used == 3

    remaining = max(0, 5 - total_used)
    assert remaining == 2

    await grant_credits(
        db_session, user_id=uid, source="grant",
        amount=5, source_detail="migration-free-5",
    )
    # Manually adjust remaining to simulate pre-used credits
    from sqlalchemy import select as sa_select

    credit_stmt = sa_select(ChatCredit).where(
        ChatCredit.user_id == uid,
        ChatCredit.source_detail == "migration-free-5",
    )
    credit_result = await db_session.execute(credit_stmt)
    credit = credit_result.scalar_one()
    credit.remaining = remaining
    await db_session.flush()

    # Verify balance
    balance = await get_balance(db_session, uid)
    assert balance.total_remaining == 2
    assert balance.grant_remaining == 2

    # Can use 2 more
    for _ in range(2):
        consume_result = await consume_credit(db_session, uid)
        assert consume_result.consumed is True

    # Now exhausted
    consume_result = await consume_credit(db_session, uid)
    assert consume_result.consumed is False


# 15. Agent failure should NOT consume credits
@pytest.mark.asyncio
async def test_agent_failure_no_credit_consumed(db_session) -> None:
    """When agent call fails (502), only check_balance is called.
    consume_after_success is NOT called, so no credit is deducted."""
    uid = "u_agent_fail"
    await _seed_profile(db_session, uid, tier="free")
    await grant_credits(
        db_session, user_id=uid, source="grant",
        amount=5, source_detail="migration-free-5",
    )

    # Step 1: check_balance (pre-flight) — does NOT consume
    result = await check_balance(db_session, uid, "free")
    assert result.allowed is True
    assert result.total_remaining == 5  # Still 5 — nothing consumed

    # Step 2: Agent call fails (simulated) — consume_after_success is NOT called
    # Verify credits remain intact
    balance = await get_balance(db_session, uid)
    assert balance.total_remaining == 5  # Still 5!

    # Step 3: User retries, this time agent succeeds
    result = await check_balance(db_session, uid, "free")
    assert result.allowed is True
    consume = await consume_after_success(db_session, uid, "free")
    assert consume.credit_used_from == "grant"
    assert consume.total_remaining == 4  # Now 4 — consumed only after success


# 16. Race condition: consume_after_success with zero credits
@pytest.mark.asyncio
async def test_consume_after_success_race_condition(db_session) -> None:
    """If credits are exhausted between check_balance and consume_after_success
    (e.g., concurrent request), consume_after_success still returns allowed=True
    to avoid failing an already-completed agent response."""
    uid = "u_race"
    await _seed_profile(db_session, uid, tier="free")
    await grant_credits(
        db_session, user_id=uid, source="grant",
        amount=1, source_detail="single-credit",
    )

    # Request A: check_balance passes
    result_a = await check_balance(db_session, uid, "free")
    assert result_a.allowed is True

    # Request B: also passes check (concurrent)
    result_b = await check_balance(db_session, uid, "free")
    assert result_b.allowed is True

    # Request A: agent succeeds, consumes the last credit
    consume_a = await consume_after_success(db_session, uid, "free")
    assert consume_a.credit_used_from == "grant"
    assert consume_a.total_remaining == 0

    # Request B: agent also succeeds, but no credits left
    # Should still return allowed=True (don't fail the response)
    consume_b = await consume_after_success(db_session, uid, "free")
    assert consume_b.allowed is True  # Graceful — treated as free
    assert consume_b.credit_used_from is None  # No credit consumed
