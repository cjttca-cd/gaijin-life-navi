"""Tests for POST /api/v1/profile/trial-setup endpoint.

Tests verify:
  - Profile creation for anonymous TestFlight users (TESTFLIGHT_MODE=True)
  - 404 when TESTFLIGHT_MODE=False
  - Idempotent behavior (second call returns existing profile)
  - Trial credits are granted on first setup
"""
from __future__ import annotations

import pytest

from models.profile import Profile
from routers.profile_router import TrialSetupRequest, trial_setup
from services.auth import FirebaseUser
from services.credits import get_balance


@pytest.mark.asyncio
async def test_trial_setup_creates_profile(db_session, monkeypatch) -> None:
    """TestFlight trial-setup creates a profile for anonymous users."""
    from config import settings
    monkeypatch.setattr(settings, "TESTFLIGHT_MODE", True)

    uid = "anon-tf-user-1"
    body = TrialSetupRequest(
        nationality="CN",
        residence_status="engineer_specialist",
        residence_region="13",
    )
    current_user = FirebaseUser(uid=uid, email=None, is_anonymous=True)

    response = await trial_setup(body=body, current_user=current_user, db=db_session)
    data = response["data"]

    assert data["id"] == uid
    assert data["nationality"] == "CN"
    assert data["residence_status"] == "engineer_specialist"
    assert data["residence_region"] == "13"
    assert data["subscription_tier"] == "free"

    # Verify profile in DB
    profile = await db_session.get(Profile, uid)
    assert profile is not None
    assert profile.email == f"anon-{uid}@testflight.local"
    assert profile.nationality == "CN"


@pytest.mark.asyncio
async def test_trial_setup_returns_404_when_not_testflight(db_session, monkeypatch) -> None:
    """Trial-setup returns 404 when TESTFLIGHT_MODE is disabled."""
    from config import settings
    monkeypatch.setattr(settings, "TESTFLIGHT_MODE", False)

    from fastapi import HTTPException

    uid = "anon-tf-user-2"
    body = TrialSetupRequest(
        nationality="VN",
        residence_status="student",
        residence_region="27",
    )
    current_user = FirebaseUser(uid=uid, email=None, is_anonymous=True)

    with pytest.raises(HTTPException) as exc_info:
        await trial_setup(body=body, current_user=current_user, db=db_session)

    assert exc_info.value.status_code == 404
    assert exc_info.value.detail["error"]["code"] == "NOT_FOUND"


@pytest.mark.asyncio
async def test_trial_setup_idempotent(db_session, monkeypatch) -> None:
    """Second call to trial-setup returns existing profile without changes."""
    from config import settings
    monkeypatch.setattr(settings, "TESTFLIGHT_MODE", True)

    uid = "anon-tf-user-3"
    body = TrialSetupRequest(
        nationality="KR",
        residence_status="student",
        residence_region="26",
    )
    current_user = FirebaseUser(uid=uid, email=None, is_anonymous=True)

    # First call — creates profile
    resp1 = await trial_setup(body=body, current_user=current_user, db=db_session)
    assert resp1["data"]["nationality"] == "KR"

    # Second call with different values — should return existing profile unchanged
    body2 = TrialSetupRequest(
        nationality="JP",
        residence_status="permanent_resident",
        residence_region="13",
    )
    resp2 = await trial_setup(body=body2, current_user=current_user, db=db_session)

    # Should still be KR (idempotent — nationality was already set)
    assert resp2["data"]["nationality"] == "KR"
    assert resp2["data"]["residence_status"] == "student"


@pytest.mark.asyncio
async def test_trial_setup_grants_credits(db_session, monkeypatch) -> None:
    """Trial-setup grants 5 credits when user has none."""
    from config import settings
    monkeypatch.setattr(settings, "TESTFLIGHT_MODE", True)

    uid = "anon-tf-user-4"
    body = TrialSetupRequest(
        nationality="BR",
        residence_status="designated_activities",
        residence_region="40",
    )
    current_user = FirebaseUser(uid=uid, email=None, is_anonymous=True)

    # Verify no credits before
    balance_before = await get_balance(db_session, uid)
    assert balance_before.total_remaining == 0

    # Call trial-setup
    await trial_setup(body=body, current_user=current_user, db=db_session)

    # Verify 5 credits granted
    balance_after = await get_balance(db_session, uid)
    assert balance_after.total_remaining == 5
    assert balance_after.grant_remaining == 5
