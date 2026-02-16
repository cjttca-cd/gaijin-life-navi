#!/usr/bin/env python3
"""Seed visa_procedures with 6 procedure templates.

Usage:
    DATABASE_URL=sqlite:///data/app.db python scripts/seed_visa.py
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
    {
        "procedure_type": "renewal",
        "title": json.dumps({
            "en": "Status of Residence Renewal",
            "zh": "在留资格更新",
            "vi": "Gia hạn tư cách lưu trú",
            "ko": "재류자격 갱신",
            "pt": "Renovação do Status de Residência",
        }),
        "description": json.dumps({
            "en": "Renew your current status of residence before it expires. Apply at the Immigration Services Agency (出入国在留管理局). You can apply up to 3 months before expiry.",
            "zh": "在留资格到期前进行更新。在出入国在留管理局申请。可在到期前3个月内申请。",
            "vi": "Gia hạn tư cách lưu trú hiện tại trước khi hết hạn. Nộp đơn tại Cục Quản lý Xuất nhập cảnh và Lưu trú. Có thể nộp đơn trước 3 tháng khi hết hạn.",
            "ko": "현재 재류자격이 만료되기 전에 갱신하세요. 출입국재류관리국에서 신청합니다. 만료 3개월 전부터 신청 가능합니다.",
            "pt": "Renove seu status de residência atual antes de expirar. Solicite na Agência de Serviços de Imigração. Pode solicitar até 3 meses antes do vencimento.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Application form (在留期間更新許可申請書)", "zh": "申请表（在留期间更新许可申请书）", "vi": "Đơn xin (在留期間更新許可申請書)", "ko": "신청서 (재류기간 갱신허가 신청서)", "pt": "Formulário de inscrição (在留期間更新許可申請書)"}, "how_to_get": {"en": "Download from ISA website or get at the immigration office", "zh": "从ISA网站下载或在出入国管理局领取", "vi": "Tải từ trang web ISA hoặc nhận tại văn phòng nhập cư", "ko": "ISA 웹사이트에서 다운로드 또는 출입국관리국에서 수령", "pt": "Baixe do site da ISA ou obtenha no escritório de imigração"}},
            {"name": {"en": "Passport", "zh": "护照", "vi": "Hộ chiếu", "ko": "여권", "pt": "Passaporte"}, "how_to_get": {"en": "Your valid passport", "zh": "有效护照", "vi": "Hộ chiếu còn hiệu lực", "ko": "유효한 여권", "pt": "Seu passaporte válido"}},
            {"name": {"en": "Residence card (在留カード)", "zh": "在留卡", "vi": "Thẻ cư trú (在留カード)", "ko": "재류카드", "pt": "Cartão de residência (在留カード)"}, "how_to_get": {"en": "Your current residence card", "zh": "现有在留卡", "vi": "Thẻ cư trú hiện tại", "ko": "현재 재류카드", "pt": "Seu cartão de residência atual"}},
            {"name": {"en": "Photo (4cm × 3cm)", "zh": "照片 (4cm × 3cm)", "vi": "Ảnh (4cm × 3cm)", "ko": "사진 (4cm × 3cm)", "pt": "Foto (4cm × 3cm)"}, "how_to_get": {"en": "Take at photo booth or photo studio", "zh": "在证件照机或照相馆拍摄", "vi": "Chụp tại ki-ốt ảnh hoặc studio", "ko": "사진 부스 또는 사진관에서 촬영", "pt": "Tire em cabine fotográfica ou estúdio"}},
            {"name": {"en": "Certificate of tax payment or withholding slip", "zh": "纳税证明或源泉征收票", "vi": "Giấy chứng nhận nộp thuế", "ko": "납세 증명서 또는 원천징수표", "pt": "Certificado de pagamento de impostos"}, "how_to_get": {"en": "From your employer or tax office", "zh": "从公司或税务署获取", "vi": "Từ công ty hoặc sở thuế", "ko": "회사 또는 세무서에서 발급", "pt": "Do seu empregador ou escritório fiscal"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Prepare documents", "zh": "准备材料", "vi": "Chuẩn bị hồ sơ", "ko": "서류 준비", "pt": "Preparar documentos"}, "description": {"en": "Gather all required documents. Check ISA website for your specific status.", "zh": "收集所有必要文件。在ISA网站确认您的具体资格要求。", "vi": "Thu thập tất cả hồ sơ cần thiết. Kiểm tra trang web ISA cho tư cách cụ thể của bạn.", "ko": "모든 필요 서류를 준비하세요. ISA 웹사이트에서 구체적인 자격을 확인하세요.", "pt": "Reúna todos os documentos necessários. Verifique o site da ISA para seu status específico."}},
            {"order": 2, "title": {"en": "Visit immigration office", "zh": "前往出入国管理局", "vi": "Đến văn phòng nhập cư", "ko": "출입국관리국 방문", "pt": "Visite o escritório de imigração"}, "description": {"en": "Go to your local Immigration Services Agency. Take a number and wait for your turn.", "zh": "前往当地出入国在留管理局。取号等候。", "vi": "Đến Cục Quản lý Xuất nhập cảnh địa phương. Lấy số và đợi đến lượt.", "ko": "관할 출입국재류관리국을 방문하세요. 번호표를 뽑고 대기하세요.", "pt": "Vá ao escritório local da Agência de Serviços de Imigração. Pegue uma senha e aguarde."}},
            {"order": 3, "title": {"en": "Submit application", "zh": "提交申请", "vi": "Nộp đơn", "ko": "신청서 제출", "pt": "Enviar aplicação"}, "description": {"en": "Submit your application and documents. You'll receive a postcard when ready.", "zh": "提交申请和文件。审核完成后会收到通知明信片。", "vi": "Nộp đơn và hồ sơ. Bạn sẽ nhận được bưu thiếp khi có kết quả.", "ko": "신청서와 서류를 제출하세요. 준비되면 엽서를 받게 됩니다.", "pt": "Envie sua aplicação e documentos. Receberá um cartão postal quando estiver pronto."}},
            {"order": 4, "title": {"en": "Receive new residence card", "zh": "领取新在留卡", "vi": "Nhận thẻ cư trú mới", "ko": "새 재류카드 수령", "pt": "Receba o novo cartão de residência"}, "description": {"en": "Return to immigration with the postcard and revenue stamp (収入印紙) to receive your new card.", "zh": "带通知明信片和收入印纸前往出入国管理局领取新卡。", "vi": "Quay lại văn phòng nhập cư với bưu thiếp và tem thu nhập (収入印紙) để nhận thẻ mới.", "ko": "엽서와 수입인지를 가지고 출입국관리국을 다시 방문하여 새 카드를 받으세요.", "pt": "Retorne à imigração com o cartão postal e selo de receita (収入印紙) para receber seu novo cartão."}},
        ]),
        "estimated_duration": "2-4 weeks",
        "fees": json.dumps({"application_fee": 4000, "currency": "JPY", "notes": "Revenue stamp (収入印紙)"}),
        "applicable_statuses": json.dumps(["engineer_specialist", "specified_skilled_1", "specified_skilled_2", "student", "spouse_of_japanese", "long_term_resident", "technical_intern", "business_manager", "highly_skilled_professional", "dependent", "designated_activities"]),
        "deadline_rule": json.dumps({"type": "before_expiry", "months": 3}),
        "tips": json.dumps({
            "en": "Apply early (up to 3 months before expiry). Immigration offices are crowded on Mondays and after holidays.",
            "zh": "尽早申请（最早可在到期前3个月）。周一和节假日后出入国管理局很拥挤。",
            "vi": "Nộp đơn sớm (tối đa 3 tháng trước khi hết hạn). Văn phòng nhập cư đông vào thứ Hai và sau nghỉ lễ.",
            "ko": "일찍 신청하세요 (만료 3개월 전부터 가능). 월요일과 휴일 다음 날은 출입국관리국이 붐빕니다.",
            "pt": "Solicite com antecedência (até 3 meses antes do vencimento). Os escritórios de imigração ficam lotados às segundas e após feriados.",
        }),
        "sort_order": 1,
    },
    {
        "procedure_type": "change",
        "title": json.dumps({
            "en": "Change of Status of Residence",
            "zh": "在留资格变更",
            "vi": "Thay đổi tư cách lưu trú",
            "ko": "재류자격 변경",
            "pt": "Mudança de Status de Residência",
        }),
        "description": json.dumps({
            "en": "Change your current status of residence to a different one (e.g., Student to Engineer/Specialist). Apply at the Immigration Services Agency.",
            "zh": "将现有在留资格变更为其他资格（如从留学变更为技术·人文知识·国际业务）。在出入国在留管理局申请。",
            "vi": "Thay đổi tư cách lưu trú hiện tại sang loại khác (ví dụ: Du học sinh sang Kỹ sư/Chuyên gia). Nộp đơn tại Cục Quản lý Xuất nhập cảnh.",
            "ko": "현재 재류자격을 다른 자격으로 변경합니다 (예: 유학에서 기술·인문지식·국제업무로). 출입국재류관리국에서 신청합니다.",
            "pt": "Mude seu status de residência atual para um diferente (ex.: Estudante para Engenheiro/Especialista). Solicite na Agência de Serviços de Imigração.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Application form (在留資格変更許可申請書)", "zh": "申请表", "vi": "Đơn xin", "ko": "신청서", "pt": "Formulário"}, "how_to_get": {"en": "Download from ISA website", "zh": "从ISA网站下载", "vi": "Tải từ trang web ISA", "ko": "ISA 웹사이트에서 다운로드", "pt": "Baixe do site da ISA"}},
            {"name": {"en": "Passport and residence card", "zh": "护照和在留卡", "vi": "Hộ chiếu và thẻ cư trú", "ko": "여권과 재류카드", "pt": "Passaporte e cartão de residência"}, "how_to_get": {"en": "Your current documents", "zh": "现有证件", "vi": "Giấy tờ hiện tại", "ko": "현재 서류", "pt": "Seus documentos atuais"}},
            {"name": {"en": "Documents proving new activity (e.g., employment contract)", "zh": "证明新活动的文件（如雇佣合同）", "vi": "Giấy tờ chứng minh hoạt động mới (ví dụ: hợp đồng lao động)", "ko": "새 활동을 증명하는 서류 (예: 고용계약서)", "pt": "Documentos comprovando nova atividade (ex.: contrato de trabalho)"}, "how_to_get": {"en": "From your new employer/organization", "zh": "从新公司/机构获取", "vi": "Từ công ty/tổ chức mới", "ko": "새 회사/기관에서 발급", "pt": "Do seu novo empregador/organização"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Secure new position/reason", "zh": "确定新职位/理由", "vi": "Xác nhận vị trí/lý do mới", "ko": "새 직위/사유 확보", "pt": "Garantir nova posição/razão"}, "description": {"en": "Get employment contract or other proof of your new activity.", "zh": "获取雇佣合同或其他新活动证明。", "vi": "Nhận hợp đồng lao động hoặc chứng minh hoạt động mới.", "ko": "고용계약서 또는 새 활동 증빙을 준비하세요.", "pt": "Obtenha contrato de trabalho ou outra prova de sua nova atividade."}},
            {"order": 2, "title": {"en": "Prepare and submit", "zh": "准备并提交", "vi": "Chuẩn bị và nộp", "ko": "준비 및 제출", "pt": "Preparar e enviar"}, "description": {"en": "Complete the application form and submit at immigration with all documents.", "zh": "填写申请表并携带所有文件到出入国管理局提交。", "vi": "Hoàn thành đơn và nộp tại văn phòng nhập cư với tất cả hồ sơ.", "ko": "신청서를 작성하고 모든 서류와 함께 출입국관리국에 제출하세요.", "pt": "Complete o formulário e envie na imigração com todos os documentos."}},
            {"order": 3, "title": {"en": "Receive new residence card", "zh": "领取新在留卡", "vi": "Nhận thẻ cư trú mới", "ko": "새 재류카드 수령", "pt": "Receba o novo cartão"}, "description": {"en": "Collect your new residence card with updated status.", "zh": "领取更新了资格的新在留卡。", "vi": "Nhận thẻ cư trú mới với tư cách đã cập nhật.", "ko": "업데이트된 자격이 기재된 새 재류카드를 수령하세요.", "pt": "Colete seu novo cartão com status atualizado."}},
        ]),
        "estimated_duration": "1-3 months",
        "fees": json.dumps({"application_fee": 4000, "currency": "JPY"}),
        "applicable_statuses": json.dumps(["engineer_specialist", "specified_skilled_1", "student", "spouse_of_japanese", "long_term_resident", "technical_intern", "business_manager", "dependent", "designated_activities"]),
        "deadline_rule": None,
        "tips": json.dumps({
            "en": "Apply before your current status expires. You can continue your previous activities while the application is being processed.",
            "zh": "在现有资格到期前申请。审查期间可以继续进行之前的活动。",
            "vi": "Nộp đơn trước khi tư cách hiện tại hết hạn. Bạn có thể tiếp tục hoạt động trước đó trong khi đơn đang được xử lý.",
            "ko": "현재 자격이 만료되기 전에 신청하세요. 심사 중에는 이전 활동을 계속할 수 있습니다.",
            "pt": "Solicite antes de seu status atual expirar. Pode continuar suas atividades anteriores enquanto a aplicação é processada.",
        }),
        "sort_order": 2,
    },
    {
        "procedure_type": "permanent",
        "title": json.dumps({
            "en": "Permanent Residence Application",
            "zh": "永住权申请",
            "vi": "Xin thường trú",
            "ko": "영주권 신청",
            "pt": "Pedido de Residência Permanente",
        }),
        "description": json.dumps({
            "en": "Apply for permanent residence status in Japan. Generally requires 10+ years of continuous residence, good conduct, and financial stability.",
            "zh": "申请日本永住权。通常需要连续居住10年以上、品行良好且经济稳定。",
            "vi": "Xin tư cách thường trú tại Nhật Bản. Thường yêu cầu cư trú liên tục 10 năm trở lên, phẩm hạnh tốt và ổn định tài chính.",
            "ko": "일본 영주권을 신청합니다. 일반적으로 10년 이상의 계속 거주, 양호한 품행, 경제적 안정이 필요합니다.",
            "pt": "Solicite o status de residência permanente no Japão. Geralmente requer 10+ anos de residência contínua, boa conduta e estabilidade financeira.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Application form", "zh": "申请表", "vi": "Đơn xin", "ko": "신청서", "pt": "Formulário"}, "how_to_get": {"en": "Download from ISA website", "zh": "从ISA网站下载", "vi": "Tải từ trang web ISA", "ko": "ISA 웹사이트에서 다운로드", "pt": "Baixe do site da ISA"}},
            {"name": {"en": "Letter of reason for application", "zh": "申请理由书", "vi": "Thư lý do xin", "ko": "신청 이유서", "pt": "Carta de razão para aplicação"}, "how_to_get": {"en": "Write it yourself explaining your situation", "zh": "自行撰写，说明情况", "vi": "Tự viết giải thích tình huống của bạn", "ko": "본인이 직접 작성", "pt": "Escreva você mesmo explicando sua situação"}},
            {"name": {"en": "Tax certificates (past 5 years)", "zh": "纳税证明（过去5年）", "vi": "Giấy chứng nhận thuế (5 năm gần nhất)", "ko": "납세 증명서 (최근 5년)", "pt": "Certificados fiscais (últimos 5 anos)"}, "how_to_get": {"en": "From tax office (税務署)", "zh": "从税务署获取", "vi": "Từ sở thuế (税務署)", "ko": "세무서에서 발급", "pt": "Do escritório fiscal (税務署)"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Check eligibility", "zh": "确认资格", "vi": "Kiểm tra đủ điều kiện", "ko": "자격 확인", "pt": "Verificar elegibilidade"}, "description": {"en": "Verify you meet the requirements: 10+ years residence, 5+ years on current status, good conduct, financial stability.", "zh": "确认是否满足条件：居住10年以上，现资格5年以上，品行良好，经济稳定。", "vi": "Xác nhận bạn đáp ứng yêu cầu: cư trú 10+ năm, 5+ năm trên tư cách hiện tại, phẩm hạnh tốt, ổn định tài chính.", "ko": "요건을 충족하는지 확인: 10년 이상 거주, 현재 자격 5년 이상, 양호한 품행, 경제적 안정.", "pt": "Verifique se atende aos requisitos: 10+ anos de residência, 5+ anos no status atual, boa conduta, estabilidade financeira."}},
            {"order": 2, "title": {"en": "Submit application", "zh": "提交申请", "vi": "Nộp đơn", "ko": "신청서 제출", "pt": "Enviar aplicação"}, "description": {"en": "Submit at your local immigration office with all documents.", "zh": "携带所有文件到当地出入国管理局提交。", "vi": "Nộp tại văn phòng nhập cư địa phương với tất cả hồ sơ.", "ko": "모든 서류와 함께 관할 출입국관리국에 제출하세요.", "pt": "Envie no escritório de imigração local com todos os documentos."}},
            {"order": 3, "title": {"en": "Wait for decision", "zh": "等待审批", "vi": "Chờ quyết định", "ko": "결정 대기", "pt": "Aguardar decisão"}, "description": {"en": "Processing can take 6-12 months. You may receive additional document requests.", "zh": "审查可能需要6-12个月。可能会收到追加文件要求。", "vi": "Xử lý có thể mất 6-12 tháng. Bạn có thể nhận được yêu cầu bổ sung hồ sơ.", "ko": "처리에 6-12개월이 걸릴 수 있습니다. 추가 서류 요청을 받을 수 있습니다.", "pt": "O processamento pode levar 6-12 meses. Pode receber pedidos de documentos adicionais."}},
        ]),
        "estimated_duration": "6-12 months",
        "fees": json.dumps({"application_fee": 8000, "currency": "JPY"}),
        "applicable_statuses": json.dumps(["engineer_specialist", "spouse_of_japanese", "long_term_resident", "business_manager", "highly_skilled_professional"]),
        "deadline_rule": None,
        "tips": None,
        "sort_order": 3,
    },
    {
        "procedure_type": "reentry",
        "title": json.dumps({
            "en": "Re-entry Permit",
            "zh": "再入国许可",
            "vi": "Giấy phép tái nhập cảnh",
            "ko": "재입국 허가",
            "pt": "Permissão de Reentrada",
        }),
        "description": json.dumps({
            "en": "If leaving Japan for more than 1 year, you need a re-entry permit. A 'Special Re-entry Permit' is automatically granted for stays up to 1 year if you have a valid residence card.",
            "zh": "如果离开日本超过1年，需要再入国许可。持有有效在留卡并在1年内返回的情况下，自动获得\"视同再入国许可\"。",
            "vi": "Nếu rời Nhật Bản hơn 1 năm, bạn cần giấy phép tái nhập cảnh. 'Giấy phép tái nhập cảnh đặc biệt' được cấp tự động cho thời gian ở dưới 1 năm nếu bạn có thẻ cư trú hợp lệ.",
            "ko": "일본을 1년 이상 떠나는 경우 재입국 허가가 필요합니다. 유효한 재류카드가 있으면 1년 이내의 체류에 대해 '간주 재입국 허가'가 자동으로 부여됩니다.",
            "pt": "Se sair do Japão por mais de 1 ano, precisa de permissão de reentrada. Uma 'Permissão Especial de Reentrada' é concedida automaticamente para estadias de até 1 ano se tiver cartão de residência válido.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Passport", "zh": "护照", "vi": "Hộ chiếu", "ko": "여권", "pt": "Passaporte"}, "how_to_get": {"en": "Your valid passport", "zh": "有效护照", "vi": "Hộ chiếu còn hiệu lực", "ko": "유효한 여권", "pt": "Seu passaporte válido"}},
            {"name": {"en": "Residence card", "zh": "在留卡", "vi": "Thẻ cư trú", "ko": "재류카드", "pt": "Cartão de residência"}, "how_to_get": {"en": "Your current residence card", "zh": "现有在留卡", "vi": "Thẻ cư trú hiện tại", "ko": "현재 재류카드", "pt": "Seu cartão de residência atual"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Determine if needed", "zh": "确认是否需要", "vi": "Xác định có cần không", "ko": "필요 여부 확인", "pt": "Determine se necessário"}, "description": {"en": "If leaving for less than 1 year, special re-entry is automatic. For longer, apply for a regular re-entry permit.", "zh": "1年以内出境自动获得视同再入国许可。超过1年需要申请正式再入国许可。", "vi": "Nếu rời đi dưới 1 năm, tái nhập cảnh đặc biệt là tự động. Lâu hơn, cần xin giấy phép tái nhập cảnh.", "ko": "1년 미만 출국 시 간주 재입국이 자동입니다. 그 이상은 정식 재입국 허가를 신청하세요.", "pt": "Se sair por menos de 1 ano, a reentrada especial é automática. Para mais tempo, solicite permissão regular."}},
            {"order": 2, "title": {"en": "Apply at immigration (if needed)", "zh": "在出入国管理局申请（如需）", "vi": "Nộp đơn tại nhập cư (nếu cần)", "ko": "출입국관리국에서 신청 (필요시)", "pt": "Solicite na imigração (se necessário)"}, "description": {"en": "Submit application at immigration office before departure.", "zh": "出发前在出入国管理局提交申请。", "vi": "Nộp đơn tại văn phòng nhập cư trước khi khởi hành.", "ko": "출발 전에 출입국관리국에서 신청하세요.", "pt": "Envie a aplicação no escritório de imigração antes da partida."}},
        ]),
        "estimated_duration": "Same day to 1 week",
        "fees": json.dumps({"single_entry": 3000, "multiple_entry": 6000, "currency": "JPY"}),
        "applicable_statuses": json.dumps(["engineer_specialist", "specified_skilled_1", "specified_skilled_2", "student", "permanent_resident", "spouse_of_japanese", "long_term_resident", "technical_intern", "business_manager", "highly_skilled_professional", "dependent", "designated_activities"]),
        "deadline_rule": None,
        "tips": None,
        "sort_order": 4,
    },
    {
        "procedure_type": "work_permit",
        "title": json.dumps({
            "en": "Permission to Engage in Activities Other Than Those Permitted (Work Permit for Students)",
            "zh": "资格外活动许可（留学生打工许可）",
            "vi": "Giấy phép hoạt động ngoài phạm vi tư cách (Giấy phép làm thêm cho du học sinh)",
            "ko": "자격 외 활동 허가 (유학생 아르바이트 허가)",
            "pt": "Permissão para Atividades Além das Permitidas (Permissão de Trabalho para Estudantes)",
        }),
        "description": json.dumps({
            "en": "Students can apply for permission to work part-time (up to 28 hours/week during school, 40 hours during vacations).",
            "zh": "留学生可以申请打工许可（上课期间每周28小时以内，假期期间每周40小时以内）。",
            "vi": "Du học sinh có thể xin phép làm thêm (tối đa 28 giờ/tuần khi đi học, 40 giờ khi nghỉ hè).",
            "ko": "유학생은 아르바이트 허가를 신청할 수 있습니다 (수업 중 주 28시간, 방학 중 주 40시간까지).",
            "pt": "Estudantes podem solicitar permissão para trabalhar meio período (até 28 horas/semana durante as aulas, 40 horas durante as férias).",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Application form (資格外活動許可申請書)", "zh": "申请表", "vi": "Đơn xin", "ko": "신청서", "pt": "Formulário"}, "how_to_get": {"en": "Download from ISA website", "zh": "从ISA网站下载", "vi": "Tải từ trang web ISA", "ko": "ISA 웹사이트에서 다운로드", "pt": "Baixe do site da ISA"}},
            {"name": {"en": "Passport and residence card", "zh": "护照和在留卡", "vi": "Hộ chiếu và thẻ cư trú", "ko": "여권과 재류카드", "pt": "Passaporte e cartão de residência"}, "how_to_get": {"en": "Your current documents", "zh": "现有证件", "vi": "Giấy tờ hiện tại", "ko": "현재 서류", "pt": "Seus documentos atuais"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Prepare application", "zh": "准备申请", "vi": "Chuẩn bị đơn", "ko": "신청 준비", "pt": "Preparar aplicação"}, "description": {"en": "Fill out the application form and prepare your passport and residence card.", "zh": "填写申请表，准备护照和在留卡。", "vi": "Điền đơn và chuẩn bị hộ chiếu và thẻ cư trú.", "ko": "신청서를 작성하고 여권과 재류카드를 준비하세요.", "pt": "Preencha o formulário e prepare passaporte e cartão de residência."}},
            {"order": 2, "title": {"en": "Submit at immigration", "zh": "提交申请", "vi": "Nộp đơn", "ko": "신청서 제출", "pt": "Enviar na imigração"}, "description": {"en": "Submit at immigration office or at the airport upon arrival.", "zh": "在出入国管理局或入境时在机场提交。", "vi": "Nộp tại văn phòng nhập cư hoặc tại sân bay khi đến.", "ko": "출입국관리국 또는 도착 시 공항에서 제출하세요.", "pt": "Envie no escritório de imigração ou no aeroporto na chegada."}},
        ]),
        "estimated_duration": "2 weeks to 2 months",
        "fees": json.dumps({"application_fee": 0, "currency": "JPY", "notes": "Free"}),
        "applicable_statuses": json.dumps(["student", "dependent", "designated_activities"]),
        "deadline_rule": None,
        "tips": json.dumps({
            "en": "You can apply at Narita/Haneda airport upon arrival. This is the fastest way to get work permission.",
            "zh": "可以在抵达成田/羽田机场时申请。这是获得打工许可最快的方式。",
            "vi": "Bạn có thể nộp đơn tại sân bay Narita/Haneda khi đến. Đây là cách nhanh nhất để được phép làm việc.",
            "ko": "나리타/하네다 공항 도착 시 신청할 수 있습니다. 이것이 가장 빠른 방법입니다.",
            "pt": "Pode solicitar no aeroporto Narita/Haneda na chegada. É a forma mais rápida de obter permissão de trabalho.",
        }),
        "sort_order": 5,
    },
    {
        "procedure_type": "family",
        "title": json.dumps({
            "en": "Family Stay Visa (Dependent Visa)",
            "zh": "家属签证（家族滞在）",
            "vi": "Visa gia đình (Visa phụ thuộc)",
            "ko": "가족 체류 비자 (가족 체재)",
            "pt": "Visto de Família (Visto de Dependente)",
        }),
        "description": json.dumps({
            "en": "Bring your spouse or children to Japan on a Dependent (家族滞在) visa. The sponsor must have a valid working visa.",
            "zh": "以家族滞在签证将配偶或子女带到日本。担保人必须持有有效的工作签证。",
            "vi": "Đưa vợ/chồng hoặc con cái đến Nhật Bản với visa Phụ thuộc (家族滞在). Người bảo lãnh phải có visa lao động hợp lệ.",
            "ko": "배우자나 자녀를 가족 체재(家族滞在) 비자로 일본에 데려옵니다. 보증인은 유효한 취업 비자가 있어야 합니다.",
            "pt": "Traga seu cônjuge ou filhos ao Japão com visto de Dependente (家族滞在). O patrocinador deve ter visto de trabalho válido.",
        }),
        "required_documents": json.dumps([
            {"name": {"en": "Certificate of Eligibility (COE) application", "zh": "在留资格认定证明书申请", "vi": "Đơn xin Giấy chứng nhận đủ điều kiện (COE)", "ko": "재류자격 인정증명서 신청", "pt": "Aplicação de Certificado de Elegibilidade (COE)"}, "how_to_get": {"en": "Submit at immigration by the sponsor in Japan", "zh": "由在日本的担保人在出入国管理局提交", "vi": "Nộp tại nhập cư bởi người bảo lãnh tại Nhật Bản", "ko": "일본에 있는 보증인이 출입국관리국에 제출", "pt": "Envie na imigração pelo patrocinador no Japão"}},
            {"name": {"en": "Marriage certificate / Birth certificate", "zh": "结婚证/出生证", "vi": "Giấy kết hôn / Giấy khai sinh", "ko": "혼인 증명서 / 출생 증명서", "pt": "Certidão de casamento / Certidão de nascimento"}, "how_to_get": {"en": "From your home country, with Japanese translation", "zh": "从本国获取，附日语翻译", "vi": "Từ quê nhà, kèm bản dịch tiếng Nhật", "ko": "본국에서 발급, 일본어 번역 첨부", "pt": "Do seu país de origem, com tradução para japonês"}},
            {"name": {"en": "Sponsor's tax certificate", "zh": "担保人纳税证明", "vi": "Giấy chứng nhận thuế của người bảo lãnh", "ko": "보증인의 납세 증명서", "pt": "Certificado fiscal do patrocinador"}, "how_to_get": {"en": "From employer or tax office", "zh": "从公司或税务署获取", "vi": "Từ công ty hoặc sở thuế", "ko": "회사 또는 세무서에서 발급", "pt": "Do empregador ou escritório fiscal"}},
        ]),
        "steps": json.dumps([
            {"order": 1, "title": {"en": "Apply for COE", "zh": "申请在留资格认定证明书", "vi": "Xin COE", "ko": "재류자격 인정증명서 신청", "pt": "Solicitar COE"}, "description": {"en": "Sponsor submits COE application at Japanese immigration office.", "zh": "担保人在出入国管理局提交在留资格认定证明书申请。", "vi": "Người bảo lãnh nộp đơn COE tại văn phòng nhập cư Nhật Bản.", "ko": "보증인이 일본 출입국관리국에서 COE를 신청합니다.", "pt": "Patrocinador envia aplicação de COE no escritório de imigração japonês."}},
            {"order": 2, "title": {"en": "Send COE to family", "zh": "将COE寄给家属", "vi": "Gửi COE cho gia đình", "ko": "가족에게 COE 발송", "pt": "Enviar COE para família"}, "description": {"en": "Once approved, send the COE to your family member abroad.", "zh": "批准后将COE寄给海外家属。", "vi": "Sau khi được chấp thuận, gửi COE cho thành viên gia đình ở nước ngoài.", "ko": "승인 후 해외 가족에게 COE를 보내세요.", "pt": "Após aprovação, envie o COE para o familiar no exterior."}},
            {"order": 3, "title": {"en": "Apply for visa at embassy", "zh": "在大使馆申请签证", "vi": "Xin visa tại đại sứ quán", "ko": "대사관에서 비자 신청", "pt": "Solicitar visto na embaixada"}, "description": {"en": "Family member applies for visa at Japanese embassy in their country using the COE.", "zh": "家属在当地日本大使馆使用COE申请签证。", "vi": "Thành viên gia đình xin visa tại đại sứ quán Nhật Bản ở nước họ bằng COE.", "ko": "가족이 COE를 사용하여 해당 국가의 일본 대사관에서 비자를 신청합니다.", "pt": "O familiar solicita o visto na embaixada japonesa em seu país usando o COE."}},
        ]),
        "estimated_duration": "1-3 months",
        "fees": json.dumps({"coe_application": 0, "visa_fee": "varies_by_country", "currency": "JPY"}),
        "applicable_statuses": json.dumps(["engineer_specialist", "specified_skilled_2", "business_manager", "highly_skilled_professional", "permanent_resident"]),
        "deadline_rule": None,
        "tips": json.dumps({
            "en": "Highly Skilled Professional visa holders may get expedited processing for family visas.",
            "zh": "高度专门职签证持有者的家属签证可能获得加速处理。",
            "vi": "Người có visa Chuyên gia kỹ năng cao có thể được xử lý nhanh cho visa gia đình.",
            "ko": "고도전문직 비자 소지자는 가족 비자 심사가 빨라질 수 있습니다.",
            "pt": "Titulares de visto de Profissional Altamente Qualificado podem ter processamento acelerado para vistos familiares.",
        }),
        "sort_order": 6,
    },
]


def seed():
    now = datetime.now(timezone.utc).isoformat()
    with engine.connect() as conn:
        result = conn.execute(text("SELECT COUNT(*) FROM visa_procedures"))
        count = result.scalar()
        if count and count > 0:
            print(f"visa_procedures already has {count} records. Clearing...")
            conn.execute(text("DELETE FROM visa_procedures"))
            conn.commit()

        for proc in PROCEDURES:
            conn.execute(
                text("""
                    INSERT INTO visa_procedures
                    (id, procedure_type, title, description, required_documents,
                     steps, estimated_duration, fees, applicable_statuses,
                     deadline_rule, tips, is_active, sort_order,
                     created_at, updated_at)
                    VALUES
                    (:id, :procedure_type, :title, :description, :required_documents,
                     :steps, :estimated_duration, :fees, :applicable_statuses,
                     :deadline_rule, :tips, 1, :sort_order,
                     :now, :now)
                """),
                {
                    "id": str(uuid.uuid4()),
                    "now": now,
                    **proc,
                },
            )
        conn.commit()
        print(f"✅ Seeded {len(PROCEDURES)} visa procedures.")


if __name__ == "__main__":
    seed()
