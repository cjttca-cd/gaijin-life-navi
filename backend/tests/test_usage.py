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
    summary_count: int = 0,
    usage_date: date | None = None,
) -> None:
    profile = Profile(
        id=user_id,
        email=f"{user_id}@example.com",
        display_name="Test User",
        subscription_tier="free",
    )
    db.add(profile)

    if deep_count or summary_count:
        db.add(
            DailyUsage(
                id=str(uuid.uuid4()),
                user_id=user_id,
                usage_date=usage_date or date.today(),
                chat_count=summary_count,
                deep_count=deep_count,
                scan_count_monthly=0,
            )
        )

    await db.flush()


@pytest.mark.asyncio
@pytest.mark.parametrize(
    ("tier", "deep_used", "summary_used", "expected_allowed", "expected_depth", "expected_used", "expected_limit"),
    [
        ("guest", 0, 0, True, "summary", 1, 5),
        ("guest", 0, 4, True, "summary", 5, 5),
        ("guest", 0, 5, False, "summary", 5, 5),
        ("free", 0, 0, True, "deep", 1, 5),
        ("free", 4, 0, True, "deep", 5, 5),
        ("free", 5, 0, True, "summary", 1, 3),
        ("free", 5, 2, True, "summary", 3, 3),
        ("free", 5, 3, False, "summary", 8, 8),
        ("standard", 0, 0, True, "deep", 1, 300),
        ("standard", 299, 0, True, "deep", 300, 300),
        ("standard", 300, 0, False, "deep", 300, 300),
        ("premium", 1000, 0, True, "deep", 1001, None),
        ("premium_plus", 0, 0, True, "deep", 1, None),
        ("unknown_tier", 0, 0, False, "summary", 0, 0),
    ],
)
async def test_check_and_increment_tier_scenarios(
    db_session,
    tier: str,
    deep_used: int,
    summary_used: int,
    expected_allowed: bool,
    expected_depth: str,
    expected_used: int,
    expected_limit: int | None,
) -> None:
    user_id = f"u_{tier}_{deep_used}_{summary_used}"

    # Known tiers that touch DB need a profile row for FK integrity.
    if tier != "unknown_tier":
        await _seed_profile_and_usage(
            db_session,
            user_id,
            deep_count=deep_used,
            summary_count=summary_used,
        )

    result = await check_and_increment(db_session, user_id=user_id, tier=tier)

    assert result.allowed is expected_allowed
    assert result.depth_level == expected_depth
    assert result.used == expected_used
    assert result.limit == expected_limit
