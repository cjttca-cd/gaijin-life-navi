"""Session title generator — creates titles from the first message.

Falls back to truncation when Claude API is not configured.
"""

import logging

from config import settings

logger = logging.getLogger(__name__)

MAX_TITLE_LENGTH = 200


def _truncate_title(message: str) -> str:
    """Generate a simple title by truncating the message."""
    # Take first sentence or first 60 chars
    for sep in ["。", ".", "？", "?", "！", "!", "\n"]:
        idx = message.find(sep)
        if 0 < idx < 80:
            return message[: idx + 1].strip()

    if len(message) <= 60:
        return message.strip()

    # Truncate at word boundary
    truncated = message[:57]
    last_space = truncated.rfind(" ")
    if last_space > 30:
        return truncated[:last_space] + "..."
    return truncated + "..."


async def generate_title(message: str) -> str:
    """Generate a session title from the first user message.

    Uses Claude API when available, falls back to simple truncation.
    Returns a string of max 200 characters.
    """
    if not settings.claude_available:
        title = _truncate_title(message)
        logger.debug("Mock title generation: %s", title)
        return title[:MAX_TITLE_LENGTH]

    try:
        import anthropic

        client = anthropic.AsyncAnthropic(api_key=settings.ANTHROPIC_API_KEY)

        response = await client.messages.create(
            model=settings.CLAUDE_MODEL,
            max_tokens=50,
            messages=[
                {
                    "role": "user",
                    "content": (
                        "Generate a short, descriptive title (max 60 characters) for a "
                        "chat conversation that starts with this message. "
                        "The title should be in the same language as the message. "
                        "Reply with ONLY the title, no quotes or explanation.\n\n"
                        f"Message: {message}"
                    ),
                }
            ],
        )

        title = response.content[0].text.strip().strip('"').strip("'")
        return title[:MAX_TITLE_LENGTH]
    except Exception as exc:
        logger.error("Claude title generation failed: %s — falling back to truncation", exc)
        return _truncate_title(message)[:MAX_TITLE_LENGTH]
