# Handoff: Backend + Infrastructure Scaffold

## Intent

Build the foundational monorepo structure with FastAPI App Service, Alembic migrations, and Cloudflare Workers API gateway — enough for subsequent features to build upon.

## Non-goals

- Full CRUD for all entities (only profiles + daily_usage in this scaffold)
- AI Service implementation (placeholder routing only)
- Stripe integration (mentioned in delete-account as TODO)
- Production PostgreSQL deployment
- Automated tests (scaffold only)

## Status: ✅ Complete

All deliverables verified:

| Check | Result |
|-------|--------|
| `pip install -r requirements.txt` | ✅ Success |
| `python -c "from main import app; print('OK')"` | ✅ OK (mock auth mode) |
| `alembic upgrade head` (SQLite) | ✅ Tables created correctly |
| Routers registered | ✅ 6 API endpoints |
| Git commit | ✅ `f39e79e` |

## Verification

```bash
# Activate venv
source .venv/bin/activate

# 1. Import test
cd backend/app_service && python -c "from main import app; print('OK')"

# 2. Migration test
cd infra/migrations && rm -f test.db && alembic upgrade head

# 3. Route check
cd backend/app_service && python -c "
from main import app
for r in app.routes:
    if hasattr(r, 'methods'):
        for m in r.methods:
            if m not in ('HEAD','OPTIONS'):
                print(f'{m:6s} {r.path}')
"
```

## File Structure

```
backend/
  app_service/
    main.py              — FastAPI app init (CORS, router registration)
    config.py            — Pydantic Settings (env vars)
    database.py          — AsyncSession, SQLAlchemy async engine
    Dockerfile           — Multi-stage Python 3.12 container
    requirements.txt     — FastAPI, SQLAlchemy, Alembic, firebase-admin, etc.
    models/
      __init__.py
      profile.py         — Profile model (DATA_MODEL.md §1)
      daily_usage.py     — DailyUsage model (DATA_MODEL.md §4)
    schemas/
      __init__.py
      common.py          — ErrorResponse, SuccessResponse wrappers
      auth.py            — RegisterRequest/Response
      users.py           — ProfileResponse, UpdateProfileRequest, OnboardingRequest
    routers/
      __init__.py
      health.py          — GET /api/v1/health
      auth.py            — POST /api/v1/auth/register, /delete-account
      users.py           — GET/PATCH /api/v1/users/me, POST /me/onboarding
    services/
      __init__.py
      auth.py            — Firebase Admin SDK token verification + mock mode
  shared/
    __init__.py          — Placeholder

infra/
  migrations/
    alembic.ini          — Alembic config (defaults to SQLite)
    env.py               — Migration environment (SQLite + PostgreSQL compatible)
    script.py.mako       — Migration template
    versions/
      001_create_profiles_and_daily_usage.py — Initial tables
  api-gateway/
    wrangler.toml        — Cloudflare Workers config
    package.json         — npm deps (wrangler)
    src/
      index.js           — JWT verification + routing + CORS + rate limit placeholder
  firebase/
    .gitkeep             — Configuration placeholder
```

## Key Decisions

1. **SQLite for local dev** — `render_as_batch=True` in Alembic env.py; `aiosqlite` driver in SQLAlchemy. Database URL auto-switches via `DATABASE_URL` env var.
2. **Firebase mock mode** — When `FIREBASE_CREDENTIALS` is empty, `services/auth.py` accepts any Bearer token with format `uid:email` or defaults. Logs a warning on startup.
3. **String-based subscription_tier** — Used `String(20)` instead of native PostgreSQL ENUM for SQLite compatibility. Can be tightened with a CHECK constraint or ENUM migration for production.
4. **UUID as String(36)** for daily_usage.id — SQLite doesn't have native UUID type. Python-side UUID generation via `uuid.uuid4()`.
5. **Inline UniqueConstraint** for daily_usage(user_id, usage_date) — SQLite doesn't support `ALTER TABLE ADD CONSTRAINT`.

## Gaps / Next Steps

- [ ] Add remaining SQLAlchemy models (chat_sessions, chat_messages, etc.) as needed by features
- [ ] Implement `POST /api/v1/users/me/onboarding` auto-add of 5 essential procedures (requires admin_procedures + user_procedures tables)
- [ ] Add Stripe subscription cancellation in delete-account flow
- [ ] Production Dockerfile testing
- [ ] PostgreSQL-specific migration (native ENUM types, triggers for updated_at)
- [ ] Unit/integration tests
- [ ] Firebase Admin SDK real credentials testing
