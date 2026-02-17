# Integration Test Report — task-037
## Backend + Flutter Web Phase 0 API 疎通検証

**Date:** 2026-02-18  
**Tester:** tester (automated)  
**Prev commit:** `2fd53e2 refactor: rewire Flutter to Phase 0 API`

---

## 1. Static Checks

| Check | Result |
|-------|--------|
| `dart analyze --fatal-infos` | ✅ PASS — No issues found |
| `flutter test` | ✅ PASS — 41/41 tests passed |
| `flutter build web --release` | ✅ PASS — Built in 59.9s |

---

## 2. Backend Startup

- FastAPI started successfully on port 8000
- Mock auth mode active (FIREBASE_CREDENTIALS not set)
- Mock Stripe mode active (STRIPE_SECRET_KEY not set)
- Seed scripts ran successfully (5 banks, 6 visa procedures, 26 medical phrases)

---

## 3. API Endpoint Test Results

### Summary Table

| # | Endpoint | HTTP Status | `{"data": ...}` Format | Flutter Compatible | Verdict |
|---|----------|-------------|------------------------|--------------------|---------|
| 1 | `GET /api/v1/auth/me` | **404** | N/A | N/A | ❌ FAIL — endpoint does not exist |
| 2 | `POST /api/v1/chat` | **200** | ✅ Yes | ✅ Yes | ✅ PASS |
| 3 | `GET /api/v1/navigator/domains` | **200** | ✅ Yes | ✅ Yes | ✅ PASS |
| 4 | `GET /api/v1/emergency` | **200** | ✅ Yes | ✅ Yes | ✅ PASS |
| 5 | `GET /api/v1/banking/banks` | **404** | N/A | N/A | ❌ FAIL — router not registered |
| 6 | `GET /api/v1/usage` | **200** | ✅ Yes | ❌ **Mismatch** | ❌ FAIL |
| 7 | `GET /api/v1/subscriptions/plans` | **200** | ✅ Yes | ❌ **Mismatch** | ❌ FAIL |
| 8 | `GET /api/v1/users/me` | **200** | ✅ Yes | ✅ Yes | ✅ PASS |

**Result: 4 PASS / 4 FAIL**

---

### Detailed Response Samples

#### ✅ 2. POST /api/v1/chat → 200
```json
{
  "data": {
    "reply": "Hello! 👋 What can I help you with today? 😊",
    "domain": "concierge",
    "sources": [],
    "actions": [],
    "tracker_items": [],
    "usage": { "used": 3, "limit": 5, "tier": "free" }
  },
  "meta": { "request_id": "..." }
}
```
**Flutter match:** `ChatResponse.fromJson` expects `reply`, `domain`, `sources`, `actions`, `tracker_items`, `usage.{used,limit,tier}` → **All fields match ✅**

#### ✅ 3. GET /api/v1/navigator/domains → 200
```json
{
  "data": {
    "domains": [
      { "id": "banking", "label": "Banking & Finance", "icon": "🏦", "status": "active", "guide_count": 6 },
      { "id": "visa", "label": "Visa & Immigration", "icon": "🛂", "status": "active", "guide_count": 6 },
      ...
    ]
  }
}
```
**Flutter match:** `NavigatorDomain.fromJson` expects `id`, `label`, `icon`, `status`, `guide_count` → **All fields match ✅**  
`NavigatorRepository.getDomains()` accesses `data['domains']` → **Structure match ✅**

#### ✅ 4. GET /api/v1/emergency → 200
```json
{
  "data": {
    "title": "緊急時対応ガイド",
    "contacts": [
      { "name": "Police", "number": "110", "note": "" },
      { "name": "Fire / Ambulance", "number": "119", "note": "" },
      ...
    ],
    "content": "[markdown content]"
  }
}
```
**Flutter match:** `EmergencyData.fromJson` expects `title`, `contacts[].{name,number,note}`, `content` → **All fields match ✅**

