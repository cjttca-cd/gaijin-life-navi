# Patch: API Response Structure Alignment

**Date**: 2026-02-17
**Task**: task-029

## Summary

Fixed all 5 modules where Flutter `fromJson` parsers crashed due to mismatches with backend API response structures. The fix principle: **align Flutter models to match backend's actual response**, with backend fixes only for Issue 5.1 (missing `title` field).

---

## Changes by Module

### Module 1: Banking Guide (`/api/v1/banking/banks/:id/guide`)

| File | Change | Reason |
|------|--------|--------|
| `app/lib/features/banking/domain/bank_guide.dart` | `BankGuide.fromJson`: pass root `json` to `Bank.fromJson` instead of `json['bank']` | Backend returns flat structure, no `bank` nesting (Issue 1.1) |
| `app/lib/features/banking/domain/bank_guide.dart` | `requirements`: `List<String>` → `Map<String, dynamic>` | Backend returns dict with `residence_card`, `min_stay_months`, `documents` keys (Issue 1.2) |
| `app/lib/features/banking/domain/bank_guide.dart` | `ConversationTemplate.fromJson`: `json['japanese']` → `json['ja']` | Seed data uses `ja` key (Issue 1.3) |
| `app/lib/features/banking/domain/bank_guide.dart` | `troubleshooting`: `List<String>?` → `List<TroubleshootingItem>?`; new `TroubleshootingItem` class | Backend returns `[{problem, solution}]` (Issue 1.4) |
| `app/lib/features/banking/presentation/banking_guide_screen.dart` | Updated requirements display to handle Map; troubleshooting now shows problem+solution | UI adapted to new model types |
| `app/test/features/banking/domain/bank_models_test.dart` | Updated test data to match real backend response shape | Tests aligned |

### Module 2: Medical Emergency Guide (`/api/v1/medical/emergency-guide`)

| File | Change | Reason |
|------|--------|--------|
| `app/lib/features/medical/domain/emergency_guide.dart` | `howToCall`: `String` → `List<String>` | Backend returns list of steps (Issue 2.1) |
| `app/lib/features/medical/domain/emergency_guide.dart` | `whatToPrepare`: `String` → `List<String>` | Backend returns list of items (Issue 2.2) |
| `app/lib/features/medical/domain/emergency_guide.dart` | `usefulPhrases`: `List<String>` → `List<EmergencyPhrase>`; new `EmergencyPhrase` class | Backend returns `[{ja, reading, translation}]` (Issue 2.3) |
| `app/lib/features/medical/domain/emergency_guide.dart` | Added `policeNumber` (String?) and `importantNotes` (List<String>) fields | Backend returns these but Flutter model was missing them (Issue 2.4) |
| `app/lib/features/medical/presentation/medical_guide_screen.dart` | Updated UI: howToCall/whatToPrepare render as bullet lists; phrases show ja/reading/translation | UI adapted to new model types |
| `app/test/features/medical/domain/medical_models_test.dart` | Updated test data with real backend response shape; added EmergencyPhrase tests | Tests aligned |

### Module 3: Visa Procedure (`/api/v1/visa/procedures/:id`)

| File | Change | Reason |
|------|--------|--------|
| `app/lib/features/visa/domain/visa_procedure.dart` | `requiredDocuments`: `List<String>` → `List<VisaDocument>`; new `VisaDocument` class with `name`, `howToGet` | Backend returns `[{name, how_to_get}]` (Issue 3.1) |
| `app/lib/features/visa/domain/visa_procedure.dart` | `fees`: `String?` → `Map<String, dynamic>?` | Backend returns dict `{application_fee, currency, notes}` (Issue 3.2) |
| `app/lib/features/visa/domain/visa_procedure.dart` | `processingTime`: reads from `json['estimated_duration']` with fallback to `json['processing_time']` | Backend field name is `estimated_duration` (Issue 3.3) |
| `app/lib/features/visa/domain/visa_procedure.dart` | `VisaStep.stepNumber`: reads from `json['order']` with fallback to `json['step_number']` | Seed data uses `order` key (Issue 3.4) |
| `app/lib/features/visa/presentation/visa_detail_screen.dart` | Updated: documents show name+howToGet; fees formatted from map; added `_formatFees` helper | UI adapted to new model types |
| `app/test/features/visa/domain/visa_models_test.dart` | Updated test data; added VisaDocument tests | Tests aligned |

### Module 4: Tracker Templates (`/api/v1/procedures/templates`)

| File | Change | Reason |
|------|--------|--------|
| `app/lib/features/tracker/domain/procedure_template.dart` | `procedureType`: reads `json['procedure_code']` with fallback to `json['procedure_type']` | Backend returns `procedure_code` (Issue 4.1) |
| `app/lib/features/tracker/domain/procedure_template.dart` | `title`: reads `json['procedure_name']` with fallback to `json['title']` | Backend returns `procedure_name` (Issue 4.2) |
| `app/test/features/tracker/domain/tracker_models_test.dart` | Updated test data with `procedure_code`/`procedure_name`; added fallback test | Tests aligned |

### Module 5: User Procedures (`/api/v1/procedures/my`)

| File | Change | Reason |
|------|--------|--------|
| `backend/app_service/routers/procedures.py` | `_user_procedure_to_dict`: added `title` param (default `""`) and includes it in response | Backend had no `title` field in response (Issue 5.1) |
| `backend/app_service/routers/procedures.py` | Added `_resolve_procedure_title()` helper to look up name from AdminProcedure or VisaProcedure | Resolves display title from reference |
| `backend/app_service/routers/procedures.py` | `list_my_procedures`: resolves title for each procedure; added `lang` query param | Title now included in list response |
| `backend/app_service/routers/procedures.py` | `add_procedure`: resolves title from already-loaded `ref` | Title included in create response |
| `backend/app_service/routers/procedures.py` | `update_procedure`: resolves title before returning | Title included in update response |
| `app/test/features/tracker/domain/tracker_models_test.dart` | Added test for missing `title` graceful handling | Defensive test |

---

## Verification

- `dart analyze --fatal-infos` → 0 issues ✅
- `flutter test` → 104 tests passed (0 failures) ✅
- Backend import check → `from main import app; print('OK')` → OK ✅

## Risk & Rollback

- **Risk**: Low. All changes are backward-compatible with fallbacks in Flutter `fromJson`.
- **Breaking change scope**: Flutter model types changed (e.g., `List<String>` → `List<VisaDocument>`). Any code outside the modified presentation files that directly accesses these fields by old type will fail at compile time (caught by `dart analyze`).
- **Rollback**: Revert the commit. No DB migrations involved.
