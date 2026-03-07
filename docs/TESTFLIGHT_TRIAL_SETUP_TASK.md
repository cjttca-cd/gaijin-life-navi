# TestFlight Trial Setup — 実装タスク

> 作成日: 2026-03-07
> ステータス: PM に委譲
> 優先度: 高（TestFlight テスト前の必須対応）

## 背景

TestFlight モードで匿名ユーザーが AI Chat を利用する際、Profile 行がないため Agent がパーソナライズ回答を提供できない。現在の `_testflight_hint` アプローチ（Agent に口頭で聞かせる）を廃止し、ダイアログで 3 フィールドを事前収集 → Profile テーブルに保存する方式に変更する。

## 変更概要

### Backend（3 ファイル変更 + 1 ファイル新規）

#### 1. 新規: `POST /api/v1/profile/trial-setup` エンドポイント
- **場所**: `backend/app_service/routers/profile_router.py` に追加
- **仕様**: `architecture/API_DESIGN.md` §10 参照
- **処理**:
  1. `TESTFLIGHT_MODE` チェック → false なら 404
  2. Firebase JWT 検証 → UID 取得
  3. Profile 取得 or 新規作成
     - 新規作成時: `email = f"anon-{uid}@testflight.local"`
     - ⚠️ Profile テーブルの email は `NOT NULL UNIQUE` — プレースホルダーで制約を満たす
  4. nationality / residence_status / residence_region を設定
  5. Chat Credit が 0 の場合 → `grant_credits()` で 5 回分付与（`services/credits.py` の既存関数を使用）
  6. Profile 返却

- **参考実装**: `profile_router.py` の `_get_or_create_profile()` が類似ロジック（Auto-create + abuse prevention）を持つ。ただし trial-setup は匿名ユーザー専用のため、email 重複のabuse prevention は不要。

#### 2. 変更: `backend/app_service/routers/chat.py`
- **削除**: L393-404 の `_testflight_hint` 注入ブロック全体を削除
- **変更後**: TestFlight かどうかに関係なく、profile が None の場合は `{"subscription_tier": tier}` のみ設定（既存の else 分岐と同じ）
- **理由**: trial-setup で Profile が事前に作成されるため、chat.py の L375-385 で正常に Profile データが取得される

#### 3. 変更: `backend/app_service/services/agent.py`
- **削除**: L136-138 の `_testflight_hint` 処理を削除（`hint = user_profile.get("_testflight_hint")` + `if hint:` ブロック）

#### 4. テスト更新
- 新規: `test_trial_setup_creates_profile` — 匿名ユーザーの Profile 作成
- 新規: `test_trial_setup_returns_404_when_not_testflight` — 本番モードで 404
- 新規: `test_trial_setup_idempotent` — 2 回目呼び出しは既存 Profile 返却
- 新規: `test_trial_setup_grants_credits` — Credit が付与される
- 既存: `test_chat_guest_returns_403` のmonkeypatch（TESTFLIGHT_MODE=False）を維持

### Frontend（Flutter — 2 ファイル変更 + 1 ファイル新規）

#### 1. 新規: Trial Setup ダイアログ
- **場所**: `app/lib/features/chat/presentation/widgets/trial_setup_dialog.dart`（新規作成）
- **UI**:
  - BottomSheet or Dialog
  - タイトル: "始める前に、少し教えてください"（i18n 対応）
  - 3 つのドロップダウン:
    - 国籍: `app/lib/data/nationalities.dart` のデータを使用
    - 在留資格: `app/lib/data/residence_statuses.dart` のデータを使用
    - 居住地域: `app/lib/data/regions.dart` のデータを使用
  - 送信ボタン → `POST /api/v1/profile/trial-setup` 呼び出し
  - 成功 → ダイアログ閉じる → Chat 画面表示
- **参考**: Profile 画面（`app/lib/features/profile/presentation/profile_screen.dart`）が同様のドロップダウン選択 UI を既に持つ。BottomSheet 選択ロジックも同ファイルに実装済み。

#### 2. 変更: Chat 画面のエントリーポイント
- **場所**: `app/lib/features/chat/presentation/chat_screen.dart`（推定）
- **ロジック**:
  1. TestFlight モードかつ匿名ユーザーか判定（`AppConfig.testFlightMode` + Firebase user の `isAnonymous`）
  2. Profile に nationality が設定済みか確認（`GET /api/v1/profile` or ローカルキャッシュ）
  3. 未設定 → Trial Setup ダイアログを表示（dismissible=false）
  4. 設定済み → 通常の Chat 画面を表示

#### 3. API クライアント追加
- **場所**: `app/lib/features/profile/data/` or 共通 API クライアント
- `POST /api/v1/profile/trial-setup` の API 呼び出しメソッドを追加

### i18n（5 言語 ARB ファイル）
- 新規キー追加:
  - `trialSetupTitle`: "始める前に、少し教えてください" / "Before we start, tell us a bit about yourself"
  - `trialSetupNationality`: "国籍" / "Nationality"
  - `trialSetupResidenceStatus`: "在留資格" / "Residence Status"
  - `trialSetupRegion`: "居住地域" / "Region"
  - `trialSetupSubmit`: "はじめる" / "Get Started"

## 既存コードの参照ポイント

| ファイル | 参照内容 |
|---------|---------|
| `backend/app_service/routers/profile_router.py` | `_get_or_create_profile()` — Profile 自動作成ロジック |
| `backend/app_service/routers/auth.py` L85-101 | `register()` — Profile 作成 + grant_credits 呼び出し |
| `backend/app_service/services/credits.py` | `grant_credits()` — Credit 付与関数 |
| `backend/app_service/routers/chat.py` L375-413 | Profile 取得 → Agent 呼び出しフロー（_testflight_hint 削除対象） |
| `backend/app_service/services/agent.py` L136-138 | _testflight_hint 処理（削除対象） |
| `app/lib/features/profile/presentation/profile_screen.dart` | BottomSheet ドロップダウン選択 UI |
| `app/lib/data/nationalities.dart` | 国籍データ |
| `app/lib/data/residence_statuses.dart` | 在留資格データ |
| `app/lib/data/regions.dart` | 都道府県データ |
| `app/lib/core/config/app_config.dart` | `testFlightMode` フラグ |

## 仕様参照ドキュメント

- `architecture/API_DESIGN.md` §10 — エンドポイント詳細仕様
- `architecture/BUSINESS_RULES.md` §9 — TestFlight モード業務ルール
- `architecture/DATA_MODEL.md` §6 — 匿名ユーザー Profile データモデル

## 注意事項

1. **email プレースホルダー**: `anon-{uid}@testflight.local` は Profile テーブルの UNIQUE 制約を満たすためのもの。UID ごとに一意なので衝突しない。
2. **idempotent**: trial-setup は何度呼んでも安全。既に Profile があれば更新 or 既存返却。
3. **既存の `_get_or_create_profile`（profile_router.py）との違い**: profile_router 版は `user.email` を使う（正規ユーザー向け）。trial-setup は匿名ユーザー向けでプレースホルダー email を使用。混同しないこと。
4. **Credit 付与重複防止**: `grant_credits()` 呼び出し前に既存 credit の有無を確認する。
5. **本番モードへの影響**: `TESTFLIGHT_MODE=false` では trial-setup endpoint が 404 を返すため、本番プロダクトに一切影響しない。

