"""Firebase Auth token verification service.

Provides the `get_current_user` dependency for FastAPI routes.

When FIREBASE_CREDENTIALS is not set (empty string), a mock/stub mode is used
so the app can start and be tested without actual Firebase credentials.
"""

import logging
from dataclasses import dataclass
from typing import Any

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from config import settings

logger = logging.getLogger(__name__)

security = HTTPBearer()

# ── Firebase Admin SDK initialisation ──────────────────────────────────

_firebase_app: Any = None
_mock_mode: bool = False


def _init_firebase() -> None:
    """Initialise Firebase Admin SDK or enable mock mode."""
    global _firebase_app, _mock_mode

    if not settings.FIREBASE_CREDENTIALS:
        logger.warning(
            "FIREBASE_CREDENTIALS not set — running in MOCK auth mode. "
            "All tokens will be accepted with a test UID."
        )
        _mock_mode = True
        return

    try:
        import firebase_admin  # type: ignore[import-untyped]
        from firebase_admin import credentials as fb_credentials  # type: ignore[import-untyped]

        cred = fb_credentials.Certificate(settings.FIREBASE_CREDENTIALS)
        _firebase_app = firebase_admin.initialize_app(cred)
        logger.info("Firebase Admin SDK initialised successfully.")
    except Exception as exc:
        logger.warning(
            "Failed to initialise Firebase Admin SDK (%s). "
            "Falling back to MOCK auth mode.",
            exc,
        )
        _mock_mode = True


# Initialise on module import
_init_firebase()


# ── Data class for decoded token ───────────────────────────────────────


@dataclass
class FirebaseUser:
    """Decoded Firebase user info extracted from ID Token."""

    uid: str
    email: str
    email_verified: bool = False
    name: str = ""


# ── Token verification ─────────────────────────────────────────────────


def _verify_token(token: str) -> FirebaseUser:
    """Verify a Firebase ID token and return a FirebaseUser."""
    if _mock_mode:
        # In mock mode accept any Bearer token.
        # If it looks like a Firebase JWT, decode the payload (no verification)
        # to extract uid/email. Otherwise use "uid:email" format.
        if token.count(".") == 2:
            # JWT format: header.payload.signature
            import base64, json as _json
            try:
                payload_b64 = token.split(".")[1]
                # Add padding
                payload_b64 += "=" * (4 - len(payload_b64) % 4)
                payload = _json.loads(base64.urlsafe_b64decode(payload_b64))
                uid = payload.get("user_id") or payload.get("sub") or "mock_user_id"
                email = payload.get("email", "mock@example.com")
                name = payload.get("name", "")
                return FirebaseUser(uid=uid, email=email, email_verified=True, name=name)
            except Exception:
                pass  # Fall through to simple format
        # Simple format: "test_uid:test@example.com"
        parts = token.split(":", 1)
        uid = parts[0] if parts[0] else "mock_user_id"
        email = parts[1] if len(parts) > 1 else "mock@example.com"
        return FirebaseUser(uid=uid, email=email, email_verified=True)

    try:
        from firebase_admin import auth as fb_auth  # type: ignore[import-untyped]

        decoded = fb_auth.verify_id_token(token)
        return FirebaseUser(
            uid=decoded["uid"],
            email=decoded.get("email", ""),
            email_verified=decoded.get("email_verified", False),
            name=decoded.get("name", ""),
        )
    except Exception:
        # Do NOT log the token (PII)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={
                "error": {
                    "code": "UNAUTHORIZED",
                    "message": "Invalid or expired authentication token.",
                    "details": {},
                }
            },
        )


# ── FastAPI Dependency ─────────────────────────────────────────────────


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> FirebaseUser:
    """FastAPI dependency — extracts and verifies the Firebase ID token."""
    return _verify_token(credentials.credentials)
