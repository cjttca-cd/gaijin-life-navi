"""Create M3 tables: community_posts, community_replies, community_votes, subscriptions.

Revision ID: 004
Revises: 003
Create Date: 2026-02-16

Tables:
  - community_posts    (DATA_MODEL.md §10) — soft-delete
  - community_replies  (DATA_MODEL.md §11) — soft-delete
  - community_votes    (DATA_MODEL.md §12) — NO soft-delete (physical delete)
  - subscriptions      (DATA_MODEL.md §13)

ENUM types (handled at application layer for SQLite compatibility):
  - moderation_status: pending, approved, flagged, rejected
  - subscription_status: active, cancelled, past_due, expired
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = "004"
down_revision: Union[str, None] = "003"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ── community_posts (§10) — soft-delete ────────────────────────────
    op.create_table(
        "community_posts",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
        ),
        sa.Column("channel", sa.String(5), nullable=False),
        sa.Column("category", sa.String(30), nullable=False),
        sa.Column("title", sa.String(200), nullable=False),
        sa.Column("content", sa.Text, nullable=False),
        sa.Column("is_answered", sa.Boolean, nullable=False, server_default=sa.text("0")),
        sa.Column("view_count", sa.Integer, nullable=False, server_default=sa.text("0")),
        sa.Column("upvote_count", sa.Integer, nullable=False, server_default=sa.text("0")),
        sa.Column("reply_count", sa.Integer, nullable=False, server_default=sa.text("0")),
        sa.Column(
            "ai_moderation_status",
            sa.String(20),
            nullable=False,
            server_default="pending",
        ),
        sa.Column("ai_moderation_reason", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )

    op.create_index(
        "idx_community_posts_channel",
        "community_posts",
        ["channel", "category", sa.text("created_at DESC")],
    )
    op.create_index(
        "idx_community_posts_user_id",
        "community_posts",
        ["user_id"],
    )

    # ── community_replies (§11) — soft-delete ──────────────────────────
    op.create_table(
        "community_replies",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "post_id",
            sa.String(36),
            sa.ForeignKey("community_posts.id"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
        ),
        sa.Column("content", sa.Text, nullable=False),
        sa.Column("is_best_answer", sa.Boolean, nullable=False, server_default=sa.text("0")),
        sa.Column("upvote_count", sa.Integer, nullable=False, server_default=sa.text("0")),
        sa.Column(
            "ai_moderation_status",
            sa.String(20),
            nullable=False,
            server_default="pending",
        ),
        sa.Column("ai_moderation_reason", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )

    op.create_index(
        "idx_community_replies_post_id",
        "community_replies",
        ["post_id", sa.text("created_at ASC")],
    )

    # ── community_votes (§12) — NO soft-delete ─────────────────────────
    op.create_table(
        "community_votes",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
        ),
        sa.Column("target_type", sa.String(10), nullable=False),  # 'post' | 'reply'
        sa.Column("target_id", sa.String(36), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.UniqueConstraint("user_id", "target_type", "target_id", name="uq_community_votes_user_target"),
    )

    # ── subscriptions (§13) ────────────────────────────────────────────
    op.create_table(
        "subscriptions",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
            unique=True,
        ),
        sa.Column("stripe_customer_id", sa.String(100), nullable=False),
        sa.Column("stripe_subscription_id", sa.String(100), nullable=True),
        sa.Column(
            "tier",
            sa.String(20),
            nullable=False,
            server_default="premium",
        ),
        sa.Column(
            "status",
            sa.String(20),
            nullable=False,
            server_default="active",
        ),
        sa.Column("current_period_start", sa.DateTime(timezone=True), nullable=False),
        sa.Column("current_period_end", sa.DateTime(timezone=True), nullable=False),
        sa.Column("cancel_at_period_end", sa.Boolean, nullable=False, server_default=sa.text("0")),
        sa.Column("cancelled_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )


def downgrade() -> None:
    op.drop_table("subscriptions")
    op.drop_table("community_votes")
    op.drop_index("idx_community_replies_post_id", table_name="community_replies")
    op.drop_table("community_replies")
    op.drop_index("idx_community_posts_user_id", table_name="community_posts")
    op.drop_index("idx_community_posts_channel", table_name="community_posts")
    op.drop_table("community_posts")
