# Guest CTA UI + Closed Loop E — Handoff

## Intent
Enhance the Guest → Registration and Free → Premium upgrade CTAs throughout the app, establishing a complete conversion funnel (Closed Loop E):
1. Guest → Browse → Truncated content → Registration CTA → Register
2. Guest → Chat tab → ChatGuestScreen → Registration CTA → Register
3. Free user → Chat limit reached → Upgrade CTA → Subscription Plans

## Non-goals
- Backend API changes (frontend-only)
- IAP purchase flow (separate task)
- Dark mode

## Status: ✅ Complete

## Changes

### 1. Guide Detail — Guest Content Gate Enhancement (`guide_detail_screen.dart`)
- `_GuestContentGate`: Redesigned with `colorTertiaryContainer` (#FEF3C7) background per spec
  - Icon + "Sign up to read the full guide" text
  - "Create Free Account" button → `/register`
  - Removed secondary "Ask AI" text button for cleaner CTA focus
- `_PremiumContentGate` (NEW): Shows when backend returns 403 TIER_LIMIT_EXCEEDED
  - Star icon + Premium subscription message
  - "View Plans" button → `/subscription`
- Error handler: Detects 403/TIER_LIMIT_EXCEEDED and shows upgrade CTA instead of generic error

### 2. Home Screen — Guest CTA Card Enhancement (`home_screen.dart`)
- `_GuestCtaBanner`: Redesigned as prominent Card component
  - `colorPrimaryContainer` background (via `cs.primaryContainer`)
  - Auto-awesome icon + "Create your free account to unlock AI chat and personalized guides"
  - Full-width "Get Started" FilledButton → `/register`

### 3. Chat — Usage Limit Upgrade Banner (`chat_conversation_screen.dart`)
- `_ChatUpgradeBanner` (NEW): ConsumerWidget shown when `remaining ≤ 1`
  - `colorWarningContainer` background
  - Star icon + "Upgrade to Premium for unlimited chat"
  - "View Plans" text button → `/subscription`
  - Automatically hidden for unlimited (Premium) users
  - Positioned above the message list for visibility

### 4. Subscription Screen — Current Plan Highlight (`subscription_screen.dart`)
- `_PlanCard`: Added "Current Plan" badge (green `colorSecondary` pill) when `isCurrentPlan == true`
  - Badge takes priority over "RECOMMENDED" badge
  - Current plan card gets primary border (2dp)
  - CTA button shows "Current Plan" (disabled) instead of "Choose {plan}"
  - `isRecommended` auto-adjusts: Standard only recommended when not already the user's plan
- `userTierProvider`: New derived provider from `chatUsageProvider` for current tier detection

### 5. Localization (5 languages × 8 new keys)
New keys added to all ARB files (en/zh/vi/ko/pt):
- `guideGuestCtaButton` — "Create Free Account"
- `homeGuestCtaText` — "Create your free account to unlock AI chat and personalized guides"
- `homeGuestCtaButton` — "Get Started"
- `chatUpgradeBanner` — "Upgrade to Premium for unlimited chat"
- `chatUpgradeButton` — "View Plans"
- `guidePremiumCta` — "This content is available with a Premium subscription"
- `guidePremiumCtaButton` — "View Plans"
- `guideTierLimitError` — "Upgrade to access the full guide content"

### 6. User Tier Provider (`chat_providers.dart`)
- `userTierProvider`: Reads from `chatUsageProvider.tier`, defaults to `'free'`
- Used by SubscriptionScreen and ChatUpgradeBanner

## Verification
1. `dart analyze --fatal-infos` → 0 issues
2. `dart format --set-exit-if-changed .` → 0 changes
3. `flutter test` → 49/49 passed (0 broken)
4. `flutter build web --release` → success

## Closed Loop E Test Paths
1. **Guest → Register**: Browse Navigator → Open non-banking guide → See truncated content + tertiaryContainer CTA → Tap "Create Free Account" → /register
2. **Guest → Register (Chat)**: Tap Chat tab → See ChatGuestScreen → Tap "Get started free" → /register
3. **Guest → Register (Home)**: See Home guest CTA card → Tap "Get Started" → /register
4. **Free → Upgrade**: Send 5 chats → See warning banner at top of chat → Tap "View Plans" → /subscription → See "Current Plan" badge on Free tier

## Gaps
- Current tier detection depends on `chatUsageProvider` being populated (requires at least 1 chat API response). Before first chat, tier defaults to `'free'` which is correct for new users.
- 403 TIER_LIMIT_EXCEEDED detection is string-based (checks error message for "403" or "TIER_LIMIT_EXCEEDED"). May need refinement when backend implements actual tier gating.

## Next Steps
- E2E visual verification of all CTA flows (Tester)
- IAP purchase integration (separate task)
- Backend tier gating implementation (backend task)
