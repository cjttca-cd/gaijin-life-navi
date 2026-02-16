"""Document Scanner endpoints (API_DESIGN.md — Document Scanner).

POST   /api/v1/ai/documents/scan  — Upload + OCR + translate (mock mode)
GET    /api/v1/ai/documents       — List scans (cursor pagination)
GET    /api/v1/ai/documents/:id   — Scan detail
DELETE /api/v1/ai/documents/:id   — Soft-delete
"""

import logging
import os
import uuid
from datetime import date, datetime, timezone

from fastapi import APIRouter, Depends, File, Form, HTTPException, Query, UploadFile, status
from sqlalchemy import select, func as sa_func
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.document_scan import DocumentScan
from models.profile import Profile
from models.daily_usage import DailyUsage

import sys

_backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
_shared_dir = os.path.join(os.path.dirname(_backend_dir), "backend")
if _shared_dir not in sys.path:
    sys.path.insert(0, _shared_dir)

from shared.auth import FirebaseUser, get_current_user  # noqa: E402

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/ai/documents", tags=["documents"])

# ── Tier limits (BUSINESS_RULES.md §2) ─────────────────────────────────
FREE_SCAN_MONTHLY_LIMIT = 3
PREMIUM_SCAN_MONTHLY_LIMIT = 30

# Max file size: 10 MB
MAX_FILE_SIZE = 10 * 1024 * 1024
ALLOWED_CONTENT_TYPES = {"image/jpeg", "image/png", "image/heic"}

# ── Mock OCR result (for when Cloud Vision API key is not set) ─────────

MOCK_OCR_RESULT = {
    "ocr_text": "国民健康保険料　納入通知書\n\n被保険者番号：12345678\n氏名：〇〇　〇〇　様\n\n令和6年度　国民健康保険料\n\n期別　　　保険料額\n第1期　　 12,300円\n第2期　　 12,300円\n第3期　　 12,300円\n\n合計　　　36,900円\n\n納期限：令和6年6月30日\n\nお問い合わせ先：\n〇〇市役所　国民健康保険課\nTEL: 03-XXXX-XXXX",
    "document_type": "insurance_notice",
    "translation": {
        "en": "National Health Insurance Premium Payment Notice\n\nInsured Person Number: 12345678\nName: ○○ ○○\n\nFiscal Year 2024 National Health Insurance Premium\n\nPeriod    Premium Amount\n1st Period    ¥12,300\n2nd Period    ¥12,300\n3rd Period    ¥12,300\n\nTotal    ¥36,900\n\nPayment Deadline: June 30, 2024\n\nInquiries:\n○○ City Hall National Health Insurance Division\nTEL: 03-XXXX-XXXX",
        "zh": "国民健康保险费缴纳通知书\n\n被保险人编号：12345678\n姓名：○○ ○○\n\n令和6年度 国民健康保险费\n\n期别　　　保险费金额\n第1期　　 12,300日元\n第2期　　 12,300日元\n第3期　　 12,300日元\n\n合计　　　36,900日元\n\n缴纳期限：2024年6月30日\n\n咨询处：\n○○市政府 国民健康保险课\nTEL: 03-XXXX-XXXX",
        "vi": "Thông báo đóng phí Bảo hiểm Y tế Quốc dân\n\nSố người được bảo hiểm: 12345678\nHọ tên: ○○ ○○\n\nPhí Bảo hiểm Y tế Quốc dân năm 2024\n\nKỳ    Số tiền\nKỳ 1    ¥12,300\nKỳ 2    ¥12,300\nKỳ 3    ¥12,300\n\nTổng cộng    ¥36,900\n\nHạn nộp: 30 tháng 6 năm 2024\n\nLiên hệ:\nPhòng Bảo hiểm Y tế Quốc dân - Tòa thị chính ○○\nTEL: 03-XXXX-XXXX",
        "ko": "국민건강보험료 납입 통지서\n\n피보험자 번호: 12345678\n성명: ○○ ○○\n\n2024년도 국민건강보험료\n\n기별    보험료액\n제1기    ¥12,300\n제2기    ¥12,300\n제3기    ¥12,300\n\n합계    ¥36,900\n\n납기한: 2024년 6월 30일\n\n문의처:\n○○시청 국민건강보험과\nTEL: 03-XXXX-XXXX",
        "pt": "Aviso de Pagamento do Seguro Nacional de Saúde\n\nNúmero do segurado: 12345678\nNome: ○○ ○○\n\nPrêmio do Seguro Nacional de Saúde - Ano Fiscal 2024\n\nPeríodo    Valor do prêmio\n1º Período    ¥12,300\n2º Período    ¥12,300\n3º Período    ¥12,300\n\nTotal    ¥36,900\n\nPrazo de pagamento: 30 de junho de 2024\n\nInformações:\nPrefeitura de ○○ - Divisão de Seguro Nacional de Saúde\nTEL: 03-XXXX-XXXX",
    },
    "explanation": {
        "en": "This is a National Health Insurance (国民健康保険) premium payment notice from your local city hall. It shows your insurance premium broken down by payment periods. You need to pay the specified amount by the deadline shown. You can pay at convenience stores, banks, or set up automatic deduction. If you have difficulty paying, contact the insurance division at your city hall to discuss payment plans.",
        "zh": "这是您当地市政府发送的国民健康保险费缴纳通知书。它显示了按缴纳期别划分的保险费金额。您需要在截止日期前缴纳指定金额。可以在便利店、银行缴纳，或设置自动扣款。如果缴费有困难，请联系市政府保险课商讨分期付款方案。",
        "vi": "Đây là thông báo đóng phí Bảo hiểm Y tế Quốc dân từ tòa thị chính địa phương. Nó cho thấy số tiền bảo hiểm được chia theo từng kỳ thanh toán. Bạn cần thanh toán số tiền được chỉ định trước hạn. Bạn có thể thanh toán tại cửa hàng tiện lợi, ngân hàng, hoặc đăng ký trích tự động. Nếu gặp khó khăn, hãy liên hệ phòng bảo hiểm tại tòa thị chính để thảo luận về phương án trả góp.",
        "ko": "이것은 지역 시청에서 보낸 국민건강보험료 납입 통지서입니다. 납부 기별로 나뉜 보험료가 표시되어 있습니다. 표시된 기한까지 지정된 금액을 납부해야 합니다. 편의점, 은행에서 납부하거나 자동이체를 설정할 수 있습니다. 납부가 어려운 경우 시청 보험과에 연락하여 분할 납부를 상담하세요.",
        "pt": "Este é um aviso de pagamento do Seguro Nacional de Saúde (国民健康保険) da sua prefeitura local. Mostra o valor do prêmio dividido por períodos de pagamento. Você precisa pagar o valor especificado até o prazo indicado. Pode pagar em lojas de conveniência, bancos, ou configurar débito automático. Se tiver dificuldade para pagar, entre em contato com a divisão de seguros da sua prefeitura para discutir planos de pagamento.",
    },
}


