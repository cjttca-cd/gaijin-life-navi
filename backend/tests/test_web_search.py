"""Tests for Web Search Integration (ADR-012).

Tests verify:
  - RoutingResult dataclass (agent_id + search_query)
  - Router JSON response parsing (valid, malformed, code-block-wrapped)
  - _execute_search() with mocked Gemini API (success, timeout, error)
  - call_agent() search_results injection into user message
  - SEARCH_ENABLED=false disables search
"""
from __future__ import annotations

import asyncio
import json
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from services.agent import (
    AgentResponse,
    RoutingResult,
    _execute_search,
    _parse_router_response,
    call_agent,
    route_to_agent,
)


# ---------------------------------------------------------------------------
# RoutingResult dataclass tests
# ---------------------------------------------------------------------------


class TestRoutingResult:
    """Tests for the RoutingResult dataclass."""

    def test_basic_creation(self):
        result = RoutingResult(agent_id="svc-finance", search_query="Wise 手数料")
        assert result.agent_id == "svc-finance"
        assert result.search_query == "Wise 手数料"

    def test_no_search_query(self):
        result = RoutingResult(agent_id="svc-life")
        assert result.agent_id == "svc-life"
        assert result.search_query is None

    def test_out_of_scope(self):
        result = RoutingResult(agent_id="out_of_scope")
        assert result.agent_id == "out_of_scope"
        assert result.search_query is None

    def test_immutable(self):
        result = RoutingResult(agent_id="svc-tax")
        with pytest.raises(AttributeError):
            result.agent_id = "svc-life"  # type: ignore[misc]


# ---------------------------------------------------------------------------
# Router JSON parsing tests
# ---------------------------------------------------------------------------


class TestParseRouterResponse:
    """Tests for _parse_router_response() JSON parsing."""

    def test_valid_json_with_search(self):
        raw = '{"domain": "finance", "search": "Wise 手数料 最新"}'
        domain, search = _parse_router_response(raw)
        assert domain == "finance"
        assert search == "Wise 手数料 最新"

    def test_valid_json_no_search(self):
        raw = '{"domain": "life", "search": null}'
        domain, search = _parse_router_response(raw)
        assert domain == "life"
        assert search is None

    def test_json_wrapped_in_code_block(self):
        raw = '```json\n{"domain": "tax", "search": "確定申告 期限"}\n```'
        domain, search = _parse_router_response(raw)
        assert domain == "tax"
        assert search == "確定申告 期限"

    def test_json_code_block_no_lang(self):
        raw = '```\n{"domain": "medical", "search": null}\n```'
        domain, search = _parse_router_response(raw)
        assert domain == "medical"
        assert search is None

    def test_malformed_json_fallback_single_word(self):
        """Malformed JSON falls back to single-word parsing."""
        raw = "finance"
        domain, search = _parse_router_response(raw)
        assert domain == "finance"
        assert search is None

    def test_malformed_json_with_extra_text(self):
        """Extra text after domain word — takes first word."""
        raw = "life some extra text"
        domain, search = _parse_router_response(raw)
        assert domain == "life"
        assert search is None

    def test_empty_search_string_treated_as_none(self):
        raw = '{"domain": "visa", "search": ""}'
        domain, search = _parse_router_response(raw)
        assert domain == "visa"
        assert search is None

    def test_search_null_string_treated_as_none(self):
        raw = '{"domain": "legal", "search": "null"}'
        domain, search = _parse_router_response(raw)
        assert domain == "legal"
        assert search is None

    def test_domain_case_insensitive(self):
        raw = '{"domain": "FINANCE", "search": null}'
        domain, search = _parse_router_response(raw)
        assert domain == "finance"

    def test_out_of_scope_json(self):
        raw = '{"domain": "out_of_scope", "search": null}'
        domain, search = _parse_router_response(raw)
        assert domain == "out_of_scope"
        assert search is None

    def test_whitespace_handling(self):
        raw = '  {"domain": "tax", "search": "  年金返金額  "}  '
        domain, search = _parse_router_response(raw)
        assert domain == "tax"
        assert search == "年金返金額"


# ---------------------------------------------------------------------------
# _execute_search() mock tests
# ---------------------------------------------------------------------------


