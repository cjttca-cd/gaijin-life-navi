"""Knowledge base loader — CLI script for ingesting documents into Pinecone.

Usage:
    python -m rag.knowledge_loader --file data/knowledge.jsonl
    python -m rag.knowledge_loader --directory data/knowledge/

JSONL format (one document per line):
    {"title": "...", "content": "...", "url": "...", "category": "banking"}

⚠️ Requires OPENAI_API_KEY and PINECONE_API_KEY to be set.
"""

import argparse
import asyncio
import json
import logging
import sys
from pathlib import Path
from typing import List

logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(levelname)s | %(message)s")
logger = logging.getLogger(__name__)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Load knowledge documents into Pinecone")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--file", type=str, help="Path to JSONL file")
    group.add_argument("--directory", type=str, help="Path to directory of JSONL files")
    parser.add_argument("--batch-size", type=int, default=50, help="Batch size for upserts")
    return parser.parse_args()


def load_documents(path: str) -> List[dict]:
    """Load documents from a JSONL file."""
    docs = []
    with open(path, "r", encoding="utf-8") as f:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue
            try:
                doc = json.loads(line)
                if "content" not in doc or "title" not in doc:
                    logger.warning("Line %d missing required fields, skipping", line_num)
                    continue
                docs.append(doc)
            except json.JSONDecodeError as e:
                logger.warning("Line %d invalid JSON: %s", line_num, e)
    return docs


async def ingest_documents(documents: List[dict], batch_size: int = 50) -> None:
    """Embed and upsert documents into Pinecone."""
    from config import settings

    if not settings.rag_available:
        logger.error(
            "OPENAI_API_KEY and PINECONE_API_KEY must be set for knowledge loading."
        )
        sys.exit(1)

    from rag.embeddings import get_embeddings_batch

    try:
        from pinecone import Pinecone

        pc = Pinecone(api_key=settings.PINECONE_API_KEY)
        index = pc.Index(settings.PINECONE_INDEX_NAME)
    except Exception as exc:
        logger.error("Failed to connect to Pinecone: %s", exc)
        sys.exit(1)

    total = len(documents)
    logger.info("Processing %d documents in batches of %d", total, batch_size)

    for i in range(0, total, batch_size):
        batch = documents[i : i + batch_size]
        texts = [doc["content"] for doc in batch]

        logger.info("Embedding batch %d-%d / %d", i + 1, min(i + batch_size, total), total)
        embeddings = await get_embeddings_batch(texts)

        vectors = []
        for doc, embedding in zip(batch, embeddings):
            import uuid

            vectors.append(
                {
                    "id": str(uuid.uuid4()),
                    "values": embedding,
                    "metadata": {
                        "title": doc["title"],
                        "content": doc["content"],
                        "url": doc.get("url", ""),
                        "category": doc.get("category", "general"),
                    },
                }
            )

        try:
            index.upsert(vectors=vectors)
            logger.info("Upserted %d vectors", len(vectors))
        except Exception as exc:
            logger.error("Upsert failed for batch starting at %d: %s", i, exc)

    logger.info("Knowledge loading complete. Total documents processed: %d", total)


def main() -> None:
    args = parse_args()

    documents: List[dict] = []

    if args.file:
        documents = load_documents(args.file)
    elif args.directory:
        dir_path = Path(args.directory)
        for jsonl_file in sorted(dir_path.glob("*.jsonl")):
            logger.info("Loading %s", jsonl_file)
            documents.extend(load_documents(str(jsonl_file)))

    if not documents:
        logger.warning("No documents found to load.")
        sys.exit(0)

    logger.info("Loaded %d documents total", len(documents))
    asyncio.run(ingest_documents(documents, args.batch_size))


if __name__ == "__main__":
    main()
