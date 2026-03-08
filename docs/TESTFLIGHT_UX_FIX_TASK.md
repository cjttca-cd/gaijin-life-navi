# TestFlight UX 修正 — 4 件

## 背景

TestFlight モードで Guest ユーザーのフローが壊れている。
Z が実機テストで発見した問題を一括修正する。

---

## Task 1: 注册页の居住地域を 2 步选择に修正

**ファイル**: `app/lib/features/auth/presentation/register_screen.dart`

**現状**: `_selectResidenceRegion()` が `_showSearchableBottomSheet<Prefecture>` で都道府県のみ 1 ステップ。Profile 画面は都道府県 → 市区町村の 2 ステップ。

**修正**: Profile 画面（`profile_screen.dart`）の `_showRegionSheet()` + `_showCitySheet()` パターンを参考に、Register 画面にも同じ 2 ステップフローを実装。

1. ステップ 1: 都道府県を `ListView.builder`（47 件）で選択
2. ステップ 2: 選択した都道府県内の市区町村を `ListView.builder` で選択
3. 保存値: `"PrefectureEn CityEn"` 形式（Profile 画面と同一フォーマット）
4. 表示: `"CityJa, PrefectureJa"` or `"PrefectureEn CityEn"`

**参考実装**: `profile_screen.dart` L702-L760 の `_showRegionSheet()` + `_showCitySheet()`

---

## Task 2: TestFlight 試用フロー修正

**ファイル**: `app/lib/features/chat/presentation/chat_guest_screen.dart`

**現状**: `ChatGuestScreen` の「免费开始」ボタン → `context.push(AppRoutes.register)` → 登録ページに飛ぶ。
TestFlight モードでは匿名ログインで試用できるはずが、匿名ログイン失敗時に `ChatGuestScreen` にフォールバックしてしまい、そこからは登録ページにしか行けない。

**修正**:

```dart
// TestFlight モードの場合
if (AppConfig.testFlightMode) {
  // 「免费试用」ボタン → 匿名ログインを再試行
  onPressed: () async {
    final auth = ref.read(firebaseAuthProvider);
    await signInAnonymously(auth);
    // authStateProvider が自動で更新 → _ChatTabRouter が _TrialSetupGate に遷移
  }
} else {
  // 通常モード: 登録ページへ
  onPressed: () => context.push(AppRoutes.register)
}
```

追加変更:
- `ChatGuestScreen` を `ConsumerWidget`（or `ConsumerStatefulWidget`）に変更（`ref` が必要）
- TestFlight モードの場合:
  - ボタンテキスト: `chatGuestSignUp` → `chatGuestFreeOffer`（既存 l10n「免注册，免费体验 5 次对话」）
  - 「已有账号？登录」リンクはそのまま表示（登録済みユーザーもテスト可能）

---

## Task 3: 首页 Guest バナー（TestFlight 対応）

**ファイル**: `app/lib/features/home/presentation/home_screen.dart`

**現状** (L87-93):
```dart
if (isGuest) ...[
  _UpgradeBannerWithAnalytics(
    text: l10n.homeGuestCtaText,  // "免费注册，解锁 AI 对话和个性化指南"
    cta: l10n.homeGuestCtaButton, // "开始使用"
    onTap: () => context.push(AppRoutes.register),
  ),
]
```

**修正**: TestFlight モードの場合、バナーのテキストと遷移先を変更:

```dart
if (isGuest) ...[
  _UpgradeBannerWithAnalytics(
    text: AppConfig.testFlightMode
        ? l10n.chatGuestFreeOffer  // "免注册，免费体验 5 次对话"
        : l10n.homeGuestCtaText,
    cta: AppConfig.testFlightMode
        ? l10n.navAiSearchButton   // "立即体验" (既存キー)
        : l10n.homeGuestCtaButton,
    onTap: () => AppConfig.testFlightMode
        ? context.push(AppRoutes.chat)  // → 匿名ログイン → 試用
        : context.push(AppRoutes.register),
  ),
]
```

---

## Task 4: 首页 Tracker を Guest にも表示

**ファイル**: `app/lib/features/home/presentation/home_screen.dart`

**現状** (L119):
```dart
if (!isGuest) ...[
  // Tracker Summary section
]
```

**修正**: Guest にも Tracker セクションを表示:

```dart
// Tracker Summary (visible to all users including guests)
...[
  Text(
    l10n.homeTrackerSummary.toUpperCase(),
    style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
  ),
  const SizedBox(height: AppSpacing.spaceMd),
  const _TrackerSummaryCard(),
  const SizedBox(height: AppSpacing.space2xl),
],
```

`!isGuest` ガードを削除。Tracker は SharedPreferences ベース（ローカル専用）なので Guest でも問題なく動作する。

---

## NOT in scope

- Backend 変更なし
- l10n 新規キー追加なし（既存キーを再利用）
- Profile 画面の region picker 変更なし（既に正しく動作）

## 手動検証チェックリスト

1. ログアウト状態で Chat タブ → TestFlight: 匿名ログイン → TrialSetupDialog → Chat 可能
2. 匿名ログイン失敗時 → ChatGuestScreen に「試用」ボタン → 再試行で匿名ログイン
3. ログアウト状態の首页 → TestFlight: 「免注册体験」バナー → Chat へ遷移
4. ログアウト状態の首页 → Tracker セクションが表示される
5. 注册画面の居住地域 → 都道府県（47 件表示）→ 市区町村選択 → 正しく保存
6. 登録済みユーザー → Profile の居住地域と同じフォーマットで保存

## 最新 commit

`4cd4920` on master
