"""Chat endpoints (API_DESIGN.md — AI Chat section).

POST   /api/v1/ai/chat/sessions                      — Create session
GET    /api/v1/ai/chat/sessions                      — List sessions
GET    /api/v1/ai/chat/sessions/:session_id          — Session detail + messages
DELETE /api/v1/ai/chat/sessions/:session_id          — Soft-delete session
POST   /api/v1/ai/chat/sessions/:session_id/messages — Send message + AI response (SSE)
GET    /api/v1/ai/chat/sessions/:session_id/messages — Message history
"""

import json
import logging
import uuid
from datetime import date, datetime, timezone
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.responses import JSONResponse
from sqlalchemy import select, func as sa_func, update
from sqlalchemy.ext.asyncio import AsyncSession
from sse_starlette.sse import EventSourceResponse

from config import settings
from database import async_session_factory, get_db
from models.chat_message import ChatMessage
from models.chat_session import ChatSession
from models.daily_usage import DailyUsage
from models.profile import Profile
from schemas.chat import (
    CreateSessionRequest,
    MessageResponse,
    SendMessageRequest,
    SessionDetailResponse,
    SessionResponse,
)
from schemas.common import ErrorResponse, SuccessResponse

# Import shared auth
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))))
from shared.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/ai/chat", tags=["chat"])


# ── Helpers ────────────────────────────────────────────────────────────


async def _get_session_or_404(
    session_id: str, user_id: str, db: AsyncSession
) -> ChatSession:
    """Fetch a chat session owned by the user, or raise 404/403."""
    result = await db.execute(
        select(ChatSession).where(
            ChatSession.id == session_id,
            ChatSession.deleted_at.is_(None),
        )
    )
    session = result.scalar_one_or_none()

    if session is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Chat session not found.",
                    "details": {},
                }
            },
        )

    if session.user_id != user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": {
                    "code": "FORBIDDEN",
                    "message": "You do not have access to this session.",
                    "details": {},
                }
            },
        )

    return session


async def _get_or_create_daily_usage(
    user_id: str, db: AsyncSession
) -> DailyUsage:
    """Get or create today's daily_usage record."""
    today = date.today()
    result = await db.execute(
        select(DailyUsage).where(
            DailyUsage.user_id == user_id,
            DailyUsage.usage_date == today,
        )
    )
    usage = result.scalar_one_or_none()

    if usage is None:
        usage = DailyUsage(
            id=str(uuid.uuid4()),
            user_id=user_id,
            usage_date=today,
            chat_count=0,
            scan_count_monthly=0,
        )
        db.add(usage)
        await db.flush()

    return usage


async def _check_daily_limit(
    user_id: str, db: AsyncSession
) -> tuple[DailyUsage, Profile]:
    """Check if the user has exceeded daily chat limit.

    Returns (daily_usage, profile) if within limits.
    Raises HTTPException 403 if limit exceeded.
    """
    # Get profile for tier check
    profile = await db.get(Profile, user_id)
    if profile is None or profile.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "User profile not found.",
                    "details": {},
                }
            },
        )

    # Premium/Premium+ have unlimited chat
    if profile.subscription_tier in ("premium", "premium_plus"):
        usage = await _get_or_create_daily_usage(user_id, db)
        return usage, profile

    # Free tier: check daily limit
    usage = await _get_or_create_daily_usage(user_id, db)

    if usage.chat_count >= settings.FREE_CHAT_DAILY_LIMIT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": {
                    "code": "TIER_LIMIT_EXCEEDED",
                    "message": "You have reached the daily limit for AI chat. Upgrade to Premium for unlimited access.",
                    "details": {
                        "feature": "ai_chat",
                        "current_count": usage.chat_count,
                        "limit": settings.FREE_CHAT_DAILY_LIMIT,
                        "tier": profile.subscription_tier,
                        "upgrade_url": "/subscription",
                    },
                }
            },
        )

    return usage, profile


def _session_to_dict(session: ChatSession) -> dict:
    """Convert ChatSession to response dict."""
    return SessionResponse.model_validate(session).model_dump()


