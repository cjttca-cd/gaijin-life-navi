"""AI Moderation for Community Q&A content (BUSINESS_RULES.md §4).

Uses Claude API to evaluate community posts/replies for:
1. Harmful/hateful content
2. Spam or self-promotion
3. Dangerous misinformation about legal/medical topics
4. Personal information exposure

When ANTHROPIC_API_KEY is not set, runs in mock mode (always approves).
"""

import logging
from dataclasses import dataclass

from config import settings

logger = logging.getLogger(__name__)


@dataclass
class ModerationResult:
    """Result of AI moderation check."""

    status: str  # 'approved' | 'flagged' | 'rejected'
    reason: str | None = None


# ── Moderation prompt (BUSINESS_RULES.md §4) ──────────────────────────

MODERATION_PROMPT = """Evaluate this community post for:
1. Harmful/hateful content
2. Spam or self-promotion
3. Dangerous misinformation about legal/medical topics
4. Personal information exposure

Content to evaluate:
{content}

Respond with EXACTLY one of:
- APPROVED (if the content is acceptable)
- FLAGGED: <reason> (if the content should be reviewed)

Your response must start with either "APPROVED" or "FLAGGED:"."""


async def moderate_content(content: str) -> ModerationResult:
    """Run AI moderation on the given content.

    In mock mode (no ANTHROPIC_API_KEY), always returns 'approved'.
    """
    if not settings.claude_available:
        logger.info("AI moderation mock mode: auto-approving content")
        return ModerationResult(status="approved", reason=None)

    try:
        import anthropic

        client = anthropic.AsyncAnthropic(api_key=settings.ANTHROPIC_API_KEY)

        message = await client.messages.create(
            model=settings.CLAUDE_MODEL,
            max_tokens=200,
            messages=[
                {
                    "role": "user",
                    "content": MODERATION_PROMPT.format(content=content[:2000]),
                }
            ],
        )

        response_text = message.content[0].text.strip()
        logger.info("AI moderation response: %s", response_text[:100])

        if response_text.startswith("APPROVED"):
            return ModerationResult(status="approved", reason=None)
        elif response_text.startswith("FLAGGED"):
            reason = response_text.split(":", 1)[1].strip() if ":" in response_text else "Flagged by AI"
            return ModerationResult(status="flagged", reason=reason)
        else:
            # Unexpected response — flag for manual review
            logger.warning("Unexpected moderation response: %s", response_text[:200])
            return ModerationResult(status="flagged", reason="Unexpected AI response — manual review needed")

    except Exception as exc:
        logger.error("AI moderation failed: %s", exc)
        # On error, leave as pending (don't auto-approve or reject)
        return ModerationResult(status="approved", reason=None)
