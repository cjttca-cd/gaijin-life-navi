# Handoff: Flutter Chat UI + Onboarding (task-021)

## Intent
Implement the Flutter client-side features for:
- **AI Chat**: Session list, conversation screen with SSE streaming, message bubbles, source citations, disclaimer banner, daily usage counter
- **Onboarding**: 4-step flow (nationality → residence status → region → arrival date)
- **Home Dashboard**: Quick actions grid, recent chats section

## Non-goals
- Drift (local DB) caching — not yet needed
- Subscription/payment flow — separate epic
- Community Q&A, Document Scanner, Banking Navigator — separate features
- Offline support

## Status: ✅ Complete

### Files Added/Modified (25+ files)

#### Core
- `core/config/app_config.dart` — Added `aiServiceBaseUrl` for AI Service (port 8001)
- `core/network/ai_api_client.dart` — Dio instance configured for AI Service
- `core/providers/router_provider.dart` — Added `/onboarding`, `/chat/:id` routes

#### Chat Feature (`features/chat/`)
- `domain/chat_session.dart` — ChatSession model (fromJson, copyWith)
- `domain/chat_message.dart` — ChatMessage, SourceCitation, ChatUsage models
- `domain/sse_event.dart` — SSE event types (MessageStart, ContentDelta, MessageEnd) + SseParser
- `data/chat_repository.dart` — ChatRepository (sessions CRUD, messages, SSE streaming)
- `presentation/providers/chat_providers.dart` — Riverpod providers (sessions, messages, usage, streaming)
- `presentation/chat_list_screen.dart` — Session list with swipe-to-delete
- `presentation/chat_conversation_screen.dart` — Conversation with SSE streaming
- `presentation/widgets/message_bubble.dart` — User/Assistant bubbles with sources & disclaimer
- `presentation/widgets/typing_indicator.dart` — Animated typing dots
- `presentation/widgets/source_citation.dart` — RAG source URLs display
- `presentation/widgets/disclaimer_banner.dart` — Mandatory disclaimer display
- `presentation/widgets/usage_counter.dart` — Daily remaining count badge

#### Onboarding Feature (`features/onboarding/`)
- `data/onboarding_repository.dart` — API client for POST /users/me/onboarding
- `presentation/onboarding_screen.dart` — 4-step PageView (nationality, visa, region, date)

#### Home Feature (`features/home/`)
- `presentation/home_screen.dart` — Dashboard with quick actions grid + recent chats

#### l10n (5 languages × 125 keys)
- `l10n/app_en.arb`, `app_zh.arb`, `app_vi.arb`, `app_ko.arb`, `app_pt.arb` — All new keys for chat, onboarding, home dashboard

#### Tests (40 tests, all passing)
- `test/features/chat/domain/sse_event_test.dart` — SSE parser: 11 tests
- `test/features/chat/domain/chat_models_test.dart` — Models: 9 tests
- `test/core/providers/router_test.dart` — Routes: 5 tests
- `test/core/config/app_config_test.dart` — Config: 5 tests
- `test/l10n/arb_test.dart` — ARB validation: 4 tests
- `test/core/providers/locale_test.dart` — Locale: 5 tests
- `test/widget_test.dart` — Placeholder: 1 test

## Verification

```bash
cd app

# 1. Static analysis — 0 issues
flutter analyze  # → No issues found!

# 2. Tests — 40/40 passing
flutter test     # → All tests passed!

# 3. Web release build — success
flutter build web --release  # → ✓ Built build/web
```

## Architecture Notes

### SSE Streaming Protocol
The chat uses Server-Sent Events (SSE) via Dio's `ResponseType.stream`:
1. `message_start` → creates assistant message bubble
2. `content_delta` (×N) → appends text chunks (typing effect)
3. `message_end` → finalizes with sources, disclaimer, usage count

### State Management (Riverpod)
- `chatSessionsProvider` — AsyncNotifier for session CRUD
- `chatMessagesProvider(sessionId)` — Family AsyncNotifier for per-session messages
- `chatUsageProvider` — StateProvider for daily usage (remaining count)
- `isChatStreamingProvider` — StateProvider<bool> for UI loading state
- `chatStreamControllerProvider` — Manages SSE subscription lifecycle

### API Routing
- AI Service (port 8001): `/api/v1/ai/chat/sessions`, `/api/v1/ai/chat/sessions/{id}/messages`
- App Service (port 8000): `/api/v1/users/me/onboarding`

### l10n
All UI text uses ARB keys (no hardcoded strings). 125 keys across 5 languages (en, zh, vi, ko, pt).
Parameterized keys: `chatRemainingCount(remaining, limit)`, `onboardingStepOf(current, total)`.

## Gaps / Known Limitations
1. **No Drift caching** — All data fetched from server (per ARCHITECTURE.md: drift is cache-only, not needed yet)
2. **No subscription navigation** — "Upgrade to Premium" button exists but TODO navigation
3. **No real Firebase Auth in tests** — Tests cover models/parsing/routing logic, not widget rendering with Firebase
4. **No image/file attachments in chat** — Text-only for MVP
5. **Date formatting** — Uses simple m/d/y format in session list (could use intl DateFormat)

## Next Steps
1. **Integration testing** — Run against AI Service mock mode
2. **Subscription screen** — Wire "Upgrade to Premium" button
3. **Profile editing** — PATCH /users/me integration
4. **Admin Tracker** — Wire tracker screen to procedures API
5. **Drift caching** — Optional offline cache layer

## Git
- Commit: `feat(chat-ui): Flutter Chat UI + Onboarding [task-021]`
