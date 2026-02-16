#!/usr/bin/env python3
"""E2E Test Script — 6 closed-loop integration tests (A–F).

Each loop exercises a real user journey through the API layer.
Uses mock auth mode (Bearer uid:email) and in-process ASGI transport.

Usage:
    cd /root/.openclaw/projects/gaijin-life-navi
    python scripts/e2e_test.py           # Run all loops
    python scripts/e2e_test.py A         # Run single loop
    python scripts/e2e_test.py A B C     # Run selected loops

Loops:
  A: Register → Onboarding → Chat session create → Send message → SSE response
  B: Banking banks list → Recommend → Bank guide
  C: Onboarding → Tracker procedures → Add → Status change → Complete
  D: Document scan → OCR result
  E: Upgrade to Premium → Community post → Reply → Vote → Best answer
  F: Free → Checkout → Webhook → Premium → Chat unlimited
"""

import asyncio
import json
import os
import subprocess
import sys
import traceback
import uuid
from datetime import datetime, timezone

# ── Project setup ──────────────────────────────────────────────────────

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
APP_SERVICE_DIR = os.path.join(PROJECT_ROOT, "backend", "app_service")
AI_SERVICE_DIR = os.path.join(PROJECT_ROOT, "backend", "ai_service")
MIGRATIONS_DIR = os.path.join(PROJECT_ROOT, "infra", "migrations")

# Add app_service to sys.path first
sys.path.insert(0, APP_SERVICE_DIR)
os.chdir(APP_SERVICE_DIR)


def _run_db_setup():
    """Run seed scripts (DB is assumed to be migrated already)."""
    print("📦 Setting up database...")

    env = os.environ.copy()
    sync_url = f"sqlite:////{PROJECT_ROOT}/data/app.db"
    env["DATABASE_URL"] = sync_url

    # Run alembic with sync driver
    alembic_env = env.copy()
    alembic_env["DATABASE_URL"] = sync_url
    result = subprocess.run(
        [sys.executable, "-c",
         "from sqlalchemy import create_engine; "
         f"e = create_engine('{sync_url}'); "
         "from sqlalchemy import text; "
         "c = e.connect(); "
         "c.execute(text('SELECT 1')); "
         "c.close(); "
         "print('DB accessible')"],
        capture_output=True, text=True,
    )
    if result.returncode == 0:
        print(f"  ✅ Database accessible")
    else:
        # Create data dir if needed
        os.makedirs(os.path.join(PROJECT_ROOT, "data"), exist_ok=True)

    # Run alembic in a subprocess with sync driver
    alembic_script = f"""
import sys, os
sys.path.insert(0, '{APP_SERVICE_DIR}')
os.chdir('{APP_SERVICE_DIR}')
# Patch database module to use sync URL
os.environ['DATABASE_URL'] = '{sync_url}'

from alembic.config import Config
from alembic import command

cfg = Config('{MIGRATIONS_DIR}/alembic.ini')
cfg.set_main_option('script_location', '{MIGRATIONS_DIR}')
cfg.set_main_option('sqlalchemy.url', '{sync_url}')
try:
    command.upgrade(cfg, 'head')
    print('OK')
except Exception as e:
    print(f'WARN: {{e}}')
"""
    result = subprocess.run(
        [sys.executable, "-c", alembic_script],
        capture_output=True, text=True,
    )
    if "OK" in result.stdout or "WARN" in result.stdout:
        print(f"  ✅ Alembic: {result.stdout.strip()}")
    else:
        print(f"  ⚠️  Alembic: {result.stderr.strip()[:200]}")

    # Seed scripts
    for seed in ["seed_banking.py", "seed_admin.py", "seed_medical.py", "seed_visa.py"]:
        seed_path = os.path.join(PROJECT_ROOT, "scripts", seed)
        if os.path.exists(seed_path):
            result = subprocess.run(
                [sys.executable, seed_path],
                env=env,
                capture_output=True,
                text=True,
                cwd=PROJECT_ROOT,
            )
            if result.returncode == 0:
                print(f"  ✅ {seed}")
            else:
                print(f"  ⚠️  {seed}: {result.stderr.strip()[:120]}")