# ── Helpers ────────────────────────────────────────────────────────────


def _scan_to_dict(scan: DocumentScan) -> dict:
    return {
        "id": scan.id,
        "file_url": scan.file_url,
        "file_name": scan.file_name,
        "file_size_bytes": scan.file_size_bytes,
        "ocr_text": scan.ocr_text,
        "translation": scan.translation,
        "explanation": scan.explanation,
        "document_type": scan.document_type,
        "source_language": scan.source_language,
        "target_language": scan.target_language,
        "status": scan.status,
        "error_message": scan.error_message,
        "created_at": scan.created_at.isoformat() if scan.created_at else None,
        "updated_at": scan.updated_at.isoformat() if scan.updated_at else None,
    }


async def _get_or_create_usage(db: AsyncSession, user_id: str) -> DailyUsage:
    """Get or create today's usage record."""
    today = date.today()
    stmt = select(DailyUsage).where(
        DailyUsage.user_id == user_id,
        DailyUsage.usage_date == today,
    )
    result = await db.execute(stmt)
    usage = result.scalars().first()
    if usage is None:
        usage = DailyUsage(
            id=str(uuid.uuid4()),
            user_id=user_id,
            usage_date=today,
            chat_count=0,
            scan_count_monthly=0,
        )
        db.add(usage)
        await db.flush()
    return usage


def _get_monthly_scan_count(usage: DailyUsage) -> int:
    """Get scan count, handling monthly reset logic."""
    # If usage_date month != current month, treat count as 0
    today = date.today()
    if usage.usage_date.month != today.month or usage.usage_date.year != today.year:
        return 0
    return usage.scan_count_monthly


# ── Endpoints ──────────────────────────────────────────────────────────


