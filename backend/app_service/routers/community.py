"""Community Q&A endpoints (API_DESIGN.md — Community Q&A).

GET    /api/v1/community/posts                  — Post list
POST   /api/v1/community/posts                  — Create post (Premium+)
GET    /api/v1/community/posts/:id              — Post detail (view_count++)
PATCH  /api/v1/community/posts/:id              — Edit post (author only)
DELETE /api/v1/community/posts/:id              — Soft-delete post (author only)
GET    /api/v1/community/posts/:id/replies      — Replies list
POST   /api/v1/community/posts/:id/replies      — Create reply (Premium+)
PATCH  /api/v1/community/replies/:id            — Edit reply (author only)
DELETE /api/v1/community/replies/:id            — Soft-delete reply (author only)
POST   /api/v1/community/posts/:id/vote         — Vote toggle on post (Premium+)
POST   /api/v1/community/replies/:id/vote       — Vote toggle on reply (Premium+)
POST   /api/v1/community/replies/:id/best-answer — Set best answer (post author only)
"""

import logging
import uuid
from datetime import datetime, timezone

import httpx
from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from pydantic import BaseModel, Field
from sqlalchemy import select, delete, func as sa_func
from sqlalchemy.ext.asyncio import AsyncSession

from config import settings
from database import get_db
from models.community_post import CommunityPost
from models.community_reply import CommunityReply
from models.community_vote import CommunityVote
from models.profile import Profile
from schemas.common import SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/community", tags=["community"])


# ── Schemas ────────────────────────────────────────────────────────────


class CreatePostRequest(BaseModel):
    channel: str = Field(..., min_length=2, max_length=5)
    category: str = Field(..., max_length=30)
    title: str = Field(..., min_length=5, max_length=200)
    content: str = Field(..., min_length=10, max_length=5000)


class UpdatePostRequest(BaseModel):
    title: str | None = Field(default=None, min_length=5, max_length=200)
    content: str | None = Field(default=None, min_length=10, max_length=5000)


class CreateReplyRequest(BaseModel):
    content: str = Field(..., min_length=5, max_length=3000)


class UpdateReplyRequest(BaseModel):
    content: str | None = Field(default=None, min_length=5, max_length=3000)


# ── Helpers ────────────────────────────────────────────────────────────


def _check_premium(profile: Profile, feature: str = "community") -> None:
    """Raise 403 if the user is on the free tier (BUSINESS_RULES.md §2)."""
    if profile.subscription_tier == "free":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": {
                    "code": "TIER_LIMIT_EXCEEDED",
                    "message": "Community posting, replying, and voting require a Premium subscription.",
                    "details": {
                        "feature": feature,
                        "tier": "free",
                        "upgrade_url": "/subscription",
                    },
                }
            },
        )


async def _get_profile_or_404(db: AsyncSession, user_id: str) -> Profile:
    """Fetch profile or raise 404."""
    profile = await db.get(Profile, user_id)
    if profile is None or profile.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Profile not found.",
                    "details": {},
                }
            },
        )
    return profile


def _post_to_dict(post: CommunityPost, user_voted: bool = False) -> dict:
    return {
        "id": post.id,
        "user_id": post.user_id,
        "channel": post.channel,
        "category": post.category,
        "title": post.title,
        "content": post.content,
        "is_answered": post.is_answered,
        "view_count": post.view_count,
        "upvote_count": post.upvote_count,
        "reply_count": post.reply_count,
        "ai_moderation_status": post.ai_moderation_status,
        "user_voted": user_voted,
        "created_at": post.created_at.isoformat() if post.created_at else None,
        "updated_at": post.updated_at.isoformat() if post.updated_at else None,
    }


def _reply_to_dict(reply: CommunityReply, user_voted: bool = False) -> dict:
    return {
        "id": reply.id,
        "post_id": reply.post_id,
        "user_id": reply.user_id,
        "content": reply.content,
        "is_best_answer": reply.is_best_answer,
        "upvote_count": reply.upvote_count,
        "ai_moderation_status": reply.ai_moderation_status,
        "user_voted": user_voted,
        "created_at": reply.created_at.isoformat() if reply.created_at else None,
        "updated_at": reply.updated_at.isoformat() if reply.updated_at else None,
    }


