# Trial Setup — Handoff

## Intent
Enable anonymous TestFlight users to provide profile info (nationality, residence status, region) via a non-dismissible dialog before accessing AI Chat, replacing the old `_testflight_hint` approach that asked the agent to collect this info mid-conversation.

## Non-goals
- No changes to production mode (TESTFLIGHT_MODE=false) behavior
- No changes to registered user flows
- No UI/UX changes to the profile_screen.dart

## Status: ✅ Complete

## Changes

### Backend
| File | Change |
|------|--------|
| `routers/profile_router.py` | Added `POST /api/v1/profile/trial-setup` endpoint with TrialSetupRequest schema |
| `routers/chat.py` | Removed `_testflight_hint` block (~12 lines at L393-404) |
| `services/agent.py` | Removed `_testflight_hint` processing (~4 lines at L136-138) |
| `tests/test_trial_setup.py` | 4 new tests: create profile / 404 in prod / idempotent / credit grant |

### Frontend
| File | Change |
|------|--------|
| `core/config/app_config.dart` | Added `testFlightMode` compile-time flag |
| `core/providers/router_provider.dart` | Added `_TrialSetupGate` widget between auth and chat list |
| `features/chat/presentation/widgets/trial_setup_dialog.dart` | New non-dismissible BottomSheet with 3 field pickers |
| `features/profile/data/profile_repository.dart` | Added `trialSetup()` method |
| `l10n/app_{en,zh,vi,ko,pt}.arb` | 5 new i18n keys each |

## Verification
- `cd backend && python3 -m pytest tests/ -v` → 38/38 passed
- `cd app && flutter analyze` → 0 new errors (5 pre-existing in navigator_providers.dart)
- `grep -rn "_testflight_hint" backend/ --include="*.py"` → 0 hits

## Gaps
- None identified

## Next Steps
- Build with `--dart-define=TESTFLIGHT_MODE=true` for TestFlight distribution
- Ensure `TESTFLIGHT_MODE=true` in backend .env for TestFlight server
