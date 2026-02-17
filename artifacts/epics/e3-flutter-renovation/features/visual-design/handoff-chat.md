# Handoff: AI Chat Screen (S08) — 最重要画面

> Version: 1.0.0 | Created: 2026-02-17
> Screen: S08 AI Chat
> Design System: `design/DESIGN_SYSTEM.md` v1.0.0
> ⚠️ この画面はアプリのコアバリュー。全仕様を正確に実装すること。

---

## S08: AI Chat

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│ ←  AI Chat            domain badge   │  AppBar: titleLarge
│                         [Banking]     │  domain badge (optional)
├──────────────────────────────────────┤
│                                       │
│ ┌──────────────────────────────────┐  │  ← Usage limit banner
│ │ ⓘ 3/5 free chats remaining     │  │    (Free tier only)
│ │   today.      Upgrade →         │  │    colorWarningContainer bg
│ └──────────────────────────────────┘  │
│                                       │
│ ── Today ──────────────────────────── │  Date separator
│                                       │
│                    ┌────────────────┐ │
│                    │ I want to open │ │  User bubble (right)
│                    │ a bank account │ │  colorPrimary bg
│                    │          10:30 │ │
│                    └────────────────┘ │
│                                       │
│ ┌───┐                                 │
│ │ 🤖│                                │  AI avatar 28dp
│ └───┘                                 │
│ ┌──────────────────────────────────┐  │
│ │ Here's a guide to opening a     │  │  AI bubble (left)
│ │ bank account in Japan.          │  │  colorSurfaceVariant bg
│ │                                  │  │
│ │ ## Required Documents            │  │  ← Markdown H2
│ │                                  │  │
│ │ 1. **Residence Card** (在留カード)│  │  ← Bold + Japanese
│ │ 2. **Passport**                  │  │  ← Numbered list
│ │ 3. **Proof of Address** (住民票) │  │
│ │                                  │  │
│ │ ## Recommended Banks             │  │
│ │                                  │  │
│ │ - **Yucho Bank**: Nationwide     │  │  ← Bulleted list
│ │ - **SMBC**: English online...    │  │
│ │                                  │  │
│ │ ─────── Sources ───────          │  │  ← Source divider
│ │ 📎 FSA Foreign Residents Guide  │  │  ← Source links
│ │ 📎 Zenginkyo Account Manual     │  │
│ │                                  │  │
│ │ [💡 Ask AI] [📋 Add to Tracker] │  │  ← Action chips
│ └──────────────────────────────────┘  │
│ ⚠️ General information only.         │  ← Disclaimer (outside bubble)
│    Not legal advice.                  │    labelSmall, variant
│                                       │
│ ┌───┐                                 │
│ │ 🤖│ ● ● ●                          │  ← Typing indicator
│ └───┘                                 │    (when AI is responding)
│                                       │
├──────────────────────────────────────┤
│ ┌──────────────────────────────┐ ┌─┐ │  Chat Input Bar
│ │ 📎 Type your message...      │ │→│ │  colorSurface bg
│ └──────────────────────────────┘ └─┘ │  border-top 1dp
│ SafeArea                              │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │  BottomNavigationBar
│ Home  Chat Guide  SOS Profile        │  Chat = active
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

**AppBar & Navigation:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_title` | AI Chat | AI 对话 | AI Chat | AI 채팅 | Chat IA |
| `chat_domain_banking` | Banking | 银行 | Ngân hàng | 은행 | Banco |
| `chat_domain_visa` | Visa | 签证 | Visa | 비자 | Visto |
| `chat_domain_medical` | Medical | 医疗 | Y tế | 의료 | Saúde |
| `chat_domain_concierge` | General | 综合 | Tổng hợp | 종합 | Geral |

**Chat Input:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_input_placeholder` | Type your message... | 输入你的消息... | Nhập tin nhắn... | 메시지를 입력하세요... | Digite sua mensagem... |
| `chat_input_send` | Send | 发送 | Gửi | 보내기 | Enviar |
| `chat_input_attach` | Attach image | 添加图片 | Đính kèm ảnh | 이미지 첨부 | Anexar imagem |