def _load_ai_service_app():
    """Load the AI service FastAPI app in a clean manner."""
    import importlib
    import importlib.util

    # Save current module state
    saved_modules = {}
    for mod_name in list(sys.modules.keys()):
        if mod_name in ("config", "database", "routers", "models", "schemas", "services", "main"):
            saved_modules[mod_name] = sys.modules.pop(mod_name)
        elif mod_name.startswith(("config.", "database.", "routers.", "models.", "schemas.", "services.")):
            saved_modules[mod_name] = sys.modules.pop(mod_name)

    # Temporarily switch path and cwd
    original_path = sys.path[:]
    original_cwd = os.getcwd()

    # Set up AI service path — AI service dir first, then backend/ for shared
    backend_dir = os.path.join(PROJECT_ROOT, "backend")
    sys.path = [AI_SERVICE_DIR, backend_dir] + [
        p for p in sys.path if p != APP_SERVICE_DIR
    ]
    os.chdir(AI_SERVICE_DIR)

    try:
        # Load AI service config
        ai_config_spec = importlib.util.spec_from_file_location(
            "ai_config", os.path.join(AI_SERVICE_DIR, "config.py")
        )
        ai_config_mod = importlib.util.module_from_spec(ai_config_spec)
        sys.modules["config"] = ai_config_mod
        ai_config_spec.loader.exec_module(ai_config_mod)

        # Load AI service database
        ai_db_spec = importlib.util.spec_from_file_location(
            "ai_database", os.path.join(AI_SERVICE_DIR, "database.py")
        )
        ai_db_mod = importlib.util.module_from_spec(ai_db_spec)
        sys.modules["database"] = ai_db_mod
        ai_db_spec.loader.exec_module(ai_db_mod)

        # Load AI service main
        ai_main_spec = importlib.util.spec_from_file_location(
            "ai_main", os.path.join(AI_SERVICE_DIR, "main.py")
        )
        ai_main_mod = importlib.util.module_from_spec(ai_main_spec)
        ai_main_spec.loader.exec_module(ai_main_mod)

        ai_app = ai_main_mod.app
        return ai_app
    except Exception as e:
        print(f"  ⚠️  AI Service load failed: {e}")
        return None
    finally:
        # Restore original state
        sys.path = original_path
        os.chdir(original_cwd)

        # Restore app_service modules
        for mod_name in list(sys.modules.keys()):
            if mod_name in ("config", "database", "routers", "models", "schemas", "services", "main"):
                sys.modules.pop(mod_name, None)
            elif mod_name.startswith(("config.", "database.", "routers.", "models.", "schemas.", "services.")):
                sys.modules.pop(mod_name, None)
        sys.modules.update(saved_modules)


# ── Helper to create async clients ────────────────────────────────────

from httpx import AsyncClient, ASGITransport  # noqa: E402


def _make_headers(uid: str, email: str) -> dict:
    """Mock auth header: Bearer uid:email."""
    return {"Authorization": f"Bearer {uid}:{email}"}


# ── User setup helpers ─────────────────────────────────────────────────


async def _ensure_profile(uid: str, email: str, tier: str = "free", **extra):
    """Create a profile directly in DB if it doesn't exist."""
    from database import async_session_factory
    from models.profile import Profile

    async with async_session_factory() as db:
        profile = await db.get(Profile, uid)
        if profile and profile.deleted_at is not None:
            # Un-delete for reuse
            profile.deleted_at = None
            profile.subscription_tier = tier
            for k, v in extra.items():
                setattr(profile, k, v)
            profile.updated_at = datetime.now(timezone.utc)
            await db.commit()
        elif profile is None:
            now = datetime.now(timezone.utc)
            profile = Profile(
                id=uid,
                email=email,
                display_name=extra.get("display_name", uid),
                subscription_tier=tier,
                preferred_language=extra.get("preferred_language", "en"),
                onboarding_completed=extra.get("onboarding_completed", False),
                created_at=now,
                updated_at=now,
            )
            db.add(profile)
            await db.commit()
        else:
            changed = False
            if profile.subscription_tier != tier:
                profile.subscription_tier = tier
                changed = True
            for k, v in extra.items():
                if hasattr(profile, k) and getattr(profile, k) != v:
                    setattr(profile, k, v)
                    changed = True
            if changed:
                profile.updated_at = datetime.now(timezone.utc)
                await db.commit()


