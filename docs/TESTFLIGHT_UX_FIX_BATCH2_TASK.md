# TestFlight UX 修正 Batch 2 — Trial Setup 強化 + 匿名 Profile 画面

> 作成日: 2026-03-08
> 最新 commit: `26231e4`
> ステータス: PM に委譲

## 背景

TestFlight モードの匿名ユーザーフローに以下の問題がある:

1. Trial Setup ダイアログが収集する情報が不足（visa_expiry がない）
2. preferred_language を app locale から自動設定していない
3. 匿名ユーザーが設定変更する手段がない（Profile 画面がない）

## Task 1: Trial Setup に visa_expiry フィールド追加

### Backend

**ファイル**: `backend/app_service/routers/profile_router.py`

1. `TrialSetupRequest` に `visa_expiry: str | None = None` を追加（任意項目）
2. `trial_setup()` 関数内で `body.visa_expiry` があれば Profile に設定
3. `preferred_language` パラメータ `preferred_language: str | None = None` も追加 → Profile に設定

```python
class TrialSetupRequest(BaseModel):
    """Request body for TestFlight trial profile setup."""
    nationality: str
    residence_status: str
    residence_region: str
    visa_expiry: str | None = None          # ← 追加（"YYYY-MM-DD" 形式）
    preferred_language: str | None = None   # ← 追加（app locale から自動送信）
```

### Frontend — Trial Setup ダイアログ

**ファイル**: `app/lib/features/chat/presentation/widgets/trial_setup_dialog.dart`

**変更内容**:

1. `_selectedVisaExpiry`（`DateTime?`）State 変数を追加
2. visa_expiry 用の `_SelectorTile` を residence_region の下に追加
   - タップ → `showDatePicker()` で日付選択
   - 表示: `yyyy/MM/dd` 形式（locale に応じたフォーマット）
   - **任意項目** — `_canSubmit` の条件には含めない（nationality + residence_status + region の 3 つが必須）
3. `_submit()` で `preferred_language` を app locale から自動取得して送信:
   ```dart
   final locale = Localizations.localeOf(context).languageCode;
   await repo.trialSetup(
     nationality: _selectedNationality!,
     residenceStatus: _selectedResidenceStatus!,
     residenceRegion: '${_selectedPrefecture!.nameEn} ${_selectedCity!.nameEn}',
     visaExpiry: _selectedVisaExpiry?.toIso8601String().split('T').first,
     preferredLanguage: locale,
   );
   ```
4. l10n: `profileVisaExpiry` キーを再利用（新規キー追加不要）

**参考**: Profile 画面（`profile_screen.dart`）の `_showVisaExpirySheet()` に `showDatePicker` の実装あり。

### Frontend — API クライアント

**ファイル**: `app/lib/features/profile/data/profile_repository.dart`

`trialSetup()` メソッドに `visaExpiry` と `preferredLanguage` パラメータを追加:

```dart
Future<UserProfile> trialSetup({
  required String nationality,
  required String residenceStatus,
  required String residenceRegion,
  String? visaExpiry,           // ← 追加
  String? preferredLanguage,    // ← 追加
}) async {
  final response = await _dio.post(
    '/profile/trial-setup',
    data: {
      'nationality': nationality,
      'residence_status': residenceStatus,
      'residence_region': residenceRegion,
      if (visaExpiry != null) 'visa_expiry': visaExpiry,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
    },
  );
  // ...
}
```

---

## Task 2: 匿名ユーザー用 簡易 Profile 画面

### 概要

匿名ユーザーが Trial Setup で入力した情報を後から変更できるようにする。
既存の `ProfileScreen` を拡張して、匿名ユーザー向けの簡易表示モードを追加する。

### ファイル: `app/lib/features/profile/presentation/profile_screen.dart`

**変更方針**: 新規画面は作らない。既存 `ProfileScreen` 内で匿名ユーザーかどうかを判定し、表示する項目を切り替える。

**匿名ユーザー向け表示**:

