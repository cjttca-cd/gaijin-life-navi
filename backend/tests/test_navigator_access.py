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
    # Ensure production mode for this test
    from config import settings
    monkeypatch.setattr(settings, 'TESTFLIGHT_MODE', False)
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
    # Ensure production mode for this test
    from config import settings
    monkeypatch.setattr(settings, 'TESTFLIGHT_MODE', False)
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


@pytest.mark.asyncio
async def test_tags_field_in_list_guides(tmp_path, monkeypatch) -> None:
    """Tags from frontmatter should appear in list_guides response."""
    guides_dir = tmp_path / "guides"
    guides_dir.mkdir(parents=True)

    (guides_dir / "tagged-guide.md").write_text(
        """---
access: free
tags:
  - banking
  - foreigner
  - account
---
# Tagged Guide

Some guide content.
""",
        encoding="utf-8",
    )

    (guides_dir / "no-tags-guide.md").write_text(
        """---
access: free
---
# No Tags Guide

Another guide.
""",
        encoding="utf-8",
    )

    monkeypatch.setitem(
        navigator.DOMAIN_CONFIG,
        "finance",
        {
            "label": "Finance & Banking",
            "icon": "💰",
            "status": "active",
            "guides_path": guides_dir,
        },
    )

    response = await navigator.list_guides("finance")
    guides = response["data"]["guides"]

    tagged = next(g for g in guides if g["slug"] == "tagged-guide")
    assert tagged["tags"] == ["banking", "foreigner", "account"]

    no_tags = next(g for g in guides if g["slug"] == "no-tags-guide")
    assert no_tags["tags"] == []


@pytest.mark.asyncio
async def test_tags_and_reading_time_in_get_guide(tmp_path, monkeypatch) -> None:
    """Tags and reading_time_min should appear in get_guide response."""
    guides_dir = tmp_path / "guides"
    guides_dir.mkdir(parents=True)

    # Create a guide with CJK content (>30% CJK chars)
    cjk_body = "日本語のテスト本文です。" * 100  # ~1200 CJK chars
    (guides_dir / "cjk-guide.md").write_text(
        f"""---
access: free
tags:
  - 銀行
  - 開設
---
# CJK Guide

{cjk_body}
""",
        encoding="utf-8",
    )

    monkeypatch.setitem(
        navigator.DOMAIN_CONFIG,
        "finance",
        {
            "label": "Finance & Banking",
            "icon": "💰",
            "status": "active",
            "guides_path": guides_dir,
        },
    )

    response = await navigator.get_guide("finance", "cjk-guide", tier="free")
    data = response["data"]

    assert data["tags"] == ["銀行", "開設"]
    assert isinstance(data["reading_time_min"], int)
    assert data["reading_time_min"] >= 1


@pytest.mark.asyncio
async def test_reading_time_latin_text(tmp_path, monkeypatch) -> None:
    """Reading time for Latin text uses word count / 200."""
    guides_dir = tmp_path / "guides"
    guides_dir.mkdir(parents=True)

    # Create a guide with Latin-only content
    latin_body = "word " * 400  # 400 words → 2 min
    (guides_dir / "latin-guide.md").write_text(
        f"""---
access: free
---
# Latin Guide

{latin_body}
""",
        encoding="utf-8",
    )

    monkeypatch.setitem(
        navigator.DOMAIN_CONFIG,
        "finance",
        {
            "label": "Finance & Banking",
            "icon": "💰",
            "status": "active",
            "guides_path": guides_dir,
        },
    )

    response = await navigator.get_guide("finance", "latin-guide", tier="free")
    data = response["data"]

    assert data["reading_time_min"] == 2  # 400 words // 200 = 2


@pytest.mark.asyncio
async def test_tags_in_locked_guide(tmp_path, monkeypatch) -> None:
    """Tags and reading_time_min should appear even in locked guide responses."""
    from config import settings
    monkeypatch.setattr(settings, 'TESTFLIGHT_MODE', False)

    guides_dir = tmp_path / "guides"
    guides_dir.mkdir(parents=True)

    (guides_dir / "premium-tagged.md").write_text(
        """---
access: premium
tags:
  - premium
  - special
---
# Premium Guide

Premium content here with enough text to read.
""",
        encoding="utf-8",
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

    response = await navigator.get_guide("life", "premium-tagged", tier=None)
    data = response["data"]

    assert data["locked"] is True
    assert data["tags"] == ["premium", "special"]
    assert isinstance(data["reading_time_min"], int)
    assert data["reading_time_min"] >= 1
