# Task Contract — Plan C Frontend + Backend Update

```
Project: gaijin-life-navi (path: /root/.openclaw/projects/gaijin-life-navi)
Goal: Plan C 前端+后端 — 实现 4 层访问模型的前端适配 + 后端 UsageInfo period 补充
WorkType: Feature
```

## 访问模型（Plan C 确定版）

| Tier | Guide | AI Chat |
|------|-------|---------|
| Guest（未登录/匿名） | 8 篇 Free Guide（截断+注册CTA） | 5次 lifetime（概要級） |
| Free（注册用户） | 全部 45 篇 | 10次 lifetime（概要級） |
| Standard ¥720 | 全部 | 300次/月（深度級） |
| Premium ¥1,360 | 全部 | 无限（深度級） |

## A. 后端补充（3 处小改动）

### A1. `backend/app_service/routers/chat.py` — UsageInfo 增加 period 字段

现在 `UsageInfo`（L68-72）只有 `used`, `limit`, `tier`。新增 `period`:

```python
class UsageInfo(BaseModel):
    used: int
    limit: int | None = None
    tier: str
    period: str | None = None  # "lifetime" | "month" | None(unlimited)
```

`_usage_to_info()`（L253）修改为从 UsageCheck 取 period:

```python
def _usage_to_info(uc: UsageCheck) -> UsageInfo:
    return UsageInfo(used=uc.used, limit=uc.limit, tier=uc.tier, period=uc.period)
```

### A2. `backend/app_service/services/usage.py` — UsageCheck 增加 period

`UsageCheck` dataclass（L35-39）新增 `period`:

```python
@dataclass(frozen=True, slots=True)
class UsageCheck:
    allowed: bool
    used: int
    limit: int | None
    tier: str
    period: str | None = None
```

`check_and_increment()` 函数在创建 `UsageCheck` 时传入 period（`_TIER_LIMITS[tier][1]`）。

### A3. `backend/app_service/routers/usage_router.py` — 修复限额 + 支持 guest + period

问题：
- L161 `tier_limits` 硬编码 free: 20（应该是 10 lifetime）
- 没有 guest tier
- 没有 period 字段

修改：
1. `tier_limits` 更新为 Plan C 值：
   ```python
   tier_limits = {
       "guest": {"limit": 5, "period": "lifetime"},
       "free": {"limit": 10, "period": "lifetime"},
       "standard": {"limit": 300, "period": "month"},
       "premium": {"limit": None, "period": None},
       "premium_plus": {"limit": None, "period": None},
   }
   ```
2. 如果 `current_user.is_anonymous` → tier = "guest"
3. lifetime 用 `lifetime_total`（已计算），month 用当月总量
4. 返回值增加 `"period"` 字段

## B. 前端改动（6 项）

### B1. Firebase Anonymous Auth — `lib/core/providers/auth_provider.dart`

新增：

```dart
/// Whether the current user is an anonymous (guest) user.
final isAnonymousProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return user?.isAnonymous ?? false;
});

/// Sign in anonymously (for guest chat access).
Future<User?> signInAnonymously(FirebaseAuth auth) async {
  try {
    final credential = await auth.signInAnonymously();
    return credential.user;
  } catch (e) {
    return null;
  }
}
```

### B2. Router 更新 — `lib/core/providers/router_provider.dart`

`_ChatTabRouter` 改为：
- 已登录用户（含匿名）→ ChatListScreen
- 未登录 → 自动触发 `signInAnonymously()`，完成后进 ChatListScreen
- 新增 `_AnonymousAuthGate` widget（loading → signInAnonymously → ChatListScreen）

**Profile 保护**: redirect 逻辑中，`/profile` 对匿名用户 → redirect to `/login`。
```dart
// Profile requires real auth (not anonymous)
if (currentPath == AppRoutes.profile) {
  final user = authState.valueOrNull;
  if (user == null || user.isAnonymous) {
    return AppRoutes.login;
  }
}
```

### B3. Guide 锁定视图 CTA — domain + UI

**`lib/features/navigate/domain/navigator_domain.dart`**:
`NavigatorGuideDetail` 新增 `registerCta` 字段：
```dart
final bool registerCta;
// fromJson: registerCta: json['register_cta'] as bool? ?? false,
```

**`lib/features/navigate/presentation/guide_detail_screen.dart`**:
`_buildLockedView` 根据 `detail.registerCta` 切换：
- `registerCta == true` → 注册引导文案 + 按钮跳 /register
- `upgradeCta == true` → 升级引导 + 按钮跳 /subscription
- 默认 fallback = 注册引导

