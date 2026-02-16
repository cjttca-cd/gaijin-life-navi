"""Create profiles and daily_usage tables.

Revision ID: 001
Revises: None
Create Date: 2026-02-16

Tables:
  - profiles  (DATA_MODEL.md §1)
  - daily_usage (DATA_MODEL.md §4)

Notes:
  - subscription_tier is stored as String(20) for SQLite compatibility.
    On PostgreSQL, a native ENUM type can be used via a follow-up migration.
  - UNIQUE constraints are defined inline in create_table for SQLite compat.
  - render_as_batch=True is used in env.py for SQLite ALTER TABLE support.
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = "001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ── profiles ───────────────────────────────────────────────────────
    op.create_table(
        "profiles",
        sa.Column("id", sa.String(128), primary_key=True),
        sa.Column("display_name", sa.String(100), nullable=False, server_default=""),
        sa.Column("email", sa.String(255), nullable=False),
        sa.Column("avatar_url", sa.Text, nullable=True),
        sa.Column("nationality", sa.String(2), nullable=True),
        sa.Column("residence_status", sa.String(50), nullable=True),
        sa.Column("residence_region", sa.String(10), nullable=True),
        sa.Column("arrival_date", sa.Date, nullable=True),
        sa.Column("preferred_language", sa.String(5), nullable=False, server_default="en"),
        sa.Column(
            "subscription_tier",
            sa.String(20),
            nullable=False,
            server_default="free",
        ),
        sa.Column("onboarding_completed", sa.Boolean, nullable=False, server_default=sa.text("0")),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )

    # Unique index on email
    op.create_index("ix_profiles_email", "profiles", ["email"], unique=True)

    # ── daily_usage ────────────────────────────────────────────────────
    op.create_table(
        "daily_usage",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
        ),
        sa.Column("usage_date", sa.Date, nullable=False, server_default=sa.func.current_date()),
        sa.Column("chat_count", sa.Integer, nullable=False, server_default=sa.text("0")),
        sa.Column("scan_count_monthly", sa.Integer, nullable=False, server_default=sa.text("0")),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        # Inline unique constraint for SQLite compatibility
        sa.UniqueConstraint("user_id", "usage_date", name="uq_daily_usage_user_date"),
    )

    # Index on (user_id, usage_date) for lookups
    op.create_index("ix_daily_usage_user_date", "daily_usage", ["user_id", "usage_date"])


def downgrade() -> None:
    op.drop_index("ix_daily_usage_user_date", table_name="daily_usage")
    op.drop_table("daily_usage")
    op.drop_index("ix_profiles_email", table_name="profiles")
    op.drop_table("profiles")
