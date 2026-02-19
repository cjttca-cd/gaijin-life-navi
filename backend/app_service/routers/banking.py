"""Banking Navigator endpoints (API_DESIGN.md — Banking Navigator).

GET  /api/v1/banking/banks               — Bank list (public, no auth)
POST /api/v1/banking/recommend            — Recommendation (auth required)
GET  /api/v1/banking/banks/:bank_id/guide — Individual guide (auth required)
"""

import json
import logging
from datetime import date
from typing import Literal

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.banking_guide import BankingGuide
from models.profile import Profile
from schemas.common import SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/banking", tags=["banking"])


# ── Schemas ────────────────────────────────────────────────────────────


class RecommendRequest(BaseModel):
    """POST /api/v1/banking/recommend request body."""

    nationality: str | None = Field(default=None, max_length=2)
    residence_status: str | None = Field(default=None, max_length=50)
    residence_region: str | None = Field(default=None, max_length=10)
    priorities: list[Literal["multilingual", "low_fee", "atm", "online"]] = Field(
        default_factory=list
    )


# ── Score calculation (BUSINESS_RULES.md §7 — SSOT) ───────────────────


def calculate_match_score(
    bank: BankingGuide,
    preferred_language: str,
    priorities: list[str],
) -> tuple[int, list[str], list[str]]:
    """Calculate bank recommendation score.

    Implements BUSINESS_RULES.md §7 scoring algorithm exactly.
    Score: 0-100
    """
    score = 0
    reasons: list[str] = []
    warnings: list[str] = []

    # Base score: foreigner-friendly (0-40 pts)
    score += bank.foreigner_friendly_score * 8  # 1-5 → 8-40

    # Multilingual support (0-20 pts)
    multilingual = bank.get_multilingual_support()
    if preferred_language in multilingual:
        score += 20
        reasons.append(f"Supports {preferred_language}")
    elif "en" in multilingual:
        score += 10
        reasons.append("English support available")

    # Priority bonuses (each 0-10 pts, max 40 pts)
    features = bank.get_features()
    if "low_fee" in priorities and features.get("monthly_fee", 0) == 0:
        score += 10
        reasons.append("No monthly fee")
    if "atm" in priorities and features.get("atm_count", 0) > 5000:
        score += 10
        reasons.append("Extensive ATM network")
    if "online" in priorities and features.get("online_banking"):
        score += 10
        reasons.append("Full online banking")
    if "multilingual" in priorities and len(multilingual) >= 3:
        score += 10
        reasons.append("Multilingual support")

    # Warning checks
    requirements = bank.get_requirements()
    min_stay = requirements.get("min_stay_months", 0)
    if min_stay > 0:
        warnings.append(f"May require {min_stay} months residence (verify with bank)")

    return min(score, 100), reasons, warnings


# ── Helpers ────────────────────────────────────────────────────────────


def _bank_to_dict(bank: BankingGuide, lang: str) -> dict:
    """Convert a BankingGuide row to a response dict for a given lang."""
    return {
        "id": bank.id,
        "bank_code": bank.bank_code,
        "bank_name": bank.get_bank_name(lang),
        "bank_name_ja": bank.bank_name_ja,
        "logo_url": bank.logo_url,
        "multilingual_support": bank.get_multilingual_support(),
        "features": bank.get_features(),
        "foreigner_friendly_score": bank.foreigner_friendly_score,
        "application_url": bank.application_url,
        "sort_order": bank.sort_order,
    }


# ── Endpoints ──────────────────────────────────────────────────────────


@router.get("/banks")
async def list_banks(
    lang: str = Query(default="en", max_length=5),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Bank list — public, sorted by foreigner_friendly_score DESC."""
    stmt = (
        select(BankingGuide)
        .where(BankingGuide.is_active == True)  # noqa: E712
        .order_by(
            BankingGuide.foreigner_friendly_score.desc(),
            BankingGuide.sort_order,
        )
    )
    result = await db.execute(stmt)
    banks = result.scalars().all()

    return SuccessResponse(
        data=[_bank_to_dict(b, lang) for b in banks]
    ).model_dump()


@router.post("/recommend")
async def recommend_banks(
    body: RecommendRequest,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Bank recommendation — auth required, score calculation per §7."""
    # Get user profile for defaults
    profile = await db.get(Profile, current_user.uid)
    if profile is None or profile.deleted_at is not None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Profile not found.",
                    "details": {},
                }
            },
        )

    # Use request body values or fall back to profile values
    preferred_language = profile.preferred_language or "en"
    priorities = body.priorities

    # Fetch active banks
    stmt = select(BankingGuide).where(BankingGuide.is_active == True)  # noqa: E712
    result = await db.execute(stmt)
    banks = result.scalars().all()

    recommendations = []
    for bank in banks:
        match_score, match_reasons, warnings = calculate_match_score(
            bank, preferred_language, priorities
        )
        recommendations.append(
            {
                "bank": _bank_to_dict(bank, preferred_language),
                "match_score": match_score,
                "match_reasons": match_reasons,
                "warnings": warnings,
            }
        )

    # Sort by match_score descending
    recommendations.sort(key=lambda r: r["match_score"], reverse=True)

    return SuccessResponse(data=recommendations).model_dump()


@router.get("/banks/{bank_id}/guide")
async def get_bank_guide(
    bank_id: str,
    lang: str = Query(default="en", max_length=5),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Individual bank guide — auth required, full detail."""
    bank = await db.get(BankingGuide, bank_id)
    if bank is None or not bank.is_active:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Bank guide not found.",
                    "details": {},
                }
            },
        )

    guide = _bank_to_dict(bank, lang)
    guide["requirements"] = bank.get_requirements()
    guide["conversation_templates"] = bank.get_conversation_templates(lang)
    guide["troubleshooting"] = bank.get_troubleshooting(lang)

    return SuccessResponse(data=guide).model_dump()
