"""Firebase Auth token verification service.

Provides the `get_current_user` dependency for FastAPI routes.

Requires FIREBASE_CREDENTIALS to point to a valid service account JSON.
The app will fail to start if Firebase Admin SDK cannot be initialised.
"""

import logging
from dataclasses import dataclass
from typing import Any

import firebase_admin  # type: ignore[import-untyped]
from firebase_admin import auth as fb_auth  # type: ignore[import-untyped]
from firebase_admin import credentials as fb_credentials  # type: ignore[import-untyped]
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from config import settings

logger = logging.getLogger(__name__)

security = HTTPBearer()

# ── Firebase Admin SDK initialisation ──────────────────────────────────

_firebase_app: Any = None


def _init_firebase() -> None:
    """Initialise Firebase Admin SDK. Raises on failure."""
    global _firebase_app

    cred_path = settings.FIREBASE_CREDENTIALS
    if not cred_path:
        raise RuntimeError(
            "FIREBASE_CREDENTIALS is not set. "
            "Set it to the path of your Firebase service account JSON."
        )

    cred = fb_credentials.Certificate(cred_path)
    _firebase_app = firebase_admin.initialize_app(cred)
    logger.info("Firebase Admin SDK initialised successfully.")


# Initialise on module import — will crash fast if misconfigured.
_init_firebase()


# ── Data class for decoded token ───────────────────────────────────────


@dataclass
class FirebaseUser:
    """Decoded Firebase user info extracted from ID Token."""

    uid: str
    email: str
    email_verified: bool = False
    name: str = ""
    is_anonymous: bool = False


# ── Token verification ─────────────────────────────────────────────────


def _verify_token(token: str) -> FirebaseUser:
    """Verify a Firebase ID token and return a FirebaseUser."""
    try:
        decoded = fb_auth.verify_id_token(token)
        sign_in_provider = decoded.get("firebase", {}).get("sign_in_provider", "")
        return FirebaseUser(
            uid=decoded["uid"],
            email=decoded.get("email", ""),
            email_verified=decoded.get("email_verified", False),
            name=decoded.get("name", ""),
            is_anonymous=sign_in_provider == "anonymous",
        )
    except Exception:
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



async def get_optional_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(
        HTTPBearer(auto_error=False)
    ),
) -> FirebaseUser | None:
    """Optional auth — returns FirebaseUser if valid token present, else None."""
    if credentials is None:
        return None
    try:
        return _verify_token(credentials.credentials)
    except HTTPException:
        return None

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> FirebaseUser:
    """FastAPI dependency — extracts and verifies the Firebase ID token."""
    return _verify_token(credentials.credentials)
