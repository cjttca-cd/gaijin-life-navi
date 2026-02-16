"""CommunityVote model — maps to community_votes table (DATA_MODEL.md §12).

NO soft-delete — votes use physical delete (toggle behaviour).
"""

from datetime import datetime

from sqlalchemy import DateTime, String, UniqueConstraint, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class CommunityVote(Base):
    """Community Q&A vote — physical delete only."""

    __tablename__ = "community_votes"
    __table_args__ = (
        UniqueConstraint("user_id", "target_type", "target_id", name="uq_community_votes_user_target"),
    )

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    user_id: Mapped[str] = mapped_column(String(128), nullable=False)
    target_type: Mapped[str] = mapped_column(String(10), nullable=False)  # 'post' | 'reply'
    target_id: Mapped[str] = mapped_column(String(36), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
