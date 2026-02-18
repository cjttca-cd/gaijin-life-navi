# Handoff — Phase 0 Auto Tracker (task-042)

## Intent

Implement the Phase 0 Tracker feature: display AI-suggested `tracker_items` inside chat bubbles with a "Save" button, store saved items locally via SharedPreferences, and provide a dedicated `/tracker` screen for managing saved items with status cycling and deletion.

## Non-goals

- Server-side `user_procedures` storage (Phase 1)
- Tracker item editing (title/date modification)
- Push notifications for deadlines
- Tracker-specific AI queries

## Status

✅ **Complete** — All acceptance criteria met.

## Architecture

### Data Flow

```
AI Response → ChatResponse.trackerItems (parsed)
           → ChatMessage.trackerItems (passed through)
           → TrackerItemCards widget (displayed in AI bubble)
           → User taps "Save" → TrackerRepository (SharedPreferences)
           → TrackerScreen (list view with status management)
```

### New Files

| File | Purpose |
|------|---------|
| `app/lib/features/tracker/domain/tracker_item.dart` | TrackerItem model + TrackerStatus enum |
| `app/lib/features/tracker/data/tracker_repository.dart` | SharedPreferences CRUD (key: `tracker_items_v1`) |
| `app/lib/features/tracker/presentation/providers/tracker_providers.dart` | Riverpod AsyncNotifier + derived providers |
| `app/lib/features/tracker/presentation/tracker_screen.dart` | Full-screen list with status cycling + swipe delete |
| `app/lib/features/chat/presentation/widgets/tracker_item_card.dart` | In-bubble tracker item cards with Save/Saved state |

### Modified Files

| File | Changes |
|------|---------|
| `app/lib/features/chat/domain/chat_message.dart` | Added `trackerItems` and `actions` fields |
| `app/lib/features/chat/presentation/providers/chat_providers.dart` | Pass trackerItems/actions from ChatResponse to ChatMessage |
| `app/lib/features/chat/presentation/widgets/message_bubble.dart` | Integrate TrackerItemCards after sources section |
| `app/lib/core/providers/router_provider.dart` | Added `/tracker` route + import |
| `app/lib/features/home/presentation/home_screen.dart` | Added Tracker Quick Action card (logged-in users) |
| `app/lib/l10n/app_{en,zh,vi,ko,pt}.arb` | Added 5 new l10n keys per language |

### Key Design Decisions

1. **SharedPreferences storage** — JSON-encoded list under `tracker_items_v1` key. Phase 1 will migrate to server-side `user_procedures` table.
2. **Duplicate detection** — By `type + title` (case-insensitive). Prevents saving the same AI suggestion twice.
3. **ID generation** — `microsecondsSinceEpoch_random` pattern. No external `uuid` dependency needed for local-only storage.
4. **Free tier limit** — Hardcoded `3` in `TrackerRepository.freeTierLimit`, matching BUSINESS_RULES.md §2. Checked via `trackerLimitReachedProvider` which reads `userTierProvider`.
5. **Status cycling** — Tap on item cycles: `not_started → in_progress → completed → not_started`.

## Verification

```bash
# Static analysis (0 issues)
cd app && dart analyze --fatal-infos

# All tests pass (78 tests including 30+ new tracker tests)
flutter test

# Web build succeeds
flutter build web --release
```

## Acceptance Criteria Checklist

- [x] AI response tracker_items → card display in chat bubble
- [x] Save button on each tracker_item → SharedPreferences
- [x] /tracker screen with status list (not_started / in_progress / completed)
- [x] Status change via tap (cycling)
- [x] Delete via swipe (Dismissible with confirmation dialog)
- [x] Free tier: 3 items max, upgrade CTA on limit
- [x] Standard/Premium: unlimited
- [x] Home Quick Actions: Tracker shortcut (logged-in users)
- [x] `dart analyze --fatal-infos` → 0 issues
- [x] `flutter test` → 78 tests pass
- [x] `flutter build web --release` → success
- [x] All UI text via ARB (5 languages)

## Gaps / Next Steps

- **Phase 1**: Sync tracker items to server-side `user_procedures` table (SSOT migration)
- **Phase 1**: Add tracker item detail screen with notes/sub-steps
- **Phase 1**: Deadline notifications
- **UX**: Consider adding tracker item count badge on Home Quick Action card

## Git

- Commit: `d6574f0` — `feat(tracker): implement Phase 0 tracker feature [task-042]`