async def _trigger_moderation(target_type: str, target_id: str, content: str) -> None:
    """Fire-and-forget call to AI Service for moderation.

    In mock mode (no AI service running), silently approves.
    """
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            await client.post(
                f"{settings.AI_SERVICE_URL}/api/v1/ai/moderation/check",
                json={
                    "target_type": target_type,
                    "target_id": target_id,
                    "content": content,
                },
            )
    except Exception as exc:
        logger.warning("Moderation call failed (will retry or stay pending): %s", exc)


# ── Post Endpoints ─────────────────────────────────────────────────────


@router.get("/posts")
async def list_posts(
    channel: str = Query(..., max_length=5),
    category: str | None = Query(default=None, max_length=30),
    sort: str = Query(default="newest", pattern=r"^(newest|popular)$"),
    limit: int = Query(default=20, ge=1, le=50),
    cursor: str | None = Query(default=None),
    q: str | None = Query(default=None, max_length=200),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """List community posts — visibility rules per BUSINESS_RULES.md §4."""
    stmt = (
        select(CommunityPost)
        .where(
            CommunityPost.channel == channel,
            CommunityPost.deleted_at == None,  # noqa: E711
            CommunityPost.ai_moderation_status != "rejected",
        )
    )

    # Visibility: pending/flagged only visible to author
    stmt = stmt.where(
        (CommunityPost.ai_moderation_status == "approved")
        | (CommunityPost.user_id == current_user.uid)
    )

    if category:
        stmt = stmt.where(CommunityPost.category == category)

    if q:
        search = f"%{q}%"
        stmt = stmt.where(
            CommunityPost.title.ilike(search) | CommunityPost.content.ilike(search)
        )

    if cursor:
        cursor_post = await db.get(CommunityPost, cursor)
        if cursor_post:
            if sort == "newest":
                stmt = stmt.where(CommunityPost.created_at < cursor_post.created_at)
            else:
                stmt = stmt.where(
                    (CommunityPost.upvote_count < cursor_post.upvote_count)
                    | (
                        (CommunityPost.upvote_count == cursor_post.upvote_count)
                        & (CommunityPost.created_at < cursor_post.created_at)
                    )
                )

    if sort == "newest":
        stmt = stmt.order_by(CommunityPost.created_at.desc())
    else:
        stmt = stmt.order_by(
            CommunityPost.upvote_count.desc(), CommunityPost.created_at.desc()
        )

    stmt = stmt.limit(limit + 1)
    result = await db.execute(stmt)
    posts = list(result.scalars().all())

    has_more = len(posts) > limit
    if has_more:
        posts = posts[:limit]

    return {
        "data": [_post_to_dict(p) for p in posts],
        "pagination": {
            "next_cursor": posts[-1].id if has_more and posts else None,
            "has_more": has_more,
        },
    }


@router.post("/posts", status_code=status.HTTP_201_CREATED)
async def create_post(
    body: CreatePostRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Create a community post — Premium+ only. Moderation is async."""
    profile = await _get_profile_or_404(db, current_user.uid)
    _check_premium(profile, "community_post")

    post_id = str(uuid.uuid4())
    post = CommunityPost(
        id=post_id,
        user_id=current_user.uid,
        channel=body.channel,
        category=body.category,
        title=body.title,
        content=body.content,
        ai_moderation_status="pending",
    )
    db.add(post)
    await db.flush()

    # Trigger async moderation
    await _trigger_moderation("post", post_id, f"{body.title}\n{body.content}")

    return SuccessResponse(data=_post_to_dict(post)).model_dump()


@router.get("/posts/{post_id}")
async def get_post(
    post_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Get post detail — increments view_count per BUSINESS_RULES.md §4."""
    post = await db.get(CommunityPost, post_id)
    if post is None or post.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )

    # Visibility: rejected = hidden; pending/flagged = author only
    if post.ai_moderation_status == "rejected":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )
    if post.ai_moderation_status in ("pending", "flagged") and post.user_id != current_user.uid:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )

    # Increment view_count
    post.view_count = (post.view_count or 0) + 1
    post.updated_at = datetime.now(timezone.utc)
    await db.flush()

    # Check if user has voted
    vote_stmt = select(CommunityVote).where(
        CommunityVote.user_id == current_user.uid,
        CommunityVote.target_type == "post",
        CommunityVote.target_id == post_id,
    )
    vote_result = await db.execute(vote_stmt)
    user_voted = vote_result.scalars().first() is not None

    return SuccessResponse(data=_post_to_dict(post, user_voted=user_voted)).model_dump()