#### ❌ 5. GET /api/v1/banking/banks → 404
Router file `routers/banking.py` exists but is **NOT imported or registered** in `main.py`.

#### ❌ 6. GET /api/v1/usage → 200 (but field mismatch)
```json
{
  "data": {
    "tier": "free",
    "queries_used_today": 0,
    "daily_limit": 5,
    "monthly_limit": null
  }
}
```
**Flutter mismatch:** `UsageData.fromJson` expects:
| Flutter field | Expected key | Backend key | Match |
|---------------|-------------|-------------|-------|
| `chatCount` | `chat_count` | `queries_used_today` | ❌ |
| `chatLimit` | `chat_limit` | `daily_limit` | ❌ |
| `chatRemaining` | `chat_remaining` | *(not present)* | ❌ |
| `period` | `period` | *(not present)* | ❌ |
| `tier` | `tier` | `tier` | ✅ |

**Result:** 4 out of 5 fields mismatched — `UsageData` will parse with all defaults (0/null).

#### ❌ 7. GET /api/v1/subscriptions/plans → 200 (but structure mismatch)
```json
{
  "data": [
    {
      "id": "premium_monthly", "name": "Premium", "price": 500,
      "currency": "jpy", "interval": "month",
      "features": ["Unlimited AI chat", "30 document scans/month", ...]
    },
    ...
  ]
}
```
**Flutter issues:**

1. **Path mismatch:** Flutter `SubscriptionRepository` calls `/subscription/plans` (singular) → 404.  
   Backend route is `/subscriptions/plans` (plural).

2. **Response structure mismatch:** Flutter `PlansData.fromJson` expects:
   ```json
   { "plans": [...], "charge_packs": [...] }
   ```
   Backend returns a flat list `[plan1, plan2]`, not a map with `plans` and `charge_packs` keys.

3. **`features` type mismatch:** Backend returns `features` as `List<String>`.  
   Flutter `SubscriptionPlan.fromJson` expects `features` as `Map<String, dynamic>`.

**Note:** There is an alternative endpoint `GET /api/v1/plans` that returns `{"plans": [...], "charge_packs": [...]}` with `features` as a Map — closer to Flutter's expectation, but:
- Uses `billing_period` instead of `interval`
- Charge pack fields use `queries` instead of Flutter's expected `chats`
- Path doesn't match Flutter's call

#### ✅ 8. GET /api/v1/users/me → 200
```json
{
  "data": {
    "id": "test", "email": "mock@example.com", "display_name": "",
    "avatar_url": null, "nationality": null, "residence_status": null,
    "residence_region": null, "arrival_date": null,
    "preferred_language": "en", "subscription_tier": "free",
    "onboarding_completed": false, "created_at": "2026-02-17T23:41:05"
  }
}
```
**Flutter match:** `UserProfile.fromJson` expects `id`, `email`, `display_name`, `avatar_url`, `nationality`, `residence_status`, `residence_region`, `arrival_date`, `preferred_language`, `subscription_tier`, `onboarding_completed`, `created_at` → **All fields match ✅**

---

## 4. Visual Confirmation (Flutter Web)

| Screenshot | File | Size | Description |
|------------|------|------|-------------|
| S01 | `S01_language_selection.png` | 26,322 bytes | ✅ Language selection screen with 5 languages displayed correctly |
| S02 | `S02_emergency.png` | 8,329 bytes | ⚠️ SOS tab selected, bottom nav rendered, content area empty (expected — no Firebase Auth in test env) |

Screenshots saved to: `artifacts/epics/e4-api-integration/features/integration-test/screenshots/`

---

## 5. Bug List

### 🔴 BUG-1: Banking router not registered (Critical)

**Location:** `backend/app_service/main.py`  
**Issue:** `routers/banking.py` defines endpoints (`GET /api/v1/banking/banks`, `POST /api/v1/banking/recommend`, `GET /api/v1/banking/banks/{bank_id}/guide`) but is NOT imported or included via `app.include_router()` in `main.py`.  
**Impact:** All banking endpoints return 404. Flutter's banking features completely non-functional.  
**Fix:** Add `from routers import banking` and `app.include_router(banking.router)` to `main.py`.

