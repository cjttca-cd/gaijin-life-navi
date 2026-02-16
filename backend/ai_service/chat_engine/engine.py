"""Main chat engine — orchestrates system prompt, RAG, and Claude API.

Implements the full RAG pipeline (BUSINESS_RULES.md §3):
1. Build system prompt with user profile and RAG context
2. Include conversation history (last 10 messages)
3. Call Claude API (streaming)
4. Append disclaimer (BUSINESS_RULES.md §6)

Falls back to mock response mode when Claude API is not configured.
"""

import asyncio
import logging
from dataclasses import dataclass, field
from typing import AsyncIterator, List, Optional

from config import settings
from rag.pipeline import RAGChunk

logger = logging.getLogger(__name__)

# ── Disclaimer (BUSINESS_RULES.md §6) ─────────────────────────────────

DISCLAIMER = (
    "This information is for general guidance only and does not constitute legal advice. "
    "Please verify with relevant authorities for the most up-to-date information."
)

# ── System prompt template (BUSINESS_RULES.md §3) ─────────────────────

SYSTEM_PROMPT_TEMPLATE = """\
You are a multilingual life concierge AI for foreign residents in Japan.
Your role is to help users with daily life procedures, visa matters, banking,
medical care, and other challenges they face living in Japan.

RULES:
1. Always respond in the user's language (detected from input).
2. Base your answers on the provided context (RAG results).
3. Always cite your sources with URLs when available.
4. If unsure, say so clearly - never make up information.
5. For legal/visa matters, always include the disclaimer.
6. Provide actionable next steps when possible.
7. Be culturally sensitive and encouraging.

USER PROFILE:
- Nationality: {nationality}
- Residence Status: {residence_status}
- Region: {residence_region}
- Preferred Language: {preferred_language}

CONTEXT (from knowledge base):
{rag_context}

IMPORTANT: Always end your response with source citations in this format:
📚 Sources:
- [Title](URL)

And always include this disclaimer at the end:
⚠️ {disclaimer}"""


@dataclass
class UserContext:
    """User profile info for system prompt."""

    nationality: Optional[str] = None
    residence_status: Optional[str] = None
    residence_region: Optional[str] = None
    preferred_language: str = "en"


@dataclass
class ChatContext:
    """Full context for a chat response."""

    user_context: UserContext
    rag_chunks: List[RAGChunk] = field(default_factory=list)
    history: List[dict] = field(default_factory=list)  # [{"role": "user/assistant", "content": "..."}]


@dataclass
class StreamResult:
    """Result metadata collected during streaming."""

    full_content: str = ""
    tokens_used: int = 0
    sources: List[dict] = field(default_factory=list)


def _build_system_prompt(ctx: ChatContext) -> str:
    """Build the system prompt with user profile and RAG context."""
    rag_context = "\n\n".join(
        f"[{i + 1}] {chunk.title}\n{chunk.content}\nSource: {chunk.url}"
        for i, chunk in enumerate(ctx.rag_chunks)
    )
    if not rag_context:
        rag_context = "No specific context available. Provide general guidance."

    return SYSTEM_PROMPT_TEMPLATE.format(
        nationality=ctx.user_context.nationality or "Not specified",
        residence_status=ctx.user_context.residence_status or "Not specified",
        residence_region=ctx.user_context.residence_region or "Not specified",
        preferred_language=ctx.user_context.preferred_language,
        rag_context=rag_context,
        disclaimer=DISCLAIMER,
    )


def _build_messages(ctx: ChatContext, user_message: str) -> List[dict]:
    """Build the messages array for Claude API."""
    messages = []

    # Add conversation history (last 10 messages)
    for msg in ctx.history[-10:]:
        messages.append({"role": msg["role"], "content": msg["content"]})

    # Add current user message
    messages.append({"role": "user", "content": user_message})

    return messages


def _extract_sources(rag_chunks: List[RAGChunk]) -> List[dict]:
    """Extract source citations from RAG chunks."""
    return [
        {"title": chunk.title, "url": chunk.url}
        for chunk in rag_chunks
        if chunk.url
    ]


# ── Mock streaming response ───────────────────────────────────────────

_MOCK_RESPONSE = (
    "Thank you for your question! Based on the available information, "
    "here's what I can help you with.\n\n"
    "As a foreign resident in Japan, there are many resources available to assist you. "
    "I recommend checking with your local municipal office (市区町村役場) for the most "
    "accurate and up-to-date information specific to your area.\n\n"
    "Here are some general steps you can take:\n"
    "1. Visit your local ward/city office for resident services\n"
    "2. Check the Immigration Services Agency website for visa-related matters\n"
    "3. Contact the multilingual support hotline if you need language assistance\n\n"
    "📚 Sources:\n"
    "- [Immigration Services Agency](https://www.isa.go.jp/en/)\n"
    "- [CLAIR Multilingual Guide](https://www.clair.or.jp/tagengo/)\n\n"
    "⚠️ This information is for general guidance only and does not constitute legal advice. "
    "Please verify with relevant authorities for the most up-to-date information."
)


async def _mock_stream(user_message: str) -> AsyncIterator[str]:
    """Stream mock response word by word."""
    words = _MOCK_RESPONSE.split(" ")
    for i, word in enumerate(words):
        if i > 0:
            yield " " + word
        else:
            yield word
        await asyncio.sleep(0.02)  # Simulate streaming delay


# ── Real Claude API streaming ─────────────────────────────────────────


async def _claude_stream(
    system_prompt: str,
    messages: List[dict],
) -> AsyncIterator[str]:
    """Stream response from Claude API."""
    import anthropic

    client = anthropic.AsyncAnthropic(api_key=settings.ANTHROPIC_API_KEY)

    async with client.messages.stream(
        model=settings.CLAUDE_MODEL,
        max_tokens=settings.CLAUDE_MAX_TOKENS,
        system=system_prompt,
        messages=messages,
    ) as stream:
        async for text in stream.text_stream:
            yield text


# ── Public API ─────────────────────────────────────────────────────────


async def stream_response(
    user_message: str,
    context: ChatContext,
) -> AsyncIterator[str]:
    """Stream AI response for a user message.

    Yields text chunks. Caller is responsible for assembling the full response.

    Uses Claude API when available, falls back to mock streaming.
    """
    if not settings.claude_available:
        logger.info("Claude API not configured — using mock response mode.")
        async for chunk in _mock_stream(user_message):
            yield chunk
        return

    try:
        system_prompt = _build_system_prompt(context)
        messages = _build_messages(context, user_message)

        async for chunk in _claude_stream(system_prompt, messages):
            yield chunk
    except Exception as exc:
        logger.error("Claude streaming failed: %s — falling back to mock", exc)
        async for chunk in _mock_stream(user_message):
            yield chunk


def get_sources(rag_chunks: List[RAGChunk]) -> List[dict]:
    """Extract source citations from RAG chunks."""
    return _extract_sources(rag_chunks)


def get_disclaimer() -> str:
    """Return the disclaimer text."""
    return DISCLAIMER
