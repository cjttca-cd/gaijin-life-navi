"""LLM direct API agent calling service.

Replaces the OpenClaw subprocess approach with direct HTTP calls to a local
LLM proxy (OpenAI-compatible API).  Domain knowledge files are loaded from
disk and injected into the system prompt.

Every call is stateless.  The frontend manages conversation history and
sends prior context with each request.

Usage::

    from services.agent import call_agent, route_to_agent

    domain = await route_to_agent(user_message)
    response = await call_agent(agent_id=domain, message=user_message, context=ctx)

    if response.status == "ok":
        print(response.text)
"""

from __future__ import annotations

import asyncio
import json
import logging
import re
import time
from dataclasses import dataclass, field
from pathlib import Path

import httpx

from config import settings

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

_BACKEND_DIR = Path(__file__).resolve().parent.parent
"""Backend app_service directory (contains prompts/ and knowledge/)."""

_PROMPTS_DIR = _BACKEND_DIR / "prompts"
"""System prompt files for each domain agent."""

_KNOWLEDGE_DIR = _BACKEND_DIR / "knowledge"
"""Domain knowledge files (migrated from OpenClaw agent workspaces)."""

# ---------------------------------------------------------------------------
# Response dataclass  (unchanged — interface contract)
# ---------------------------------------------------------------------------


@dataclass(frozen=True, slots=True)
class AgentResponse:
    """Structured response from an LLM agent invocation.

    Attributes:
        text: The agent's reply text.
        model: Model identifier (e.g. ``"gemini-3-flash"``).
        duration_ms: Wall-clock response time in milliseconds.
        input_tokens: Prompt tokens consumed.
        output_tokens: Completion tokens generated.
        cache_read_tokens: Tokens served from cache.
        status: ``"ok"`` on success, ``"error"`` on failure.
        error: Human-readable error description when *status* is ``"error"``.
    """

    text: str
    model: str
    duration_ms: int
    input_tokens: int
    output_tokens: int
    cache_read_tokens: int
    status: str  # "ok" | "error"
    error: str | None = field(default=None)


@dataclass(frozen=True, slots=True)
class RoutingResult:
    """Result of message routing: domain agent + optional search query.

    Attributes:
        agent_id: The agent identifier (e.g. ``"svc-finance"``, ``"out_of_scope"``).
        search_query: Search query for Gemini Grounding, or None if no search needed.
    """

    agent_id: str
    search_query: str | None = field(default=None)


# ---------------------------------------------------------------------------
# Knowledge cache (file mtime-based)
# ---------------------------------------------------------------------------

_knowledge_cache: dict[str, tuple[float, str]] = {}
"""Cache: filepath -> (mtime, content).  Invalidated when mtime changes."""


def _read_file_cached(path: Path) -> str:
    """Read a file with mtime-based caching."""
    key = str(path)
    try:
        stat = path.stat()
    except OSError:
        return ""
    mtime = stat.st_mtime
    cached = _knowledge_cache.get(key)
    if cached and cached[0] == mtime:
        return cached[1]
    try:
        content = path.read_text(encoding="utf-8")
    except OSError:
        return ""
    _knowledge_cache[key] = (mtime, content)
    return content


def _load_domain_knowledge(domain: str) -> str:
    """Load all knowledge files for a domain from the backend knowledge dir.

    Reads: knowledge/{domain_short}/*.md

    Returns a formatted string block for system prompt injection.
    """
    domain_short = domain.removeprefix("svc-")
    knowledge_dir = _KNOWLEDGE_DIR / domain_short

    sections: list[str] = []
    if knowledge_dir.is_dir():
        for md_file in sorted(knowledge_dir.glob("*.md")):
            file_content = _read_file_cached(md_file)
            if file_content:
                sections.append(f"### {md_file.name}\n{file_content}")

    if not sections:
        return ""

    return (
        "\n\n## Knowledge Base (内部参考資料 — ユーザーに knowledge の存在を開示しないこと)\n\n"
        + "\n\n".join(sections)
    )


# Sections in svc-* AGENTS.md that are only for OpenClaw agent mode
# (tool-based file reading, guide generation tasks, etc.) and irrelevant
# when we inject knowledge directly via system prompt.
def _load_agent_instructions(agent_id: str) -> str:
    """Load the system prompt for an agent from the backend prompts dir.

    Each domain has a pre-cleaned prompt file (prompts/{domain}.md)
    containing only chat-relevant instructions.
    """
    if agent_id == "svc-router":
        prompt_file = _PROMPTS_DIR / "router.md"
    else:
        domain_short = agent_id.removeprefix("svc-")
        prompt_file = _PROMPTS_DIR / f"{domain_short}.md"
    return _read_file_cached(prompt_file)