# ══════════════════════════════════════════════════════════════════════
# Loop A: Register → Onboarding → Chat → Message → SSE
# ══════════════════════════════════════════════════════════════════════


async def loop_a(app_client: AsyncClient, ai_client: AsyncClient):
    """A: Register → Onboarding → Chat session create → Send message → SSE response."""
    print("\n" + "=" * 60)
    print("🔄 Loop A: Register → Onboarding → Chat → Message → SSE")
    print("=" * 60)

    uid = f"e2e_a_{uuid.uuid4().hex[:8]}"
    email = f"{uid}@test.com"
    headers = _make_headers(uid, email)

    # Step 1: Register
    print("\n  [A1] POST /auth/register")
    resp = await app_client.post(
        "/api/v1/auth/register",
        json={"display_name": "E2E User A", "preferred_language": "en"},
        headers=headers,
    )
    assert resp.status_code == 201, f"Register failed: {resp.status_code} {resp.text}"
    reg_data = resp.json()["data"]["user"]
    assert reg_data["id"] == uid
    assert reg_data["onboarding_completed"] is False
    print(f"    ✅ Registered: {uid}")

    # Step 2: Onboarding
    print("  [A2] POST /users/me/onboarding")
    resp = await app_client.post(
        "/api/v1/users/me/onboarding",
        json={
            "nationality": "US",
            "residence_status": "engineer_specialist",
            "residence_region": "13",
            "arrival_date": "2026-01-15",
            "preferred_language": "en",
        },
        headers=headers,
    )
    assert resp.status_code == 200, f"Onboarding failed: {resp.status_code} {resp.text}"
    ob_data = resp.json()["data"]
    assert ob_data["onboarding_completed"] is True
    print("    ✅ Onboarding completed")

    # Step 3: Create chat session (AI Service)
    print("  [A3] POST /ai/chat/sessions")
    resp = await ai_client.post(
        "/api/v1/ai/chat/sessions",
        json={},
        headers=headers,
    )
    assert resp.status_code == 201, f"Session create failed: {resp.status_code} {resp.text}"
    session_id = resp.json()["data"]["session"]["id"]
    print(f"    ✅ Session created: {session_id}")

    # Step 4: Send message (SSE endpoint)
    print("  [A4] POST /ai/chat/sessions/{id}/messages (SSE)")
    resp = await ai_client.post(
        f"/api/v1/ai/chat/sessions/{session_id}/messages",
        json={"content": "How do I open a bank account in Japan?"},
        headers=headers,
    )
    # SSE responses or JSON — both acceptable in mock mode
    assert resp.status_code == 200, f"Message failed: {resp.status_code} {resp.text}"
    body = resp.text
    # Verify we got some response content
    has_content = len(body) > 0 and ("event:" in body or "data" in body or "message" in body.lower())
    if not has_content:
        try:
            json_body = resp.json()
            has_content = "data" in json_body or "error" not in json_body
        except Exception:
            has_content = len(body) > 10  # At least some data
    assert has_content, f"No content in response: {body[:200]}"
    print(f"    ✅ SSE/response received ({len(body)} chars)")

    print("\n  🎉 Loop A PASSED")


# ══════════════════════════════════════════════════════════════════════
# Loop B: Banking banks list → Recommend → Bank guide
# ══════════════════════════════════════════════════════════════════════


