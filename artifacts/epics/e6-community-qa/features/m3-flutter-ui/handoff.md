# M3 Flutter UI — Community Q&A + Subscription + Upgrade Flow Handoff

## Intent
Implement Flutter UI screens for Community Q&A (post list, detail, create), Subscription management (plan comparison, checkout), and Free→Premium upgrade flow throughout the app.

## Non-goals
- Real Stripe payment processing (uses mock checkout URL)
- Admin moderation review UI
- Push notifications for moderation results
- Offline caching via drift (API-only for now)

## Status: ✅ Complete

All 7 acceptance criteria verified:

| # | Criterion | Status |
|---|-----------|--------|
| 1 | `flutter analyze` — 0 errors | ✅ |
| 2 | `flutter test` — all 93 pass | ✅ (was 73, +20 new) |
| 3 | `flutter build web --release` — success | ✅ |
| 4 | go_router routes for Community/Subscription | ✅ |
| 5 | Community: list + filters, detail + replies + vote, create (Premium) | ✅ |
| 6 | Subscription: plan comparison + current plan + checkout | ✅ |
| 7 | Free→Premium upgrade flow (banners + navigation) | ✅ |

## Files Created

### Community Feature (`app/lib/features/community/`)
- `domain/community_post.dart` — CommunityPost model + ModerationStatus enum
- `domain/community_reply.dart` — CommunityReply model
- `data/community_repository.dart` — API client (list/create posts, replies, vote, best answer)
- `presentation/providers/community_providers.dart` — Riverpod providers (filters, pagination, CRUD)
- `presentation/community_list_screen.dart` — Post list with channel + category filters + sort
- `presentation/community_detail_screen.dart` — Post detail with replies, voting, reply input
- `presentation/community_create_screen.dart` — Post creation form (Premium only)

### Subscription Feature (`app/lib/features/subscription/`)
- `domain/subscription_plan.dart` — SubscriptionPlan + UserSubscription models
- `data/subscription_repository.dart` — API client (plans, me, checkout, cancel)
- `presentation/providers/subscription_providers.dart` — Riverpod providers (plans, mySubscription, isPremium)
- `presentation/subscription_screen.dart` — Plan comparison (Free vs Premium vs Premium+), current plan display, Stripe checkout

### Shared
- `app/lib/features/common/upgrade_banner.dart` — Reusable UpgradeBanner + UpgradeChip widgets

### Tests
- `app/test/features/community/domain/community_models_test.dart` — 11 tests
- `app/test/features/subscription/domain/subscription_models_test.dart` — 6 tests

## Files Modified
- `app/lib/core/providers/router_provider.dart` — Added Community (/community, /community/new, /community/:id) and Subscription (/subscription) routes
- `app/lib/features/navigate/presentation/navigate_screen.dart` — Added Community to the Navigate hub grid
- `app/test/core/providers/router_test.dart` — Added M3 route tests (+3 test cases)
- `app/pubspec.yaml` — Added `url_launcher: ^6.3.1` dependency
- `app/lib/l10n/app_en.arb` — Added ~60 new l10n keys for Community + Subscription
- `app/lib/l10n/app_zh.arb` — Chinese translations for all new keys
- `app/lib/l10n/app_vi.arb` — Vietnamese translations for all new keys
- `app/lib/l10n/app_ko.arb` — Korean translations for all new keys
- `app/lib/l10n/app_pt.arb` — Portuguese translations for all new keys

## Architecture Decisions

1. **State management**: All providers use Riverpod (consistent with existing features)
2. **HTTP client**: Uses existing `createApiClient()` (App Service) — Community & Subscription go through App Service not AI Service
3. **Pagination**: Cursor-based pagination matching backend API (next_cursor/has_more)
4. **Upgrade flow**: UpgradeBanner widget is shared; any screen can import it. Free users clicking restricted actions are redirected to /subscription
5. **Moderation UI**: Posts/replies show moderation status badges (pending/flagged). Only approved content is visible to non-authors (enforced server-side)
6. **Stripe checkout**: Uses `url_launcher` to open checkout URL in external browser (works on iOS/Android/Web)
7. **l10n**: All 60+ new text strings are in ARB files for all 5 languages (en/zh/vi/ko/pt). No hardcoded strings.

## Upgrade Flow Integration Points
Existing screens already have upgrade-related text (e.g., `trackerLimitReached`, `scannerLimitReached`, `chatLimitReachedMessage`). These now link to `/subscription` via `AppRoutes.subscription`. The `UpgradeBanner` widget provides a consistent, reusable CTA pattern.

## Gaps / Next Steps
- Wire up real Stripe checkout (set `STRIPE_SECRET_KEY` env var)
- Add pull-to-refresh on Community list (already in place with RefreshIndicator)
- User profile display on posts/replies (currently shows userId only; needs profile lookup)
- Admin moderation review UI for flagged content
- Push notifications for moderation status changes
- Best answer toggle UI button on reply cards (API endpoint exists)
- Cancel subscription UI (API endpoint exists in SubscriptionRepository)
- Deep link handling for `/community/:id` from push notifications

## Verification

```bash
cd app && export PATH="/root/flutter/bin:$PATH"

# 1. Analyze
flutter analyze
# Expected: No issues found!

# 2. Test
flutter test
# Expected: All 93 tests passed!

# 3. Build
flutter build web --release
# Expected: ✓ Built build/web
```
