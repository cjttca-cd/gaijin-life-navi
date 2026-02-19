"""OpenClaw agent calling service.

Provides async functions to invoke OpenClaw CLI agents and route messages
to the appropriate domain agent.

Every call is stateless: the /reset prefix forces OpenClaw to create a fresh
session. The frontend manages conversation history and sends prior context
with each request.

Usage::

    from services.agent import call_agent, route_to_agent

    domain = route_to_agent(user_message)
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

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

_OPENCLAW_WORKDIR = "/root/.openclaw"
"""Working directory for OpenClaw subprocess calls."""

_OPENCLAW_BIN = "openclaw"
"""Binary name — expected to be on ``$PATH``."""


# ---------------------------------------------------------------------------
# Response dataclass
# ---------------------------------------------------------------------------


@dataclass(frozen=True, slots=True)
class AgentResponse:
    """Structured response from an OpenClaw agent invocation.

    Attributes:
        text: The agent's reply text.
        model: Model identifier (e.g. ``"claude-sonnet-4-5"``).
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


# ---------------------------------------------------------------------------
# Core agent caller
# ---------------------------------------------------------------------------


async def call_agent(
    agent_id: str,
    message: str,
    context: list[dict] | None = None,
    image_path: str | None = None,
    user_profile: dict | None = None,
    timeout: int = 60,
) -> AgentResponse:
    """Invoke an OpenClaw agent statelessly and return a structured response.

    Every call is prefixed with ``/reset`` so OpenClaw creates a fresh
    session, ensuring complete isolation between users/requests.
    Conversation history is passed explicitly via *context*.

    Parameters:
        agent_id: The agent identifier to route to (e.g. ``"svc-concierge"``).
        message: The user's message text.
        context: Optional list of prior conversation turns, each a dict
            with ``role`` (``"user"`` | ``"assistant"``) and ``text``.
        image_path: Optional filesystem path to an uploaded image.
        user_profile: Optional dict with user profile fields
            (``display_name``, ``nationality``, ``residence_status``,
            ``residence_region``, ``arrival_date``). Injected into the
            prompt so the agent can personalise responses.
        timeout: Maximum seconds to wait for the agent (passed to both
            OpenClaw ``--timeout`` and ``asyncio`` subprocess timeout).

    Returns:
        An :class:`AgentResponse` — always returned, never raises.
        Check ``response.status`` for success/failure.
    """
    start = time.monotonic()

    # Build the full message with /reset prefix for stateless isolation.
    full_message = "/reset "

    # Inject user profile so the agent can personalise responses.
    if user_profile:
        profile_lines = ["【ユーザープロフィール】"]
        field_map = {
            "display_name": "表示名",
            "nationality": "国籍",
            "residence_status": "在留資格",
            "residence_region": "居住地域",
            "arrival_date": "来日時期",
        }
        for key, label in field_map.items():
            value = user_profile.get(key)
            if value:
                profile_lines.append(f"{label}: {value}")
        if len(profile_lines) > 1:  # has at least one field
            full_message += "\n".join(profile_lines) + "\n\n"

    # Append conversation history if provided.
    if context:
        full_message += "以下は過去の会話履歴です。この文脈を踏まえて回答してください。\n\n"
        for msg in context:
            role_label = "User" if msg["role"] == "user" else "Assistant"
            # Truncate very long messages in context.
            text = msg["text"][:2000]
            full_message += f"{role_label}: {text}\n\n"
        full_message += "---\n\n"

    # Append image instruction if present.
    if image_path:
        full_message += (
            f"[The user attached an image. Analyze it using the image "
            f"tool with path: {image_path}]\n\n"
        )

    # Append the actual new message.
    full_message += message

    cmd = [
        _OPENCLAW_BIN,
        "agent",
        "--agent", agent_id,
        "--message", full_message,
        "--json",
        "--thinking", "low",
        "--timeout", str(timeout),
    ]

    logger.info(
        "Calling agent=%s timeout=%ds message_len=%d context_len=%d",
        agent_id,
        timeout,
        len(full_message),
        len(context) if context else 0,
    )

    try:
        proc = await asyncio.create_subprocess_exec(
            *cmd,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
            cwd=_OPENCLAW_WORKDIR,
        )

        # Give a small buffer over the CLI timeout so OpenClaw can
        # handle its own timeout gracefully before we force-kill.
        subprocess_timeout = timeout + 15

        try:
            stdout_bytes, stderr_bytes = await asyncio.wait_for(
                proc.communicate(),
                timeout=subprocess_timeout,
            )
        except asyncio.TimeoutError:
            # Force-kill the runaway process.
            logger.error(
                "Agent subprocess timed out after %ds; killing pid=%s",
                subprocess_timeout,
                proc.pid,
            )
            proc.kill()
            await proc.wait()
            elapsed_ms = int((time.monotonic() - start) * 1000)
            return AgentResponse(
                text="",
                model="",
                duration_ms=elapsed_ms,
                input_tokens=0,
                output_tokens=0,
                cache_read_tokens=0,
                status="error",
                error=f"Agent timed out after {subprocess_timeout}s",
            )

        elapsed_ms = int((time.monotonic() - start) * 1000)
        stdout = stdout_bytes.decode("utf-8", errors="replace").strip()
        stderr = stderr_bytes.decode("utf-8", errors="replace").strip()

        if stderr:
            logger.debug("Agent stderr: %s", stderr[:500])

        # Non-zero exit code — treat as error.
        if proc.returncode != 0:
            logger.error(
                "Agent exited with code %d (agent=%s): %s",
                proc.returncode,
                agent_id,
                stderr[:300] or stdout[:300],
            )
            # Try to extract a useful error message.
            error_detail = stderr or stdout or f"exit code {proc.returncode}"
            return AgentResponse(
                text="",
                model="",
                duration_ms=elapsed_ms,
                input_tokens=0,
                output_tokens=0,
                cache_read_tokens=0,
                status="error",
                error=error_detail[:1000],
            )

        # Parse JSON output.
        return _parse_json_response(stdout, elapsed_ms)

    except FileNotFoundError:
        elapsed_ms = int((time.monotonic() - start) * 1000)
        logger.critical("openclaw binary not found on PATH")
        return AgentResponse(
            text="",
            model="",
            duration_ms=elapsed_ms,
            input_tokens=0,
            output_tokens=0,
            cache_read_tokens=0,
            status="error",
            error="openclaw binary not found",
        )
    except OSError as exc:
        elapsed_ms = int((time.monotonic() - start) * 1000)
        logger.exception("OS error spawning openclaw subprocess")
        return AgentResponse(
            text="",
            model="",
            duration_ms=elapsed_ms,
            input_tokens=0,
            output_tokens=0,
            cache_read_tokens=0,
            status="error",
            error=f"Subprocess OS error: {exc}",
        )