def _message_to_dict(msg: ChatMessage) -> dict:
    """Convert ChatMessage to response dict."""
    data = {
        "id": msg.id,
        "session_id": msg.session_id,
        "role": msg.role,
        "content": msg.content,
        "sources": json.loads(msg.sources) if msg.sources else None,
        "tokens_used": msg.tokens_used,
        "created_at": msg.created_at.isoformat() if msg.created_at else None,
    }
    return data


# ── Endpoints ──────────────────────────────────────────────────────────


@router.post(
    "/sessions",
    status_code=status.HTTP_201_CREATED,
    responses={403: {"model": ErrorResponse}},
)
async def create_session(
    body: CreateSessionRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Create a new chat session.

    If initial_message is provided, also sends the message and returns
    SSE streaming AI response.
    """
    # Get profile for language default
    profile = await db.get(Profile, current_user.uid)
    if profile is None or profile.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "User profile not found. Please register first.",
                    "details": {},
                }
            },
        )

    session = ChatSession(
        id=str(uuid.uuid4()),
        user_id=current_user.uid,
        category="general",
        language=profile.preferred_language,
    )
    db.add(session)
    await db.flush()

    # If no initial message, return session as JSON
    if not body.initial_message:
        return SuccessResponse(
            data={"session": _session_to_dict(session)}
        ).model_dump()

    # With initial_message: check limits, then stream SSE
    usage, profile = await _check_daily_limit(current_user.uid, db)

    # Commit session creation before starting SSE stream
    await db.commit()

    return await _stream_message_response(
        session_id=session.id,
        user_id=current_user.uid,
        content=body.initial_message,
        is_first_message=True,
    )


@router.get(
    "/sessions",
    response_model=dict,
)
async def list_sessions(
    limit: int = Query(default=20, ge=1, le=50),
    cursor: Optional[str] = Query(default=None),
    category: Optional[str] = Query(default=None),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """List chat sessions for the current user (cursor-based pagination)."""
    query = (
        select(ChatSession)
        .where(
            ChatSession.user_id == current_user.uid,
            ChatSession.deleted_at.is_(None),
        )
        .order_by(ChatSession.updated_at.desc())
    )

    if category:
        query = query.where(ChatSession.category == category)

    if cursor:
        # Cursor is the ID of the last item — get its updated_at for comparison
        cursor_result = await db.execute(
            select(ChatSession.updated_at).where(ChatSession.id == cursor)
        )
        cursor_updated_at = cursor_result.scalar_one_or_none()
        if cursor_updated_at:
            query = query.where(ChatSession.updated_at < cursor_updated_at)

    query = query.limit(limit + 1)  # Fetch one extra to check has_more

    result = await db.execute(query)
    sessions = list(result.scalars().all())

    has_more = len(sessions) > limit
    if has_more:
        sessions = sessions[:limit]

    session_data = [_session_to_dict(s) for s in sessions]
    next_cursor = sessions[-1].id if sessions and has_more else None

    return {
        "data": session_data,
        "pagination": {
            "next_cursor": next_cursor,
            "has_more": has_more,
        },
        "meta": {"request_id": str(uuid.uuid4())},
    }


@router.get(
    "/sessions/{session_id}",
    responses={404: {"model": ErrorResponse}, 403: {"model": ErrorResponse}},
)
async def get_session(
    session_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Get session detail + latest 20 messages."""
    session = await _get_session_or_404(session_id, current_user.uid, db)

    # Get latest 20 messages
    result = await db.execute(
        select(ChatMessage)
        .where(ChatMessage.session_id == session_id)
        .order_by(ChatMessage.created_at.desc())
        .limit(20)
    )
    messages = list(reversed(result.scalars().all()))

    return SuccessResponse(
        data={
            "session": _session_to_dict(session),
            "messages": [_message_to_dict(m) for m in messages],
        }
    ).model_dump()


@router.delete(
    "/sessions/{session_id}",
    responses={404: {"model": ErrorResponse}, 403: {"model": ErrorResponse}},
)
async def delete_session(
    session_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Soft-delete a chat session."""
    session = await _get_session_or_404(session_id, current_user.uid, db)
    session.deleted_at = datetime.now(timezone.utc)
    await db.flush()

    return SuccessResponse(data={"message": "Session deleted"}).model_dump()


@router.post(
    "/sessions/{session_id}/messages",
    responses={403: {"model": ErrorResponse}, 404: {"model": ErrorResponse}},
)
async def send_message(
    session_id: str,
    body: SendMessageRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Send a message and receive AI response via SSE streaming.

    SSE events:
    - message_start: {"message_id": "uuid", "role": "assistant"}
    - content_delta: {"delta": "text chunk"} (multiple)
    - message_end: {"sources": [...], "tokens_used": N, "disclaimer": "...", "usage": {...}}
    """
    # Verify session ownership
    session = await _get_session_or_404(session_id, current_user.uid, db)

    # Check daily limit
    usage, profile = await _check_daily_limit(current_user.uid, db)

    is_first = session.message_count == 0

    # Commit limit check before SSE stream
    await db.commit()

    return await _stream_message_response(
        session_id=session_id,
        user_id=current_user.uid,
        content=body.content,
        is_first_message=is_first,
    )


@router.get(
    "/sessions/{session_id}/messages",
    responses={404: {"model": ErrorResponse}, 403: {"model": ErrorResponse}},
)
async def list_messages(
    session_id: str,
    limit: int = Query(default=50, ge=1, le=100),
    cursor: Optional[str] = Query(default=None),
    order: str = Query(default="asc", pattern="^(asc|desc)$"),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """List messages in a session (cursor-based pagination)."""
    # Verify ownership
    await _get_session_or_404(session_id, current_user.uid, db)

    if order == "asc":
        order_clause = ChatMessage.created_at.asc()
    else:
        order_clause = ChatMessage.created_at.desc()

    query = (
        select(ChatMessage)
        .where(ChatMessage.session_id == session_id)
        .order_by(order_clause)
    )

    if cursor:
        cursor_result = await db.execute(
            select(ChatMessage.created_at).where(ChatMessage.id == cursor)
        )
        cursor_created_at = cursor_result.scalar_one_or_none()
        if cursor_created_at:
            if order == "asc":
                query = query.where(ChatMessage.created_at > cursor_created_at)
            else:
                query = query.where(ChatMessage.created_at < cursor_created_at)

    query = query.limit(limit + 1)

    result = await db.execute(query)
    messages = list(result.scalars().all())

    has_more = len(messages) > limit
    if has_more:
        messages = messages[:limit]

    return {
        "data": [_message_to_dict(m) for m in messages],
        "pagination": {
            "next_cursor": messages[-1].id if messages and has_more else None,
            "has_more": has_more,
        },
        "meta": {"request_id": str(uuid.uuid4())},
    }


# ── SSE streaming helper ──────────────────────────────────────────────


async def _stream_message_response(
    session_id: str,
    user_id: str,
    content: str,
    is_first_message: bool = False,
):
    """Create and return an SSE EventSourceResponse for a chat message."""

    async def event_generator():
        """Generate SSE events for the chat response."""
        # Use a fresh DB session inside the generator
        async with async_session_factory() as db:
            try:
                # 1. Save user message
                user_msg = ChatMessage(
                    id=str(uuid.uuid4()),
                    session_id=session_id,
                    role="user",
                    content=content,
                    tokens_used=0,
                )
                db.add(user_msg)
                await db.flush()

                # 2. Get profile for context
                profile = await db.get(Profile, user_id)

                # 3. If first message, classify category and generate title
                if is_first_message:
                    from chat_engine.category_classifier import classify
                    from chat_engine.title_generator import generate_title

                    category = await classify(content)
                    title = await generate_title(content)

                    await db.execute(
                        update(ChatSession)
                        .where(ChatSession.id == session_id)
                        .values(
                            category=category,
                            title=title,
                            updated_at=datetime.now(timezone.utc),
                        )
                    )
                    await db.flush()
                else:
                    # Get existing session for category
                    result = await db.execute(
                        select(ChatSession.category).where(ChatSession.id == session_id)
                    )
                    category = result.scalar_one_or_none() or "general"

                # 4. Get conversation history (last 10 messages)
                history_result = await db.execute(
                    select(ChatMessage)
                    .where(ChatMessage.session_id == session_id)
                    .order_by(ChatMessage.created_at.desc())
                    .limit(11)  # 10 + current user message
                )
                history_msgs = list(reversed(history_result.scalars().all()))
                # Exclude the current user message from history
                history = [
                    {"role": m.role, "content": m.content}
                    for m in history_msgs
                    if m.id != user_msg.id
                ][-10:]

                # 5. Run RAG pipeline
                from rag.pipeline import search as rag_search

                rag_result = await rag_search(content, category=category, top_k=5)

                # 6. Build chat context
                from chat_engine.engine import (
                    ChatContext,
                    UserContext,
                    get_disclaimer,
                    get_sources,
                    stream_response,
                )

                user_ctx = UserContext(
                    nationality=profile.nationality if profile else None,
                    residence_status=profile.residence_status if profile else None,
                    residence_region=profile.residence_region if profile else None,
                    preferred_language=profile.preferred_language if profile else "en",
                )

                chat_ctx = ChatContext(
                    user_context=user_ctx,
                    rag_chunks=rag_result.chunks,
                    history=history,
                )

                # 7. Generate assistant message ID
                assistant_msg_id = str(uuid.uuid4())

                # 8. Send message_start event
                yield {
                    "event": "message_start",
                    "data": json.dumps(
                        {"message_id": assistant_msg_id, "role": "assistant"}
                    ),
                }

                # 9. Stream content_delta events
                full_content = ""
                async for chunk in stream_response(content, chat_ctx):
                    full_content += chunk
                    yield {
                        "event": "content_delta",
                        "data": json.dumps({"delta": chunk}),
                    }

                # 10. Estimate tokens used
                tokens_used = len(full_content.split()) * 2  # rough estimate

                # 11. Get sources
                sources = get_sources(rag_result.chunks)

                # 12. Save assistant message
                assistant_msg = ChatMessage(
                    id=assistant_msg_id,
                    session_id=session_id,
                    role="assistant",
                    content=full_content,
                    sources=json.dumps(sources) if sources else None,
                    tokens_used=tokens_used,
                )
                db.add(assistant_msg)

                # 13. Update session message count
                await db.execute(
                    update(ChatSession)
                    .where(ChatSession.id == session_id)
                    .values(
                        message_count=ChatSession.message_count + 2,  # user + assistant
                        updated_at=datetime.now(timezone.utc),
                    )
                )

                # 14. Increment daily usage
                today = date.today()
                usage_result = await db.execute(
                    select(DailyUsage).where(
                        DailyUsage.user_id == user_id,
                        DailyUsage.usage_date == today,
                    )
                )
                usage = usage_result.scalar_one_or_none()
                if usage:
                    usage.chat_count += 1
                else:
                    usage = DailyUsage(
                        id=str(uuid.uuid4()),
                        user_id=user_id,
                        usage_date=today,
                        chat_count=1,
                    )
                    db.add(usage)

                await db.flush()

                # 15. Calculate remaining usage
                tier = profile.subscription_tier if profile else "free"
                if tier in ("premium", "premium_plus"):
                    chat_limit = -1  # unlimited
                    chat_remaining = -1
                else:
                    chat_limit = settings.FREE_CHAT_DAILY_LIMIT
                    chat_remaining = max(0, chat_limit - usage.chat_count)

                # 16. Send message_end event
                usage_info = {
                    "chat_count": usage.chat_count,
                    "chat_limit": chat_limit,
                    "chat_remaining": chat_remaining,
                }

                yield {
                    "event": "message_end",
                    "data": json.dumps(
                        {
                            "sources": sources,
                            "tokens_used": tokens_used,
                            "disclaimer": get_disclaimer(),
                            "usage": usage_info,
                        }
                    ),
                }

                await db.commit()

            except Exception as exc:
                logger.exception("Error during chat streaming")
                await db.rollback()
                yield {
                    "event": "error",
                    "data": json.dumps(
                        {
                            "error": {
                                "code": "INTERNAL_ERROR",
                                "message": "An error occurred while generating the response.",
                            }
                        }
                    ),
                }

    return EventSourceResponse(event_generator())