**Usage Limit Banner (Free tier):**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_limit_remaining` | {remaining}/{limit} free chats remaining today. | 今日剩余 {remaining}/{limit} 次免费对话。 | Còn {remaining}/{limit} lượt chat miễn phí hôm nay. | 오늘 무료 채팅 {remaining}/{limit}회 남음. | {remaining}/{limit} chats grátis restantes hoje. |
| `chat_limit_upgrade` | Upgrade | 升级 | Nâng cấp | 업그레이드 | Upgrade |
| `chat_limit_exhausted` | You've used all your free chats for today. Upgrade to keep chatting! | 你今天的免费对话已用完。升级以继续对话！ | Bạn đã dùng hết lượt chat miễn phí hôm nay. Nâng cấp để tiếp tục! | 오늘의 무료 채팅을 모두 사용했습니다. 업그레이드하여 계속하세요! | Você usou todos os chats grátis de hoje. Faça upgrade para continuar! |
| `chat_limit_standard_remaining` | {remaining}/{limit} chats remaining this month. | 本月剩余 {remaining}/{limit} 次对话。 | Còn {remaining}/{limit} lượt chat tháng này. | 이번 달 {remaining}/{limit}회 채팅 남음. | {remaining}/{limit} chats restantes este mês. |

**AI Response Elements:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_sources_header` | Sources | 参考来源 | Nguồn tham khảo | 출처 | Fontes |
| `chat_disclaimer` | This is general information only. It does not constitute legal advice. Please verify with relevant authorities. | 以上为一般性信息，不构成法律建议。请向相关机构确认。 | Đây chỉ là thông tin chung, không phải tư vấn pháp lý. Vui lòng xác nhận với cơ quan liên quan. | 이 정보는 일반적인 안내이며 법적 조언이 아닙니다. 관련 기관에 확인하세요. | Esta é apenas informação geral. Não constitui aconselhamento jurídico. Verifique com as autoridades competentes. |
| `chat_disclaimer_medical` | This guide provides general health information and is not a substitute for professional medical advice. In an emergency, call 119 immediately. | 本指南提供一般健康信息，不能替代专业医疗建议。紧急情况请立即拨打119。 | Hướng dẫn này cung cấp thông tin sức khỏe chung, không thay thế tư vấn y tế chuyên nghiệp. Trong trường hợp khẩn cấp, hãy gọi 119 ngay. | 이 가이드는 일반적인 건강 정보를 제공하며 전문 의료 조언을 대체하지 않습니다. 응급 상황에서는 즉시 119에 전화하세요. | Este guia fornece informações gerais de saúde e não substitui orientação médica profissional. Em caso de emergência, ligue 119 imediatamente. |
| `chat_disclaimer_visa` | This is general information about visa procedures and does not constitute immigration advice. Always consult the Immigration Services Agency or a qualified lawyer. | 这是有关签证手续的一般信息，不构成移民建议。请咨询入管局或合格律师。 | Đây là thông tin chung về thủ tục visa, không phải tư vấn nhập cư. Hãy tham khảo Cục Quản lý Nhập cư hoặc luật sư có chuyên môn. | 이것은 비자 절차에 대한 일반적인 정보이며 이민 조언이 아닙니다. 출입국재류관리청 또는 자격을 갖춘 변호사에게 상담하세요. | Estas são informações gerais sobre procedimentos de visto e não constituem aconselhamento de imigração. Consulte sempre a Agência de Serviços de Imigração ou um advogado qualificado. |

