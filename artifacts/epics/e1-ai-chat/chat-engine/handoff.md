# Handoff: AI Service + Chat Backend (task-020)

## Intent
Build the AI Service (FastAPI) with Chat Backend supporting:
- Session CRUD (create, list, detail, soft-delete)
- Message send with SSE streaming AI response
- RAG pipeline integration (mock mode for development)
- Daily usage rate limiting (free tier: 5/day)
- Shared Firebase auth (mock mode supported)

## Non-goals
- Real Claude API integration (mock mode only — API key required for real mode)
- Real Pinecone/OpenAI vector search (mock mode only)
- Real Firebase Auth verification (mock mode only)
- Frontend/Flutter integration

## Status: ✅ Complete

### Files Added/Modified (30 files)

#### AI Service (`backend/ai_service/`) — 22 files
- `main.py` — FastAPI app, CORS, health endpoint, router registration
- `config.py` — Settings via pydantic-settings (env vars)
- `database.py` — Async SQLAlchemy engine + session factory
- `Dockerfile` — Container build
- `requirements.txt` — Python dependencies
- **Models**: `models/profile.py`, `models/chat_session.py`, `models/chat_message.py`, `models/daily_usage.py`
- **Schemas**: `schemas/chat.py`, `schemas/common.py`
- **Router**: `routers/chat.py` — All 6 chat endpoints + SSE streaming
- **Chat Engine**: `chat_engine/engine.py` (system prompt + Claude streaming + mock fallback), `chat_engine/category_classifier.py` (keyword-based + Claude fallback), `chat_engine/title_generator.py` (truncation + Claude fallback)
- **RAG**: `rag/pipeline.py` (mock knowledge base + Pinecone integration), `rag/embeddings.py`, `rag/knowledge_loader.py`

#### Shared (`backend/shared/`)
- `auth.py` — Firebase Auth token verification with mock mode

#### DB Migration
- `infra/migrations/versions/002_create_chat_tables.py` — chat_sessions + chat_messages tables

#### Config Fixes (DB path unification)
- `backend/app_service/config.py` — DATABASE_URL → absolute path
- `backend/ai_service/config.py` — DATABASE_URL → absolute path
- `infra/migrations/alembic.ini` — sqlalchemy.url → same absolute path
- `.gitignore` — Added `data/*` with `!data/.gitkeep`
- `data/.gitkeep` — Placeholder for shared DB directory

## Verification

All tests performed in mock mode (no API keys required):

```bash
# 1. Import check
cd backend/ai_service && python3 -c "from main import app; print('OK')"

# 2. Migration
cd infra/migrations && alembic upgrade head
# → 4 tables: profiles, daily_usage, chat_sessions, chat_messages

# 3. Start server
cd backend/ai_service && uvicorn main:app --port 8001

# 4. API endpoints (all verified ✅)
GET  /api/v1/ai/health                              → 200 (mock_mode)
POST /api/v1/ai/chat/sessions                       → 201 (session created)
POST /api/v1/ai/chat/sessions/{id}/messages          → 200 SSE stream
     Events: message_start → content_delta* → message_end
GET  /api/v1/ai/chat/sessions                       → 200 (list + pagination)
GET  /api/v1/ai/chat/sessions/{id}                  → 200 (detail + messages)
DELETE /api/v1/ai/chat/sessions/{id}                → 200 (soft-delete)
GET  /api/v1/ai/chat/sessions/{id}/messages          → 200 (message history)
```

## Architecture Notes

### DB Path
- All services (App Service, AI Service, Alembic) share `data/app.db` via absolute path
- Default: `sqlite+aiosqlite:////root/.openclaw/projects/gaijin-life-navi/data/app.db`
- Override via `DATABASE_URL` env var for production (PostgreSQL)

### Mock Mode Behavior
- **Auth**: Any `Bearer <uid>:<email>` token accepted; `<uid>` maps to profile ID
- **Claude**: Returns static helpful response about living in Japan
- **RAG**: Returns category-matched mock knowledge chunks (banking, visa, medical, etc.)
- **Category Classifier**: Keyword-based matching
- **Title Generator**: First sentence / truncation

### SSE Event Protocol
```
event: message_start
data: {"message_id": "uuid", "role": "assistant"}

event: content_delta  (×N)
data: {"delta": "text chunk"}

event: message_end
data: {"sources": [...], "tokens_used": N, "disclaimer": "...", "usage": {"chat_count": N, "chat_limit": N, "chat_remaining": N}}
```

## Gaps / Known Limitations
1. **No real API integration** — Claude, OpenAI, Pinecone, Firebase all in mock mode
2. **No WebSocket** — SSE only (as per API_DESIGN.md)
3. **No rate limiting middleware** — Daily limit check is per-endpoint, not global
4. **SQLite only tested** — PostgreSQL path exists but not verified
5. **No unit tests** — Endpoint testing was manual via curl

## Next Steps
1. **Flutter Chat UI** (e1-ai-chat/chat-ui) — Connect to these endpoints
2. **Production config** — Set `DATABASE_URL`, `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `PINECONE_API_KEY`, `FIREBASE_CREDENTIALS`
3. **Containerization** — Build & deploy via `backend/ai_service/Dockerfile`
4. **Knowledge base seeding** — Load RAG documents into Pinecone

## Git
- Commit: `b430984` — `feat(ai-chat): AI Service + Chat Backend [task-020]`
