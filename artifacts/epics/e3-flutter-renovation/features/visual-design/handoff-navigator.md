# Handoff: Navigator Screens (S09–S11)

> Version: 1.0.0 | Created: 2026-02-17
> Screens: S09 Navigator Top, S10 Guide List, S11 Guide Detail
> Design System: `design/DESIGN_SYSTEM.md` v1.0.0

---

## S09: Navigator Top — Domain Grid

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│         Guide                         │  AppBar: titleLarge, centered
├──────────────────────────────────────┤
│                                       │
│  Explore topics to help you           │  bodyMedium 14sp, variant
│  navigate life in Japan.              │
│                                       │
│  ┌──────────┐  ┌──────────┐          │
│  │ ┌──────┐ │  │ ┌──────┐ │          │
│  │ │ 🏦   │ │  │ │ 🛂   │ │          │  Domain cards
│  │ └──────┘ │  │ └──────┘ │          │  2-column grid
│  │ Banking  │  │ Visa     │          │  gap: 12dp
│  │ 6 guides │  │ 6 guides │          │
│  └──────────┘  └──────────┘          │
│  ┌──────────┐  ┌──────────┐          │
│  │ ┌──────┐ │  │ ┌──────┐ │          │
│  │ │ 🏥   │ │  │ │ 📋   │ │          │
│  │ └──────┘ │  │ └──────┘ │          │
│  │ Medical  │  │ General  │          │
│  │ 7 guides │  │ 5 guides │          │
│  └──────────┘  └──────────┘          │
│                                       │  ← 24dp section gap
│  ┌──────────┐  ┌──────────┐          │
│  │ ┌──────┐ │  │ ┌──────┐ │          │  Coming Soon cards
│  │ │ 🏠   │ │  │ │ 💼   │ │          │  opacity 0.5
│  │ └──────┘ │  │ └──────┘ │          │
│  │ Housing  │  │ Employ-  │          │
│  │ (Soon)   │  │ (Soon)   │          │
│  └──────────┘  └──────────┘          │
│  ┌──────────┐  ┌──────────┐          │
│  │ ┌──────┐ │  │ ┌──────┐ │          │
│  │ │ 🎓   │ │  │ │ ⚖️   │ │          │
│  │ └──────┘ │  │ └──────┘ │          │
│  │Education │  │ Legal    │          │
│  │ (Soon)   │  │ (Soon)   │          │
│  └──────────┘  └──────────┘          │
│                                       │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │  BottomNavigationBar
│ Home  Chat Guide  SOS Profile        │  Guide = active
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

**AppBar & Header:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `nav_title` | Guide | 指南 | Hướng dẫn | 가이드 | Guia |
| `nav_subtitle` | Explore topics to help you navigate life in Japan. | 探索各种主题，帮助你在日本生活。 | Khám phá các chủ đề giúp bạn sống tại Nhật Bản. | 일본 생활에 도움이 되는 주제를 탐색하세요. | Explore tópicos para ajudar você a viver no Japão. |

**Domain labels:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `domain_banking` | Banking & Finance | 银行与金融 | Ngân hàng & Tài chính | 은행 및 금융 | Banco e Finanças |
| `domain_visa` | Visa & Immigration | 签证与入境 | Visa & Nhập cư | 비자 및 출입국 | Visto e Imigração |
| `domain_medical` | Medical & Health | 医疗与健康 | Y tế & Sức khỏe | 의료 및 건강 | Saúde e Medicina |
| `domain_concierge` | Life & General | 生活与综合 | Cuộc sống & Tổng hợp | 생활 및 종합 | Vida e Geral |
| `domain_housing` | Housing & Utilities | 住房与公共事业 | Nhà ở & Tiện ích | 주거 및 공공요금 | Moradia e Utilidades |
| `domain_employment` | Employment & Tax | 就业与税务 | Việc làm & Thuế | 취업 및 세금 | Emprego e Impostos |
| `domain_education` | Education & Childcare | 教育与育儿 | Giáo dục & Chăm sóc trẻ | 교육 및 육아 | Educação e Cuidado Infantil |
| `domain_legal` | Legal & Insurance | 法律与保险 | Pháp lý & Bảo hiểm | 법률 및 보험 | Jurídico e Seguros |

