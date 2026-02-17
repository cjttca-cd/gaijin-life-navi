# Patch: 結合テスト 6 Bug Fix (4 Critical + 2 Major)

## Change Summary

### 🔴 BUG-1: Banking router 未登録 (Critical) — FIXED
- **File**: `backend/app_service/main.py`
- **Change**: Added `banking` to router imports and `app.include_router(banking.router)`
- **Effect**: All `/api/v1/banking/*` endpoints now reachable (previously 404)

### 🔴 BUG-2: Usage API フィールド名不一致 (Critical) — FIXED
- **File**: `app/lib/features/usage/domain/usage_data.dart`
- **Change**: Rewrote `UsageData.fromJson` to read backend SSOT field names:
  - `chat_count` ← `queries_used_today`
  - `chat_limit` ← `daily_limit` (fallback: `monthly_limit`)
  - `chat_remaining` ← computed: `effectiveLimit - queriesUsed`
  - `period` ← derived: `"day"` if `daily_limit` set, else `"month"`
- **Principle**: Flutter adapts to Backend (SSOT)

### 🔴 BUG-3: Subscription plans パス不一致 (Critical) — FIXED
- **File**: `app/lib/features/subscription/data/subscription_repository.dart`
- **Change**: `/subscription/plans` → `/subscriptions/plans` (plural, matching backend route prefix)

### 🔴 BUG-4: Subscription plans レスポンス構造不一致 (Critical) — FIXED
- **Files**:
  - `app/lib/features/subscription/domain/subscription_plan.dart`
  - `app/lib/features/subscription/data/subscription_repository.dart`
  - `app/test/features/subscription/domain/subscription_models_test.dart`
- **Changes**:
  1. `SubscriptionPlan.features`: `Map<String, dynamic>` → `List<String>` (matches backend)
  2. `PlansData.fromList()`: new factory for flat list parsing (backend returns `data: [plan1, plan2]`)
  3. `SubscriptionRepository.getPlans()`: handles both List and Map `data` responses
  4. Tests updated to match new types and added `fromList` test case
- **Note**: UI (`subscription_screen.dart`) uses hardcoded l10n feature lists, not `plan.features` — no UI change needed

### 🟡 BUG-5: `/api/v1/auth/me` 未定義 (Major) — FIXED
- **File**: `backend/app_service/routers/auth.py`
- **Change**: Added `GET /api/v1/auth/me` endpoint that returns same `ProfileResponse` as `/users/me`
- **Purpose**: Future-proofing; Flutter currently uses Firebase Auth directly

### 🟡 BUG-6: Profile エンドポイント重複 (Major) — FIXED
- **File**: `backend/app_service/routers/profile_router.py`
- **Changes**:
  - `ProfileOut`: `uid` → `id`, `visa_type` → `residence_status`
  - `ProfileUpdate`: `visa_type` → `residence_status`
  - `_profile_to_out()`: unified field names with `/users/me` (`ProfileResponse`)
  - `update_profile()`: reads `body.residence_status` instead of `body.visa_type`
- **Impact**: Flutter uses `/users/me`, not `/profile`, so no client-side breakage

## Verification

### Static Analysis
- `dart analyze --fatal-infos` → 0 issues ✅
- `dart format --set-exit-if-changed .` → clean ✅
- `flutter test` → 42/42 passed ✅
- `ruff check` on modified Python files → All checks passed ✅

### Manual Verification Steps
1. **BUG-1**: `GET /api/v1/banking/banks` should return 200 (was 404)
2. **BUG-2**: `GET /api/v1/usage` response `queries_used_today`/`daily_limit` correctly parsed by Flutter `UsageData`
3. **BUG-3**: Flutter `getPlans()` hits `/subscriptions/plans` (plural)
4. **BUG-4**: Flutter correctly parses flat-list plans + `List<String>` features
5. **BUG-5**: `GET /api/v1/auth/me` returns profile data (same as `/users/me`)
6. **BUG-6**: `GET /api/v1/profile` returns `id`/`residence_status` (not `uid`/`visa_type`)

## Risk & Rollback
- **Low risk**: All changes are additive or field-name corrections
- **BUG-6 breaking change**: If any external client depends on `uid`/`visa_type` from `/api/v1/profile`, it will break. Mitigated: Flutter exclusively uses `/users/me`
- **Rollback**: `git revert <commit-hash>`