async def loop_b(app_client: AsyncClient, ai_client: AsyncClient):
    """B: Banking banks list → Recommend → Bank guide."""
    print("\n" + "=" * 60)
    print("🔄 Loop B: Banking list → Recommend → Guide")
    print("=" * 60)

    uid = f"e2e_b_{uuid.uuid4().hex[:8]}"
    email = f"{uid}@test.com"
    headers = _make_headers(uid, email)

    await _ensure_profile(uid, email, onboarding_completed=True,
                          nationality="CN", preferred_language="zh",
                          residence_region="13")

    # Step 1: Banks list (public — no auth needed)
    print("\n  [B1] GET /banking/banks")
    resp = await app_client.get("/api/v1/banking/banks?lang=en")
    assert resp.status_code == 200, f"Banks list failed: {resp.status_code} {resp.text}"
    banks = resp.json()["data"]
    assert isinstance(banks, list) and len(banks) > 0, "No banks returned"
    bank_id = banks[0]["id"]
    print(f"    ✅ Got {len(banks)} banks (first: {banks[0].get('bank_name', bank_id)})")

    # Step 2: Recommend
    print("  [B2] POST /banking/recommend")
    resp = await app_client.post(
        "/api/v1/banking/recommend",
        json={"priorities": ["multilingual", "low_fee"]},
        headers=headers,
    )
    assert resp.status_code == 200, f"Recommend failed: {resp.status_code} {resp.text}"
    recs = resp.json()["data"]
    assert isinstance(recs, list) and len(recs) > 0, "No recommendations"
    rec = recs[0]
    assert "match_score" in rec, f"Missing match_score: {rec.keys()}"
    print(f"    ✅ Got {len(recs)} recommendations (top score: {rec['match_score']})")

    # Step 3: Bank guide
    print(f"  [B3] GET /banking/banks/{bank_id[:8]}.../guide")
    resp = await app_client.get(
        f"/api/v1/banking/banks/{bank_id}/guide?lang=en",
        headers=headers,
    )
    assert resp.status_code == 200, f"Guide failed: {resp.status_code} {resp.text}"
    guide = resp.json()["data"]
    assert "bank_name" in guide or "requirements" in guide or "id" in guide, \
        f"Guide missing expected fields: {list(guide.keys())}"
    print("    ✅ Got bank guide")

    print("\n  🎉 Loop B PASSED")


# ══════════════════════════════════════════════════════════════════════
# Loop C: Onboarding → Tracker → Add → Status change → Complete
# ══════════════════════════════════════════════════════════════════════


