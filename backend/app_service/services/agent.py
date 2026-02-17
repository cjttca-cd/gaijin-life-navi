"""OpenClaw agent calling service.

Provides async functions to invoke OpenClaw CLI agents, route messages
to the appropriate domain agent, and manage session identifiers.

Usage::

    from services.agent import call_agent, route_to_agent, build_session_id

    domain = route_to_agent(user_message)
    session = build_session_id(user_id, domain)
    response = await call_agent(agent_id=domain, session_id=session, message=user_message)

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
        session_id: OpenClaw session identifier used for this turn.
        status: ``"ok"`` on success, ``"error"`` on failure.
        error: Human-readable error description when *status* is ``"error"``.
    """

    text: str
    model: str
    duration_ms: int
    input_tokens: int
    output_tokens: int
    cache_read_tokens: int
    session_id: str
    status: str  # "ok" | "error"
    error: str | None = field(default=None)


# ---------------------------------------------------------------------------
# Core agent caller
# ---------------------------------------------------------------------------


async def call_agent(
    agent_id: str,
    session_id: str,
    message: str,
    timeout: int = 60,
) -> AgentResponse:
    """Invoke an OpenClaw agent and return a structured response.

    Parameters:
        agent_id: The agent identifier to route to (e.g. ``"svc-concierge"``).
        session_id: Explicit session id (must not contain colons).
        message: The user's message text.
        timeout: Maximum seconds to wait for the agent (passed to both
            OpenClaw ``--timeout`` and ``asyncio`` subprocess timeout).

    Returns:
        An :class:`AgentResponse` — always returned, never raises.
        Check ``response.status`` for success/failure.
    """
    start = time.monotonic()

    # Defensive: strip colons — OpenClaw rejects them in session IDs.
    safe_session = session_id.replace(":", "_")
    if safe_session != session_id:
        logger.warning(
            "Session id contained colons; sanitised %r → %r",
            session_id,
            safe_session,
        )

    cmd = [
        _OPENCLAW_BIN,
        "agent",
        "--agent", agent_id,
        "--session-id", safe_session,
        "--message", message,
        "--json",
        "--thinking", "low",
        "--timeout", str(timeout),
    ]

    logger.info(
        "Calling agent=%s session=%s timeout=%ds message_len=%d",
        agent_id,
        safe_session,
        timeout,
        len(message),
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
                session_id=safe_session,
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
                "Agent exited with code %d (agent=%s session=%s): %s",
                proc.returncode,
                agent_id,
                safe_session,
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
                session_id=safe_session,
                status="error",
                error=error_detail[:1000],
            )

        # Parse JSON output.
        return _parse_json_response(stdout, safe_session, elapsed_ms)

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
            session_id=safe_session,
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
            session_id=safe_session,
            status="error",
            error=f"Subprocess OS error: {exc}",
        )


# ---------------------------------------------------------------------------
# JSON parsing helper
# ---------------------------------------------------------------------------


def _parse_json_response(
    raw: str,
    session_id: str,
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
            session_id=session_id,
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
                session_id=session_id,
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
    resp_session = agent_meta.get("sessionId") or result.get("sessionId") or session_id

    logger.info(
        "Agent response: model=%s tokens_in=%d tokens_out=%d cache=%d duration=%dms session=%s",
        model,
        input_tokens,
        output_tokens,
        cache_read,
        elapsed_ms,
        resp_session,
    )

    return AgentResponse(
        text=text,
        model=str(model),
        duration_ms=elapsed_ms,
        input_tokens=int(input_tokens),
        output_tokens=int(output_tokens),
        cache_read_tokens=int(cache_read),
        session_id=str(resp_session),
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
            session_id="system_classify",
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


# ---------------------------------------------------------------------------
# Session ID helper
# ---------------------------------------------------------------------------


def build_session_id(user_id: str, domain: str) -> str:
    """Build a deterministic OpenClaw session identifier.

    OpenClaw session IDs must **not** contain colons. This function
    produces a stable ``app_{user_id}_{domain}`` identifier, replacing
    any forbidden characters.

    Parameters:
        user_id: Application-level user identifier.
        domain: Agent/domain identifier (e.g. ``"svc-concierge"``).

    Returns:
        Sanitised session id string.

    Examples::

        >>> build_session_id("usr_abc123", "svc-banking")
        'app_usr_abc123_svc-banking'
        >>> build_session_id("firebase:uid:xyz", "svc-visa")
        'app_firebase_uid_xyz_svc-visa'
    """
    # Replace colons and whitespace — keep alphanumerics, hyphens, underscores.
    safe_user = re.sub(r"[^a-zA-Z0-9_-]", "_", user_id)
    safe_domain = re.sub(r"[^a-zA-Z0-9_-]", "_", domain)
    session_id = f"app_{safe_user}_{safe_domain}"

    # Collapse consecutive underscores for tidiness.
    session_id = re.sub(r"_{2,}", "_", session_id)

    return session_id
