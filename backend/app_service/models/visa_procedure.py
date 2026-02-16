"""VisaProcedure model — maps to the visa_procedures table (DATA_MODEL.md §6)."""

import json
import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, SmallInteger, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class VisaProcedure(Base):
    """Visa procedure template — master data."""

    __tablename__ = "visa_procedures"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    procedure_type: Mapped[str] = mapped_column(String(30), nullable=False)
    title: Mapped[str] = mapped_column(Text, nullable=False)  # JSONB
    description: Mapped[str] = mapped_column(Text, nullable=False)  # JSONB
    required_documents: Mapped[str] = mapped_column(
        Text, nullable=False, default="[]"
    )
    steps: Mapped[str] = mapped_column(Text, nullable=False, default="[]")
    estimated_duration: Mapped[str | None] = mapped_column(
        String(50), nullable=True, default=None
    )
    fees: Mapped[str | None] = mapped_column(Text, nullable=True, default=None)  # JSONB
    applicable_statuses: Mapped[str] = mapped_column(
        Text, nullable=False, default="[]"
    )  # JSON array
    deadline_rule: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    tips: Mapped[str | None] = mapped_column(Text, nullable=True, default=None)
    is_active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    sort_order: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now(),
        onupdate=func.now(),
    )

    # ── JSONB helper methods ───────────────────────────────────────────

    def _parse_json(self, field_value: str | None) -> dict | list | None:
        if field_value is None:
            return None
        if isinstance(field_value, str):
            return json.loads(field_value)
        return field_value

    def get_title(self, lang: str = "en") -> str:
        data = self._parse_json(self.title)
        if isinstance(data, dict):
            return data.get(lang, data.get("en", ""))
        return ""

    def get_description(self, lang: str = "en") -> str:
        data = self._parse_json(self.description)
        if isinstance(data, dict):
            return data.get(lang, data.get("en", ""))
        return ""

    def get_applicable_statuses(self) -> list[str]:
        data = self._parse_json(self.applicable_statuses)
        return data if isinstance(data, list) else []

    def get_fees(self) -> dict | None:
        data = self._parse_json(self.fees)
        return data if isinstance(data, dict) else None