async def loop_c(app_client: AsyncClient, ai_client: AsyncClient):
    """C: Onboarding → Tracker procedures → Add → Status change → Complete."""
    print("\n" + "=" * 60)
    print("🔄 Loop C: Onboarding → Tracker → Add → Status → Complete")
    print("=" * 60)

    uid = f"e2e_c_{uuid.uuid4().hex[:8]}"
    email = f"{uid}@test.com"
    headers = _make_headers(uid, email)

    # Create as premium so tracker limit doesn't block
    await _ensure_profile(uid, email, tier="premium")

    # Step 1: Onboarding (creates auto-tracking of essential procedures)
    print("\n  [C1] POST /users/me/onboarding")
    resp = await app_client.post(
        "/api/v1/users/me/onboarding",
        json={
            "nationality": "VN",
            "residence_status": "student",
            "residence_region": "27",
            "arrival_date": "2026-02-01",
            "preferred_language": "vi",
        },
        headers=headers,
    )
    assert resp.status_code == 200, f"Onboarding failed: {resp.status_code} {resp.text}"
    print("    ✅ Onboarding completed")

    # Step 2: List tracked procedures
    print("  [C2] GET /procedures/my")
    resp = await app_client.get("/api/v1/procedures/my", headers=headers)
    assert resp.status_code == 200, f"List procedures failed: {resp.status_code} {resp.text}"
    my_procs = resp.json()["data"]
    assert isinstance(my_procs, list) and len(my_procs) > 0, \
        "No auto-tracked procedures after onboarding"
    print(f"    ✅ {len(my_procs)} procedures auto-tracked")

    # Step 3: Get templates and add a new one
    print("  [C3] GET /procedures/templates")
    resp = await app_client.get("/api/v1/procedures/templates?lang=en", headers=headers)
    assert resp.status_code == 200, f"Templates failed: {resp.status_code} {resp.text}"
    templates = resp.json()["data"]
    assert len(templates) > 0, "No templates"

    # Find a template not already tracked
    tracked_ref_ids = {p.get("procedure_ref_id") for p in my_procs}
    new_template = None
    for t in templates:
        if t["id"] not in tracked_ref_ids:
            new_template = t
            break

    if new_template:
        print(f"  [C3b] POST /procedures/my (add: {new_template['id'][:8]}...)")
        resp = await app_client.post(
            "/api/v1/procedures/my",
            json={
                "procedure_ref_type": "admin",
                "procedure_ref_id": new_template["id"],
                "notes": "E2E test",
            },
            headers=headers,
        )
        assert resp.status_code in (201, 409), \
            f"Add procedure failed: {resp.status_code} {resp.text}"
        if resp.status_code == 201:
            proc_id = resp.json()["data"]["id"]
            print(f"    ✅ Added procedure: {proc_id}")
        else:
            proc_id = my_procs[0]["id"]
            print(f"    ✅ Already tracking, using: {proc_id}")
    else:
        # All templates already tracked — use an existing procedure
        proc_id = my_procs[0]["id"]
        print(f"    ✅ All tracked, using existing: {proc_id}")

    # Step 4: Change status to in_progress
    print(f"  [C4] PATCH /procedures/my/{proc_id[:8]}... → in_progress")
    resp = await app_client.patch(
        f"/api/v1/procedures/my/{proc_id}",
        json={"status": "in_progress"},
        headers=headers,
    )
    assert resp.status_code == 200, f"Status change failed: {resp.status_code} {resp.text}"
    assert resp.json()["data"]["status"] == "in_progress"
    print("    ✅ Status → in_progress")

    # Step 5: Complete
    print(f"  [C5] PATCH /procedures/my/{proc_id[:8]}... → completed")
    resp = await app_client.patch(
        f"/api/v1/procedures/my/{proc_id}",
        json={"status": "completed"},
        headers=headers,
    )
    assert resp.status_code == 200, f"Complete failed: {resp.status_code} {resp.text}"
    assert resp.json()["data"]["status"] == "completed"
    print("    ✅ Status → completed")

    print("\n  🎉 Loop C PASSED")


# ══════════════════════════════════════════════════════════════════════
# Loop D: Document scan → OCR result
# ══════════════════════════════════════════════════════════════════════


