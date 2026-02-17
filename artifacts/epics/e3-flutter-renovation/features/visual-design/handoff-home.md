# Handoff: Home Screen (S07)

> Version: 1.0.0 | Created: 2026-02-17
> Screen: S07 Home Dashboard
> Design System: `design/DESIGN_SYSTEM.md` v1.0.0

---

## S07: Home Screen

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
│                                       │
│  Good morning, Wei 👋                 │  displayMedium 28sp
│  Free • 3/5 chats remaining today     │  bodySmall 12sp, variant
│                                       │
│ ── Quick Actions ──────────────────── │  labelSmall 11sp, overline
│                                       │
│  ┌─────────────┐  ┌─────────────┐    │
│  │ 💬          │  │ 🏦          │    │
│  │ AI Chat     │  │ Banking     │    │  Quick Action Cards
│  │ Ask anything│  │ Guides      │    │  2-column grid
│  └─────────────┘  └─────────────┘    │
│  ┌─────────────┐  ┌─────────────┐    │
│  │ 🛂          │  │ 🏥          │    │
│  │ Visa        │  │ Medical     │    │
│  │ Guides      │  │ Guides      │    │
│  └─────────────┘  └─────────────┘    │
│                                       │
│ ── Explore Guides ─────────────────── │  labelSmall overline
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ 🧭  Browse all guides       →  │  │  List item → S09
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ 🆘  Emergency contacts      →  │  │  List item → S12
│  └─────────────────────────────────┘  │
│                                       │
│ ── Upgrade ────────── (Free only) ─── │
│  ┌─────────────────────────────────┐  │
│  │ ⭐ Get more from your AI       │  │  Upgrade banner
│  │    assistant. Upgrade now →     │  │  colorTertiaryContainer bg
│  └─────────────────────────────────┘  │
│                                       │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │  BottomNavigationBar
│ Home  Chat Guide  SOS Profile        │  Home = active
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

**Greeting:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_greeting_morning` | Good morning, {name} 👋 | 早上好，{name} 👋 | Chào buổi sáng, {name} 👋 | 좋은 아침이에요, {name} 👋 | Bom dia, {name} 👋 |
| `home_greeting_afternoon` | Good afternoon, {name} 👋 | 下午好，{name} 👋 | Chào buổi chiều, {name} 👋 | 좋은 오후예요, {name} 👋 | Boa tarde, {name} 👋 |
| `home_greeting_evening` | Good evening, {name} 👋 | 晚上好，{name} 👋 | Chào buổi tối, {name} 👋 | 좋은 저녁이에요, {name} 👋 | Boa noite, {name} 👋 |
| `home_greeting_default` | Hello, {name} 👋 | 你好，{name} 👋 | Xin chào, {name} 👋 | 안녕하세요, {name} 👋 | Olá, {name} 👋 |

> Greeting time rules: morning 5:00–11:59, afternoon 12:00–16:59, evening 17:00–4:59. Use device local time.

**Usage status:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_usage_free` | Free • {remaining}/{limit} chats remaining today | 免费版 • 今日剩余 {remaining}/{limit} 次对话 | Miễn phí • Còn {remaining}/{limit} lượt chat hôm nay | 무료 • 오늘 {remaining}/{limit}회 채팅 남음 | Grátis • {remaining}/{limit} chats restantes hoje |
| `home_usage_standard` | Standard • {remaining}/{limit} chats this month | 标准版 • 本月剩余 {remaining}/{limit} 次对话 | Tiêu chuẩn • {remaining}/{limit} lượt chat tháng này | 스탠다드 • 이번 달 {remaining}/{limit}회 채팅 남음 | Padrão • {remaining}/{limit} chats este mês |
| `home_usage_premium` | Premium • Unlimited chats | 高级版 • 无限对话 | Cao cấp • Chat không giới hạn | 프리미엄 • 무제한 채팅 | Premium • Chats ilimitados |

