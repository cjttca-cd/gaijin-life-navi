"""Create chat_credits table for Credit Ledger system.

Revision ID: 005
Revises: 004
Create Date: 2026-03-07

Tables:
  - chat_credits (tasks/chat-credits-design.md §2.1)

Supports the Credit Ledger system replacing fixed daily_usage-based limits.
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = "005"
down_revision: Union[str, None] = "004"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "chat_credits",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
        ),
        sa.Column("source", sa.String(20), nullable=False),
        sa.Column("source_detail", sa.String(100), nullable=True),
        sa.Column("initial_amount", sa.Integer, nullable=False),
        sa.Column("remaining", sa.Integer, nullable=False),
        sa.Column("expires_at", sa.DateTime, nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime,
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime,
            nullable=False,
            server_default=sa.func.now(),
        ),
        # CHECK constraints
        sa.CheckConstraint("remaining >= 0", name="ck_chat_credits_remaining_gte_0"),
        sa.CheckConstraint(
            "remaining <= initial_amount",
            name="ck_chat_credits_remaining_lte_initial",
        ),
        sa.CheckConstraint(
            "source IN ('subscription', 'grant', 'purchase')",
            name="ck_chat_credits_source_valid",
        ),
    )

    # Partial index for active credits (remaining > 0).
    # SQLite supports partial indexes via WHERE clause.
    op.execute(
        "CREATE INDEX idx_chat_credits_user_active "
        "ON chat_credits(user_id, expires_at) "
        "WHERE remaining > 0"
    )


def downgrade() -> None:
    op.execute("DROP INDEX IF EXISTS idx_chat_credits_user_active")
    op.drop_table("chat_credits")
