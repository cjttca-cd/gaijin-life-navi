# Flutter Phase 2 — Navigator + Emergency + Subscription + Profile/Settings Handoff

## Intent
Rebuild Phase 2 screens (Navigator S09-S11, Emergency S12, Subscription S16, Profile S13-S15) to be fully compliant with DESIGN_SYSTEM.md and the designer's visual handoff specifications.

## Non-goals
- Backend API changes (Flutter-side only)
- Dark mode
- Admin Tracker UI (deferred — existing screens already functional)
- IAP integration (placeholder for App Store / Google Play billing)

## Status: ✅ Complete

## What was delivered

### 1. Navigator Screens (S09-S11)

| Screen | File | Key behaviors |
|--------|------|---------------|
| S09 Navigator Top | `navigate/presentation/navigate_screen.dart` | 2-column domain grid, 8 domains with accent colors, Coming Soon cards at 0.5 opacity, snackbar for coming_soon taps |
| S10 Guide List | `navigate/presentation/guide_list_screen.dart` | Domain-filtered guide list, pill search bar, left accent bar cards, coming_soon empty state with "Ask AI" CTA |
| S11 Guide Detail | `navigate/presentation/guide_detail_screen.dart` | Markdown content rendering, blockquote styling, disclaimer banner, share action, "Ask AI" CTA |

**Supporting files:**
- `navigate/domain/navigator_domain.dart` — NavigatorDomain, NavigatorGuide, NavigatorGuideDetail models
- `navigate/data/navigator_repository.dart` — API client for /navigator/* endpoints
- `navigate/presentation/providers/navigator_providers.dart` — Riverpod providers
- `core/theme/domain_colors.dart` — DomainColorSet + DomainColors helper (§1.7 colors + icons)

### 2. Emergency Screen (S12)

| File | Key behaviors |
|------|---------------|
| `medical/presentation/emergency_screen.dart` | Red AppBar, warning banner, 5 emergency contacts with call buttons, ambulance steps with numbered circles, Japanese phrases (always shown), disclaimer, "Chat with AI" CTA |

- **110/119 always available** — hardcoded in UI, not dependent on API
- Contact cards are fully tappable → tel: URI launch
- No auth required (added to public routes)
- Now properly integrated as SOS tab in BottomNavigationBar

### 3. Subscription Screen (S16)

| File | Key behaviors |
|------|---------------|
| `subscription/presentation/subscription_screen.dart` | Current plan card, horizontal PageView with 3 plan cards (Free/Standard/Premium), RECOMMENDED badge on Standard, charge packs, expandable FAQ, footer |

- Plan comparison with ✓/✗ feature list
- colorSuccess for included features, colorOnSurfaceVariant for excluded
- Recommended plan: colorPrimaryFixed bg + 2dp primary border + Level 1 elevation

### 4. Profile & Settings Screens (S13-S15)

| Screen | File | Key behaviors |
|--------|------|---------------|
| S13 Profile | `profile/presentation/profile_screen.dart` | Geometric avatar (initials, primary bg), tier badge, info card with label-value rows, usage stats, manage subscription link |
| S14 Profile Edit | `profile/presentation/profile_edit_screen.dart` | Save in AppBar (enabled only when changed), unsaved changes dialog, dropdown fields |
| S15 Settings | `profile/presentation/settings_screen.dart` | Grouped sections (General/Account/Danger/About), language BottomSheet, logout/delete confirmation dialogs, footer |

### 5. Route Updates

- Added `/emergency` route (SOS tab, public, no auth)
- Added `/navigate/:domain` route (Guide List)
- Added `/navigate/:domain/:slug` route (Guide Detail)
- Updated MainShell to use `/emergency` instead of `/medical` placeholder
- Emergency route added to ShellRoute for proper tab behavior

### 6. Localization (5 languages complete)

All new UI text added to ARB files:
- `app_en.arb` — 120+ new keys
- `app_zh.arb` — Chinese translations
- `app_vi.arb` — Vietnamese translations
- `app_ko.arb` — Korean translations
- `app_pt.arb` — Portuguese translations

Zero hardcoded strings. All UI text via `AppLocalizations`.

## Verification

```bash
cd app/
dart analyze --fatal-infos    # 0 issues
flutter test                  # 104 tests pass
flutter build web --release   # ✓ success
dart format --set-exit-if-changed lib/  # 0 unformatted
```

## Design System Compliance

- ✅ Zero hex hardcoding outside `app_colors.dart` / `app_theme.dart` / `domain_colors.dart`
- ✅ All colors via `Theme.of(context).colorScheme.*` or `AppColors.*` tokens
- ✅ All spacing via `AppSpacing.*` constants
- ✅ Typography via `Theme.of(context).textTheme.*`
- ✅ Domain Accent Colors applied per §1.7 (8 domains)
- ✅ Emergency AppBar: colorError bg, white text (§8.4)
- ✅ SOS tab icon always colorError
- ✅ Section headers: labelSmall, uppercase, colorOnSurfaceVariant
- ✅ Card styling: radiusMd (12dp), outlineVariant border, surface bg
- ✅ Button styling: Primary/Tonal/Outline per design system

## Gaps / Known Issues

1. **Admin Tracker UI** — Not rebuilt in this phase. Existing tracker screens remain functional but don't follow the new design system. Can be addressed in a future task.
2. **IAP Integration** — Subscription purchase buttons use `url_launcher` to open Stripe checkout URL. Native App Store/Google Play billing is not yet implemented.
3. **Share functionality** — Guide detail share button is a placeholder. Needs platform share sheet integration (`share_plus` package).
4. **Image assets** — No custom domain icons; using Material Icons as specified in handoff.
5. **Conversation Templates / Troubleshooting** — Guide detail renders all content via Markdown. Specialized section rendering (e.g., conversation template tables) depends on backend providing structured markdown.

## Next Steps

- Admin Tracker UI design system rebuild
- IAP integration for subscription purchases
- Share functionality with deep links
- Widget tests for new screens
- Performance optimization (lazy loading domain data)