### 🔴 BUG-2: Usage API response field names mismatch (Critical)

**Location:** `backend/app_service/routers/usage_router.py` vs `app/lib/features/usage/domain/usage_data.dart`  
**Issue:** Backend returns `queries_used_today`, `daily_limit`, `monthly_limit`. Flutter expects `chat_count`, `chat_limit`, `chat_remaining`, `period`.  
**Impact:** `UsageData` will be populated with all-zero/null defaults. Usage display will be incorrect.  
**Fix:** Either rename backend response fields to match Flutter, or update Flutter's `fromJson` to match backend field names. Recommendation: align both to one standard.

### 🔴 BUG-3: Subscription plans — path mismatch (Critical)

**Location:** `app/lib/features/subscription/data/subscription_repository.dart`  
**Issue:** Flutter calls `GET /subscription/plans` (singular). Backend route is `/subscriptions/plans` (plural).  
**Impact:** Flutter will receive 404 when fetching subscription plans.  
**Fix:** Change Flutter path to `/subscriptions/plans` or add a singular alias on the backend.

### 🔴 BUG-4: Subscription plans — response structure mismatch (Critical)

**Location:** `backend/app_service/routers/subscriptions.py` vs `app/lib/features/subscription/domain/subscription_plan.dart`  
**Issue:** Multiple mismatches:
1. Backend `data` is a flat list `[plan1, plan2]`. Flutter `PlansData.fromJson` expects `{"plans": [...], "charge_packs": [...]}`.
2. Backend `features` is `List<String>`. Flutter expects `Map<String, dynamic>`.
3. No `charge_packs` in response.  
**Impact:** `PlansData.fromJson` will crash or return empty plans.  
**Fix:** Either restructure backend response to match Flutter expectations, or rewrite Flutter's parsing to match backend format.

### 🟡 BUG-5: `/api/v1/auth/me` endpoint missing (Major)

**Location:** `backend/app_service/routers/auth.py`  
**Issue:** No `GET /api/v1/auth/me` endpoint defined. Auth router only has `/register` and `/delete-account`.  
**Impact:** If any Flutter code or test calls this endpoint, it will 404. Currently Flutter's `auth_provider.dart` uses Firebase Auth directly, so this may not be blocking at runtime.  
**Note:** The task contract explicitly lists this endpoint for testing, suggesting it was expected to exist.

### 🟡 BUG-6: Dual profile endpoints with inconsistent field names (Major)

**Location:** `routers/users.py` (GET `/users/me`) vs `routers/profile_router.py` (GET `/profile`)  
**Issue:**  
- `/users/me` returns `id`, `residence_status`  
- `/profile` returns `uid`, `visa_type`  
**Impact:** Two different response shapes for essentially the same data. Flutter uses `/users/me` (correct match), but having two inconsistent endpoints is a maintenance risk.  
**Fix:** Deprecate one or align field names.

---

## 6. Conclusion

### Verdict: ❌ FAIL

**Reason:** 4 of 8 API endpoints have issues (1 missing route, 1 not registered, 2 with response structure mismatches). The critical mismatches in Usage API and Subscription Plans API mean Flutter cannot correctly parse these responses. The unregistered banking router means the entire banking feature is inaccessible.

### Passing criteria assessment:
- ✅ Static checks all pass (dart analyze, flutter test, flutter build web)
- ❌ NOT all API endpoints return HTTP 200 (auth/me → 404, banking → 404)
- ❌ NOT all response structures match Flutter fromJson expectations (usage, subscription plans)
- ✅ Test report created

### Priority fixes needed:
1. **BUG-1** — Register banking router (1-line fix)
2. **BUG-2** — Align usage API field names
3. **BUG-3** — Fix subscription plans path (singular vs plural)
4. **BUG-4** — Align subscription plans response structure
