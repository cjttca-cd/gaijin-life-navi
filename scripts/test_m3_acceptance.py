"""M3 Acceptance Test Script — tests criteria 6-11.

Run: cd backend/app_service && python ../../scripts/test_m3_acceptance.py
"""

import asyncio
import json
import sys
import os

# Ensure app_service is on sys.path FIRST
_project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
_app_service_dir = os.path.join(_project_root, "backend", "app_service")
sys.path.insert(0, _app_service_dir)
os.chdir(_app_service_dir)

from httpx import AsyncClient, ASGITransport

from main import app as app_service_app

# Headers for mock auth
FREE_USER_HEADERS = {"Authorization": "Bearer free_user:free@test.com"}
PREMIUM_USER_HEADERS = {"Authorization": "Bearer premium_user:premium@test.com"}


async def setup_users(client: AsyncClient):
    """Create test profiles in the DB."""
    from database import async_session_factory
    from models.profile import Profile
    from datetime import datetime, timezone

    async with async_session_factory() as db:
        now = datetime.now(timezone.utc)

        # Free user
        free_profile = await db.get(Profile, "free_user")
        if not free_profile:
            free_profile = Profile(
                id="free_user",
                email="free@test.com",
                display_name="Free User",
                subscription_tier="free",
                preferred_language="en",
                created_at=now,
                updated_at=now,
            )
            db.add(free_profile)

        # Premium user
        premium_profile = await db.get(Profile, "premium_user")
        if not premium_profile:
            premium_profile = Profile(
                id="premium_user",
                email="premium@test.com",
                display_name="Premium User",
                subscription_tier="premium",
                preferred_language="en",
                created_at=now,
                updated_at=now,
            )
            db.add(premium_profile)

        await db.commit()


async def test_6_free_user_post_blocked(client: AsyncClient):
    """#6: Free user POST community/posts → 403 TIER_LIMIT_EXCEEDED."""
    print("\n=== Test #6: Free user cannot create community post ===")
    resp = await client.post(
        "/api/v1/community/posts",
        json={
            "channel": "en",
            "category": "banking",
            "title": "How to open a bank account?",
            "content": "I just arrived in Japan and need help opening a bank account.",
        },
        headers=FREE_USER_HEADERS,
    )
    assert resp.status_code == 403, f"Expected 403, got {resp.status_code}: {resp.text}"
    body = resp.json()
    assert body["detail"]["error"]["code"] == "TIER_LIMIT_EXCEEDED", f"Wrong error code: {body}"
    print("✅ PASS: Free user blocked with TIER_LIMIT_EXCEEDED")


async def test_7_ai_moderation(client: AsyncClient):
    """#7: Post creation sets ai_moderation_status='pending', mock moderation returns 'approved'."""
    print("\n=== Test #7: AI moderation on post creation ===")
    resp = await client.post(
        "/api/v1/community/posts",
        json={
            "channel": "en",
            "category": "banking",
            "title": "Best bank for foreigners?",
            "content": "I'm looking for a bank that supports English and has low fees.",
        },
        headers=PREMIUM_USER_HEADERS,
    )
    assert resp.status_code == 201, f"Expected 201, got {resp.status_code}: {resp.text}"
    body = resp.json()
    post_data = body["data"]
    # Note: moderation is async — it may still be pending or already approved depending on AI service
    assert post_data["ai_moderation_status"] in ("pending", "approved"), \
        f"Expected pending/approved, got {post_data['ai_moderation_status']}"
    print(f"✅ PASS: Post created with ai_moderation_status='{post_data['ai_moderation_status']}'")
    return post_data["id"]


async def test_8_vote_toggle(client: AsyncClient, post_id: str):
    """#8: POST vote → voted:true, POST again → voted:false."""
    print("\n=== Test #8: Vote toggle ===")

    # First vote
    resp1 = await client.post(
        f"/api/v1/community/posts/{post_id}/vote",
        headers=PREMIUM_USER_HEADERS,
    )
    assert resp1.status_code == 200, f"Expected 200, got {resp1.status_code}: {resp1.text}"
    body1 = resp1.json()
    assert body1["data"]["voted"] is True, f"Expected voted=true: {body1}"
    assert body1["data"]["upvote_count"] == 1, f"Expected upvote_count=1: {body1}"
    print(f"  Vote 1: voted={body1['data']['voted']}, count={body1['data']['upvote_count']}")

    # Second vote (toggle off)
    resp2 = await client.post(
        f"/api/v1/community/posts/{post_id}/vote",
        headers=PREMIUM_USER_HEADERS,
    )
    assert resp2.status_code == 200, f"Expected 200, got {resp2.status_code}: {resp2.text}"
    body2 = resp2.json()
    assert body2["data"]["voted"] is False, f"Expected voted=false: {body2}"
    assert body2["data"]["upvote_count"] == 0, f"Expected upvote_count=0: {body2}"
    print(f"  Vote 2: voted={body2['data']['voted']}, count={body2['data']['upvote_count']}")
    print("✅ PASS: Vote toggle works correctly")


