#!/usr/bin/env python3
"""Seed admin_procedures with essential + other administrative procedures.

Usage:
    DATABASE_URL=sqlite:///data/app.db python scripts/seed_admin.py
"""

import json
import os
import uuid
from datetime import datetime, timezone

_PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    f"sqlite:///{os.path.join(_PROJECT_ROOT, 'data', 'app.db')}",
)
DATABASE_URL = DATABASE_URL.replace("sqlite+aiosqlite", "sqlite")
DATABASE_URL = DATABASE_URL.replace("postgresql+asyncpg", "postgresql")

from sqlalchemy import create_engine, text

engine = create_engine(DATABASE_URL, echo=False)

PROCEDURES = [
    # ── 5 Arrival-essential procedures (is_arrival_essential=true) ──────
    {
        "procedure_code": "resident_registration",
        "procedure_name": json.dumps({
            "en": "Resident Registration (Moving-in Notification)",
            "zh": "住民登记（转入届）",
            "vi": "Đăng ký cư trú (Thông báo chuyển đến)",
            "ko": "주민등록 (전입신고)",
            "pt": "Registro de Residente (Notificação de Mudança)",
        }),
        "category": "arrival",
        "description": json.dumps({
            "en": "Register your address at your local city/ward office within 14 days of moving in. This is legally required and enables access to health insurance, pension, and other services.",
            "zh": "搬入后14天内在当地市区町村役所进行住民登记。这是法律要求，是加入健康保险、年金等服务的前提。",
            "vi": "Đăng ký địa chỉ tại văn phòng thành phố/phường trong vòng 14 ngày sau khi chuyển đến. Đây là yêu cầu pháp lý và cho phép tiếp cận bảo hiểm y tế, lương hưu và các dịch vụ khác.",
            "ko": "전입 후 14일 이내에 시/구청에서 주소를 등록하세요. 법적 의무이며, 건강보험, 연금 등의 서비스를 이용하기 위해 필요합니다.",
            "pt": "Registre seu endereço no escritório da cidade/bairro dentro de 14 dias após a mudança. É legalmente obrigatório e permite acesso ao seguro de saúde, previdência e outros serviços.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Residence card (在留カード)", "zh": "在留卡", "vi": "Thẻ cư trú", "ko": "재류카드", "pt": "Cartão de residência"}, "how_to_get": {"en": "Issued at airport upon arrival", "zh": "入境时在机场发行", "vi": "Được cấp tại sân bay khi đến", "ko": "도착 시 공항에서 발급", "pt": "Emitido no aeroporto na chegada"}},
            {"name": {"en": "Passport", "zh": "护照", "vi": "Hộ chiếu", "ko": "여권", "pt": "Passaporte"}, "how_to_get": {"en": "Your valid passport", "zh": "有效护照", "vi": "Hộ chiếu còn hiệu lực", "ko": "유효한 여권", "pt": "Seu passaporte válido"}},
            {"name": {"en": "Moving-in notification form (転入届)", "zh": "转入届", "vi": "Đơn thông báo chuyển đến", "ko": "전입신고서", "pt": "Formulário de notificação de mudança"}, "how_to_get": {"en": "Available at the city/ward office counter", "zh": "在市区町村役所柜台领取", "vi": "Có tại quầy văn phòng thành phố/phường", "ko": "시/구청 창구에서 수령", "pt": "Disponível no balcão do escritório da cidade/bairro"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Go to city/ward office", "zh": "前往市区町村役所", "vi": "Đến văn phòng thành phố/phường", "ko": "시/구청 방문", "pt": "Vá ao escritório da cidade/bairro"}, "description": {"en": "Bring your residence card and passport. Look for the resident registration (住民登録) counter.", "zh": "携带在留卡和护照。寻找住民登录柜台。", "vi": "Mang thẻ cư trú và hộ chiếu. Tìm quầy đăng ký cư trú.", "ko": "재류카드와 여권을 지참하세요. 주민등록 창구를 찾으세요.", "pt": "Leve seu cartão de residência e passaporte. Procure o balcão de registro de residentes."}},
            {"order": 2, "title": {"en": "Fill and submit the form", "zh": "填写并提交", "vi": "Điền và nộp đơn", "ko": "양식 작성 및 제출", "pt": "Preencha e envie o formulário"}, "description": {"en": "Fill out the moving-in notification form. Staff will update your residence card with your address.", "zh": "填写转入届。工作人员会在在留卡上记载您的地址。", "vi": "Điền đơn thông báo chuyển đến. Nhân viên sẽ cập nhật địa chỉ trên thẻ cư trú.", "ko": "전입신고서를 작성하세요. 직원이 재류카드에 주소를 기재합니다.", "pt": "Preencha o formulário de notificação de mudança. O funcionário atualizará seu cartão com o endereço."}},
        ]),
        "deadline_rule": json.dumps({"type": "within_days_of_arrival", "days": 14}),
        "office_info": json.dumps({"name": {"en": "City/Ward Office (市区町村役所)", "zh": "市区町村役所", "vi": "Văn phòng Thành phố/Phường", "ko": "시/구청", "pt": "Escritório da Cidade/Bairro"}, "typical_hours": "8:30-17:00 (weekdays)"}),
        "tips": json.dumps({
            "en": "Go on a weekday morning for shorter wait times. Some offices have multilingual staff or interpreter tablets.",
            "zh": "工作日上午去等待时间较短。部分役所有多语言工作人员或翻译平板。",
            "vi": "Đi vào buổi sáng ngày thường để chờ ít hơn. Một số văn phòng có nhân viên đa ngôn ngữ hoặc máy tính bảng phiên dịch.",
            "ko": "평일 오전에 가면 대기 시간이 짧습니다. 일부 사무소에는 다국어 직원이나 통역 태블릿이 있습니다.",
            "pt": "Vá pela manhã em dia útil para esperar menos. Alguns escritórios têm funcionários multilíngues ou tablets de tradução.",
        }),
        "is_arrival_essential": True,
        "sort_order": 1,
    },
    {
        "procedure_code": "national_health_insurance",
        "procedure_name": json.dumps({
            "en": "National Health Insurance (NHI) Enrollment",
            "zh": "加入国民健康保险",
            "vi": "Đăng ký Bảo hiểm Y tế Quốc dân",
            "ko": "국민건강보험 가입",
            "pt": "Inscrição no Seguro Nacional de Saúde",
        }),
        "category": "insurance",
        "description": json.dumps({
            "en": "Enroll in National Health Insurance (国民健康保険) at your city/ward office. This covers 70% of medical costs. Required for residents not covered by employer's health insurance.",
            "zh": "在市区町村役所加入国民健康保险。可报销70%的医疗费用。未加入公司社会保险的居民必须加入。",
            "vi": "Đăng ký Bảo hiểm Y tế Quốc dân (国民健康保険) tại văn phòng thành phố/phường. Bảo hiểm chi trả 70% chi phí y tế. Bắt buộc cho cư dân không có bảo hiểm y tế từ công ty.",
            "ko": "시/구청에서 국민건강보험(国民健康保険)에 가입하세요. 의료비의 70%를 보장합니다. 회사 건강보험에 가입하지 않은 주민은 필수입니다.",
            "pt": "Inscreva-se no Seguro Nacional de Saúde (国民健康保険) no escritório da cidade/bairro. Cobre 70% dos custos médicos. Obrigatório para residentes não cobertos pelo seguro do empregador.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Residence card", "zh": "在留卡", "vi": "Thẻ cư trú", "ko": "재류카드", "pt": "Cartão de residência"}, "how_to_get": {"en": "Your residence card with address", "zh": "已记载地址的在留卡", "vi": "Thẻ cư trú đã ghi địa chỉ", "ko": "주소가 기재된 재류카드", "pt": "Seu cartão de residência com endereço"}},
            {"name": {"en": "Passport", "zh": "护照", "vi": "Hộ chiếu", "ko": "여권", "pt": "Passaporte"}, "how_to_get": {"en": "Your valid passport", "zh": "有效护照", "vi": "Hộ chiếu còn hiệu lực", "ko": "유효한 여권", "pt": "Seu passaporte válido"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Apply at city office", "zh": "在役所申请", "vi": "Nộp đơn tại văn phòng thành phố", "ko": "시청에서 신청", "pt": "Solicite no escritório da cidade"}, "description": {"en": "Visit the NHI counter (国民健康保険窓口) at your city/ward office. You can do this at the same time as resident registration.", "zh": "前往役所的国民健康保险窗口。可以和住民登记同时办理。", "vi": "Đến quầy NHI (国民健康保険窓口) tại văn phòng thành phố/phường. Có thể làm cùng lúc với đăng ký cư trú.", "ko": "시/구청의 국민건강보험 창구를 방문하세요. 주민등록과 동시에 할 수 있습니다.", "pt": "Visite o balcão do NHI (国民健康保険窓口) no escritório da cidade/bairro. Pode fazer ao mesmo tempo que o registro de residente."}},
            {"order": 2, "title": {"en": "Receive insurance card", "zh": "领取保险证", "vi": "Nhận thẻ bảo hiểm", "ko": "보험증 수령", "pt": "Receba o cartão de seguro"}, "description": {"en": "You'll receive your health insurance card (保険証) by mail within 1-2 weeks.", "zh": "1-2周内会通过邮件收到健康保险证。", "vi": "Bạn sẽ nhận thẻ bảo hiểm y tế (保険証) qua đường bưu điện trong 1-2 tuần.", "ko": "1-2주 내에 건강보험증(保険証)을 우편으로 받게 됩니다.", "pt": "Receberá o cartão de seguro (保険証) pelo correio em 1-2 semanas."}},
        ]),
        "deadline_rule": json.dumps({"type": "within_days_of_arrival", "days": 14}),
        "office_info": json.dumps({"name": {"en": "City/Ward Office — NHI Counter", "zh": "市区町村役所 — 国民健康保险窗口", "vi": "Văn phòng Thành phố — Quầy NHI", "ko": "시/구청 — 국민건강보험 창구", "pt": "Escritório da Cidade — Balcão NHI"}, "typical_hours": "8:30-17:00 (weekdays)"}),
        "tips": json.dumps({
            "en": "Premiums are based on your income from the previous year. First-year residents usually pay the minimum.",
            "zh": "保险费根据前一年收入计算。第一年的居民通常只需缴纳最低费用。",
            "vi": "Phí bảo hiểm dựa trên thu nhập năm trước. Cư dân năm đầu tiên thường trả mức tối thiểu.",
            "ko": "보험료는 전년도 소득을 기준으로 합니다. 첫 해 주민은 보통 최소 금액을 납부합니다.",
            "pt": "Os prêmios são baseados na renda do ano anterior. Residentes do primeiro ano geralmente pagam o mínimo.",
        }),
        "is_arrival_essential": True,
        "sort_order": 2,
    },
    {
        "procedure_code": "national_pension",
        "procedure_name": json.dumps({
            "en": "National Pension Enrollment",
            "zh": "加入国民年金",
            "vi": "Đăng ký Lương hưu Quốc dân",
            "ko": "국민연금 가입",
            "pt": "Inscrição na Previdência Nacional",
        }),
        "category": "pension",
        "description": json.dumps({
            "en": "All residents aged 20-59 must enroll in the National Pension (国民年金) system. If you leave Japan, you may be eligible for a lump-sum withdrawal payment.",
            "zh": "20-59岁的所有居民必须加入国民年金制度。离开日本时可能有资格获得一次性退还。",
            "vi": "Tất cả cư dân từ 20-59 tuổi phải đăng ký hệ thống Lương hưu Quốc dân (国民年金). Nếu rời Nhật Bản, bạn có thể được nhận tiền hoàn trả một lần.",
            "ko": "20-59세 모든 주민은 국민연금(国民年金)에 가입해야 합니다. 일본을 떠날 때 일시금 탈퇴를 받을 수 있습니다.",
            "pt": "Todos os residentes de 20-59 anos devem se inscrever no sistema de Previdência Nacional (国民年金). Se sair do Japão, pode ser elegível para um pagamento de retirada em valor único.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Residence card", "zh": "在留卡", "vi": "Thẻ cư trú", "ko": "재류카드", "pt": "Cartão de residência"}, "how_to_get": {"en": "Your residence card with address", "zh": "已记载地址的在留卡", "vi": "Thẻ cư trú đã ghi địa chỉ", "ko": "주소가 기재된 재류카드", "pt": "Seu cartão de residência com endereço"}},
            {"name": {"en": "Passport", "zh": "护照", "vi": "Hộ chiếu", "ko": "여권", "pt": "Passaporte"}, "how_to_get": {"en": "Your valid passport", "zh": "有效护照", "vi": "Hộ chiếu còn hiệu lực", "ko": "유효한 여권", "pt": "Seu passaporte válido"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Enroll at city office or pension office", "zh": "在役所或年金事务所办理", "vi": "Đăng ký tại văn phòng thành phố hoặc văn phòng lương hưu", "ko": "시청 또는 연금사무소에서 가입", "pt": "Inscreva-se no escritório da cidade ou escritório de previdência"}, "description": {"en": "Visit the pension counter at your city/ward office. You can often do this along with resident registration.", "zh": "前往役所的年金窗口。通常可以和住民登记一起办理。", "vi": "Đến quầy lương hưu tại văn phòng thành phố/phường. Thường có thể làm cùng với đăng ký cư trú.", "ko": "시/구청의 연금 창구를 방문하세요. 주민등록과 함께 할 수 있습니다.", "pt": "Visite o balcão de previdência no escritório da cidade/bairro. Pode fazer junto com o registro de residente."}},
            {"order": 2, "title": {"en": "Receive pension handbook", "zh": "领取年金手册", "vi": "Nhận sổ tay lương hưu", "ko": "연금수첩 수령", "pt": "Receba o manual de previdência"}, "description": {"en": "You'll receive a pension handbook (年金手帳) with your pension number.", "zh": "会收到记载年金号码的年金手帳。", "vi": "Bạn sẽ nhận sổ tay lương hưu (年金手帳) với số lương hưu của bạn.", "ko": "연금 번호가 기재된 연금수첩(年金手帳)을 받게 됩니다.", "pt": "Receberá um manual de previdência (年金手帳) com seu número de previdência."}},
        ]),
        "deadline_rule": json.dumps({"type": "within_days_of_arrival", "days": 14}),
        "office_info": json.dumps({"name": {"en": "City/Ward Office — Pension Counter or Japan Pension Service", "zh": "市区町村役所 — 年金窗口", "vi": "Văn phòng Thành phố — Quầy Lương hưu", "ko": "시/구청 — 연금 창구", "pt": "Escritório da Cidade — Balcão de Previdência"}, "typical_hours": "8:30-17:00 (weekdays)"}),
        "tips": json.dumps({
            "en": "Current monthly premium is about ¥16,980 (2024). Students can apply for exemption. If you pay for 6+ months and leave Japan, you can claim a lump-sum withdrawal.",
            "zh": "目前每月保险费约16,980日元（2024年）。学生可以申请免除。如果缴费6个月以上后离开日本，可以申请一次性退还。",
            "vi": "Phí hàng tháng hiện tại khoảng ¥16,980 (2024). Du học sinh có thể xin miễn. Nếu đóng 6+ tháng và rời Nhật, có thể yêu cầu hoàn trả một lần.",
            "ko": "현재 월 보험료는 약 ¥16,980 (2024년)입니다. 학생은 면제를 신청할 수 있습니다. 6개월 이상 납부 후 일본을 떠나면 일시금 탈퇴를 청구할 수 있습니다.",
            "pt": "O prêmio mensal atual é cerca de ¥16.980 (2024). Estudantes podem solicitar isenção. Se pagar por 6+ meses e sair do Japão, pode solicitar retirada em valor único.",
        }),
        "is_arrival_essential": True,
        "sort_order": 3,
    },
    {
        "procedure_code": "bank_account",
        "procedure_name": json.dumps({
            "en": "Bank Account Opening",
            "zh": "银行开户",
            "vi": "Mở tài khoản ngân hàng",
            "ko": "은행 계좌 개설",
            "pt": "Abertura de Conta Bancária",
        }),
        "category": "arrival",
        "description": json.dumps({
            "en": "Open a bank account to receive salary and make payments. Some banks accept new arrivals, while others require 6 months of residency.",
            "zh": "开设银行账户用于接收工资和支付。部分银行接受新来日的外国人，而有些银行要求居住满6个月。",
            "vi": "Mở tài khoản ngân hàng để nhận lương và thanh toán. Một số ngân hàng chấp nhận người mới đến, trong khi những ngân hàng khác yêu cầu cư trú 6 tháng.",
            "ko": "급여를 받고 결제를 하기 위해 은행 계좌를 개설하세요. 일부 은행은 신규 입국자를 받지만, 6개월 거주를 요구하는 은행도 있습니다.",
            "pt": "Abra uma conta bancária para receber salário e fazer pagamentos. Alguns bancos aceitam recém-chegados, enquanto outros exigem 6 meses de residência.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Residence card with address", "zh": "已记载地址的在留卡", "vi": "Thẻ cư trú có địa chỉ", "ko": "주소가 기재된 재류카드", "pt": "Cartão de residência com endereço"}, "how_to_get": {"en": "After resident registration", "zh": "住民登记后", "vi": "Sau khi đăng ký cư trú", "ko": "주민등록 후", "pt": "Após registro de residente"}},
            {"name": {"en": "Passport", "zh": "护照", "vi": "Hộ chiếu", "ko": "여권", "pt": "Passaporte"}, "how_to_get": {"en": "Your valid passport", "zh": "有效护照", "vi": "Hộ chiếu còn hiệu lực", "ko": "유효한 여권", "pt": "Seu passaporte válido"}},
            {"name": {"en": "Seal (印鑑) or signature", "zh": "印章或签名", "vi": "Con dấu (印鑑) hoặc chữ ký", "ko": "도장 (印鑑) 또는 서명", "pt": "Selo (印鑑) ou assinatura"}, "how_to_get": {"en": "Some banks accept signature. See Banking Navigator for details.", "zh": "部分银行接受签名。详见Banking Navigator。", "vi": "Một số ngân hàng chấp nhận chữ ký. Xem Banking Navigator để biết chi tiết.", "ko": "일부 은행은 서명을 받습니다. Banking Navigator를 참조하세요.", "pt": "Alguns bancos aceitam assinatura. Veja o Banking Navigator para detalhes."}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Choose a bank", "zh": "选择银行", "vi": "Chọn ngân hàng", "ko": "은행 선택", "pt": "Escolha um banco"}, "description": {"en": "Use the Banking Navigator to find the best bank for your situation.", "zh": "使用Banking Navigator找到最适合您情况的银行。", "vi": "Sử dụng Banking Navigator để tìm ngân hàng phù hợp nhất.", "ko": "Banking Navigator를 사용하여 상황에 맞는 최적의 은행을 찾으세요.", "pt": "Use o Banking Navigator para encontrar o melhor banco para sua situação."}},
            {"order": 2, "title": {"en": "Visit the branch", "zh": "前往分行", "vi": "Đến chi nhánh", "ko": "지점 방문", "pt": "Visite a agência"}, "description": {"en": "Go to the nearest branch with your documents. Tell the staff you want to open an account.", "zh": "携带证件前往最近的分行。告诉工作人员您要开户。", "vi": "Đến chi nhánh gần nhất với giấy tờ. Nói với nhân viên bạn muốn mở tài khoản.", "ko": "서류를 가지고 가장 가까운 지점을 방문하세요. 직원에게 계좌를 개설하고 싶다고 말하세요.", "pt": "Vá à agência mais próxima com seus documentos. Diga ao funcionário que quer abrir uma conta."}},
        ]),
        "deadline_rule": None,
        "office_info": None,
        "tips": json.dumps({
            "en": "Japan Post Bank (ゆうちょ銀行) and Shinsei Bank are the most foreigner-friendly. See Banking Navigator for recommendations.",
            "zh": "邮储银行和新生银行对外国人最友好。详见Banking Navigator推荐。",
            "vi": "Japan Post Bank (ゆうちょ銀行) và Shinsei Bank thân thiện nhất với người nước ngoài. Xem Banking Navigator để được giới thiệu.",
            "ko": "일본 우편은행(ゆうちょ銀行)과 신세이은행이 외국인에게 가장 친화적입니다. Banking Navigator의 추천을 참조하세요.",
            "pt": "Japan Post Bank (ゆうちょ銀行) e Shinsei Bank são os mais amigáveis para estrangeiros. Veja o Banking Navigator para recomendações.",
        }),
        "is_arrival_essential": True,
        "sort_order": 4,
    },
    {
        "procedure_code": "phone_contract",
        "procedure_name": json.dumps({
            "en": "Mobile Phone / SIM Card Contract",
            "zh": "手机/SIM卡合同",
            "vi": "Hợp đồng Điện thoại / SIM",
            "ko": "휴대폰 / SIM 카드 계약",
            "pt": "Contrato de Celular / SIM Card",
        }),
        "category": "arrival",
        "description": json.dumps({
            "en": "Get a Japanese phone number and mobile service. Options include major carriers (docomo, au, SoftBank), budget MVNOs, or prepaid SIMs.",
            "zh": "获取日本手机号和移动服务。可选择大手运营商（docomo、au、SoftBank）、格安SIM或预付费SIM。",
            "vi": "Lấy số điện thoại và dịch vụ di động Nhật Bản. Các lựa chọn bao gồm nhà mạng lớn (docomo, au, SoftBank), MVNO giá rẻ, hoặc SIM trả trước.",
            "ko": "일본 전화번호와 모바일 서비스를 받으세요. 대형 통신사(docomo, au, SoftBank), 저가 MVNO 또는 선불 SIM 중에서 선택할 수 있습니다.",
            "pt": "Obtenha um número de telefone e serviço móvel japonês. Opções incluem operadoras principais (docomo, au, SoftBank), MVNOs econômicas ou SIMs pré-pagos.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Residence card", "zh": "在留卡", "vi": "Thẻ cư trú", "ko": "재류카드", "pt": "Cartão de residência"}, "how_to_get": {"en": "Your residence card", "zh": "在留卡", "vi": "Thẻ cư trú", "ko": "재류카드", "pt": "Seu cartão de residência"}},
            {"name": {"en": "Bank account (for monthly billing)", "zh": "银行账户（用于月付）", "vi": "Tài khoản ngân hàng (cho thanh toán hàng tháng)", "ko": "은행 계좌 (월별 청구용)", "pt": "Conta bancária (para cobrança mensal)"}, "how_to_get": {"en": "Open a bank account first", "zh": "先开设银行账户", "vi": "Mở tài khoản ngân hàng trước", "ko": "먼저 은행 계좌를 개설하세요", "pt": "Abra uma conta bancária primeiro"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Choose a provider", "zh": "选择运营商", "vi": "Chọn nhà cung cấp", "ko": "통신사 선택", "pt": "Escolha um provedor"}, "description": {"en": "Compare carriers: budget MVNOs (Sakura Mobile, GTN Mobile) are foreigner-friendly. Major carriers offer more coverage.", "zh": "比较运营商：格安SIM（Sakura Mobile, GTN Mobile）对外国人友好。大手运营商覆盖更广。", "vi": "So sánh nhà mạng: MVNO giá rẻ (Sakura Mobile, GTN Mobile) thân thiện với người nước ngoài. Nhà mạng lớn có phủ sóng rộng hơn.", "ko": "통신사를 비교하세요: 저가 MVNO(Sakura Mobile, GTN Mobile)가 외국인에게 친화적입니다. 대형 통신사는 더 넓은 커버리지를 제공합니다.", "pt": "Compare operadoras: MVNOs econômicas (Sakura Mobile, GTN Mobile) são amigáveis para estrangeiros. Operadoras principais oferecem mais cobertura."}},
            {"order": 2, "title": {"en": "Visit store or apply online", "zh": "前往门店或在线申请", "vi": "Đến cửa hàng hoặc đăng ký trực tuyến", "ko": "매장 방문 또는 온라인 신청", "pt": "Visite a loja ou solicite online"}, "description": {"en": "Bring your residence card and bank details to sign up.", "zh": "携带在留卡和银行信息前往签约。", "vi": "Mang thẻ cư trú và thông tin ngân hàng để đăng ký.", "ko": "재류카드와 은행 정보를 가지고 가입하세요.", "pt": "Leve seu cartão de residência e dados bancários para se inscrever."}},
        ]),
        "deadline_rule": None,
        "office_info": None,
        "tips": json.dumps({
            "en": "For the first few days, buy a prepaid data SIM at the airport. Then set up a proper contract after getting a bank account.",
            "zh": "最初几天在机场购买预付费数据SIM。然后在开设银行账户后再办理正式合同。",
            "vi": "Vài ngày đầu, mua SIM data trả trước tại sân bay. Sau đó thiết lập hợp đồng chính thức sau khi có tài khoản ngân hàng.",
            "ko": "처음 며칠은 공항에서 선불 데이터 SIM을 구입하세요. 은행 계좌 개설 후 정식 계약을 하세요.",
            "pt": "Nos primeiros dias, compre um SIM de dados pré-pago no aeroporto. Depois faça um contrato adequado após abrir a conta bancária.",
        }),
        "is_arrival_essential": True,
        "sort_order": 5,
    },
    # ── Non-essential procedures ───────────────────────────────────────
    {
        "procedure_code": "tax_registration",
        "procedure_name": json.dumps({
            "en": "Tax Registration (My Number Card)",
            "zh": "税务登记（个人编号卡）",
            "vi": "Đăng ký thuế (Thẻ My Number)",
            "ko": "세금 등록 (마이넘버 카드)",
            "pt": "Registro Fiscal (Cartão My Number)",
        }),
        "category": "tax",
        "description": json.dumps({
            "en": "After resident registration, you will be assigned a My Number (マイナンバー). You can optionally apply for a My Number Card, which serves as official ID and is needed for tax filing.",
            "zh": "住民登记后会被分配个人编号（マイナンバー）。可以选择申请个人编号卡，可作为身份证件使用，报税时需要。",
            "vi": "Sau khi đăng ký cư trú, bạn sẽ được cấp My Number (マイナンバー). Bạn có thể tùy chọn đăng ký Thẻ My Number, dùng làm giấy tờ tùy thân chính thức và cần cho khai thuế.",
            "ko": "주민등록 후 마이넘버(マイナンバー)가 부여됩니다. 선택적으로 마이넘버 카드를 신청할 수 있으며, 공식 신분증 및 세금 신고에 필요합니다.",
            "pt": "Após o registro de residente, será atribuído um My Number (マイナンバー). Pode opcionalmente solicitar um Cartão My Number, que serve como ID oficial e é necessário para declaração de impostos.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "My Number notification letter", "zh": "个人编号通知书", "vi": "Thư thông báo My Number", "ko": "마이넘버 통지서", "pt": "Carta de notificação My Number"}, "how_to_get": {"en": "Sent by mail after resident registration", "zh": "住民登记后邮寄", "vi": "Gửi qua bưu điện sau khi đăng ký cư trú", "ko": "주민등록 후 우편으로 발송", "pt": "Enviada pelo correio após registro de residente"}},
            {"name": {"en": "Photo (for card application)", "zh": "照片（申请卡片用）", "vi": "Ảnh (để đăng ký thẻ)", "ko": "사진 (카드 신청용)", "pt": "Foto (para aplicação do cartão)"}, "how_to_get": {"en": "Take at photo booth", "zh": "在证件照机拍摄", "vi": "Chụp tại ki-ốt ảnh", "ko": "사진 부스에서 촬영", "pt": "Tire em cabine fotográfica"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Receive My Number notification", "zh": "收到个人编号通知", "vi": "Nhận thông báo My Number", "ko": "마이넘버 통지 수령", "pt": "Receba notificação My Number"}, "description": {"en": "You'll receive a notification letter with your 12-digit My Number within 1-2 months of resident registration.", "zh": "住民登记后1-2个月内会收到记载12位个人编号的通知书。", "vi": "Bạn sẽ nhận thư thông báo với số My Number 12 chữ số trong 1-2 tháng sau đăng ký cư trú.", "ko": "주민등록 후 1-2개월 내에 12자리 마이넘버가 기재된 통지서를 받게 됩니다.", "pt": "Receberá uma carta de notificação com seu My Number de 12 dígitos dentro de 1-2 meses do registro de residente."}},
            {"order": 2, "title": {"en": "Apply for My Number Card (optional)", "zh": "申请个人编号卡（可选）", "vi": "Đăng ký Thẻ My Number (tùy chọn)", "ko": "마이넘버 카드 신청 (선택)", "pt": "Solicite Cartão My Number (opcional)"}, "description": {"en": "Apply online, by mail, or at a designated photo booth. Card is free.", "zh": "可网上申请、邮寄申请或在指定证件照机申请。卡片免费。", "vi": "Đăng ký trực tuyến, qua bưu điện, hoặc tại ki-ốt ảnh chỉ định. Thẻ miễn phí.", "ko": "온라인, 우편 또는 지정 사진 부스에서 신청할 수 있습니다. 카드는 무료입니다.", "pt": "Solicite online, pelo correio ou em cabine fotográfica designada. O cartão é gratuito."}},
        ]),
        "deadline_rule": None,
        "office_info": json.dumps({"name": {"en": "City/Ward Office", "zh": "市区町村役所", "vi": "Văn phòng Thành phố/Phường", "ko": "시/구청", "pt": "Escritório da Cidade/Bairro"}, "typical_hours": "8:30-17:00 (weekdays)"}),
        "tips": None,
        "is_arrival_essential": False,
        "sort_order": 6,
    },
    {
        "procedure_code": "drivers_license",
        "procedure_name": json.dumps({
            "en": "Driver's License Conversion",
            "zh": "驾照转换",
            "vi": "Chuyển đổi bằng lái xe",
            "ko": "운전면허 전환",
            "pt": "Conversão de Carteira de Motorista",
        }),
        "category": "residence",
        "description": json.dumps({
            "en": "Convert your foreign driver's license to a Japanese one. Requirements vary by country. Some countries have agreements allowing direct conversion.",
            "zh": "将外国驾照转换为日本驾照。要求因国家而异。部分国家有直接转换协议。",
            "vi": "Chuyển đổi bằng lái nước ngoài sang bằng lái Nhật Bản. Yêu cầu khác nhau tùy theo quốc gia. Một số quốc gia có thỏa thuận cho phép chuyển đổi trực tiếp.",
            "ko": "외국 운전면허를 일본 면허로 전환합니다. 요건은 국가에 따라 다릅니다. 일부 국가는 직접 전환이 가능한 협정이 있습니다.",
            "pt": "Converta sua carteira de motorista estrangeira para uma japonesa. Os requisitos variam por país. Alguns países têm acordos permitindo conversão direta.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Foreign driver's license + Japanese translation", "zh": "外国驾照 + 日语翻译", "vi": "Bằng lái nước ngoài + bản dịch tiếng Nhật", "ko": "외국 운전면허 + 일본어 번역", "pt": "Carteira de motorista estrangeira + tradução japonesa"}, "how_to_get": {"en": "Get translation from JAF (Japan Automobile Federation)", "zh": "在JAF（日本自动车联盟）办理翻译", "vi": "Dịch tại JAF (Liên đoàn Ô tô Nhật Bản)", "ko": "JAF(일본자동차연맹)에서 번역 받기", "pt": "Obtenha tradução da JAF (Federação Automobilística do Japão)"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Get license translated by JAF", "zh": "在JAF翻译驾照", "vi": "Dịch bằng lái tại JAF", "ko": "JAF에서 면허 번역", "pt": "Traduza a carteira pela JAF"}, "description": {"en": "Visit JAF office for official translation (about ¥4,000).", "zh": "前往JAF办公室办理正式翻译（约4,000日元）。", "vi": "Đến văn phòng JAF để dịch chính thức (khoảng ¥4,000).", "ko": "JAF 사무소를 방문하여 공식 번역을 받으세요 (약 ¥4,000).", "pt": "Visite o escritório da JAF para tradução oficial (cerca de ¥4.000)."}},
            {"order": 2, "title": {"en": "Apply at driving license center", "zh": "在驾照中心申请", "vi": "Nộp đơn tại trung tâm bằng lái", "ko": "운전면허 시험장에서 신청", "pt": "Solicite no centro de habilitação"}, "description": {"en": "Visit your prefectural driving license center with documents.", "zh": "携带证件前往所在都道府县的驾照中心。", "vi": "Đến trung tâm bằng lái của tỉnh với hồ sơ.", "ko": "서류를 가지고 관할 운전면허 시험장을 방문하세요.", "pt": "Visite o centro de habilitação da sua prefeitura com os documentos."}},
        ]),
        "deadline_rule": None,
        "office_info": None,
        "tips": None,
        "is_arrival_essential": False,
        "sort_order": 7,
    },
]


def seed():
    now = datetime.now(timezone.utc).isoformat()
    with engine.connect() as conn:
        result = conn.execute(text("SELECT COUNT(*) FROM admin_procedures"))
        count = result.scalar()
        if count and count > 0:
            print(f"admin_procedures already has {count} records. Clearing...")
            conn.execute(text("DELETE FROM admin_procedures"))
            conn.commit()

        for proc in PROCEDURES:
            conn.execute(
                text("""
                    INSERT INTO admin_procedures
                    (id, procedure_code, procedure_name, category, description,
                     required_documents, steps, deadline_rule, office_info,
                     tips, is_arrival_essential, sort_order, is_active,
                     created_at, updated_at)
                    VALUES
                    (:id, :procedure_code, :procedure_name, :category, :description,
                     :required_documents, :steps, :deadline_rule, :office_info,
                     :tips, :is_arrival_essential, :sort_order, 1,
                     :now, :now)
                """),
                {
                    "id": str(uuid.uuid4()),
                    "now": now,
                    **proc,
                },
            )
        conn.commit()
        essential_count = sum(1 for p in PROCEDURES if p["is_arrival_essential"])
        print(f"✅ Seeded {len(PROCEDURES)} admin procedures ({essential_count} arrival-essential).")


if __name__ == "__main__":
    seed()
