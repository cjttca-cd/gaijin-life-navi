"""Auth-related Pydantic schemas (API_DESIGN.md — Auth section)."""

from pydantic import BaseModel, Field
from typing import Literal


class RegisterRequest(BaseModel):
    """POST /api/v1/auth/register request body.

    nationality, residence_status, and residence_region are required at
    registration to enable deep-level personalisation from the first chat.
    See BUSINESS_RULES.md §2 「注册時の必須 Profile」.
    """

    display_name: str = Field(default="", max_length=100)
    preferred_language: Literal["en", "zh", "vi", "ko", "pt"] = "en"
    nationality: str = Field(..., min_length=2, max_length=2, description="ISO 3166-1 alpha-2 country code")
    residence_status: str = Field(..., min_length=1, max_length=50, description="在留資格 (e.g. 留学, 技術・人文知識・国際業務)")
    residence_region: str = Field(..., min_length=1, max_length=100, description="居住地域 (e.g. 東京都, 大阪府)")


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
