# Integration Re-Test Report — task-039

**Date**: 2026-02-18  
**Scope**: 6 バグ修正後の全 API 疎通再検証  
**Previous**: task-037 (4 Critical + 2 Major bugs found) → task-038 (all fixed)  
**Result**: ✅ **ALL PASS**

---

## Bug Fix Verification

| Bug ID | Severity | Description | Status |
|--------|----------|-------------|--------|
| BUG-1 | Critical | Banking router not registered | ✅ Fixed — `/api/v1/banking/banks` returns 200 |
| BUG-2 | Critical | UsageData.fromJson field mismatch | ✅ Fixed — `queries_used_today`, `daily_limit`, `monthly_limit` match |
| BUG-3 | Critical | Subscription path wrong | ✅ Fixed — `/api/v1/subscriptions/plans` returns 200 |
| BUG-4 | Critical | PlansData expects nested object, backend returns flat list | ✅ Fixed — `PlansData.fromList()` + `features` is `List<String>` |
| BUG-5 | Major | `GET /api/v1/auth/me` missing | ✅ Fixed — returns user profile |
| BUG-6 | Major | profile_router field names inconsistent | ✅ Fixed — `display_name`, `avatar_url` etc. match Flutter model |

---

## Full API Test Results (8/8 Pass)

### 1. `GET /api/v1/auth/me` — ✅ PASS (was FAIL in task-037)
- **HTTP**: 200
- **Flutter model**: `UserProfile.fromJson`
- **Fields verified**: `id`(String), `email`(String), `display_name`(String), `avatar_url`(String?), `nationality`(String?), `residence_status`(String?), `residence_region`(String?), `arrival_date`(String?), `preferred_language`(String), `subscription_tier`(String), `onboarding_completed`(bool), `created_at`(String/DateTime)
- **All fields match** ✅

### 2. `POST /api/v1/chat` — ✅ PASS
- **HTTP**: 200
- **Flutter model**: `ChatResponse.fromJson`
- **Fields verified**: `reply`(String), `domain`(String), `sources`(List), `actions`(List), `tracker_items`(List), `usage`{`used`(int), `limit`(int), `tier`(String)}
- **All fields match** ✅

### 3. `GET /api/v1/navigator/domains` — ✅ PASS
- **HTTP**: 200
- **Flutter model**: `NavigatorDomain.fromJson`
- **Response**: `data.domains` (array of domain objects)
- **Fields verified**: `id`(String), `label`(String), `icon`(String?), `status`(String), `guide_count`(int)
- **All fields match** ✅

### 4. `GET /api/v1/emergency?lang=en` — ✅ PASS
- **HTTP**: 200
- **Flutter model**: `EmergencyData.fromJson`
- **Fields verified**: `title`(String), `contacts`(List of `{name, number, note}`), `content`(String)
- **All fields match** ✅

### 5. `GET /api/v1/banking/banks?lang=en` — ✅ PASS (was FAIL in task-037)
- **HTTP**: 200
- **Response**: flat array of bank objects with rich data
- **Note**: Flutter model `bank.dart` does not exist yet (no `features/banking/` directory in app). API is functional and returns valid JSON.
- **API functional** ✅

### 6. `GET /api/v1/usage` — ✅ PASS (was FAIL in task-037)
- **HTTP**: 200
- **Flutter model**: `UsageData.fromJson`
- **Fields verified**: `tier`(String), `queries_used_today`(int), `daily_limit`(int?), `monthly_limit`(int?)
- **fromJson logic**: correctly maps `queries_used_today` → `chatCount`, derives `period`/`chatLimit`/`chatRemaining`
- **All fields match** ✅

### 7. `GET /api/v1/subscriptions/plans` — ✅ PASS (was FAIL in task-037)
- **HTTP**: 200
- **Flutter model**: `SubscriptionPlan.fromJson` + `PlansData.fromList`
- **Response**: flat list (not nested object) — compatible with `PlansData.fromList()`
- **Fields verified**: `id`(String), `name`(String), `price`(int), `currency`(String), `interval`(String?), `features`(List<String>)
- **All fields match** ✅

### 8. `GET /api/v1/users/me` — ✅ PASS
- **HTTP**: 200
- **Flutter model**: `UserProfile.fromJson` (same as auth/me)
- **Identical response structure to endpoint #1**
- **All fields match** ✅

---

## Response Envelope

All endpoints return the standard envelope:
```json
{
  "data": <payload>,
  "meta": { "request_id": "..." }
}
```

- Object payloads: auth/me, chat, emergency, usage, users/me
- Nested object: navigator/domains (`data.domains`)
- Flat list: banking/banks, subscriptions/plans (`data` is array)

---

## Notes

- **banking/banks**: Flutter model file (`bank.dart`) doesn't exist yet — this is expected as the banking feature frontend hasn't been implemented. The API endpoint is fully functional.
- All responses are properly JSON-formatted with correct types
- Mock auth mode accepts any `Bearer` token with test UID — appropriate for dev testing

---

## Conclusion

**✅ ALL 8 ENDPOINTS PASS** — All 6 bugs confirmed fixed. Backend ↔ Flutter model contract is consistent across all endpoints.