**Action Chips:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_action_ask_more` | Ask more about this | 了解更多 | Hỏi thêm về điều này | 이에 대해 더 질문하기 | Perguntar mais sobre isso |
| `chat_action_add_tracker` | Add to Tracker | 添加到待办 | Thêm vào danh sách | 트래커에 추가 | Adicionar ao Rastreador |

**Empty State (no messages yet):**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_empty_title` | Ask me anything! | 有什么想问的？ | Hãy hỏi bất cứ điều gì! | 무엇이든 물어보세요! | Pergunte-me qualquer coisa! |
| `chat_empty_subtitle` | I can help you with banking, visa, medical questions and more about life in Japan. | 我可以帮你解答银行、签证、医疗等日本生活问题。 | Tôi có thể giúp bạn về ngân hàng, visa, y tế và nhiều vấn đề khác về cuộc sống tại Nhật. | 은행, 비자, 의료 등 일본 생활에 대한 질문에 도움을 드릴 수 있습니다. | Posso ajudar com perguntas sobre banco, visto, saúde e mais sobre a vida no Japão. |

**Suggested prompts (Empty state chips):**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_suggest_bank` | How do I open a bank account? | 如何开设银行账户？ | Làm sao để mở tài khoản ngân hàng? | 은행 계좌는 어떻게 만드나요? | Como abro uma conta bancária? |
| `chat_suggest_visa` | How to renew my visa? | 如何续签签证？ | Làm sao để gia hạn visa? | 비자 갱신은 어떻게 하나요? | Como renovar meu visto? |
| `chat_suggest_medical` | How to see a doctor? | 如何就医？ | Làm sao để khám bệnh? | 병원에 가려면 어떻게 하나요? | Como consultar um médico? |
| `chat_suggest_general` | What do I need after arriving in Japan? | 来日本后需要做什么？ | Cần làm gì sau khi đến Nhật? | 일본에 도착하면 무엇을 해야 하나요? | O que preciso fazer depois de chegar ao Japão? |

**Error messages:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_error_send` | Unable to send your message. Please try again. | 无法发送消息，请重试。 | Không thể gửi tin nhắn. Vui lòng thử lại. | 메시지를 보낼 수 없습니다. 다시 시도해주세요. | Não foi possível enviar sua mensagem. Tente novamente. |
| `chat_error_network` | No internet connection. Please check your network. | 无网络连接，请检查网络。 | Không có kết nối internet. Vui lòng kiểm tra mạng. | 인터넷에 연결되지 않았습니다. 네트워크를 확인해주세요. | Sem conexão com a internet. Verifique sua rede. |
| `chat_error_agent` | Something went wrong. Please try again. | 出了点问题，请重试。 | Đã xảy ra lỗi. Vui lòng thử lại. | 문제가 발생했습니다. 다시 시도해주세요. | Algo deu errado. Tente novamente. |
| `chat_error_retry` | Retry | 重试 | Thử lại | 다시 시도 | Tentar novamente |
| `chat_error_too_long` | Message is too long. Maximum {max} characters. | 消息太长，最多 {max} 个字符。 | Tin nhắn quá dài. Tối đa {max} ký tự. | 메시지가 너무 깁니다. 최대 {max}자입니다. | Mensagem muito longa. Máximo de {max} caracteres. |

