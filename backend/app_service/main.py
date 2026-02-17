"""Gaijin Life Navi — App Service (FastAPI).

Initialises the FastAPI application with CORS and router registration.
"""

import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from config import settings
from routers import auth, banking, chat, health, navigator, profile_router, subscriptions, usage_router, users

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

app.include_router(health.router)
app.include_router(auth.router)
app.include_router(users.router)
app.include_router(subscriptions.router)
app.include_router(navigator.router)
app.include_router(profile_router.router)
app.include_router(usage_router.router)
app.include_router(chat.router)
app.include_router(banking.router)

logger.info(
    "App Service started — version=%s, debug=%s",
    settings.APP_VERSION,
    settings.DEBUG,
)