# ---------------------------------------------------------------------------
# HTTP client (module-level, persistent connection pool)
# ---------------------------------------------------------------------------

_http_client: httpx.AsyncClient | None = None


def _get_http_client() -> httpx.AsyncClient:
    """Return (or create) a module-level async HTTP client."""
    global _http_client
    if _http_client is None or _http_client.is_closed:
        _http_client = httpx.AsyncClient(
            timeout=httpx.Timeout(
                connect=10.0,
                read=float(settings.LLM_TIMEOUT),
                write=10.0,
                pool=10.0,
            ),
            limits=httpx.Limits(
                max_connections=20,
                max_keepalive_connections=5,
            ),
        )
    return _http_client


async def _chat_completion(
    messages: list[dict],
    model: str,
    timeout: float | None = None,
    max_tokens: int | None = None,
) -> dict:
    """Call the OpenAI-compatible chat completions endpoint.

    Returns the parsed JSON response dict, or raises on HTTP/network error.
    """
    client = _get_http_client()
    url = f"{settings.LLM_API_BASE_URL}/chat/completions"

    payload: dict = {
        "model": model,
        "messages": messages,
    }
    if max_tokens is not None:
        payload["max_tokens"] = max_tokens

    headers = {
        "Content-Type": "application/json",
    }
    if settings.LLM_API_KEY:
        headers["Authorization"] = f"Bearer {settings.LLM_API_KEY}"

    effective_timeout = timeout or float(settings.LLM_TIMEOUT)

    response = await client.post(
        url,
        json=payload,
        headers=headers,
        timeout=effective_timeout,
    )
    response.raise_for_status()
    return response.json()


async def _chat_completion_with_fallback(
    messages: list[dict],
    primary_model: str,
    fallback_model: str,
    timeout: float | None = None,
    max_tokens: int | None = None,
) -> tuple[dict, str]:
    """Try primary model, fall back to fallback_model on failure.

    Returns (response_dict, model_used).
    Raises if both fail.
    """
    for model in (primary_model, fallback_model):
        try:
            result = await _chat_completion(
                messages=messages,
                model=model,
                timeout=timeout,
                max_tokens=max_tokens,
            )
            return result, model
        except Exception as exc:
            if model == primary_model:
                logger.warning(
                    "Primary model %s failed (%s), trying fallback %s",
                    model, exc, fallback_model,
                )
                continue
            else:
                raise


# ---------------------------------------------------------------------------
# Gemini Grounding search (Google Search via direct API)
# ---------------------------------------------------------------------------

_genai_client = None  # Lazy-initialized google.genai.Client


def _get_genai_client():
    """Return (or create) a module-level google.genai Client."""
    global _genai_client
    if _genai_client is None:
        from google import genai
        _genai_client = genai.Client(api_key=settings.GEMINI_API_KEY)
    return _genai_client


_SEARCH_PROMPT = (
    "以下のトピックについてウェブ検索し、見つかった事実情報を箇条書きで簡潔に返してください。"
    "解説や推測は不要です。検索で見つかった具体的な数字・条件・日付のみ列挙してください。"
    "\n\n検索トピック: {query}"
)


async def _execute_search(query: str) -> str | None:
    """Execute web search via Gemini Grounding and return fact summary.

    Uses Gemini Direct API (not the proxy) with Google Search tool.
    Returns formatted text for injection into agent prompt, or None on failure.
    """
    if not settings.GEMINI_API_KEY:
        logger.warning("GEMINI_API_KEY not set, skipping search")
        return None

    try:
        from google.genai import types

        client = _get_genai_client()
        prompt = _SEARCH_PROMPT.format(query=query)

        # Run the synchronous genai call in a thread to avoid blocking the event loop
        loop = asyncio.get_event_loop()
        response = await asyncio.wait_for(
            loop.run_in_executor(
                None,
                lambda: client.models.generate_content(
                    model=settings.SEARCH_MODEL,
                    contents=prompt,
                    config=types.GenerateContentConfig(
                        tools=[types.Tool(google_search=types.GoogleSearch())],
                        max_output_tokens=400,
                    ),
                ),
            ),
            timeout=10.0,
        )

        if response and response.text:
            logger.info(
                "Search completed for query=%s, result_len=%d",
                query[:80], len(response.text),
            )
            return response.text
        else:
            logger.warning("Search returned empty response for query=%s", query[:80])
            return None

    except asyncio.TimeoutError:
        logger.warning("Search timed out (10s) for query=%s", query[:80])
        return None
    except Exception:
        logger.exception("Search failed for query=%s", query[:80])
        return None


