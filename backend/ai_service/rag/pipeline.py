"""RAG Pipeline — vector search for knowledge retrieval.

Performs:
1. Text → Embedding conversion (text-embedding-3-small via OpenAI)
2. Pinecone similarity search (top-5, category filter)
3. Structured results returned

Falls back to mock chunks when Pinecone/OpenAI are not configured.
"""

import logging
from dataclasses import dataclass, field
from typing import List, Optional

from config import settings

logger = logging.getLogger(__name__)


@dataclass
class RAGChunk:
    """A retrieved knowledge chunk."""

    content: str
    title: str
    url: str
    category: str
    score: float = 0.0


@dataclass
class RAGResult:
    """Result of a RAG pipeline query."""

    chunks: List[RAGChunk] = field(default_factory=list)
    is_mock: bool = False


# ── Mock knowledge base ────────────────────────────────────────────────

_MOCK_CHUNKS: dict[str, List[RAGChunk]] = {
    "banking": [
        RAGChunk(
            content="To open a bank account in Japan as a foreigner, you typically need: "
            "1) Residence Card (在留カード), 2) Passport, 3) Seal/Inkan (印鑑) or signature, "
            "4) Proof of address (住民票). Major banks like MUFG, SMBC, and Mizuho offer "
            "English-speaking services at select branches. Online banks like Sony Bank and "
            "Shinsei Bank provide multilingual interfaces.",
            title="Banking Guide for Foreign Residents",
            url="https://www.isa.go.jp/en/publications/materials/newimmiact_3_procedure.html",
            category="banking",
            score=0.95,
        ),
        RAGChunk(
            content="Japan Post Bank (ゆうちょ銀行) is often recommended for newcomers as it has "
            "branches in every post office nationwide and relatively simple account opening procedures. "
            "Some banks may require you to have lived in Japan for at least 6 months before opening an account.",
            title="Japan Post Bank for Foreigners",
            url="https://www.jp-bank.japanpost.jp/en/",
            category="banking",
            score=0.88,
        ),
    ],
    "visa": [
        RAGChunk(
            content="Visa renewal (在留期間更新) should be applied for at the Immigration Services Agency "
            "(出入国在留管理局) 3 months before expiry. Required documents include: application form, "
            "passport, residence card, photo (4x3cm), documents proving reason for continued stay "
            "(employment certificate, tax certificates, etc.).",
            title="Visa Renewal Guide",
            url="https://www.isa.go.jp/en/applications/procedures/16-3.html",
            category="visa",
            score=0.93,
        ),
    ],
    "medical": [
        RAGChunk(
            content="Japan's National Health Insurance (国民健康保険/NHI) covers 70% of medical costs. "
            "Foreign residents staying more than 3 months are required to enroll. Emergency number is 119 "
            "for ambulance. For non-emergency medical inquiries in English, call AMDA International "
            "Medical Information Center: 03-6233-9266.",
            title="Healthcare Guide for Foreign Residents",
            url="https://www.mhlw.go.jp/english/policy/health-medical/health-insurance/",
            category="medical",
            score=0.91,
        ),
    ],
    "admin": [
        RAGChunk(
            content="Within 14 days of arriving in Japan, you must register your address at the local "
            "municipal office (市区町村役場). Bring your passport and residence card. This registration "
            "is required for National Health Insurance enrollment, pension, and other services.",
            title="Resident Registration Guide",
            url="https://www.soumu.go.jp/main_sosiki/jichi_gyousei/c-gyousei/zairyu.html",
            category="admin",
            score=0.94,
        ),
    ],
    "housing": [
        RAGChunk(
            content="Renting an apartment in Japan typically requires: guarantor (保証人) or guarantor "
            "company (保証会社), initial costs including deposit (敷金, 1-2 months), key money (礼金, "
            "0-2 months), agent fee (仲介手数料, 1 month), and first month's rent. UR Housing (UR都市機構) "
            "offers apartments without key money or guarantor requirements.",
            title="Housing Guide for Foreign Residents",
            url="https://www.ur-net.go.jp/chintai/english/",
            category="housing",
            score=0.90,
        ),
    ],
    "work": [
        RAGChunk(
            content="Work regulations in Japan: Standard work hours are 8 hours/day, 40 hours/week. "
            "Overtime must be agreed upon in a 36 Agreement (三六協定). Workers are entitled to paid "
            "annual leave starting at 10 days/year after 6 months of continuous employment. "
            "Labor Standards Bureau (労働基準監督署) handles workplace complaints.",
            title="Work Rights in Japan",
            url="https://www.mhlw.go.jp/english/topics/working_conditions.html",
            category="work",
            score=0.89,
        ),
    ],
    "daily_life": [
        RAGChunk(
            content="Garbage separation in Japan is strict: burnable (燃えるゴミ), non-burnable "
            "(燃えないゴミ), recyclables (資源ゴミ), and oversized items (粗大ゴミ). Collection days "
            "vary by area. Your local ward office provides a garbage calendar. Incorrect separation "
            "may result in your garbage not being collected.",
            title="Daily Life Tips for Residents",
            url="https://www.env.go.jp/en/recycle/waste/index.html",
            category="daily_life",
            score=0.87,
        ),
    ],
    "general": [
        RAGChunk(
            content="Key resources for foreign residents in Japan: Immigration Services Agency (ISA) "
            "for visa matters, Hello Work (ハローワーク) for job searching, municipal offices for "
            "resident services, and CLAIR (Council of Local Authorities for International Relations) "
            "for multilingual living guides.",
            title="General Resources for Foreign Residents",
            url="https://www.clair.or.jp/tagengo/",
            category="general",
            score=0.85,
        ),
    ],
}


