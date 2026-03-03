from __future__ import annotations

import uuid
from datetime import date

import pytest

from models.daily_usage import DailyUsage
from models.profile import Profile
from services.usage import check_and_increment


async def _seed_profile_and_usage(
    db,
    user_id: str,
    *,
    deep_count: int = 0,
    usage_date: date | None = None,
) -> None:
    profile = Profile(
        id=user_id,
        email=f"{user_id}@example.com",
        display_name="Test User",
        subscription_tier="free",
    )
    db.add(profile)

    if deep_count:
        db.add(
            DailyUsage(
                id=str(uuid.uuid4()),
                user_id=user_id,
                usage_date=usage_date or date.today(),
                chat_count=0,
                deep_count=deep_count,
                scan_count_monthly=0,
            )
        )

    await db.flush()


@pytest.mark.asyncio
@pytest.mark.parametrize(
    ("tier", "deep_used", "expected_allowed", "expected_used", "expected_limit"),
    [
        # Guest — AI Chat blocked (0 deep)
        ("guest", 0, False, 0, 0),
        # Free — deep only (5 lifetime)
        ("free", 0, True, 1, 5),
        ("free", 4, True, 5, 5),
        ("free", 5, False, 5, 5),
        # Standard — deep 300/month
        ("standard", 0, True, 1, 300),
        ("standard", 299, True, 300, 300),
        ("standard", 300, False, 300, 300),
        # Premium — unlimited
        ("premium", 1000, True, 1001, None),
        ("premium_plus", 0, True, 1, None),
        # Unknown tier — blocked
        ("unknown_tier", 0, False, 0, 0),
    ],
)
async def test_check_and_increment_tier_scenarios(
    db_session,
    tier: str,
    deep_used: int,
    expected_allowed: bool,
    expected_used: int,
    expected_limit: int | None,
) -> None:
    user_id = f"u_{tier}_{deep_used}"

    # Known tiers that touch DB need a profile row for FK integrity.
    if tier != "unknown_tier":
        await _seed_profile_and_usage(
            db_session,
            user_id,
            deep_count=deep_used,
        )

    result = await check_and_increment(db_session, user_id=user_id, tier=tier)

    assert result.allowed is expected_allowed
    assert result.used == expected_used
    assert result.limit == expected_limit