# ---------------------------------------------------------------------------
# Core agent caller  (signature updated — search_results parameter added)
# ---------------------------------------------------------------------------


async def call_agent(
    agent_id: str,
    message: str,
    context: list[dict] | None = None,
    image_path: str | None = None,
    user_profile: dict | None = None,
    search_results: str | None = None,
    timeout: int = 90,
) -> AgentResponse:
    """Invoke an LLM agent via direct API call and return a structured response.

    Domain knowledge is loaded from disk and injected into the system
    prompt.  Conversation history is passed via user messages.

    Parameters:
        agent_id: The agent identifier to route to (e.g. ``"svc-life"``).
        message: The user's message text.
        context: Optional list of prior conversation turns, each a dict
            with ``role`` (``"user"`` | ``"assistant"``) and ``text``.
        image_path: Optional filesystem path to an uploaded image.
        user_profile: Optional dict with user profile fields.
        search_results: Optional web search results to inject into the prompt.
        timeout: Maximum seconds to wait for the agent.

    Returns:
        An :class:`AgentResponse` — always returned, never raises.
        Check ``response.status`` for success/failure.
    """
    start = time.monotonic()

    # ---- Build system prompt: agent instructions + domain knowledge ----
    agent_instructions = _load_agent_instructions(agent_id)
    domain_knowledge = _load_domain_knowledge(agent_id)

    system_prompt = agent_instructions
    if domain_knowledge:
        system_prompt += "\n\n" + domain_knowledge

    # ---- Build user message (same structure as before) ----
    user_message_parts: list[str] = []

    # Inject user profile
    if user_profile:
        profile_lines = ["【ユーザープロフィール】"]
        field_map = {
            "display_name": "表示名",
            "subscription_tier": "会員プラン",
            "nationality": "国籍",
            "residence_status": "在留資格",
            "visa_expiry": "在留期限",
            "residence_region": "居住地域",
            "preferred_language": "首選語言",
        }
        for key, label in field_map.items():
            value = user_profile.get(key)
            if value:
                profile_lines.append(f"{label}: {value}")
        profile_lines.append("回答深度: 深度級")
        user_message_parts.append("\n".join(profile_lines))

    # Append conversation history
    if context:
        history_lines = ["以下は過去の会話履歴です。この文脈を踏まえて回答してください。"]
        for msg in context:
            role_label = "User" if msg["role"] == "user" else "Assistant"
            text = msg["text"][:2000]
            history_lines.append(f"\n{role_label}: {text}")
        history_lines.append("\n---")
        user_message_parts.append("\n".join(history_lines))

    # Image handling — file saved but analysis deferred
    if image_path:
        user_message_parts.append(
            "(User attached an image — image analysis not yet supported in this mode)"
        )

    # Search results injection (before the user's question)
    if search_results:
        user_message_parts.append(
            "【ウェブ検索結果（参考情報 — 数字や日付はこの検索結果を優先すること）】\n"
            f"{search_results}"
        )

    # The actual current question
    user_message_parts.append(f"【現在のユーザーの質問】\n{message}")

    full_user_message = "\n\n".join(user_message_parts)

    # ---- Build messages array ----
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": full_user_message},
    ]

    logger.info(
        "Calling agent=%s timeout=%ds message_len=%d context_len=%d system_len=%d",
        agent_id,
        timeout,
        len(full_user_message),
        len(context) if context else 0,
        len(system_prompt),
    )

    try:
        result, model_used = await _chat_completion_with_fallback(
            messages=messages,
            primary_model=settings.LLM_AGENT_MODEL,
            fallback_model=settings.LLM_AGENT_FALLBACK_MODEL,
            timeout=float(timeout),
        )

        elapsed_ms = int((time.monotonic() - start) * 1000)

        # Extract response text
        choices = result.get("choices", [])
        if not choices:
            return AgentResponse(
                text="",
                model=model_used,
                duration_ms=elapsed_ms,
                input_tokens=0,
                output_tokens=0,
                cache_read_tokens=0,
                status="error",
                error="No choices in LLM response",
            )

        text = choices[0].get("message", {}).get("content", "")

        # Extract usage stats
        usage = result.get("usage", {})
        input_tokens = usage.get("prompt_tokens", 0)
        output_tokens = usage.get("completion_tokens", 0)
        cache_read = usage.get("prompt_tokens_details", {}).get("cached_tokens", 0) if isinstance(usage.get("prompt_tokens_details"), dict) else 0

        logger.info(
            "Agent response: model=%s tokens_in=%d tokens_out=%d cache=%d duration=%dms",
            model_used,
            input_tokens,
            output_tokens,
            cache_read,
            elapsed_ms,
        )

        return AgentResponse(
            text=text,
            model=model_used,
            duration_ms=elapsed_ms,
            input_tokens=input_tokens,
            output_tokens=output_tokens,
            cache_read_tokens=cache_read,
            status="ok",
        )

    except httpx.TimeoutException:
        elapsed_ms = int((time.monotonic() - start) * 1000)
        logger.error("Agent API timed out after %dms (agent=%s)", elapsed_ms, agent_id)
        return AgentResponse(
            text="",
            model="",
            duration_ms=elapsed_ms,
            input_tokens=0,
            output_tokens=0,
            cache_read_tokens=0,
            status="error",
            error=f"Agent timed out after {timeout}s",
        )
    except httpx.HTTPStatusError as exc:
        elapsed_ms = int((time.monotonic() - start) * 1000)
        logger.error(
            "Agent API HTTP error %d (agent=%s): %s",
            exc.response.status_code, agent_id, exc.response.text[:300],
        )
        return AgentResponse(
            text="",
            model="",
            duration_ms=elapsed_ms,
            input_tokens=0,
            output_tokens=0,
            cache_read_tokens=0,
            status="error",
            error=f"LLM API error: {exc.response.status_code}",
        )
    except Exception as exc:
        elapsed_ms = int((time.monotonic() - start) * 1000)
        logger.exception("Unexpected error calling agent %s", agent_id)
        return AgentResponse(
            text="",
            model="",
            duration_ms=elapsed_ms,
            input_tokens=0,
            output_tokens=0,
            cache_read_tokens=0,
            status="error",
            error=f"Unexpected error: {exc}",
        )


