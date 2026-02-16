"""ChatSession model — maps to chat_sessions table (DATA_MODEL.md §2)."""

import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class ChatSession(Base):
    """AI chat session."""

    __tablename__ = "chat_sessions"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        String(128), ForeignKey("profiles.id"), nullable=False
    )
    title: Mapped[str | None] = mapped_column(
        String(200), nullable=True, default=None
    )
    category: Mapped[str] = mapped_column(
        String(30), nullable=False, default="general"
    )
    language: Mapped[str] = mapped_column(
        String(5), nullable=False, default="en"
    )
    message_count: Mapped[int] = mapped_column(
        Integer, nullable=False, default=0
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now(),
        onupdate=func.now()
    )
    deleted_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, default=None
    )
