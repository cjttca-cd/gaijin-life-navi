"""User profile Pydantic schemas (API_DESIGN.md — User Profile section)."""

from datetime import date, datetime
from typing import Literal

from pydantic import BaseModel, Field


class ProfileResponse(BaseModel):
    """GET /api/v1/users/me response — profile data object."""

    id: str
    email: str
    display_name: str
    avatar_url: str | None = None
    nationality: str | None = None
    residence_status: str | None = None
    residence_region: str | None = None
    visa_expiry: date | None = None
    preferred_language: str | None = None
    subscription_tier: str
    onboarding_completed: bool
    created_at: datetime

    model_config = {"from_attributes": True}


class UpdateProfileRequest(BaseModel):
    """PATCH /api/v1/users/me request body — all fields optional."""

    display_name: str | None = Field(default=None, max_length=100)
    avatar_url: str | None = None
    nationality: str | None = Field(default=None, max_length=2)
    residence_status: str | None = Field(default=None, max_length=50)
    residence_region: str | None = Field(default=None, max_length=100)
    visa_expiry: date | None = None
    preferred_language: Literal["en", "zh", "vi", "ko", "pt"] | None = None


class OnboardingRequest(BaseModel):
    """POST /api/v1/users/me/onboarding request body."""

    nationality: str | None = Field(default=None, max_length=2)
    residence_status: str | None = Field(default=None, max_length=50)
    residence_region: str | None = Field(default=None, max_length=100)
    visa_expiry: date | None = None
    preferred_language: Literal["en", "zh", "vi", "ko", "pt"]
