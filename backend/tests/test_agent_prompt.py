from __future__ import annotations

import pytest

from services.agent import call_agent


def _make_mock_response(text: str = "ok") -> dict:
    """Build a mock OpenAI-compatible chat completion response."""
    return {
        "choices": [
            {
                "message": {"role": "assistant", "content": text},
                "finish_reason": "stop",
            }
        ],
        "usage": {
            "prompt_tokens": 10,
            "completion_tokens": 20,
        },
        "model": "stub-model",
    }


async def _capture_messages(monkeypatch) -> list[dict]:
    """Call call_agent with a profile and capture the messages sent to the LLM."""
    captured: dict[str, object] = {}

    async def fake_chat_completion(messages, model, timeout=None, max_tokens=None):
        captured["messages"] = messages
        captured["model"] = model
        return _make_mock_response()

    async def fake_with_fallback(messages, primary_model, fallback_model, timeout=None, max_tokens=None):
        captured["messages"] = messages
        captured["primary_model"] = primary_model
        return _make_mock_response(), primary_model

    import services.agent as agent_module
    monkeypatch.setattr(agent_module, "_chat_completion_with_fallback", fake_with_fallback)

    resp = await call_agent(
        agent_id="svc-life",
        message="口座開設について教えて",
        user_profile={
            "display_name": "Alice",
            "subscription_tier": "free",
            "nationality": "JP",
            "residence_status": "留学",
            "residence_region": "東京都",
            "preferred_language": "ja",
        },
    )

    assert resp.status == "ok"
    return captured["messages"]


@pytest.mark.asyncio
async def test_prompt_contains_deep_annotation_and_profile_fields(monkeypatch) -> None:
    messages = await _capture_messages(monkeypatch)

    # Messages should have system + user
    assert len(messages) == 2
    assert messages[0]["role"] == "system"
    assert messages[1]["role"] == "user"

    user_content = messages[1]["content"]

    assert "回答深度: 深度級" in user_content
    assert "国籍: JP" in user_content
    assert "在留資格: 留学" in user_content
    assert "居住地域: 東京都" in user_content


@pytest.mark.asyncio
async def test_system_prompt_contains_agent_instructions(monkeypatch) -> None:
    messages = await _capture_messages(monkeypatch)

    system_content = messages[0]["content"]
    # Should contain svc-life AGENTS.md content
    assert "svc-life" in system_content or "Life Navigator" in system_content or "Response Format" in system_content


@pytest.mark.asyncio
async def test_image_path_deferred(monkeypatch) -> None:
    """Image analysis should be deferred with a text note."""
    captured: dict[str, object] = {}

    async def fake_with_fallback(messages, primary_model, fallback_model, timeout=None, max_tokens=None):
        captured["messages"] = messages
        return _make_mock_response(), primary_model

    import services.agent as agent_module
    monkeypatch.setattr(agent_module, "_chat_completion_with_fallback", fake_with_fallback)

    resp = await call_agent(
        agent_id="svc-life",
        message="この書類は何ですか",
        image_path="/tmp/test-image.jpg",
    )

    assert resp.status == "ok"
    user_content = captured["messages"][1]["content"]
    assert "image analysis not yet supported" in user_content


@pytest.mark.asyncio
async def test_context_included_in_user_message(monkeypatch) -> None:
    """Conversation context should be included in the user message."""
    captured: dict[str, object] = {}

    async def fake_with_fallback(messages, primary_model, fallback_model, timeout=None, max_tokens=None):
        captured["messages"] = messages
        return _make_mock_response(), primary_model

    import services.agent as agent_module
    monkeypatch.setattr(agent_module, "_chat_completion_with_fallback", fake_with_fallback)

    resp = await call_agent(
        agent_id="svc-life",
        message="それで次は？",
        context=[
            {"role": "user", "text": "銀行口座を開きたい"},
            {"role": "assistant", "text": "在留カードが必要です"},
        ],
    )

    assert resp.status == "ok"
    user_content = captured["messages"][1]["content"]
    assert "銀行口座を開きたい" in user_content
    assert "在留カードが必要です" in user_content
    assert "それで次は？" in user_content
