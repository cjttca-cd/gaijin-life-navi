"""Subscription model — maps to subscriptions table (DATA_MODEL.md §13)."""

from datetime import datetime

from sqlalchemy import Boolean, DateTime, String, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class Subscription(Base):
    """User subscription — 1:1 with profiles. Managed by Stripe webhooks."""

    __tablename__ = "subscriptions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    user_id: Mapped[str] = mapped_column(String(128), unique=True, nullable=False)
    stripe_customer_id: Mapped[str] = mapped_column(String(100), nullable=False)
    stripe_subscription_id: Mapped[str | None] = mapped_column(String(100), nullable=True)
    tier: Mapped[str] = mapped_column(String(20), nullable=False, default="premium")
    status: Mapped[str] = mapped_column(String(20), nullable=False, default="active")
    current_period_start: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False
    )
    current_period_end: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False
    )
    cancel_at_period_end: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    cancelled_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, default=None
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now(), onupdate=func.now()
    )
