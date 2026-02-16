"""Create chat_sessions and chat_messages tables.

Revision ID: 002
Revises: 001
Create Date: 2026-02-16

Tables:
  - chat_sessions  (DATA_MODEL.md §2)
  - chat_messages   (DATA_MODEL.md §3)

Indexes:
  - idx_chat_sessions_user_id ON (user_id) WHERE deleted_at IS NULL
  - idx_chat_sessions_updated_at ON (user_id, updated_at DESC) WHERE deleted_at IS NULL
  - idx_chat_messages_session_id ON (session_id, created_at ASC)
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = "002"
down_revision: Union[str, None] = "001"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ── chat_sessions ──────────────────────────────────────────────────
    op.create_table(
        "chat_sessions",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
        ),
        sa.Column("title", sa.String(200), nullable=True),
        sa.Column(
            "category",
            sa.String(30),
            nullable=False,
            server_default="general",
        ),
        sa.Column(
            "language",
            sa.String(5),
            nullable=False,
            server_default="en",
        ),
        sa.Column(
            "message_count",
            sa.Integer,
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )

    # Indexes for chat_sessions
    # Note: SQLite does not support partial indexes (WHERE clause), so we
    # create standard indexes for compatibility. On PostgreSQL, add WHERE clause.
    op.create_index(
        "idx_chat_sessions_user_id",
        "chat_sessions",
        ["user_id"],
    )
    op.create_index(
        "idx_chat_sessions_updated_at",
        "chat_sessions",
        ["user_id", sa.text("updated_at DESC")],
    )

    # ── chat_messages ──────────────────────────────────────────────────
    op.create_table(
        "chat_messages",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "session_id",
            sa.String(36),
            sa.ForeignKey("chat_sessions.id"),
            nullable=False,
        ),
        sa.Column("role", sa.String(10), nullable=False),
        sa.Column("content", sa.Text, nullable=False),
        sa.Column("sources", sa.Text, nullable=True),  # JSON string (JSONB on PG)
        sa.Column(
            "tokens_used",
            sa.Integer,
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
    )

    # Index for chat_messages
    op.create_index(
        "idx_chat_messages_session_id",
        "chat_messages",
        ["session_id", "created_at"],
    )


def downgrade() -> None:
    op.drop_index("idx_chat_messages_session_id", table_name="chat_messages")
    op.drop_table("chat_messages")
    op.drop_index("idx_chat_sessions_updated_at", table_name="chat_sessions")
    op.drop_index("idx_chat_sessions_user_id", table_name="chat_sessions")
    op.drop_table("chat_sessions")
