# SSE Streaming Chat — Handoff

## Intent
Reduce perceived chat latency from ~20s to ~3s by streaming LLM tokens incrementally via Server-Sent Events (SSE). The new `/chat/stream` endpoint sends events as the agent generates tokens, so users see text appearing in real-time.

## Non-goals
- Not replacing the existing `/chat` endpoint (kept for backward compat)
- Not modifying `services/usage.py` or `services/credits.py`
- Not streaming router or search phases (only the agent LLM call is streamed)

## Status: ✅ Complete

## Changes Made

### Backend
| File | Change |
|------|--------|
| `backend/app_service/services/agent.py` | Added `_chat_completion_stream()`, `_chat_completion_stream_with_fallback()`, `call_agent_stream()` |
| `backend/app_service/routers/chat.py` | Added `_stream_generator()`, `POST /api/v1/chat/stream` endpoint |
| `backend/tests/test_chat_stream.py` | 15 new tests covering SSE format, orchestration, credit flow, backward compat |

### Frontend
| File | Change |
|------|--------|
| `app/lib/features/chat/domain/chat_stream_event.dart` | New: sealed class hierarchy (RoutingEvent, SearchingEvent, TokenEvent, DoneEvent, ErrorEvent) |
| `app/lib/features/chat/data/chat_repository.dart` | Added `sendMessageStream()` with SSE parsing |
| `app/lib/features/chat/presentation/providers/chat_providers.dart` | Added `streamingMessageIdProvider`, `streamingTextProvider`, `sendMessageStream()` in controller, `updateMessageContent()` and `finalizeMessage()` in AllMessagesNotifier |
| `app/lib/features/chat/presentation/chat_conversation_screen.dart` | Updated to use streaming send, pass `isStreaming` to bubbles, conditionally show typing indicator |
| `app/lib/features/chat/presentation/widgets/message_bubble.dart` | Added `_buildStreamingContent()` with cursor (▌), conditional rendering during/after stream |

### Infrastructure
| File | Change |
|------|--------|
| `/etc/nginx/sites-enabled/japan-life-navi` | Added `/api/` proxy location with `proxy_buffering off` for SSE |

## Verification

### Backend
```bash
cd /root/.openclaw/projects/gaijin-life-navi/backend
python3 -m pytest tests/ -v  # 105 passed (90 existing + 15 new)
ruff check app_service/routers/chat.py app_service/services/agent.py  # All checks passed
```

### Frontend
```bash
cd /root/.openclaw/projects/gaijin-life-navi/app
flutter analyze  # No issues found
```

### Nginx
```bash
sudo nginx -t  # syntax ok
sudo systemctl reload nginx  # applied
```

## SSE Event Flow
```
routing → (searching) → token → token → ... → done
                                          or → error
```

## Key Design Decisions
1. **Internal `__meta__` event**: `call_agent_stream()` yields a `__meta__` event with usage stats (model, tokens, duration) which the router intercepts and uses to build the `done` event — not forwarded to client.
2. **Credit consumption AFTER stream**: Same as sync flow — `consume_after_success()` called after all tokens are received.
3. **□ tracker parsing AFTER stream**: Full text is accumulated during streaming, then `_extract_blocks()` runs after stream completes. Parsed results go into the `done` event.
4. **X-Accel-Buffering: no**: Added to StreamingResponse headers to bypass nginx buffering.
5. **Fallback**: Frontend can revert to `/chat` if streaming fails (endpoint unchanged).

## Gaps
- E2E testing through Cloudflare Tunnel (SSE delivery timing)
- Network disconnect mid-stream recovery in frontend (currently shows accumulated text)
- Analytics event for streaming (`chat_message_sent` fires after DoneEvent)

## Next Steps
- Deploy and test with real LLM proxy
- Monitor TTFT (time to first token) metrics
- Consider adding retry logic on frontend for network failures
