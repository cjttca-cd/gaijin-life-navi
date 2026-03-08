"""Usage service tests — Credit Ledger based.

Tests verify the check_balance function works correctly with the
Credit Ledger system for all tier scenarios.
"""

from __future__ import annotations

import uuid
from datetime import datetime, timedelta, timezone

import pytest

from models.chat_credit import ChatCredit
from models.daily_usage import DailyUsage
from models.profile import Profile
from services.usage import check_balance, consume_after_success


def _now() -> datetime:
    return datetime.now(timezone.utc)


async def _seed_profile(db, user_id: str, tier: str = "free") -> None:
    profile = Profile(
        id=user_id,
        email=f"{user_id}@example.com",
        display_name="Test User",
        subscription_tier=tier,
    )
    db.add(profile)
    await db.flush()


async def _seed_credits(
    db, user_id: str, *, source: str = "grant",
    amount: int = 5, remaining: int | None = None,
    expires_at: datetime | None = None,
) -> None:
    db.add(ChatCredit(
        id=str(uuid.uuid4()),
        user_id=user_id,
        source=source,
        initial_amount=amount,
        remaining=remaining if remaining is not None else amount,
        expires_at=expires_at,
    ))
    await db.flush()


@pytest.mark.asyncio
@pytest.mark.parametrize(
    ("tier", "has_credits", "expected_allowed"),
    [
        # Guest — AI Chat blocked
        ("guest", False, False),
        # Free — with credits: allowed
        ("free", True, True),
        # Free — no credits: re-engagement kicks in (first time = allowed)
        ("free", False, True),
        # Standard — with credits: allowed
        ("standard", True, True),
        # Standard — no credits: blocked (re-engagement only for free)
        ("standard", False, False),
        # Premium — always allowed (no credits needed)
        ("premium", False, True),
        ("premium_plus", False, True),
        # Unknown tier — blocked
        ("unknown_tier", False, False),
    ],
)
async def test_check_balance_tier_scenarios(
    db_session,
    tier: str,
    has_credits: bool,
    expected_allowed: bool,
) -> None:
    user_id = f"u_{tier}_{has_credits}"

    # Create profile for known tiers
    if tier not in ("guest", "unknown_tier"):
        await _seed_profile(db_session, user_id, tier=tier)

    if has_credits:
        await _seed_credits(db_session, user_id, amount=5)

    result = await check_balance(db_session, user_id=user_id, tier=tier)
    assert result.allowed is expected_allowed


@pytest.mark.asyncio
async def test_premium_does_not_consume_credits(db_session) -> None:
    """Premium users should not consume credits even if some exist."""
    uid = "u_premium_no_consume"
    await _seed_profile(db_session, uid, tier="premium")
    await _seed_credits(db_session, uid, amount=10)

    result = await check_balance(db_session, uid, "premium")
    assert result.allowed is True
    assert result.credit_used_from is None
    assert result.limit is None


@pytest.mark.asyncio
async def test_deep_count_incremented_on_consume(db_session) -> None:
    """deep_count in daily_usage should be incremented for analytics."""
    uid = "u_analytics"
    await _seed_profile(db_session, uid, tier="free")
    await _seed_credits(db_session, uid, amount=5)

    result = await check_balance(db_session, uid, "free")
    assert result.allowed is True

    # check_balance does NOT increment deep_count — consume_after_success does
    consume = await consume_after_success(db_session, uid, "free")
    assert consume.allowed is True

    # Verify deep_count was incremented by consume_after_success
    from datetime import date
    from sqlalchemy import select

    stmt = select(DailyUsage).where(
        DailyUsage.user_id == uid,
        DailyUsage.usage_date == date.today(),
    )
    db_result = await db_session.execute(stmt)
    daily = db_result.scalar_one()
    assert daily.deep_count == 1


@pytest.mark.asyncio
async def test_credit_used_from_in_result(db_session) -> None:
    """check_balance should return which source was consumed."""
    uid = "u_source_tracking"
    await _seed_profile(db_session, uid, tier="standard")
    await _seed_credits(
        db_session, uid, source="subscription", amount=300,
        expires_at=_now() + timedelta(days=30),
    )

    result = await check_balance(db_session, uid, "standard")
    assert result.allowed is True
    # check_balance doesn't consume — credit_used_from is None
    assert result.total_remaining == 300

    # consume_after_success returns the source
    consume = await consume_after_success(db_session, uid, "standard")
    assert consume.credit_used_from == "subscription"
    assert consume.total_remaining == 299
