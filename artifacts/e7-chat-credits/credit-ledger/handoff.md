# Credit Ledger — Handoff

## Intent
Replace the fixed `daily_usage.deep_count` based chat limit system with a flexible Credit Ledger (`chat_credits` table) that supports subscription credits, grants, purchases, and re-engagement.

## Non-goals
- Admin API for credit management (direct DB operations for now)
- Apple IAP / Google Play purchase flow (out of scope — only the credit row insertion mechanism is provided)
- Modifying `daily_usage` or `profiles` tables

## Status: ✅ Complete

### Phase 1 — Core
- [x] `ChatCredit` model with CHECK constraints
- [x] `credits.py` service (grant, consume, balance, re-engagement)
- [x] `usage.py` refactored to Credit Ledger
- [x] Alembic migration 005
- [x] REENGAGE_CONFIG in config.py

### Phase 2 — API + Frontend
- [x] `GET /api/v1/credits/balance` endpoint
- [x] Chat response extended with `credit_used_from` + `total_remaining`
- [x] `usage_counter.dart` updated for credit display
- [x] `chat_response.dart` updated with credit fields
- [x] l10n: `chatCreditsRemaining` key added to all 5 ARB files

### Phase 3 — Re-engagement
- [x] Auto-grant on exhaustion for free tier
- [x] Cooldown enforcement (30 days)
- [x] Tier eligibility check

### Phase 4 — Documentation
- [x] `DATA_MODEL.md` — chat_credits table definition
- [x] `BUSINESS_RULES.md` §2 — Credit Ledger flow
- [x] `API_DESIGN.md` — credits/balance + chat response extension

## Verification
```bash
cd /root/.openclaw/projects/gaijin-life-navi/backend
python3 -m pytest tests/ -v  # 34 passed

cd /root/.openclaw/projects/gaijin-life-navi/app
flutter analyze  # 0 new errors (5 pre-existing in navigator_providers.dart)
```

## Gaps / Next Steps
1. **Subscription monthly credit provisioning**: Need a trigger (webhook or cron) to INSERT subscription credits at billing cycle start
2. **IAP purchase flow**: When IAP is implemented, call `grant_credits(source='purchase')` after payment verification
3. **Migration script for production**: The 005 migration creates the table. A data migration script to convert existing `daily_usage` data to `chat_credits` rows should be run once during deployment
4. **Admin CLI/API**: For manual grant operations (campaign, compensation)