async def test_9_best_answer(client: AsyncClient, post_id: str):
    """#9: Only post author can set best answer, community_posts.is_answered updated."""
    print("\n=== Test #9: Best answer ===")

    # Create a reply (premium user is the post author)
    resp_reply = await client.post(
        f"/api/v1/community/posts/{post_id}/replies",
        json={"content": "I recommend Shinsei Bank — great for foreigners!"},
        headers=PREMIUM_USER_HEADERS,
    )
    assert resp_reply.status_code == 201, f"Expected 201, got {resp_reply.status_code}: {resp_reply.text}"
    reply_id = resp_reply.json()["data"]["id"]
    print(f"  Created reply: {reply_id}")

    # Free user tries to set best answer → should fail (post author check)
    resp_fail = await client.post(
        f"/api/v1/community/replies/{reply_id}/best-answer",
        headers=FREE_USER_HEADERS,
    )
    assert resp_fail.status_code == 403, f"Expected 403, got {resp_fail.status_code}: {resp_fail.text}"
    print("  Non-author blocked from setting best answer ✓")

    # Post author sets best answer
    resp_ba = await client.post(
        f"/api/v1/community/replies/{reply_id}/best-answer",
        headers=PREMIUM_USER_HEADERS,
    )
    assert resp_ba.status_code == 200, f"Expected 200, got {resp_ba.status_code}: {resp_ba.text}"
    ba_data = resp_ba.json()["data"]
    assert ba_data["is_best_answer"] is True, f"Expected is_best_answer=true: {ba_data}"
    assert ba_data["post_is_answered"] is True, f"Expected post_is_answered=true: {ba_data}"
    print(f"  Best answer set: is_best_answer={ba_data['is_best_answer']}, post_is_answered={ba_data['post_is_answered']}")
    print("✅ PASS: Best answer works correctly")


async def test_10_stripe_webhook_checkout(client: AsyncClient):
    """#10: Stripe webhook mock — checkout.session.completed creates subscription + updates profile tier."""
    print("\n=== Test #10: Stripe webhook checkout.session.completed ===")

    # Create a third test user
    from database import async_session_factory
    from models.profile import Profile
    from datetime import datetime, timezone

    async with async_session_factory() as db:
        now = datetime.now(timezone.utc)
        webhook_user = await db.get(Profile, "webhook_user")
        if not webhook_user:
            webhook_user = Profile(
                id="webhook_user",
                email="webhook@test.com",
                display_name="Webhook User",
                subscription_tier="free",
                preferred_language="en",
                created_at=now,
                updated_at=now,
            )
            db.add(webhook_user)
            await db.commit()

    # Send mock webhook event
    webhook_event = {
        "type": "checkout.session.completed",
        "data": {
            "object": {
                "customer": "cus_test_123",
                "subscription": "sub_test_123",
                "metadata": {
                    "firebase_uid": "webhook_user",
                    "plan_id": "premium_monthly",
                },
            }
        },
    }
    resp = await client.post(
        "/api/v1/subscriptions/webhook",
        content=json.dumps(webhook_event),
        headers={"Content-Type": "application/json"},
    )
    assert resp.status_code == 200, f"Expected 200, got {resp.status_code}: {resp.text}"
    print("  Webhook processed successfully")

    # Verify subscription was created and profile updated
    async with async_session_factory() as db:
        from sqlalchemy import select
        from models.subscription import Subscription

        sub_stmt = select(Subscription).where(Subscription.user_id == "webhook_user")
        sub_result = await db.execute(sub_stmt)
        sub = sub_result.scalars().first()
        assert sub is not None, "Subscription not created!"
        assert sub.status == "active", f"Expected status=active, got {sub.status}"
        assert sub.tier == "premium", f"Expected tier=premium, got {sub.tier}"
        print(f"  Subscription created: tier={sub.tier}, status={sub.status}")

        profile = await db.get(Profile, "webhook_user")
        assert profile.subscription_tier == "premium", \
            f"Expected profile tier=premium, got {profile.subscription_tier}"
        print(f"  Profile tier updated: {profile.subscription_tier}")

    print("✅ PASS: Stripe webhook creates subscription and updates profile tier")


async def test_11_subscription_cancel(client: AsyncClient):
    """#11: Cancel → sets cancel_at_period_end=true."""
    print("\n=== Test #11: Subscription cancel ===")

    WEBHOOK_USER_HEADERS = {"Authorization": "Bearer webhook_user:webhook@test.com"}

    resp = await client.post(
        "/api/v1/subscriptions/cancel",
        headers=WEBHOOK_USER_HEADERS,
    )
    assert resp.status_code == 200, f"Expected 200, got {resp.status_code}: {resp.text}"
    body = resp.json()
    assert body["data"]["cancel_at_period_end"] is True, f"Expected cancel_at_period_end=true: {body}"
    print(f"  Cancel result: cancel_at_period_end={body['data']['cancel_at_period_end']}")
    print("✅ PASS: Subscription cancel sets cancel_at_period_end=true")


async def main():
    print("=" * 60)
    print("M3 Acceptance Tests (Criteria #6–#11)")
    print("=" * 60)

    transport = ASGITransport(app=app_service_app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        await setup_users(client)

        # Test #6
        await test_6_free_user_post_blocked(client)

        # Test #7
        post_id = await test_7_ai_moderation(client)

        # Test #8
        await test_8_vote_toggle(client, post_id)

        # Test #9
        await test_9_best_answer(client, post_id)

        # Test #10
        await test_10_stripe_webhook_checkout(client)

        # Test #11
        await test_11_subscription_cancel(client)

    print("\n" + "=" * 60)
    print("🎉 ALL M3 ACCEPTANCE TESTS PASSED!")
    print("=" * 60)


if __name__ == "__main__":
    asyncio.run(main())
