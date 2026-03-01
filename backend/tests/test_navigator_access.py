from __future__ import annotations

from pathlib import Path

import pytest

from routers import navigator


def _write_guide(path: Path, *, access: str, title: str, body: str) -> None:
    path.write_text(
        f"""---
access: {access}
---
# {title}

{body}
""",
        encoding="utf-8",
    )


@pytest.mark.asyncio
async def test_registered_access_full_for_registered_user(tmp_path, monkeypatch) -> None:
    guides_dir = tmp_path / "guides"
    guides_dir.mkdir(parents=True)

    _write_guide(
        guides_dir / "registered-guide.md",
        access="registered",
        title="Registered Guide",
        body="これは登録ユーザー向けの完全ガイドです。\n続きの説明です。",
    )

    monkeypatch.setitem(
        navigator.DOMAIN_CONFIG,
        "life",
        {
            "label": "Daily Life",
            "icon": "🌏",
            "status": "active",
            "guides_path": guides_dir,
        },
    )

    response = await navigator.get_guide("life", "registered-guide", tier="free")
    data = response["data"]

    assert data["access"] == "registered"
    assert data["locked"] is False
    assert "content" in data
    assert "完全ガイド" in data["content"]


@pytest.mark.asyncio
async def test_registered_access_locked_for_guest(tmp_path, monkeypatch) -> None:
    guides_dir = tmp_path / "guides"
    guides_dir.mkdir(parents=True)

    _write_guide(
        guides_dir / "registered-guide.md",
        access="registered",
        title="Registered Guide",
        body="ゲストには冒頭だけ見せる本文です。\n次の段落です。",
    )

    monkeypatch.setitem(
        navigator.DOMAIN_CONFIG,
        "life",
        {
            "label": "Daily Life",
            "icon": "🌏",
            "status": "active",
            "guides_path": guides_dir,
        },
    )

    response = await navigator.get_guide("life", "registered-guide", tier=None)
    data = response["data"]

    assert data["access"] == "registered"
    assert data["locked"] is True
    assert data["register_cta"] is True
    assert "excerpt" in data and data["excerpt"]
    assert "content" not in data


@pytest.mark.asyncio
async def test_premium_access_backward_compatibility(tmp_path, monkeypatch) -> None:
    guides_dir = tmp_path / "guides"
    guides_dir.mkdir(parents=True)

    _write_guide(
        guides_dir / "premium-guide.md",
        access="premium",
        title="Premium Guide",
        body="プレミアム向けの詳細な本文です。",
    )

    monkeypatch.setitem(
        navigator.DOMAIN_CONFIG,
        "life",
        {
            "label": "Daily Life",
            "icon": "🌏",
            "status": "active",
            "guides_path": guides_dir,
        },
    )

    registered = await navigator.get_guide("life", "premium-guide", tier="standard")
    guest = await navigator.get_guide("life", "premium-guide", tier=None)

    reg_data = registered["data"]
    guest_data = guest["data"]

    assert reg_data["access"] == "premium"
    assert reg_data["locked"] is False
    assert "content" in reg_data

    assert guest_data["access"] == "premium"
    assert guest_data["locked"] is True
    assert guest_data["register_cta"] is True