# ---------------------------------------------------------------------------
# Message routing  (returns RoutingResult with agent_id + search_query)
# ---------------------------------------------------------------------------

# Keyword patterns compiled once at module load.

_EMERGENCY_PATTERN = re.compile(
    r"\b(119|110)\b|救急|emergency|ambulance|緊急通報|救命|急救|救护车",
    re.IGNORECASE,
)

_CLASSIFY_PROMPT = """\
Classify the conversation into exactly ONE domain. Reply with ONLY the domain name, nothing else.

Domains:
- finance — bank accounts, money transfer, credit cards, insurance, loans, investment (NISA/iDeCo), cashless payment
- tax — income tax, resident tax, pension, social insurance, tax filing (確定申告), furusato nozei, payslip
- visa — residence status, visa renewal, immigration, permanent residency, residence card, work permit
- medical — hospitals, doctors, health insurance, pharmacy, vaccination, mental health, pregnancy
- life — housing, transport, shopping, mobile phone, garbage, culture, education, administrative procedures (city hall, My Number)
- legal — labor disputes, consumer protection, traffic accidents, crime victims, divorce, legal rights

If the message is ambiguous, choose the MOST relevant domain based on the conversation context. If truly unclear, reply "life".

{context_section}Current user message: {message}"""

# Maximum number of recent conversation turns to include in routing context.
_ROUTING_CONTEXT_MAX_TURNS = 10


def _build_routing_context(context: list[dict] | None) -> str:
    """Build a conversation history section for the routing classifier.

    Takes the most recent *_ROUTING_CONTEXT_MAX_TURNS* turns from the
    frontend-provided context and formats them for the classification
    prompt.  Each message is truncated to 300 chars to keep the prompt
    compact — the router only needs enough to understand the topic,
    not the full detail.

    Returns an empty string when there is no context.
    """
    if not context:
        return ""

    recent = context[-_ROUTING_CONTEXT_MAX_TURNS:]
    lines = ["Recent conversation history:\n"]
    for msg in recent:
        role_label = "User" if msg["role"] == "user" else "Assistant"
        text = msg["text"][:300]
        lines.append(f"{role_label}: {text}\n")
    lines.append("\n")
    return "\n".join(lines)


