from __future__ import annotations

import os
import sys
import types
from pathlib import Path

import pytest_asyncio
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine


# Make backend/app_service importable (modules use absolute imports like "from models...")
APP_SERVICE_DIR = Path(__file__).resolve().parents[1] / "app_service"
if str(APP_SERVICE_DIR) not in sys.path:
    sys.path.insert(0, str(APP_SERVICE_DIR))


# Stub Firebase Admin SDK before services.auth is imported.
if "firebase_admin" not in sys.modules:
    firebase_admin = types.ModuleType("firebase_admin")

    def _initialize_app(_cred: object | None = None) -> object:
        return object()

    firebase_admin.initialize_app = _initialize_app  # type: ignore[attr-defined]

    auth_mod = types.ModuleType("firebase_admin.auth")

    def _verify_id_token(_token: str) -> dict:
        return {
            "uid": "stub-uid",
            "email": "stub@example.com",
            "email_verified": True,
            "name": "Stub User",
            "firebase": {"sign_in_provider": "password"},
        }

    def _delete_user(_uid: str) -> None:
        return None

    auth_mod.verify_id_token = _verify_id_token  # type: ignore[attr-defined]
    auth_mod.delete_user = _delete_user  # type: ignore[attr-defined]

    cred_mod = types.ModuleType("firebase_admin.credentials")

    class Certificate:  # noqa: D401 - simple test stub
        """Test stub for firebase_admin.credentials.Certificate."""

        def __init__(self, path: str) -> None:
            self.path = path

    cred_mod.Certificate = Certificate  # type: ignore[attr-defined]

    firebase_admin.auth = auth_mod  # type: ignore[attr-defined]
    firebase_admin.credentials = cred_mod  # type: ignore[attr-defined]

    sys.modules["firebase_admin"] = firebase_admin
    sys.modules["firebase_admin.auth"] = auth_mod
    sys.modules["firebase_admin.credentials"] = cred_mod


# Ensure FIREBASE_CREDENTIALS is set (services.auth checks this during import).
os.environ.setdefault("FIREBASE_CREDENTIALS", "/tmp/fake-firebase-service-account.json")


@pytest_asyncio.fixture
async def db_session() -> AsyncSession:
    """In-memory SQLite async session for DB-backed tests."""
    from database import Base
    from models.daily_usage import DailyUsage
    from models.profile import Profile

    engine = create_async_engine("sqlite+aiosqlite:///:memory:")

    async with engine.begin() as conn:
        await conn.run_sync(
            lambda sync_conn: Base.metadata.create_all(
                sync_conn,
                tables=[Profile.__table__, DailyUsage.__table__],
            )
        )

    session_factory = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

    async with session_factory() as session:
        yield session

    await engine.dispose()
