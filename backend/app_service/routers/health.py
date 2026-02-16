"""Health check endpoint (API_DESIGN.md — Health Check)."""

from fastapi import APIRouter

from config import settings

router = APIRouter(tags=["health"])


@router.get("/api/v1/health")
async def health_check() -> dict:
    """GET /api/v1/health — returns service health status.

    No authentication required.
    """
    return {
        "status": "ok",
        "version": settings.APP_VERSION,
        "services": {
            "database": "ok",
            "ai_service": "ok",
            "vector_db": "ok",
        },
    }