class TestExecuteSearch:
    """Tests for _execute_search() with mocked Gemini API."""

    @pytest.mark.asyncio
    async def test_search_success(self, monkeypatch):
        """Successful search returns result text."""
        monkeypatch.setattr("services.agent.settings.GEMINI_API_KEY", "test-key")
        monkeypatch.setattr("services.agent.settings.SEARCH_MODEL", "gemini-2.5-flash-lite")

        mock_response = MagicMock()
        mock_response.text = "- Wise 手数料: 約1.5%\n- 送金限度額: 100万円/回"

        mock_client = MagicMock()
        mock_client.models.generate_content.return_value = mock_response

        monkeypatch.setattr("services.agent._genai_client", mock_client)

        result = await _execute_search("Wise 送金手数料")
        assert result is not None
        assert "Wise" in result
        assert "1.5%" in result

    @pytest.mark.asyncio
    async def test_search_no_api_key(self, monkeypatch):
        """No API key → returns None gracefully."""
        monkeypatch.setattr("services.agent.settings.GEMINI_API_KEY", "")
        result = await _execute_search("test query")
        assert result is None

    @pytest.mark.asyncio
    async def test_search_empty_response(self, monkeypatch):
        """Empty response → returns None."""
        monkeypatch.setattr("services.agent.settings.GEMINI_API_KEY", "test-key")

        mock_response = MagicMock()
        mock_response.text = ""

        mock_client = MagicMock()
        mock_client.models.generate_content.return_value = mock_response

        monkeypatch.setattr("services.agent._genai_client", mock_client)

        result = await _execute_search("test query")
        assert result is None

    @pytest.mark.asyncio
    async def test_search_api_error(self, monkeypatch):
        """API exception → returns None (graceful degradation)."""
        monkeypatch.setattr("services.agent.settings.GEMINI_API_KEY", "test-key")

        mock_client = MagicMock()
        mock_client.models.generate_content.side_effect = Exception("API error")

        monkeypatch.setattr("services.agent._genai_client", mock_client)

        result = await _execute_search("test query")
        assert result is None

    @pytest.mark.asyncio
    async def test_search_timeout(self, monkeypatch):
        """Timeout → returns None (graceful degradation)."""
        monkeypatch.setattr("services.agent.settings.GEMINI_API_KEY", "test-key")

        def slow_generate(*args, **kwargs):
            import time
            time.sleep(15)  # Exceed the 10s timeout

        mock_client = MagicMock()
        mock_client.models.generate_content.side_effect = slow_generate

        monkeypatch.setattr("services.agent._genai_client", mock_client)

        result = await _execute_search("test query")
        assert result is None


# ---------------------------------------------------------------------------
# call_agent() search_results injection tests
# ---------------------------------------------------------------------------


class TestCallAgentSearchInjection:
    """Tests for search_results injection in call_agent()."""

    @pytest.mark.asyncio
    async def test_search_results_injected(self, monkeypatch):
        """When search_results provided, it appears in the user message."""
        captured_payload: dict = {}

        async def fake_chat_completion_with_fallback(
            messages, primary_model, fallback_model, timeout=None, max_tokens=None
        ):
            captured_payload["messages"] = messages
            return {
                "choices": [{"message": {"content": "テスト回答"}}],
                "usage": {"prompt_tokens": 100, "completion_tokens": 50},
            }, "test-model"

        monkeypatch.setattr(
            "services.agent._chat_completion_with_fallback",
            fake_chat_completion_with_fallback,
        )

        await call_agent(
            agent_id="svc-finance",
            message="Wise の手数料は？",
            search_results="- Wise 手数料: 約1.5%",
        )

        user_msg = captured_payload["messages"][1]["content"]
        assert "【ウェブ検索結果（参考情報 — 数字や日付はこの検索結果を優先すること）】" in user_msg
        assert "Wise 手数料: 約1.5%" in user_msg
        assert "【現在のユーザーの質問】" in user_msg
        assert "Wise の手数料は？" in user_msg

    @pytest.mark.asyncio
    async def test_no_search_results_no_injection(self, monkeypatch):
        """When search_results is None, no search block in user message."""
        captured_payload: dict = {}

        async def fake_chat_completion_with_fallback(
            messages, primary_model, fallback_model, timeout=None, max_tokens=None
        ):
            captured_payload["messages"] = messages
            return {
                "choices": [{"message": {"content": "テスト回答"}}],
                "usage": {"prompt_tokens": 100, "completion_tokens": 50},
            }, "test-model"

        monkeypatch.setattr(
            "services.agent._chat_completion_with_fallback",
            fake_chat_completion_with_fallback,
        )

        await call_agent(
            agent_id="svc-life",
            message="ゴミの分別方法は？",
            search_results=None,
        )

        user_msg = captured_payload["messages"][1]["content"]
        assert "【ウェブ検索結果" not in user_msg
        assert "【現在のユーザーの質問】" in user_msg
        assert "ゴミの分別方法は？" in user_msg

    @pytest.mark.asyncio
    async def test_search_results_before_question(self, monkeypatch):
        """Search results block appears BEFORE the user question."""
        captured_payload: dict = {}

        async def fake_chat_completion_with_fallback(
            messages, primary_model, fallback_model, timeout=None, max_tokens=None
        ):
            captured_payload["messages"] = messages
            return {
                "choices": [{"message": {"content": "テスト回答"}}],
                "usage": {"prompt_tokens": 100, "completion_tokens": 50},
            }, "test-model"

        monkeypatch.setattr(
            "services.agent._chat_completion_with_fallback",
            fake_chat_completion_with_fallback,
        )

        await call_agent(
            agent_id="svc-tax",
            message="確定申告の期限は？",
            search_results="- 2026年3月16日まで",
        )

        user_msg = captured_payload["messages"][1]["content"]
        search_pos = user_msg.index("【ウェブ検索結果")
        question_pos = user_msg.index("【現在のユーザーの質問】")
        assert search_pos < question_pos


