"""Tests for the SSE streaming chat endpoint (/api/v1/chat/stream).

Verifies:
  - SSE event format (routing, searching, token, done, error)
  - Stream generator orchestration
  - Credit check before stream, consume after stream
  - Existing /chat endpoint unchanged (backward compat)
  - Out-of-scope handling
  - Error handling
"""
from __future__ import annotations

import json

import pytest
from fastapi import HTTPException

from models.profile import Profile
from routers import chat as chat_router
from services.agent import AgentResponse, RoutingResult
from services.auth import FirebaseUser
from services.usage import UsageCheck


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _parse_sse_events(raw: str) -> list[dict]:
    """Parse raw SSE text into a list of {event, data} dicts."""
    events = []
    current_event = None
    current_data = None

    for line in raw.split("\n"):
        if line.startswith("event: "):
            current_event = line[7:].strip()
        elif line.startswith("data: "):
            current_data = line[6:].strip()
        elif line == "" and current_event is not None:
            try:
                data_parsed = json.loads(current_data) if current_data else {}
            except json.JSONDecodeError:
                data_parsed = {"raw": current_data}
            events.append({"event": current_event, "data": data_parsed})
            current_event = None
            current_data = None

    return events


async def _collect_stream(generator) -> list[str]:
    """Collect all chunks from an async generator."""
    chunks = []
    async for chunk in generator:
        chunks.append(chunk)
    return chunks


def _parse_all_events(chunks: list[str]) -> list[dict]:
    """Parse SSE events from collected chunks."""
    combined = "".join(chunks)
    return _parse_sse_events(combined)


# ---------------------------------------------------------------------------
# Test: SSE event format
# ---------------------------------------------------------------------------


class TestSSEEventFormat:
    """Verify SSE events follow the spec format."""

    def test_routing_event_format(self):
        event_str = 'event: routing\ndata: {"domain": "finance", "search_query": "Wise"}\n\n'
        events = _parse_sse_events(event_str)
        assert len(events) == 1
        assert events[0]["event"] == "routing"
        assert events[0]["data"]["domain"] == "finance"

    def test_searching_event_format(self):
        event_str = "event: searching\ndata: {}\n\n"
        events = _parse_sse_events(event_str)
        assert len(events) == 1
        assert events[0]["event"] == "searching"

    def test_token_event_format(self):
        event_str = 'event: token\ndata: {"text": "\u3053\u3093\u306b\u3061\u306f"}\n\n'
        events = _parse_sse_events(event_str)
        assert len(events) == 1
        assert events[0]["event"] == "token"
        assert events[0]["data"]["text"] == "\u3053\u3093\u306b\u3061\u306f"

    def test_done_event_format(self):
        event_str = (
            'event: done\n'
            'data: {"text": "reply", "domain": "finance", "sources": [], '
            '"tracker_items": [], "usage": {"used": 1, "limit": 5, "tier": "free"}}\n\n'
        )
        events = _parse_sse_events(event_str)
        assert len(events) == 1
        assert events[0]["event"] == "done"
        assert events[0]["data"]["domain"] == "finance"
        assert "usage" in events[0]["data"]

    def test_error_event_format(self):
        event_str = 'event: error\ndata: {"message": "Agent timed out"}\n\n'
        events = _parse_sse_events(event_str)
        assert len(events) == 1
        assert events[0]["event"] == "error"
        assert "timed out" in events[0]["data"]["message"]


# ---------------------------------------------------------------------------
# Test: Stream generator orchestration
# ---------------------------------------------------------------------------