# ---------------------------------------------------------------------------
# JSON parsing helper
# ---------------------------------------------------------------------------


def _parse_json_response(
    raw: str,
    elapsed_ms: int,
) -> AgentResponse:
    """Parse OpenClaw ``--json`` output into an :class:`AgentResponse`.

    Handles multiple JSON objects in the output (OpenClaw may emit
    progress lines before the final result) by trying the last valid
    JSON object first, then falling back to the first.
    """
    if not raw:
        logger.error("Empty stdout from openclaw agent")
        return AgentResponse(
            text="",
            model="",
            duration_ms=elapsed_ms,
            input_tokens=0,
            output_tokens=0,
            cache_read_tokens=0,
            status="error",
            error="Empty response from agent",
        )

    # OpenClaw --json may output one JSON object or multiple NDJSON lines.
    # Try to find the "result" object (contains "text" or "reply").
    candidates: list[dict] = []
    for line in raw.splitlines():
        line = line.strip()
        if not line or not line.startswith("{"):
            continue
        try:
            candidates.append(json.loads(line))
        except json.JSONDecodeError:
            continue

    # If no NDJSON lines found, try parsing the entire block.
    if not candidates:
        try:
            candidates.append(json.loads(raw))
        except json.JSONDecodeError:
            logger.error("Failed to parse agent JSON output: %s", raw[:500])
            return AgentResponse(
                text="",
                model="",
                duration_ms=elapsed_ms,
                input_tokens=0,
                output_tokens=0,
                cache_read_tokens=0,
                status="error",
                error=f"Invalid JSON from agent: {raw[:200]}",
            )

    # Prefer the last object that looks like a result (has text/reply/message).
    data: dict = candidates[-1]
    for candidate in reversed(candidates):
        if any(k in candidate for k in ("text", "reply", "message", "result")):
            data = candidate
            break

    # Extract result — handle nested {"result": {...}} wrappers.
    result = data.get("result", data)
    if isinstance(result, str):
        # Some modes return {"result": "text here"}
        text = result
        result = data
    else:
        # OpenClaw --json output: {"result": {"payloads": [{"text": "..."}], "meta": {...}}}
        payloads = result.get("payloads")
        if isinstance(payloads, list) and payloads:
            text = payloads[0].get("text", "") or ""
        else:
            text = (
                result.get("text")
                or result.get("reply")
                or result.get("message")
                or ""
            )

    # Extract usage stats from agentMeta (OpenClaw format)
    meta = result.get("meta", {})
    agent_meta = meta.get("agentMeta", {})
    usage = agent_meta.get("usage") or result.get("usage") or result.get("stats") or {}
    if isinstance(usage, dict):
        input_tokens = usage.get("input") or usage.get("inputTokens") or usage.get("input_tokens") or 0
        output_tokens = usage.get("output") or usage.get("outputTokens") or usage.get("output_tokens") or 0
        cache_read = (
            usage.get("cacheRead")
            or usage.get("cacheReadInputTokens")
            or usage.get("cache_read_tokens")
            or 0
        )
    else:
        input_tokens = 0
        output_tokens = 0
        cache_read = 0

    model = agent_meta.get("model") or result.get("model") or result.get("modelId") or ""

    logger.info(
        "Agent response: model=%s tokens_in=%d tokens_out=%d cache=%d duration=%dms",
        model,
        input_tokens,
        output_tokens,
        cache_read,
        elapsed_ms,
    )

    return AgentResponse(
        text=text,
        model=str(model),
        duration_ms=elapsed_ms,
        input_tokens=int(input_tokens),
        output_tokens=int(output_tokens),
        cache_read_tokens=int(cache_read),
        status="ok",
    )


