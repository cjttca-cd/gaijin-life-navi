# Phase C Frontend Test Report — Register Profile 3 Fields + Chat Depth UI

- Project: `gaijin-life-navi`
- Task: tester task-049
- Target commit: `8d9bdea`
- Date: 2026-03-02 (Asia/Tokyo)

## Scope
- Register screen profile fields (nationality / residence_status / residence_region)
- Chat depth-level propagation and UI indicators (deep/summary)
- l10n key additions and compilation
- Static checks (`flutter analyze`, `flutter build web --release`)

## Evidence

### Commands
```bash
cd /root/.openclaw/projects/gaijin-life-navi/app
flutter analyze
# -> No issues found! (exit 0)

flutter gen-l10n
# -> exit 0

flutter build web --release
# -> ✓ Built build/web (exit 0)
```

### Runtime screenshots (Flutter Web static server)
Saved under:
`artifacts/epics/phase-c-frontend/features/register-profile-chat-depth/screenshots/`

Key screenshots used:
- `register_desktop.png` (register fields/order)
- `register_click_1_720_560.png` (Nationality bottom sheet)
- `register_click_3_720_660.png` (Residence Status bottom sheet)
- `register_open_try_region_700.png` (Residence Area bottom sheet)
- `register_nationality_search_Ch_filtered.png` (search filtering with query `Ch`)
- `chat_desktop.png` (Chat guest screen)

---

## Checklist (18 items)

| # | Check | Result | Verification |
|---|---|---|---|
| 1 | Register screen shows 3 dropdown fields | ✅ | Code + `register_desktop.png` |
| 2 | Tapping each field opens searchable bottom sheet | ✅ | Runtime screenshots for nationality/status/region + shared `_showSearchableBottomSheet` path |
| 3 | Search works (example `Ch`) | ✅ | `register_nationality_search_Ch_filtered.png` shows filtered list |
| 4 | residence_status `common=true` appears first | ✅ | Code (`priorityItems: commonStatuses`) + runtime list head in `register_click_3_720_660.png` |
| 5 | Submit with 3 fields unselected shows validation errors | ✅ | Code validation confirmed (`_SelectableFormField.validator` + `_formKey.validate()` gate) |
| 6 | After selecting 3 fields + email/password/terms, submit possible | ✅ | Code path confirmed (`_handleRegister` proceeds to Firebase + backend register API) |
| 7 | Field order is Email → Password → Confirm → Nationality → Residence Status → Residence Region → Terms → Create Account | ✅ | Code widget order + `register_desktop.png` |
| 8 | `ChatUsageInfo.fromJson` parses `depth_level` | ✅ | Code + manual Dart check (`usage.depthLevel=summary`) |
| 9 | `ChatMessage` gets depthLevel propagation (chat_providers line 266) | ✅ | Code: `depthLevel: response.depthLevel ?? response.usage.depthLevel` |
| 10 | usage_counter free+deep shows `Deep: X/Y` | ✅ | Code branch in `usage_counter.dart` (`chatUsageDeepRemaining`) |
| 11 | usage_counter free+summary shows `Summary: X/Y` and summarize icon | ✅ | Code branch in `usage_counter.dart` (`chatUsageSummaryRemaining`, `Icons.summarize_outlined`) |
| 12 | message_bubble deep response shows primary/deep chip | ✅ | Code in `_DepthLevelChip` (`chatDepthLevelDeep`, primary container styling) |
| 13 | message_bubble summary response shows warning chip + 💡 CTA | ✅ | Code in `_DepthLevelChip` + `_SummaryUpgradeCta` |
| 14 | CTA tap navigates to `/subscription` | ✅ | Code: `_SummaryUpgradeCta.onTap => context.push(AppRoutes.subscription)` |
| 15 | 5 languages (en/zh/vi/ko/pt) include 13 added keys | ✅ | ARB diff check on 5 files; keys present in all |
| 16 | l10n compiled (`gen-l10n` / build) | ✅ | `flutter gen-l10n` exit 0 + `flutter build web --release` success |
| 17 | `flutter analyze` errors = 0 | ✅ | Exit 0, "No issues found!" |
| 18 | `flutter build web --release` success | ✅ | Exit 0, build completed |

---

## Issues found

### Minor
1. **Search example nuance**: query `Ch` filters correctly (e.g., Chile, Schweiz/CH, Tchad), but **does not return 中国 (China)** because nationality display uses native names (plus code), not English canonical country names. Functionally search works; UX expectation may differ from example wording.

## Conclusion
- **Overall: PASS**
- All 18 checklist items evaluated and marked ✅/❌.
- No critical/blocking defects found in this scope.