def _parse_router_response(raw_text: str) -> tuple[str, str | None]:
    """Parse the router's JSON response into (domain, search_query).

    The router outputs JSON like: {"domain":"finance","search":"query text"}
    Flash-lite sometimes wraps output in ```json ... ``` code blocks.
    Falls back to single-word parsing if JSON parsing fails.

    Returns (domain, search_query) where search_query may be None.
    """
    text = raw_text.strip()

    # Strip markdown code block wrapper if present
    code_block_match = re.match(r"```(?:json)?\s*\n?(.*?)\n?\s*```", text, re.DOTALL)
    if code_block_match:
        text = code_block_match.group(1).strip()

    # Try JSON parse
    try:
        parsed = json.loads(text)
        if isinstance(parsed, dict):
            domain = str(parsed.get("domain", "")).strip().lower()
            search = parsed.get("search")
            search_query = str(search).strip() if search and str(search).strip().lower() != "null" else None
            return domain, search_query
    except (json.JSONDecodeError, ValueError):
        pass

    # Fallback: single-word parse (backward compat)
    domain = text.strip().lower().rstrip(".")
    domain = domain.split()[0] if domain else ""
    logger.warning("Router JSON parse failed, falling back to word parse: domain=%s", domain)
    return domain, None


async def route_to_agent(
    message: str,
    current_domain: str | None = None,
    context: list[dict] | None = None,
) -> RoutingResult:
    """Determine which domain agent should handle *message*.

    Uses a three-layer approach:
    1. **Emergency keyword detection** (instant, no LLM) → svc-medical
    2. **LLM classification** via direct API call to router model
    3. **Fallback** to current_domain or svc-life if LLM fails

    Parameters:
        message: The user's raw message text.
        current_domain: The agent id of the ongoing conversation domain,
            or ``None`` if this is a fresh conversation.
        context: Optional list of prior conversation turns, each a dict
            with ``role`` (``"user"`` | ``"assistant"``) and ``text``.

    Returns:
        A :class:`RoutingResult` with agent_id and optional search_query.
    """
    if not message or not message.strip():
        return RoutingResult(agent_id=current_domain or "svc-life")

    # 1. Emergency — instant keyword detection, no LLM needed.
    if _EMERGENCY_PATTERN.search(message):
        logger.info("Routing to svc-medical (emergency detected)")
        return RoutingResult(agent_id="svc-medical")

    # 2. LLM classification via direct API call (lightweight, fast).
    valid_domains = {"finance", "tax", "visa", "medical", "life", "legal", "out_of_scope"}
    try:
        context_section = _build_routing_context(context)
        classify_msg = _CLASSIFY_PROMPT.format(
            context_section=context_section,
            message=message[:500],
        )

        # Load router system prompt
        router_system = _load_agent_instructions("svc-router")

        messages = [
            {"role": "system", "content": router_system},
            {"role": "user", "content": classify_msg},
        ]

        result, model_used = await _chat_completion_with_fallback(
            messages=messages,
            primary_model=settings.LLM_ROUTER_MODEL,
            fallback_model=settings.LLM_ROUTER_FALLBACK_MODEL,
            timeout=15.0,
            max_tokens=100,  # JSON output needs more tokens
        )

        choices = result.get("choices", [])
        if choices:
            raw_text = choices[0].get("message", {}).get("content", "")

            usage = result.get("usage", {})
            duration_info = f"tokens_in={usage.get('prompt_tokens', 0)} tokens_out={usage.get('completion_tokens', 0)}"

            # Parse JSON response (with code-block strip + fallback)
            domain, search_query = _parse_router_response(raw_text)

            if domain == "out_of_scope":
                logger.info(
                    "LLM classified as out_of_scope (model=%s, %s, context_turns=%d)",
                    model_used, duration_info,
                    len(context) if context else 0,
                )
                return RoutingResult(agent_id="out_of_scope")
            if domain in valid_domains:
                agent_id = f"svc-{domain}"
                logger.info(
                    "LLM routing to %s search=%s (model=%s, %s, context_turns=%d)",
                    agent_id, search_query, model_used, duration_info,
                    len(context) if context else 0,
                )
                return RoutingResult(agent_id=agent_id, search_query=search_query)
            else:
                logger.warning(
                    "LLM returned invalid domain '%s', falling back", domain,
                )
    except Exception:
        logger.exception("LLM classification failed, falling back")

    # 3. Fallback — sticky domain or life.
    if current_domain:
        logger.debug("Classification fallback; staying on %s", current_domain)
        return RoutingResult(agent_id=current_domain)

    logger.debug("Classification fallback; routing to svc-life")
    return RoutingResult(agent_id="svc-life")
