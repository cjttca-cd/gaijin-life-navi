from __future__ import annotations

import asyncio

import pytest

from services.agent import call_agent


class _DummyProc:
    def __init__(self) -> None:
        self.returncode = 0
        self.pid = 9999

    async def communicate(self):
        stdout = (
            b'{"result":{"payloads":[{"text":"ok"}],'
            b'"meta":{"agentMeta":{"usage":{"input":10,"output":20,"cacheRead":0},"model":"stub-model"}}}}'
        )
        return stdout, b""

    def kill(self) -> None:
        return None

    async def wait(self) -> None:
        return None


async def _capture_full_message(monkeypatch, depth_level: str) -> str:
    captured: dict[str, tuple] = {}

    async def fake_create_subprocess_exec(*cmd, **kwargs):  # noqa: ANN001
        captured["cmd"] = cmd
        return _DummyProc()

    monkeypatch.setattr(asyncio, "create_subprocess_exec", fake_create_subprocess_exec)

    resp = await call_agent(
        agent_id="svc-life",
        message="口座開設について教えて",
        user_profile={
            "display_name": "Alice",
            "subscription_tier": "free",
            "nationality": "JP",
            "residence_status": "留学",
            "residence_region": "東京都",
            "preferred_language": "ja",
        },
        depth_level=depth_level,
    )

    assert resp.status == "ok"

    cmd = captured["cmd"]
    msg_idx = cmd.index("--message") + 1
    return str(cmd[msg_idx])


@pytest.mark.asyncio
async def test_prompt_contains_deep_annotation_and_profile_fields(monkeypatch) -> None:
    full_message = await _capture_full_message(monkeypatch, depth_level="deep")

    assert "回答深度: 深度級" in full_message
    assert "国籍: JP" in full_message
    assert "在留資格: 留学" in full_message
    assert "居住地域: 東京都" in full_message


@pytest.mark.asyncio
async def test_prompt_summary_strips_sensitive_profile_fields(monkeypatch) -> None:
    full_message = await _capture_full_message(monkeypatch, depth_level="summary")

    assert "回答深度: 概要級" in full_message
    assert "国籍: JP" not in full_message
    assert "在留資格: 留学" not in full_message
    assert "居住地域: 東京都" not in full_message
