"""ChatCredit model — maps to the chat_credits table.

Credit Ledger system for tracking chat usage credits.
Credits can come from subscription (monthly), grant (system/admin), or purchase.

See: architecture/DATA_MODEL.md, tasks/chat-credits-design.md §2.1
"""

import uuid
from datetime import datetime

from sqlalchemy import (
    CheckConstraint,
    DateTime,
    ForeignKey,
    Integer,
    String,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class ChatCredit(Base):
    """A single credit ledger row — tracks granted/purchased chat credits."""

    __tablename__ = "chat_credits"
    __table_args__ = (
        CheckConstraint("remaining >= 0", name="ck_chat_credits_remaining_gte_0"),
        CheckConstraint(
            "remaining <= initial_amount",
            name="ck_chat_credits_remaining_lte_initial",
        ),
        CheckConstraint(
            "source IN ('subscription', 'grant', 'purchase')",
            name="ck_chat_credits_source_valid",
        ),
        # Partial index defined in migration (005_create_chat_credits.py)
        # using raw SQL for SQLite compatibility.
    )

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        String(128),
        ForeignKey("profiles.id"),
        nullable=False,
    )
    source: Mapped[str] = mapped_column(String(20), nullable=False)
    source_detail: Mapped[str | None] = mapped_column(
        String(100), nullable=True, default=None
    )
    initial_amount: Mapped[int] = mapped_column(Integer, nullable=False)
    remaining: Mapped[int] = mapped_column(Integer, nullable=False)
    expires_at: Mapped[datetime | None] = mapped_column(
        DateTime, nullable=True, default=None
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.now(), onupdate=func.now()
    )