@router.patch("/posts/{post_id}")
async def update_post(
    post_id: str,
    body: UpdatePostRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Edit a post — author only."""
    post = await db.get(CommunityPost, post_id)
    if post is None or post.deleted_at is not None or post.user_id != current_user.uid:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )

    if body.title is not None:
        post.title = body.title
    if body.content is not None:
        post.content = body.content
    post.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(data=_post_to_dict(post)).model_dump()


@router.delete("/posts/{post_id}")
async def delete_post(
    post_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Soft-delete a post — author only."""
    post = await db.get(CommunityPost, post_id)
    if post is None or post.deleted_at is not None or post.user_id != current_user.uid:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )

    now = datetime.now(timezone.utc)
    post.deleted_at = now
    post.updated_at = now
    await db.flush()

    return SuccessResponse(data={"message": "Post deleted."}).model_dump()


# ── Reply Endpoints ────────────────────────────────────────────────────


@router.get("/posts/{post_id}/replies")
async def list_replies(
    post_id: str,
    limit: int = Query(default=20, ge=1, le=50),
    cursor: str | None = Query(default=None),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """List replies for a post."""
    # Verify post exists
    post = await db.get(CommunityPost, post_id)
    if post is None or post.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )

    stmt = (
        select(CommunityReply)
        .where(
            CommunityReply.post_id == post_id,
            CommunityReply.deleted_at == None,  # noqa: E711
            CommunityReply.ai_moderation_status != "rejected",
        )
        .where(
            (CommunityReply.ai_moderation_status == "approved")
            | (CommunityReply.user_id == current_user.uid)
        )
    )

    if cursor:
        cursor_reply = await db.get(CommunityReply, cursor)
        if cursor_reply:
            stmt = stmt.where(CommunityReply.created_at > cursor_reply.created_at)

    stmt = stmt.order_by(CommunityReply.created_at.asc()).limit(limit + 1)
    result = await db.execute(stmt)
    replies = list(result.scalars().all())

    has_more = len(replies) > limit
    if has_more:
        replies = replies[:limit]

    return {
        "data": [_reply_to_dict(r) for r in replies],
        "pagination": {
            "next_cursor": replies[-1].id if has_more and replies else None,
            "has_more": has_more,
        },
    }


@router.post("/posts/{post_id}/replies", status_code=status.HTTP_201_CREATED)
async def create_reply(
    post_id: str,
    body: CreateReplyRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Create a reply — Premium+ only."""
    profile = await _get_profile_or_404(db, current_user.uid)
    _check_premium(profile, "community_reply")

    # Verify post exists
    post = await db.get(CommunityPost, post_id)
    if post is None or post.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )

    reply_id = str(uuid.uuid4())
    reply = CommunityReply(
        id=reply_id,
        post_id=post_id,
        user_id=current_user.uid,
        content=body.content,
        ai_moderation_status="pending",
    )
    db.add(reply)

    # Increment reply_count on the post
    post.reply_count = (post.reply_count or 0) + 1
    post.updated_at = datetime.now(timezone.utc)

    await db.flush()

    # Trigger async moderation
    await _trigger_moderation("reply", reply_id, body.content)

    return SuccessResponse(data=_reply_to_dict(reply)).model_dump()


@router.patch("/replies/{reply_id}")
async def update_reply(
    reply_id: str,
    body: UpdateReplyRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Edit a reply — author only."""
    reply = await db.get(CommunityReply, reply_id)
    if reply is None or reply.deleted_at is not None or reply.user_id != current_user.uid:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Reply not found.", "details": {}}},
        )

    if body.content is not None:
        reply.content = body.content
    reply.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(data=_reply_to_dict(reply)).model_dump()


