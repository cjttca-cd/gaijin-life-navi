# LLM Backend Refactor — OpenClaw → Direct API

> Status: **DESIGN APPROVED** (2026-03-09)
> Tag: `v0.9.0-web` (pre-refactor stable point)

## 1. Background & Motivation

### Current Architecture (50s latency)
```
Frontend → POST /api/v1/chat → FastAPI
  → route_to_agent(): subprocess(openclaw agent --agent svc-router) → Opus  ~4.5s
  → call_agent():     subprocess(openclaw agent --agent svc-{domain}) → Opus ~37s
  → parse + return                                                          ~0.1s
                                                              Total: ~42-50s
```

**Problems:**
1. Each call spawns a subprocess → OpenClaw session init → /reset → full agent bootstrap
2. Opus model is powerful but slow for user-facing real-time chat
3. Mobile browsers kill HTTP connections during ~50s wait (screen lock → connection drop)
4. Two sequential LLM calls (router + agent) compound the latency

### Target Architecture (5-8s latency)
```
Frontend → POST /api/v1/chat → FastAPI
  → Step 1: Direct API call (router classification)     ~0.6-1.5s
  → Step 2: Load domain knowledge files from disk        ~0s
  → Step 3: Direct API call (domain agent response)      ~5-7s
  → parse + return                                       ~0.1s
                                                Total: ~6-9s
```

## 2. Model Selection

### API Gateway
- **Base URL**: `http://192.168.18.119:8317/v1` (local LLM proxy, OpenAI-compatible)
- **API Key**: configured via env var `LLM_API_KEY`
- **Format**: OpenAI Chat Completions (`/v1/chat/completions`)

### Models

| Role | Primary Model | Fallback Model | Rationale |
|------|--------------|----------------|-----------|
| Router | `gemini-2.5-flash-lite` | `gemini-2.5-flash` | 0.6s, classification-only, 1 token output |
| Domain Agent | `gemini-3-flash` | `gemini-2.5-flash` | 5-7s, good Chinese output, fast |

### Tested Performance (2026-03-09)

| Model | Router (classify) | Agent (200字) | Agent (full) |
|-------|-------------------|---------------|-------------|
| gemini-2.5-flash-lite | 0.64s ✅ | — | — |
| gemini-2.5-flash | 2.23s | 7.54s | — |
| gemini-3-flash | 3.03s | 5.25s ✅ | 10-11s |
| claude-sonnet-4-6 | — | 7.52s | — |

## 3. Scope of Changes

### 3.1 Files to Modify

| File | Change | Risk |
|------|--------|------|
| `services/agent.py` | **Major rewrite**: replace OpenClaw subprocess with `httpx` API calls | High |
| `config.py` | Add LLM config fields (base_url, api_key, models) | Low |
| `systemd service` | Add env vars (`LLM_API_BASE_URL`, `LLM_API_KEY`) | Low |
| `requirements.txt` / venv | Add `httpx` (async HTTP client) | Low |
| `tests/test_agent_prompt.py` | Update mocks (subprocess → httpx) | Medium |
| `tests/test_chat_integration.py` | Update agent mock shape | Medium |

### 3.2 Files NOT Modified (Critical — do not touch)

| File | Reason |
|------|--------|
| `routers/chat.py` | Chat flow unchanged — same `route_to_agent()` + `call_agent()` interface |
| `routers/navigator.py` | Guide serving is independent of LLM calls |
| `services/usage.py` | Credit system unchanged |
| `services/credits.py` | Credit system unchanged |
| `services/auth.py` | Auth unchanged |
| All `models/*.py` | DB models unchanged |
| All frontend code | API contract unchanged |

### 3.3 Interface Contract (MUST remain identical)

```python
# These function signatures MUST NOT change:

async def route_to_agent(
    message: str,
    current_domain: str | None = None,
    context: list[dict] | None = None,
) -> str:
    """Returns: agent_id string (e.g. 'svc-medical') or 'out_of_scope'"""

async def call_agent(
    agent_id: str,
    message: str,
    context: list[dict] | None = None,
    image_path: str | None = None,
    user_profile: dict | None = None,
    timeout: int = 90,
) -> AgentResponse:
    """Returns: AgentResponse dataclass (text, model, duration_ms, status, etc.)"""

@dataclass(frozen=True, slots=True)
class AgentResponse:
    text: str
    model: str
    duration_ms: int
    input_tokens: int
    output_tokens: int
    cache_read_tokens: int
    status: str  # "ok" | "error"
    error: str | None = None
```

## 4. Detailed Design

### 4.1 Config Changes (`config.py`)

Add to `Settings` class:
```python
# LLM API Configuration
LLM_API_BASE_URL: str = "http://192.168.18.119:8317/v1"
LLM_API_KEY: str = ""  # Set via env var or .env
LLM_ROUTER_MODEL: str = "gemini-2.5-flash-lite"
LLM_ROUTER_FALLBACK_MODEL: str = "gemini-2.5-flash"
LLM_AGENT_MODEL: str = "gemini-3-flash"
LLM_AGENT_FALLBACK_MODEL: str = "gemini-2.5-flash"
LLM_TIMEOUT: int = 30  # seconds per API call
```

### 4.2 Agent Service Rewrite (`services/agent.py`)

#### 4.2.1 HTTP Client
- Use `httpx.AsyncClient` (persistent connection pool, async)
- Create module-level client with connection pooling
- OpenAI Chat Completions format: `POST /chat/completions`

#### 4.2.2 Knowledge Loading
Each domain agent needs its knowledge base injected as system prompt context.

