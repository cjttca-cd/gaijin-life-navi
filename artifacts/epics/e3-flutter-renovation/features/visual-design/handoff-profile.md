# Handoff: Profile & Settings (S13–S15)

> Version: 1.0.0 | Created: 2026-02-17
> Screens: S13 Profile View, S14 Profile Edit, S15 Settings
> Design System: `design/DESIGN_SYSTEM.md` v1.0.0

---

## S13: Profile (View Only)

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│          Profile           ⚙️        │  AppBar: title + settings icon
├──────────────────────────────────────┤
│                                       │
│           ┌────────┐                  │
│           │  Avatar │  80dp           │  Geometric avatar
│           │  (C.W.) │                 │  colorPrimary bg, White initials
│           └────────┘                  │
│                                       │
│          Chen Wei                     │  headlineMedium 20sp
│          user@example.com             │  bodySmall 12sp, variant
│                                       │
│          ┌────────────┐               │
│          │ ⭐ Standard │              │  Tier badge
│          └────────────┘               │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  ✏️  Edit Profile              →  │   │  List item → S14
│  └────────────────────────────────┘   │
│                                       │
│ ── Your Information ──────────────── │  Section header
│                                       │
│  ┌────────────────────────────────┐   │
│  │  Nationality          China    │   │  Info row
│  │  ─────────────────────────     │   │  Divider
│  │  Residence Status     Engineer │   │
│  │  ─────────────────────────     │   │
│  │  Region               Tokyo   │   │
│  │  ─────────────────────────     │   │
│  │  Arrival Date    April 2024   │   │
│  │  ─────────────────────────     │   │
│  │  Language              中文    │   │
│  └────────────────────────────────┘   │
│                                       │
│ ── Usage Statistics ──────────────── │  Section header
│                                       │
│  ┌────────────────────────────────┐   │
│  │  Chats today        3/5       │   │  Stats row
│  │  ─────────────────────────     │   │
│  │  Member since    Feb 2026     │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  ⭐  Manage Subscription    →  │   │  → S16
│  └────────────────────────────────┘   │
│                                       │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │  BottomNavigationBar
│ Home  Chat Guide  SOS Profile        │  Profile = active
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

**AppBar & Header:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `profile_title` | Profile | 个人资料 | Hồ sơ | 프로필 | Perfil |
| `profile_edit` | Edit Profile | 编辑资料 | Chỉnh sửa hồ sơ | 프로필 편집 | Editar perfil |

**Tier badges:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `tier_free` | Free | 免费版 | Miễn phí | 무료 | Grátis |
| `tier_standard` | Standard | 标准版 | Tiêu chuẩn | 스탠다드 | Padrão |
| `tier_premium` | Premium | 高级版 | Cao cấp | 프리미엄 | Premium |

**Information labels:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `profile_nationality` | Nationality | 国籍 | Quốc tịch | 국적 | Nacionalidade |
| `profile_residence_status` | Residence Status | 在留资格 | Tình trạng cư trú | 체류 자격 | Status de residência |
| `profile_region` | Region | 地区 | Khu vực | 지역 | Região |
| `profile_arrival_date` | Arrival Date | 来日日期 | Ngày đến Nhật | 도착 날짜 | Data de chegada |
| `profile_language` | Language | 语言 | Ngôn ngữ | 언어 | Idioma |
| `profile_not_set` | Not set | 未设置 | Chưa đặt | 미설정 | Não definido |