**Section headers:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_section_quick_actions` | Quick Actions | 快捷操作 | Thao tác nhanh | 빠른 실행 | Ações rápidas |
| `home_section_explore` | Explore Guides | 浏览指南 | Khám phá hướng dẫn | 가이드 둘러보기 | Explorar guias |

**Quick Action cards:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_qa_chat_title` | AI Chat | AI 对话 | AI Chat | AI 채팅 | Chat IA |
| `home_qa_chat_subtitle` | Ask anything about life in Japan | 关于日本生活的任何问题 | Hỏi bất kỳ điều gì về cuộc sống tại Nhật | 일본 생활에 대해 무엇이든 물어보세요 | Pergunte qualquer coisa sobre a vida no Japão |
| `home_qa_banking_title` | Banking | 银行 | Ngân hàng | 은행 | Banco |
| `home_qa_banking_subtitle` | Account opening, transfers & more | 开户、转账等 | Mở tài khoản, chuyển tiền & hơn thế | 계좌 개설, 송금 등 | Abertura de conta, transferências e mais |
| `home_qa_visa_title` | Visa | 签证 | Visa | 비자 | Visto |
| `home_qa_visa_subtitle` | Immigration guides & procedures | 入境指南和手续 | Hướng dẫn nhập cư & thủ tục | 이민 가이드 및 절차 | Guias e procedimentos de imigração |
| `home_qa_medical_title` | Medical | 医疗 | Y tế | 의료 | Saúde |
| `home_qa_medical_subtitle` | Health guides & emergency info | 健康指南和急救信息 | Hướng dẫn sức khỏe & thông tin khẩn cấp | 건강 가이드 및 응급 정보 | Guias de saúde e informações de emergência |

**Explorer shortcuts:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_explore_guides` | Browse all guides | 浏览所有指南 | Xem tất cả hướng dẫn | 모든 가이드 보기 | Ver todos os guias |
| `home_explore_emergency` | Emergency contacts | 紧急联系方式 | Liên hệ khẩn cấp | 긴급 연락처 | Contatos de emergência |

**Upgrade banner (Free tier only):**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_upgrade_title` | Get more from your AI assistant | 从 AI 助手获得更多帮助 | Nhận thêm từ trợ lý AI của bạn | AI 어시스턴트를 더 활용하세요 | Aproveite mais do seu assistente IA |
| `home_upgrade_cta` | Upgrade now | 立即升级 | Nâng cấp ngay | 지금 업그레이드 | Upgrade agora |