**Date separators:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_date_today` | Today | 今天 | Hôm nay | 오늘 | Hoje |
| `chat_date_yesterday` | Yesterday | 昨天 | Hôm qua | 어제 | Ontem |

**Timestamp format:**

| Language | Format | Example |
|----------|--------|---------|
| en | h:mm a | 2:30 PM |
| zh | HH:mm | 14:30 |
| vi | HH:mm | 14:30 |
| ko | a h:mm | 오후 2:30 |
| pt | HH:mm | 14:30 |

### 3. Component Mapping

#### AppBar
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar, height 56dp |
| Title | §2.2 `titleLarge` (18sp, SemiBold 600) |
| Domain badge | §6.7.3 Info Tag — domain color variant |
| Back button (from Navigator) | §7.5 `arrow_back_ios` 24dp |

#### Usage Limit Banner
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Container | §6.9.4 — `colorWarningContainer` (#FEF3C7) bg, `radiusMd` (12dp), 12dp padding |
| Info icon | §7.5 `info_outline` 20dp `colorWarning` (#F59E0B) |
| Text | §2.2 `bodySmall` (12sp) `colorOnWarningContainer` (#78350F) |
| Upgrade button | §6.1.4 Text Button `colorPrimary` |
| Position | Fixed at top of chat list, not scrollable |

#### User Chat Bubble
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Background | §6.2.3 — `colorPrimary` (#2563EB) |
| Text | §2.2 `bodyLarge` (16sp) #FFFFFF |
| Border Radius | 8dp top-left, 8dp top-right, 2dp bottom-right, 8dp bottom-left |
| Max Width | 75% of screen width |
| Padding | 12dp horizontal, 8dp vertical |
| Alignment | Right-aligned |
| Timestamp | §2.2 `labelSmall` (11sp) rgba(255,255,255,0.7), bottom-right |
| Consecutive spacing | 4dp (same sender), 12dp (different sender) — §6.9.1 |

#### AI Chat Bubble
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Background | §6.2.4 — `colorSurfaceVariant` (#F1F5F9) |
| Text | §2.2 `bodyLarge` (16sp) `colorOnSurface` (#1E293B) |
| Border Radius | 8dp top-left, 8dp top-right, 8dp bottom-right, 2dp bottom-left |
| Max Width | 85% of screen width |
| Padding | 12dp horizontal, 8dp vertical |
| Alignment | Left-aligned |
| AI Avatar | 28dp circle, `colorPrimary` bg, `explore` icon white |
| Avatar position | Above bubble, left-aligned |

#### Markdown Rendering in AI Bubble
| Markdown Element | Rendering | DESIGN_SYSTEM Reference |
|------------------|-----------|------------------------|
| `# Heading 1` | `titleMedium` (16sp, Medium 500), 12dp top margin | §2.2 |
| `## Heading 2` | `titleSmall` (14sp, Medium 500), 8dp top margin | §6.2.4 |
| `**bold**` | SemiBold (600) | §6.2.4 |
| `*italic*` | Italic style | — |
| `- bullet list` | `bodyMedium` (14sp), 16dp left indent, `colorPrimary` bullet dot | §6.2.4 |
| `1. numbered list` | `bodyMedium` (14sp), 16dp left indent, `colorPrimary` number | §6.2.4 |
| `` `inline code` `` | `bodySmall` (12sp) monospace, bg #E2E8F0, radius 4dp | §6.2.4 |
| ```` ```code block``` ```` | `bodySmall` (12sp) monospace, bg #E2E8F0, radius 4dp, 8dp padding | §6.2.4 |
| `[link text](url)` | `colorPrimary`, underline | §6.2.4 |
| `> blockquote` | Left border 3dp `colorPrimary`, 12dp left padding, bg `colorPrimaryFixed` (#EFF6FF) | — |

> **Phase 0 制約**: SSE ストリーミングなし → 同期レスポンス。AI の全回答がまとめて表示される。Typing Indicator で待機感を演出。

#### Source Citation Section
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Divider | 1dp `colorOutline` (#CBD5E1), full width within bubble, 8dp vertical margin |
| Header text | §2.2 `labelSmall` (11sp, Medium 500) `colorOnSurfaceVariant`, "Sources" / "参考来源" etc. |
| Source icon | `attach_file` 16dp `colorPrimary` |
| Source title | §2.2 `bodySmall` (12sp) `colorPrimary`, tappable (opens URL in browser) |
| Source row height | 32dp |
| Source row spacing | 4dp between sources |

#### Action Chips
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Container | §6.9.3 — height 32dp, `colorPrimaryContainer` (#DBEAFE) bg, `radiusFull` (999dp) |
| Icon | 16dp `colorPrimary` |
| Text | §2.2 `labelMedium` (12sp, Medium 500) `colorPrimary` |
| Padding | 12dp horizontal |
| Spacing | 8dp between chips |
| Position | Below source section, inside bubble |

#### Disclaimer
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Text | §2.2 `labelSmall` (11sp, Regular) `colorOnSurfaceVariant` (#64748B) |
| Icon | `warning_amber` 14dp `colorOnSurfaceVariant` |
| Position | **Outside** AI bubble, below it, left-aligned with 12dp left padding |
| Spacing | 4dp below bubble |

#### Typing Indicator
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Container | §6.9.5 — same shape as AI bubble, `colorSurfaceVariant` bg |
| Dots | 3 × 6dp circles, `colorOnSurfaceVariant` (#64748B) |
| Animation | Each dot bounces up 4dp with 300ms offset between dots |
| Avatar | Same AI avatar (28dp) shown above |

#### Chat Input Bar
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Container | §6.3.4 — `colorSurface` (#FFFFFF) bg, border-top 1dp `colorOutlineVariant` |
| Input field | §6.3.4 — bg #F1F5F9, `radiusFull` (999dp), `bodyLarge` (16sp) |
| Send button | §6.3.4 — 40dp circle, bg `colorPrimary`, icon send #FFFFFF 24dp |
| Send button disabled | bg #E2E8F0, icon #94A3B8 (when input is empty) |
| Attach button | §7.5 `attach_file` 24dp, `colorOnSurfaceVariant`, **disabled** in Phase 0 |
| Attach button disabled | opacity 0.4, non-tappable |
| Padding | 8dp top/bottom, 16dp left/right |
| Safe area | Add device bottom safe area inset |

#### Date Separator
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Layout | Centered text with horizontal lines on each side |
| Line | 1dp `colorOutlineVariant` (#E2E8F0) |
| Text | §2.2 `labelSmall` (11sp) `colorOnSurfaceVariant` |
| Margin | 16dp vertical |

#### BottomNavigationBar
| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Full spec | §6.5.1 — Chat tab = active |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Type in input | Enable send button when text.length > 0 |
| Tap send | 1. Add user bubble to list. 2. Clear input. 3. Show typing indicator. 4. POST /api/v1/chat. 5. Replace typing indicator with AI bubble. 6. Show disclaimer below. |
| Tap source link | Open URL in external browser (or in-app WebView) |
| Tap "Ask more about this" chip | Pre-fill input with context question related to the AI message |
| Tap "Add to Tracker" chip | Snackbar: "Added to your tracker" (Phase 0: visual feedback only, tracker feature limited) |
| Tap "Upgrade" in limit banner | Navigate → S16 (Subscription) |
| Tap domain badge | No action (informational only) |
| Tap attach button (Phase 0) | Show Snackbar: "Image sending coming soon!" |
| Scroll up | Load previous messages in session |
| Message send animation | User bubble: FadeTransition + SlideTransition (bottom 20dp→0) 200ms (§9.1) |
| AI response animation | AI bubble: FadeTransition + SlideTransition (bottom 20dp→0) 200ms |
| Typing indicator | Appears immediately after user sends message |
| Auto-scroll | Scroll to bottom when new message arrives |
| Long press user bubble | Copy text to clipboard → Snackbar "Copied" |
| Long press AI bubble | Copy text to clipboard → Snackbar "Copied" |
| Keyboard dismiss | Tap outside input field / scroll chat list |

**Coming from Navigator (S11 "Ask AI" button):**
- Pre-fill domain hint in request
- Show domain badge in AppBar
- Optionally pre-fill a suggested question

### 5. API Data Mapping

#### Send Message: `POST /api/v1/chat`

**Request:**
```json
{
  "message": "I want to open a bank account",
  "image": null,
  "domain": null,
  "locale": "en"
}
```

**Response → UI Mapping:**

| Response Field | UI Element |
|----------------|-----------|
| `data.reply` | AI bubble text (markdown rendered) |
| `data.domain` | Domain badge in AppBar + disclaimer variant selection |
| `data.sources[].title` | Source citation text |
| `data.sources[].url` | Source citation tap target |
| `data.actions[].type` | Action chip icon selection |
| `data.actions[].text` or `items` | Action chip text or tracker item |
| `data.tracker_items[]` | "Add to Tracker" chip data |
| `data.usage.used` | Limit banner numerator |
| `data.usage.limit` | Limit banner denominator |
| `data.usage.tier` | Limit banner visibility logic + variant |

**Error Handling:**

| Error Code | UI Behavior |
|------------|------------|
| 429 `USAGE_LIMIT_EXCEEDED` | Replace typing indicator with limit exhausted banner. Disable input. Show upgrade CTA. |
| 502 `AGENT_ERROR` | Show error bubble with retry button in place of AI response |
| 500 `INTERNAL_ERROR` | Show error bubble with retry button |
| Network error | Show error Snackbar + keep user message with "retry" icon |

#### Usage Check: `GET /api/v1/usage`

Called on screen load to populate limit banner.

| Response Field | UI Element |
|----------------|-----------|
| `data.chat_remaining` | Banner "{remaining}" |
| `data.chat_limit` | Banner "{limit}" |
| `data.tier` | Banner variant (free/standard) or hidden (premium) |

### 6. State Variations

#### Empty State (First Visit)
```
┌──────────────────────────────────────┐
│ ←  AI Chat                           │
├──────────────────────────────────────┤
│                                       │
│                                       │
│            ┌────────┐                 │
│            │  💬    │  64dp icon      │
│            └────────┘                 │
│                                       │
│      Ask me anything!                 │  headlineMedium 20sp
│  I can help you with banking,         │  bodyMedium 14sp, variant
│  visa, medical questions and more     │
│  about life in Japan.                 │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ 🏦 How do I open a bank acct?  │  │  Suggestion chips
│  └─────────────────────────────────┘  │  (Outline style)
│  ┌─────────────────────────────────┐  │
│  │ 🛂 How to renew my visa?       │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ 🏥 How to see a doctor?        │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ 🗾 What to do after arriving?  │  │
│  └─────────────────────────────────┘  │
│                                       │
├──────────────────────────────────────┤
│ │ 📎 Type your message...      │ │→│ │
└──────────────────────────────────────┘
```

Suggestion chips:
- Height: 48dp
- Background: `colorSurface` (#FFFFFF)
- Border: 1dp `colorOutline` (#CBD5E1)
- Border Radius: `radiusSm` (8dp)
- Icon: 20dp, domain accent color
- Text: `bodyMedium` (14sp) `colorOnSurface`
- Padding: 12dp horizontal
- Tap: Pre-fill input and auto-send

#### Loading State (AI Responding)
- Typing indicator shown below last message
- Input field disabled with reduced opacity
- Send button disabled

#### Error State (Failed AI Response)
```
│ ┌───┐                                 │
│ │ 🤖│                                │
│ └───┘                                 │
│ ┌──────────────────────────────────┐  │
│ │ ⚠️ Something went wrong.       │  │  Error bubble
│ │                                  │  │  colorErrorContainer bg
│ │    [🔄 Retry]                    │  │  retry button
│ └──────────────────────────────────┘  │
```

Error bubble:
- Background: `colorErrorContainer` (#FEE2E2)
- Text: `bodyMedium` (14sp) `colorOnErrorContainer` (#7F1D1D)
- Retry button: §6.1.2 Secondary Button variant, small
- Border Radius: same as AI bubble

#### Usage Limit Exhausted (Free Tier)
```
│ ┌──────────────────────────────────┐  │
│ │ 🔒                              │  │  Lock icon
│ │                                  │  │
│ │ You've used all your free chats  │  │  titleSmall
│ │ for today.                       │  │
│ │                                  │  │
│ │ Upgrade to keep chatting!        │  │  bodyMedium, variant
│ │                                  │  │
│ │  ┌────────────────────────────┐  │  │
│ │  │      Upgrade Now           │  │  │  Primary Button
│ │  └────────────────────────────┘  │  │
│ │                                  │  │
│ │  Come back tomorrow for 5 more   │  │  bodySmall, variant
│ │  free chats.                     │  │
│ └──────────────────────────────────┘  │
```

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `chat_limit_exhausted_title` | You've used all your free chats for today. | 你今天的免费对话已用完。 | Bạn đã dùng hết lượt chat miễn phí hôm nay. | 오늘의 무료 채팅을 모두 사용했습니다. | Você usou todos os chats grátis de hoje. |
| `chat_limit_exhausted_subtitle` | Upgrade to keep chatting! | 升级以继续对话！ | Nâng cấp để tiếp tục chat! | 업그레이드하여 계속 채팅하세요! | Faça upgrade para continuar! |
| `chat_limit_exhausted_button` | Upgrade Now | 立即升级 | Nâng cấp ngay | 지금 업그레이드 | Upgrade agora |
| `chat_limit_come_back` | Come back tomorrow for {limit} more free chats. | 明天再来可获得 {limit} 次免费对话。 | Quay lại ngày mai để có {limit} lượt chat miễn phí. | 내일 다시 오시면 {limit}회 무료 채팅이 가능합니다. | Volte amanhã para mais {limit} chats grátis. |

- Input field disabled: bg #F1F5F9, placeholder text = "Upgrade to continue"
- Send button disabled state

#### Tier Differences

| Element | Free | Standard | Premium |
|---------|------|----------|---------|
| Limit banner | ✅ Shown (daily count) | ✅ Shown (monthly count) if remaining < 50 | ❌ Hidden |
| Usage exhausted overlay | ✅ Full overlay with upgrade CTA | ✅ Similar overlay but monthly | ❌ Never |
| Action chips | All shown | All shown | All shown |
| Attach button | Disabled (Phase 0) | Disabled (Phase 0) | Disabled (Phase 0) |
| Tracker chip | Show but limit to 3 items | Show, unlimited | Show, unlimited |

### 7. AI Bubble Complete Structure Spec

The AI response bubble is the most complex component. Here is the full rendering order:

```
[AI Avatar 28dp]  ← Always shown for first message in group

┌── AI Bubble ──────────────────────────────────────┐
│                                                    │
│  [Markdown-rendered reply text]                    │  ← §6.2.4 styles
│    • H1/H2 headings with spacing                  │
│    • Bold, italic, inline code                    │
│    • Numbered and bulleted lists                  │
│    • Code blocks with bg                          │
│    • Links in colorPrimary                        │
│                                                    │
│  ────────── Sources ──────────                    │  ← Divider + label
│  📎 Source Title 1                                │  ← Tappable links
│  📎 Source Title 2                                │
│                                                    │
│  [💡 Ask more] [📋 Add to Tracker]               │  ← Action chips
│                                                    │
│                                    10:30          │  ← Timestamp
└───────────────────────────────────────────────────┘

⚠️ This is general information only...              ← Disclaimer (OUTSIDE bubble)
```

**Rendering rules:**
1. `reply` → markdown parser → Flutter widgets
2. `sources` → if array is non-empty, show divider + source list
3. `actions` → if array is non-empty, show action chips
4. `tracker_items` → if array is non-empty, show "Add to Tracker" chip
5. Disclaimer → ALWAYS shown after every AI bubble (§5 BUSINESS_RULES)
6. Choose disclaimer variant based on `domain`: medical → medical disclaimer, visa → visa disclaimer, others → general disclaimer

### 8. Accessibility Notes

- All chat bubbles should have semantic labels: "You said: {text}" / "AI said: {text}"
- Send button: semanticLabel = "Send message"
- Attach button: semanticLabel = "Attach image (coming soon)"
- Source links: semanticLabel = "Open source: {title}"
- Action chips: semanticLabel per action type
- Typing indicator: semanticLabel = "AI is typing..."
- Respect `MediaQuery.textScaleFactor` — bubble max-width adapts
- Minimum tap target 48dp on all interactive elements (§10.3)