@router.post("/scan", status_code=status.HTTP_202_ACCEPTED)
async def scan_document(
    file: UploadFile = File(...),
    target_language: str = Form(default="en"),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Upload document → OCR → translate → explain. Mock mode if no API key."""
    # Check profile
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

    tier = profile.subscription_tier

    # Check file validation
    if file.content_type and file.content_type not in ALLOWED_CONTENT_TYPES:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={
                "error": {
                    "code": "VALIDATION_ERROR",
                    "message": f"Unsupported file type: {file.content_type}. Allowed: JPEG, PNG, HEIC.",
                    "details": {"field": "file"},
                }
            },
        )

    # Read file content
    content = await file.read()
    file_size = len(content)

    if file_size > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={
                "error": {
                    "code": "VALIDATION_ERROR",
                    "message": f"File too large ({file_size} bytes). Maximum: {MAX_FILE_SIZE} bytes (10 MB).",
                    "details": {"field": "file"},
                }
            },
        )

    # Check tier limit (BUSINESS_RULES.md §2)
    usage = await _get_or_create_usage(db, current_user.uid)
    monthly_count = _get_monthly_scan_count(usage)

    if tier == "free" and monthly_count >= FREE_SCAN_MONTHLY_LIMIT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": {
                    "code": "TIER_LIMIT_EXCEEDED",
                    "message": "You have reached the monthly limit for document scanning. Upgrade to Premium for more scans.",
                    "details": {
                        "feature": "document_scanner",
                        "current_count": monthly_count,
                        "limit": FREE_SCAN_MONTHLY_LIMIT,
                        "tier": "free",
                        "upgrade_url": "/subscription",
                    },
                }
            },
        )
    elif tier == "premium" and monthly_count >= PREMIUM_SCAN_MONTHLY_LIMIT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": {
                    "code": "TIER_LIMIT_EXCEEDED",
                    "message": "You have reached the monthly limit for document scanning. Upgrade to Premium+ for unlimited scans.",
                    "details": {
                        "feature": "document_scanner",
                        "current_count": monthly_count,
                        "limit": PREMIUM_SCAN_MONTHLY_LIMIT,
                        "tier": "premium",
                        "upgrade_url": "/subscription",
                    },
                }
            },
        )

    # Create scan record
    scan_id = str(uuid.uuid4())
    file_url = f"mock://uploads/{current_user.uid}/{scan_id}/{file.filename}"

    scan = DocumentScan(
        id=scan_id,
        user_id=current_user.uid,
        file_url=file_url,
        file_name=file.filename or "unknown",
        file_size_bytes=file_size,
        source_language="ja",
        target_language=target_language,
        status="processing",
    )
    db.add(scan)
    await db.flush()

    # Mock OCR processing (GOTCHAS: Cloud Vision must have mock mode)
    mock = MOCK_OCR_RESULT
    scan.ocr_text = mock["ocr_text"]
    scan.document_type = mock["document_type"]
    scan.translation = mock["translation"].get(target_language, mock["translation"]["en"])
    scan.explanation = mock["explanation"].get(target_language, mock["explanation"]["en"])
    scan.status = "completed"
    scan.updated_at = datetime.now(timezone.utc)
    await db.flush()

    # Increment scan count
    usage.scan_count_monthly = monthly_count + 1
    usage.updated_at = datetime.now(timezone.utc)
    await db.flush()

    return {
        "data": _scan_to_dict(scan),
        "meta": {"request_id": str(uuid.uuid4())},
    }


@router.get("")
async def list_documents(
    limit: int = Query(default=20, ge=1, le=50),
    cursor: str | None = Query(default=None),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """List user's document scans — cursor pagination."""
    stmt = (
        select(DocumentScan)
        .where(
            DocumentScan.user_id == current_user.uid,
            DocumentScan.deleted_at == None,  # noqa: E711
        )
        .order_by(DocumentScan.created_at.desc())
        .limit(limit + 1)
    )

    if cursor:
        # Cursor is the id of the last item
        cursor_scan = await db.get(DocumentScan, cursor)
        if cursor_scan and cursor_scan.created_at:
            stmt = stmt.where(DocumentScan.created_at < cursor_scan.created_at)

    result = await db.execute(stmt)
    scans = result.scalars().all()

    has_more = len(scans) > limit
    if has_more:
        scans = scans[:limit]

    next_cursor = scans[-1].id if has_more and scans else None

    return {
        "data": [_scan_to_dict(s) for s in scans],
        "pagination": {
            "next_cursor": next_cursor,
            "has_more": has_more,
        },
        "meta": {"request_id": str(uuid.uuid4())},
    }


@router.get("/{scan_id}")
async def get_document(
    scan_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Get scan result detail."""
    scan = await db.get(DocumentScan, scan_id)
    if (
        scan is None
        or scan.deleted_at is not None
        or scan.user_id != current_user.uid
    ):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Document scan not found.",
                    "details": {},
                }
            },
        )

    return {
        "data": _scan_to_dict(scan),
        "meta": {"request_id": str(uuid.uuid4())},
    }


@router.delete("/{scan_id}")
async def delete_document(
    scan_id: str,
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Soft-delete a document scan."""
    scan = await db.get(DocumentScan, scan_id)
    if (
        scan is None
        or scan.deleted_at is not None
        or scan.user_id != current_user.uid
    ):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={
                "error": {
                    "code": "NOT_FOUND",
                    "message": "Document scan not found.",
                    "details": {},
                }
            },
        )

    scan.deleted_at = datetime.now(timezone.utc)
    scan.updated_at = scan.deleted_at
    await db.flush()

    return {
        "data": {"message": "Document scan deleted."},
        "meta": {"request_id": str(uuid.uuid4())},
    }