**Empty state (no name set):**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_greeting_no_name` | Welcome! 👋 | 欢迎！👋 | Chào mừng! 👋 | 환영합니다! 👋 | Bem-vindo! 👋 |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Background | §1.6 `colorBackground` (#FAFBFC) |
| AppBar area | §6.6.2 Home AppBar — no standard AppBar, greeting text acts as header |
| Greeting text | §2.2 `displayMedium` (28sp, Bold 700) `colorOnBackground` |
| Usage status | §2.2 `bodySmall` (12sp, Regular) `colorOnSurfaceVariant` |
| Section overline | §2.2 `labelSmall` (11sp, Medium 500) `colorOnSurfaceVariant`, uppercase |
| Quick Action cards | §6.2.1 variant — 2-column grid, gap 12dp |
| Card background | §1.6 `colorSurface` (#FFFFFF) |
| Card border | 1dp `colorOutlineVariant` (#E2E8F0) |
| Card radius | §4 `radiusMd` (12dp) |
| Card elevation | §5 Level 0 default → Level 1 on press |
| Card icon | 40dp × 40dp, domain Container color background in 48dp circle |
| Card title | §2.2 `titleMedium` (16sp, Medium 500) |
| Card subtitle | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Card padding | §3.1 `spaceLg` (16dp) |
| Explorer list items | §6.4.1 Standard List Item |
| Upgrade banner bg | §1.4 `colorTertiaryContainer` (#FEF3C7) |
| Upgrade banner text | §2.2 `titleSmall` (14sp, Medium 500) `colorOnTertiaryContainer` (#78350F) |
| Upgrade banner CTA | §6.1.4 Text Button, `colorPrimary` |
| Upgrade banner radius | §4 `radiusMd` (12dp) |
| Upgrade banner padding | §3.1 `spaceLg` (16dp) |
| BottomNavigationBar | §6.5.1 — Home tab active |
| Page padding | §3.2 16dp horizontal |
| Section spacing | §3.1 `space2xl` (24dp) |

**Quick Action Card Icon Background Colors (from §1.7 Domain Accent Colors):**

| Card | Icon BG (Container) | Icon Color |
|------|---------------------|------------|
| AI Chat | `colorPrimaryContainer` (#DBEAFE) | `colorPrimaryDark` (#1D4ED8) |
| Banking | Banking Container (#DBEAFE) | Banking Icon (#1D4ED8) |
| Visa | Visa Container (#EDE9FE) | Visa Icon (#6D28D9) |
| Medical | Medical Container (#FEE2E2) | Medical Icon (#B91C1C) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap "AI Chat" card | Navigate → S08 (Chat) |
| Tap "Banking" card | Navigate → S10 (banking guide list) with domain=banking |
| Tap "Visa" card | Navigate → S10 (visa guide list) with domain=visa |
| Tap "Medical" card | Navigate → S10 (medical guide list) with domain=medical |
| Tap "Browse all guides" | Navigate → S09 (Navigator top) |
| Tap "Emergency contacts" | Navigate → S12 (Emergency) |
| Tap "Upgrade now" | Navigate → S16 (Subscription) |
| Pull to refresh | RefreshIndicator (§9.2) → reload usage data |
| BottomNav tap | Tab switch with FadeTransition 200ms (§9.1) |
| Card press animation | Scale 0.97 + opacity 0.8, 100ms (§9.2) |
| Screen entry | FadeTransition + items stagger (§9.1 list items 200ms each) |

### 5. API Data Mapping

| Data | API | Response Field → UI Element |
|------|-----|----------------------------|
| Usage stats | `GET /api/v1/usage` | `data.chat_remaining` → usage subtitle; `data.tier` → tier badge; `data.chat_limit` → limit display |
| User profile | `GET /api/v1/users/me` | `data.display_name` → greeting name; `data.subscription_tier` → tier logic |

**Greeting name logic:**
1. Use `display_name` if set
2. Else use email prefix (before @)
3. Else show `home_greeting_no_name`

**Usage display logic:**
- Free: "Free • {chat_remaining}/{chat_limit} chats remaining today"
- Standard: "Standard • {chat_remaining}/{chat_limit} chats this month"
- Premium: "Premium • Unlimited chats"

### 6. State Variations

#### Loading State
```
┌──────────────────────────────────────┐
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ 👋              │  Shimmer skeleton
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓              │
│                                       │
│  ┌─────────────┐  ┌─────────────┐    │
│  │ ▓▓▓▓▓▓▓▓▓▓ │  │ ▓▓▓▓▓▓▓▓▓▓ │    │  Skeleton cards
│  │ ▓▓▓▓▓▓▓▓   │  │ ▓▓▓▓▓▓▓▓   │    │
│  └─────────────┘  └─────────────┘    │
│  ┌─────────────┐  ┌─────────────┐    │
│  │ ▓▓▓▓▓▓▓▓▓▓ │  │ ▓▓▓▓▓▓▓▓▓▓ │    │
│  │ ▓▓▓▓▓▓▓▓   │  │ ▓▓▓▓▓▓▓▓   │    │
│  └─────────────┘  └─────────────┘    │
└──────────────────────────────────────┘
```
- Shimmer animation: 1500ms loop, left→right gradient (§9.2)

#### Error State

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_error_load` | Unable to load your dashboard. | 无法加载你的主页。 | Không thể tải trang chính. | 대시보드를 불러올 수 없습니다. | Não foi possível carregar seu painel. |
| `home_error_retry` | Tap to retry | 点击重试 | Nhấn để thử lại | 탭하여 다시 시도 | Toque para tentar novamente |

- Show centered error message with retry button
- Quick Action cards still show (static, no usage data needed)

#### Tier-specific Differences

| Element | Free | Standard | Premium |
|---------|------|----------|---------|
| Usage subtitle | "Free • X/5 chats remaining today" | "Standard • X/300 chats this month" | "Premium • Unlimited chats" |
| Upgrade banner | ✅ Shown | ❌ Hidden | ❌ Hidden |
| Quick Action cards | All shown | All shown | All shown |

#### Usage Warning (approaching limit)

When `chat_remaining <= 1` (Free) or `chat_remaining <= 10` (Standard):

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `home_usage_warning_free` | Last chat remaining today! | 今日最后一次对话！ | Lượt chat cuối cùng hôm nay! | 오늘 마지막 채팅입니다! | Último chat restante hoje! |
| `home_usage_warning_standard` | {remaining} chats remaining this month | 本月剩余 {remaining} 次对话 | Còn {remaining} lượt chat tháng này | 이번 달 {remaining}회 채팅 남음 | {remaining} chats restantes este mês |

- Usage text color changes to `colorWarning` (#F59E0B) when low
