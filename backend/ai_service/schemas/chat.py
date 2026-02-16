"""Chat-related Pydantic schemas (API_DESIGN.md — AI Chat section)."""

from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field


# ── Request Schemas ────────────────────────────────────────────────────


class CreateSessionRequest(BaseModel):
    """POST /api/v1/ai/chat/sessions request body."""

    initial_message: str | None = Field(default=None, max_length=2000)


class SendMessageRequest(BaseModel):
    """POST /api/v1/ai/chat/sessions/:session_id/messages request body."""

    content: str = Field(..., min_length=1, max_length=2000)


# ── Response Schemas ───────────────────────────────────────────────────


class SessionResponse(BaseModel):
    """Chat session data object."""

    id: str
    title: str | None = None
    category: str = "general"
    language: str = "en"
    message_count: int = 0
    created_at: datetime
    updated_at: datetime | None = None

    model_config = {"from_attributes": True}


class MessageResponse(BaseModel):
    """Chat message data object."""

    id: str
    session_id: str
    role: str
    content: str
    sources: list[dict] | None = None
    tokens_used: int = 0
    created_at: datetime

    model_config = {"from_attributes": True}


class SessionDetailResponse(BaseModel):
    """Session detail with recent messages."""

    session: SessionResponse
    messages: list[MessageResponse]


# ── SSE Event Data Schemas ─────────────────────────────────────────────


class MessageStartEvent(BaseModel):
    """SSE message_start event data."""

    message_id: str
    role: str = "assistant"


class ContentDeltaEvent(BaseModel):
    """SSE content_delta event data."""

    delta: str


class UsageInfo(BaseModel):
    """Usage info included in message_end event."""

    chat_count: int
    chat_limit: int
    chat_remaining: int


class MessageEndEvent(BaseModel):
    """SSE message_end event data."""

    sources: list[dict] = Field(default_factory=list)
    tokens_used: int = 0
    disclaimer: str = ""
    usage: UsageInfo | None = None
