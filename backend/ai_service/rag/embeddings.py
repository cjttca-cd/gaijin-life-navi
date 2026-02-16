"""Embedding helper — text-embedding-3-small via OpenAI.

Falls back to a zero-vector when OpenAI API key is not configured.
"""

import logging
from typing import List

from config import settings

logger = logging.getLogger(__name__)

EMBEDDING_DIMENSION = 1536  # text-embedding-3-small dimension


async def get_embedding(text: str) -> List[float]:
    """Convert text to embedding vector.

    Returns a zero vector when OpenAI is not configured (mock mode).
    """
    if not settings.OPENAI_API_KEY:
        logger.debug("OpenAI not configured — returning zero vector (mock mode).")
        return [0.0] * EMBEDDING_DIMENSION

    try:
        from openai import AsyncOpenAI

        client = AsyncOpenAI(api_key=settings.OPENAI_API_KEY)
        response = await client.embeddings.create(
            model=settings.EMBEDDING_MODEL,
            input=text,
        )
        return response.data[0].embedding
    except Exception as exc:
        logger.error("Embedding generation failed: %s", exc)
        return [0.0] * EMBEDDING_DIMENSION


async def get_embeddings_batch(texts: List[str]) -> List[List[float]]:
    """Convert multiple texts to embedding vectors."""
    if not settings.OPENAI_API_KEY:
        return [[0.0] * EMBEDDING_DIMENSION for _ in texts]

    try:
        from openai import AsyncOpenAI

        client = AsyncOpenAI(api_key=settings.OPENAI_API_KEY)
        response = await client.embeddings.create(
            model=settings.EMBEDDING_MODEL,
            input=texts,
        )
        return [item.embedding for item in response.data]
    except Exception as exc:
        logger.error("Batch embedding generation failed: %s", exc)
        return [[0.0] * EMBEDDING_DIMENSION for _ in texts]
