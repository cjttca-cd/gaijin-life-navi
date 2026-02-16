"""CommunityReply model — maps to community_replies table (DATA_MODEL.md §11)."""

from datetime import datetime

from sqlalchemy import Boolean, DateTime, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class CommunityReply(Base):
    """Community Q&A reply — soft-delete enabled."""

    __tablename__ = "community_replies"

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    post_id: Mapped[str] = mapped_column(String(36), nullable=False)
    user_id: Mapped[str] = mapped_column(String(128), nullable=False)
    content: Mapped[str] = mapped_column(Text, nullable=False)
    is_best_answer: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    upvote_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    ai_moderation_status: Mapped[str] = mapped_column(
        String(20), nullable=False, default="pending"
    )
    ai_moderation_reason: Mapped[str | None] = mapped_column(Text, nullable=True, default=None)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now(), onupdate=func.now()
    )
    deleted_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, default=None
    )
