from __future__ import annotations

import pytest

from models.profile import Profile
from routers import chat as chat_router
from services.agent import AgentResponse
from services.auth import FirebaseUser
from services.usage import UsageCheck


@pytest.mark.asyncio
async def test_chat_summary_mode_strips_profile_and_returns_depth_level(
    db_session,
    monkeypatch,
) -> None:
    uid = "chat-user-1"
    db_session.add(
        Profile(
            id=uid,
            email="chat-user-1@example.com",
            display_name="Taro",
            subscription_tier="free",
            nationality="JP",
            residence_status="留学",
            residence_region="東京都",
            preferred_language="ja",
        )
    )
    await db_session.flush()

    captured: dict[str, object] = {}

    async def fake_check_and_increment(db, user_id: str, tier: str):  # noqa: ANN001
        assert user_id == uid
        assert tier == "free"
        return UsageCheck(
            allowed=True,
            used=6,
            limit=8,
            tier="free",
            period="lifetime",
            depth_level="summary",
        )

    async def fake_route_to_agent(message: str, current_domain=None, context=None):  # noqa: ANN001
        return "svc-life"

    async def fake_call_agent(**kwargs):  # noqa: ANN003
        captured["user_profile"] = kwargs.get("user_profile")
        captured["depth_level"] = kwargs.get("depth_level")
        return AgentResponse(
            text="一般的な案内です",
            model="stub",
            duration_ms=10,
            input_tokens=10,
            output_tokens=20,
            cache_read_tokens=0,
            status="ok",
        )

    monkeypatch.setattr(chat_router, "check_and_increment", fake_check_and_increment)

    import services.agent as agent_service

    monkeypatch.setattr(agent_service, "route_to_agent", fake_route_to_agent)
    monkeypatch.setattr(agent_service, "call_agent", fake_call_agent)

    body = chat_router.ChatRequest(message="教えてください", locale="ja")
    current_user = FirebaseUser(uid=uid, email="chat-user-1@example.com", is_anonymous=False)

    response = await chat_router.chat(body=body, current_user=current_user, db=db_session)
    data = response["data"]

    assert data["depth_level"] == "summary"
    assert data["usage"]["depth_level"] == "summary"
    assert captured["depth_level"] == "summary"

    user_profile = captured["user_profile"]
    assert isinstance(user_profile, dict)
    assert "nationality" not in user_profile
    assert "residence_status" not in user_profile
    assert "residence_region" not in user_profile