class TestStreamGenerator:
    """Test _stream_generator orchestration logic."""

    @pytest.mark.asyncio
    async def test_normal_flow_routing_token_done(self, db_session, monkeypatch):
        """Normal flow: routing -> token(s) -> done."""
        uid = "stream-user-1"
        db_session.add(
            Profile(id=uid, email="s1@example.com", display_name="Taro", subscription_tier="free")
        )
        await db_session.flush()

        async def fake_route(message, current_domain=None, context=None):
            return RoutingResult(agent_id="svc-finance")

        async def fake_search(query):
            return None

        async def fake_stream(**kwargs):
            yield 'event: token\ndata: {"text": "Hello"}\n\n'
            yield 'event: token\ndata: {"text": " world"}\n\n'
            yield 'event: __meta__\ndata: {"model": "test", "duration_ms": 100, "input_tokens": 10, "output_tokens": 5}\n\n'

        import services.agent as agent_mod
        monkeypatch.setattr(agent_mod, "route_to_agent", fake_route)
        monkeypatch.setattr(agent_mod, "_execute_search", fake_search)
        monkeypatch.setattr(agent_mod, "call_agent_stream", fake_stream)

        async def fake_consume(db, user_id, tier):
            return UsageCheck(allowed=True, used=1, limit=5, tier="free", period="lifetime")

        monkeypatch.setattr(chat_router, "consume_after_success", fake_consume)

        body = chat_router.ChatRequest(message="Wise fees?", locale="ja")
        usage = UsageCheck(allowed=True, used=0, limit=5, tier="free", period="lifetime")

        chunks = await _collect_stream(
            chat_router._stream_generator(body, uid, "free", usage, db_session)
        )
        events = _parse_all_events(chunks)

        event_types = [e["event"] for e in events]
        assert event_types[0] == "routing"
        assert "token" in event_types
        assert event_types[-1] == "done"

        done = events[-1]["data"]
        assert done["domain"] == "finance"
        assert "usage" in done
        assert done["text"] == "Hello world"

    @pytest.mark.asyncio
    async def test_out_of_scope_immediate_done(self, db_session, monkeypatch):
        """Out-of-scope: routing -> done (no tokens)."""
        uid = "stream-user-oos"
        db_session.add(Profile(id=uid, email="oos@example.com", subscription_tier="free"))
        await db_session.flush()

        async def fake_route(message, current_domain=None, context=None):
            return RoutingResult(agent_id="out_of_scope")

        import services.agent as agent_mod
        monkeypatch.setattr(agent_mod, "route_to_agent", fake_route)

        body = chat_router.ChatRequest(message="What is 2+2?", locale="en")
        usage = UsageCheck(allowed=True, used=0, limit=5, tier="free", period="lifetime")

        chunks = await _collect_stream(
            chat_router._stream_generator(body, uid, "free", usage, db_session)
        )
        events = _parse_all_events(chunks)

        event_types = [e["event"] for e in events]
        assert event_types == ["routing", "done"]
        assert "Japan life guide" in events[-1]["data"]["text"]

    @pytest.mark.asyncio
    async def test_search_emits_searching_event(self, db_session, monkeypatch):
        """Search triggers a searching event before tokens."""
        uid = "stream-user-search"
        db_session.add(Profile(id=uid, email="search@example.com", subscription_tier="free"))
        await db_session.flush()

        async def fake_route(message, current_domain=None, context=None):
            return RoutingResult(agent_id="svc-finance", search_query="Wise fees 2026")

        async def fake_search(query):
            return "Wise fee: 0.5%"

        async def fake_stream(**kwargs):
            yield 'event: token\ndata: {"text": "Fee info"}\n\n'
            yield 'event: __meta__\ndata: {"model": "test", "duration_ms": 50, "input_tokens": 5, "output_tokens": 3}\n\n'

        import services.agent as agent_mod
        monkeypatch.setattr(agent_mod, "route_to_agent", fake_route)
        monkeypatch.setattr(agent_mod, "_execute_search", fake_search)
        monkeypatch.setattr(agent_mod, "call_agent_stream", fake_stream)

        from config import settings
        monkeypatch.setattr(settings, "SEARCH_ENABLED", True)

        async def fake_consume(db, user_id, tier):
            return UsageCheck(allowed=True, used=1, limit=5, tier="free", period="lifetime")
        monkeypatch.setattr(chat_router, "consume_after_success", fake_consume)

        body = chat_router.ChatRequest(message="Wise fees?", locale="en")
        usage = UsageCheck(allowed=True, used=0, limit=5, tier="free", period="lifetime")

        chunks = await _collect_stream(
            chat_router._stream_generator(body, uid, "free", usage, db_session)
        )
        events = _parse_all_events(chunks)
        event_types = [e["event"] for e in events]
        assert "searching" in event_types
        assert event_types.index("searching") < event_types.index("token")

    @pytest.mark.asyncio
    async def test_error_event_forwarded(self, db_session, monkeypatch):
        """Agent error yields error event, no done event."""
        uid = "stream-user-err"
        db_session.add(Profile(id=uid, email="err@example.com", subscription_tier="free"))
        await db_session.flush()

        async def fake_route(message, current_domain=None, context=None):
            return RoutingResult(agent_id="svc-life")

        async def fake_search(query):
            return None

        async def fake_stream(**kwargs):
            yield 'event: error\ndata: {"message": "Agent timed out after 90s"}\n\n'

        import services.agent as agent_mod
        monkeypatch.setattr(agent_mod, "route_to_agent", fake_route)
        monkeypatch.setattr(agent_mod, "_execute_search", fake_search)
        monkeypatch.setattr(agent_mod, "call_agent_stream", fake_stream)

        body = chat_router.ChatRequest(message="Help", locale="en")
        usage = UsageCheck(allowed=True, used=0, limit=5, tier="free", period="lifetime")

        chunks = await _collect_stream(
            chat_router._stream_generator(body, uid, "free", usage, db_session)
        )
        events = _parse_all_events(chunks)
        event_types = [e["event"] for e in events]
        assert "error" in event_types
        assert "done" not in event_types

    @pytest.mark.asyncio
    async def test_tracker_items_parsed_after_stream(self, db_session, monkeypatch):
        """Tracker items are parsed from full text after stream completes."""
        uid = "stream-user-tracker"
        db_session.add(Profile(id=uid, email="trk@example.com", subscription_tier="free"))
        await db_session.flush()

        async def fake_route(message, current_domain=None, context=None):
            return RoutingResult(agent_id="svc-life")

        async def fake_search(query):
            return None

        text = "Do this:\n\u25a1 Go to city hall (within 14 days)\n\u25a1 Apply for health insurance"

        async def fake_stream(**kwargs):
            yield f'event: token\ndata: {json.dumps({"text": text})}\n\n'
            yield 'event: __meta__\ndata: {"model": "test", "duration_ms": 100, "input_tokens": 10, "output_tokens": 20}\n\n'

        import services.agent as agent_mod
        monkeypatch.setattr(agent_mod, "route_to_agent", fake_route)
        monkeypatch.setattr(agent_mod, "_execute_search", fake_search)
        monkeypatch.setattr(agent_mod, "call_agent_stream", fake_stream)

        async def fake_consume(db, user_id, tier):
            return UsageCheck(allowed=True, used=1, limit=5, tier="free", period="lifetime")
        monkeypatch.setattr(chat_router, "consume_after_success", fake_consume)

        body = chat_router.ChatRequest(message="Moving to Japan", locale="en")
        usage = UsageCheck(allowed=True, used=0, limit=5, tier="free", period="lifetime")

        chunks = await _collect_stream(
            chat_router._stream_generator(body, uid, "free", usage, db_session)
        )
        events = _parse_all_events(chunks)

        done = [e for e in events if e["event"] == "done"][0]
        tracker_items = done["data"]["tracker_items"]
        assert len(tracker_items) == 2
        assert any("city hall" in item.get("title", "") for item in tracker_items)


