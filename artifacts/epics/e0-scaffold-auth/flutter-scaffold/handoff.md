# Handoff: Flutter App Scaffold + Auth + l10n

## Intent

Build the Flutter app foundation with Riverpod state management, go_router routing (with auth guard), Firebase Auth integration, BottomNavigation shell, and 5-language l10n base.

## Non-goals

- Feature implementation beyond auth screens (chat, tracker, navigate, profile are placeholders)
- Onboarding flow (M0 later feature)
- Apple Sign In (MVP後)
- drift local DB schema (placeholder only)
- Real Firebase project connection (mock mode)

## Status: ✅ Complete

All deliverables verified:

| Check | Result |
|-------|--------|
| `flutter analyze` | ✅ No issues found |
| `flutter test` | ✅ 17/17 tests passed |
| `flutter build web --release` | ✅ Build successful (55.7s) |
| go_router routes | ✅ All required paths (/, /language, /login, /register, /reset-password, /home, /chat, /tracker, /navigate, /profile) |
| Auth redirect | ✅ Unauthenticated → /login, Authenticated on /login → /home |
| ARB files | ✅ 5 languages (en, zh, vi, ko, pt) |
| pubspec.yaml deps | ✅ Riverpod, go_router, drift, dio, firebase_auth, flutter_localizations |
| Git commit | ✅ `e05e4df` |

## File Structure

```
app/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config.dart       — API base URL, supported languages, defaults
│   │   ├── network/
│   │   │   └── api_client.dart        — dio client with AuthInterceptor (Firebase ID Token)
│   │   ├── providers/
│   │   │   ├── auth_provider.dart     — Firebase Auth state (Riverpod StreamProvider)
│   │   │   ├── locale_provider.dart   — Locale state (Riverpod StateNotifier, 5 languages)
│   │   │   └── router_provider.dart   — GoRouter config (auth guard redirect)
│   │   └── theme/
│   │       └── app_theme.dart         — Material 3 theme (light/dark, seed color)
│   ├── features/
│   │   ├── auth/presentation/
│   │   │   ├── language_screen.dart   — 5-language selection (initial setup)
│   │   │   ├── login_screen.dart      — Email/Password login (Firebase Auth)
│   │   │   ├── register_screen.dart   — Email/Password registration
│   │   │   └── reset_password_screen.dart — Password reset via email
│   │   ├── home/presentation/
│   │   │   ├── home_screen.dart       — Dashboard (placeholder)
│   │   │   └── main_shell.dart        — BottomNavigationBar (5 tabs) + ShellRoute
│   │   ├── chat/presentation/
│   │   │   └── chat_screen.dart       — Placeholder
│   │   ├── tracker/presentation/
│   │   │   └── tracker_screen.dart    — Placeholder
│   │   ├── navigate/presentation/
│   │   │   └── navigate_screen.dart   — Placeholder
│   │   └── profile/presentation/
│   │       └── profile_screen.dart    — Placeholder
│   ├── l10n/
│   │   ├── app_en.arb                 — English (base)
│   │   ├── app_zh.arb                 — Chinese
│   │   ├── app_vi.arb                 — Vietnamese
│   │   ├── app_ko.arb                 — Korean
│   │   ├── app_pt.arb                 — Portuguese
│   │   └── app_localizations*.dart    — Generated localization files
│   └── main.dart                      — App entry point (ProviderScope, MaterialApp.router)
├── test/
│   ├── core/
│   │   ├── config/app_config_test.dart
│   │   └── providers/
│   │       ├── locale_test.dart
│   │       └── router_test.dart
│   ├── l10n/arb_test.dart
│   └── widget_test.dart
├── web/                               — Web platform files
├── pubspec.yaml
├── pubspec.lock
├── l10n.yaml                          — l10n generation config
└── analysis_options.yaml
```

## Key Design Decisions

1. **Auth guard via go_router redirect** — Centralized in `router_provider.dart`. Watches `authStateProvider` and redirects unauthenticated users to `/login`, authenticated users away from auth screens.
2. **ShellRoute for BottomNavigation** — `MainShell` wraps the 5 tab screens. `NoTransitionPage` for smooth tab switching.
3. **Locale as StateNotifier** — `LocaleNotifier` tracks selected language, persists across sessions (via `hasSelectedLanguage` flag). First visit shows language selection screen.
4. **dio AuthInterceptor** — Automatically attaches Firebase ID Token to `Authorization: Bearer` header on every API request.
5. **Mock auth mode** — When Firebase is not configured, auth provider uses a test stream. Allows development without Firebase project.

## BottomNavigation Tabs

| Index | Icon | Label | Route | Status |
|-------|------|-------|-------|--------|
| 0 | 🏠 | Home | /home | Placeholder |
| 1 | 💬 | Chat | /chat | Placeholder |
| 2 | 📋 | Tracker | /tracker | Placeholder |
| 3 | 🔍 | Navigate | /navigate | Placeholder |
| 4 | 👤 | Profile | /profile | Placeholder |

## Gaps / Next Steps

- [ ] Connect to real Firebase project (add `google-services.json` / `GoogleService-Info.plist`)
- [ ] Implement onboarding flow (`/onboarding` route + screen)
- [ ] Set up drift local DB schema for offline caching
- [ ] Apple Sign In integration
- [ ] Feature screens implementation (M1+)
- [ ] iOS/Android platform-specific setup (Info.plist, AndroidManifest.xml)