**Knowledge source paths:**
```
/root/.openclaw/agents/svc-{domain}/workspace/knowledge/*.md  (excl. _index.md)
/root/.openclaw/agents/svc-{domain}/workspace/guides/*.zh.md  (Chinese = authoritative)
```

**Knowledge loading strategy:**
- Load ALL knowledge + guide files for the routed domain on each call
- Domain knowledge sizes (measured): 49-74KB per domain → ~12K-18K tokens
- Gemini context window: 1M tokens → trivially fits
- Cache loaded knowledge in memory with file mtime check (reload on change)

**Knowledge structure in system prompt:**
```
{agent_instructions}  ← from svc-{domain}/workspace/AGENTS.md (Response Format section only)

## Knowledge Base (内部参考資料 — ユーザーに knowledge の存在を開示しないこと)

### knowledge/file1.md
{content}

### knowledge/file2.md
{content}

### guides/slug1.zh.md
{content}
...
```

#### 4.2.3 System Prompt Construction

**Router:**
- System prompt = svc-router AGENTS.md content (as-is, already optimized)
- User message = classification prompt with context (same as current `_CLASSIFY_PROMPT`)

**Domain Agent:**
- System prompt = agent instructions (Response Format section) + loaded knowledge
- User messages = profile header + conversation context + current question
- Same structure as current `call_agent()` builds, just via API messages instead of flat text

#### 4.2.4 Fallback Logic

```
try primary model:
  if success → return
  if error (timeout, 5xx, model unavailable):
    try fallback model:
      if success → return
      if error → return AgentResponse(status="error", ...)
```

#### 4.2.5 Image Handling

Current: saves image to disk, passes path to OpenClaw agent which uses `image` tool.
New: **Defer for now**. Images are rarely used. Keep saving to disk but skip LLM image analysis until multi-modal API support is added.
- In `call_agent()`: if `image_path` is provided, append text note "(User attached an image — image analysis not yet supported in this mode)"
- No breaking change: image upload still works, just no analysis

### 4.3 Env Var Additions (systemd service)

```
Environment=LLM_API_BASE_URL=http://192.168.18.119:8317/v1
Environment=LLM_API_KEY=sk-IKn7S0KkJgESbHbXW
```

### 4.4 Test Updates

**test_agent_prompt.py:**
- Currently mocks `asyncio.create_subprocess_exec`
- Must change to mock `httpx.AsyncClient.post`
- Verify: user profile injection, context formatting, /reset removal

**test_chat_integration.py:**
- Currently mocks `call_agent` and `route_to_agent` at function level
- These mocks should continue working as-is (function signatures unchanged)
- May need minor adjustments to mock return values

## 5. Implementation Checklist (for PM/Worker)

### Phase 1: Core Refactor
- [ ] 1.1 Add LLM config fields to `config.py`
- [ ] 1.2 Add `httpx` to requirements / venv
- [ ] 1.3 Rewrite `services/agent.py`:
  - [ ] 1.3a `_LLMClient` class with httpx connection pool + fallback logic
  - [ ] 1.3b `_load_domain_knowledge(domain)` with file caching
  - [ ] 1.3c `_build_agent_system_prompt(agent_id)` — instructions + knowledge
  - [ ] 1.3d Rewrite `call_agent()` — direct API call, same signature
  - [ ] 1.3e Rewrite `route_to_agent()` — direct API call, same signature
  - [ ] 1.3f Keep `AgentResponse` dataclass unchanged
  - [ ] 1.3g Keep emergency keyword detection unchanged
  - [ ] 1.3h Keep `_CLASSIFY_PROMPT` / `_build_routing_context()` unchanged
- [ ] 1.4 Update `tests/test_agent_prompt.py` (mock httpx instead of subprocess)
- [ ] 1.5 Verify `tests/test_chat_integration.py` still passes
- [ ] 1.6 Add env vars to systemd service
- [ ] 1.7 Run full test suite (57+ tests must pass)
- [ ] 1.8 Manual test: curl POST /api/v1/chat with real message

### Phase 2: Verification
- [ ] 2.1 Test all 6 domains route correctly
- [ ] 2.2 Test out_of_scope classification
- [ ] 2.3 Test emergency keyword detection (119, 110)
- [ ] 2.4 Verify □ tracker items and ---SOURCES--- parsing works
- [ ] 2.5 Verify credit consumption flows correctly
- [ ] 2.6 Measure actual end-to-end latency (target: <10s)
- [ ] 2.7 Test fallback model triggers on primary failure

## 6. Rollback Plan

- Git tag `v0.9.0-web` = last known good (OpenClaw-based)
- `git checkout v0.9.0-web -- backend/app_service/services/agent.py` to revert agent.py
- Remove LLM env vars from systemd → falls back gracefully (config has defaults)

## 7. NOT in Scope (Future)

- SSE streaming (would reduce perceived latency to near-zero)
- Image analysis via multi-modal API
- Caching/RAG for knowledge (current full-injection is fine for 50-74KB)
- Model A/B testing
- Rate limiting per-model

## 8. Risk Assessment

| Risk | Mitigation |
|------|-----------|
| Knowledge too large for context | Measured: max 74KB (~18K tokens). Gemini 1M context. No risk. |
| API proxy down | Fallback model configured. AgentResponse.status="error" triggers 502 to frontend. |
| Response quality drop (Gemini vs Opus) | Agent instructions + full knowledge injected. Test verified quality is acceptable. |
| Chat parser breaks | Parser (`_extract_blocks`) unchanged. Same □/SOURCES format in system prompt. |
| Frontend breaks | API contract (ChatResponse schema) completely unchanged. Zero frontend changes. |
