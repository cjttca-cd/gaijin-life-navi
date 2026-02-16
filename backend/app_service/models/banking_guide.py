"""BankingGuide model — maps to the banking_guides table (DATA_MODEL.md §5)."""

import json
import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, SmallInteger, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class BankingGuide(Base):
    """Bank account opening guide — master data."""

    __tablename__ = "banking_guides"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    bank_code: Mapped[str] = mapped_column(
        String(20), unique=True, nullable=False
    )
    bank_name: Mapped[str] = mapped_column(Text, nullable=False)  # JSONB
    bank_name_ja: Mapped[str] = mapped_column(String(100), nullable=False)
    logo_url: Mapped[str | None] = mapped_column(Text, nullable=True, default=None)
    multilingual_support: Mapped[str] = mapped_column(
        Text, nullable=False, default="[]"
    )
    requirements: Mapped[str] = mapped_column(Text, nullable=False, default="{}")
    features: Mapped[str] = mapped_column(Text, nullable=False, default="{}")
    foreigner_friendly_score: Mapped[int] = mapped_column(
        SmallInteger, nullable=False, default=3
    )
    application_url: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    conversation_templates: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    troubleshooting: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
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

    # ── Helper methods for JSONB fields ────────────────────────────────

    def get_bank_name(self, lang: str = "en") -> str:
        data = json.loads(self.bank_name) if isinstance(self.bank_name, str) else self.bank_name
        return data.get(lang, data.get("en", ""))

    def get_multilingual_support(self) -> list[str]:
        data = json.loads(self.multilingual_support) if isinstance(self.multilingual_support, str) else self.multilingual_support
        return data if isinstance(data, list) else []

    def get_requirements(self) -> dict:
        data = json.loads(self.requirements) if isinstance(self.requirements, str) else self.requirements
        return data if isinstance(data, dict) else {}

    def get_features(self) -> dict:
        data = json.loads(self.features) if isinstance(self.features, str) else self.features
        return data if isinstance(data, dict) else {}

    def get_conversation_templates(self, lang: str = "en") -> dict | list | None:
        if not self.conversation_templates:
            return None
        data = json.loads(self.conversation_templates) if isinstance(self.conversation_templates, str) else self.conversation_templates
        if isinstance(data, dict):
            return data.get(lang, data.get("en"))
        return data

    def get_troubleshooting(self, lang: str = "en") -> dict | list | None:
        if not self.troubleshooting:
            return None
        data = json.loads(self.troubleshooting) if isinstance(self.troubleshooting, str) else self.troubleshooting
        if isinstance(data, dict):
            return data.get(lang, data.get("en"))
        return data
