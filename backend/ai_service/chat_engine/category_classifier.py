"""Intent classification — categorise user messages.

Categories: banking, visa, medical, admin, housing, work, daily_life, general

Falls back to keyword-based classification when Claude API is not configured.
"""

import logging
from typing import Optional

from config import settings

logger = logging.getLogger(__name__)

VALID_CATEGORIES = {
    "banking",
    "visa",
    "medical",
    "admin",
    "housing",
    "work",
    "daily_life",
    "general",
}

# ── Keyword mappings for mock classifier ───────────────────────────────

_CATEGORY_KEYWORDS: dict[str, list[str]] = {
    "banking": [
        "bank", "account", "atm", "transfer", "deposit", "withdraw",
        "銀行", "口座", "振込", "預金", "引き出し", "money", "yen", "円",
        "credit card", "debit", "送金", "remittance",
    ],
    "visa": [
        "visa", "residence card", "在留", "ビザ", "immigration", "入管",
        "renewal", "更新", "change of status", "work permit", "在留カード",
        "permanent resident", "永住", "reentry", "再入国",
    ],
    "medical": [
        "doctor", "hospital", "clinic", "health", "insurance", "medical",
        "病院", "健康", "保険", "医療", "pharmacy", "薬局", "emergency",
        "ambulance", "救急", "sick", "pain", "symptom",
    ],
    "admin": [
        "city hall", "ward office", "registration", "resident",
        "市役所", "区役所", "届出", "住民票", "pension", "年金",
        "tax", "税金", "my number", "マイナンバー", "certificate",
    ],
    "housing": [
        "apartment", "rent", "lease", "landlord", "deposit", "key money",
        "アパート", "マンション", "家賃", "敷金", "礼金", "contract",
        "move", "引っ越し", "guarantor", "保証人", "utility",
    ],
    "work": [
        "work", "job", "employment", "salary", "overtime", "labor",
        "仕事", "就職", "給料", "残業", "労働", "contract",
        "hello work", "ハローワーク", "company", "会社",
    ],
    "daily_life": [
        "garbage", "trash", "recycle", "transport", "train", "bus",
        "ゴミ", "電車", "バス", "shopping", "supermarket", "post office",
        "郵便局", "phone", "internet", "wifi", "delivery",
    ],
}


def _keyword_classify(message: str) -> str:
    """Classify message category using keyword matching (fallback)."""
    message_lower = message.lower()

    scores: dict[str, int] = {cat: 0 for cat in VALID_CATEGORIES}

    for category, keywords in _CATEGORY_KEYWORDS.items():
        for keyword in keywords:
            if keyword.lower() in message_lower:
                scores[category] += 1

    best_category = max(scores, key=scores.get)  # type: ignore
    if scores[best_category] == 0:
        return "general"

    return best_category


async def classify(message: str) -> str:
    """Classify the intent of a user message.

    Returns one of: banking, visa, medical, admin, housing, work, daily_life, general.
    Uses Claude API when available, falls back to keyword-based classification.
    """
    if not settings.claude_available:
        category = _keyword_classify(message)
        logger.debug("Mock category classification: %s", category)
        return category

    try:
        import anthropic

        client = anthropic.AsyncAnthropic(api_key=settings.ANTHROPIC_API_KEY)

        response = await client.messages.create(
            model=settings.CLAUDE_MODEL,
            max_tokens=20,
            messages=[
                {
                    "role": "user",
                    "content": (
                        "Classify this user message into exactly one category. "
                        "Reply with ONLY the category name, nothing else.\n"
                        "Categories: banking, visa, medical, admin, housing, work, daily_life, general\n\n"
                        f"Message: {message}"
                    ),
                }
            ],
        )

        category = response.content[0].text.strip().lower()
        if category not in VALID_CATEGORIES:
            logger.warning("Claude returned invalid category '%s', defaulting to general", category)
            category = "general"

        return category
    except Exception as exc:
        logger.error("Claude classification failed: %s — falling back to keywords", exc)
        return _keyword_classify(message)
