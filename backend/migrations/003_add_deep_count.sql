-- Migration 003: Add deep_count column to daily_usage table
-- Tracks 深度級 (deep-level) chat usage separately from 概要級 (summary-level).
-- chat_count now tracks 概要級 usage; deep_count tracks 深度級 usage.
-- See: architecture/BUSINESS_RULES.md §2

ALTER TABLE daily_usage ADD COLUMN deep_count INTEGER NOT NULL DEFAULT 0;