# ---------------------------------------------------------------------------
# Message routing
# ---------------------------------------------------------------------------

# Keyword patterns compiled once at module load.

_EMERGENCY_PATTERN = re.compile(
    r"\b(119|110)\b|救急|emergency|ambulance|緊急通報|救命|急救|救护车",
    re.IGNORECASE,
)

_CLASSIFY_PROMPT = """\
Classify the user message into exactly ONE domain. Reply with ONLY the domain name, nothing else.

Domains:
- banking — bank accounts, money transfer, ATM, tax payment, credit cards, cashless payment
- visa — residence status, visa renewal, immigration, permanent residency, residence card, work permit
- medical — hospitals, doctors, health insurance, pharmacy, vaccination, mental health
- concierge — general life in Japan, housing, transport, food, culture, anything else

If the message is ambiguous, choose the MOST relevant domain. If truly unclear, reply "concierge".

User message: {message}"""


async def route_to_agent(
    message: str,
    current_domain: str | None = None,
) -> str:
    """Determine which domain agent should handle *message*.

    Uses a two-layer approach:
    1. **Emergency keyword detection** (instant, no LLM) → svc-medical
    2. **LLM classification** via lightweight OpenClaw CLI call → domain agent
    3. **Fallback** to current_domain or svc-concierge if LLM fails

    Parameters:
        message: The user's raw message text.
        current_domain: The agent id of the ongoing conversation domain,
            or ``None`` if this is a fresh conversation.

    Returns:
        Agent identifier string (e.g. ``"svc-medical"``).
    """
    if not message or not message.strip():
        return current_domain or "svc-concierge"

    # 1. Emergency — instant keyword detection, no LLM needed.
    if _EMERGENCY_PATTERN.search(message):
        logger.info("Routing to svc-medical (emergency detected)")
        return "svc-medical"

    # 2. LLM classification via OpenClaw CLI (lightweight, fast).
    valid_domains = {"banking", "visa", "medical", "concierge"}
    try:
        classify_msg = _CLASSIFY_PROMPT.format(message=message[:500])
        resp = await call_agent(
            agent_id="svc-concierge",
            message=classify_msg,
            timeout=15,
        )
        if resp.status == "ok" and resp.text:
            domain = resp.text.strip().lower().rstrip(".")
            # Extract first word in case of extra text
            domain = domain.split()[0] if domain else ""
            if domain in valid_domains:
                agent_id = f"svc-{domain}"
                logger.info(
                    "LLM routing to %s (classified in %dms)",
                    agent_id, resp.duration_ms,
                )
                return agent_id
            else:
                logger.warning(
                    "LLM returned invalid domain '%s', falling back", domain,
                )
    except Exception:
        logger.exception("LLM classification failed, falling back")

    # 3. Fallback — sticky domain or concierge.
    if current_domain:
        logger.debug("Classification fallback; staying on %s", current_domain)
        return current_domain

    logger.debug("Classification fallback; routing to svc-concierge")
    return "svc-concierge"



# (build_session_id removed — stateless /reset mode eliminates session management)
