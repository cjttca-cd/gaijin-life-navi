"""MedicalPhrase model — maps to the medical_phrases table (DATA_MODEL.md §15)."""

import json
import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, SmallInteger, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class MedicalPhrase(Base):
    """Medical phrase for symptom translation — master data."""

    __tablename__ = "medical_phrases"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    category: Mapped[str] = mapped_column(String(30), nullable=False)
    phrase_ja: Mapped[str] = mapped_column(Text, nullable=False)
    phrase_reading: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )
    translations: Mapped[str] = mapped_column(Text, nullable=False)  # JSONB
    context: Mapped[str | None] = mapped_column(
        Text, nullable=True, default=None
    )  # JSONB
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

    def get_translation(self, lang: str = "en") -> str:
        data = json.loads(self.translations) if isinstance(self.translations, str) else self.translations
        if isinstance(data, dict):
            return data.get(lang, data.get("en", ""))
        return ""

    def get_context(self, lang: str = "en") -> str | None:
        if not self.context:
            return None
        data = json.loads(self.context) if isinstance(self.context, str) else self.context
        if isinstance(data, dict):
            return data.get(lang, data.get("en"))
        return None
