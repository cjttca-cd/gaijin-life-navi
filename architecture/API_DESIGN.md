# API 設計

## API スタイル

**REST API** — 選定理由: Flutter (dio) との親和性が高く、ストリーミング (SSE) との相性が良い。GraphQL は MVP のクエリ複雑性に対して過剰。

## 共通仕様

### ベース URL

| サービス | ベース URL | ルーティング |
|---------|-----------|-------------|
| App Service (FastAPI) | `/api/v1/` | CF Workers → Fly.io (App Service) |
| AI Service (FastAPI) | `/api/v1/ai/` | CF Workers → Fly.io (AI Service) |

### 認証

- **方式**: Bearer Token (Firebase Auth ID Token)
- **ヘッダー**: `Authorization: Bearer {firebase_id_token}`
- **JWT 検証**: CF Workers の Edge で Firebase 公開鍵を使用して RS256 検証。バックエンドでも Firebase Admin SDK で二重検証
- **未認証エンドポイント**: `/api/v1/auth/register`, `/api/v1/health`, `/api/v1/banking/banks` (公開情報), `/api/v1/subscriptions/plans`, `/api/v1/subscriptions/webhook`

> クライアント (Flutter) は `firebase_auth` パッケージでサインイン後、`getIdToken()` で ID Token を取得し、dio の interceptor で全リクエストに付与する。

