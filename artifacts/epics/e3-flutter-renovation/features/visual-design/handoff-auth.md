# Handoff: Auth Flow (S01–S06)

> Version: 1.0.0 | Created: 2026-02-17
> Screens: S01 Splash, S02 Language Selection, S03 Login, S04 Register, S05 Password Reset, S06 Onboarding
> Design System: `design/DESIGN_SYSTEM.md` v1.0.0

---

## S01: Splash Screen

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│          colorPrimary (#2563EB)       │
│          FULL SCREEN                  │
│                                       │
│                                       │
│                                       │
│            ┌────────┐                 │
│            │  LOGO  │  80dp × 80dp   │
│            │ (white)│                 │
│            └────────┘                 │
│         Gaijin Life Navi              │  displayLarge 32sp White
│                                       │
│                                       │
│                                       │
│              ◌  ← spinner             │  CircularProgressIndicator White
│                                       │
│                                       │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `splash_app_name` | Gaijin Life Navi | Gaijin Life Navi | Gaijin Life Navi | Gaijin Life Navi | Gaijin Life Navi |

> App name は翻訳しない（ブランド名）。

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Background | §1.2 `colorPrimary` (#2563EB) full screen |
| Logo icon | §8.1 — `explore` (Filled) in white, 80dp |
| App name text | §2.2 `displayLarge` (32sp, Bold 700, White) |
| Loading spinner | Standard `CircularProgressIndicator`, White, 36dp |
| Spacing: logo → text | §3.1 `spaceLg` (16dp) |
| Spacing: text → spinner | §3.1 `space5xl` (48dp) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Screen display | Show for max 2 seconds while checking auth state |
| Auth state: first launch | Navigate → S02 (Language Selection) |
| Auth state: logged out (language set) | Navigate → S03 (Login) |
| Auth state: logged in, onboarding incomplete | Navigate → S06 (Onboarding) |
| Auth state: logged in, onboarding complete | Navigate → S07 (Home) |
| Transition out | FadeTransition 300ms `Curves.easeInOut` (§9.1) |

### 5. API Data Mapping

| Data | Source |
|------|--------|
| Auth state | Firebase Auth `currentUser` (local check, no API call) |
| Language preference | `SharedPreferences` local storage |
| Onboarding status | Cached `onboarding_completed` from previous session |

### 6. State Variations

| State | Display |
|-------|---------|
| Normal | Logo + App name + Spinner |
| Network unavailable | Same visual (no error shown on splash) → proceeds to cached state |

---

## S02: Language Selection

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
│                                       │
│          ┌────────┐                   │
│          │  LOGO  │  48dp             │
│          └────────┘                   │
│                                       │
│     Choose your language              │  displayMedium 28sp
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 🇺🇸  English                ○  │   │  56dp height, radio
│  └────────────────────────────────┘   │
│  ┌────────────────────────────────┐   │
│  │ 🇨🇳  中文                   ○  │   │
│  └────────────────────────────────┘   │
│  ┌────────────────────────────────┐   │
│  │ 🇻🇳  Tiếng Việt             ○  │   │
│  └────────────────────────────────┘   │
│  ┌────────────────────────────────┐   │
│  │ 🇰🇷  한국어                  ○  │   │
│  └────────────────────────────────┘   │
│  ┌────────────────────────────────┐   │
│  │ 🇧🇷  Português              ○  │   │
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │          Continue              │   │  Primary Button 48dp
│  └────────────────────────────────┘   │
│                                       │
│  SafeArea Bottom                      │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `lang_title` | Choose your language | 选择你的语言 | Chọn ngôn ngữ của bạn | 언어를 선택하세요 | Escolha seu idioma |
| `lang_en` | English | English | English | English | English |
| `lang_zh` | 中文 | 中文 | 中文 | 中文 | 中文 |
| `lang_vi` | Tiếng Việt | Tiếng Việt | Tiếng Việt | Tiếng Việt | Tiếng Việt |
| `lang_ko` | 한국어 | 한국어 | 한국어 | 한국어 | 한국어 |
| `lang_pt` | Português | Português | Português | Português | Português |
| `lang_continue` | Continue | 继续 | Tiếp tục | 계속 | Continuar |

> **注意**: 言語名は常にネイティブ表記（BRAND_GUIDELINES §5.3）。国旗はこの画面のみ使用可（§5.2）。

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Logo | §8.2 — 48dp, `colorPrimary` |
| Title | §2.2 `displayMedium` (28sp, Bold 700), centered |
| Language row | §6.4.1 Standard List Item, height 56dp |
| Radio button (inactive) | 24dp circle, border `colorOutline` (#CBD5E1) |
| Radio button (active) | 24dp circle, fill `colorPrimary` (#2563EB) |
| Selected row bg | §1.2 `colorPrimaryContainer` (#DBEAFE) |
| Selected row radius | §4 `radiusSm` (8dp) |
| Flag emoji | 24dp, left of language name |
| Language name | §2.2 `titleMedium` (16sp, Medium 500) |
| Continue button | §6.1.1 Primary Button, full width minus 32dp (16dp padding each side) |
| Page padding | §3.2 16dp horizontal |
| Spacing: logo → title | §3.1 `spaceLg` (16dp) |
| Spacing: title → list | §3.1 `space3xl` (32dp) |
| Spacing: list items | §3.1 `spaceSm` (8dp) |
| Spacing: list → button | §3.1 `space3xl` (32dp) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap language row | Select language, highlight row with `colorPrimaryContainer`, fill radio |
| Tap "Continue" (no selection) | Button disabled (§6.1.1 Disabled state) |
| Tap "Continue" (selected) | Save language to `SharedPreferences` → Navigate to S03 (Login) |
| Transition | SlideTransition right→left 300ms (§9.1) |
| Language detection | Pre-select based on device locale if matching one of 5 languages |

### 5. API Data Mapping

No API calls. Language is stored locally in `SharedPreferences`.

### 6. State Variations

| State | Display |
|-------|---------|
| Initial (no device locale match) | No language pre-selected, Continue button disabled |
| Initial (device locale matches) | Matching language pre-selected, Continue button enabled |

---

## S03: Login

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
│                                       │
│          ┌────────┐                   │
│          │  LOGO  │  48dp             │
│          └────────┘                   │
│       Gaijin Life Navi                │  titleLarge 18sp
│                                       │
│     Welcome back                      │  displayMedium 28sp
│     Sign in to continue               │  bodyMedium 14sp, variant
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 📧  Email                      │   │  TextField 56dp
│  └────────────────────────────────┘   │
│                                       │  spaceSm (8dp)
│  ┌────────────────────────────────┐   │
│  │ 🔒  Password              👁   │   │  TextField 56dp + toggle
│  └────────────────────────────────┘   │
│                                       │
│              Forgot password?         │  Text Button, right-aligned
│                                       │
│  ┌────────────────────────────────┐   │
│  │           Sign In              │   │  Primary Button 48dp
│  └────────────────────────────────┘   │
│                                       │
│  Don't have an account? Sign Up       │  bodyMedium + Text Button
│                                       │
│  SafeArea Bottom                      │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `login_welcome` | Welcome back | 欢迎回来 | Chào mừng trở lại | 다시 오신 것을 환영합니다 | Bem-vindo de volta |
| `login_subtitle` | Sign in to continue | 登录以继续 | Đăng nhập để tiếp tục | 로그인하여 계속하기 | Faça login para continuar |
| `login_email_label` | Email | 邮箱 | Email | 이메일 | E-mail |
| `login_email_hint` | your@email.com | your@email.com | your@email.com | your@email.com | your@email.com |
| `login_password_label` | Password | 密码 | Mật khẩu | 비밀번호 | Senha |
| `login_password_hint` | Enter your password | 请输入密码 | Nhập mật khẩu | 비밀번호를 입력하세요 | Digite sua senha |
| `login_forgot_password` | Forgot password? | 忘记密码？ | Quên mật khẩu? | 비밀번호를 잊으셨나요? | Esqueceu a senha? |
| `login_button` | Sign In | 登录 | Đăng nhập | 로그인 | Entrar |
| `login_no_account` | Don't have an account? | 还没有账号？ | Chưa có tài khoản? | 계정이 없으신가요? | Não tem uma conta? |
| `login_sign_up` | Sign Up | 注册 | Đăng ký | 회원가입 | Cadastre-se |
| `login_error_invalid_email` | Please enter a valid email address. | 请输入有效的邮箱地址。 | Vui lòng nhập địa chỉ email hợp lệ. | 유효한 이메일 주소를 입력해주세요. | Por favor, insira um endereço de e-mail válido. |
| `login_error_invalid_credentials` | Incorrect email or password. Please try again. | 邮箱或密码不正确，请重试。 | Email hoặc mật khẩu không đúng. Vui lòng thử lại. | 이메일 또는 비밀번호가 올바르지 않습니다. 다시 시도해주세요. | E-mail ou senha incorretos. Tente novamente. |
| `login_error_network` | Unable to connect. Please check your internet connection. | 无法连接，请检查网络。 | Không thể kết nối. Vui lòng kiểm tra kết nối internet. | 연결할 수 없습니다. 인터넷 연결을 확인해주세요. | Não foi possível conectar. Verifique sua conexão com a internet. |
| `login_error_too_many_attempts` | Too many attempts. Please try again later. | 尝试次数过多，请稍后再试。 | Quá nhiều lần thử. Vui lòng thử lại sau. | 시도 횟수가 너무 많습니다. 나중에 다시 시도해주세요. | Muitas tentativas. Tente novamente mais tarde. |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Logo | §8.2 — 48dp |
| App name | §2.2 `titleLarge` (18sp, SemiBold 600) |
| Welcome text | §2.2 `displayMedium` (28sp, Bold 700) |
| Subtitle | §2.2 `bodyMedium` (14sp, Regular) `colorOnSurfaceVariant` |
| Email field | §6.3.1 TextField, 56dp, prefix icon `email` |
| Password field | §6.3.1 TextField, 56dp, prefix icon `lock`, suffix icon `visibility`/`visibility_off` |
| Forgot password | §6.1.4 Text Button, right-aligned |
| Sign In button | §6.1.1 Primary Button, full width |
| Sign Up link | §2.2 `bodyMedium` + §6.1.4 Text Button (inline) |
| Error messages | §6.3.1 Error Text — `bodySmall` (12sp) `colorError` |
| Snackbar (network error) | §6.8.3 Snackbar |
| Page padding | §3.2 16dp horizontal |
| Field spacing | §3.1 `spaceSm` (8dp) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap Email field | Focus state (§6.3.1 Focused) |
| Tap Password field | Focus state, keyboard type = visiblePassword |
| Tap visibility toggle | Toggle password visibility |
| Tap "Forgot password?" | Navigate → S05 (Password Reset) |
| Tap "Sign In" (valid) | Show loading spinner on button → Firebase Auth signIn → on success: check onboarding → S06 or S07 |
| Tap "Sign In" (invalid email format) | Show inline error under email field |
| Tap "Sign In" (wrong credentials) | Show Snackbar with error message |
| Tap "Sign Up" | Navigate → S04 (Register) |
| Transition in | SlideTransition right→left 300ms (§9.1) |
| Button loading state | Replace button text with CircularProgressIndicator (white, 20dp) |

### 5. API Data Mapping

| Action | API | Notes |
|--------|-----|-------|
| Sign In | Firebase Auth `signInWithEmailAndPassword` | Client-side only, no backend API |
| Post-login profile fetch | `GET /api/v1/users/me` | Check `onboarding_completed` |

### 6. State Variations

| State | Display |
|-------|---------|
| Default | Empty fields, Sign In button enabled |
| Loading | Button shows spinner, fields disabled |
| Email validation error | Red border on email field + error text below |
| Auth error | Snackbar with error message |
| Network error | Snackbar with connection error message |

---

## S04: Register (User Registration)

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
│ ←  (back)                             │  AppBar with back button
│                                       │
│          ┌────────┐                   │
│          │  LOGO  │  48dp             │
│          └────────┘                   │
│                                       │
│     Create your account               │  displayMedium 28sp
│     Start your journey in Japan       │  bodyMedium 14sp, variant
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 📧  Email                      │   │  TextField 56dp
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 🔒  Password              👁   │   │  TextField 56dp
│  └────────────────────────────────┘   │
│  8+ characters                        │  helper text
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 🔒  Confirm password      👁   │   │  TextField 56dp
│  └────────────────────────────────┘   │
│                                       │
│  ☐ I agree to the Terms of Service    │  Checkbox + Text Button
│    and Privacy Policy                 │
│                                       │
│  ┌────────────────────────────────┐   │
│  │         Create Account         │   │  Primary Button 48dp
│  └────────────────────────────────┘   │
│                                       │
│  Already have an account? Sign In     │  bodyMedium + Text Button
│                                       │
│  SafeArea Bottom                      │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `register_title` | Create your account | 创建你的账号 | Tạo tài khoản của bạn | 계정 만들기 | Crie sua conta |
| `register_subtitle` | Start your journey in Japan | 开始你的日本生活之旅 | Bắt đầu hành trình tại Nhật Bản | 일본에서의 여정을 시작하세요 | Comece sua jornada no Japão |
| `register_email_label` | Email | 邮箱 | Email | 이메일 | E-mail |
| `register_email_hint` | your@email.com | your@email.com | your@email.com | your@email.com | your@email.com |
| `register_password_label` | Password | 密码 | Mật khẩu | 비밀번호 | Senha |
| `register_password_hint` | Create a password | 创建密码 | Tạo mật khẩu | 비밀번호를 만드세요 | Crie uma senha |
| `register_password_helper` | 8 or more characters | 8个字符以上 | 8 ký tự trở lên | 8자 이상 | 8 ou mais caracteres |
| `register_confirm_label` | Confirm password | 确认密码 | Xác nhận mật khẩu | 비밀번호 확인 | Confirmar senha |
| `register_confirm_hint` | Re-enter your password | 再次输入密码 | Nhập lại mật khẩu | 비밀번호를 다시 입력하세요 | Digite sua senha novamente |
| `register_terms_agree` | I agree to the | 我同意 | Tôi đồng ý với | 에 동의합니다 | Eu concordo com os |
| `register_terms_link` | Terms of Service | 服务条款 | Điều khoản dịch vụ | 서비스 이용약관 | Termos de Serviço |
| `register_privacy_and` | and | 和 | và | 및 | e |
| `register_privacy_link` | Privacy Policy | 隐私政策 | Chính sách bảo mật | 개인정보 처리방침 | Política de Privacidade |
| `register_button` | Create Account | 创建账号 | Tạo tài khoản | 계정 만들기 | Criar conta |
| `register_has_account` | Already have an account? | 已有账号？ | Đã có tài khoản? | 이미 계정이 있으신가요? | Já tem uma conta? |
| `register_sign_in` | Sign In | 登录 | Đăng nhập | 로그인 | Entrar |
| `register_error_email_invalid` | Please enter a valid email address. | 请输入有效的邮箱地址。 | Vui lòng nhập địa chỉ email hợp lệ. | 유효한 이메일 주소를 입력해주세요. | Por favor, insira um endereço de e-mail válido. |
| `register_error_email_in_use` | This email is already registered. Try signing in instead. | 该邮箱已注册，请直接登录。 | Email này đã được đăng ký. Hãy thử đăng nhập. | 이미 등록된 이메일입니다. 로그인을 시도해보세요. | Este e-mail já está registrado. Tente fazer login. |
| `register_error_password_short` | Password must be at least 8 characters. | 密码至少需要8个字符。 | Mật khẩu phải có ít nhất 8 ký tự. | 비밀번호는 8자 이상이어야 합니다. | A senha deve ter pelo menos 8 caracteres. |
| `register_error_password_mismatch` | Passwords don't match. | 两次密码不一致。 | Mật khẩu không khớp. | 비밀번호가 일치하지 않습니다. | As senhas não coincidem. |
| `register_error_terms_required` | Please agree to the Terms of Service. | 请同意服务条款。 | Vui lòng đồng ý với Điều khoản dịch vụ. | 서비스 이용약관에 동의해주세요. | Por favor, concorde com os Termos de Serviço. |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar, leading = back arrow |
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Logo | §8.2 — 48dp |
| Title | §2.2 `displayMedium` (28sp, Bold 700) |
| Subtitle | §2.2 `bodyMedium` (14sp, Regular) `colorOnSurfaceVariant` |
| Text fields | §6.3.1 TextField × 3 |
| Password helper | §6.3.1 Helper Text — `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Checkbox | 24dp, unchecked = `colorOutline`, checked = `colorPrimary` |
| Terms/Privacy links | §6.1.4 Text Button (inline) |
| Create Account button | §6.1.1 Primary Button, full width |
| Sign In link | §2.2 `bodyMedium` + §6.1.4 Text Button |
| Error messages | §6.3.1 Error state |
| Field spacing | §3.1 `spaceMd` (12dp) |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap back | Navigate ← S03 (Login), pop animation (§9.1) |
| Tap "Create Account" (valid all) | Loading state on button → Firebase Auth `createUser` → `POST /api/v1/auth/register` → Navigate → S06 (Onboarding) |
| Tap "Create Account" (invalid) | Show inline errors on relevant fields |
| Checkbox not checked | "Create Account" button still tappable, but shows terms error |
| Tap "Terms of Service" | Open in-app WebView or external browser |
| Tap "Privacy Policy" | Open in-app WebView or external browser |
| Tap "Sign In" | Navigate ← S03 (Login) |
| Transition | SlideTransition right→left 300ms (§9.1) |

### 5. API Data Mapping

| Action | API | Fields |
|--------|-----|--------|
| Create account | Firebase Auth `createUserWithEmailAndPassword` | email, password |
| Register profile | `POST /api/v1/auth/register` | `{ display_name: "", preferred_language: "{current_locale}" }` |
| Response | `201` → `data.user.id`, `data.user.onboarding_completed` | |

### 6. State Variations

| State | Display |
|-------|---------|
| Default | Empty fields, button enabled |
| Validation errors | Red border + error text on invalid fields |
| Loading | Button shows spinner, all fields disabled |
| Email already in use | Error Snackbar + suggestion to sign in |
| Network error | Snackbar §6.8.3 |

---

## S05: Password Reset

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
│ ←  (back)                             │  AppBar
│                                       │
│                                       │
│     Reset your password               │  displayMedium 28sp
│     Enter your email and we'll send   │  bodyMedium 14sp, variant
│     you a reset link.                 │
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 📧  Email                      │   │  TextField 56dp
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │         Send Reset Link        │   │  Primary Button 48dp
│  └────────────────────────────────┘   │
│                                       │
│     Back to Sign In                   │  Text Button centered
│                                       │
│                                       │
│                                       │
│ ─ ─ ─ ─ SUCCESS STATE ─ ─ ─ ─ ─ ─   │
│                                       │
│           ✉️  (64dp icon)             │
│     Check your email                  │  displayMedium
│     We've sent a reset link to        │  bodyMedium
│     user@email.com                    │
│                                       │
│  ┌────────────────────────────────┐   │
│  │        Back to Sign In         │   │  Primary Button
│  └────────────────────────────────┘   │
│                                       │
│     Didn't receive it? Resend         │  Text Button
│                                       │
└──────────────────────────────────────┘
```

### 2. Text Content (5 Languages)

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `reset_title` | Reset your password | 重置密码 | Đặt lại mật khẩu | 비밀번호 재설정 | Redefinir sua senha |
| `reset_subtitle` | Enter your email and we'll send you a reset link. | 输入你的邮箱，我们将发送重置链接。 | Nhập email và chúng tôi sẽ gửi liên kết đặt lại. | 이메일을 입력하면 재설정 링크를 보내드립니다. | Digite seu e-mail e enviaremos um link de redefinição. |
| `reset_email_label` | Email | 邮箱 | Email | 이메일 | E-mail |
| `reset_email_hint` | your@email.com | your@email.com | your@email.com | your@email.com | your@email.com |
| `reset_button` | Send Reset Link | 发送重置链接 | Gửi liên kết đặt lại | 재설정 링크 보내기 | Enviar link de redefinição |
| `reset_back_to_login` | Back to Sign In | 返回登录 | Quay lại đăng nhập | 로그인으로 돌아가기 | Voltar para login |
| `reset_success_title` | Check your email | 检查你的邮箱 | Kiểm tra email của bạn | 이메일을 확인하세요 | Verifique seu e-mail |
| `reset_success_subtitle` | We've sent a reset link to {email} | 我们已向 {email} 发送了重置链接 | Chúng tôi đã gửi liên kết đặt lại đến {email} | {email}로 재설정 링크를 보냈습니다 | Enviamos um link de redefinição para {email} |
| `reset_resend` | Didn't receive it? Resend | 没收到？重新发送 | Không nhận được? Gửi lại | 받지 못하셨나요? 재전송 | Não recebeu? Reenviar |
| `reset_error_email_invalid` | Please enter a valid email address. | 请输入有效的邮箱地址。 | Vui lòng nhập địa chỉ email hợp lệ. | 유효한 이메일 주소를 입력해주세요. | Por favor, insira um endereço de e-mail válido. |
| `reset_error_user_not_found` | No account found with this email. | 未找到该邮箱对应的账号。 | Không tìm thấy tài khoản với email này. | 이 이메일로 등록된 계정이 없습니다. | Nenhuma conta encontrada com este e-mail. |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| AppBar | §6.6.1 Standard AppBar, leading = back arrow |
| Title | §2.2 `displayMedium` (28sp, Bold 700) |
| Subtitle | §2.2 `bodyMedium` (14sp) `colorOnSurfaceVariant` |
| Email field | §6.3.1 TextField |
| Send button | §6.1.1 Primary Button, full width |
| Back to Sign In (form) | §6.1.4 Text Button, centered |
| Success icon | Material `mark_email_read`, 64dp, `colorSuccess` (#16A34A) |
| Success title | §2.2 `displayMedium` |
| Success subtitle | §2.2 `bodyMedium` `colorOnSurfaceVariant` |
| Back to Sign In (success) | §6.1.1 Primary Button, full width |
| Resend link | §6.1.4 Text Button |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap "Send Reset Link" | Loading → Firebase Auth `sendPasswordResetEmail` → swap to success state |
| Tap "Back to Sign In" | Navigate ← S03 (Login) |
| Tap "Resend" | Re-send email, show Snackbar "Reset link sent" |
| State transition | FadeTransition form→success 300ms (§9.1) |

### 5. API Data Mapping

| Action | API |
|--------|-----|
| Send reset email | Firebase Auth `sendPasswordResetEmail(email)` — no backend API |

### 6. State Variations

| State | Display |
|-------|---------|
| Form (default) | Email field + Send button |
| Form (loading) | Button spinner, field disabled |
| Form (error) | Inline error on email field |
| Success | Email sent confirmation with check icon |

---

## S06: Onboarding (4 Steps)

### 1. Screen Layout

```
┌──────────────────────────────────────┐
│ StatusBar                             │
│                                Skip → │  Text Button, right
│                                       │
│  ● ○ ○ ○                             │  Step indicator (4 dots)
│                                       │
│  Step 1 of 4                          │  labelSmall, variant
│                                       │
│     What's your nationality?          │  headlineLarge 24sp
│     This helps us give you            │  bodyMedium 14sp, variant
│     relevant information.             │
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 🌍 Select your nationality  ▼ │   │  Dropdown / Search field
│  └────────────────────────────────┘   │
│                                       │
│                                       │
│                                       │
│                                       │
│                                       │
│                                       │
│  ┌────────────────────────────────┐   │
│  │            Next                │   │  Primary Button
│  └────────────────────────────────┘   │
│  SafeArea                             │
└──────────────────────────────────────┘

─── Step 2 ─────────────────────────────

│  ○ ● ○ ○                             │
│  Step 2 of 4                          │
│                                       │
│     What's your residence status?     │  headlineLarge
│     We can tailor visa-related        │  bodyMedium
│     information for you.              │
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 📋 Select status           ▼  │   │  Dropdown
│  └────────────────────────────────┘   │

─── Step 3 ─────────────────────────────

│  ○ ○ ● ○                             │
│  Step 3 of 4                          │
│                                       │
│     Where do you live in Japan?       │  headlineLarge
│     For location-specific guides.     │  bodyMedium
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 📍 Select your region      ▼  │   │  Dropdown
│  └────────────────────────────────┘   │

─── Step 4 ─────────────────────────────

│  ○ ○ ○ ●                             │
│  Step 4 of 4                          │
│                                       │
│     When did you arrive in Japan?     │  headlineLarge
│     We'll suggest time-sensitive      │  bodyMedium
│     tasks you may need to complete.   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │ 📅 Select date                 │   │  Date picker trigger
│  └────────────────────────────────┘   │
│                                       │
│  ┌────────────────────────────────┐   │
│  │        Get Started             │   │  Primary Button (final step)
│  └────────────────────────────────┘   │
```

### 2. Text Content (5 Languages)

**Common elements:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `onboarding_skip` | Skip | 跳过 | Bỏ qua | 건너뛰기 | Pular |
| `onboarding_next` | Next | 下一步 | Tiếp theo | 다음 | Próximo |
| `onboarding_back` | Back | 返回 | Quay lại | 뒤로 | Voltar |
| `onboarding_get_started` | Get Started | 开始使用 | Bắt đầu | 시작하기 | Começar |
| `onboarding_step_of` | Step {current} of {total} | 第{current}步，共{total}步 | Bước {current}/{total} | {total}단계 중 {current}단계 | Passo {current} de {total} |
| `onboarding_optional` | Optional — you can always change this later | 可选——你可以稍后修改 | Tùy chọn — bạn có thể thay đổi sau | 선택사항 — 나중에 변경할 수 있습니다 | Opcional — você pode alterar depois |

**Step 1 — Nationality:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `onboarding_s1_title` | What's your nationality? | 你的国籍是什么？ | Quốc tịch của bạn là gì? | 국적이 어디인가요? | Qual é a sua nacionalidade? |
| `onboarding_s1_subtitle` | This helps us give you relevant information. | 这有助于我们提供相关信息。 | Điều này giúp chúng tôi cung cấp thông tin phù hợp. | 관련 정보를 제공하는 데 도움이 됩니다. | Isso nos ajuda a fornecer informações relevantes. |
| `onboarding_s1_placeholder` | Select your nationality | 选择你的国籍 | Chọn quốc tịch của bạn | 국적을 선택하세요 | Selecione sua nacionalidade |

**Step 2 — Residence Status:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `onboarding_s2_title` | What's your residence status? | 你的在留资格是什么？ | Tình trạng cư trú của bạn là gì? | 체류 자격이 무엇인가요? | Qual é o seu status de residência? |
| `onboarding_s2_subtitle` | We can tailor visa-related information for you. | 我们可以为你定制签证相关信息。 | Chúng tôi có thể điều chỉnh thông tin visa cho bạn. | 비자 관련 정보를 맞춤 제공해드립니다. | Podemos personalizar informações sobre visto para você. |
| `onboarding_s2_placeholder` | Select your status | 选择在留资格 | Chọn tình trạng của bạn | 체류 자격을 선택하세요 | Selecione seu status |

**Residence status options:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `status_engineer` | Engineer / Specialist in Humanities | 技术·人文知识·国际业务 | Kỹ sư / Chuyên gia nhân văn | 기술·인문지식·국제업무 | Engenheiro / Especialista em Humanidades |
| `status_student` | Student | 留学 | Du học sinh | 유학 | Estudante |
| `status_dependent` | Dependent | 家族滞在 | Người phụ thuộc | 가족체재 | Dependente |
| `status_permanent` | Permanent Resident | 永住者 | Thường trú nhân | 영주자 | Residente permanente |
| `status_spouse` | Spouse of Japanese National | 日本人配偶者 | Vợ/chồng công dân Nhật | 일본인의 배우자 | Cônjuge de nacional japonês |
| `status_working_holiday` | Working Holiday | 打工度假 | Kỳ nghỉ làm việc | 워킹홀리데이 | Working Holiday |
| `status_specified_skilled` | Specified Skilled Worker | 特定技能 | Lao động kỹ năng đặc định | 특정기능 | Trabalhador qualificado específico |
| `status_other` | Other | 其他 | Khác | 기타 | Outro |

**Step 3 — Region:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `onboarding_s3_title` | Where do you live in Japan? | 你住在日本哪里？ | Bạn sống ở đâu tại Nhật Bản? | 일본 어디에 살고 계신가요? | Onde você mora no Japão? |
| `onboarding_s3_subtitle` | For location-specific guides. | 用于提供本地化指南。 | Để cung cấp hướng dẫn theo khu vực. | 지역별 가이드를 제공해드립니다. | Para guias específicos da região. |
| `onboarding_s3_placeholder` | Select your region | 选择你的地区 | Chọn khu vực của bạn | 지역을 선택하세요 | Selecione sua região |

> Region list: 47 prefectures — use ISO 3166-2:JP codes. Display in user's language.

**Step 4 — Arrival Date:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `onboarding_s4_title` | When did you arrive in Japan? | 你什么时候来日本的？ | Bạn đến Nhật Bản khi nào? | 일본에 언제 도착하셨나요? | Quando você chegou ao Japão? |
| `onboarding_s4_subtitle` | We'll suggest time-sensitive tasks you may need to complete. | 我们会提醒你需要完成的时间敏感任务。 | Chúng tôi sẽ gợi ý các nhiệm vụ cần hoàn thành đúng hạn. | 기한이 있는 할 일을 안내해드립니다. | Vamos sugerir tarefas urgentes que você precisa concluir. |
| `onboarding_s4_placeholder` | Select date | 选择日期 | Chọn ngày | 날짜를 선택하세요 | Selecione a data |
| `onboarding_s4_not_yet` | I haven't arrived yet | 我还没来日本 | Tôi chưa đến Nhật | 아직 도착하지 않았습니다 | Ainda não cheguei |

### 3. Component Mapping

| Element | DESIGN_SYSTEM Reference |
|---------|------------------------|
| Background | §1.6 `colorBackground` (#FAFBFC) |
| Skip button | §6.1.4 Text Button, top-right |
| Step indicator | §8.3 — 8dp dots, Active = `colorPrimary`, Inactive = `colorOutline` |
| Step label | §2.2 `labelSmall` (11sp) `colorOnSurfaceVariant` |
| Step title | §2.2 `headlineLarge` (24sp, SemiBold 600) |
| Step subtitle | §2.2 `bodyMedium` (14sp) `colorOnSurfaceVariant` |
| Dropdown field | §6.3.1 TextField with suffix chevron icon |
| Date picker | Material 3 `DatePickerDialog` |
| Next / Get Started button | §6.1.1 Primary Button, full width, bottom fixed |
| Optional hint | §2.2 `bodySmall` (12sp) `colorOnSurfaceVariant` |
| Page padding | §3.2 16dp horizontal |
| Step transition | §9.1 SlideTransition + FadeTransition 300ms |

### 4. Interaction Spec

| Action | Behavior |
|--------|----------|
| Tap "Skip" | `POST /api/v1/users/me/onboarding` with empty fields → Navigate → S07 (Home) |
| Tap "Next" on Step 1-3 | Slide to next step. All fields optional — can proceed without input |
| Tap "Back" on Step 2-4 | Slide back to previous step |
| Tap "Get Started" on Step 4 | `POST /api/v1/users/me/onboarding` with collected data → Navigate → S07 (Home) |
| Tap dropdown | Open BottomSheet (§6.8.2) with searchable list |
| Tap date picker | Open Material DatePickerDialog |
| Step transition animation | SlideTransition left→right / right→left 300ms (§9.1) |

### 5. API Data Mapping

| Action | API | Request Fields |
|--------|-----|----------------|
| Complete onboarding | `POST /api/v1/users/me/onboarding` | `{ nationality, residence_status, residence_region, arrival_date, preferred_language }` |
| Response | `200` | Updated profile with `onboarding_completed: true` |

### 6. State Variations

| State | Display |
|-------|---------|
| Step 1-4 (no input) | Empty dropdown, "Next" still enabled (all optional) |
| Step 1-4 (with input) | Filled dropdown showing selected value |
| Loading (Get Started) | Button spinner, fields disabled |
| Error (API failure) | Snackbar §6.8.3 "Unable to save. Please try again." |

**Error messages for onboarding:**

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `onboarding_error_save` | Unable to save your information. Please try again. | 无法保存信息，请重试。 | Không thể lưu thông tin. Vui lòng thử lại. | 정보를 저장할 수 없습니다. 다시 시도해주세요. | Não foi possível salvar suas informações. Tente novamente. |

---

## Shared Auth Components

### BottomNavigationBar

Not shown on any Auth screens (S01–S06). The BottomNavigationBar appears only after login on S07+.

### Keyboard Handling

- All form screens (S03, S04, S05) should scroll to keep the active field visible above the keyboard
- Use `SingleChildScrollView` + `resizeToAvoidBottomInset: true`
- "Sign In" / "Create Account" buttons should remain visible (scroll into view, not fixed at bottom when keyboard is open)

### Password Visibility Toggle

| Key | en | zh | vi | ko | pt |
|-----|----|----|----|----|-----|
| `password_show` | Show password | 显示密码 | Hiện mật khẩu | 비밀번호 표시 | Mostrar senha |
| `password_hide` | Hide password | 隐藏密码 | Ẩn mật khẩu | 비밀번호 숨기기 | Ocultar senha |

> Semantic label for accessibility (§10.2).