### B4. Guest 聊天 — `lib/features/chat/presentation/chat_guest_screen.dart`

ChatGuestScreen 不再被路由到（B2 让匿名用户也进 ChatListScreen）。
保留文件但改为用途：额度用完后的 CTA（guest → 注册；free → 升级）。
或直接在 usage_counter.dart 中处理 exhausted 状态。

### B5. Usage 模型适配

**`lib/features/chat/domain/chat_response.dart`** — ChatUsageInfo 加 period:
```dart
final String? period;
// fromJson: period: json['period'] as String?,
```

**`lib/features/usage/domain/usage_data.dart`** — 支持 lifetime:
- fromJson() 优先解析 `json['used']` + `json['limit']` + `json['period']`
- 兼容旧格式 `queries_used_today` / `daily_limit` / `monthly_limit`

**`lib/features/chat/presentation/providers/chat_providers.dart`**:
- fetchUsageProvider: 解析 period 传入 ChatUsageInfo
- chat response 回调也传 period

**`lib/features/chat/presentation/widgets/usage_counter.dart`**:
- lifetime: "剩余 X/Y 次"（无时间词）
- month: "本月剩余 X/Y 次"
- exhausted + guest → 注册 CTA (l10n.chatGuestExhausted)
- exhausted + free → 升级 CTA (l10n.chatFreeExhausted)

### B6. L10n 更新 — 5 种语言

**更新已有 key** (app_en.arb, app_zh.arb, app_vi.arb, app_ko.arb, app_pt.arb):

| Key | 新值(en) |
|-----|---------|
| `chatGuestFreeOffer` | "Try 5 free chats — no signup needed" |
| `guideLocked` | "Sign up to read the full guide" |
| `guideUpgradePrompt` | "Create a free account to unlock all 45 guides" |
| `guideUpgradeButton` | "Create Free Account" |
| `chatLimitExhausted` | "You've used all your free chats." |
| `subFeatureChatFree` | "10 lifetime AI Guide chats" |
| `subscriptionFeatureFreeChat` | "10 free AI chats (lifetime)" |

**新增 key**:

| Key | en |
|-----|-----|
| `chatGuestUsageHint` | "You have {remaining} free chats to explore" |
| `chatGuestExhausted` | "Sign up to keep chatting — 10 more chats free" |
| `chatFreeExhausted` | "Upgrade to Standard for 300 chats/month" |
| `usageLifetimeRemaining` | "{remaining} of {limit} chats remaining" |
| `chatGuestWelcome` | "Ask anything about life in Japan" |

zh/vi/ko/pt 翻译完整。placeholders 用 ICU 格式。

## Deliverables

- 后端 3 处改动 committed
- 前端 6 项改动 committed
- `flutter analyze` 无 error
- `flutter build web --release` 成功
- handoff.md at `artifacts/epics/plan-c-access-control/features/frontend-update/handoff.md`

## Done (验收条件)

1. Guest → Chat tab → 自动匿名 auth → ChatListScreen
2. Guest Chat 显示 "剩余 X/5 次"（lifetime）
3. Guest 5 次用完 → 注册 CTA（不是升级）
4. Guest 打开 free guide → 全文
5. Guest 打开 premium guide → excerpt + gradient + "Create Free Account" CTA
6. Free 用户看全部 45 篇 guide
7. Free Chat 显示 "剩余 X/10 次"（lifetime）
8. Free 10 次用完 → 升级 CTA
9. Standard/Premium 无变化
10. l10n 全部 5 种语言完整
11. `flutter analyze` 无 error
12. `flutter build web --release` 成功

## Constraints

- 技术栈: Flutter + Riverpod + GoRouter + Firebase Auth（app）, FastAPI + SQLAlchemy（backend）
- 不要创建新的 screen 文件（复用/改造现有文件）
- Firebase Anonymous Auth 只在 Chat tab 触发（不在 app 启动时）
- Profile tab：匿名用户 redirect 到 /login
- l10n: 所有 UI 文案通过 ARB，禁止硬编码
- 后端已有: `is_anonymous`（services/auth.py L61）、`get_optional_user()`（L96）、`_TIER_LIMITS` guest（usage.py L50）
- 读 `artifacts/project/GOTCHAS.md`
- navigator.py L444 返回 `register_cta: True`

## Artifacts binding

- artifactsRoot: artifacts/
- epic: plan-c-access-control
- feature: frontend-update
