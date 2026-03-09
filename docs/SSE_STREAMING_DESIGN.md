# SSE Streaming Chat Design

> Status: **Approved by Z** (2026-03-10)
> ADR: ADR-013 in `architecture/DECISIONS.md`

## 1. Problem

Chat responses take 16-26s (router + optional search + agent). During this time,
the user sees only a loading spinner. This makes the app feel slow even though
the actual content generation starts within 2-4s of the agent call.

**With SSE streaming**: First token appears in ~2-4s after the agent call begins,
and text flows in real-time. The user starts reading immediately. Total time is
unchanged but **perceived latency drops from 20s to 3s**.

## 2. Architecture

### Current Flow (Synchronous)
```
Frontend                  Backend                     LLM Proxy
   │                        │                            │
   ├─ POST /chat ──────────>│                            │
   │                        ├─ route_to_agent() ────────>│ (~1.5s)
   │                        │<──── domain + search ──────│
   │                        ├─ _execute_search() ───────>│ (~4s, if needed)
   │                        │<──── search results ───────│
   │                        ├─ call_agent() ────────────>│ (~10-17s)
   │   (user waits 16-26s)  │<──── full response ────────│
   │<── JSON response ──────│                            │
   │                        │                            │
```

### New Flow (SSE Streaming)
```
Frontend                  Backend                     LLM Proxy
   │                        │                            │
   ├─ POST /chat/stream ───>│                            │
   │                        ├─ route_to_agent() ────────>│ (~1.5s)
   │<── SSE: {"event":"routing","domain":"finance"} ─────│
   │                        ├─ _execute_search() ───────>│ (~4s, if needed)
   │<── SSE: {"event":"searching"} ──────────────────────│
   │                        ├─ call_agent(stream=True) ─>│
   │<── SSE: {"event":"token","text":"こんにちは"} ──────│ (~2s TTFT)
   │<── SSE: {"event":"token","text":"、"} ──────────────│
   │<── SSE: {"event":"token","text":"Wiseで"} ──────────│
   │     ... (streaming) ...                             │
   │<── SSE: {"event":"done","usage":{...},"domain":"finance"} ──│
   │                        │                            │
```

## 3. Implementation Spec

### 3.1 New Streaming Endpoint (`routers/chat.py`)

Add a new endpoint alongside the existing synchronous one:

```python
@router.post("/chat/stream")
async def chat_stream(body: ChatRequest, ...) -> StreamingResponse:
    """SSE streaming chat endpoint."""
```

**⚠️ Keep the existing `/chat` endpoint unchanged** — backward compatibility for
older frontend versions or API consumers.

**SSE Event Format** (newline-delimited JSON):
```
event: routing
data: {"domain": "svc-finance", "search_query": "Wise 手数料"}

event: searching
data: {}

event: token
data: {"text": "こんにちは"}

event: done
data: {"domain": "finance", "model": "gemini-3-flash", "duration_ms": 15230,
       "input_tokens": 12000, "output_tokens": 500, "usage": {...}}

event: error
data: {"message": "Agent timed out"}
```

### 3.2 Streaming Agent Function (`services/agent.py`)

New function:

```python
async def call_agent_stream(
    agent_id: str,
    message: str,
    context: list[dict] | None = None,
    image_path: str | None = None,
    user_profile: dict | None = None,
    search_results: str | None = None,
    timeout: int = 90,
) -> AsyncGenerator[str, None]:
    """Stream agent response as SSE events.
    
    Yields SSE-formatted strings. The caller wraps them in StreamingResponse.
    """
```

Implementation:
1. Build system prompt + user message (same as `call_agent()`)
2. Call `_chat_completion_stream()` with `stream=True`
3. Iterate over response chunks, yielding `event: token\ndata: {"text": "..."}\n\n`
4. After stream ends, yield `event: done\ndata: {...}\n\n` with usage stats
5. On error, yield `event: error\ndata: {"message": "..."}\n\n`

New helper:
```python
async def _chat_completion_stream(
    messages: list[dict],
    model: str,
    timeout: float | None = None,
) -> httpx.Response:
    """Start a streaming chat completion request. Returns the raw httpx Response."""
```

### 3.3 Orchestration in `/chat/stream`

```python
async def _stream_generator(body, uid, ...):
    # 1. Auth + credit check (same as sync)
    # 2. Route
    routing = await route_to_agent(...)
    yield f"event: routing\ndata: {json.dumps({'domain': routing.agent_id})}\n\n"
    
    # 3. Out of scope check
    if routing.agent_id == "out_of_scope":
        yield f'event: done\ndata: {json.dumps({"text": oos_message})}\n\n'
        return
    
    # 4. Search (if needed)
    search_results = None
    if routing.search_query and settings.SEARCH_ENABLED:
        yield 'event: searching\ndata: {}\n\n'
        search_results = await _execute_search(routing.search_query)
    
    # 5. Stream agent response
    full_text = ""
    async for chunk in call_agent_stream(agent_id=..., search_results=search_results, ...):
        yield chunk
        # Accumulate full text for post-processing
        # (chunk parsing extracts text from SSE format)
    
    # 6. Post-stream: parse trackers, consume credits
    reply, sources, actions, tracker_items = _extract_blocks(full_text)
    await consume_after_success(uid, ...)
    
    # 7. Final event with structured data
    yield f"event: done\ndata: {json.dumps({...})}\n\n"

@router.post("/chat/stream")
async def chat_stream(body: ChatRequest, ...):
    return StreamingResponse(
        _stream_generator(body, uid, ...),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "X-Accel-Buffering": "no",  # Disable Nginx buffering
        },
    )
```

