from __future__ import annotations

from models.profile import SubscriptionTier


def test_subscription_tier_enum_members_and_values() -> None:
    expected = {
        "GUEST": "guest",
        "FREE": "free",
        "STANDARD": "standard",
        "PREMIUM": "premium",
        "PREMIUM_PLUS": "premium_plus",
    }

    actual = {name: member.value for name, member in SubscriptionTier.__members__.items()}

    assert actual == expected
