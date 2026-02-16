"""AdminProcedure model — maps to the admin_procedures table (DATA_MODEL.md §7)."""

import json
import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, SmallInteger, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class AdminProcedure(Base):
    """Administrative procedure template — master data."""

    __tablename__ = "admin_procedures"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    procedure_code: Mapped[str] = mapped_column(
        String(30), unique=True, nullable=False
    )
    procedure_name: Mapped[str] = mapped_column(Text, nullable=False)  # JSONB
    category: Mapped[str] = mapped_column(String(30), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)  # JSONB
    required_documents: Mapped[str] = mapped_column(
        Text, nullable=False, default="[]"
    )
    steps: Mapped[str] = mapped_column(Text, nullable=False, default="[]")
    deadline_rule: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    office_info: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    tips: Mapped[str | None] = mapped_column(Text, nullable=True, default=None)
    is_arrival_essential: Mapped[bool] = mapped_column(
        Boolean, nullable=False, default=False
    )
    sort_order: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
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

    def get_procedure_name(self, lang: str = "en") -> str:
        data = self._parse_json(self.procedure_name)
        if isinstance(data, dict):
            return data.get(lang, data.get("en", ""))
        return ""

    def get_description(self, lang: str = "en") -> str:
        data = self._parse_json(self.description)
        if isinstance(data, dict):
            return data.get(lang, data.get("en", ""))
        return ""