```
┌─ アカウント ─────────────────────────┐
│                                      │
│  セクション 1: 基本情報               │
│  ├── 国籍           [中国 🇨🇳]  >   │
│  ├── 在留資格       [技術・人文...]>  │
│  ├── 在留期限       [2027/03/15]  >  │
│  └── 居住地域       [新宿区, 東京都]> │
│                                      │
│  セクション 2: 言語                   │
│  └── 使用言語       [中文]        >   │
│                                      │
│  ⚠️ 匿名アカウント: 正式登録す       │
│  ると完全な機能をご利用いただけます   │
│  [正式アカウントを作成] ボタン         │
│                                      │
└──────────────────────────────────────┘
```

**非表示にする項目（匿名ユーザー）:**
- 表示名（display_name）— 匿名なので不要
- サブスクリプション — IAP 未実装
- アカウント削除 — 匿名は端末ベースなので不要
- ログアウト → 表示するが、テキストを「データをリセット」等に変えない。
  → **そのまま「ログアウト」を表示**。匿名ユーザーがログアウトすると
  新しい匿名 UID が作られ、以前の Profile・Credit は失われる。

**ロジック**:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final isAnonymous = ref.watch(isAnonymousProvider);

  // ... existing profileAsync.when() ...

  // Section 1: Profile info
  // 匿名: nationality, residence_status, visa_expiry, residence_region のみ
  // 正規: display_name + 上記 + preferred_language

  // Section 2: Account Management
  // 匿名: 「正式アカウントを作成」ボタン + ログアウト
  // 正規: サブスクリプション + ログアウト + 削除
}
```

**「正式アカウントを作成」ボタン**: `context.push(AppRoutes.register)` で遷移。

### ファイル: `app/lib/core/navigation/main_shell.dart`

**Batch 1 で Profile tab を非表示にした変更を元に戻す**:

```dart
// 元に戻す: Profile tab は常に表示
// 匿名ユーザーでも ProfileScreen が簡易版を表示するため
```

`MainShell` を `StatelessWidget` に戻す（`ConsumerWidget` 不要に）。
`_visibleTabs` の `hideProfile` ロジックを削除。Tab は常に 5 つ表示。

### ファイル: `app/lib/core/providers/router_provider.dart`

**Profile ルートの redirect を修正**:

```dart
// 変更前（匿名→/home にリダイレクト）:
if (currentPath == AppRoutes.profile) {
  final user = authState.valueOrNull;
  if (user == null || user.isAnonymous) {
    return AppConfig.testFlightMode ? AppRoutes.home : AppRoutes.login;
  }
}

// 変更後:
if (currentPath == AppRoutes.profile) {
  final user = authState.valueOrNull;
  if (user == null) {
    return AppRoutes.login;
  }
  // 匿名ユーザー（TestFlight）は ProfileScreen の簡易版を表示するため
  // リダイレクトしない
}
```

---

## 既存コードの参照ポイント

| ファイル | 参照内容 |
|---------|---------|
| `app/lib/features/profile/presentation/profile_screen.dart` | 正規 Profile 画面（全フィールド表示 + BottomSheet 編集） |
| `app/lib/features/chat/presentation/widgets/trial_setup_dialog.dart` | Trial Setup ダイアログ（Batch 1 で 2-step region 実装済み） |
| `app/lib/core/providers/auth_provider.dart` | `isAnonymousProvider` — 匿名判定 |
| `app/lib/features/profile/data/profile_repository.dart` | `trialSetup()` + `updateProfile()` API |
| `backend/app_service/routers/profile_router.py` | trial-setup endpoint |

## NOT in scope

- l10n 新規キー追加不要（既存キー `profileVisaExpiry` 等を再利用）
- Tracker 自動生成ロジックは既存の Profile 画面にあるものをそのまま使う
- IAP / サブスクリプション画面の変更なし

## 手動検証チェックリスト

1. 匿名ユーザー → Chat → Trial Setup → 4 フィールド入力（visa_expiry は任意）→ Chat 画面表示
2. 匿名ユーザー → Account タブ → 簡易 Profile 表示 → 各フィールド変更可能
3. 匿名ユーザー → Profile で visa_expiry 変更 → Tracker 自動生成される
4. 匿名ユーザー → Profile で「正式アカウントを作成」→ 登録画面へ遷移
5. 正規ユーザー → Profile 画面の表示に変更がないこと（regression なし）
6. preferred_language が app locale から自動設定される（Trial Setup 完了後に backend の Profile を確認）
