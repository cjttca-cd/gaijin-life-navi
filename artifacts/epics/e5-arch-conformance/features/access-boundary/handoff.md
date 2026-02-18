# Access Boundary + Router Guest Access — Handoff

## Intent
Enable unauthenticated (guest) users to access Navigator, Banking guides, Emergency, and Home without login, while blocking Chat (showing promotion screen) and Profile (redirect to login). Per BUSINESS_RULES.md §2 Access Boundary Matrix.

## Non-goals
- Backend API changes (frontend-only gating)
- Dark mode
- Image upload in chat

## Status: ✅ Complete

## Changes

### 1. router_provider.dart
- **publicRoutes** expanded: `home`, `navigate`, `chat`, `subscription` added
- **Path prefix matching**: `/navigate/*` and `/emergency*` routes are guest-accessible
- **_ChatTabRouter** widget: switches between `ChatListScreen` (auth) and `ChatGuestScreen` (guest)

### 2. chat_guest_screen.dart (NEW)
- Registration promotion screen per task spec wireframe
- Feature highlight list (4 items) with check icons
- Free offer badge ("5 chats per day")
- Primary CTA → `/register`, Text button → `/login`
- DESIGN_SYSTEM.md compliant (spacing, colors, typography)

### 3. home_screen.dart
- Guest detection via `authStateProvider`
- Usage line hidden for guests
- Guest CTA banner at top: "Sign up free to use AI Chat"
- Quick actions: guests see Banking + Emergency only (no AI Chat, no Visa)
- Upgrade banner adapts: guests → register, logged-in → subscription

### 4. guide_detail_screen.dart
- Content gating: `showFullContent = !isGuest || isBanking`
- Non-banking domains: first 200 chars + word-boundary truncation + `…`
- `_GuestContentGate` widget: lock icon + "Sign up to read" + "Ask AI" CTA
- Banking domain: full content for all users

### 5. Localization (5 languages × 11 keys)
All new keys added to en/zh/vi/ko/pt ARB files + regenerated l10n.

## Verification
1. `dart analyze` → 0 issues
2. `dart format --set-exit-if-changed .` → 0 changes
3. `flutter test` → 49/49 passed (7 new guest access tests)
4. `flutter build web --release` → success

## Gaps
- Home screen guest version still shows `_startNewChat` reference but it's hidden behind `!isGuest` conditional — no issue
- `ChatConversationScreen` route (`/chat/:id`) correctly requires auth via redirect logic

## Next Steps
- E2E visual verification of guest flow (Tester)
- Consider adding onboarding skip → guest mode flow
