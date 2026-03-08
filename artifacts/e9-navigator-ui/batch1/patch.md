# Navigator UI Batch 1 — Patch

## Change Summary

### Task A: TestFlight mode — hide subscription
- Wrapped subscription ListTile + divider in `if (!AppConfig.testFlightMode)` guard
- File: `app/lib/features/profile/presentation/profile_screen.dart`

### Task B: Replace search with AI banner
- **navigate_screen.dart**: Removed `_buildSearchBar`, `_buildSearchResults`, `_SearchGuideCard`, all search state. Replaced with `_AiBanner` widget using `primaryContainer` theme + `FilledButton.tonal` → `AppRoutes.chat`
- **guide_list_screen.dart**: Removed search bar, search state, and `_buildSearchEmpty` method
- **5-language ARB keys added**: `navAiSearchTitle`, `navAiSearchSubtitle`, `navAiSearchButton` (en/zh/vi/ko/pt)
- Converted `NavigateScreen` from `ConsumerStatefulWidget` to `ConsumerWidget` (no mutable state needed)

### Task C: Remove Coming Soon domains
- **Backend**: Removed `housing`, `employment`, `education` from `DOMAIN_CONFIG`
- **Frontend**: Removed `isComingSoon` getter from `NavigatorDomain`, removed `comingSoonDomains` filtering/rendering, removed `isComingSoon` parameter from `_DomainCard` and `_DomainGrid`
- Cleaned all `coming_soon`/`comingSoon`/`isComingSoon` references from `app/lib/features/navigate/`

### Task D: Domain descriptions
- **Backend**: Added `description` dict (`ja`/`zh`) to each domain in `DOMAIN_CONFIG`. `list_domains` endpoint now returns `description` resolved by `?lang=` (ja/zh specific, others fallback to ja).
- **Frontend**: Added `description` field to `NavigatorDomain` model + `fromJson`. `_DomainCard` displays description below guide count.

## Verification

```bash
# Backend tests
cd backend && python3 -m pytest tests/ -v    # 38/38 PASS

# Frontend static analysis
cd app && flutter analyze                     # No issues found

# Coming Soon grep (zero hits)
grep -rn "coming_soon\|comingSoon\|isComingSoon" app/lib/features/navigate/
```

## Risk & Rollback
- Low risk — purely UI/data changes, no auth/routing modifications
- Rollback: `git revert f864cad`