async def search(
    query: str,
    category: Optional[str] = None,
    top_k: int = 5,
) -> RAGResult:
    """Run the RAG pipeline: embed query → search Pinecone → return chunks.

    Falls back to mock chunks when Pinecone/OpenAI are not configured.
    """
    if not settings.rag_available:
        return _mock_search(query, category, top_k)

    try:
        from rag.embeddings import get_embedding

        query_embedding = await get_embedding(query)
        return await _pinecone_search(query_embedding, category, top_k)
    except Exception as exc:
        logger.error("RAG pipeline error, falling back to mock: %s", exc)
        return _mock_search(query, category, top_k)


def _mock_search(
    query: str,
    category: Optional[str] = None,
    top_k: int = 5,
) -> RAGResult:
    """Return mock RAG chunks based on category."""
    logger.debug(
        "Using mock RAG mode (Pinecone/OpenAI not configured). category=%s",
        category,
    )

    chunks: List[RAGChunk] = []

    if category and category in _MOCK_CHUNKS:
        chunks.extend(_MOCK_CHUNKS[category])

    # Always add general chunks
    if category != "general":
        chunks.extend(_MOCK_CHUNKS.get("general", []))

    # Deduplicate and limit
    seen_urls = set()
    unique_chunks = []
    for chunk in chunks:
        if chunk.url not in seen_urls:
            seen_urls.add(chunk.url)
            unique_chunks.append(chunk)

    return RAGResult(chunks=unique_chunks[:top_k], is_mock=True)


async def _pinecone_search(
    query_embedding: List[float],
    category: Optional[str] = None,
    top_k: int = 5,
) -> RAGResult:
    """Search Pinecone for similar vectors."""
    try:
        from pinecone import Pinecone

        pc = Pinecone(api_key=settings.PINECONE_API_KEY)
        index = pc.Index(settings.PINECONE_INDEX_NAME)

        filter_dict = {}
        if category and category != "general":
            filter_dict["category"] = category

        results = index.query(
            vector=query_embedding,
            top_k=top_k,
            include_metadata=True,
            filter=filter_dict if filter_dict else None,
        )

        chunks = []
        for match in results.get("matches", []):
            metadata = match.get("metadata", {})
            chunks.append(
                RAGChunk(
                    content=metadata.get("content", ""),
                    title=metadata.get("title", "Unknown"),
                    url=metadata.get("url", ""),
                    category=metadata.get("category", "general"),
                    score=match.get("score", 0.0),
                )
            )

        return RAGResult(chunks=chunks, is_mock=False)
    except Exception as exc:
        logger.error("Pinecone search failed: %s", exc)
        return _mock_search("", category, top_k)
