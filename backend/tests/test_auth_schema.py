from __future__ import annotations

from fastapi import FastAPI
from fastapi.testclient import TestClient
from pydantic import ValidationError
import pytest

from routers import auth as auth_router
from schemas.auth import RegisterRequest
from services.auth import FirebaseUser


def _build_auth_client() -> TestClient:
    app = FastAPI()
    app.include_router(auth_router.router)

    async def override_current_user() -> FirebaseUser:
        return FirebaseUser(uid="uid-1", email="user@example.com")

    async def override_db():
        yield None

    app.dependency_overrides[auth_router.get_current_user] = override_current_user
    app.dependency_overrides[auth_router.get_db] = override_db
    return TestClient(app)


def test_register_request_requires_nationality_residence_fields() -> None:
    with pytest.raises(ValidationError) as exc_info:
        RegisterRequest(display_name="A", preferred_language="en")

    missing_fields = {err["loc"][0] for err in exc_info.value.errors()}
    assert "nationality" in missing_fields
    assert "residence_status" in missing_fields
    assert "residence_region" in missing_fields


def test_register_request_nationality_must_be_2_chars() -> None:
    with pytest.raises(ValidationError):
        RegisterRequest(
            display_name="A",
            preferred_language="en",
            nationality="J",
            residence_status="留学",
            residence_region="東京都",
        )

    with pytest.raises(ValidationError):
        RegisterRequest(
            display_name="A",
            preferred_language="en",
            nationality="JPN",
            residence_status="留学",
            residence_region="東京都",
        )

    valid = RegisterRequest(
        display_name="A",
        preferred_language="en",
        nationality="JP",
        residence_status="留学",
        residence_region="東京都",
    )
    assert valid.nationality == "JP"


def test_register_endpoint_returns_422_when_required_fields_missing() -> None:
    client = _build_auth_client()

    response = client.post(
        "/api/v1/auth/register",
        json={"display_name": "A", "preferred_language": "en"},
    )

    assert response.status_code == 422
    detail = response.json()["detail"]
    missing_locs = {tuple(item["loc"]) for item in detail}

    assert ("body", "nationality") in missing_locs
    assert ("body", "residence_status") in missing_locs
    assert ("body", "residence_region") in missing_locs