### エラーフォーマット

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "details": {
      "field": "email",
      "constraint": "required"
    }
  }
}
```

**エラーコード一覧**:

| HTTP Status | code | 意味 |
|-------------|------|------|
| 400 | `VALIDATION_ERROR` | リクエストバリデーション失敗 |
| 401 | `UNAUTHORIZED` | 認証なし / トークン期限切れ |
| 403 | `FORBIDDEN` | 権限なし（Tier 不足含む） |
| 404 | `NOT_FOUND` | リソースが存在しない |
| 409 | `CONFLICT` | 重複（メール等） |
| 422 | `UNPROCESSABLE_ENTITY` | ビジネスルール違反 |
| 429 | `RATE_LIMITED` | レート制限超過 |
| 500 | `INTERNAL_ERROR` | サーバーエラー |

### ページネーション

**Cursor-based** — コミュニティ投稿等のリスト API に適用。

```
GET /api/v1/community/posts?limit=20&cursor={last_id}
```

**レスポンス**:
```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "uuid-of-last-item",
    "has_more": true
  }
}
```

- `limit`: デフォルト 20、最大 50
- `cursor`: 前回取得の最後の ID

### 共通レスポンスラッパー

```json
{
  "data": { ... },
  "meta": {
    "request_id": "uuid"
  }
}
```

リスト系:
```json
{
  "data": [...],
  "pagination": { ... },
  "meta": {
    "request_id": "uuid",
    "total_count": 42
  }
}
```

---

## エンドポイント

---

### Auth

> Firebase Auth SDK をクライアント (Flutter) から直接利用してサインイン/サインアップを行う。
> 以下の API はサーバー側でプロフィール作成等の追加処理を行うラッパー。

#### `POST /api/v1/auth/register`

- **説明**: プロフィール作成（Firebase Auth でアカウント作成後にクライアントが呼び出す）
- **認証**: 必要（Firebase ID Token — 直前に作成したアカウントの Token）
- **Request Body**:
  ```json
  {
    "display_name": "string (optional, max 100)",
    "preferred_language": "string (optional, enum: en|zh|vi|ko|pt, default: en)"
  }
  ```
- **Response 201**:
  ```json
  {
    "data": {
      "user": {
        "id": "firebase_uid",
        "email": "user@example.com",
        "display_name": "John",
        "preferred_language": "en",
        "subscription_tier": "free",
        "onboarding_completed": false
      }
    }
  }
  ```
- **Errors**: 409 (profile already exists)
- **処理**: Firebase ID Token から UID と email を取得 → profiles テーブルにレコード作成

#### `POST /api/v1/auth/delete-account`

- **説明**: アカウント削除（プロフィールのソフトデリート + Firebase Auth アカウント削除）
- **認証**: 必要
- **Response 200**: `{"data": {"message": "Account deleted"}}`
- **処理**: profiles.deleted_at 設定 → サブスクあれば Stripe キャンセル → Firebase Admin SDK でアカウント削除

---

### User Profile

#### `GET /api/v1/users/me`

- **説明**: 現在のユーザープロフィール取得
- **認証**: 必要
- **Response 200**:
  ```json
  {
    "data": {
      "id": "firebase_uid",
      "email": "user@example.com",
      "display_name": "Chen Wei",
      "avatar_url": "https://r2.example.com/avatars/uid.jpg",
      "nationality": "CN",
      "residence_status": "engineer_specialist",
      "residence_region": "13",
      "arrival_date": "2024-04-01",
      "preferred_language": "zh",
      "subscription_tier": "free",
      "onboarding_completed": true,
      "created_at": "2026-02-16T02:25:00Z"
    }
  }
  ```

#### `PATCH /api/v1/users/me`

- **説明**: プロフィール更新
- **認証**: 必要
- **Request Body** (全フィールド optional):
  ```json
  {
    "display_name": "string (max 100)",
    "avatar_url": "string (valid URL)",
    "nationality": "string (ISO 3166-1 alpha-2)",
    "residence_status": "string (enum, see DATA_MODEL §1)",
    "residence_region": "string (prefecture code)",
    "arrival_date": "string (YYYY-MM-DD)",
    "preferred_language": "string (en|zh|vi|ko|pt)"
  }
  ```
- **Response 200**: 更新後の profile オブジェクト
- **Errors**: 422 (validation)

#### `POST /api/v1/users/me/onboarding`

- **説明**: オンボーディング完了（プロフィール設定 + フラグ更新 + 初期手続き追加）
- **認証**: 必要
- **Request Body**:
  ```json
  {
    "nationality": "string (optional)",
    "residence_status": "string (optional)",
    "residence_region": "string (optional)",
    "arrival_date": "string (optional, YYYY-MM-DD)",
    "preferred_language": "string (required, en|zh|vi|ko|pt)"
  }
  ```
- **Response 200**: 更新後の profile（`onboarding_completed: true`）
- **処理**: プロフィール更新 + 来日直後の 5 大手続きを user_procedures に自動追加（see BUSINESS_RULES.md §8）

---

### AI Chat (AI Service)

#### `POST /api/v1/ai/chat/sessions`

- **説明**: 新しいチャットセッション作成
- **認証**: 必要
- **Request Body**:
  ```json
  {
    "initial_message": "string (optional, max 2000)"
  }
  ```
- **Response 201**:
  ```json
  {
    "data": {
      "session": {
        "id": "uuid",
        "title": null,
        "category": "general",
        "language": "en",
        "message_count": 0,
        "created_at": "2026-02-16T02:25:00Z"
      }
    }
  }
  ```
  > `initial_message` が指定された場合、セッション作成後に自動的にメッセージを送信し、AI 応答を SSE ストリーミング返却する。

#### `GET /api/v1/ai/chat/sessions`

- **説明**: チャットセッション一覧取得
- **認証**: 必要
- **Query Parameters**: `limit` (int, default 20, max 50), `cursor` (UUID, optional), `category` (string, optional)
- **Response 200**: セッション配列 + pagination

#### `GET /api/v1/ai/chat/sessions/:session_id`

- **説明**: セッション詳細 + 最新メッセージ 20 件
- **認証**: 必要
- **Errors**: 404, 403

#### `DELETE /api/v1/ai/chat/sessions/:session_id`

- **説明**: セッション削除（ソフトデリート）
- **認証**: 必要（所有者のみ）
- **Errors**: 404, 403

#### `POST /api/v1/ai/chat/sessions/:session_id/messages`

- **説明**: メッセージ送信 + AI 応答（ストリーミング）
- **認証**: 必要
- **Rate Limit**: Free ティア: 5 回/日（BUSINESS_RULES.md §2 参照）
- **Request Body**:
  ```json
  {
    "content": "string (required, max 2000)"
  }
  ```
- **Response 200** (SSE — `text/event-stream`):
  ```
  event: message_start
  data: {"message_id": "uuid", "role": "assistant"}

  event: content_delta
  data: {"delta": "日本で"}

  event: content_delta
  data: {"delta": "銀行口座を"}

  event: message_end
  data: {"sources": [{"title": "ISA Portal", "url": "https://..."}], "tokens_used": 450}
  ```
- **Errors**: 403 (`TIER_LIMIT_EXCEEDED`), 404

#### `GET /api/v1/ai/chat/sessions/:session_id/messages`

- **説明**: メッセージ履歴取得
- **認証**: 必要
- **Query Parameters**: `limit` (int, default 50, max 100), `cursor` (UUID), `order` (asc|desc, default asc)
- **Response 200**: メッセージ配列 + pagination

---

### Banking Navigator

#### `GET /api/v1/banking/banks`

- **説明**: 銀行一覧取得
- **認証**: 不要（公開情報）
- **Query Parameters**: `lang` (string, default en)
- **Response 200**: 銀行配列（bank_code, bank_name, features, foreigner_friendly_score 等）

#### `POST /api/v1/banking/recommend`

- **説明**: ユーザー条件に基づく銀行レコメンド
- **認証**: 必要
- **Request Body**:
  ```json
  {
    "nationality": "string (optional, defaults to profile)",
    "residence_status": "string (optional)",
    "residence_region": "string (optional)",
    "priorities": "string[] (optional, enum: multilingual|low_fee|atm|online)"
  }
  ```
- **Response 200**: recommendations 配列（bank オブジェクト + match_score + match_reasons + warnings）
- **計算ロジック**: see BUSINESS_RULES.md §7

#### `GET /api/v1/banking/banks/:bank_id/guide`

- **説明**: 特定銀行の詳細口座開設ガイド
- **認証**: 必要
- **Query Parameters**: `lang` (string)
- **Response 200**: bank オブジェクト + requirements + conversation_templates + troubleshooting

---

### Visa Navigator

#### `GET /api/v1/visa/procedures`

- **説明**: ビザ手続き一覧
- **認証**: 必要
- **Query Parameters**: `lang`, `status` (filter by applicable residence status)
- **Response 200**: 手続き配列

#### `GET /api/v1/visa/procedures/:procedure_id`

- **説明**: ビザ手続き詳細（ステップ、必要書類、費用）
- **認証**: 必要
- **Tier 制限**: Free = 基本情報のみ、Premium = 全情報（パーソナライズ含む）
- **Response 200**: 詳細オブジェクト + disclaimer

#### `POST /api/v1/visa/check`

- **説明**: 在留資格に基づく手続き適格性チェック
- **認証**: 必要
- **Tier 制限**: Premium のみ
- **Request Body**: `{ "procedure_type", "residence_status", "residence_expiry" }`
- **Response 200**: eligible + applicable_procedures + urgency + disclaimer

---

### Admin Procedure Tracker

#### `GET /api/v1/procedures/templates`

- **説明**: 行政手続きテンプレート一覧
- **認証**: 必要
- **Query Parameters**: `lang`, `category`, `arrival_essential` (boolean)
- **Response 200**: テンプレート配列

#### `GET /api/v1/procedures/my`

- **説明**: ユーザーの追跡中手続き一覧
- **認証**: 必要
- **Tier 制限**: Free = 最大 3 件、Premium = 無制限
- **Query Parameters**: `status` (not_started/in_progress/completed)
- **Response 200**: user_procedure 配列 + meta (total_count, limit, tier)

#### `POST /api/v1/procedures/my`

- **説明**: 手続きを追跡リストに追加
- **認証**: 必要
- **Tier 制限**: Free = 最大 3 件
- **Request Body**: `{ "procedure_ref_type", "procedure_ref_id", "due_date?", "notes?" }`
- **Response 201**: 作成された user_procedure
- **Errors**: 403 (`TIER_LIMIT_EXCEEDED`), 409 (already tracking), 404

#### `PATCH /api/v1/procedures/my/:id`

- **説明**: 追跡手続きの更新
- **認証**: 必要
- **Request Body**: `{ "status?", "due_date?", "notes?" }`
- **Response 200**: 更新後のオブジェクト

#### `DELETE /api/v1/procedures/my/:id`

- **説明**: 追跡手続き削除（ソフトデリート）
- **認証**: 必要

---

### Document Scanner (AI Service)

#### `POST /api/v1/ai/documents/scan`

- **説明**: 書類スキャン（アップロード → OCR → 翻訳 → 説明）
- **認証**: 必要
- **Tier 制限**: Free = 3 枚/月、Premium = 30 枚/月、Premium+ = 無制限
- **Content-Type**: `multipart/form-data`
- **Request Body**: `file` (image, required, max 10MB, jpg/png/heic), `target_language` (optional)
- **Response 202**: `{ "id", "status": "processing" }`
- **Errors**: 403 (`TIER_LIMIT_EXCEEDED`), 422 (invalid file)

#### `GET /api/v1/ai/documents`

- **説明**: スキャン済み書類一覧
- **認証**: 必要
- **Query Parameters**: `limit`, `cursor`
- **Response 200**: スキャン配列 + pagination

#### `GET /api/v1/ai/documents/:id`

- **説明**: スキャン結果詳細
- **認証**: 必要
- **Response 200**: file_url, ocr_text, translation, explanation, document_type, status 等

#### `DELETE /api/v1/ai/documents/:id`

- **説明**: スキャン結果削除（ソフトデリート）
- **認証**: 必要

---

### Community Q&A

#### `GET /api/v1/community/posts`

- **説明**: 投稿一覧取得
- **認証**: 必要
- **Query Parameters**: `channel` (required), `category`, `sort` (newest|popular), `limit`, `cursor`, `q` (search)
- **Response 200**: 投稿配列 + pagination

#### `POST /api/v1/community/posts`

- **説明**: 投稿作成
- **認証**: 必要
- **Tier 制限**: Premium 以上のみ
- **Request Body**: `{ "channel", "category", "title" (min 5, max 200), "content" (min 10, max 5000) }`
- **Response 201**: 作成された post（`ai_moderation_status: pending`）
- **Errors**: 403 (Tier 不足), 422

#### `GET /api/v1/community/posts/:id`

- **説明**: 投稿詳細
- **認証**: 必要
- **Response 200**: 投稿オブジェクト + user_voted フラグ

#### `PATCH /api/v1/community/posts/:id`

- **説明**: 投稿編集（投稿者のみ）
- **Request Body**: `{ "title?", "content?" }`

#### `DELETE /api/v1/community/posts/:id`

- **説明**: 投稿削除（投稿者のみ、ソフトデリート）

#### `POST /api/v1/community/posts/:id/replies`

- **説明**: 返信作成
- **Tier 制限**: Premium 以上
- **Request Body**: `{ "content" (min 5, max 3000) }`

#### `GET /api/v1/community/posts/:id/replies`

- **説明**: 返信一覧
- **Query Parameters**: `limit`, `cursor`

#### `PATCH /api/v1/community/replies/:id`

- **説明**: 返信編集（返信者のみ）

#### `DELETE /api/v1/community/replies/:id`

- **説明**: 返信削除（返信者のみ）

#### `POST /api/v1/community/posts/:id/vote`

- **説明**: 投稿に投票（トグル）
- **Tier 制限**: Premium 以上
- **Response 200**: `{ "voted": true, "upvote_count": 6 }`

#### `POST /api/v1/community/replies/:id/vote`

- **説明**: 返信に投票（トグル）
- **Tier 制限**: Premium 以上

#### `POST /api/v1/community/replies/:id/best-answer`

- **説明**: ベストアンサーに設定（投稿者のみ）
- **Errors**: 403 (投稿者以外)

---

### Subscription

#### `GET /api/v1/subscriptions/plans`

- **説明**: 利用可能なプラン一覧
- **認証**: 不要
- **Response 200**: プラン配列（id, name, price, currency, interval, features）

#### `POST /api/v1/subscriptions/checkout`

- **説明**: Stripe Checkout セッション作成
- **認証**: 必要
- **Request Body**: `{ "plan_id", "success_url", "cancel_url" }`
- **Response 200**: `{ "checkout_url": "https://checkout.stripe.com/..." }`

#### `GET /api/v1/subscriptions/me`

- **説明**: 現在のサブスクリプション状態
- **認証**: 必要
- **Response 200**: tier, status, current_period_end, cancel_at_period_end, manage_url

#### `POST /api/v1/subscriptions/cancel`

- **説明**: サブスクリプションキャンセル（期間終了時に解約）
- **認証**: 必要
- **Response 200**: status, cancel_at_period_end, current_period_end

#### `POST /api/v1/subscriptions/webhook`

- **説明**: Stripe Webhook ハンドラー
- **認証**: Stripe Webhook Signature で検証
- **処理するイベント**: see BUSINESS_RULES.md §9

---

### Usage

#### `GET /api/v1/usage/today`

- **説明**: 当日の利用状況
- **認証**: 必要
- **Response 200**:
  ```json
  {
    "data": {
      "chat_count": 3,
      "chat_limit": 5,
      "chat_remaining": 2,
      "scan_count_monthly": 1,
      "scan_limit_monthly": 3,
      "scan_remaining_monthly": 2,
      "tier": "free"
    }
  }
  ```

---

### Medical Guide

#### `GET /api/v1/medical/phrases`

- **説明**: 症状翻訳フレーズ集
- **認証**: 必要
- **Query Parameters**: `lang`, `category` (symptom/emergency/insurance/general)
- **Response 200**: フレーズ配列（phrase_ja, phrase_reading, translation, context）

#### `GET /api/v1/medical/emergency-guide`

- **説明**: 緊急時ガイド（静的コンテンツ）
- **認証**: 必要
- **Query Parameters**: `lang`
- **Response 200**: emergency_number, how_to_call, what_to_prepare, useful_phrases + disclaimer

---

### Health Check

#### `GET /api/v1/health`

- **説明**: ヘルスチェック
- **認証**: 不要
- **Response 200**:
  ```json
  {
    "status": "ok",
    "version": "0.1.0",
    "services": {
      "database": "ok",
      "ai_service": "ok",
      "vector_db": "ok"
    }
  }
  ```
