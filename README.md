# Gaijin Life Navi 🌏

> AI-powered life concierge for foreign residents in Japan.

## Architecture

```
├── backend/
│   ├── app_service/      # FastAPI App Service (Auth, Users, etc.)
│   └── shared/           # Shared utilities
├── infra/
│   ├── migrations/       # Alembic PostgreSQL migrations
│   ├── api-gateway/      # Cloudflare Workers (JWT validation + routing)
│   └── firebase/         # Firebase configuration placeholder
└── architecture/         # Architecture documents (SSOT)
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend (App Service) | FastAPI 0.115+, Python 3.11+, SQLAlchemy (async), Pydantic v2 |
| Database | PostgreSQL 15+ (prod), SQLite (local dev) |
| Auth | Firebase Auth + Firebase Admin SDK |
| API Gateway | Cloudflare Workers (JWT validation, rate limiting) |
| Migrations | Alembic |

## Quick Start

### Backend (App Service)

```bash
cd backend/app_service
pip install -r requirements.txt

# Set environment variables (or use defaults for local dev)
export DATABASE_URL="sqlite+aiosqlite:///./test.db"

# Run the server
uvicorn main:app --reload --port 8000
```

### Migrations

```bash
cd infra/migrations

# Apply all migrations (uses DATABASE_URL env var, defaults to SQLite)
alembic upgrade head
```

### API Gateway (Cloudflare Workers)

```bash
cd infra/api-gateway
npm install
npx wrangler dev  # Local development
```

## API Endpoints (MVP)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/v1/health` | Health check | No |
| POST | `/api/v1/auth/register` | Create profile | Yes |
| POST | `/api/v1/auth/delete-account` | Delete account | Yes |
| GET | `/api/v1/users/me` | Get profile | Yes |
| PATCH | `/api/v1/users/me` | Update profile | Yes |
| POST | `/api/v1/users/me/onboarding` | Complete onboarding | Yes |

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DATABASE_URL` | No | `sqlite+aiosqlite:///./app.db` | Database connection URL |
| `FIREBASE_PROJECT_ID` | No | `gaijin-life-navi` | Firebase project ID |
| `FIREBASE_CREDENTIALS` | No | — | Path to Firebase service account JSON |
| `CORS_ORIGINS` | No | `*` | Allowed CORS origins |
| `APP_VERSION` | No | `0.1.0` | Application version |

## License

Private — All rights reserved.
