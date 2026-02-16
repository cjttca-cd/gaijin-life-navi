# Profile & Settings Feature — Handoff

## Intent
Implement the Profile view, Profile edit, and Settings screens for the Flutter app, with backend support for account deletion (soft-delete + Stripe subscription cancellation).

## Non-goals
- Avatar upload (future — `avatar_url` field exists but no upload endpoint)
- Profile data export (GDPR — future)
- Push notification settings (not in MVP)

## Status
✅ **Complete** — All acceptance criteria met.

## What was built

### Backend
- **DELETE /api/v1/users/me** — New endpoint in `users.py` for account deletion
  - Sets `profiles.deleted_at` (soft-delete)
  - Cancels active Stripe subscription (`cancel_at_period_end=true`)
  - Deletes Firebase Auth account (skipped in mock mode)
- **POST /api/v1/auth/delete-account** — Enhanced with Stripe subscription cancellation (was missing)

### Flutter (app/lib/features/profile/)
- **domain/user_profile.dart** — `UserProfile` model with `fromJson`/`toJson`
- **data/profile_repository.dart** — `ProfileRepository` with GET, PATCH, DELETE
- **presentation/providers/profile_providers.dart** — Riverpod providers for profile data
- **presentation/profile_screen.dart** — Profile view (avatar, name, tier badge, all fields)
- **presentation/profile_edit_screen.dart** — Edit form with all profile fields
- **presentation/settings_screen.dart** — Language switching, logout, account deletion

### Routing
- `/profile` — Profile view (in bottom nav shell)
- `/profile/edit` — Full-screen profile editor
- `/settings` — Full-screen settings

### Localization
- 33 new keys × 5 languages (en, zh, vi, ko, pt)
- Total: 303 l10n keys

### E2E Tests (scripts/e2e_test.py)
- 6 closed-loop integration tests (A–F) using ASGI transport
- All 6 loops PASS

## Verification
```bash
cd /root/.openclaw/projects/gaijin-life-navi/app

# 1. Flutter analyze
flutter analyze
# → No issues found!

# 2. Flutter test
flutter test
# → 97 tests passed

# 3. Flutter web build
flutter build web --no-tree-shake-icons
# → Built build/web

# 4. E2E tests
cd /root/.openclaw/projects/gaijin-life-navi
source .venv/bin/activate
python scripts/e2e_test.py
# → ALL 6 CLOSED LOOPS PASSED
```

## Gaps
- Alembic cannot run in-process with async driver (uses subprocess for migrations in E2E)
- Chat streaming errors in E2E (missing `chat_engine` module) are handled gracefully — SSE still returns 200 with error event

## Next Steps
- M5: Notification system, analytics dashboard
- Avatar upload endpoint + R2 integration
- GDPR data export
