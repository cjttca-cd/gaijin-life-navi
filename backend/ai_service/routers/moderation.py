"""AI Moderation endpoint — internal API called by App Service.

POST /api/v1/ai/moderation/check — Evaluate content and update DB.

This endpoint is called internally by the App Service after community
post/reply creation. It runs moderation asynchronously and updates the
moderation status directly in the shared database.
"""

import logging
from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from moderation.moderator import moderate_content

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/ai/moderation", tags=["moderation"])


# ── Schemas ────────────────────────────────────────────────────────────


class ModerationCheckRequest(BaseModel):
    target_type: str = Field(..., pattern=r"^(post|reply)$")
    target_id: str = Field(...)
    content: str = Field(..., max_length=10000)


class ModerationCheckResponse(BaseModel):
    target_type: str
    target_id: str
    status: str
    reason: str | None = None


# ── Endpoint ───────────────────────────────────────────────────────────


@router.post("/check")
async def check_moderation(
    body: ModerationCheckRequest,
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Run AI moderation and update the target record in the database.

    This is an internal endpoint — no user auth required (service-to-service).
    """
    result = await moderate_content(body.content)

    now = datetime.now(timezone.utc)

    # Update the target record directly in the shared DB
    if body.target_type == "post":
        # Import here to avoid circular deps — shared DB, different models
        from sqlalchemy import text

        await db.execute(
            text(
                "UPDATE community_posts SET ai_moderation_status = :status, "
                "ai_moderation_reason = :reason, updated_at = :now "
                "WHERE id = :target_id"
            ),
            {
                "status": result.status,
                "reason": result.reason,
                "now": now,
                "target_id": body.target_id,
            },
        )
    elif body.target_type == "reply":
        from sqlalchemy import text

        await db.execute(
            text(
                "UPDATE community_replies SET ai_moderation_status = :status, "
                "ai_moderation_reason = :reason, updated_at = :now "
                "WHERE id = :target_id"
            ),
            {
                "status": result.status,
                "reason": result.reason,
                "now": now,
                "target_id": body.target_id,
            },
        )

    logger.info(
        "Moderation check: %s/%s → %s",
        body.target_type,
        body.target_id,
        result.status,
    )

    return {
        "data": ModerationCheckResponse(
            target_type=body.target_type,
            target_id=body.target_id,
            status=result.status,
            reason=result.reason,
        ).model_dump()
    }