# ---------------------------------------------------------------------------
# Test: /chat/stream endpoint
# ---------------------------------------------------------------------------


class TestChatStreamEndpoint:
    """Test the /chat/stream endpoint (HTTP-level)."""

    @pytest.mark.asyncio
    async def test_stream_returns_streaming_response(self, db_session, monkeypatch):
        """chat_stream returns a StreamingResponse with correct headers."""
        uid = "stream-ep-1"
        db_session.add(Profile(id=uid, email="ep1@example.com", subscription_tier="free"))
        await db_session.flush()

        async def fake_check(db, user_id, tier):
            return UsageCheck(allowed=True, used=0, limit=5, tier="free", period="lifetime")

        monkeypatch.setattr(chat_router, "check_balance", fake_check)

        from fastapi.responses import StreamingResponse

        async def quick_gen(body, uid, tier, usage, db):
            yield 'event: routing\ndata: {"domain": "life"}\n\n'
            yield 'event: done\ndata: {"text": "Hi", "domain": "life", "sources": [], "tracker_items": [], "usage": {"used": 0, "limit": 5, "tier": "free"}}\n\n'

        monkeypatch.setattr(chat_router, "_stream_generator", quick_gen)

        body = chat_router.ChatRequest(message="Hello", locale="en")
        user = FirebaseUser(uid=uid, email="ep1@example.com", is_anonymous=False)

        response = await chat_router.chat_stream(body=body, current_user=user, db=db_session)

        assert isinstance(response, StreamingResponse)
        assert response.media_type == "text/event-stream"
        assert response.headers.get("X-Accel-Buffering") == "no"
        assert response.headers.get("Cache-Control") == "no-cache"

    @pytest.mark.asyncio
    async def test_stream_guest_returns_403(self, db_session, monkeypatch):
        """Guest users get 403 on /chat/stream."""
        from config import settings
        monkeypatch.setattr(settings, "TESTFLIGHT_MODE", False)

        uid = "anon-stream-1"
        body = chat_router.ChatRequest(message="Test", locale="en")
        user = FirebaseUser(uid=uid, email=None, is_anonymous=True)

        with pytest.raises(HTTPException) as exc_info:
            await chat_router.chat_stream(body=body, current_user=user, db=db_session)

        assert exc_info.value.status_code == 403

    @pytest.mark.asyncio
    async def test_stream_usage_limit_returns_429(self, db_session, monkeypatch):
        """Exhausted credits -> 429."""
        uid = "limit-stream-1"
        db_session.add(Profile(id=uid, email="limit@example.com", subscription_tier="free"))
        await db_session.flush()

        async def fake_check(db, user_id, tier):
            return UsageCheck(allowed=False, used=5, limit=5, tier="free", period="lifetime")

        monkeypatch.setattr(chat_router, "check_balance", fake_check)

        body = chat_router.ChatRequest(message="Test", locale="en")
        user = FirebaseUser(uid=uid, email="limit@example.com", is_anonymous=False)

        with pytest.raises(HTTPException) as exc_info:
            await chat_router.chat_stream(body=body, current_user=user, db=db_session)

        assert exc_info.value.status_code == 429