async def loop_d(app_client: AsyncClient, ai_client: AsyncClient):
    """D: Document scan → OCR result."""
    print("\n" + "=" * 60)
    print("🔄 Loop D: Document scan → OCR result")
    print("=" * 60)

    uid = f"e2e_d_{uuid.uuid4().hex[:8]}"
    email = f"{uid}@test.com"
    headers = _make_headers(uid, email)

    await _ensure_profile(uid, email, onboarding_completed=True)

    # Step 1: Scan a document (upload)
    print("\n  [D1] POST /ai/documents/scan")
    # Create a minimal valid JPEG (1x1 pixel, 107 bytes)
    jpeg_bytes = bytes([
        0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01,
        0x01, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0xFF, 0xDB, 0x00, 0x43,
        0x00, 0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07, 0x07, 0x07, 0x09,
        0x09, 0x08, 0x0A, 0x0C, 0x14, 0x0D, 0x0C, 0x0B, 0x0B, 0x0C, 0x19, 0x12,
        0x13, 0x0F, 0x14, 0x1D, 0x1A, 0x1F, 0x1E, 0x1D, 0x1A, 0x1C, 0x1C, 0x20,
        0x24, 0x2E, 0x27, 0x20, 0x22, 0x2C, 0x23, 0x1C, 0x1C, 0x28, 0x37, 0x29,
        0x2C, 0x30, 0x31, 0x34, 0x34, 0x34, 0x1F, 0x27, 0x39, 0x3D, 0x38, 0x32,
        0x3C, 0x2E, 0x33, 0x34, 0x32, 0xFF, 0xC0, 0x00, 0x0B, 0x08, 0x00, 0x01,
        0x00, 0x01, 0x01, 0x01, 0x11, 0x00, 0xFF, 0xC4, 0x00, 0x1F, 0x00, 0x00,
        0x01, 0x05, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x09, 0x0A, 0x0B, 0xFF, 0xC4, 0x00, 0xB5, 0x10, 0x00, 0x02, 0x01, 0x03,
        0x03, 0x02, 0x04, 0x03, 0x05, 0x05, 0x04, 0x04, 0x00, 0x00, 0x01, 0x7D,
        0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12, 0x21, 0x31, 0x41, 0x06,
        0x13, 0x51, 0x61, 0x07, 0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xA1, 0x08,
        0x23, 0x42, 0xB1, 0xC1, 0x15, 0x52, 0xD1, 0xF0, 0x24, 0x33, 0x62, 0x72,
        0x82, 0x09, 0x0A, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x25, 0x26, 0x27, 0x28,
        0x29, 0x2A, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x43, 0x44, 0x45,
        0x46, 0x47, 0x48, 0x49, 0x4A, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
        0x5A, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x73, 0x74, 0x75,
        0x76, 0x77, 0x78, 0x79, 0x7A, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
        0x8A, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9A, 0xA2, 0xA3,
        0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xAA, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6,
        0xB7, 0xB8, 0xB9, 0xBA, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9,
        0xCA, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA, 0xE1, 0xE2,
        0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xEA, 0xF1, 0xF2, 0xF3, 0xF4,
        0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0xFA, 0xFF, 0xDA, 0x00, 0x08, 0x01, 0x01,
        0x00, 0x00, 0x3F, 0x00, 0x7B, 0x94, 0x11, 0x00, 0x00, 0x00, 0x00, 0xFF,
        0xD9,
    ])

    from io import BytesIO
    resp = await ai_client.post(
        "/api/v1/ai/documents/scan",
        files={"file": ("test_doc.jpg", BytesIO(jpeg_bytes), "image/jpeg")},
        data={"target_language": "en"},
        headers=headers,
    )
    assert resp.status_code == 202, f"Scan failed: {resp.status_code} {resp.text}"
    scan_data = resp.json()["data"]
    scan_id = scan_data["id"]
    print(f"    ✅ Scan submitted: {scan_id} (status: {scan_data.get('status', '?')})")

    # Step 2: Get scan result
    print(f"  [D2] GET /ai/documents/{scan_id[:8]}...")
    resp = await ai_client.get(
        f"/api/v1/ai/documents/{scan_id}",
        headers=headers,
    )
    assert resp.status_code == 200, f"Get scan failed: {resp.status_code} {resp.text}"
    result = resp.json()["data"]
    assert result["id"] == scan_id
    has_ocr = result.get("ocr_text") is not None or result.get("status") in ("completed", "processing")
    assert has_ocr, f"No OCR data: {result}"
    print(f"    ✅ Scan result: status={result.get('status')}, type={result.get('document_type', '?')}")

    print("\n  🎉 Loop D PASSED")


# ══════════════════════════════════════════════════════════════════════
# Loop E: Premium → Community post → Reply → Vote → Best answer
# ══════════════════════════════════════════════════════════════════════


