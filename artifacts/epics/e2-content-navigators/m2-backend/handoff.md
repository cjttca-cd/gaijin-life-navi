# M2 Backend Handoff

## Intent
Build the complete backend for all 5 M2 features: Banking Navigator, Visa Navigator, Admin Procedure Tracker, Document Scanner, and Medical Guide.

## Non-goals
- Flutter/client-side implementation
- Real Cloud Vision OCR integration (mock mode only)
- R2 file upload (mock file URLs)
- Community Q&A (M3)
- Stripe subscriptions (M4)

## Status: ✅ Complete

### Delivered

#### 1. DB Migration (`infra/migrations/versions/003_create_m2_tables.py`)
- 6 new tables: `banking_guides`, `visa_procedures`, `admin_procedures`, `user_procedures`, `document_scans`, `medical_phrases`
- All indexes from DATA_MODEL.md
- Soft-delete on `user_procedures` and `document_scans`
- `alembic upgrade head` verified OK

#### 2. SQLAlchemy Models
- **App Service** (`backend/app_service/models/`): `banking_guide.py`, `visa_procedure.py`, `admin_procedure.py`, `user_procedure.py`, `medical_phrase.py`
- **AI Service** (`backend/ai_service/models/`): `document_scan.py`
- All have JSON helper methods for multilingual JSONB field access

#### 3. App Service Routers (`backend/app_service/routers/`)

| Router | Endpoints | Auth |
|--------|----------|------|
| `banking.py` | `GET /banks` (public), `POST /recommend`, `GET /banks/:id/guide` | `/banks` public, others auth |
| `visa.py` | `GET /procedures`, `GET /procedures/:id` | Auth, Free=basic/Premium=full |
| `procedures.py` | `GET /templates`, `GET/POST /my`, `PATCH/DELETE /my/:id` | Auth, Free limit=3 |
| `medical.py` | `GET /emergency-guide`, `GET /phrases` | Auth |

**Onboarding** (`users.py`): TODO replaced with working implementation that auto-adds 5 essential procedures with due_date calculation.

#### 4. AI Service Router (`backend/ai_service/routers/documents.py`)
- `POST /scan` — mock OCR (Cloud Vision API key not required)
- `GET /` — cursor pagination
- `GET /:id`, `DELETE /:id` — detail & soft-delete
- Tier limits: Free=3/month, Premium=30/month, Premium+=unlimited

#### 5. Seed Scripts (`scripts/`)
- `seed_banking.py` — 5 banks (MUFG, SMBC, Mizuho, Japan Post, Shinsei) with multilingual data
- `seed_visa.py` — 6 visa procedures (renewal, change, permanent, reentry, work_permit, family)
- `seed_admin.py` — 7 admin procedures (5 arrival-essential + 2 others)
- `seed_medical.py` — 26 medical phrases (6 emergency, 10 symptom, 5 insurance, 5 general)
- All 5-language: en, zh, vi, ko, pt

## Verification

```bash
# Migration
cd infra/migrations && python -m alembic upgrade head

# Seeds
python scripts/seed_banking.py
python scripts/seed_visa.py
python scripts/seed_admin.py
python scripts/seed_medical.py

# Start App Service
cd backend/app_service && uvicorn main:app --port 8001

# Test endpoints (mock auth: Bearer test_user:test@example.com)
GET  http://localhost:8001/api/v1/banking/banks              → 5 banks
POST http://localhost:8001/api/v1/banking/recommend           → scored recommendations
GET  http://localhost:8001/api/v1/visa/procedures             → 6 procedures
GET  http://localhost:8001/api/v1/procedures/templates        → 7 templates
POST http://localhost:8001/api/v1/procedures/my               → add (Free: 4th → 403)
GET  http://localhost:8001/api/v1/medical/phrases             → 26 phrases
GET  http://localhost:8001/api/v1/medical/emergency-guide     → with disclaimer
POST http://localhost:8001/api/v1/users/me/onboarding         → auto-adds 5 procedures

# Start AI Service
cd backend/ai_service && uvicorn main:app --port 8002

POST http://localhost:8002/api/v1/ai/documents/scan           → mock OCR result
GET  http://localhost:8002/api/v1/ai/documents                → cursor pagination
```

## Gaps / Assumptions
- OCR is mock mode only — real Cloud Vision integration needed when API key is available
- File uploads create mock URLs (`mock://uploads/...`) — real R2 upload needed in production
- `scan_count_monthly` reset logic uses date comparison in-code (no batch job)
- `applicable_statuses` stored as JSON array string (not native PostgreSQL text[]) for SQLite compat
- Visa `check` endpoint (POST `/api/v1/visa/check`) not implemented (Premium-only, deferred)

## Next Steps
- M3: Community Q&A backend
- M4: Stripe subscription integration
- Flutter client for M2 features
- Real OCR integration when Cloud Vision API is configured