**Guide count:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `nav_guide_count` | {count} guides | {count} 篇指南 | {count} hướng dẫn | {count}개 가이드 | {count} guias |
| `nav_guide_count_one` | 1 guide | 1 篇指南 | 1 hướng dẫn | 1개 가이드 | 1 guia |

**Coming Soon badge:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `nav_coming_soon` | Coming Soon | 即将上线 | Sắp ra mắt | 곧 출시 | Em breve |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar, title centered |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Subtitle | §2.2 `bodyMedium` (14sp) `colorOnSurfaceVariant` |
| Domain card | §6.2.1 Navigator Domain Card |
| Card bg | §1.6 `colorSurface` (#FFFFFF) |
| Card border | 1dp `colorOutlineVariant` (#E2E8F0) |
| Card radius | §4 `radiusMd` (12dp) |
| Card elevation | §5 Level 0 default |
| Card padding | §3.1 `spaceLg` (16dp) |
| Grid | 2 columns, gap `spaceMd` (12dp) |
| Icon container | 48dp × 48dp circle, domain Container color (§1.7) |
| Icon | 28dp, domain Icon color (§7.3) |
| Domain name | §2.2 `titleMedium` (16sp, Medium 500) |
| Guide count | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Coming Soon badge | §6.7.1 Domain Status Badge — `colorSurfaceVariant` bg, `labelSmall` |
| Coming Soon card opacity | 0.5 |
| Page padding | §3.2 16dp horizontal |
| BottomNavigationBar | §6.5.1 — Guide tab active |

**Domain Icon & Color Mapping (§1.7 + §7.3):**

| Domain ID | Material Icon | Container BG | Icon Color |
|-----------|--------------|--------------|------------|
| `banking` | `account_balance` | #DBEAFE | #1D4ED8 |
| `visa` | `badge` | #EDE9FE | #6D28D9 |
| `medical` | `local_hospital` | #FEE2E2 | #B91C1C |
| `concierge` | `assignment` | #E0E7FF | #4338CA |
| `housing` | `home_work` | #FFF7ED | #C2410C |
| `employment` | `work_outline` | #CCFBF1 | #0F766E |
| `education` | `school` | #E0F2FE | #0369A1 |
| `legal` | `gavel` | #DCFCE7 | #15803D |

> **Note**: `education` and `legal` use custom icon mappings. The DESIGN_SYSTEM §7.3 lists `directions_transit` and `restaurant` for different domain names (Transport/Food). Coder should use `school` and `gavel` respectively. If these aren't in Material Symbols, use `flutter_svg` custom icons.

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap active domain card | Navigate → S10 (Guide List) with `domain` parameter |
| Tap coming_soon domain card | No navigation. Show Snackbar: "Coming soon! We're working on it." |
| Card press animation | Scale 0.97, 100ms (§9.2). Coming soon: no press animation. |
| Page transition | SlideTransition right→left 300ms (§9.1) |
| List animation | FadeTransition + SlideTransition stagger, 200ms per card (§9.1) |

**Snackbar for coming_soon:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `nav_coming_soon_snackbar` | Coming soon! We're working on it. | 即将上线！我们正在准备中。 | Sắp ra mắt! Chúng tôi đang thực hiện. | 곧 출시됩니다! 준비 중입니다. | Em breve! Estamos trabalhando nisso. |

### 5. API Data Mapping

| Data | API | Response Field → UI |
|------|-----|---------------------|
| Domain list | `GET /api/v1/navigator/domains` | `data.domains[]` → grid |
| Per domain | — | `.id` → routing key, `.label` → domain name, `.icon` → emoji (use Material Icon instead), `.status` → active/coming_soon, `.guide_count` → count text |

### 6. State Variations

#### Loading State
```
┌──────────┐  ┌──────────┐
│ ▓▓▓▓▓▓▓▓ │  │ ▓▓▓▓▓▓▓▓ │  Shimmer skeleton cards
│ ▓▓▓▓▓▓   │  │ ▓▓▓▓▓▓   │  2-col grid, 4 cards
│ ▓▓▓       │  │ ▓▓▓       │
└──────────┘  └──────────┘
```
- 4 skeleton cards (matching expected active domain count)
- Shimmer animation 1500ms loop (§9.2)

#### Error State

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `nav_error_load` | Unable to load guides. | 无法加载指南。 | Không thể tải hướng dẫn. | 가이드를 불러올 수 없습니다. | Não foi possível carregar os guias. |
| `nav_error_retry` | Tap to retry | 点击重试 | Nhấn để thử lại | 탭하여 다시 시도 | Toque para tentar novamente |

- Centered error icon + message + retry button

---

## S10: Navigator Guide List

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│ ←  Banking & Finance                  │  AppBar: titleLarge
├──────────────────────────────────────┤
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 🔍 Search guides...            │   │  Search bar (pill)
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │▌ Bank Account Opening Guide   │   │  Guide card with left bar
│  │▌ for Foreign Residents         │   │  4dp left border in
│  │▌                               │   │  domain accent color
│  │▌ Step-by-step guide to         │   │
│  │▌ opening a bank account...     │   │  Summary: max 2 lines
│  └────────────────────────────────┘   │
│                                       │  spaceSm (8dp)
│  ┌────────────────────────────────┐   │
│  │▌ Major Banks Comparison        │   │
│  │▌                               │   │
│  │▌ Comparison of major banks     │   │
│  │▌ in Japan for foreign...       │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │▌ International Money Transfer  │   │
│  │▌ Guide                         │   │
│  │▌                               │   │
│  │▌ Compare remittance options:   │   │
│  │▌ bank transfer, Wise...        │   │
│  └────────────────────────────────┘   │
│                                       │
│  ... more guides ...                  │
│                                       │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │  BottomNavigationBar
│ Home  Chat Guide  SOS Profile        │  Guide = active
└──────────────────────────────────────┘

─── Coming Soon Domain ─────────────────

┌──────────────────────────────────────┐
│ ←  Housing & Utilities                │
├──────────────────────────────────────┤
│                                       │
│                                       │
│            ┌────────┐                 │
│            │  🏠    │  64dp           │  Domain icon, large
│            └────────┘                 │
│                                       │
│      Coming Soon                      │  headlineMedium 20sp
│                                       │
│  We're working on housing guides.     │  bodyMedium, variant
│  Check back soon!                     │
│                                       │
│  ┌────────────────────────────────┐   │
│  │   Ask AI about housing →       │   │  Secondary Button
│  └────────────────────────────────┘   │
│                                       │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

**Search:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `guide_search_placeholder` | Search guides... | 搜索指南... | Tìm kiếm hướng dẫn... | 가이드 검색... | Buscar guias... |

**Coming Soon empty state:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `guide_coming_soon_title` | Coming Soon | 即将上线 | Sắp ra mắt | 곧 출시 | Em breve |
| `guide_coming_soon_subtitle` | We're working on {domain} guides. Check back soon! | 我们正在准备{domain}指南，请稍后查看！ | Chúng tôi đang chuẩn bị hướng dẫn về {domain}. Hãy quay lại sau! | {domain} 가이드를 준비 중입니다. 곧 다시 확인해주세요! | Estamos trabalhando nos guias de {domain}. Volte em breve! |
| `guide_coming_soon_ask_ai` | Ask AI about {domain} | 向 AI 询问{domain}相关问题 | Hỏi AI về {domain} | AI에게 {domain}에 대해 질문하기 | Pergunte à IA sobre {domain} |

**Search empty:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `guide_search_empty` | No guides found for "{query}". | 未找到与"{query}"相关的指南。 | Không tìm thấy hướng dẫn cho "{query}". | "{query}"에 대한 가이드를 찾을 수 없습니다. | Nenhum guia encontrado para "{query}". |
| `guide_search_try` | Try a different search term. | 试试其他搜索词。 | Thử từ khóa khác. | 다른 검색어를 시도해보세요. | Tente um termo de busca diferente. |

**Error messages:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `guide_error_load` | Unable to load guides for this category. | 无法加载该类别的指南。 | Không thể tải hướng dẫn cho danh mục này. | 이 카테고리의 가이드를 불러올 수 없습니다. | Não foi possível carregar os guias desta categoria. |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar, title = domain label |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Search bar | §6.3.3 Search Bar — pill shape, height 48dp |
| Guide card | §6.2.2 Guide List Card |
| Card bg | §1.6 `colorSurface` (#FFFFFF) |
| Card border | 1dp `colorOutlineVariant` (#E2E8F0) |
| Card left bar | 4dp, domain Accent color (§1.7) |
| Card radius | §4 `radiusMd` (12dp) |
| Card padding | §3.1 `spaceLg` (16dp) |
| Guide title | §2.2 `titleSmall` (14sp, Medium 500) |
| Guide summary | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant`, max 2 lines, overflow ellipsis |
| Card spacing | §3.1 `spaceSm` (8dp) |
| Page padding | §3.2 16dp horizontal |
| Coming soon icon | 64dp, domain Container color bg |
| Coming soon title | §2.2 `headlineMedium` (20sp, SemiBold 600) |
| Coming soon subtitle | §2.2 `bodyMedium` (14sp) `colorOnSurfaceVariant` |
| Ask AI button | §6.1.2 Secondary Button |
| BottomNavigationBar | §6.5.1 |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap guide card | Navigate → S11 (Guide Detail) with `domain` + `slug` |
| Card pressed state | bg `colorSurfaceVariant` (#F1F5F9) |
| Tap search bar | Focus, show keyboard, filter guides client-side |
| Type in search | Filter guide list by title match (case-insensitive) |
| Clear search (X button) | Reset to full list |
| Tap "Ask AI about {domain}" | Navigate → S08 (Chat) with `domain` hint pre-set |
| Back button | Navigate ← S09 (Navigator Top) |
| Page transition | SlideTransition right→left 300ms (§9.1) |
| List animation | FadeTransition + SlideTransition stagger 200ms (§9.1) |

### 5. API Data Mapping

| Data | API | Response → UI |
|------|-----|---------------|
| Guide list | `GET /api/v1/navigator/{domain}/guides` | `data.guides[]` → card list |
| Per guide | — | `.slug` → routing, `.title` → card title, `.summary` → card description |
| Coming soon | — | `data.status == "coming_soon"` → show empty state |

### 6. State Variations

#### Loading
- 3 skeleton cards with shimmer (§9.2)

#### Empty (no guides in active domain)
- "No guides available yet" message centered

#### Search Results Empty
- Illustration + "No guides found" + suggestion text

---

## S11: Navigator Guide Detail

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│ ←  Banking & Finance        (share)  │  AppBar: domain as title
├──────────────────────────────────────┤
│                                       │
│  Bank Account Opening Guide           │  headlineLarge 24sp
│  for Foreign Residents                │
│                                       │
│  ─────────────────────────────────    │  Divider
│                                       │
│  ## Required Documents                │  ← Markdown H2
│                                       │
│  1. **Residence Card** (在留カード)   │  Markdown rendered
│     - Must be valid for 3+ months     │  content
│                                       │
│  2. **Passport**                      │
│     - Original, not a copy            │
│                                       │
│  3. **Proof of Address** (住民票)     │
│     - Issued within 3 months          │
│                                       │
│  ## Recommended Banks                 │
│                                       │
│  ### Yucho Bank (ゆうちょ銀行)        │  ← Markdown H3
│  - Nationwide branches                │
│  - English ATM available              │
│                                       │
│  ### SMBC (三井住友銀行)              │
│  - English online banking             │
│  - Multi-language support             │
│                                       │
│  > **Tip**: Visit the branch in the   │  ← Blockquote
│  > morning for shorter wait times.    │
│                                       │
│  ## Important Notes                   │
│                                       │
│  ⚠️ Some banks require 6 months of   │
│  residence before opening...          │
│                                       │
│  ─────────────────────────────────    │
│  This is general information only.    │  ← Disclaimer
│  Not legal advice.                    │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  💬 Ask AI about this topic    │   │  Secondary Button
│  └────────────────────────────────┘   │
│                                       │
│  SafeArea                             │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │  BottomNavigationBar
│ Home  Chat Guide  SOS Profile        │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `guide_ask_ai` | Ask AI about this topic | 向 AI 询问此话题 | Hỏi AI về chủ đề này | AI에게 이 주제에 대해 질문하기 | Perguntar à IA sobre este tópico |
| `guide_disclaimer` | This is general information and does not constitute legal advice. Please verify with relevant authorities. | 以上为一般性信息，不构成法律建议。请向相关机构确认。 | Đây là thông tin chung và không phải tư vấn pháp lý. Vui lòng xác nhận với cơ quan liên quan. | 이 정보는 일반적인 안내이며 법적 조언이 아닙니다. 관련 기관에 확인하세요. | Esta é uma informação geral e não constitui aconselhamento jurídico. Verifique com as autoridades competentes. |
| `guide_share` | Share | 分享 | Chia sẻ | 공유 | Compartilhar |

**Error messages:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `guide_error_not_found` | This guide is no longer available. | 此指南已不可用。 | Hướng dẫn này không còn khả dụng. | 이 가이드는 더 이상 이용할 수 없습니다. | Este guia não está mais disponível. |
| `guide_error_load` | Unable to load this guide. Please try again. | 无法加载此指南，请重试。 | Không thể tải hướng dẫn này. Vui lòng thử lại. | 이 가이드를 불러올 수 없습니다. 다시 시도해주세요. | Não foi possível carregar este guia. Tente novamente. |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar, title = domain label, action = share icon |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Guide title | §2.2 `headlineLarge` (24sp, SemiBold 600) `colorOnBackground` |
| Divider below title | 1dp `colorOutlineVariant` (#E2E8F0) |
| Markdown content area | Scrollable body, padding 16dp horizontal |
| Markdown H1 | §2.2 `headlineLarge` (24sp, SemiBold), 24dp top margin |
| Markdown H2 | §2.2 `headlineMedium` (20sp, SemiBold), 20dp top margin |
| Markdown H3 | §2.2 `titleLarge` (18sp, SemiBold), 16dp top margin |
| Markdown body | §2.2 `bodyLarge` (16sp, Regular 400) |
| Markdown bold | SemiBold 600 |
| Markdown bullet list | `bodyLarge`, 16dp indent, `colorPrimary` bullet dot |
| Markdown numbered list | `bodyLarge`, 16dp indent |
| Markdown code inline | `bodySmall` (12sp) monospace, bg `colorSurfaceDim` (#E2E8F0), radius 4dp |
| Markdown code block | `bodySmall` monospace, bg `colorSurfaceDim`, radius 4dp, 8dp padding |
| Markdown blockquote | Left 3dp `colorPrimary` border, 12dp left padding, bg `colorPrimaryFixed` (#EFF6FF), radius 4dp |
| Markdown link | `colorPrimary`, underline |
| Disclaimer text | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant`, above CTA button |
| Ask AI button | §6.1.2 Secondary Button, full width, icon `chat_bubble_outline` |
| Button bottom spacing | §3.1 `space2xl` (24dp) |
| BottomNavigationBar | §6.5.1 |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Scroll | Standard scroll through markdown content |
| Tap "Ask AI about this topic" | Navigate → S08 (Chat), pre-set `domain` hint to current domain |
| Tap share icon | Platform share sheet (share guide title + deep link) |
| Tap link in markdown | Open URL in external browser |
| Back button | Navigate ← S10 (Guide List) |
| Page transition | SlideTransition right→left 300ms (§9.1) |

### 5. API Data Mapping

| Data | API | Response → UI |
|------|-----|---------------|
| Guide detail | `GET /api/v1/navigator/{domain}/guides/{slug}` | `data.title` → page title, `data.content` → markdown body, `data.summary` → used for share text |

### 6. State Variations

#### Loading
```
┌──────────────────────────────────────┐
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓               │  Shimmer title
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                       │
│                                       │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     │  Shimmer body lines
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓           │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓         │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                     │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓       │
│                                       │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓               │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓         │
└──────────────────────────────────────┘
```

#### Error (404 Not Found)
- Centered icon (error_outline, 48dp) + `guide_error_not_found` message + back button

#### Error (Network)
- Centered icon + `guide_error_load` message + retry button

#### Guide Content Notes
- Guide content is in the user's selected language (returned by API based on locale)
- If translation is not available, English content is shown as fallback
- Content length varies — scrollable area adapts
