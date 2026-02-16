"""Auth-related Pydantic schemas (API_DESIGN.md — Auth section)."""

from pydantic import BaseModel, Field
from typing import Literal


class RegisterRequest(BaseModel):
    """POST /api/v1/auth/register request body."""

    display_name: str = Field(default="", max_length=100)
    preferred_language: Literal["en", "zh", "vi", "ko", "pt"] = "en"


class UserInRegisterResponse(BaseModel):
    """User object returned in register response."""

    id: str
    email: str
    display_name: str
    preferred_language: str
    subscription_tier: str
    onboarding_completed: bool


class RegisterResponse(BaseModel):
    """Response body for POST /api/v1/auth/register."""

    user: UserInRegisterResponse