**Statistics:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `profile_section_info` | Your Information | 你的信息 | Thông tin của bạn | 내 정보 | Suas informações |
| `profile_section_stats` | Usage Statistics | 使用统计 | Thống kê sử dụng | 이용 통계 | Estatísticas de uso |
| `profile_chats_today` | Chats today | 今日对话 | Chat hôm nay | 오늘 채팅 | Chats hoje |
| `profile_chats_month` | Chats this month | 本月对话 | Chat tháng này | 이번 달 채팅 | Chats este mês |
| `profile_member_since` | Member since | 加入时间 | Thành viên từ | 가입일 | Membro desde |
| `profile_manage_subscription` | Manage Subscription | 管理订阅 | Quản lý gói đăng ký | 구독 관리 | Gerenciar assinatura |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar, action = settings icon (→ S15) |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Avatar | 80dp circle, `colorPrimary` (#2563EB) bg, initials in White `headlineMedium` (20sp, Bold). `radiusFull` (§4) |
| Display name | §2.2 `headlineMedium` (20sp, SemiBold 600) |
| Email | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Tier badge | §6.7.2 Subscription Tier Badge |
| Edit Profile row | §6.4.1 Standard List Item, leading icon `edit_outlined`, trailing chevron |
| Section header | §2.2 `labelSmall` (11sp, Medium 500) `colorOnSurfaceVariant`, uppercase |
| Info card | bg `colorSurface` (#FFFFFF), border 1dp `colorOutlineVariant`, `radiusMd` (12dp), padding 16dp |
| Info row label | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Info row value | §2.2 `bodyMedium` (14sp) `colorOnSurface`, right-aligned |
| Row divider | 1dp `colorOutlineVariant`, full width inside card |
| Stats card | Same as info card |
| Stats value | §2.2 `titleSmall` (14sp, Medium 500), right-aligned |
| Manage subscription | §6.4.1 Standard List Item, leading icon star, trailing chevron |
| BottomNavigationBar | §6.5.1 — Profile tab active |
| Page padding | §3.2 16dp horizontal |
| Section spacing | §3.1 `space2xl` (24dp) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap settings icon | Navigate → S15 (Settings) |
| Tap "Edit Profile" | Navigate → S14 (Profile Edit) |
| Tap "Manage Subscription" | Navigate → S16 (Subscription) |
| Pull to refresh | Reload profile + usage data |
| Page transition | SlideTransition right→left 300ms (§9.1) |

### 5. API Data Mapping

| Data | API | Response Field → UI |
|------|-----|---------------------|
| Profile | `GET /api/v1/users/me` | `data.display_name` → name; `data.email` → email; `data.nationality` → nationality value; `data.residence_status` → status value; `data.residence_region` → region value; `data.arrival_date` → date; `data.preferred_language` → language; `data.subscription_tier` → tier badge; `data.created_at` → member since |
| Usage | `GET /api/v1/usage` | `data.chat_count` → chats used; `data.chat_limit` → chats limit; `data.tier` → display logic |

**Avatar initials logic:**
1. Use first letters of `display_name` words (max 2 chars)
2. If no name: first letter of email
3. Uppercase always

### 6. State Variations

#### Loading
- Shimmer skeleton: avatar circle + text lines + info card

#### Unset fields
- Show `profile_not_set` in `colorOnSurfaceVariant` + italic style

#### Tier badge variants (§6.7.2):
| Tier | Badge |
|------|-------|
| Free | `colorSurfaceVariant` bg, `colorOnSurfaceVariant` text |
| Standard | `colorTertiaryContainer` bg, `colorOnTertiaryContainer` text, ⭐ icon |
| Premium | Gradient `colorTertiaryContainer`, 💎 icon |

---

## S14: Profile Edit

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│ ←  Edit Profile              Save    │  AppBar: title + Save button
├──────────────────────────────────────┤
│                                       │
│           ┌────────┐                  │
│           │  Avatar │  80dp           │
│           │  (C.W.) │                 │
│           └────────┘                  │
│        Change photo (future)          │  bodySmall, disabled
│                                       │
│  ┌────────────────────────────────┐   │
│  │  Display Name                  │   │  TextField
│  │  Chen Wei                      │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  Nationality                ▼  │   │  Dropdown
│  │  China                         │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  Residence Status           ▼  │   │  Dropdown
│  │  Engineer / Specialist         │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  Region                     ▼  │   │  Dropdown
│  │  Tokyo                         │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  Preferred Language         ▼  │   │  Dropdown
│  │  中文                          │   │
│  └────────────────────────────────┘   │
│                                       │
│  SafeArea                             │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `edit_title` | Edit Profile | 编辑资料 | Chỉnh sửa hồ sơ | 프로필 편집 | Editar perfil |
| `edit_save` | Save | 保存 | Lưu | 저장 | Salvar |
| `edit_name_label` | Display Name | 显示名称 | Tên hiển thị | 표시 이름 | Nome de exibição |
| `edit_name_hint` | Enter your name | 输入你的名字 | Nhập tên của bạn | 이름을 입력하세요 | Digite seu nome |
| `edit_nationality_label` | Nationality | 国籍 | Quốc tịch | 국적 | Nacionalidade |
| `edit_nationality_hint` | Select your nationality | 选择你的国籍 | Chọn quốc tịch | 국적을 선택하세요 | Selecione sua nacionalidade |
| `edit_status_label` | Residence Status | 在留资格 | Tình trạng cư trú | 체류 자격 | Status de residência |
| `edit_status_hint` | Select your status | 选择在留资格 | Chọn tình trạng | 체류 자격 선택 | Selecione seu status |
| `edit_region_label` | Region | 地区 | Khu vực | 지역 | Região |
| `edit_region_hint` | Select your region | 选择地区 | Chọn khu vực | 지역을 선택하세요 | Selecione sua região |
| `edit_language_label` | Preferred Language | 首选语言 | Ngôn ngữ ưu tiên | 선호 언어 | Idioma preferido |
| `edit_change_photo` | Change photo | 更换照片 | Đổi ảnh | 사진 변경 | Alterar foto |
| `edit_success` | Profile updated successfully. | 资料更新成功。 | Hồ sơ đã được cập nhật. | 프로필이 업데이트되었습니다. | Perfil atualizado com sucesso. |
| `edit_error` | Unable to update profile. Please try again. | 无法更新资料，请重试。 | Không thể cập nhật hồ sơ. Vui lòng thử lại. | 프로필을 업데이트할 수 없습니다. 다시 시도해주세요. | Não foi possível atualizar o perfil. Tente novamente. |
| `edit_unsaved_title` | Unsaved changes | 未保存的更改 | Thay đổi chưa lưu | 저장되지 않은 변경 | Alterações não salvas |
| `edit_unsaved_message` | You have unsaved changes. Discard them? | 你有未保存的更改，要放弃吗？ | Bạn có thay đổi chưa lưu. Bỏ đi? | 저장되지 않은 변경사항이 있습니다. 취소하시겠습니까? | Você tem alterações não salvas. Descartar? |
| `edit_unsaved_discard` | Discard | 放弃 | Bỏ | 취소 | Descartar |
| `edit_unsaved_keep` | Keep editing | 继续编辑 | Tiếp tục chỉnh sửa | 계속 편집 | Continuar editando |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar, title centered, action = "Save" Text Button |
| Save button | §6.1.4 Text Button `colorPrimary`, `labelLarge` |
| Save button disabled | §6.1.4 Disabled state (no changes made) |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Avatar | Same as S13 (80dp, `colorPrimary`, White initials) |
| Change photo text | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant`, opacity 0.5 (Phase 0: disabled) |
| Name field | §6.3.1 TextField |
| Dropdown fields | §6.3.1 TextField with suffix chevron → opens BottomSheet (§6.8.2) |
| Field spacing | §3.1 `spaceMd` (12dp) |
| Page padding | §3.2 16dp horizontal |
| Success feedback | §6.8.3 Snackbar |
| Unsaved dialog | §6.8.1 Dialog |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Edit any field | Enable "Save" button |
| Tap "Save" | Loading → `PATCH /api/v1/users/me` → Snackbar "Profile updated" → Navigate ← S13 |
| Tap back (with changes) | Show unsaved changes Dialog (§6.8.1) |
| Tap back (no changes) | Navigate ← S13 directly |
| Tap dropdown field | Open BottomSheet with searchable list (§6.8.2) |
| Language change | Update app locale immediately + save via API |
| Save loading | Button text replaced with CircularProgressIndicator |

### 5. API Data Mapping

| Action | API | Fields |
|--------|-----|--------|
| Load profile | `GET /api/v1/users/me` | Pre-fill all fields |
| Save profile | `PATCH /api/v1/users/me` | `{ display_name, nationality, residence_status, residence_region, preferred_language }` |

### 6. State Variations

| State | Display |
|-------|---------|
| No changes | Save button disabled |
| Has changes | Save button enabled (blue) |
| Saving | Save button shows spinner |
| Save success | Snackbar + navigate back |
| Save error | Snackbar with error message |

---

## S15: Settings

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
├──────────────────────────────────────┤
│ ←  Settings                           │  AppBar: titleLarge
├──────────────────────────────────────┤
│                                       │
│ ── GENERAL ────────────────────────── │  Section header
│                                       │
│  ┌────────────────────────────────┐   │
│  │  🌐 Language           中文 → │   │  Settings items
│  │  ─────────────────────────     │   │
│  │  🔔 Notifications          → │   │  (Future)
│  └────────────────────────────────┘   │
│                                       │
│ ── ACCOUNT ────────────────────────── │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  ⭐ Subscription      Free → │   │
│  │  ─────────────────────────     │   │
│  │  🚪 Log Out                    │   │  Red text
│  └────────────────────────────────┘   │
│                                       │
│ ── DANGER ZONE ──────────────────── │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  🗑️ Delete Account             │   │  Red text
│  └────────────────────────────────┘   │
│                                       │
│ ── ABOUT ──────────────────────────── │
│                                       │
│  ┌────────────────────────────────┐   │
│  │  ℹ️  Version           1.0.0  │   │
│  │  ─────────────────────────     │   │
│  │  📄 Terms of Service       →  │   │
│  │  ─────────────────────────     │   │
│  │  🔒 Privacy Policy         →  │   │
│  │  ─────────────────────────     │   │
│  │  📧 Contact Us             →  │   │
│  └────────────────────────────────┘   │
│                                       │
│                                       │
│      Made with ❤️ for everyone        │  bodySmall, variant, centered
│      navigating life in Japan         │
│                                       │
├──────────────────────────────────────┤
│  🏠   💬   🧭   🆘   👤            │
│ Home  Chat Guide  SOS Profile        │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

**Section headers:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `settings_title` | Settings | 设置 | Cài đặt | 설정 | Configurações |
| `settings_section_general` | General | 通用 | Chung | 일반 | Geral |
| `settings_section_account` | Account | 账号 | Tài khoản | 계정 | Conta |
| `settings_section_danger` | Danger Zone | 危险操作 | Vùng nguy hiểm | 위험 영역 | Zona de perigo |
| `settings_section_about` | About | 关于 | Giới thiệu | 정보 | Sobre |

**Settings items:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `settings_language` | Language | 语言 | Ngôn ngữ | 언어 | Idioma |
| `settings_notifications` | Notifications | 通知 | Thông báo | 알림 | Notificações |
| `settings_subscription` | Subscription | 订阅 | Gói đăng ký | 구독 | Assinatura |
| `settings_logout` | Log Out | 退出登录 | Đăng xuất | 로그아웃 | Sair |
| `settings_delete_account` | Delete Account | 删除账号 | Xóa tài khoản | 계정 삭제 | Excluir conta |
| `settings_version` | Version | 版本 | Phiên bản | 버전 | Versão |
| `settings_terms` | Terms of Service | 服务条款 | Điều khoản dịch vụ | 서비스 이용약관 | Termos de Serviço |
| `settings_privacy` | Privacy Policy | 隐私政策 | Chính sách bảo mật | 개인정보 처리방침 | Política de Privacidade |
| `settings_contact` | Contact Us | 联系我们 | Liên hệ | 문의하기 | Fale conosco |
| `settings_footer` | Made with ❤️ for everyone navigating life in Japan | 用 ❤️ 为每一位在日生活的人打造 | Tạo với ❤️ cho mọi người đang sống tại Nhật Bản | 일본에서 생활하는 모든 분을 위해 ❤️으로 만들었습니다 | Feito com ❤️ para todos que vivem no Japão |

**Logout confirmation dialog:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `settings_logout_title` | Log Out | 退出登录 | Đăng xuất | 로그아웃 | Sair |
| `settings_logout_message` | Are you sure you want to log out? | 确定要退出登录吗？ | Bạn có chắc muốn đăng xuất? | 로그아웃 하시겠습니까? | Tem certeza que deseja sair? |
| `settings_logout_confirm` | Log Out | 退出 | Đăng xuất | 로그아웃 | Sair |
| `settings_logout_cancel` | Cancel | 取消 | Hủy | 취소 | Cancelar |

**Delete account confirmation dialog:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `settings_delete_title` | Delete Account | 删除账号 | Xóa tài khoản | 계정 삭제 | Excluir conta |
| `settings_delete_message` | This action cannot be undone. All your data will be permanently deleted. Are you sure? | 此操作无法撤销。你的所有数据将被永久删除。确定吗？ | Hành động này không thể hoàn tác. Tất cả dữ liệu sẽ bị xóa vĩnh viễn. Bạn chắc chứ? | 이 작업은 취소할 수 없습니다. 모든 데이터가 영구적으로 삭제됩니다. 확실합니까? | Esta ação não pode ser desfeita. Todos os seus dados serão excluídos permanentemente. Tem certeza? |
| `settings_delete_confirm` | Delete My Account | 删除我的账号 | Xóa tài khoản của tôi | 내 계정 삭제 | Excluir minha conta |
| `settings_delete_cancel` | Cancel | 取消 | Hủy | 취소 | Cancelar |
| `settings_delete_success` | Your account has been deleted. | 你的账号已删除。 | Tài khoản của bạn đã bị xóa. | 계정이 삭제되었습니다. | Sua conta foi excluída. |

**Language selection (BottomSheet):**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `settings_language_title` | Choose Language | 选择语言 | Chọn ngôn ngữ | 언어 선택 | Escolher idioma |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Section header | §6.4.2 — `labelSmall` (11sp, Medium 500) `colorOnSurfaceVariant`, uppercase |
| Settings card | bg `colorSurface` (#FFFFFF), border 1dp `colorOutlineVariant`, `radiusMd` (12dp) |
| Settings list item | §6.4.2 Settings List Item |
| Leading icon | 24dp `colorOnSurfaceVariant` |
| Item title | §2.2 `titleSmall` (14sp, Medium 500) |
| Trailing value | §2.2 `bodyMedium` (14sp) `colorOnSurfaceVariant` |
| Trailing chevron | `chevron_right` 24dp `colorOnSurfaceVariant` |
| Row divider | 1dp `colorOutlineVariant`, left 56dp margin |
| Log Out text | §2.2 `titleSmall` (14sp) `colorError` (#DC2626) |
| Delete Account text | §2.2 `titleSmall` (14sp) `colorError` (#DC2626) |
| Logout dialog | §6.8.1 Dialog — actions: Cancel (Text Button) + Log Out (Text Button `colorError`) |
| Delete dialog | §6.8.1 Dialog — actions: Cancel (Text Button) + Delete (§6.1.5 Danger Button) |
| Language BottomSheet | §6.8.2 BottomSheet with 5 language radio list |
| Footer text | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant`, centered |
| Section spacing | §3.1 `space2xl` (24dp) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap "Language" | Open BottomSheet (§6.8.2) with 5 languages + radio selection. Save → `PATCH /api/v1/users/me` + update app locale |
| Tap "Notifications" | Future feature — show "Coming soon" Snackbar |
| Tap "Subscription" | Navigate → S16 (Subscription) |
| Tap "Log Out" | Show confirmation Dialog → on confirm: Firebase Auth signOut → Navigate → S03 (Login), clear all navigation stack |
| Tap "Delete Account" | Show confirmation Dialog (§6.8.1) with Danger Button → on confirm: `POST /api/v1/auth/delete-account` → Firebase Auth delete → Navigate → S02 (Language Selection), clear all |
| Tap "Terms of Service" | Open URL in external browser |
| Tap "Privacy Policy" | Open URL in external browser |
| Tap "Contact Us" | Open email compose: `mailto:support@gaijinlifenavi.com` |
| Tap "Version" | No action (display only) |
| Page transition | SlideTransition right→left 300ms (§9.1) |

### 5. API Data Mapping

| Action | API |
|--------|-----|
| Change language | `PATCH /api/v1/users/me` → `{ preferred_language: "zh" }` |
| Log out | Firebase Auth `signOut()` — no backend API |
| Delete account | `POST /api/v1/auth/delete-account` |
| Version info | From `pubspec.yaml` / package info (local, no API) |

### 6. State Variations

| State | Display |
|-------|---------|
| Default | All items shown |
| Logout loading | Dialog button shows spinner |
| Delete loading | Dialog Danger Button shows spinner |
| Delete error | Snackbar: "Unable to delete account. Please try again." |
| Language changing | Brief loading overlay → UI switches |

**Error messages:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `settings_error_logout` | Unable to log out. Please try again. | 无法退出登录，请重试。 | Không thể đăng xuất. Vui lòng thử lại. | 로그아웃할 수 없습니다. 다시 시도해주세요. | Não foi possível sair. Tente novamente. |
| `settings_error_delete` | Unable to delete account. Please try again. | 无法删除账号，请重试。 | Không thể xóa tài khoản. Vui lòng thử lại. | 계정을 삭제할 수 없습니다. 다시 시도해주세요. | Não foi possível excluir a conta. Tente novamente. |
