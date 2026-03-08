"""Tests for _extract_blocks() — inline □ parser reform.

Validates the new inline □ extraction, SOURCES block handling,
and confirms deprecated TRACKER/ACTIONS block formats are no longer parsed.
"""
from __future__ import annotations

import sys
from pathlib import Path

# Ensure app_service is on path (same as conftest.py)
APP_SERVICE_DIR = Path(__file__).resolve().parents[1] / "app_service"
if str(APP_SERVICE_DIR) not in sys.path:
    sys.path.insert(0, str(APP_SERVICE_DIR))

from routers.chat import _extract_blocks  # noqa: E402


class TestInlineCheckboxExtraction:
    """Test case 1: □ lines in reply → tracker_items extracted, □ lines kept in reply."""

    def test_three_checkbox_items(self):
        text = (
            "Here's what you need to do after moving:\n\n"
            "□ Go to city hall to register your address\n"
            "□ Apply for health insurance\n"
            "□ Open a bank account\n\n"
            "Let me know if you need more details!"
        )
        reply, sources, actions, tracker_items = _extract_blocks(text)

        # 3 tracker items extracted
        assert len(tracker_items) == 3
        assert tracker_items[0]["title"] == "Go to city hall to register your address"
        assert tracker_items[1]["title"] == "Apply for health insurance"
        assert tracker_items[2]["title"] == "Open a bank account"

        # □ lines remain in reply
        assert "□ Go to city hall" in reply
        assert "□ Apply for health insurance" in reply
        assert "□ Open a bank account" in reply

        # Surrounding text preserved
        assert "Here's what you need to do" in reply
        assert "Let me know if you need more details!" in reply

        # actions always empty
        assert actions == []


class TestNoCheckboxItems:
    """Test case 2: No □ lines → tracker_items empty, reply unchanged."""

    def test_plain_text_no_checkboxes(self):
        text = (
            "Welcome to Japan! Here are some tips for settling in.\n\n"
            "First, you should find an apartment.\n"
            "Then, set up your utilities."
        )
        reply, sources, actions, tracker_items = _extract_blocks(text)

        assert tracker_items == []
        assert sources == []
        assert actions == []
        assert reply == text


class TestSourcesAndCheckboxMixed:
    """Test case 3: ---SOURCES--- + □ lines mixed → both extracted correctly."""

    def test_sources_removed_checkboxes_kept(self):
        text = (
            "Here's your checklist:\n\n"
            "□ Register at city hall\n"
            "□ Get health insurance\n\n"
            "For more info, see below.\n\n"
            "---SOURCES---\n"
            "- https://example.com/guide\n"
            "- title: City Hall | url: https://city.example.com\n"
        )
        reply, sources, actions, tracker_items = _extract_blocks(text)

        # tracker_items extracted
        assert len(tracker_items) == 2
        assert tracker_items[0]["title"] == "Register at city hall"

        # sources extracted
        assert len(sources) == 2
        assert sources[0]["url"] == "https://example.com/guide"

        # SOURCES block removed from reply
        assert "---SOURCES---" not in reply
        assert "https://example.com/guide" not in reply

        # □ lines kept in reply
        assert "□ Register at city hall" in reply
        assert "□ Get health insurance" in reply


class TestCheckboxWithDate:
    """Test case 4: □ line with parenthesised date → date field extracted."""

    def test_date_extraction(self):
        text = (
            "Your visa tasks:\n\n"
            "□ Submit renewal application (deadline 2025-06-15)\n"
            "□ Prepare documents\n"
        )
        reply, sources, actions, tracker_items = _extract_blocks(text)

        assert len(tracker_items) == 2
        # First item has date
        assert tracker_items[0]["date"] == "2025-06-15"
        assert "renewal application" in tracker_items[0]["title"]
        # Second item has no date
        assert "date" not in tracker_items[1]


class TestScatteredCheckboxes:
    """Test case 5: □ lines scattered throughout text → all extracted."""

    def test_non_consecutive_checkboxes(self):
        text = (
            "Step 1: Housing\n"
            "Find a place to live first.\n"
            "□ Search for apartments on Suumo\n\n"
            "Step 2: Registration\n"
            "You must register within 14 days.\n"
            "□ Go to ward office (within 2025-04-01)\n\n"
            "Step 3: Banking\n"
            "Open a bank account for salary.\n"
            "□ Visit a bank with your residence card\n"
        )
        reply, sources, actions, tracker_items = _extract_blocks(text)

        # All 3 scattered items extracted
        assert len(tracker_items) == 3
        assert tracker_items[0]["title"] == "Search for apartments on Suumo"
        assert tracker_items[1]["date"] == "2025-04-01"
        assert "bank" in tracker_items[2]["title"].lower()

        # All text preserved in reply (including □ lines)
        assert "Step 1: Housing" in reply
        assert "Step 2: Registration" in reply
        assert "Step 3: Banking" in reply
        assert "□ Search for apartments" in reply
        assert "□ Go to ward office" in reply
        assert "□ Visit a bank" in reply


class TestOrphanMarkersRemoved:
    """Orphan ---TRACKER--- / ---ACTIONS--- markers are cleaned from reply."""

    def test_orphan_markers_stripped(self):
        text = (
            "Here is your answer.\n"
            "---TRACKER---\n"
            "---ACTIONS---\n"
            "Some trailing text."
        )
        reply, sources, actions, tracker_items = _extract_blocks(text)

        assert "---TRACKER---" not in reply
        assert "---ACTIONS---" not in reply
        assert "Here is your answer." in reply
        assert "Some trailing text." in reply


class TestDeprecatedBlockFormatIgnored:
    """Old ---TRACKER--- block items are NOT parsed as tracker_items (block format deprecated)."""

    def test_old_tracker_block_not_parsed(self):
        text = (
            "Here is your answer.\n\n"
            "---TRACKER---\n"
            "□ Old format item\n"
            "---SOURCES---\n"
            "- https://example.com\n"
        )
        reply, sources, actions, tracker_items = _extract_blocks(text)

        # □ line inside old TRACKER block IS still picked up by inline scan
        # (it's still a □ line in the text), but the ---TRACKER--- marker is removed
        assert len(tracker_items) == 1
        assert tracker_items[0]["title"] == "Old format item"
        assert "---TRACKER---" not in reply
        assert sources[0]["url"] == "https://example.com"
