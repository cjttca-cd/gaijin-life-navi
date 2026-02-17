# Handoff: Emergency Guide (S12)

> Version: 1.0.0 | Created: 2026-02-17
> Screen: S12 Emergency Guide
> Design System: `design/DESIGN_SYSTEM.md` v1.0.0
> ⚠️ This screen is accessible without authentication. Emergency tab always shows `colorError` icon.

---

## S12: Emergency Guide

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│ ████████ Emergency ██████████████████│  AppBar: RED bg (#DC2626)
│ ████████████████████████████████████ │  White text + icons
├──────────────────────────────────────┤
│                                       │
│  ⚠️ If you are in immediate danger,  │  Warning banner
│  call 110 (Police) or 119 (Fire/     │  colorErrorContainer bg
│  Ambulance) immediately.              │
│                                       │
│ ── Emergency Contacts ─────────────── │  Section header
│                                       │
│  ┌────────────────────────────────┐   │
│  │                                │   │
│  │  🚔 Police                    │   │  Contact card 80dp
│  │  110                          │   │  Large number
│  │                     ┌──────┐  │   │
│  │                     │  📞  │  │   │  Call button (red circle)
│  │                     └──────┘  │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │                                │   │
│  │  🚑 Fire / Ambulance          │   │
│  │  119                          │   │
│  │                     ┌──────┐  │   │
│  │                     │  📞  │  │   │
│  │                     └──────┘  │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  🏥 Medical Consultation      │   │
│  │  #7119                        │   │
│  │  Non-emergency medical        │   │
│  │  consultation           📞   │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  💚 TELL Japan (Mental Health)│   │
│  │  03-5774-0992                 │   │
│  │  Counseling in English        │   │
│  │                          📞   │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  🌏 Japan Helpline            │   │
│  │  0570-064-211                 │   │
│  │  24h, multilingual            │   │
│  │                          📞   │   │
│  └────────────────────────────────┘   │
│                                       │
│ ── How to Call an Ambulance ───────── │  Section header
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 1. Call 119                    │   │  Numbered steps
│  │                                │   │  (Card style)
│  │ 2. Say "Kyuukyuu desu"        │   │
│  │    (救急です — It's an        │   │
│  │    emergency)                  │   │
│  │                                │   │
│  │ 3. Explain your location      │   │
│  │    (address, landmarks)       │   │
│  │                                │   │
│  │ 4. Describe the situation     │   │
│  │                                │   │
│  │ 5. Wait for the ambulance     │   │
│  │    at the entrance            │   │
│  └────────────────────────────────┘   │
│                                       │
│ ── Need more help? ───────────────── │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  💬 Chat with AI about        │   │  Secondary Button
│  │     emergency situations       │   │
│  └────────────────────────────────┘   │
│                                       │
│  ─────────────────────────────────    │
│  ⚠️ This guide provides general     │  Disclaimer
│  health information and is not a      │
│  substitute for professional medical  │
│  advice. In an emergency, call 119.   │
│                                       │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │  BottomNavigationBar
│ Home  Chat Guide  SOS Profile        │  SOS = active
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

**AppBar & Warning:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `emergency_title` | Emergency | 紧急情况 | Khẩn cấp | 긴급 | Emergência |
| `emergency_warning` | If you are in immediate danger, call 110 (Police) or 119 (Fire/Ambulance) immediately. | 如果你处于紧急危险中，请立即拨打110（警察）或119（消防/救护车）。 | Nếu bạn đang gặp nguy hiểm, hãy gọi 110 (Cảnh sát) hoặc 119 (Cứu hỏa/Cứu thương) ngay lập tức. | 즉각적인 위험에 처해 있다면 110(경찰) 또는 119(소방/구급)에 즉시 전화하세요. | Se você está em perigo imediato, ligue 110 (Polícia) ou 119 (Bombeiros/Ambulância) imediatamente. |

**Section headers:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `emergency_section_contacts` | Emergency Contacts | 紧急联系方式 | Liên hệ khẩn cấp | 긴급 연락처 | Contatos de emergência |
| `emergency_section_ambulance` | How to Call an Ambulance | 如何叫救护车 | Cách gọi xe cứu thương | 구급차 호출 방법 | Como chamar uma ambulância |
| `emergency_section_more_help` | Need more help? | 需要更多帮助？ | Cần thêm trợ giúp? | 더 많은 도움이 필요하세요? | Precisa de mais ajuda? |

**Emergency contacts:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `emergency_police_name` | Police | 警察 | Cảnh sát | 경찰 | Polícia |
| `emergency_police_number` | 110 | 110 | 110 | 110 | 110 |
| `emergency_fire_name` | Fire / Ambulance | 消防/救护车 | Cứu hỏa / Cứu thương | 소방/구급 | Bombeiros / Ambulância |
| `emergency_fire_number` | 119 | 119 | 119 | 119 | 119 |
| `emergency_medical_name` | Medical Consultation | 医疗咨询 | Tư vấn y tế | 의료 상담 | Consulta médica |
| `emergency_medical_number` | #7119 | #7119 | #7119 | #7119 | #7119 |
| `emergency_medical_note` | Non-emergency medical advice | 非紧急医疗咨询 | Tư vấn y tế không khẩn cấp | 비응급 의료 상담 | Aconselhamento médico não emergencial |
| `emergency_tell_name` | TELL Japan (Mental Health) | TELL Japan（心理健康） | TELL Japan (Sức khỏe tâm thần) | TELL Japan (정신건강) | TELL Japan (Saúde Mental) |
| `emergency_tell_number` | 03-5774-0992 | 03-5774-0992 | 03-5774-0992 | 03-5774-0992 | 03-5774-0992 |
| `emergency_tell_note` | Counseling in English | 英语心理咨询 | Tư vấn bằng tiếng Anh | 영어 상담 | Aconselhamento em inglês |
| `emergency_helpline_name` | Japan Helpline | Japan Helpline | Japan Helpline | Japan Helpline | Japan Helpline |
| `emergency_helpline_number` | 0570-064-211 | 0570-064-211 | 0570-064-211 | 0570-064-211 | 0570-064-211 |
| `emergency_helpline_note` | 24 hours, multilingual | 24小时，多语言 | 24 giờ, đa ngôn ngữ | 24시간, 다국어 | 24 horas, multilíngue |

**Ambulance guide steps:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `emergency_step1` | Call 119 | 拨打119 | Gọi 119 | 119에 전화 | Ligue 119 |
| `emergency_step2` | Say "Kyuukyuu desu" (救急です — It's an emergency) | 说"Kyuukyuu desu"（救急です——这是紧急情况） | Nói "Kyuukyuu desu" (救急です — Đây là trường hợp khẩn cấp) | "큐큐데스"라고 말하세요 (救急です — 응급입니다) | Diga "Kyuukyuu desu" (救急です — É uma emergência) |
| `emergency_step3` | Explain your location (address, nearby landmarks) | 说明你的位置（地址、附近的标志性建筑） | Giải thích vị trí của bạn (địa chỉ, mốc gần đó) | 위치를 설명하세요 (주소, 근처 랜드마크) | Explique sua localização (endereço, pontos de referência) |
| `emergency_step4` | Describe the situation (what happened, symptoms) | 描述情况（发生了什么，症状） | Mô tả tình huống (chuyện gì xảy ra, triệu chứng) | 상황을 설명하세요 (무슨 일이 있었는지, 증상) | Descreva a situação (o que aconteceu, sintomas) |
| `emergency_step5` | Wait for the ambulance at the entrance of your building | 在你的建筑入口处等待救护车 | Đợi xe cứu thương ở lối vào tòa nhà | 건물 입구에서 구급차를 기다리세요 | Espere a ambulância na entrada do seu prédio |

**Japanese phrases for emergency (always shown regardless of UI language):**

| Key | Japanese | Romanization | Translation Key |
|-----|---------|-------------|-----------------|
| `emergency_phrase_emergency` | 救急です | Kyuukyuu desu | It's an emergency |
| `emergency_phrase_help` | 助けてください | Tasukete kudasai | Please help |
| `emergency_phrase_ambulance` | 救急車をお願いします | Kyuukyuusha wo onegai shimasu | Please send an ambulance |
| `emergency_phrase_address` | 住所は〇〇です | Juusho wa ○○ desu | The address is ○○ |

Translation for these phrases (shown as helper text):

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `emergency_phrase_emergency_help` | It's an emergency | 这是紧急情况 | Đây là trường hợp khẩn cấp | 응급입니다 | É uma emergência |
| `emergency_phrase_help_help` | Please help | 请帮忙 | Xin giúp đỡ | 도와주세요 | Por favor, ajude |
| `emergency_phrase_ambulance_help` | Please send an ambulance | 请叫救护车 | Xin gọi xe cứu thương | 구급차를 보내주세요 | Por favor, envie uma ambulância |
| `emergency_phrase_address_help` | The address is ○○ | 地址是○○ | Địa chỉ là ○○ | 주소는 ○○입니다 | O endereço é ○○ |

**CTA & Disclaimer:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `emergency_ask_ai` | Chat with AI about emergency situations | 与 AI 聊聊紧急情况 | Chat với AI về tình huống khẩn cấp | AI와 응급 상황에 대해 대화하기 | Falar com IA sobre situações de emergência |
| `emergency_disclaimer` | This guide provides general health information and is not a substitute for professional medical advice. In an emergency, call 119 immediately. | 本指南提供一般健康信息，不能替代专业医疗建议。紧急情况请立即拨打119。 | Hướng dẫn này cung cấp thông tin sức khỏe chung, không thay thế tư vấn y tế chuyên nghiệp. Trong trường hợp khẩn cấp, hãy gọi 119 ngay. | 이 가이드는 일반적인 건강 정보를 제공하며 전문 의료 조언을 대체하지 않습니다. 응급 상황에서는 즉시 119에 전화하세요. | Este guia fornece informações gerais de saúde e não substitui orientação médica profissional. Em caso de emergência, ligue 119 imediatamente. |
| `emergency_call_button` | Call | 拨打 | Gọi | 전화 | Ligar |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §8.4 — bg `colorError` (#DC2626), title/icons White |
| AppBar title | §2.2 `titleLarge` (18sp, SemiBold 600) #FFFFFF |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Warning banner | bg `colorErrorContainer` (#FEE2E2), text `colorOnErrorContainer` (#7F1D1D), `radiusMd` (12dp), icon `warning_amber` 20dp, padding 16dp |
| Warning text | §2.2 `bodyMedium` (14sp, Regular) `colorOnErrorContainer` |
| Section header | §2.2 `labelSmall` (11sp, Medium 500) `colorOnSurfaceVariant`, uppercase |
| Contact card | §8.4 — height 80dp, bg `colorSurface` (#FFFFFF), border 1dp `colorOutlineVariant`, `radiusMd` (12dp), padding 16dp |
| Contact name | §2.2 `titleSmall` (14sp, Medium 500) |
| Contact number | §2.2 `displayMedium` (28sp, Bold 700) `colorOnSurface` — for 110/119 |
| Contact number (others) | §2.2 `headlineMedium` (20sp, SemiBold 600) `colorOnSurface` |
| Contact note | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Call button | 48dp circle, bg `colorError` (#DC2626), icon `phone` 24dp White |
| Call button semanticLabel | "Call {number}" |
| Contact card spacing | §3.1 `spaceSm` (8dp) |
| Ambulance guide card | bg `colorSurface`, border 1dp `colorOutlineVariant`, `radiusMd` (12dp), padding 16dp |
| Step number | 24dp circle, bg `colorError` (#DC2626), text White, `labelMedium` (12sp, Bold) |
| Step text | §2.2 `bodyLarge` (16sp) |
| Japanese phrase | §2.2 `titleSmall` (14sp, Medium 500), `colorOnSurface` |
| Romanization | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant`, italic |
| Translation | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Ask AI button | §6.1.2 Secondary Button, full width, icon `chat_bubble_outline` |
| Disclaimer | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Disclaimer icon | `warning_amber` 14dp `colorOnSurfaceVariant` |
| BottomNavigationBar | §6.5.1 — SOS tab active, icon always `colorError` |
| Page padding | §3.2 16dp horizontal |
| Section spacing | §3.1 `space2xl` (24dp) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap call button (110) | `url_launcher` → `tel:110` — native phone dialer opens |
| Tap call button (119) | `url_launcher` → `tel:119` |
| Tap call button (#7119) | `url_launcher` → `tel:%237119` |
| Tap call button (03-5774-0992) | `url_launcher` → `tel:0357740992` |
| Tap call button (0570-064-211) | `url_launcher` → `tel:0570064211` |
| Tap entire contact card | Same as tap call button (whole card is tappable) |
| Contact card press state | bg `colorSurfaceVariant` (#F1F5F9) |
| Tap "Chat with AI" | Navigate → S08 (Chat) with domain=medical hint |
| Scroll | Standard scroll through all sections |
| Page entry animation | No stagger — all content visible immediately (emergency = instant access) |

> **ワンタップ発信**: Contact card 全体がタップ可能。ユーザーは番号を見て即座にタップするだけで電話が発信される。確認ダイアログは OS 標準のもの（Flutter の `url_launcher` が処理）。

### 5. API Data Mapping

| Data | API | Response → UI |
|------|-----|---------------|
| Emergency data | `GET /api/v1/emergency` | Endpoint is public (no auth required) |
| Contacts | — | `data.contacts[]` → contact cards |
| Per contact | — | `.name` → card title, `.number` → displayed number + tel: link, `.note` → subtitle text |
| Guide content | — | `data.content` → ambulance guide (markdown rendered) |
| Title | — | `data.title` → page header (optional, AppBar uses fixed "Emergency") |

### 6. State Variations

#### Loading State
- **No skeleton / shimmer** for emergency screen
- Show hardcoded 110/119 contacts immediately (cached/embedded in app)
- Additional contacts load from API in background

#### Offline / Error State
```
┌──────────────────────────────────────┐
│ ████████ Emergency ██████████████████│
├──────────────────────────────────────┤
│                                       │
│  ⚠️ If you are in immediate danger   │
│  call 110 or 119 immediately.         │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  🚔 Police        110    📞   │   │  Always available (hardcoded)
│  └────────────────────────────────┘   │
│  ┌────────────────────────────────┐   │
│  │  🚑 Ambulance     119    📞   │   │  Always available (hardcoded)
│  └────────────────────────────────┘   │
│                                       │
│  ⚠️ Unable to load additional info.  │  Error message
│     Call 110 or 119 if you need help. │
│                                       │
└──────────────────────────────────────┘
```

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `emergency_offline` | Unable to load additional information. Call 110 or 119 if you need help. | 无法加载更多信息。如需帮助请拨打110或119。 | Không thể tải thêm thông tin. Gọi 110 hoặc 119 nếu bạn cần giúp đỡ. | 추가 정보를 불러올 수 없습니다. 도움이 필요하면 110 또는 119에 전화하세요. | Não foi possível carregar informações adicionais. Ligue 110 ou 119 se precisar de ajuda. |

> **Critical**: 110/119 must ALWAYS be available, even offline. Embed these contacts in the app binary, do not depend on API.

#### Tier Differences
- **No tier differences** — Emergency screen is identical for all users (Guest, Free, Standard, Premium)
- No authentication required
- No usage limits apply
