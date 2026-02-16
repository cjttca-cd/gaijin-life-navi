"""DocumentScan model — maps to the document_scans table (DATA_MODEL.md §9)."""

import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class DocumentScan(Base):
    """Document scan record — user-uploaded document OCR + translation."""

    __tablename__ = "document_scans"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        String(128), ForeignKey("profiles.id"), nullable=False
    )
    file_url: Mapped[str] = mapped_column(Text, nullable=False)
    file_name: Mapped[str] = mapped_column(String(255), nullable=False)
    file_size_bytes: Mapped[int] = mapped_column(Integer, nullable=False)
    ocr_text: Mapped[str | None] = mapped_column(Text, nullable=True, default=None)
    translation: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    explanation: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    document_type: Mapped[str | None] = mapped_column(
        String(50), nullable=True, default=None
    )
    source_language: Mapped[str] = mapped_column(
        String(5), nullable=False, default="ja"
    )
    target_language: Mapped[str] = mapped_column(String(5), nullable=False)
    status: Mapped[str] = mapped_column(
        String(20), nullable=False, default="uploading"
    )
    error_message: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now(),
        onupdate=func.now(),
    )
    deleted_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, default=None
    )
