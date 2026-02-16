"""Common response/error schemas following API_DESIGN.md conventions."""

from typing import Any
from uuid import uuid4

from pydantic import BaseModel, Field


class MetaResponse(BaseModel):
    """Meta information included in every response."""

    request_id: str = Field(default_factory=lambda: str(uuid4()))


class SuccessResponse(BaseModel):
    """Standard success response wrapper: {"data": ..., "meta": ...}."""

    data: Any
    meta: MetaResponse = Field(default_factory=MetaResponse)


class PaginatedResponse(BaseModel):
    """Paginated response with cursor-based pagination."""

    data: list[Any]
    pagination: dict[str, Any]
    meta: MetaResponse = Field(default_factory=MetaResponse)


class ErrorDetail(BaseModel):
    """Error detail object."""

    code: str
    message: str
    details: dict[str, Any] = Field(default_factory=dict)


class ErrorResponse(BaseModel):
    """Standard error response: {"error": {"code": ..., "message": ..., "details": ...}}."""

    error: ErrorDetail
