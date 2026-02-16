"""Pydantic v2 schemas for request/response validation."""

from schemas.auth import RegisterRequest, RegisterResponse
from schemas.users import (
    OnboardingRequest,
    ProfileResponse,
    UpdateProfileRequest,
)
from schemas.common import ErrorDetail, ErrorResponse, SuccessResponse, MetaResponse

__all__ = [
    "RegisterRequest",
    "RegisterResponse",
    "OnboardingRequest",
    "ProfileResponse",
    "UpdateProfileRequest",
    "ErrorDetail",
    "ErrorResponse",
    "SuccessResponse",
    "MetaResponse",
]
