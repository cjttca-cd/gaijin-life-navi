#!/usr/bin/env python3
"""Seed medical_phrases with emergency + symptom phrases.

Usage:
    DATABASE_URL=sqlite:///data/app.db python scripts/seed_medical.py
"""

import json
import os
import uuid
from datetime import datetime, timezone

DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "sqlite:////root/.openclaw/projects/gaijin-life-navi/data/app.db",
)
DATABASE_URL = DATABASE_URL.replace("sqlite+aiosqlite", "sqlite")
DATABASE_URL = DATABASE_URL.replace("postgresql+asyncpg", "postgresql")

from sqlalchemy import create_engine, text

engine = create_engine(DATABASE_URL, echo=False)

PHRASES = [
    # ── Emergency phrases ──────────────────────────────────────────────
    {
        "category": "emergency",
        "phrase_ja": "救急車を呼んでください",
        "phrase_reading": "きゅうきゅうしゃをよんでください",
        "translations": json.dumps({"en": "Please call an ambulance", "zh": "请叫救护车", "vi": "Xin hãy gọi xe cứu thương", "ko": "구급차를 불러주세요", "pt": "Por favor, chame uma ambulância"}),
        "context": json.dumps({"en": "Use in life-threatening emergencies. Dial 119.", "zh": "在危及生命的紧急情况下使用。拨打119。", "vi": "Sử dụng trong trường hợp khẩn cấp đe dọa tính mạng. Gọi 119.", "ko": "생명을 위협하는 응급 상황에서 사용하세요. 119에 전화하세요.", "pt": "Use em emergências com risco de vida. Ligue 119."}),
        "sort_order": 1,
    },
    {
        "category": "emergency",
        "phrase_ja": "救急です",
        "phrase_reading": "きゅうきゅうです",
        "translations": json.dumps({"en": "It's an emergency", "zh": "是紧急情况", "vi": "Đây là trường hợp khẩn cấp", "ko": "응급입니다", "pt": "É uma emergência"}),
        "context": json.dumps({"en": "First thing to say when calling 119.", "zh": "拨打119时首先要说的话。", "vi": "Điều đầu tiên nói khi gọi 119.", "ko": "119에 전화할 때 가장 먼저 할 말.", "pt": "Primeira coisa a dizer ao ligar para 119."}),
        "sort_order": 2,
    },
    {
        "category": "emergency",
        "phrase_ja": "住所は〇〇です",
        "phrase_reading": "じゅうしょは〇〇です",
        "translations": json.dumps({"en": "My address is ○○", "zh": "我的地址是○○", "vi": "Địa chỉ của tôi là ○○", "ko": "주소는 ○○입니다", "pt": "Meu endereço é ○○"}),
        "context": json.dumps({"en": "Tell the dispatcher your location. Have your address written in Japanese.", "zh": "告诉调度员您的位置。准备好用日语写的地址。", "vi": "Nói cho điều phối viên vị trí của bạn. Chuẩn bị địa chỉ bằng tiếng Nhật.", "ko": "디스패처에게 위치를 알려주세요. 일본어로 쓴 주소를 준비하세요.", "pt": "Diga ao despachante sua localização. Tenha seu endereço escrito em japonês."}),
        "sort_order": 3,
    },
    {
        "category": "emergency",
        "phrase_ja": "意識がありません",
        "phrase_reading": "いしきがありません",
        "translations": json.dumps({"en": "They are unconscious", "zh": "失去意识了", "vi": "Họ bất tỉnh", "ko": "의식이 없습니다", "pt": "Está inconsciente"}),
        "context": json.dumps({"en": "Describe the patient's condition to emergency services.", "zh": "向急救服务描述患者状况。", "vi": "Mô tả tình trạng bệnh nhân cho dịch vụ cấp cứu.", "ko": "응급 서비스에 환자 상태를 설명하세요.", "pt": "Descreva a condição do paciente para os serviços de emergência."}),
        "sort_order": 4,
    },
    {
        "category": "emergency",
        "phrase_ja": "出血しています",
        "phrase_reading": "しゅっけつしています",
        "translations": json.dumps({"en": "There is bleeding", "zh": "在出血", "vi": "Đang chảy máu", "ko": "출혈이 있습니다", "pt": "Está sangrando"}),
        "context": json.dumps({"en": "Inform about bleeding to emergency services.", "zh": "告知急救服务出血情况。", "vi": "Thông báo về chảy máu cho dịch vụ cấp cứu.", "ko": "응급 서비스에 출혈 상황을 알려주세요.", "pt": "Informe sobre sangramento aos serviços de emergência."}),
        "sort_order": 5,
    },
    {
        "category": "emergency",
        "phrase_ja": "英語を話せる人はいますか",
        "phrase_reading": "えいごをはなせるひとはいますか",
        "translations": json.dumps({"en": "Is there someone who speaks English?", "zh": "有人会说英语吗？", "vi": "Có ai nói được tiếng Anh không?", "ko": "영어를 할 수 있는 사람이 있나요?", "pt": "Alguém fala inglês?"}),
        "context": json.dumps({"en": "Ask for English-speaking staff at hospital or when calling emergency.", "zh": "在医院或拨打急救电话时寻找会说英语的人。", "vi": "Hỏi nhân viên nói tiếng Anh tại bệnh viện hoặc khi gọi cấp cứu.", "ko": "병원이나 응급 전화 시 영어를 할 수 있는 직원을 요청하세요.", "pt": "Peça por funcionários que falam inglês no hospital ou ao ligar para emergência."}),
        "sort_order": 6,
    },
    # ── Symptom phrases ────────────────────────────────────────────────
    {
        "category": "symptom",
        "phrase_ja": "頭が痛いです",
        "phrase_reading": "あたまがいたいです",
        "translations": json.dumps({"en": "I have a headache", "zh": "头疼", "vi": "Tôi bị đau đầu", "ko": "머리가 아파요", "pt": "Estou com dor de cabeça"}),
        "context": json.dumps({"en": "Common symptom description at the doctor's office.", "zh": "在医院常用的症状描述。", "vi": "Mô tả triệu chứng phổ biến tại phòng khám.", "ko": "병원에서 흔한 증상 설명.", "pt": "Descrição comum de sintoma no consultório médico."}),
        "sort_order": 1,
    },
    {
        "category": "symptom",
        "phrase_ja": "お腹が痛いです",
        "phrase_reading": "おなかがいたいです",
        "translations": json.dumps({"en": "I have a stomachache", "zh": "肚子疼", "vi": "Tôi bị đau bụng", "ko": "배가 아파요", "pt": "Estou com dor de estômago"}),
        "context": json.dumps({"en": "Point to the area that hurts while saying this.", "zh": "说这句话时指向疼痛部位。", "vi": "Chỉ vào vùng đau khi nói câu này.", "ko": "이 말을 하면서 아픈 부위를 가리키세요.", "pt": "Aponte para a área que dói enquanto diz isso."}),
        "sort_order": 2,
    },
    {
        "category": "symptom",
        "phrase_ja": "熱があります",
        "phrase_reading": "ねつがあります",
        "translations": json.dumps({"en": "I have a fever", "zh": "发烧了", "vi": "Tôi bị sốt", "ko": "열이 있어요", "pt": "Estou com febre"}),
        "context": json.dumps({"en": "If you know your temperature, add: ○○度あります (○○ do arimasu).", "zh": "如果知道体温，可以补充：○○度あります。", "vi": "Nếu biết nhiệt độ, thêm: ○○度あります.", "ko": "체온을 알면 추가하세요: ○○度あります.", "pt": "Se souber sua temperatura, adicione: ○○度あります."}),
        "sort_order": 3,
    },
    {
        "category": "symptom",
        "phrase_ja": "咳が出ます",
        "phrase_reading": "せきがでます",
        "translations": json.dumps({"en": "I have a cough", "zh": "咳嗽", "vi": "Tôi bị ho", "ko": "기침이 나요", "pt": "Estou com tosse"}),
        "context": None,
        "sort_order": 4,
    },
    {
        "category": "symptom",
        "phrase_ja": "吐き気がします",
        "phrase_reading": "はきけがします",
        "translations": json.dumps({"en": "I feel nauseous", "zh": "想吐", "vi": "Tôi buồn nôn", "ko": "메스꺼워요", "pt": "Estou com náusea"}),
        "context": None,
        "sort_order": 5,
    },
    {
        "category": "symptom",
        "phrase_ja": "めまいがします",
        "phrase_reading": "めまいがします",
        "translations": json.dumps({"en": "I feel dizzy", "zh": "头晕", "vi": "Tôi bị chóng mặt", "ko": "어지러워요", "pt": "Estou com tontura"}),
        "context": None,
        "sort_order": 6,
    },
    {
        "category": "symptom",
        "phrase_ja": "下痢をしています",
        "phrase_reading": "げりをしています",
        "translations": json.dumps({"en": "I have diarrhea", "zh": "拉肚子", "vi": "Tôi bị tiêu chảy", "ko": "설사를 하고 있어요", "pt": "Estou com diarreia"}),
        "context": None,
        "sort_order": 7,
    },
    {
        "category": "symptom",
        "phrase_ja": "アレルギーがあります",
        "phrase_reading": "アレルギーがあります",
        "translations": json.dumps({"en": "I have allergies", "zh": "我有过敏症", "vi": "Tôi bị dị ứng", "ko": "알레르기가 있어요", "pt": "Tenho alergias"}),
        "context": json.dumps({"en": "Follow up with what you're allergic to. Common: 花粉 (pollen), 卵 (eggs), 薬 (medicine).", "zh": "接着说过敏原。常见：花粉、卵（鸡蛋）、薬（药物）。", "vi": "Tiếp tục nói bạn dị ứng gì. Phổ biến: 花粉 (phấn hoa), 卵 (trứng), 薬 (thuốc).", "ko": "알레르기 원인을 이어서 말하세요. 흔한 것: 花粉 (꽃가루), 卵 (계란), 薬 (약).", "pt": "Continue dizendo a que é alérgico. Comum: 花粉 (pólen), 卵 (ovos), 薬 (remédio)."}),
        "sort_order": 8,
    },
    {
        "category": "symptom",
        "phrase_ja": "ここが痛いです",
        "phrase_reading": "ここがいたいです",
        "translations": json.dumps({"en": "It hurts here", "zh": "这里疼", "vi": "Chỗ này đau", "ko": "여기가 아파요", "pt": "Dói aqui"}),
        "context": json.dumps({"en": "Point to the body part that hurts. Very useful universal phrase.", "zh": "指向疼痛的身体部位。非常有用的通用短语。", "vi": "Chỉ vào phần cơ thể bị đau. Cụm từ phổ quát rất hữu ích.", "ko": "아픈 신체 부위를 가리키세요. 매우 유용한 만능 표현.", "pt": "Aponte para a parte do corpo que dói. Frase universal muito útil."}),
        "sort_order": 9,
    },
    {
        "category": "symptom",
        "phrase_ja": "息苦しいです",
        "phrase_reading": "いきぐるしいです",
        "translations": json.dumps({"en": "I have difficulty breathing", "zh": "呼吸困难", "vi": "Tôi khó thở", "ko": "숨쉬기 어려워요", "pt": "Tenho dificuldade para respirar"}),
        "context": json.dumps({"en": "This may indicate a serious condition. Seek immediate medical attention.", "zh": "这可能表明严重状况。请立即就医。", "vi": "Điều này có thể cho thấy tình trạng nghiêm trọng. Tìm kiếm sự chăm sóc y tế ngay lập tức.", "ko": "심각한 상태를 나타낼 수 있습니다. 즉시 의료 조치를 받으세요.", "pt": "Isso pode indicar uma condição grave. Procure atendimento médico imediato."}),
        "sort_order": 10,
    },
    # ── Insurance phrases ──────────────────────────────────────────────
    {
        "category": "insurance",
        "phrase_ja": "保険証を持っています",
        "phrase_reading": "ほけんしょうをもっています",
        "translations": json.dumps({"en": "I have my insurance card", "zh": "我有保险证", "vi": "Tôi có thẻ bảo hiểm", "ko": "보험증을 가지고 있어요", "pt": "Tenho meu cartão de seguro"}),
        "context": json.dumps({"en": "Show your health insurance card at the reception desk.", "zh": "在挂号处出示健康保险证。", "vi": "Trình thẻ bảo hiểm y tế tại quầy tiếp tân.", "ko": "접수대에서 건강보험증을 보여주세요.", "pt": "Mostre seu cartão de seguro na recepção."}),
        "sort_order": 1,
    },
    {
        "category": "insurance",
        "phrase_ja": "初めて来ました",
        "phrase_reading": "はじめてきました",
        "translations": json.dumps({"en": "This is my first visit", "zh": "第一次来", "vi": "Đây là lần đầu tôi đến", "ko": "처음 왔습니다", "pt": "Esta é minha primeira visita"}),
        "context": json.dumps({"en": "Tell the reception desk. You'll need to fill out a new patient form (初診票).", "zh": "告诉挂号处。需要填写初诊表。", "vi": "Nói với quầy tiếp tân. Bạn sẽ cần điền phiếu bệnh nhân mới (初診票).", "ko": "접수대에 말하세요. 초진표를 작성해야 합니다.", "pt": "Diga na recepção. Precisará preencher um formulário de novo paciente (初診票)."}),
        "sort_order": 2,
    },
    {
        "category": "insurance",
        "phrase_ja": "薬を飲んでいます",
        "phrase_reading": "くすりをのんでいます",
        "translations": json.dumps({"en": "I am taking medication", "zh": "我在服药", "vi": "Tôi đang uống thuốc", "ko": "약을 먹고 있어요", "pt": "Estou tomando medicamento"}),
        "context": json.dumps({"en": "Bring your medication or a list of what you take.", "zh": "带上正在服用的药物或药品清单。", "vi": "Mang theo thuốc hoặc danh sách thuốc đang uống.", "ko": "복용 중인 약이나 약 목록을 가져가세요.", "pt": "Leve sua medicação ou uma lista do que toma."}),
        "sort_order": 3,
    },
    {
        "category": "insurance",
        "phrase_ja": "領収書をください",
        "phrase_reading": "りょうしゅうしょをください",
        "translations": json.dumps({"en": "Please give me a receipt", "zh": "请给我收据", "vi": "Xin cho tôi hóa đơn", "ko": "영수증을 주세요", "pt": "Por favor, me dê um recibo"}),
        "context": json.dumps({"en": "Keep receipts for medical expense deductions on your tax return.", "zh": "保留收据用于报税时的医疗费用扣除。", "vi": "Giữ hóa đơn để khấu trừ chi phí y tế khi khai thuế.", "ko": "세금 신고 시 의료비 공제를 위해 영수증을 보관하세요.", "pt": "Guarde os recibos para dedução de despesas médicas na declaração de impostos."}),
        "sort_order": 4,
    },
    {
        "category": "insurance",
        "phrase_ja": "いくらですか",
        "phrase_reading": "いくらですか",
        "translations": json.dumps({"en": "How much is it?", "zh": "多少钱？", "vi": "Bao nhiêu tiền?", "ko": "얼마예요?", "pt": "Quanto custa?"}),
        "context": json.dumps({"en": "Ask about the cost. With NHI, you pay 30% of the total.", "zh": "询问费用。有国民健康保险的话只需支付30%。", "vi": "Hỏi về chi phí. Với NHI, bạn trả 30% tổng chi phí.", "ko": "비용을 물어보세요. NHI가 있으면 총 비용의 30%를 지불합니다.", "pt": "Pergunte sobre o custo. Com NHI, você paga 30% do total."}),
        "sort_order": 5,
    },
    # ── General medical phrases ────────────────────────────────────────
    {
        "category": "general",
        "phrase_ja": "病院に行きたいです",
        "phrase_reading": "びょういんにいきたいです",
        "translations": json.dumps({"en": "I want to go to a hospital", "zh": "我想去医院", "vi": "Tôi muốn đi bệnh viện", "ko": "병원에 가고 싶어요", "pt": "Quero ir ao hospital"}),
        "context": json.dumps({"en": "For urgent but non-emergency situations.", "zh": "用于紧急但非急救的情况。", "vi": "Cho trường hợp cấp bách nhưng không phải cấp cứu.", "ko": "긴급하지만 응급이 아닌 상황에.", "pt": "Para situações urgentes mas não emergenciais."}),
        "sort_order": 1,
    },
    {
        "category": "general",
        "phrase_ja": "予約したいです",
        "phrase_reading": "よやくしたいです",
        "translations": json.dumps({"en": "I'd like to make an appointment", "zh": "我想预约", "vi": "Tôi muốn đặt lịch hẹn", "ko": "예약하고 싶어요", "pt": "Gostaria de marcar uma consulta"}),
        "context": json.dumps({"en": "Many clinics in Japan accept walk-ins, but some require appointments.", "zh": "日本很多诊所接受无预约就诊，但有些需要预约。", "vi": "Nhiều phòng khám ở Nhật chấp nhận đến trực tiếp, nhưng một số cần hẹn trước.", "ko": "일본의 많은 클리닉은 예약 없이 방문을 받지만, 일부는 예약이 필요합니다.", "pt": "Muitas clínicas no Japão aceitam sem agendamento, mas algumas exigem consulta marcada."}),
        "sort_order": 2,
    },
    {
        "category": "general",
        "phrase_ja": "処方箋をください",
        "phrase_reading": "しょほうせんをください",
        "translations": json.dumps({"en": "Please give me a prescription", "zh": "请给我处方", "vi": "Xin cho tôi đơn thuốc", "ko": "처방전을 주세요", "pt": "Por favor, me dê uma receita"}),
        "context": json.dumps({"en": "Take the prescription to a pharmacy (薬局) near the hospital.", "zh": "拿处方去医院附近的药局(薬局)。", "vi": "Mang đơn thuốc đến nhà thuốc (薬局) gần bệnh viện.", "ko": "처방전을 병원 근처 약국(薬局)에 가져가세요.", "pt": "Leve a receita para uma farmácia (薬局) perto do hospital."}),
        "sort_order": 3,
    },
    {
        "category": "general",
        "phrase_ja": "妊娠しています",
        "phrase_reading": "にんしんしています",
        "translations": json.dumps({"en": "I am pregnant", "zh": "我怀孕了", "vi": "Tôi đang mang thai", "ko": "임신 중이에요", "pt": "Estou grávida"}),
        "context": json.dumps({"en": "Important to tell the doctor as it affects treatment and medication choices.", "zh": "重要信息，会影响治疗和用药选择。", "vi": "Quan trọng phải nói với bác sĩ vì nó ảnh hưởng đến điều trị và lựa chọn thuốc.", "ko": "치료와 약물 선택에 영향을 미치므로 의사에게 반드시 말하세요.", "pt": "Importante dizer ao médico pois afeta o tratamento e escolha de medicamentos."}),
        "sort_order": 4,
    },
    {
        "category": "general",
        "phrase_ja": "診断書をください",
        "phrase_reading": "しんだんしょをください",
        "translations": json.dumps({"en": "Please give me a medical certificate", "zh": "请给我诊断书", "vi": "Xin cho tôi giấy chứng nhận y tế", "ko": "진단서를 주세요", "pt": "Por favor, me dê um atestado médico"}),
        "context": json.dumps({"en": "You may need this for work absence or insurance claims. Costs ¥3,000-5,000.", "zh": "请假或保险理赔时可能需要。费用约3,000-5,000日元。", "vi": "Bạn có thể cần cho nghỉ làm hoặc yêu cầu bảo hiểm. Chi phí ¥3,000-5,000.", "ko": "결근 또는 보험 청구에 필요할 수 있습니다. 비용 ¥3,000-5,000.", "pt": "Pode precisar para ausência no trabalho ou reivindicações de seguro. Custa ¥3.000-5.000."}),
        "sort_order": 5,
    },
]


def seed():
    now = datetime.now(timezone.utc).isoformat()
    with engine.connect() as conn:
        result = conn.execute(text("SELECT COUNT(*) FROM medical_phrases"))
        count = result.scalar()
        if count and count > 0:
            print(f"medical_phrases already has {count} records. Clearing...")
            conn.execute(text("DELETE FROM medical_phrases"))
            conn.commit()

        for phrase in PHRASES:
            conn.execute(
                text("""
                    INSERT INTO medical_phrases
                    (id, category, phrase_ja, phrase_reading, translations,
                     context, sort_order, is_active, created_at, updated_at)
                    VALUES
                    (:id, :category, :phrase_ja, :phrase_reading, :translations,
                     :context, :sort_order, 1, :now, :now)
                """),
                {
                    "id": str(uuid.uuid4()),
                    "now": now,
                    **phrase,
                },
            )
        conn.commit()

        categories = {}
        for p in PHRASES:
            categories[p["category"]] = categories.get(p["category"], 0) + 1
        cat_str = ", ".join(f"{k}: {v}" for k, v in categories.items())
        print(f"✅ Seeded {len(PHRASES)} medical phrases ({cat_str}).")


if __name__ == "__main__":
    seed()
