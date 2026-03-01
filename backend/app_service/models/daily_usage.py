"""DailyUsage model — maps to the daily_usage table (DATA_MODEL.md §4).

Tracks per-user daily usage with separate counters for:
  - deep_count: 深度級 (deep-level) chat usage
  - chat_count: 概要級 (summary-level) chat usage
"""

import uuid
from datetime import date, datetime

from sqlalchemy import (
    Date,
    DateTime,
    ForeignKey,
    Integer,
    String,
    UniqueConstraint,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class DailyUsage(Base):
    """Tracks daily/monthly usage limits per user."""

    __tablename__ = "daily_usage"
    __table_args__ = (
        UniqueConstraint("user_id", "usage_date", name="uq_daily_usage_user_date"),
    )

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        String(128),
        ForeignKey("profiles.id"),
        nullable=False,
    )
    usage_date: Mapped[date] = mapped_column(
        Date,
        nullable=False,
        server_default=func.current_date(),
    )
    chat_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    deep_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    scan_count_monthly: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )
