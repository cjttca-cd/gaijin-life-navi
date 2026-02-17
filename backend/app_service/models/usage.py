"""Usage model — re-exports DailyUsage for usage-tracking concerns.

The ``DailyUsage`` model (models/daily_usage.py) already tracks per-user
daily chat_count and scan_count_monthly.  This module exists so that
``services/usage.py`` can import from a semantically clear location while
the underlying storage remains the single ``daily_usage`` table.

If a separate ``usage`` table is ever needed (e.g. pay-as-you-go balance),
define it here alongside the re-export.
"""

from models.daily_usage import DailyUsage

__all__ = ["DailyUsage"]
