# Handoff: Subscription Screen (S16)

> Version: 1.0.0 | Created: 2026-02-17
> Screen: S16 Subscription (Plan Comparison + Purchase)
> Design System: `design/DESIGN_SYSTEM.md` v1.0.0

---

## S16: Subscription

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│ ←  Subscription                       │  AppBar: titleLarge
├──────────────────────────────────────┤
│                                       │
│ ── Current Plan ──────────────────── │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  🆓  Free Plan                │   │  Current plan card
│  │  5 chats/day • 3/5 used today │   │
│  │                                │   │
│  │  ┌────────────────────────┐    │   │
│  │  │     Upgrade Now        │    │   │  Primary Button
│  │  └────────────────────────┘    │   │
│  └────────────────────────────────┘   │
│                                       │
│ ── Choose a Plan ─────────────────── │
│                                       │
│  ← horizontal scroll snap →          │
│                                       │
│  ┌────────────┐ ┌────────────┐ ┌───  │
│  │   Free     │ │ ⭐ Standard│ │ 💎  │  Plan cards
│  │            │ │ RECOMMENDED│ │ Pre  │  horizontal scroll
│  │   ¥0      │ │            │ │     │
│  │   /month   │ │  ¥720     │ │ ¥1, │
│  │            │ │  /month    │ │ /mo  │
│  │ ✓ 5/day   │ │            │ │     │
│  │ ✓ 3 track │ │ ✓ 300/mo  │ │ ✓ U  │
│  │ ✗ Ads     │ │ ✓ Unlim   │ │ ✓ U  │
│  │            │ │ ✓ No Ads  │ │ ✓ N  │
│  │  [Current] │ │            │ │     │
│  │            │ │ [Choose]   │ │ [Ch  │
│  └────────────┘ └────────────┘ └───  │
│                                       │
│ ── Need More Chats? ─────────────── │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  💬 100 Chats Pack             │   │
│  │     ¥360 (¥3.6/chat)       →  │   │  Charge pack cards
│  └────────────────────────────────┘   │
│  ┌────────────────────────────────┐   │
│  │  💬 50 Chats Pack              │   │
│  │     ¥180 (¥3.6/chat)       →  │   │
│  └────────────────────────────────┘   │
│                                       │
│ ── FAQ ───────────────────────────── │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  ▶ How does billing work?      │   │  Expandable FAQ
│  │  ▶ Can I cancel anytime?       │   │
│  │  ▶ What happens when I         │   │
│  │    downgrade?                   │   │
│  └────────────────────────────────┘   │
│                                       │
│  Subscription managed via             │  bodySmall, variant
│  App Store / Google Play              │
│                                       │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │
│ Home  Chat Guide  SOS Profile        │
└──────────────────────────────────────┘
```

### Plan Card Detail Layout

```
┌─────────────────────────────────┐
│          RECOMMENDED            │  ← Badge (Standard only)
│     colorPrimary bg, White text │
├─────────────────────────────────┤
│                                  │
│    ⭐ Standard                   │  Plan icon + name
│                                  │  headlineMedium 20sp
│    ¥720                          │  displayMedium 28sp, Bold
│    /month                        │  bodySmall 12sp, variant
│                                  │
│  ─────────────────────────────   │
│                                  │
│  ✓  300 chats / month            │  Feature list
│  ✓  Unlimited Tracker            │  bodyMedium 14sp
│  ✓  No ads                       │  ✓ = colorSuccess
│  ✗  Image analysis (coming)      │  ✗ = colorOnSurfaceVariant
│                                  │
│  ┌────────────────────────────┐  │
│  │      Choose Standard       │  │  Primary Button (recommended)
│  └────────────────────────────┘  │  Outline Button (others)
│                                  │
└─────────────────────────────────┘
```

### 2. Text Content (5 Languages)

**AppBar & Sections:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_title` | Subscription | 订阅 | Gói đăng ký | 구독 | Assinatura |
| `sub_section_current` | Current Plan | 当前方案 | Gói hiện tại | 현재 플랜 | Plano atual |
| `sub_section_choose` | Choose a Plan | 选择方案 | Chọn gói | 플랜 선택 | Escolha um plano |
| `sub_section_charge` | Need More Chats? | 需要更多对话次数？ | Cần thêm lượt chat? | 더 많은 채팅이 필요하세요? | Precisa de mais chats? |
| `sub_section_faq` | FAQ | 常见问题 | Câu hỏi thường gặp | 자주 묻는 질문 | Perguntas frequentes |

**Current plan card:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_current_free` | Free Plan | 免费方案 | Gói miễn phí | 무료 플랜 | Plano grátis |
| `sub_current_standard` | Standard Plan | 标准方案 | Gói tiêu chuẩn | 스탠다드 플랜 | Plano padrão |
| `sub_current_premium` | Premium Plan | 高级方案 | Gói cao cấp | 프리미엄 플랜 | Plano premium |
| `sub_current_usage_free` | {limit} chats/day • {used}/{limit} used today | 每日 {limit} 次对话 • 今日已用 {used}/{limit} | {limit} chat/ngày • Đã dùng {used}/{limit} hôm nay | 하루 {limit}회 채팅 • 오늘 {used}/{limit} 사용 | {limit} chats/dia • {used}/{limit} usados hoje |
| `sub_current_usage_standard` | {limit} chats/month • {used}/{limit} used | 每月 {limit} 次对话 • 已用 {used}/{limit} | {limit} chat/tháng • Đã dùng {used}/{limit} | 월 {limit}회 채팅 • {used}/{limit} 사용 | {limit} chats/mês • {used}/{limit} usados |
| `sub_current_usage_premium` | Unlimited chats • {used} used this month | 无限对话 • 本月已用 {used} 次 | Chat không giới hạn • Đã dùng {used} tháng này | 무제한 채팅 • 이번 달 {used}회 사용 | Chats ilimitados • {used} usados este mês |
| `sub_upgrade_now` | Upgrade Now | 立即升级 | Nâng cấp ngay | 지금 업그레이드 | Upgrade agora |

**Plan names and prices:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_plan_free` | Free | 免费 | Miễn phí | 무료 | Grátis |
| `sub_plan_standard` | Standard | 标准 | Tiêu chuẩn | 스탠다드 | Padrão |
| `sub_plan_premium` | Premium | 高级 | Cao cấp | 프리미엄 | Premium |
| `sub_price_free` | ¥0 | ¥0 | ¥0 | ¥0 | ¥0 |
| `sub_price_standard` | ¥720 | ¥720 | ¥720 | ¥720 | ¥720 |
| `sub_price_premium` | ¥1,360 | ¥1,360 | ¥1,360 | ¥1,360 | ¥1,360 |
| `sub_price_interval` | /month | /月 | /tháng | /월 | /mês |
| `sub_recommended` | RECOMMENDED | 推荐 | ĐỀ XUẤT | 추천 | RECOMENDADO |

**Feature list items:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_feature_chat_free` | 5 chats per day | 每日 5 次对话 | 5 lượt chat mỗi ngày | 하루 5회 채팅 | 5 chats por dia |
| `sub_feature_chat_standard` | 300 chats per month | 每月 300 次对话 | 300 lượt chat mỗi tháng | 월 300회 채팅 | 300 chats por mês |
| `sub_feature_chat_premium` | Unlimited chats | 无限对话 | Chat không giới hạn | 무제한 채팅 | Chats ilimitados |
| `sub_feature_tracker_free` | Up to 3 tracker items | 最多 3 个待办事项 | Tối đa 3 mục theo dõi | 최대 3개 트래커 항목 | Até 3 itens no rastreador |
| `sub_feature_tracker_paid` | Unlimited tracker items | 无限待办事项 | Mục theo dõi không giới hạn | 무제한 트래커 항목 | Itens ilimitados no rastreador |
| `sub_feature_ads_yes` | Contains ads | 包含广告 | Có quảng cáo | 광고 포함 | Contém anúncios |
| `sub_feature_ads_no` | No ads | 无广告 | Không quảng cáo | 광고 없음 | Sem anúncios |
| `sub_feature_image_no` | Image analysis (coming soon) | 图片分析（即将推出） | Phân tích ảnh (sắp có) | 이미지 분석 (출시 예정) | Análise de imagem (em breve) |
| `sub_feature_image_yes` | Image analysis (coming soon) | 图片分析（即将推出） | Phân tích ảnh (sắp có) | 이미지 분석 (출시 예정) | Análise de imagem (em breve) |

**Plan buttons:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_button_current` | Current Plan | 当前方案 | Gói hiện tại | 현재 플랜 | Plano atual |
| `sub_button_choose` | Choose {plan} | 选择{plan} | Chọn {plan} | {plan} 선택 | Escolher {plan} |
| `sub_button_downgrade` | Downgrade to {plan} | 降级为{plan} | Hạ xuống {plan} | {plan}으로 다운그레이드 | Rebaixar para {plan} |

**Charge packs:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_charge_100` | 100 Chats Pack | 100次对话包 | Gói 100 lượt chat | 100회 채팅 팩 | Pacote 100 chats |
| `sub_charge_50` | 50 Chats Pack | 50次对话包 | Gói 50 lượt chat | 50회 채팅 팩 | Pacote 50 chats |
| `sub_charge_100_price` | ¥360 (¥3.6/chat) | ¥360（¥3.6/次） | ¥360 (¥3.6/lượt) | ¥360 (¥3.6/회) | ¥360 (¥3.6/chat) |
| `sub_charge_50_price` | ¥180 (¥3.6/chat) | ¥180（¥3.6/次） | ¥180 (¥3.6/lượt) | ¥180 (¥3.6/회) | ¥180 (¥3.6/chat) |
| `sub_charge_description` | Extra chats that never expire. Used after your plan's limit. | 额外对话次数，永不过期。在方案用量用完后使用。 | Lượt chat thêm không hết hạn. Sử dụng sau khi hết hạn mức gói. | 만료되지 않는 추가 채팅. 플랜 한도 초과 후 사용. | Chats extras que nunca expiram. Usados após o limite do plano. |

**FAQ items:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_faq_billing_q` | How does billing work? | 如何计费？ | Thanh toán hoạt động thế nào? | 결제는 어떻게 이루어지나요? | Como funciona a cobrança? |
| `sub_faq_billing_a` | Subscriptions are billed monthly through the App Store or Google Play. You can manage your subscription in your device settings. | 订阅通过 App Store 或 Google Play 每月计费。你可以在设备设置中管理订阅。 | Gói đăng ký được thanh toán hàng tháng qua App Store hoặc Google Play. Bạn có thể quản lý trong cài đặt thiết bị. | 구독은 App Store 또는 Google Play를 통해 매월 결제됩니다. 기기 설정에서 구독을 관리할 수 있습니다. | As assinaturas são cobradas mensalmente pela App Store ou Google Play. Você pode gerenciar nas configurações do dispositivo. |
| `sub_faq_cancel_q` | Can I cancel anytime? | 可以随时取消吗？ | Tôi có thể hủy bất kỳ lúc nào? | 언제든 취소할 수 있나요? | Posso cancelar a qualquer momento? |
| `sub_faq_cancel_a` | Yes! You can cancel anytime. Your plan will remain active until the end of the billing period. | 当然！你可以随时取消。你的方案将在计费周期结束前保持有效。 | Có! Bạn có thể hủy bất kỳ lúc nào. Gói sẽ hoạt động đến cuối kỳ thanh toán. | 네! 언제든 취소할 수 있습니다. 플랜은 결제 기간이 끝날 때까지 유지됩니다. | Sim! Você pode cancelar a qualquer momento. Seu plano permanece ativo até o final do período. |
| `sub_faq_downgrade_q` | What happens when I downgrade? | 降级后会怎样？ | Điều gì xảy ra khi hạ gói? | 다운그레이드하면 어떻게 되나요? | O que acontece quando eu rebaixo? |
| `sub_faq_downgrade_a` | When you downgrade, you'll keep your current plan benefits until the end of the billing period. Then your plan will switch to the new tier. | 降级后，你将保留当前方案权益直到计费周期结束，然后切换到新级别。 | Khi hạ gói, bạn vẫn giữ quyền lợi gói hiện tại đến cuối kỳ thanh toán, sau đó chuyển sang gói mới. | 다운그레이드 시 현재 결제 기간이 끝날 때까지 기존 플랜 혜택을 유지합니다. 그 후 새 등급으로 전환됩니다. | Ao rebaixar, você mantém os benefícios do plano atual até o final do período. Depois, muda para o novo nível. |

**Footer:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_footer` | Subscription managed via App Store / Google Play | 订阅通过 App Store / Google Play 管理 | Gói đăng ký được quản lý qua App Store / Google Play | App Store / Google Play를 통해 구독 관리 | Assinatura gerenciada pela App Store / Google Play |

**Error/Success:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_purchase_success` | Welcome to {plan}! Your upgrade is now active. | 欢迎使用{plan}！升级已生效。 | Chào mừng đến {plan}! Nâng cấp đã được kích hoạt. | {plan}에 오신 것을 환영합니다! 업그레이드가 활성화되었습니다. | Bem-vindo ao {plan}! Seu upgrade está ativo. |
| `sub_purchase_error` | Unable to complete purchase. Please try again. | 无法完成购买，请重试。 | Không thể hoàn tất mua hàng. Vui lòng thử lại. | 구매를 완료할 수 없습니다. 다시 시도해주세요. | Não foi possível concluir a compra. Tente novamente. |
| `sub_purchase_cancelled` | Purchase cancelled. | 购买已取消。 | Đã hủy mua hàng. | 구매가 취소되었습니다. | Compra cancelada. |
| `sub_charge_success` | {count} chats added to your account! | 已添加 {count} 次对话到你的账户！ | Đã thêm {count} lượt chat vào tài khoản! | {count}회 채팅이 계정에 추가되었습니다! | {count} chats adicionados à sua conta! |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Section headers | §2.2 `labelSmall` (11sp, Medium 500) `colorOnSurfaceVariant`, uppercase |
| Current plan card | bg `colorSurface` (#FFFFFF), border 1dp `colorOutlineVariant`, `radiusMd` (12dp), padding 16dp |
| Current plan icon | Tier badge icon (🆓/⭐/💎) 24dp |
| Current plan title | §2.2 `titleMedium` (16sp, Medium 500) |
| Current plan usage | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Upgrade button | §6.1.1 Primary Button (in current plan card) |
| Plan card | §6.2.6 Subscription Plan Card |
| Plan card bg (normal) | `colorSurface` (#FFFFFF), border 1dp `colorOutlineVariant` |
| Plan card bg (recommended) | `colorPrimaryFixed` (#EFF6FF), border 2dp `colorPrimary` (#2563EB), Elevation Level 1 |
| Plan card radius | §4 `radiusMd` (12dp) |
| Plan card padding | §3.1 `spaceXl` (20dp) |
| Recommended badge | bg `colorPrimary`, text White `labelSmall` (11sp), `radiusFull`, top of card |
| Plan name | §2.2 `headlineMedium` (20sp, SemiBold 600) |
| Plan price | §2.2 `displayMedium` (28sp, Bold 700) |
| Price interval | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Feature check (✓) | `check` 20dp `colorSuccess` (#16A34A) |
| Feature cross (✗) | `close` 20dp `colorOnSurfaceVariant` (#64748B) |
| Feature text | §2.2 `bodyMedium` (14sp) |
| Plan CTA (recommended) | §6.1.1 Primary Button, full width within card |
| Plan CTA (current) | §6.1.3 Outline Button, disabled style, text "Current Plan" |
| Plan CTA (other) | §6.1.3 Outline Button |
| Plan card scroll | Horizontal `PageView` with snap, card width ~280dp |
| Charge pack card | bg `colorSurface`, border 1dp `colorOutlineVariant`, `radiusMd` (12dp), padding 16dp |
| Charge pack icon | `chat_bubble_outline` 24dp `colorPrimary` |
| Charge pack title | §2.2 `titleSmall` (14sp, Medium 500) |
| Charge pack price | §2.2 `bodyMedium` (14sp) `colorOnSurfaceVariant` |
| Charge pack chevron | `chevron_right` 24dp `colorOnSurfaceVariant` |
| FAQ item | ExpansionTile, title = `titleSmall` (14sp), content = `bodyMedium` (14sp) `colorOnSurfaceVariant` |
| Footer | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant`, centered |
| Section spacing | §3.1 `space2xl` (24dp) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Horizontal scroll plan cards | Snap to center card, `PageView` with `viewportFraction: 0.85` |
| Tap "Choose Standard" | Initiate IAP: Apple IAP / Google Play Billing → show native purchase dialog → on success: `POST /api/v1/subscription/purchase` → Snackbar success |
| Tap "Choose Premium" | Same IAP flow |
| Tap "Current Plan" button | No action (disabled) |
| Tap charge pack card | Initiate IAP for one-time purchase → on success: Snackbar "{count} chats added" |
| Tap FAQ item | Expand/collapse with animation (200ms) |
| Upgrade button in current plan | Scroll to plan cards section |
| IAP cancelled by user | Snackbar "Purchase cancelled" |
| IAP failed | Snackbar with error message |
| Post-purchase | Refresh usage data, update tier badge, hide upgrade prompts |
| Back button | Navigate ← previous screen |

### 5. API Data Mapping

| Data | API | Response → UI |
|------|-----|---------------|
| Plans | `GET /api/v1/subscription/plans` | `data.plans[]` → plan cards |
| Per plan | — | `.id` → plan key, `.name` → plan title, `.price` → price, `.currency` → "JPY", `.interval` → "/month", `.features.chat_limit` → feature text, `.features.tracker_limit` → feature text, `.features.ads` → feature text |
| Charge packs | — | `data.charge_packs[]` → charge cards: `.chats` → count, `.price` → price, `.unit_price` → per-chat |
| Current usage | `GET /api/v1/usage` | `data.tier` → current plan highlight, `data.chat_count` / `data.chat_limit` → usage text |
| Purchase | `POST /api/v1/subscription/purchase` | Send IAP receipt/token → get confirmed tier |

### 6. State Variations

#### Loading
- Skeleton: 1 current plan card + 3 plan card placeholders

#### Current Plan Highlighting

| User's Tier | Free Card | Standard Card | Premium Card |
|-------------|-----------|---------------|--------------|
| Free | "Current Plan" (disabled) | "Choose Standard" (Primary) | "Choose Premium" (Outline) |
| Standard | "Downgrade to Free" (Outline) | "Current Plan" (disabled) | "Choose Premium" (Primary) |
| Premium | "Downgrade to Free" (Outline) | "Downgrade to Standard" (Outline) | "Current Plan" (disabled) |

#### Purchase In Progress
- Selected plan card shows loading overlay
- Other cards become non-interactive (opacity 0.5)

#### Post-Upgrade Success
```
┌──────────────────────────────────────┐
│  🎉                                  │
│                                       │
│  Welcome to Standard!                 │  Dialog or full-width banner
│  Your upgrade is now active.          │
│                                       │
│  ✓ 300 chats per month                │  Feature highlights
│  ✓ Unlimited tracker                  │
│  ✓ No ads                             │
│                                       │
│  [   Start Chatting   ]              │  Primary Button → S08
│                                       │
└──────────────────────────────────────┘
```

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_welcome_title` | Welcome to {plan}! | 欢迎使用{plan}！ | Chào mừng đến {plan}! | {plan}에 오신 것을 환영합니다! | Bem-vindo ao {plan}! |
| `sub_welcome_subtitle` | Your upgrade is now active. | 升级已生效。 | Nâng cấp đã được kích hoạt. | 업그레이드가 활성화되었습니다. | Seu upgrade está ativo. |
| `sub_welcome_cta` | Start Chatting | 开始对话 | Bắt đầu chat | 채팅 시작하기 | Começar a conversar |

#### Error State (API failure)

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `sub_error_load` | Unable to load subscription plans. | 无法加载订阅方案。 | Không thể tải gói đăng ký. | 구독 플랜을 불러올 수 없습니다. | Não foi possível carregar os planos. |
| `sub_error_retry` | Tap to retry | 点击重试 | Nhấn để thử lại | 탭하여 다시 시도 | Toque para tentar novamente |
