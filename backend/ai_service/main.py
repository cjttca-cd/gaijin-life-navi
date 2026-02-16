"""Gaijin Life Navi — AI Service (FastAPI).

Initialises the FastAPI application with CORS and router registration.
Handles AI chat, RAG pipeline, and streaming responses.
"""

import logging
import os
import sys

# ── Ensure backend/ is on sys.path for shared imports ──────────────────
_backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _backend_dir not in sys.path:
    sys.path.insert(0, _backend_dir)

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from config import settings
from routers import chat, documents

# ── Logging setup ──────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.DEBUG if settings.DEBUG else logging.INFO,
    format="%(asctime)s | %(levelname)-7s | %(name)s | %(message)s",
)
logger = logging.getLogger(__name__)

# ── FastAPI app ────────────────────────────────────────────────────────

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
)

# ── CORS ───────────────────────────────────────────────────────────────

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Routers ────────────────────────────────────────────────────────────

app.include_router(chat.router)
app.include_router(documents.router)


# ── Health check ───────────────────────────────────────────────────────

@app.get("/api/v1/ai/health")
async def health_check():
    """Health check for AI Service."""
    return {
        "status": "ok",
        "version": settings.APP_VERSION,
        "services": {
            "claude_api": "configured" if settings.claude_available else "mock_mode",
            "vector_db": "configured" if settings.rag_available else "mock_mode",
        },
    }


logger.info(
    "AI Service started — version=%s, debug=%s, claude=%s, rag=%s",
    settings.APP_VERSION,
    settings.DEBUG,
    "configured" if settings.claude_available else "mock",
    "configured" if settings.rag_available else "mock",
)
