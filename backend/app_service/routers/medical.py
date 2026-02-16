"""Medical Guide endpoints (API_DESIGN.md — Medical Guide).

GET /api/v1/medical/emergency-guide — Emergency guide (auth required, static content)
GET /api/v1/medical/phrases         — Phrase list (auth required, lang + category filter)
"""

import json
import logging

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models.medical_phrase import MedicalPhrase
from schemas.common import SuccessResponse
from services.auth import FirebaseUser, get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/medical", tags=["medical"])

# ── Disclaimer (BUSINESS_RULES.md §6 — mandatory) ─────────────────────

MEDICAL_DISCLAIMER = (
    "This guide provides general health information and is not a substitute "
    "for professional medical advice. In an emergency, call 119 immediately."
)

# ── Static emergency guide content (multi-language) ────────────────────

EMERGENCY_GUIDE = {
    "en": {
        "emergency_number": "119",
        "police_number": "110",
        "how_to_call": [
            "Dial 119 from any phone (free call)",
            "Say 'Kyuukyuu desu' (救急です) — meaning 'It's an emergency'",
            "State your location clearly",
            "Describe the situation in simple words",
            "If you don't speak Japanese, say 'Eigo de onegai shimasu' (英語でお願いします)",
        ],
        "what_to_prepare": [
            "Residence card (在留カード)",
            "Health insurance card (健康保険証)",
            "Any medication you take regularly",
            "Your address written in Japanese",
        ],
        "useful_phrases": [
            {"ja": "救急車を呼んでください", "reading": "きゅうきゅうしゃをよんでください", "translation": "Please call an ambulance"},
            {"ja": "ここが痛いです", "reading": "ここがいたいです", "translation": "It hurts here"},
            {"ja": "アレルギーがあります", "reading": "アレルギーがあります", "translation": "I have allergies"},
            {"ja": "薬を飲んでいます", "reading": "くすりをのんでいます", "translation": "I am taking medication"},
            {"ja": "英語を話せる人はいますか", "reading": "えいごをはなせるひとはいますか", "translation": "Is there someone who speaks English?"},
        ],
        "important_notes": [
            "Japan Medical Info Service (AMDA): 03-6233-9266 (multilingual support)",
            "Japan Helpline: 0570-000-911 (24/7, multilingual)",
            "Tokyo Metropolitan Health Medical Information Center: 03-5285-8181",
            "JMIP certified hospitals accept foreign patients with multilingual support",
        ],
    },
    "zh": {
        "emergency_number": "119",
        "police_number": "110",
        "how_to_call": [
            "拨打119（免费电话）",
            "说 'Kyuukyuu desu'（救急です）— 意思是「这是紧急情况」",
            "清楚地说出你的位置",
            "用简单的词语描述情况",
            "如果不会日语，说 'Chuugokugo de onegai shimasu'（中国語でお願いします）",
        ],
        "what_to_prepare": [
            "在留卡（在留カード）",
            "健康保险证（健康保険証）",
            "正在服用的药物",
            "用日语写的地址",
        ],
        "useful_phrases": [
            {"ja": "救急車を呼んでください", "reading": "きゅうきゅうしゃをよんでください", "translation": "请叫救护车"},
            {"ja": "ここが痛いです", "reading": "ここがいたいです", "translation": "这里疼"},
            {"ja": "アレルギーがあります", "reading": "アレルギーがあります", "translation": "我有过敏症"},
            {"ja": "薬を飲んでいます", "reading": "くすりをのんでいます", "translation": "我在服药"},
            {"ja": "中国語を話せる人はいますか", "reading": "ちゅうごくごをはなせるひとはいますか", "translation": "有人会说中文吗？"},
        ],
        "important_notes": [
            "日本医疗信息服务（AMDA）：03-6233-9266（多语言支持）",
            "日本帮助热线：0570-000-911（24小时，多语言）",
            "东京都保健医疗信息中心：03-5285-8181",
            "JMIP认证医院接受外国患者，提供多语言支持",
        ],
    },
    "vi": {
        "emergency_number": "119",
        "police_number": "110",
        "how_to_call": [
            "Gọi 119 (miễn phí)",
            "Nói 'Kyuukyuu desu' (救急です) — nghĩa là 'Đây là trường hợp khẩn cấp'",
            "Nói rõ vị trí của bạn",
            "Mô tả tình huống bằng từ ngữ đơn giản",
            "Nếu không nói được tiếng Nhật, nói 'Eigo de onegai shimasu' (英語でお願いします)",
        ],
        "what_to_prepare": [
            "Thẻ cư trú (在留カード)",
            "Thẻ bảo hiểm y tế (健康保険証)",
            "Thuốc đang uống",
            "Địa chỉ viết bằng tiếng Nhật",
        ],
        "useful_phrases": [
            {"ja": "救急車を呼んでください", "reading": "きゅうきゅうしゃをよんでください", "translation": "Xin hãy gọi xe cứu thương"},
            {"ja": "ここが痛いです", "reading": "ここがいたいです", "translation": "Chỗ này đau"},
            {"ja": "アレルギーがあります", "reading": "アレルギーがあります", "translation": "Tôi bị dị ứng"},
            {"ja": "薬を飲んでいます", "reading": "くすりをのんでいます", "translation": "Tôi đang uống thuốc"},
            {"ja": "英語を話せる人はいますか", "reading": "えいごをはなせるひとはいますか", "translation": "Có ai nói được tiếng Anh không?"},
        ],
        "important_notes": [
            "Dịch vụ Thông tin Y tế Nhật Bản (AMDA): 03-6233-9266 (đa ngôn ngữ)",
            "Đường dây trợ giúp Nhật Bản: 0570-000-911 (24/7, đa ngôn ngữ)",
            "Trung tâm Thông tin Y tế Tokyo: 03-5285-8181",
            "Bệnh viện chứng nhận JMIP tiếp nhận bệnh nhân nước ngoài với hỗ trợ đa ngôn ngữ",
        ],
    },
    "ko": {
        "emergency_number": "119",
        "police_number": "110",
        "how_to_call": [
            "119에 전화하세요 (무료 통화)",
            "'Kyuukyuu desu'(救急です)라고 말하세요 — '응급입니다'라는 뜻",
            "위치를 명확히 말하세요",
            "간단한 말로 상황을 설명하세요",
            "일본어를 못하면 'Kankokugo de onegai shimasu'(韓国語でお願いします)라고 말하세요",
        ],
        "what_to_prepare": [
            "재류카드 (在留カード)",
            "건강보험증 (健康保険証)",
            "복용 중인 약",
            "일본어로 쓴 주소",
        ],
        "useful_phrases": [
            {"ja": "救急車を呼んでください", "reading": "きゅうきゅうしゃをよんでください", "translation": "구급차를 불러주세요"},
            {"ja": "ここが痛いです", "reading": "ここがいたいです", "translation": "여기가 아파요"},
            {"ja": "アレルギーがあります", "reading": "アレルギーがあります", "translation": "알레르기가 있어요"},
            {"ja": "薬を飲んでいます", "reading": "くすりをのんでいます", "translation": "약을 먹고 있어요"},
            {"ja": "韓国語を話せる人はいますか", "reading": "かんこくごをはなせるひとはいますか", "translation": "한국어를 할 수 있는 사람이 있나요?"},
        ],
        "important_notes": [
            "일본 의료정보 서비스 (AMDA): 03-6233-9266 (다국어 지원)",
            "일본 헬프라인: 0570-000-911 (24시간, 다국어)",
            "도쿄도 보건의료정보센터: 03-5285-8181",
            "JMIP 인증 병원은 외국인 환자를 다국어로 지원합니다",
        ],
    },
    "pt": {
        "emergency_number": "119",
        "police_number": "110",
        "how_to_call": [
            "Ligue 119 (ligação gratuita)",
            "Diga 'Kyuukyuu desu' (救急です) — significa 'É uma emergência'",
            "Diga claramente sua localização",
            "Descreva a situação com palavras simples",
            "Se não fala japonês, diga 'Porutogaru-go de onegai shimasu' (ポルトガル語でお願いします)",
        ],
        "what_to_prepare": [
            "Cartão de residência (在留カード)",
            "Cartão de seguro de saúde (健康保険証)",
            "Medicamentos que toma regularmente",
            "Seu endereço escrito em japonês",
        ],
        "useful_phrases": [
            {"ja": "救急車を呼んでください", "reading": "きゅうきゅうしゃをよんでください", "translation": "Por favor, chame uma ambulância"},
            {"ja": "ここが痛いです", "reading": "ここがいたいです", "translation": "Dói aqui"},
            {"ja": "アレルギーがあります", "reading": "アレルギーがあります", "translation": "Tenho alergias"},
            {"ja": "薬を飲んでいます", "reading": "くすりをのんでいます", "translation": "Estou tomando medicamento"},
            {"ja": "ポルトガル語を話せる人はいますか", "reading": "ポルトガルごをはなせるひとはいますか", "translation": "Alguém fala português?"},
        ],
        "important_notes": [
            "Serviço de Informações Médicas do Japão (AMDA): 03-6233-9266 (suporte multilíngue)",
            "Linha de Ajuda do Japão: 0570-000-911 (24h, multilíngue)",
            "Centro de Informações de Saúde Metropolitano de Tóquio: 03-5285-8181",
            "Hospitais certificados JMIP aceitam pacientes estrangeiros com suporte multilíngue",
        ],
    },
}


