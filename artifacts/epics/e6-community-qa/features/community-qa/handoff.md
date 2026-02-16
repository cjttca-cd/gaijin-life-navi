# M3 Backend — Community Q&A + Subscription + AI Moderation Handoff

## Intent
Implement the complete M3 backend: Community Q&A CRUD with vote/best-answer, Subscription/Stripe integration with webhook processing, AI Moderation for community content, and Alembic migration for 4 new tables.

## Non-goals
- Flutter frontend integration (M3 frontend is a separate task)
- Real Stripe payment processing (mock mode only for now)
- Real Claude AI moderation (mock mode auto-approves)
- Admin moderation UI

## Status: ✅ Complete

All 12 acceptance criteria verified:

| # | Criterion | Status |
|---|-----------|--------|
| 1 | Alembic migration (4 tables) | ✅ |
| 2 | App Service import OK | ✅ |
| 3 | AI Service import OK | ✅ |
| 4 | Community endpoints (12 routes) | ✅ |
| 5 | Subscription endpoints (5 routes) | ✅ |
| 6 | Free user → 403 TIER_LIMIT_EXCEEDED | ✅ |
| 7 | AI moderation status=pending on create | ✅ |
| 8 | Vote toggle (true→false) | ✅ |
| 9 | Best answer (author-only, is_answered sync) | ✅ |
| 10 | Stripe webhook → subscription + tier update | ✅ |
| 11 | Cancel → cancel_at_period_end=true | ✅ |
| 12 | Flutter tests pass (73/73) | ✅ |

## Files Created/Modified

### New Files
- `infra/migrations/versions/004_create_m3_tables.py` — Migration for community_posts, community_replies, community_votes, subscriptions
- `backend/app_service/models/community_post.py` — CommunityPost SQLAlchemy model
- `backend/app_service/models/community_reply.py` — CommunityReply SQLAlchemy model
- `backend/app_service/models/community_vote.py` — CommunityVote SQLAlchemy model (physical delete)
- `backend/app_service/models/subscription.py` — Subscription SQLAlchemy model
- `backend/app_service/routers/community.py` — Community Q&A CRUD + vote + best answer
- `backend/app_service/routers/subscriptions.py` — Subscription plans, checkout, me, cancel, webhook
- `backend/ai_service/moderation/__init__.py` — AI moderation module init
- `backend/ai_service/moderation/moderator.py` — AI moderation engine (Claude-based, mock mode)
- `backend/ai_service/routers/moderation.py` — Internal moderation endpoint
- `scripts/test_m3_acceptance.py` — Acceptance test script

### Modified Files
- `backend/app_service/main.py` — Added community + subscriptions routers
- `backend/app_service/config.py` — Added Stripe + tier config
- `backend/app_service/models/__init__.py` — Added new model exports
- `backend/ai_service/main.py` — Added moderation router
- `infra/migrations/env.py` — Added new model imports for Alembic

## Verification

```bash
# 1. Migration
cd infra/migrations && alembic upgrade head

# 2-3. Import checks
cd backend/app_service && python -c "from main import app; from routers import community, subscriptions"
cd backend/ai_service && python -c "from main import app; from moderation import moderator"

# 6-11. Full acceptance test
python scripts/test_m3_acceptance.py

# 12. Flutter tests
cd app && flutter test
```

## Key Design Decisions

1. **Moderation is fire-and-forget**: App Service calls AI Service asynchronously. If the call fails, the post stays in `pending` status (visible only to author).
2. **Vote uses physical delete**: Per constraints, `community_votes` has no soft-delete. Toggle = INSERT/DELETE.
3. **Stripe mock mode**: When `STRIPE_SECRET_KEY` is empty, checkout returns mock URLs and webhook skips signature verification.
4. **Webhook uses its own DB session**: The webhook handler creates a fresh session from `async_session_factory` to avoid conflicts with FastAPI's dependency injection.
5. **Tier check is in the router**: `_check_premium()` reads `profiles.subscription_tier` and raises 403 for free users.

## Gaps / Next Steps
- Flutter frontend for Community Q&A screens
- Flutter frontend for Subscription management
- Real Stripe integration (set `STRIPE_SECRET_KEY`)
- Real Claude moderation (set `ANTHROPIC_API_KEY`)
- Admin moderation review UI for flagged content
- Push notification for moderation results
