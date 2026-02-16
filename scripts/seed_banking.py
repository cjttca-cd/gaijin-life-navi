#!/usr/bin/env python3
"""Seed banking_guides with 5 major banks.

Usage:
    DATABASE_URL=sqlite:///data/app.db python scripts/seed_banking.py
"""

import json
import os
import sys
import uuid
from datetime import datetime, timezone

# ── DB setup ───────────────────────────────────────────────────────────

DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "sqlite:////root/.openclaw/projects/gaijin-life-navi/data/app.db",
)
# Convert async URL to sync
DATABASE_URL = DATABASE_URL.replace("sqlite+aiosqlite", "sqlite")
DATABASE_URL = DATABASE_URL.replace("postgresql+asyncpg", "postgresql")

from sqlalchemy import create_engine, text

engine = create_engine(DATABASE_URL, echo=False)

# ── Bank data ──────────────────────────────────────────────────────────

BANKS = [
    {
        "bank_code": "mufg",
        "bank_name": json.dumps({
            "en": "MUFG Bank (Mitsubishi UFJ)",
            "zh": "三菱UFJ银行",
            "vi": "Ngân hàng MUFG (Mitsubishi UFJ)",
            "ko": "MUFG 은행 (미쓰비시 UFJ)",
            "pt": "Banco MUFG (Mitsubishi UFJ)",
        }),
        "bank_name_ja": "三菱UFJ銀行",
        "logo_url": None,
        "multilingual_support": json.dumps(["en", "zh", "ko", "pt"]),
        "requirements": json.dumps({
            "residence_card": True,
            "min_stay_months": 0,
            "seal_or_signature": "either",
            "initial_deposit": 1,
            "documents": ["residence_card", "passport"],
        }),
        "features": json.dumps({
            "atm_count": 7800,
            "monthly_fee": 0,
            "online_banking": True,
            "debit_card": True,
            "international_transfer": True,
            "multilingual_atm": True,
        }),
        "foreigner_friendly_score": 4,
        "application_url": "https://www.bk.mufg.jp/english/",
        "conversation_templates": json.dumps({
            "en": [
                {"situation": "Opening an account", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "I would like to open an account"},
                {"situation": "Setting up online banking", "ja": "インターネットバンキングの設定をお願いします", "reading": "インターネットバンキングのせっていをおねがいします", "translation": "I would like to set up internet banking"},
                {"situation": "Getting a cash card", "ja": "キャッシュカードを作りたいです", "reading": "キャッシュカードをつくりたいです", "translation": "I want to get a cash card"},
            ],
            "zh": [
                {"situation": "开户", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "我想开一个账户"},
                {"situation": "设置网上银行", "ja": "インターネットバンキングの設定をお願いします", "reading": "インターネットバンキングのせっていをおねがいします", "translation": "我想设置网上银行"},
                {"situation": "办理现金卡", "ja": "キャッシュカードを作りたいです", "reading": "キャッシュカードをつくりたいです", "translation": "我想办一张现金卡"},
            ],
            "vi": [
                {"situation": "Mở tài khoản", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Tôi muốn mở tài khoản"},
            ],
            "ko": [
                {"situation": "계좌 개설", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "계좌를 개설하고 싶습니다"},
            ],
            "pt": [
                {"situation": "Abrir uma conta", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Gostaria de abrir uma conta"},
            ],
        }),
        "troubleshooting": json.dumps({
            "en": [
                {"problem": "Can't open account without a seal", "solution": "MUFG accepts signature instead of seal (印鑑). Tell the staff: サインでお願いします (sain de onegai shimasu)"},
                {"problem": "Need a Japanese phone number", "solution": "Some branches require a Japanese phone number. Get a SIM card first, or try a different branch."},
            ],
            "zh": [
                {"problem": "没有印章无法开户", "solution": "三菱UFJ银行接受签名代替印章。告诉工作人员：サインでお願いします"},
                {"problem": "需要日本电话号码", "solution": "部分分行要求日本电话号码。请先办理SIM卡，或尝试其他分行。"},
            ],
            "vi": [
                {"problem": "Không mở được tài khoản không có con dấu", "solution": "MUFG chấp nhận chữ ký thay cho con dấu. Nói với nhân viên: サインでお願いします"},
            ],
            "ko": [
                {"problem": "도장 없이 계좌를 개설할 수 없는 경우", "solution": "MUFG는 도장 대신 서명을 받습니다. 직원에게 말하세요: サインでお願いします"},
            ],
            "pt": [
                {"problem": "Não consigo abrir conta sem selo", "solution": "O MUFG aceita assinatura em vez de selo. Diga ao funcionário: サインでお願いします"},
            ],
        }),
        "sort_order": 1,
    },
    {
        "bank_code": "smbc",
        "bank_name": json.dumps({
            "en": "SMBC (Sumitomo Mitsui Banking)",
            "zh": "三井住友银行",
            "vi": "Ngân hàng SMBC (Sumitomo Mitsui)",
            "ko": "SMBC (스미토모 미쓰이 은행)",
            "pt": "Banco SMBC (Sumitomo Mitsui)",
        }),
        "bank_name_ja": "三井住友銀行",
        "logo_url": None,
        "multilingual_support": json.dumps(["en", "zh", "ko"]),
        "requirements": json.dumps({
            "residence_card": True,
            "min_stay_months": 0,
            "seal_or_signature": "either",
            "initial_deposit": 1,
            "documents": ["residence_card", "passport"],
        }),
        "features": json.dumps({
            "atm_count": 5600,
            "monthly_fee": 0,
            "online_banking": True,
            "debit_card": True,
            "international_transfer": True,
            "multilingual_atm": True,
        }),
        "foreigner_friendly_score": 4,
        "application_url": "https://www.smbc.co.jp/global/",
        "conversation_templates": json.dumps({
            "en": [
                {"situation": "Opening an account", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "I would like to open an account"},
                {"situation": "Asking about fees", "ja": "手数料はいくらですか", "reading": "てすうりょうはいくらですか", "translation": "How much is the fee?"},
            ],
            "zh": [
                {"situation": "开户", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "我想开一个账户"},
            ],
            "vi": [
                {"situation": "Mở tài khoản", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Tôi muốn mở tài khoản"},
            ],
            "ko": [
                {"situation": "계좌 개설", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "계좌를 개설하고 싶습니다"},
            ],
            "pt": [
                {"situation": "Abrir uma conta", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Gostaria de abrir uma conta"},
            ],
        }),
        "troubleshooting": json.dumps({
            "en": [
                {"problem": "Application rejected", "solution": "SMBC may reject applications from new arrivals. Try again after 3 months or try a different bank."},
                {"problem": "Can't use ATM after hours", "solution": "SMBC ATMs charge fees after banking hours (weekdays after 18:00, weekends). Use during business hours to avoid fees."},
            ],
            "zh": [{"problem": "申请被拒", "solution": "三井住友可能会拒绝新来日的申请。3个月后再试或尝试其他银行。"}],
            "vi": [{"problem": "Đơn bị từ chối", "solution": "SMBC có thể từ chối đơn của người mới đến. Thử lại sau 3 tháng hoặc thử ngân hàng khác."}],
            "ko": [{"problem": "신청 거절", "solution": "SMBC는 신규 입국자의 신청을 거부할 수 있습니다. 3개월 후에 다시 시도하거나 다른 은행을 시도하세요."}],
            "pt": [{"problem": "Aplicação rejeitada", "solution": "O SMBC pode rejeitar aplicações de recém-chegados. Tente novamente após 3 meses ou tente outro banco."}],
        }),
        "sort_order": 2,
    },
    {
        "bank_code": "mizuho",
        "bank_name": json.dumps({
            "en": "Mizuho Bank",
            "zh": "瑞穗银行",
            "vi": "Ngân hàng Mizuho",
            "ko": "미즈호 은행",
            "pt": "Banco Mizuho",
        }),
        "bank_name_ja": "みずほ銀行",
        "logo_url": None,
        "multilingual_support": json.dumps(["en", "zh"]),
        "requirements": json.dumps({
            "residence_card": True,
            "min_stay_months": 6,
            "seal_or_signature": "seal_preferred",
            "initial_deposit": 1,
            "documents": ["residence_card", "passport", "proof_of_address"],
        }),
        "features": json.dumps({
            "atm_count": 5400,
            "monthly_fee": 0,
            "online_banking": True,
            "debit_card": True,
            "international_transfer": True,
            "multilingual_atm": False,
        }),
        "foreigner_friendly_score": 3,
        "application_url": "https://www.mizuhobank.co.jp/english/",
        "conversation_templates": json.dumps({
            "en": [
                {"situation": "Opening an account", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "I would like to open an account"},
            ],
            "zh": [{"situation": "开户", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "我想开一个账户"}],
            "vi": [{"situation": "Mở tài khoản", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Tôi muốn mở tài khoản"}],
            "ko": [{"situation": "계좌 개설", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "계좌를 개설하고 싶습니다"}],
            "pt": [{"situation": "Abrir uma conta", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Gostaria de abrir uma conta"}],
        }),
        "troubleshooting": json.dumps({
            "en": [
                {"problem": "6-month residency requirement", "solution": "Mizuho generally requires 6 months of residency. New arrivals should try MUFG, Japan Post Bank, or Shinsei Bank instead."},
            ],
            "zh": [{"problem": "6个月居住要求", "solution": "瑞穗通常要求居住满6个月。新来者请尝试三菱UFJ、邮政银行或新生银行。"}],
            "vi": [{"problem": "Yêu cầu cư trú 6 tháng", "solution": "Mizuho thường yêu cầu cư trú 6 tháng. Người mới đến nên thử MUFG, Japan Post Bank, hoặc Shinsei Bank."}],
            "ko": [{"problem": "6개월 거주 요건", "solution": "미즈호는 일반적으로 6개월 거주를 요구합니다. 신규 입국자는 MUFG, 일본 우편은행, 또는 신세이은행을 시도하세요."}],
            "pt": [{"problem": "Requisito de 6 meses de residência", "solution": "O Mizuho geralmente exige 6 meses de residência. Recém-chegados devem tentar MUFG, Japan Post Bank ou Shinsei Bank."}],
        }),
        "sort_order": 3,
    },
    {
        "bank_code": "japan_post",
        "bank_name": json.dumps({
            "en": "Japan Post Bank (Yucho)",
            "zh": "邮储银行（ゆうちょ）",
            "vi": "Ngân hàng Bưu điện Nhật Bản (Yucho)",
            "ko": "일본 우편은행 (유초)",
            "pt": "Banco Postal do Japão (Yucho)",
        }),
        "bank_name_ja": "ゆうちょ銀行",
        "logo_url": None,
        "multilingual_support": json.dumps(["en"]),
        "requirements": json.dumps({
            "residence_card": True,
            "min_stay_months": 0,
            "seal_or_signature": "either",
            "initial_deposit": 0,
            "documents": ["residence_card"],
        }),
        "features": json.dumps({
            "atm_count": 31800,
            "monthly_fee": 0,
            "online_banking": True,
            "debit_card": True,
            "international_transfer": True,
            "multilingual_atm": False,
        }),
        "foreigner_friendly_score": 5,
        "application_url": "https://www.jp-bank.japanpost.jp/en/",
        "conversation_templates": json.dumps({
            "en": [
                {"situation": "Opening an account", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "I would like to open an account"},
                {"situation": "Sending money abroad", "ja": "海外に送金したいのですが", "reading": "かいがいにそうきんしたいのですが", "translation": "I would like to send money abroad"},
            ],
            "zh": [{"situation": "开户", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "我想开一个账户"}],
            "vi": [{"situation": "Mở tài khoản", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Tôi muốn mở tài khoản"}],
            "ko": [{"situation": "계좌 개설", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "계좌를 개설하고 싶습니다"}],
            "pt": [{"situation": "Abrir uma conta", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Gostaria de abrir uma conta"}],
        }),
        "troubleshooting": json.dumps({
            "en": [
                {"problem": "Post office vs bank branch", "solution": "Not all post offices offer full banking services. Look for 'ゆうちょ銀行' (Yucho Ginko) sign specifically."},
                {"problem": "ATM closing time", "solution": "Post office ATMs close earlier than convenience store ATMs. Check hours at your local branch."},
            ],
            "zh": [{"problem": "邮局和银行分行", "solution": "并非所有邮局都提供完整的银行服务。请特别找有'ゆうちょ銀行'标志的。"}],
            "vi": [{"problem": "Bưu điện vs chi nhánh ngân hàng", "solution": "Không phải tất cả bưu điện đều cung cấp dịch vụ ngân hàng đầy đủ. Hãy tìm biển 'ゆうちょ銀行'."}],
            "ko": [{"problem": "우체국 vs 은행 지점", "solution": "모든 우체국이 전체 은행 서비스를 제공하지는 않습니다. 'ゆうちょ銀行' 간판을 찾으세요."}],
            "pt": [{"problem": "Correio vs agência bancária", "solution": "Nem todos os correios oferecem serviços bancários completos. Procure a placa 'ゆうちょ銀行'."}],
        }),
        "sort_order": 4,
    },
    {
        "bank_code": "shinsei",
        "bank_name": json.dumps({
            "en": "Shinsei Bank (SBI Shinsei)",
            "zh": "新生银行 (SBI新生)",
            "vi": "Ngân hàng Shinsei (SBI Shinsei)",
            "ko": "신세이 은행 (SBI 신세이)",
            "pt": "Banco Shinsei (SBI Shinsei)",
        }),
        "bank_name_ja": "SBI新生銀行",
        "logo_url": None,
        "multilingual_support": json.dumps(["en", "zh", "ko"]),
        "requirements": json.dumps({
            "residence_card": True,
            "min_stay_months": 0,
            "seal_or_signature": "signature",
            "initial_deposit": 0,
            "documents": ["residence_card", "passport"],
        }),
        "features": json.dumps({
            "atm_count": 95000,
            "monthly_fee": 0,
            "online_banking": True,
            "debit_card": True,
            "international_transfer": True,
            "multilingual_atm": False,
        }),
        "foreigner_friendly_score": 5,
        "application_url": "https://www.sbishinseibank.co.jp/english/",
        "conversation_templates": json.dumps({
            "en": [
                {"situation": "Opening an account", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "I would like to open an account"},
                {"situation": "About free ATM", "ja": "ATMの無料回数を教えてください", "reading": "ATMのむりょうかいすうをおしえてください", "translation": "Please tell me about free ATM withdrawals"},
            ],
            "zh": [{"situation": "开户", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "我想开一个账户"}],
            "vi": [{"situation": "Mở tài khoản", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Tôi muốn mở tài khoản"}],
            "ko": [{"situation": "계좌 개설", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "계좌를 개설하고 싶습니다"}],
            "pt": [{"situation": "Abrir uma conta", "ja": "口座を開設したいのですが", "reading": "こうざをかいせつしたいのですが", "translation": "Gostaria de abrir uma conta"}],
        }),
        "troubleshooting": json.dumps({
            "en": [
                {"problem": "No seal required", "solution": "Shinsei Bank accepts signatures only — no seal (印鑑) needed. Very foreigner-friendly."},
                {"problem": "Free ATM usage", "solution": "Shinsei offers free withdrawals at convenience store ATMs (Seven Bank, Lawson, etc.) depending on your account tier."},
            ],
            "zh": [{"problem": "不需要印章", "solution": "新生银行只需签名，不需要印章。对外国人非常友好。"}],
            "vi": [{"problem": "Không cần con dấu", "solution": "Shinsei Bank chỉ cần chữ ký, không cần con dấu. Rất thân thiện với người nước ngoài."}],
            "ko": [{"problem": "도장 불필요", "solution": "신세이은행은 서명만 필요하며 도장이 필요 없습니다. 외국인에게 매우 친화적입니다."}],
            "pt": [{"problem": "Não precisa de selo", "solution": "O Shinsei Bank aceita apenas assinatura — não precisa de selo. Muito amigável para estrangeiros."}],
        }),
        "sort_order": 5,
    },
]


def seed():
    now = datetime.now(timezone.utc).isoformat()
    with engine.connect() as conn:
        # Check if data already exists
        result = conn.execute(text("SELECT COUNT(*) FROM banking_guides"))
        count = result.scalar()
        if count and count > 0:
            print(f"banking_guides already has {count} records. Clearing...")
            conn.execute(text("DELETE FROM banking_guides"))
            conn.commit()

        for bank in BANKS:
            conn.execute(
                text("""
                    INSERT INTO banking_guides
                    (id, bank_code, bank_name, bank_name_ja, logo_url,
                     multilingual_support, requirements, features,
                     foreigner_friendly_score, application_url,
                     conversation_templates, troubleshooting,
                     sort_order, is_active, created_at, updated_at)
                    VALUES
                    (:id, :bank_code, :bank_name, :bank_name_ja, :logo_url,
                     :multilingual_support, :requirements, :features,
                     :foreigner_friendly_score, :application_url,
                     :conversation_templates, :troubleshooting,
                     :sort_order, 1, :now, :now)
                """),
                {
                    "id": str(uuid.uuid4()),
                    "now": now,
                    **bank,
                },
            )
        conn.commit()
        print(f"✅ Seeded {len(BANKS)} banks into banking_guides.")


if __name__ == "__main__":
    seed()
