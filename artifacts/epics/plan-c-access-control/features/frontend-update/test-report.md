# Plan C Access Control E2E Verification Report

- Project: `gaijin-life-navi`
- Feature: `plan-c-access-control/frontend-update`
- Tester: subagent `task-045`
- Base commit under test: `1060276`
- Test date: 2026-02-28 (Asia/Tokyo)

## Scope
Plan C 4-tier access model verification (backend + frontend) based on the 12 requested checkpoints:
- backend limits / period propagation
- frontend guest/free UX branching
- l10n completeness across 5 locales
- static analysis and Flutter web release build

## Environment / Commands Run
```bash
# Backend syntax
python3 -c "import py_compile; py_compile.compile('backend/app_service/services/usage.py', doraise=True)"
python3 -c "import py_compile; py_compile.compile('backend/app_service/routers/chat.py', doraise=True)"
python3 -c "import py_compile; py_compile.compile('backend/app_service/routers/usage_router.py', doraise=True)"

# Flutter checks
cd app && flutter analyze
cd app && flutter build web --release

# L10n key + placeholder check
python3 (JSON validation script over app_{en,zh,vi,ko,pt}.arb)

# Guide inventory spot-check
python3 (count *.md under /root/.openclaw/agents/svc-*/workspace/guides)
```

## 12-Point Verification Matrix

| # | Checkpoint | Result | Evidence |
|---|---|---|---|
| 1 | Guest → Chat tab → auto anonymous auth → ChatListScreen | ✅ PASS | `app/lib/core/providers/router_provider.dart`: `_ChatTabRouter` routes unauthenticated users to `_AnonymousAuthGate` (line ~257), `_AnonymousAuthGate` calls `signInAnonymously(auth)` (line ~286), and renders `ChatListScreen` once user exists. `app/lib/core/providers/auth_provider.dart`: `signInAnonymously()` + `isAnonymousProvider` present. |
| 2 | Guest chat shows remaining X/5 (lifetime) | ✅ PASS | `backend/app_service/routers/usage_router.py`: guest tier `{"limit": 5, "period": "lifetime"}`. `app/lib/features/chat/presentation/widgets/usage_counter.dart`: when `usage.isLifetime`, text uses `l10n.usageLifetimeRemaining(remaining, limit)` (line ~96). |
| 3 | Guest exhausted (5/5) → register CTA (not upgrade) | ✅ PASS | `usage_counter.dart`: exhausted path checks `isGuest` and routes `context.push(AppRoutes.register)`; CTA text `l10n.chatGuestExhausted` (lines ~68-81). |
| 4 | Guest opens free guide → full content | ✅ PASS | `backend/app_service/routers/navigator.py`: for `access in ("public", "free")`, response returns `locked: False` and full `content` regardless of tier (lines ~406-417). |
| 5 | Guest opens premium guide → excerpt + gradient + Create Free Account CTA | ✅ PASS | Backend: `navigator.py` returns `locked: True`, `excerpt`, `register_cta: True` for unregistered guest (lines ~434-444). Frontend: `NavigatorGuideDetail` parses `register_cta` (`navigator_domain.dart` line ~124). `guide_detail_screen.dart` locked view uses register branch and routes to `/register` when `registerCta` is true (lines ~183, ~297-301) with gradient mask present (lines ~223-248). |
| 6 | Free user can view all 45 guides | ❌ FAIL | Access-control logic is correct (`navigator.py`: registered user gets full content for premium guides, lines ~420-431), but local guide inventory count is **39** (`svc-finance 7 + tax 3 + visa 8 + medical 11 + life 8 + legal 2 = 39`), not 45. Requirement text and local data are inconsistent, so “all 45” could not be validated as true in current environment. |
| 7 | Free chat shows remaining X/10 (lifetime) | ✅ PASS | Backend: `usage_router.py` free tier `{"limit": 10, "period": "lifetime"}` (line ~126). Frontend displays lifetime string via `usageLifetimeRemaining` for lifetime period (`usage_counter.dart` line ~96). |
| 8 | Free exhausted (10/10) → upgrade CTA | ✅ PASS | `usage_counter.dart`: exhausted + non-guest branch routes to `AppRoutes.subscription`; CTA text `l10n.chatFreeExhausted` (lines ~69-81). |
| 9 | Standard/Premium unchanged | ✅ PASS | `usage_router.py` tier limits remain `standard: 300/month`, `premium: unlimited`, `premium_plus: unlimited` (lines ~127-129). `services/usage.py` `_TIER_LIMITS` matches same operational limits. |
| 10 | L10n complete for 5 languages + ICU placeholders | ✅ PASS | Verified in all 5 ARB files (`app_en/zh/vi/ko/pt.arb`) that required 12 keys exist and placeholders are present (`usageLifetimeRemaining` has `{remaining}` + `{limit}`, `chatGuestUsageHint` has `{remaining}`) with corresponding metadata placeholder definitions under `@...`. |
| 11 | `flutter analyze` has no errors | ✅ PASS | Output: `No issues found! (ran in 2.2s)`; exit code 0. |
| 12 | `flutter build web --release` succeeds | ✅ PASS | Output: `✓ Built build/web`; exit code 0. |

## Additional Findings (Out-of-scope but Relevant)

1. **Plan metadata inconsistency in `/api/v1/plans`** — `backend/app_service/routers/usage_router.py` `PLANS` still states free as `ai_queries_limit: 20` and `ai_queries_period: "day"`, which conflicts with Plan C runtime enforcement (`10/lifetime`). This may cause frontend plan display inconsistencies if `/plans` is consumed.
2. **Documentation drift** — project docs still contain older limits in places (e.g., business-rules text), while runtime code is Plan C.

## Conclusion
- **Overall result: FAIL** (1 failing acceptance item: #6 “all 45 guides” could not be validated due local inventory mismatch).
- Functional Plan C access-control logic for guest/free/standard/premium and period propagation is otherwise implemented and passes code-level verification.