# ── Endpoints ──────────────────────────────────────────────────────────


@router.get("/emergency-guide")
async def get_emergency_guide(
    lang: str = Query(default="en", max_length=5),
    current_user: FirebaseUser = Depends(get_current_user),
) -> dict:
    """Emergency guide — static multilingual content with disclaimer."""
    guide = EMERGENCY_GUIDE.get(lang, EMERGENCY_GUIDE["en"])
    guide_data = {**guide, "disclaimer": MEDICAL_DISCLAIMER}
    return SuccessResponse(data=guide_data).model_dump()


@router.get("/phrases")
async def list_phrases(
    lang: str = Query(default="en", max_length=5),
    category: str | None = Query(default=None),
    current_user: FirebaseUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> dict:
    """Medical phrase list — auth required, lang + category filter."""
    stmt = (
        select(MedicalPhrase)
        .where(MedicalPhrase.is_active == True)  # noqa: E712
        .order_by(MedicalPhrase.category, MedicalPhrase.sort_order)
    )
    if category:
        stmt = stmt.where(MedicalPhrase.category == category)

    result = await db.execute(stmt)
    phrases = result.scalars().all()

    data = []
    for p in phrases:
        data.append(
            {
                "id": p.id,
                "category": p.category,
                "phrase_ja": p.phrase_ja,
                "phrase_reading": p.phrase_reading,
                "translation": p.get_translation(lang),
                "context": p.get_context(lang),
                "sort_order": p.sort_order,
            }
        )

    return SuccessResponse(
        data=data,
    ).model_dump()