@router.delete("/replies/{reply_id}")
async def delete_reply(
    reply_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Soft-delete a reply — author only."""
    reply = await db.get(CommunityReply, reply_id)
    if reply is None or reply.deleted_at is not None or reply.user_id != current_user.uid:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Reply not found.", "details": {}}},
        )

    now = datetime.now(timezone.utc)
    reply.deleted_at = now
    reply.updated_at = now

    # Decrement reply_count on parent post
    post = await db.get(CommunityPost, reply.post_id)
    if post and post.reply_count > 0:
        post.reply_count -= 1
        post.updated_at = now

    await db.flush()

    return SuccessResponse(data={"message": "Reply deleted."}).model_dump()


# ── Vote Endpoints ─────────────────────────────────────────────────────


@router.post("/posts/{post_id}/vote")
async def vote_post(
    post_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Toggle vote on a post — Premium+ only (BUSINESS_RULES.md §4)."""
    profile = await _get_profile_or_404(db, current_user.uid)
    _check_premium(profile, "community_vote")

    post = await db.get(CommunityPost, post_id)
    if post is None or post.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )

    # Check existing vote
    vote_stmt = select(CommunityVote).where(
        CommunityVote.user_id == current_user.uid,
        CommunityVote.target_type == "post",
        CommunityVote.target_id == post_id,
    )
    vote_result = await db.execute(vote_stmt)
    existing_vote = vote_result.scalars().first()

    if existing_vote:
        # Remove vote (toggle off)
        await db.delete(existing_vote)
        post.upvote_count = max(0, (post.upvote_count or 0) - 1)
        voted = False
    else:
        # Add vote
        vote = CommunityVote(
            id=str(uuid.uuid4()),
            user_id=current_user.uid,
            target_type="post",
            target_id=post_id,
        )
        db.add(vote)
        post.upvote_count = (post.upvote_count or 0) + 1
        voted = True

    post.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(
        data={"voted": voted, "upvote_count": post.upvote_count}
    ).model_dump()


@router.post("/replies/{reply_id}/vote")
async def vote_reply(
    reply_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Toggle vote on a reply — Premium+ only."""
    profile = await _get_profile_or_404(db, current_user.uid)
    _check_premium(profile, "community_vote")

    reply = await db.get(CommunityReply, reply_id)
    if reply is None or reply.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Reply not found.", "details": {}}},
        )

    # Check existing vote
    vote_stmt = select(CommunityVote).where(
        CommunityVote.user_id == current_user.uid,
        CommunityVote.target_type == "reply",
        CommunityVote.target_id == reply_id,
    )
    vote_result = await db.execute(vote_stmt)
    existing_vote = vote_result.scalars().first()

    if existing_vote:
        await db.delete(existing_vote)
        reply.upvote_count = max(0, (reply.upvote_count or 0) - 1)
        voted = False
    else:
        vote = CommunityVote(
            id=str(uuid.uuid4()),
            user_id=current_user.uid,
            target_type="reply",
            target_id=reply_id,
        )
        db.add(vote)
        reply.upvote_count = (reply.upvote_count or 0) + 1
        voted = True

    reply.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(
        data={"voted": voted, "upvote_count": reply.upvote_count}
    ).model_dump()


# ── Best Answer Endpoint ───────────────────────────────────────────────


@router.post("/replies/{reply_id}/best-answer")
async def set_best_answer(
    reply_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Set/unset best answer — only the post author can do this (BUSINESS_RULES.md §4).

    If the reply is already best_answer, toggle it off.
    If another reply is best_answer, unset it first (1 post = 1 best answer).
    """
    reply = await db.get(CommunityReply, reply_id)
    if reply is None or reply.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Reply not found.", "details": {}}},
        )

    # Verify post ownership
    post = await db.get(CommunityPost, reply.post_id)
    if post is None or post.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "NOT_FOUND", "message": "Post not found.", "details": {}}},
        )

    if post.user_id != current_user.uid:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": {
                    "code": "FORBIDDEN",
                    "message": "Only the post author can set the best answer.",
                    "details": {},
                }
            },
        )

    now = datetime.now(timezone.utc)

    if reply.is_best_answer:
        # Toggle off
        reply.is_best_answer = False
        post.is_answered = False
    else:
        # Unset any existing best answer for this post
        existing_ba_stmt = select(CommunityReply).where(
            CommunityReply.post_id == reply.post_id,
            CommunityReply.is_best_answer == True,  # noqa: E712
            CommunityReply.deleted_at == None,  # noqa: E711
        )
        existing_ba_result = await db.execute(existing_ba_stmt)
        for old_ba in existing_ba_result.scalars().all():
            old_ba.is_best_answer = False
            old_ba.updated_at = now

        # Set new best answer
        reply.is_best_answer = True
        post.is_answered = True

    reply.updated_at = now
    post.updated_at = now
    await db.flush()

    return SuccessResponse(
        data={
            "reply_id": reply.id,
            "is_best_answer": reply.is_best_answer,
            "post_is_answered": post.is_answered,
        }
    ).model_dump()