# ---------------------------------------------------------------------------
# Test: Backward compat — /chat still works
# ---------------------------------------------------------------------------


class TestBackwardCompat:

    @pytest.mark.asyncio
    async def test_sync_chat_still_works(self, db_session, monkeypatch):
        """Synchronous /chat endpoint functions after streaming additions."""
        uid = "compat-1"
        db_session.add(Profile(id=uid, email="compat@example.com", subscription_tier="free"))
        await db_session.flush()

        async def fake_check(db, user_id, tier):
            return UsageCheck(allowed=True, used=0, limit=5, tier="free", period="lifetime")

        async def fake_route(message, current_domain=None, context=None):
            return RoutingResult(agent_id="svc-life")

        async def fake_call(**kwargs):
            return AgentResponse(
                text="Sync works", model="test", duration_ms=10,
                input_tokens=10, output_tokens=5, cache_read_tokens=0, status="ok",
            )

        monkeypatch.setattr(chat_router, "check_balance", fake_check)
        monkeypatch.setattr(chat_router, "consume_after_success", fake_check)

        import services.agent as agent_mod
        monkeypatch.setattr(agent_mod, "route_to_agent", fake_route)
        monkeypatch.setattr(agent_mod, "call_agent", fake_call)
        monkeypatch.setattr(agent_mod, "_execute_search", lambda q: None)

        body = chat_router.ChatRequest(message="Hello", locale="en")
        user = FirebaseUser(uid=uid, email="compat@example.com", is_anonymous=False)

        response = await chat_router.chat(body=body, current_user=user, db=db_session)
        assert response["data"]["reply"] == "Sync works"


# ---------------------------------------------------------------------------
# Test: Credit flow
# ---------------------------------------------------------------------------


class TestCreditFlow:

    @pytest.mark.asyncio
    async def test_credit_consumed_after_stream(self, db_session, monkeypatch):
        """consume_after_success is called AFTER streaming completes."""
        uid = "credit-flow-1"
        db_session.add(Profile(id=uid, email="cf1@example.com", subscription_tier="free"))
        await db_session.flush()

        call_order = []

        async def fake_route(message, current_domain=None, context=None):
            return RoutingResult(agent_id="svc-life")

        async def fake_search(query):
            return None

        async def fake_stream(**kwargs):
            call_order.append("stream_start")
            yield 'event: token\ndata: {"text": "resp"}\n\n'
            call_order.append("stream_end")
            yield 'event: __meta__\ndata: {"model": "t", "duration_ms": 50, "input_tokens": 5, "output_tokens": 3}\n\n'

        async def fake_consume(db, user_id, tier):
            call_order.append("consume")
            return UsageCheck(allowed=True, used=1, limit=5, tier="free", period="lifetime")

        import services.agent as agent_mod
        monkeypatch.setattr(agent_mod, "route_to_agent", fake_route)
        monkeypatch.setattr(agent_mod, "_execute_search", fake_search)
        monkeypatch.setattr(agent_mod, "call_agent_stream", fake_stream)
        monkeypatch.setattr(chat_router, "consume_after_success", fake_consume)

        body = chat_router.ChatRequest(message="Test", locale="en")
        usage = UsageCheck(allowed=True, used=0, limit=5, tier="free", period="lifetime")

        await _collect_stream(
            chat_router._stream_generator(body, uid, "free", usage, db_session)
        )

        assert "stream_start" in call_order
        assert "stream_end" in call_order
        assert "consume" in call_order
        assert call_order.index("stream_end") < call_order.index("consume")
