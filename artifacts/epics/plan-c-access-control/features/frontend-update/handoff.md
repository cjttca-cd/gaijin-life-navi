# Handoff — Plan C Frontend + Backend Update

## Intent
Implement the 4-tier access model (Guest/Free/Standard/Premium) across both backend API and Flutter frontend, enabling anonymous guest chat, lifetime/monthly usage tracking, and tier-appropriate CTAs.

## Non-goals
- Stripe integration changes (handled by Webhook SSOT)
- New screen files (constraint: reuse/modify existing)
- App-startup anonymous auth (only triggered on Chat tab)

## Status: ✅ Complete

## Changes

### Backend (3 files)

| File | Change |
|------|--------|
| `backend/app_service/services/usage.py` | `UsageCheck` dataclass: added `period: str | None = None`. All `UsageCheck()` calls now pass `period` from `_TIER_LIMITS`. |
| `backend/app_service/routers/chat.py` | `UsageInfo` Pydantic model: added `period` field. `_usage_to_info()` passes `period` from `UsageCheck`. |
| `backend/app_service/routers/usage_router.py` | Rewrote `get_usage()`: Plan C tier limits (guest:5/lifetime, free:10/lifetime, standard:300/month, premium:∞, premium_plus:∞). Anonymous users → "guest" tier. Returns `period` field. Removed unused `HTTPException`/`status` imports. |

### Frontend (8 files + 5 ARB + generated l10n)

| File | Change |
|------|--------|
| `app/lib/core/providers/auth_provider.dart` | Added `isAnonymousProvider` and `signInAnonymously()` function |
| `app/lib/core/providers/router_provider.dart` | `_ChatTabRouter`: logged-in (incl. anonymous) → `ChatListScreen`, unauthenticated → `_AnonymousAuthGate` (auto-signs-in anonymously). Profile redirect: anonymous users → `/login`. |
| `app/lib/features/navigate/domain/navigator_domain.dart` | `NavigatorGuideDetail`: added `registerCta` field parsed from `register_cta` JSON key |
| `app/lib/features/navigate/presentation/guide_detail_screen.dart` | `_buildLockedView`: routes to `/register` when `registerCta` is true, `/subscription` when `upgradeCta` is true |
| `app/lib/features/chat/domain/chat_response.dart` | `ChatUsageInfo`: added `period` field + `isLifetime` getter |
| `app/lib/features/usage/domain/usage_data.dart` | `fromJson()`: supports new Plan C format (`used`/`limit`/`period`) with backward compatibility for legacy `queries_used_today`/`daily_limit`/`monthly_limit` |
| `app/lib/features/chat/presentation/providers/chat_providers.dart` | `fetchUsageProvider`: parses `period` from backend response |
| `app/lib/features/chat/presentation/widgets/usage_counter.dart` | Full rewrite: lifetime vs month display text. Exhausted state shows tier-appropriate CTA (guest → register, free → upgrade). |

### L10n (5 languages: en, zh, vi, ko, pt)

**Updated keys**: `chatGuestFreeOffer`, `guideLocked`, `guideUpgradePrompt`, `guideUpgradeButton`, `chatLimitExhausted`, `subFeatureChatFree`, `subscriptionFeatureFreeChat`

**New keys**: `chatGuestUsageHint(remaining)`, `chatGuestExhausted`, `chatFreeExhausted`, `usageLifetimeRemaining(remaining, limit)`, `chatGuestWelcome`

## Verification

1. `flutter analyze` → No issues found
2. `flutter build web --release` → ✓ Built build/web
3. `ruff check` on changed backend files → Clean (pre-existing `os` import in chat.py is untouched)
4. `dart format --set-exit-if-changed` → 0 changes (already formatted)

## Acceptance Criteria Coverage

| # | Criterion | Status |
|---|-----------|--------|
| 1 | Guest → Chat tab → auto anonymous auth → ChatListScreen | ✅ `_AnonymousAuthGate` widget |
| 2 | Guest Chat shows "remaining X/5" (lifetime) | ✅ `usageLifetimeRemaining` l10n key + `UsageCounter` |
| 3 | Guest 5 used → register CTA (not upgrade) | ✅ `chatGuestExhausted` → `/register` |
| 4 | Guest opens free guide → full text | ✅ Backend returns `locked: false` for public/free access |
| 5 | Guest opens premium guide → excerpt + "Create Free Account" CTA | ✅ Backend `register_cta: true` + frontend `_buildLockedView` |
| 6 | Free user sees all 45 guides | ✅ Backend: `is_registered=True` → full content |
| 7 | Free Chat shows "remaining X/10" (lifetime) | ✅ Backend `free: 10/lifetime` + `usageLifetimeRemaining` |
| 8 | Free 10 used → upgrade CTA | ✅ `chatFreeExhausted` → `/subscription` |
| 9 | Standard/Premium no change | ✅ Backend limits unchanged |
| 10 | L10n all 5 languages complete | ✅ All ARBs updated + generated |
| 11 | `flutter analyze` no error | ✅ |
| 12 | `flutter build web --release` success | ✅ |

## Gaps / Risks

- **ChatGuestScreen** (B4): File preserved but not modified. The `_AnonymousAuthGate` falls back to it if anonymous sign-in fails. Could be repurposed as exhausted CTA in a future pass.
- **Pre-existing lint**: `import os` in `chat.py` is unused but pre-existing — not introduced by this change.

## Next Steps

- E2E testing with real Firebase Anonymous Auth
- Verify Stripe webhook still correctly updates tier for Standard/Premium users
- Monitor anonymous user creation rate in Firebase console

## Git

Commit: `1060276` — `feat(access): implement Plan C 4-tier access model frontend + backend [task-044]`