### 3.4 Frontend Changes (`chat_repository.dart`)

Add streaming method:

```dart
/// Send a chat message and receive SSE streaming response.
Stream<ChatStreamEvent> sendMessageStream({
  required String message,
  String? domain,
  String? locale,
  String? imageBase64,
  List<Map<String, String>>? context,
}) async* {
  final request = await _client.post<ResponseBody>(
    '/chat/stream',
    data: { ... },
    options: Options(responseType: ResponseType.stream),
  );
  
  await for (final chunk in request.data!.stream) {
    // Parse SSE events from chunk
    yield* _parseSSEEvents(chunk);
  }
}
```

**Event types for Flutter:**
```dart
sealed class ChatStreamEvent {}
class RoutingEvent extends ChatStreamEvent { String domain; }
class SearchingEvent extends ChatStreamEvent {}
class TokenEvent extends ChatStreamEvent { String text; }
class DoneEvent extends ChatStreamEvent { ChatResponse response; }
class ErrorEvent extends ChatStreamEvent { String message; }
```

### 3.5 Frontend UI Changes (`chat_conversation_screen.dart`)

Modify the chat sending flow:

1. On send: Add user message bubble immediately
2. Add assistant bubble in "streaming" state (empty, with cursor)
3. As `TokenEvent`s arrive: Append text to assistant bubble
4. On `DoneEvent`: Finalize bubble, parse □ tracker items, show save buttons
5. On `ErrorEvent`: Show error state in bubble

**Key constraint**: □ tracker items are parsed and save buttons rendered
ONLY after the stream completes (in `DoneEvent`). During streaming, show
raw text including □ lines.

### 3.6 Nginx Configuration

Ensure SSE passes through without buffering:

```nginx
location ^~ /api/ {
    proxy_pass http://localhost:8000/;
    proxy_buffering off;           # Critical for SSE
    proxy_cache off;
    proxy_set_header Connection '';
    proxy_http_version 1.1;
    chunked_transfer_encoding off;
}
```

### 3.7 Cloudflare Tunnel

Cloudflare Tunnel supports SSE natively. No configuration changes needed.
However, Cloudflare may buffer small chunks — test to confirm real-time delivery.

## 4. Latency Comparison

| Metric | Before (sync) | After (SSE) |
|--------|--------------|-------------|
| Time to first visible text | 16-26s | 2-4s after agent starts (~4-8s total) |
| Total completion time | 16-26s | 16-26s (unchanged) |
| Perceived wait | 16-26s ❌ | 4-8s ✅ |

## 5. Files Changed

### Backend
| File | Change |
|------|--------|
| `routers/chat.py` | Add `/chat/stream` endpoint + SSE generator |
| `services/agent.py` | Add `call_agent_stream()` + `_chat_completion_stream()` |
| `config.py` | (no change needed) |

### Frontend
| File | Change |
|------|--------|
| `data/chat_repository.dart` | Add `sendMessageStream()` method |
| `domain/chat_stream_event.dart` | New: sealed class for SSE events |
| `presentation/providers/chat_providers.dart` | Update send logic to use streaming |
| `presentation/chat_conversation_screen.dart` | Incremental rendering of assistant bubble |
| `presentation/widgets/chat_bubble.dart` | Support "streaming" state with cursor |

### Infrastructure
| File | Change |
|------|--------|
| Nginx config | Add `proxy_buffering off` for `/api/` |

## 6. Testing Plan

### Backend Tests
- SSE event format validation (routing, searching, token, done, error)
- `call_agent_stream()` yields correct chunks
- Stream error handling (timeout → error event, API failure → error event)
- Credit check before stream, consume after stream
- Existing `/chat` endpoint unchanged (backward compat)

### Frontend Tests
- SSE event parsing (all event types)
- Incremental text rendering
- □ tracker items only parsed after stream completes
- Error state rendering mid-stream

### E2E Tests (post-deploy)
- [ ] Stream a finance question → tokens appear incrementally
- [ ] Stream with search → "searching" event, then tokens
- [ ] Out of scope → immediate done event
- [ ] Network disconnect mid-stream → graceful error handling
- [ ] Nginx + Cloudflare don't buffer (real-time delivery)

## 7. Constraints

- **Existing `/chat` endpoint MUST remain unchanged** — backward compatibility
- **`services/usage.py` and `services/credits.py` MUST NOT be modified**
- **Credit deduction happens AFTER stream completes** (same as sync flow)
- **□ tracker parsing happens AFTER stream completes** (cannot parse mid-stream)
- **Router + Search remain synchronous** — only agent call is streamed
- **Agent behavioral rules (accuracy, knowledge protection, □ markers) preserved**
- **All existing 90 tests must continue passing**

## 8. Rollback

- Frontend can fall back to `/chat` (sync) if streaming fails
- Backend keeps both endpoints — no breaking change
- Nginx buffering change is harmless even without SSE

## 9. Verified: Proxy Supports Streaming

Tested on 2026-03-10:
- `stream: true` with `gemini-3-flash` → `text/event-stream` response ✅
- Chunks arrive incrementally ✅
- Standard OpenAI SSE format (`data: {...}` lines) ✅
