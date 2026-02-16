"""Create M2 tables: banking_guides, visa_procedures, admin_procedures,
user_procedures, document_scans, medical_phrases.

Revision ID: 003
Revises: 002
Create Date: 2026-02-16

Tables:
  - banking_guides     (DATA_MODEL.md §5)
  - visa_procedures    (DATA_MODEL.md §6)
  - admin_procedures   (DATA_MODEL.md §7)
  - user_procedures    (DATA_MODEL.md §8)  — soft-delete
  - document_scans     (DATA_MODEL.md §9)  — soft-delete
  - medical_phrases    (DATA_MODEL.md §15)

ENUM types (skip if they already exist — handled for PostgreSQL only):
  - procedure_status: not_started, in_progress, completed
  - scan_status: uploading, processing, completed, failed
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = "003"
down_revision: Union[str, None] = "002"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ── banking_guides (§5) ────────────────────────────────────────────
    op.create_table(
        "banking_guides",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("bank_code", sa.String(20), nullable=False, unique=True),
        sa.Column("bank_name", sa.Text, nullable=False),  # JSONB on PG
        sa.Column("bank_name_ja", sa.String(100), nullable=False),
        sa.Column("logo_url", sa.Text, nullable=True),
        sa.Column("multilingual_support", sa.Text, nullable=False, server_default="[]"),  # JSONB
        sa.Column("requirements", sa.Text, nullable=False, server_default="{}"),  # JSONB
        sa.Column("features", sa.Text, nullable=False, server_default="{}"),  # JSONB
        sa.Column("foreigner_friendly_score", sa.SmallInteger, nullable=False, server_default=sa.text("3")),
        sa.Column("application_url", sa.Text, nullable=True),
        sa.Column("conversation_templates", sa.Text, nullable=True),  # JSONB
        sa.Column("troubleshooting", sa.Text, nullable=True),  # JSONB
        sa.Column("sort_order", sa.SmallInteger, nullable=False, server_default=sa.text("0")),
        sa.Column("is_active", sa.Boolean, nullable=False, server_default=sa.text("1")),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )

    # ── visa_procedures (§6) ───────────────────────────────────────────
    op.create_table(
        "visa_procedures",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("procedure_type", sa.String(30), nullable=False),
        sa.Column("title", sa.Text, nullable=False),  # JSONB
        sa.Column("description", sa.Text, nullable=False),  # JSONB
        sa.Column("required_documents", sa.Text, nullable=False, server_default="[]"),  # JSONB
        sa.Column("steps", sa.Text, nullable=False, server_default="[]"),  # JSONB
        sa.Column("estimated_duration", sa.String(50), nullable=True),
        sa.Column("fees", sa.Text, nullable=True),  # JSONB
        sa.Column("applicable_statuses", sa.Text, nullable=False, server_default="[]"),  # text[] on PG, JSON array on SQLite
        sa.Column("deadline_rule", sa.Text, nullable=True),  # JSONB
        sa.Column("tips", sa.Text, nullable=True),  # JSONB
        sa.Column("is_active", sa.Boolean, nullable=False, server_default=sa.text("1")),
        sa.Column("sort_order", sa.SmallInteger, nullable=False, server_default=sa.text("0")),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )

    op.create_index(
        "idx_visa_procedures_type",
        "visa_procedures",
        ["procedure_type"],
    )

    # ── admin_procedures (§7) ──────────────────────────────────────────
    op.create_table(
        "admin_procedures",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("procedure_code", sa.String(30), nullable=False, unique=True),
        sa.Column("procedure_name", sa.Text, nullable=False),  # JSONB
        sa.Column("category", sa.String(30), nullable=False),
        sa.Column("description", sa.Text, nullable=False),  # JSONB
        sa.Column("required_documents", sa.Text, nullable=False, server_default="[]"),  # JSONB
        sa.Column("steps", sa.Text, nullable=False, server_default="[]"),  # JSONB
        sa.Column("deadline_rule", sa.Text, nullable=True),  # JSONB
        sa.Column("office_info", sa.Text, nullable=True),  # JSONB
        sa.Column("tips", sa.Text, nullable=True),  # JSONB
        sa.Column("is_arrival_essential", sa.Boolean, nullable=False, server_default=sa.text("0")),
        sa.Column("sort_order", sa.SmallInteger, nullable=False, server_default=sa.text("0")),
        sa.Column("is_active", sa.Boolean, nullable=False, server_default=sa.text("1")),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )

    op.create_index(
        "idx_admin_procedures_category",
        "admin_procedures",
        ["category"],
    )
    op.create_index(
        "idx_admin_procedures_arrival",
        "admin_procedures",
        ["is_arrival_essential"],
    )

    # ── user_procedures (§8) — soft-delete ─────────────────────────────
    op.create_table(
        "user_procedures",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
        ),
        sa.Column("procedure_ref_type", sa.String(10), nullable=False),  # 'admin' | 'visa'
        sa.Column("procedure_ref_id", sa.String(36), nullable=False),
        sa.Column(
            "status",
            sa.String(20),
            nullable=False,
            server_default="not_started",
        ),
        sa.Column("due_date", sa.Date, nullable=True),
        sa.Column("notes", sa.Text, nullable=True),
        sa.Column("completed_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )

    op.create_index(
        "idx_user_procedures_user_id",
        "user_procedures",
        ["user_id"],
    )
    op.create_index(
        "idx_user_procedures_status",
        "user_procedures",
        ["user_id", "status"],
    )

    # ── document_scans (§9) — soft-delete ──────────────────────────────
    op.create_table(
        "document_scans",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(128),
            sa.ForeignKey("profiles.id"),
            nullable=False,
        ),
        sa.Column("file_url", sa.Text, nullable=False),
        sa.Column("file_name", sa.String(255), nullable=False),
        sa.Column("file_size_bytes", sa.Integer, nullable=False),
        sa.Column("ocr_text", sa.Text, nullable=True),
        sa.Column("translation", sa.Text, nullable=True),
        sa.Column("explanation", sa.Text, nullable=True),
        sa.Column("document_type", sa.String(50), nullable=True),
        sa.Column("source_language", sa.String(5), nullable=False, server_default="ja"),
        sa.Column("target_language", sa.String(5), nullable=False),
        sa.Column(
            "status",
            sa.String(20),
            nullable=False,
            server_default="uploading",
        ),
        sa.Column("error_message", sa.Text, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )

    op.create_index(
        "idx_document_scans_user_id",
        "document_scans",
        ["user_id", sa.text("created_at DESC")],
    )

    # ── medical_phrases (§15) ──────────────────────────────────────────
    op.create_table(
        "medical_phrases",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("category", sa.String(30), nullable=False),
        sa.Column("phrase_ja", sa.Text, nullable=False),
        sa.Column("phrase_reading", sa.Text, nullable=True),
        sa.Column("translations", sa.Text, nullable=False),  # JSONB
        sa.Column("context", sa.Text, nullable=True),  # JSONB
        sa.Column("sort_order", sa.SmallInteger, nullable=False, server_default=sa.text("0")),
        sa.Column("is_active", sa.Boolean, nullable=False, server_default=sa.text("1")),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )


def downgrade() -> None:
    op.drop_table("medical_phrases")
    op.drop_index("idx_document_scans_user_id", table_name="document_scans")
    op.drop_table("document_scans")
    op.drop_index("idx_user_procedures_status", table_name="user_procedures")
    op.drop_index("idx_user_procedures_user_id", table_name="user_procedures")
    op.drop_table("user_procedures")
    op.drop_index("idx_admin_procedures_arrival", table_name="admin_procedures")
    op.drop_index("idx_admin_procedures_category", table_name="admin_procedures")
    op.drop_table("admin_procedures")
    op.drop_index("idx_visa_procedures_type", table_name="visa_procedures")
    op.drop_table("visa_procedures")
    op.drop_table("banking_guides")