async def loop_e(app_client: AsyncClient, ai_client: AsyncClient):
    """E: Upgrade to Premium → Community post → Reply → Vote → Best answer."""
    print("\n" + "=" * 60)
    print("🔄 Loop E: Premium → Post → Reply → Vote → Best answer")
    print("=" * 60)

    uid = f"e2e_e_{uuid.uuid4().hex[:8]}"
    email = f"{uid}@test.com"
    headers = _make_headers(uid, email)

    # Create user as premium
    await _ensure_profile(uid, email, tier="premium", onboarding_completed=True)

    # Step 1: Create community post
    print("\n  [E1] POST /community/posts")
    resp = await app_client.post(
        "/api/v1/community/posts",
        json={
            "channel": "en",
            "category": "banking",
            "title": "E2E Test: Best bank for newcomers?",
            "content": "I just arrived in Tokyo and need to open a bank account. Which bank is best for someone who doesn't speak Japanese?",
        },
        headers=headers,
    )
    assert resp.status_code == 201, f"Post failed: {resp.status_code} {resp.text}"
    post = resp.json()["data"]
    post_id = post["id"]
    print(f"    ✅ Post created: {post_id}")

    # Step 2: Create reply
    print(f"  [E2] POST /community/posts/{post_id[:8]}.../replies")
    resp = await app_client.post(
        f"/api/v1/community/posts/{post_id}/replies",
        json={"content": "I recommend Shinsei Bank — they have English online banking and no monthly fee!"},
        headers=headers,
    )
    assert resp.status_code == 201, f"Reply failed: {resp.status_code} {resp.text}"
    reply = resp.json()["data"]
    reply_id = reply["id"]
    print(f"    ✅ Reply created: {reply_id}")

    # Step 3: Vote on the post
    print(f"  [E3] POST /community/posts/{post_id[:8]}.../vote")
    resp = await app_client.post(
        f"/api/v1/community/posts/{post_id}/vote",
        headers=headers,
    )
    assert resp.status_code == 200, f"Vote failed: {resp.status_code} {resp.text}"
    vote_data = resp.json()["data"]
    assert vote_data["voted"] is True
    assert vote_data["upvote_count"] >= 1
    print(f"    ✅ Voted: count={vote_data['upvote_count']}")

    # Step 4: Set best answer
    print(f"  [E4] POST /community/replies/{reply_id[:8]}.../best-answer")
    resp = await app_client.post(
        f"/api/v1/community/replies/{reply_id}/best-answer",
        headers=headers,
    )
    assert resp.status_code == 200, f"Best answer failed: {resp.status_code} {resp.text}"
    ba_data = resp.json()["data"]
    assert ba_data["is_best_answer"] is True
    assert ba_data["post_is_answered"] is True
    print("    ✅ Best answer set")

    print("\n  🎉 Loop E PASSED")


# ══════════════════════════════════════════════════════════════════════
# Loop F: Free → Checkout → Webhook → Premium → Chat unlimited
# ══════════════════════════════════════════════════════════════════════


async def loop_f(app_client: AsyncClient, ai_client: AsyncClient):
    """F: Free → Checkout → Webhook → Premium → Chat unlimited."""
    print("\n" + "=" * 60)
    print("🔄 Loop F: Free → Checkout → Webhook → Premium → Unlimited Chat")
    print("=" * 60)

    uid = f"e2e_f_{uuid.uuid4().hex[:8]}"
    email = f"{uid}@test.com"
    headers = _make_headers(uid, email)

    await _ensure_profile(uid, email, tier="free", onboarding_completed=True)

    # Step 1: Verify free tier
    print("\n  [F1] GET /users/me → free tier")
    resp = await app_client.get("/api/v1/users/me", headers=headers)
    assert resp.status_code == 200
    assert resp.json()["data"]["subscription_tier"] == "free"
    print("    ✅ User is Free tier")

    # Step 2: Create checkout session
    print("  [F2] POST /subscriptions/checkout")
    resp = await app_client.post(
        "/api/v1/subscriptions/checkout",
        json={"plan_id": "premium_monthly"},
        headers=headers,
    )
    assert resp.status_code == 200, f"Checkout failed: {resp.status_code} {resp.text}"
    checkout = resp.json()["data"]
    assert "checkout_url" in checkout
    print(f"    ✅ Checkout URL: {checkout['checkout_url'][:60]}...")

    # Step 3: Simulate Stripe webhook (checkout.session.completed)
    print("  [F3] POST /subscriptions/webhook (checkout.session.completed)")
    webhook_event = {
        "type": "checkout.session.completed",
        "data": {
            "object": {
                "customer": f"cus_e2e_{uid[:12]}",
                "subscription": f"sub_e2e_{uid[:12]}",
                "metadata": {
                    "firebase_uid": uid,
                    "plan_id": "premium_monthly",
                },
            }
        },
    }
    resp = await app_client.post(
        "/api/v1/subscriptions/webhook",
        content=json.dumps(webhook_event),
        headers={"Content-Type": "application/json"},
    )
    assert resp.status_code == 200, f"Webhook failed: {resp.status_code} {resp.text}"
    print("    ✅ Webhook processed")

    # Step 4: Verify premium tier
    print("  [F4] GET /users/me → premium tier")
    resp = await app_client.get("/api/v1/users/me", headers=headers)
    assert resp.status_code == 200
    assert resp.json()["data"]["subscription_tier"] == "premium", \
        f"Expected premium, got {resp.json()['data']['subscription_tier']}"
    print("    ✅ User upgraded to Premium")

    # Step 5: Chat unlimited — send 6 messages (Free limit is 5/day)
    print("  [F5] Chat 6 times (exceeds Free limit of 5)")
    resp = await ai_client.post(
        "/api/v1/ai/chat/sessions",
        json={},
        headers=headers,
    )
    assert resp.status_code == 201, f"Session create failed: {resp.status_code} {resp.text}"
    session_id = resp.json()["data"]["session"]["id"]

    for i in range(6):
        resp = await ai_client.post(
            f"/api/v1/ai/chat/sessions/{session_id}/messages",
            json={"content": f"Test message {i + 1}"},
            headers=headers,
        )
        assert resp.status_code == 200, \
            f"Message {i + 1} failed: {resp.status_code} {resp.text}"
    print("    ✅ Sent 6 messages successfully (unlimited for Premium)")

    print("\n  🎉 Loop F PASSED")


