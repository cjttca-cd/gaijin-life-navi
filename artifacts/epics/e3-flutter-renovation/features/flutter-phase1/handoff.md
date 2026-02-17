# Flutter Phase 1 — Core Shell + Auth + Home + Chat UI Handoff

## Intent
Rebuild the Flutter app's core infrastructure, authentication flow, home screen, and chat UI to be fully compliant with the Design System (DESIGN_SYSTEM.md) and brand guidelines (BRAND_GUIDELINES.md), following the designer's visual handoff specifications.

## Non-goals
- Backend API changes (Flutter-side only)
- Phase 2+ screens (Profile edit, Subscription flow, Community, Scanner improvements)
- Push notifications integration
- Dark mode (only light theme per design system)

## Status: ✅ Complete

## What was delivered

### 1. Core Shell (`app/lib/core/`)
| File | Purpose |
|------|---------|
| `theme/app_theme.dart` | Full `ThemeData` with `ColorScheme` from Appendix A, component themes (AppBar, Card, BottomNav, Input, etc.) |
| `theme/app_colors.dart` | All color tokens as static `Color` constants — single source of truth |
| `theme/app_typography.dart` | Type scale from DESIGN_SYSTEM.md §2 (displayLarge → labelSmall) |
| `theme/app_spacing.dart` | Spacing tokens from §3 (xs=4 → xxxl=64) |
| `navigation/main_shell.dart` | 5-tab BottomNavigationBar: Home, Chat, Guide, SOS, Profile. SOS icon always `colorError`. |

### 2. Auth Flow (S01–S06)
| Screen | File | Key behaviors |
|--------|------|---------------|
| S01 Splash | `auth/presentation/splash_screen.dart` | 2s delay → auth check → route to home or language selection |
| S02 Language Selection | `auth/presentation/language_screen.dart` | 5 language buttons (EN/ZH/VI/KO/PT) → locale persistence → S03 |
| S03 Login | `auth/presentation/login_screen.dart` | Email/Password, "Forgot Password" link, "Register" link, Firebase Auth |
| S04 Register | `auth/presentation/register_screen.dart` | Email/Password/Confirm + Terms checkbox, Firebase Auth create |
| S05 Password Reset | `auth/presentation/reset_password_screen.dart` | Email input → success state with confirmation message |
| S06 Onboarding | `onboarding/presentation/onboarding_screen.dart` | 4 steps: Nationality → Residence Status → Region → Arrival Date |

### 3. Home Screen (S07)
- **File**: `home/presentation/home_screen.dart`
- Time-based greeting (morning/afternoon/evening) + user name
- Quick Actions 2×2 grid: AI Chat, Banking, Visa, Medical
- "Explore Guides" + "Emergency Contacts" links
- Upgrade Banner for free tier users

### 4. Chat UI (S08)
| Widget | File | Key behaviors |
|--------|------|---------------|
| Conversation | `chat/presentation/chat_conversation_screen.dart` | Empty state with suggestion chips, input bar, send button, auto-scroll |
| Message Bubble | `chat/presentation/widgets/message_bubble.dart` | User=Primary bg right-aligned / AI=SurfaceVariant left + avatar, Markdown rendering via `flutter_markdown` |
| Typing Indicator | `chat/presentation/widgets/typing_indicator.dart` | 3-dot bounce animation |
| Source Citation | `chat/presentation/widgets/source_citation.dart` | Expandable source cards with title + URL |
| Disclaimer Banner | `chat/presentation/widgets/disclaimer_banner.dart` | Legal disclaimer below AI responses |
| Usage Counter | `chat/presentation/widgets/usage_counter.dart` | Free tier remaining/limit display + upgrade link |

### 5. Localization (5 languages)
All ARB files updated with complete translations:
- `app_en.arb` (English — template)
- `app_zh.arb` (Chinese)
- `app_vi.arb` (Vietnamese)
- `app_ko.arb` (Korean)
- `app_pt.arb` (Portuguese)

All UI text goes through `AppLocalizations` — zero hardcoded strings.

### 6. Dependencies Added
| Package | Reason |
|---------|--------|
| `google_fonts` | CJK font support (Noto Sans SC/KR) |
| `flutter_markdown` + `markdown` | AI response Markdown rendering |
| `shared_preferences` | Locale persistence |

## Verification
```bash
cd app/
dart analyze --fatal-infos    # 0 issues
flutter test                  # 104 tests pass
flutter build web --release   # ✓ success
dart format --set-exit-if-changed lib/  # 0 unformatted
```

## Design System Compliance
- ✅ Zero hex hardcoding outside `app_colors.dart` / `app_theme.dart`
- ✅ All colors via `Theme.of(context).colorScheme.*`
- ✅ All spacing via `AppSpacing.*` constants
- ✅ Typography via `Theme.of(context).textTheme.*`
- ✅ SOS tab icon always `colorError` (#DC2626)
- ✅ Component themes (Card, AppBar, Input, BottomNav, etc.) match DESIGN_SYSTEM.md §4-§6

## Gaps / Known Issues
1. **SSE streaming**: Chat uses existing SSE parser but the streaming display (token-by-token) depends on backend sending proper SSE events. Currently tested with mock data.
2. **Firebase Auth error mapping**: Error messages are mapped to l10n keys but the specific `FirebaseAuthException` codes may need refinement in production.
3. **Onboarding data persistence**: Profile data is saved via the existing profile API. If the API is not running, onboarding will show a save error.
4. **Image assets**: Splash logo uses a `FlutterLogo` placeholder. A branded PNG/SVG should be added to `assets/`.
5. **Dark mode**: Not implemented (only light theme per current design system). DESIGN_SYSTEM.md Appendix A defines a dark `ColorScheme` if needed in the future.

## Next Steps
- Phase 2: Profile screen redesign, Subscription flow, Community Q&A improvements
- Replace FlutterLogo placeholder with branded splash asset
- Add widget tests for auth flow screens
- Performance optimization (lazy loading, image caching)
