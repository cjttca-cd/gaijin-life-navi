# M2 Flutter UI Handoff

## Intent
Implement Flutter UI screens for all 5 M2 features: Banking Navigator, Visa Navigator, Admin Tracker, Document Scanner, and Medical Guide. All screens use l10n for text, Riverpod for state management, and connect to the M2 backend APIs.

## Non-goals
- Real camera/gallery integration for Document Scanner (mock upload)
- Drift local caching of API responses
- Stripe subscription flow integration
- Community Q&A (M3)

## Status: ✅ Complete

### Delivered

#### 1. Banking Navigator (3 screens)
- **`/banking`** — `BankingListScreen`: Bank list sorted by foreigner_friendly_score, links to guide and recommend
- **`/banking/recommend`** — `BankingRecommendScreen`: Priority chip selection (multilingual, low_fee, atm, online) → recommendations with match_score, reasons, warnings
- **`/banking/:bankId`** — `BankingGuideScreen`: Required documents, conversation templates (Japanese + reading + translation), troubleshooting tips, source URL citation

**Files:**
- `app/lib/features/banking/domain/` — `bank.dart`, `bank_recommendation.dart`, `bank_guide.dart`
- `app/lib/features/banking/data/banking_repository.dart`
- `app/lib/features/banking/presentation/` — 3 screens + `providers/banking_providers.dart`

#### 2. Visa Navigator (2 screens)
- **`/visa`** — `VisaListScreen`: Procedure list with residence status filter chips, mandatory disclaimer banner
- **`/visa/:procedureId`** — `VisaDetailScreen`: Steps, required documents, fees, processing time, source URL, mandatory disclaimer

**Files:**
- `app/lib/features/visa/domain/visa_procedure.dart`
- `app/lib/features/visa/data/visa_repository.dart`
- `app/lib/features/visa/presentation/` — 2 screens + `providers/visa_providers.dart`

#### 3. Admin Tracker (3 screens)
- **`/tracker`** — `TrackerScreen` (replaced placeholder): Grouped by status (in_progress, not_started, completed), overdue warning, FAB to add, free tier limit banner
- **`/tracker/:id`** — `TrackerDetailScreen`: Status display, due date, notes, status change buttons (not_started ↔ in_progress ↔ completed), delete
- **`/tracker/add`** — `TrackerAddScreen`: Template list (essential vs others), add with 403 limit handling

**Files:**
- `app/lib/features/tracker/domain/` — `user_procedure.dart`, `procedure_template.dart`
- `app/lib/features/tracker/data/tracker_repository.dart`
- `app/lib/features/tracker/presentation/` — 3 screens + `providers/tracker_providers.dart`

#### 4. Document Scanner (3 screens)
- **`/scanner`** — `ScannerHomeScreen`: Camera/gallery scan buttons (mock upload), free tier limit info
- **`/scanner/:id`** — `ScannerResultScreen`: OCR text, translation, explanation, document type badge, processing/failed states
- **`/scanner/history`** — `ScannerHistoryScreen`: Scan history list with status icons

**Files:**
- `app/lib/features/scanner/domain/document_scan.dart`
- `app/lib/features/scanner/data/scanner_repository.dart`
- `app/lib/features/scanner/presentation/` — 3 screens + `providers/scanner_providers.dart`

#### 5. Medical Guide (1 screen, 2 tabs)
- **`/medical`** — `MedicalGuideScreen`: TabBar with Emergency + Phrases tabs
  - **Emergency tab**: Emergency number (119), how to call, what to prepare, useful phrases, mandatory disclaimer
  - **Phrases tab**: Category filter (all/emergency/symptom/insurance/general), Japanese + reading + translation + context, mandatory disclaimer

**Files:**
- `app/lib/features/medical/domain/` — `medical_phrase.dart`, `emergency_guide.dart`
- `app/lib/features/medical/data/medical_repository.dart`
- `app/lib/features/medical/presentation/` — 1 screen + `providers/medical_providers.dart`

#### 6. Updated Screens
- **`NavigateScreen`** — Converted from placeholder to hub with GridView: Banking, Visa, Scanner, Medical cards
- **`TrackerScreen`** — Replaced placeholder with full Admin Tracker
- **Router** — Added all M2 routes (banking×3, visa×2, tracker×2, scanner×3, medical×1)

#### 7. l10n (5 languages × 80+ new keys)
- All new UI text via ARB: `app_en.arb`, `app_zh.arb`, `app_vi.arb`, `app_ko.arb`, `app_pt.arb`
- Disclaimer texts for Visa and Medical as l10n keys
- No hardcoded strings

#### 8. Tests (73 total, all passing)
- `test/features/banking/domain/bank_models_test.dart` — 5 tests
- `test/features/visa/domain/visa_models_test.dart` — 4 tests
- `test/features/tracker/domain/tracker_models_test.dart` — 7 tests
- `test/features/scanner/domain/scanner_models_test.dart` — 5 tests
- `test/features/medical/domain/medical_models_test.dart` — 5 tests
- `test/core/providers/router_test.dart` — updated with M2 routes (14 tests)
- `test/l10n/arb_test.dart` — validates all 5 languages have matching keys

## Verification

```bash
cd app
export PATH="/root/flutter/bin:$PATH"
FLUTTER_ALLOW_ROOT=true flutter analyze      # 0 issues
FLUTTER_ALLOW_ROOT=true flutter test          # 73 tests pass
FLUTTER_ALLOW_ROOT=true flutter build web --release  # Build OK
```

### Routes verification:
- `/banking`, `/banking/recommend`, `/banking/:bankId` ✅
- `/visa`, `/visa/:procedureId` ✅
- `/tracker`, `/tracker/:id`, `/tracker/add` ✅
- `/scanner`, `/scanner/:id`, `/scanner/history` ✅
- `/medical` ✅
- Navigate tab → Banking/Visa/Scanner/Medical hub ✅
- Tracker tab → Admin Tracker ✅

## Invariant Rules Compliance
- ✅ Visa Navigator: Disclaimer banner on all screens
- ✅ Medical Guide: Disclaimer banner on all screens (both tabs)
- ✅ Tracker: Free tier limit banner (3 procedures), 403 handling
- ✅ Scanner: Free tier limit info (3 scans/month), 403 handling
- ✅ Banking: Source URL citation displayed
- ✅ All UI text via l10n ARB — no hardcoded strings
- ✅ API calls via `api_client.dart` (App Service) and `ai_api_client.dart` (AI Service)

## Gaps / Assumptions
- Document Scanner uses mock file upload (Uint8List) — real `image_picker` integration needed for production
- API response format assumed `{ "data": [...] }` or `{ "data": {...} }` wrapper — may need adjustment when integrating with actual backend
- No offline caching (drift) — screens show loading/error states
- Subscription tier checks are server-side; client only shows informational banners
- `FilledButton.tonalIcon` and `FilledButton.icon` used — requires Flutter 3.10+

## Next Steps
- M3: Community Q&A Flutter UI
- Real image_picker integration for Document Scanner
- Drift caching for offline support
- Integration testing with live backend
