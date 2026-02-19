"""Profile model — maps to the profiles table (DATA_MODEL.md §1)."""

import enum
from datetime import date, datetime

from sqlalchemy import Boolean, Date, DateTime, Enum, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class SubscriptionTier(str, enum.Enum):
    """Subscription tier enum."""

    FREE = "free"
    PREMIUM = "premium"
    PREMIUM_PLUS = "premium_plus"


class Profile(Base):
    """User profile — 1:1 with Firebase Auth account."""

    __tablename__ = "profiles"

    # PK = Firebase Auth UID
    id: Mapped[str] = mapped_column(String(128), primary_key=True)

    display_name: Mapped[str] = mapped_column(
        String(100), nullable=False, default=""
    )
    email: Mapped[str] = mapped_column(
        String(255), unique=True, nullable=False
    )
    avatar_url: Mapped[str | None] = mapped_column(Text, nullable=True, default=None)
    nationality: Mapped[str | None] = mapped_column(
        String(2), nullable=True, default=None
    )
    residence_status: Mapped[str | None] = mapped_column(
        String(50), nullable=True, default=None
    )
    residence_region: Mapped[str | None] = mapped_column(
        String(100), nullable=True, default=None
    )
    visa_expiry: Mapped[date | None] = mapped_column(
        Date, nullable=True, default=None
    )
    preferred_language: Mapped[str | None] = mapped_column(
        String(10), nullable=True, default=None
    )
    subscription_tier: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        default=SubscriptionTier.FREE.value,
    )
    onboarding_completed: Mapped[bool] = mapped_column(
        Boolean, nullable=False, default=False
    )
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
    deleted_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, default=None
    )
