"""Profile model (read-only for AI Service) — mirrors DATA_MODEL.md §1.

The AI Service reads from profiles for user context (nationality, language, etc.)
and subscription tier checks. Write operations happen only in App Service.
"""

from datetime import date, datetime

from sqlalchemy import Boolean, Date, DateTime, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class Profile(Base):
    """User profile — read-only in AI Service context."""

    __tablename__ = "profiles"

    id: Mapped[str] = mapped_column(String(128), primary_key=True)
    display_name: Mapped[str] = mapped_column(String(100), nullable=False, default="")
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    avatar_url: Mapped[str | None] = mapped_column(Text, nullable=True, default=None)
    nationality: Mapped[str | None] = mapped_column(String(2), nullable=True, default=None)
    residence_status: Mapped[str | None] = mapped_column(String(50), nullable=True, default=None)
    residence_region: Mapped[str | None] = mapped_column(String(10), nullable=True, default=None)
    arrival_date: Mapped[date | None] = mapped_column(Date, nullable=True, default=None)
    preferred_language: Mapped[str] = mapped_column(String(5), nullable=False, default="en")
    subscription_tier: Mapped[str] = mapped_column(String(20), nullable=False, default="free")
    onboarding_completed: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    deleted_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, default=None
    )