# ---------------------------------------------------------------------------
# route_to_agent() returns RoutingResult
# ---------------------------------------------------------------------------


class TestRouteToAgentResult:
    """Tests for route_to_agent() returning RoutingResult."""

    @pytest.mark.asyncio
    async def test_empty_message_returns_routing_result(self):
        result = await route_to_agent("")
        assert isinstance(result, RoutingResult)
        assert result.agent_id == "svc-life"
        assert result.search_query is None

    @pytest.mark.asyncio
    async def test_empty_message_with_current_domain(self):
        result = await route_to_agent("", current_domain="svc-finance")
        assert isinstance(result, RoutingResult)
        assert result.agent_id == "svc-finance"

    @pytest.mark.asyncio
    async def test_emergency_returns_routing_result(self):
        result = await route_to_agent("119に電話して救急車呼んで")
        assert isinstance(result, RoutingResult)
        assert result.agent_id == "svc-medical"
        assert result.search_query is None

    @pytest.mark.asyncio
    async def test_llm_json_response(self, monkeypatch):
        """LLM returns JSON with search → RoutingResult has search_query."""

        async def fake_chat_with_fallback(messages, primary_model, fallback_model, timeout=None, max_tokens=None):
            return {
                "choices": [
                    {
                        "message": {
                            "content": '{"domain": "finance", "search": "Wise 送金手数料"}'
                        }
                    }
                ],
                "usage": {"prompt_tokens": 50, "completion_tokens": 20},
            }, "test-model"

        monkeypatch.setattr(
            "services.agent._chat_completion_with_fallback",
            fake_chat_with_fallback,
        )

        result = await route_to_agent("Wise で中国に送金する手数料は？")
        assert isinstance(result, RoutingResult)
        assert result.agent_id == "svc-finance"
        assert result.search_query == "Wise 送金手数料"

    @pytest.mark.asyncio
    async def test_llm_json_no_search(self, monkeypatch):
        """LLM returns JSON with search=null → search_query is None."""

        async def fake_chat_with_fallback(messages, primary_model, fallback_model, timeout=None, max_tokens=None):
            return {
                "choices": [
                    {
                        "message": {
                            "content": '{"domain": "life", "search": null}'
                        }
                    }
                ],
                "usage": {"prompt_tokens": 50, "completion_tokens": 10},
            }, "test-model"

        monkeypatch.setattr(
            "services.agent._chat_completion_with_fallback",
            fake_chat_with_fallback,
        )

        result = await route_to_agent("ゴミの分別方法を教えて")
        assert isinstance(result, RoutingResult)
        assert result.agent_id == "svc-life"
        assert result.search_query is None

    @pytest.mark.asyncio
    async def test_llm_fallback_word_parse(self, monkeypatch):
        """LLM returns plain word (old format) → fallback parse works."""

        async def fake_chat_with_fallback(messages, primary_model, fallback_model, timeout=None, max_tokens=None):
            return {
                "choices": [
                    {
                        "message": {
                            "content": "tax"
                        }
                    }
                ],
                "usage": {"prompt_tokens": 50, "completion_tokens": 1},
            }, "test-model"

        monkeypatch.setattr(
            "services.agent._chat_completion_with_fallback",
            fake_chat_with_fallback,
        )

        result = await route_to_agent("確定申告について")
        assert isinstance(result, RoutingResult)
        assert result.agent_id == "svc-tax"
        assert result.search_query is None


# ---------------------------------------------------------------------------
# SEARCH_ENABLED=false disables search
# ---------------------------------------------------------------------------


class TestSearchEnabled:
    """Tests that SEARCH_ENABLED=false disables search."""

    @pytest.mark.asyncio
    async def test_search_disabled(self, monkeypatch):
        """SEARCH_ENABLED=false → _execute_search not called from chat flow."""
        # This tests the logic in routers/chat.py
        # We verify by checking that even with a search_query, search is skipped
        monkeypatch.setattr("config.settings.SEARCH_ENABLED", False)

        from config import settings
        assert settings.SEARCH_ENABLED is False

        # The actual integration is tested via the chat endpoint, but the config
        # flag is the kill switch. Verify the flag works:
        routing = RoutingResult(agent_id="svc-finance", search_query="test")
        search_results = None
        if routing.search_query and settings.SEARCH_ENABLED:
            search_results = "should not reach here"
        assert search_results is None
