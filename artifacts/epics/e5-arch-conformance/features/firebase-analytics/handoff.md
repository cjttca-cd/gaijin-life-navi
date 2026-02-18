# Handoff — Firebase Analytics SDK + KPI Event Instrumentation (task-043)

## Intent

Integrate Firebase Analytics SDK into the Flutter app and instrument all custom KPI events defined in `architecture/SYSTEM_DESIGN.md §11`. This establishes the observability foundation required by `architecture/MVP_ACCEPTANCE.md §12`.

## Non-goals

- Firebase Crashlytics integration (separate task)
- Backend-side analytics events (`charge_pack_purchased`, `subscription_cancelled` — Webhook-driven)
- A/B testing / Remote Config
- Firebase DebugView verification (requires real Firebase credentials)

## Status

✅ **Complete** — All acceptance criteria met.

## Architecture

### New Files

| File | Purpose |
|------|---------|
| `app/lib/core/analytics/analytics_events.dart` | All 12 custom event name constants — exact copy from SYSTEM_DESIGN.md §11.3 |
| `app/lib/core/analytics/analytics_service.dart` | Firebase Analytics wrapper with try-catch no-op fallback + Riverpod provider |
| `app/test/core/analytics/analytics_events_test.dart` | Unit tests for event names (12 events, snake_case, uniqueness) |

### Modified Files

| File | Changes |
|------|---------|
| `app/pubspec.yaml` | Added `firebase_analytics: ^11.4.2` dependency |
| `app/lib/features/chat/presentation/chat_conversation_screen.dart` | `chat_message_sent` on send success, `usage_limit_reached` on 429, `upgrade_cta_shown/tapped` on banner |
| `app/lib/features/chat/presentation/widgets/message_bubble.dart` | TODO comment for `chat_feedback` (feedback button not yet implemented) |
| `app/lib/features/navigate/presentation/guide_detail_screen.dart` | `guide_viewed` on detail load, `upgrade_cta_shown/tapped` on PremiumContentGate |
| `app/lib/features/navigate/presentation/emergency_screen.dart` | `emergency_accessed` on screen display |
| `app/lib/features/onboarding/presentation/onboarding_screen.dart` | `onboarding_completed` on submit success |
| `app/lib/features/tracker/presentation/providers/tracker_providers.dart` | `tracker_item_completed` on status cycle to completed |
| `app/lib/features/home/presentation/home_screen.dart` | `upgrade_cta_shown/tapped` on home upgrade banner |
| `app/lib/features/subscription/presentation/subscription_screen.dart` | TODO comment for `subscription_started` (IAP not yet implemented) |

### Design Decisions

1. **No-op fallback**: `AnalyticsService` constructor catches Firebase initialization failures. All `_logEvent` calls are wrapped in try-catch. This ensures the app works in dev/test without Firebase credentials.
2. **Single-fire pattern**: Screen-level events (`guide_viewed`, `emergency_accessed`, `upgrade_cta_shown`) use boolean flags in `ConsumerStatefulWidget` state to prevent duplicate logging on rebuilds.
3. **Provider architecture**: `analyticsServiceProvider` is a simple `Provider<AnalyticsService>` — injectable via `ref.read()` at any call site, consistent with existing Riverpod patterns.
4. **Event name source of truth**: `AnalyticsEvents` class is an exact copy of SYSTEM_DESIGN.md §11.3 code block (12 constants).

## Event Instrumentation Matrix

| Event | Status | Location | Trigger |
|-------|--------|----------|---------|
| `chat_message_sent` | ✅ Implemented | `chat_conversation_screen.dart` | After successful `sendMessage()` |
| `chat_feedback` | 📝 TODO | `message_bubble.dart` | Feedback button not yet built |
| `guide_viewed` | ✅ Implemented | `guide_detail_screen.dart` | On data load (once per visit) |
| `subscription_started` | 📝 TODO | `subscription_screen.dart` | IAP not yet implemented |
| `tracker_item_completed` | ✅ Implemented | `tracker_providers.dart` | On status cycle → completed |
| `onboarding_completed` | ✅ Implemented | `onboarding_screen.dart` | On successful submit |
| `emergency_accessed` | ✅ Implemented | `emergency_screen.dart` | On screen display (once) |
| `usage_limit_reached` | ✅ Implemented | `chat_conversation_screen.dart` | When remaining ≤ 0 on send |
| `upgrade_cta_shown` | ✅ Implemented | `chat_conversation_screen.dart`, `home_screen.dart`, `guide_detail_screen.dart` | On CTA banner display |
| `upgrade_cta_tapped` | ✅ Implemented | `chat_conversation_screen.dart`, `home_screen.dart`, `guide_detail_screen.dart` | On CTA button tap |

## Verification

```bash
# Static analysis (0 issues)
cd app && dart analyze --fatal-infos

# Format check
dart format --set-exit-if-changed .

# All tests pass (81 tests including 3 new analytics tests)
flutter test

# Web build succeeds
flutter build web --release
```

## Gaps / Next Steps

- **chat_feedback**: Requires thumbs-up/down button UI implementation first — TODO comment marks exact location in `message_bubble.dart`
- **subscription_started**: Requires IAP purchase flow — TODO comment in `subscription_screen.dart` with exact API call
- **Firebase DebugView**: Real verification requires `FIREBASE_CREDENTIALS` setup. Current dev environment uses dummy Firebase config.
- **Crashlytics**: Separate task per MVP_ACCEPTANCE.md §12

## Git

- Commit: See git log — `feat(analytics): integrate Firebase Analytics SDK with KPI event instrumentation [task-043]`