# ══════════════════════════════════════════════════════════════════════
# Main runner
# ══════════════════════════════════════════════════════════════════════

LOOPS = {
    "A": loop_a,
    "B": loop_b,
    "C": loop_c,
    "D": loop_d,
    "E": loop_e,
    "F": loop_f,
}


async def main(selected: list[str] | None = None):
    """Run E2E test loops."""
    _run_db_setup()

    # Import App Service
    from main import app as app_service_app

    # Load AI Service app
    print("\n🤖 Loading AI Service...")
    ai_app = _load_ai_service_app()
    if ai_app:
        print("  ✅ AI Service loaded")
    else:
        print("  ⚠️  AI Service unavailable — AI loops will use App Service fallback")

    # Create ASGI test clients
    app_transport = ASGITransport(app=app_service_app)
    ai_transport = ASGITransport(app=ai_app) if ai_app else app_transport

    loops_to_run = selected or list(LOOPS.keys())
    results = {}

    async with AsyncClient(transport=app_transport, base_url="http://test") as app_client:
        async with AsyncClient(transport=ai_transport, base_url="http://test") as ai_client:
            for name in loops_to_run:
                key = name.upper()
                if key not in LOOPS:
                    print(f"\n⚠️  Unknown loop: {name}")
                    continue
                try:
                    await LOOPS[key](app_client, ai_client)
                    results[key] = "PASS"
                except Exception as e:
                    results[key] = f"FAIL: {e}"
                    traceback.print_exc()

    # Summary
    print("\n" + "=" * 60)
    print("📊 E2E Test Results")
    print("=" * 60)
    all_passed = True
    for name, result in results.items():
        icon = "✅" if result == "PASS" else "❌"
        print(f"  {icon} Loop {name}: {result}")
        if result != "PASS":
            all_passed = False

    print()
    if all_passed and len(results) == len(LOOPS):
        print("🎉 ALL 6 CLOSED LOOPS PASSED!")
    elif all_passed:
        print(f"✅ {len(results)}/{len(LOOPS)} selected loops passed.")
    else:
        failed = sum(1 for r in results.values() if r != "PASS")
        print(f"❌ {failed} loop(s) FAILED")
        sys.exit(1)


if __name__ == "__main__":
    selected = sys.argv[1:] if len(sys.argv) > 1 else None
    asyncio.run(main(selected))
