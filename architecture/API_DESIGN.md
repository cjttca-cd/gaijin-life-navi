# API 設計

## API スタイル

**REST API** — FastAPI (Python) で実装。API Gateway (port 8000) が全エンドポイントを提供。
Phase 0 は同期レスポンス（SSE ストリーミングなし）。

## 共通仕様

### ベース URL

| サービス | ベース URL | 説明 |
|---------|-----------|------|
| API Gateway (FastAPI) | `/api/v1/` | 全 API を一元提供 |

> **旧アーキテクチャとの違い**: ~~AI Service (port 8001) への /api/v1/ai/* ルーティング~~ は廃止。OpenClaw Runtime に統合されたため、全 API を単一の FastAPI (port 8000) で提供。

### 認証

- **方式**: Bearer Token (Firebase Auth ID Token)
- **ヘッダー**: `Authorization: Bearer {firebase_id_token}`
- **JWT 検証**: API Gateway (FastAPI) で Firebase Admin SDK を使用して検証
- **未認証エンドポイント**: `/api/v1/health`, `/api/v1/auth/register`, `/api/v1/emergency`, `/api/v1/navigator/domains`, `/api/v1/navigator/{domain}/guides`, `/api/v1/subscription/plans`

### エラーフォーマット

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable message in request language",
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
| 429 | `USAGE_LIMIT_EXCEEDED` | 利用制限超過 |
| 429 | `RATE_LIMITED` | レート制限超過 |
| 500 | `INTERNAL_ERROR` | サーバーエラー |
| 502 | `AGENT_ERROR` | Agent 呼び出しエラー |

### 共通レスポンスラッパー

```json
{
  "data": { ... }
}
```

---

## エンドポイント一覧

| Method | Path | 説明 | 認証 |
|--------|------|------|------|
| POST | /api/v1/chat | AI Chat（テキスト + 画像） | Required |
| GET | /api/v1/navigator/domains | ドメイン一覧 | Public |
| GET | /api/v1/navigator/{domain}/guides | ドメイン別ガイド一覧 | Public |
| GET | /api/v1/navigator/{domain}/guides/{slug} | ガイド詳細 | Optional（tier で全文/excerpt 分岐） |
| GET | /api/v1/emergency | 緊急連絡先・救急ガイド | Public |
| POST | /api/v1/auth/register | ユーザー登録 | Required (JWT) |
| POST | /api/v1/auth/delete-account | アカウント削除 | Required |
| GET | /api/v1/users/me | プロフィール取得 | Required |
| PATCH | /api/v1/users/me | プロフィール更新 | Required |
| POST | /api/v1/users/me/onboarding | オンボーディング完了 | Required |
| GET | /api/v1/subscription/plans | 料金プラン一覧 | Public |
| POST | /api/v1/subscription/purchase | 購入処理（IAP レシート検証） | Required |
| GET | /api/v1/usage | 利用状況（残回数等） | Required |
| GET | /api/v1/profile | プロフィール取得 | Required |
| PUT | /api/v1/profile | プロフィール更新 | Required |
| GET | /api/v1/health | ヘルスチェック | Public |

### ~~廃止されたエンドポイント（Phase 0 ピボット）~~

以下のエンドポイントは Phase 0 ピボットで廃止:
- ~~POST /api/v1/ai/chat/sessions~~ → POST /api/v1/chat に統合
- ~~POST /api/v1/ai/chat/sessions/:id/messages~~ → POST /api/v1/chat に統合
- ~~GET/DELETE /api/v1/ai/chat/sessions/*~~ → OpenClaw session 管理に委譲
- ~~POST /api/v1/ai/documents/scan~~ → AI Chat 画像入力に統合
- ~~GET/DELETE /api/v1/ai/documents/*~~ → 削除
- ~~GET/POST /api/v1/community/*~~ → Phase 0 ピボットで Community 削除
- ~~GET /api/v1/banking/banks~~ → Navigator API に統合
- ~~POST /api/v1/banking/recommend~~ → AI Chat に統合
- ~~GET /api/v1/visa/procedures~~ → Navigator API に統合
- ~~GET /api/v1/medical/phrases~~ → svc-medical の knowledge に統合
- ~~POST /api/v1/subscriptions/checkout~~ → Apple IAP / Google Play Billing に変更

---

## エンドポイント詳細

---

### 1. AI Chat（コアエンドポイント）

#### `POST /api/v1/chat`

- **説明**: AI Chat — テキスト（+ 画像: Phase 1）をドメイン agent にルーティングし、構造化レスポンスを返す
- **認証**: 必要
- **Rate Limit**: ティアによる制限（BUSINESS_RULES.md §2 参照）

**Request Body**:
```json
{
  "message": "銀行口座を開設したいのですが",
  "image": null,
  "domain": null,
  "locale": "zh"
}
```

| フィールド | 型 | 必須 | 説明 |
|-----------|------|------|------|
| message | string | ✅ | ユーザーメッセージ (1-4000文字) |
| image | string\|null | — | Base64 画像 (Phase 1 で実装) |
| domain | string\|null | — | ドメインヒント: finance, tax, visa, medical, life, legal。指定時は LLM routing をスキップ |
| locale | string | — | ユーザー言語 (default: "en") |

**Response 200**:
```json
{
  "data": {
    "reply": "銀行口座の開設についてご案内します。\n\n日本で外国人が銀行口座を開設するには、以下の書類が必要です：\n\n1. **在留カード**（有効期限が3ヶ月以上残っていること）\n2. **パスポート**\n3. **住民票**（発行から3ヶ月以内）\n\n## おすすめの銀行\n\n多言語対応の銀行をいくつかご紹介します：\n- **ゆうちょ銀行**: 全国に支店があり、英語対応ATMが多い\n- **三井住友銀行**: 英語・中国語対応のオンラインバンキング\n- **セブン銀行**: コンビニATMで24時間利用可能",
    "domain": "finance",
    "sources": [
      {
        "title": "金融庁 外国人向けガイド",
        "url": "https://www.fsa.go.jp/..."
      },
      {
        "title": "全銀協 口座開設マニュアル",
        "url": "https://www.zenginkyo.or.jp/..."
      }
    ],
    "actions": [
      {
        "type": "checklist",
        "items": "在留カード, パスポート, 住民票"
      },
      {
        "type": "next_step",
        "text": "最寄りのゆうちょ銀行支店を検索しますか？"
      }
    ],
    "tracker_items": [
      {
        "type": "deadline",
        "title": "銀行口座開設",
        "date": ""
      }
    ],
    "usage": {
      "used": 3,
      "limit": 5,
      "tier": "free"
    }
  }
}
```

| レスポンスフィールド | 型 | 説明 |
|---|---|---|
| reply | string | AI の回答テキスト（markdown 形式） |
| domain | string | ルーティング先ドメイン (finance/tax/visa/medical/life/legal) |
| sources | array | 参考ソース `[{title, url}]` |
| actions | array | 提案アクション `[{type, ...}]` |
| tracker_items | array | Tracker 自動追加候補 `[{type, title, date}]` |
| usage | object | 利用状況 `{used, limit, tier}` |

**Error 429 (利用制限超過)**:
```json
{
  "error": {
    "code": "USAGE_LIMIT_EXCEEDED",
    "message": "Chat limit reached for your free plan. Used 5/5 chats.",
    "details": {
      "usage": {
        "used": 5,
        "limit": 5,
        "tier": "free"
      }
    }
  }
}
```

**Error 502 (Agent エラー)**:
```json
{
  "error": {
    "code": "AGENT_ERROR",
    "message": "The AI agent encountered an error. Please try again.",
    "details": {
      "agent_error": "Agent timed out after 75s"
    }
  }
}
```

**処理フロー**:
1. Firebase JWT 検証 → user_id 取得
2. profiles.subscription_tier 取得
3. daily_usage チェック + インクリメント（制限超過なら 429）
4. Emergency keyword 検出 → svc-medical / LLM 軽量分類 → 6 ドメイン判定 (finance/tax/visa/medical/life/legal)
5. `openclaw agent --agent svc-{domain} --session-id app_{uid}_{domain}` 呼び出し
6. Response text から `[SOURCES]` `[ACTIONS]` `[TRACKER]` ブロック解析
7. 構造化 ChatResponse を返却

---

### 2. Navigator

#### `GET /api/v1/navigator/domains`

- **説明**: 全ナビゲーションドメインの一覧取得（6 ドメイン、全 active）
- **認証**: 不要（公開情報）

**Response 200**:
```json
{
  "data": {
    "domains": [
      {
        "id": "finance",
        "label": "Finance & Banking",
        "icon": "🏦",
        "status": "active",
        "guide_count": 6
      },
      {
        "id": "tax",
        "label": "Tax & Pension",
        "icon": "📋",
        "status": "active",
        "guide_count": 6
      },
      {
        "id": "visa",
        "label": "Visa & Immigration",
        "icon": "🛂",
        "status": "active",
        "guide_count": 6
      },
      {
        "id": "medical",
        "label": "Medical & Health",
        "icon": "🏥",
        "status": "active",
        "guide_count": 7
      },
      {
        "id": "life",
        "label": "Life & Daily Living",
        "icon": "🗾",
        "status": "active",
        "guide_count": 8
      },
      {
        "id": "legal",
        "label": "Legal & Rights",
        "icon": "⚖️",
        "status": "active",
        "guide_count": 5
      }
    ]
  }
}
```

#### `GET /api/v1/navigator/{domain}/guides`

- **説明**: ドメイン別ガイド一覧（guides/ ディレクトリの .md ファイルを一覧）
- **認証**: 不要（公開情報）

**Response 200**:
```json
{
  "data": {
    "domain": "finance",
    "guides": [
      {
        "slug": "account-opening",
        "title": "Bank Account Opening Guide for Foreign Residents",
        "summary": "Step-by-step guide to opening a bank account in Japan as a foreign resident."
      },
      {
        "slug": "banks-overview",
        "title": "Major Banks Comparison",
        "summary": "Comparison of major banks in Japan for foreign residents."
      },
      {
        "slug": "remittance",
        "title": "International Money Transfer Guide",
        "summary": "Compare remittance options: bank transfer, Wise, Western Union."
      }
    ]
  }
}
```

#### `GET /api/v1/navigator/{domain}/guides/{slug}`

- **説明**: 特定ガイドの全文取得（markdown コンテンツ）
- **認証**: 不要（公開情報。将来 Tier-based 制限を検討）

**Response 200**:
```json
{
  "data": {
    "domain": "finance",
    "slug": "account-opening",
    "title": "Bank Account Opening Guide for Foreign Residents",
    "summary": "Step-by-step guide to opening a bank account in Japan as a foreign resident.",
    "content": "# Bank Account Opening Guide for Foreign Residents\n\n## Required Documents\n\n1. **Residence Card** (在留カード)\n2. **Passport**\n3. **Proof of Address** (住民票)..."
  }
}
```

**Error 404**:
```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Guide 'nonexistent' not found in domain 'finance'.",
    "details": {}
  }
}
```

---

### 3. Emergency

#### `GET /api/v1/emergency`

- **説明**: 緊急連絡先・救急ガイド（常時公開、認証不要）
- **認証**: 不要

**Response 200**:
```json
{
  "data": {
    "title": "Emergency Contacts — Japan",
    "contacts": [
      {"name": "Police", "number": "110", "note": ""},
      {"name": "Fire / Ambulance", "number": "119", "note": ""},
      {"name": "Emergency (English)", "number": "#7119", "note": "Medical consultation"},
      {"name": "TELL Japan", "number": "03-5774-0992", "note": "Mental health"},
      {"name": "Japan Helpline", "number": "0570-064-211", "note": "24h, multilingual"}
    ],
    "content": "# Emergency Guide\n\n## How to call 119 (Ambulance)..."
  }
}
```

---

### 4. Auth

#### `POST /api/v1/auth/register`

- **説明**: プロフィール作成（Firebase Auth でアカウント作成後にクライアントが呼び出す）
- **認証**: 必要（Firebase ID Token — 直前に作成したアカウントの Token）

**Request Body**:
```json
{
  "display_name": "Chen Wei",
  "preferred_language": "zh"
}
```

**Response 201**:
```json
{
  "data": {
    "user": {
      "id": "firebase_uid_abc123",
      "email": "user@example.com",
      "display_name": "Chen Wei",
      "preferred_language": "zh",
      "subscription_tier": "free",
      "onboarding_completed": false
    }
  }
}
```

**Error 409**: profile already exists

#### `POST /api/v1/auth/delete-account`

- **説明**: アカウント削除（プロフィールのソフトデリート + Firebase Auth アカウント削除）
- **認証**: 必要

**Response 200**:
```json
{
  "data": {
    "message": "Account deleted"
  }
}
```

---

### 5. User Profile

#### `GET /api/v1/users/me`

- **説明**: 現在のユーザープロフィール取得
- **認証**: 必要

**Response 200**:
```json
{
  "data": {
    "id": "firebase_uid_abc123",
    "email": "user@example.com",
    "display_name": "Chen Wei",
    "avatar_url": null,
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

- **説明**: プロフィール更新（全フィールド optional）
- **認証**: 必要

**Request Body**:
```json
{
  "nationality": "CN",
  "residence_status": "engineer_specialist",
  "residence_region": "13",
  "preferred_language": "zh"
}
```

**Response 200**: 更新後の profile オブジェクト

#### `POST /api/v1/users/me/onboarding`

- **説明**: オンボーディング完了
- **認証**: 必要

**Request Body**:
```json
{
  "nationality": "CN",
  "residence_status": "engineer_specialist",
  "residence_region": "13",
  "arrival_date": "2024-04-01",
  "preferred_language": "zh"
}
```

**Response 200**: 更新後の profile（`onboarding_completed: true`）

---

### 6. Subscription

#### `GET /api/v1/subscription/plans`

- **説明**: 利用可能なプラン一覧
- **認証**: 不要

**Response 200**:
```json
{
  "data": {
    "plans": [
      {
        "id": "free",
        "name": "Free",
        "price": 0,
        "currency": "JPY",
        "interval": null,
        "features": {
          "chat_limit": "5/day",
          "tracker_limit": 3,
          "ads": true
        }
      },
      {
        "id": "standard",
        "name": "Standard",
        "price": 720,
        "currency": "JPY",
        "interval": "month",
        "features": {
          "chat_limit": "300/month",
          "tracker_limit": null,
          "ads": false
        }
      },
      {
        "id": "premium",
        "name": "Premium",
        "price": 1360,
        "currency": "JPY",
        "interval": "month",
        "features": {
          "chat_limit": "unlimited",
          "tracker_limit": null,
          "ads": false
        }
      }
    ],
    "charge_packs": [
      {"chats": 100, "price": 360, "unit_price": 3.6},
      {"chats": 50, "price": 180, "unit_price": 3.6}
    ]
  }
}
```

#### `POST /api/v1/subscription/purchase`

- **説明**: IAP 購入処理（Apple レシート or Google purchase token を検証）
- **認証**: 必要

**Request Body**:
```json
{
  "platform": "ios",
  "receipt": "MIIbzg...",
  "product_id": "com.gaijinlifenavi.standard_monthly"
}
```

**Response 200**:
```json
{
  "data": {
    "subscription": {
      "tier": "standard",
      "status": "active",
      "current_period_end": "2026-03-17T00:00:00Z"
    }
  }
}
```

---

### 7. Usage

#### `GET /api/v1/usage`

- **説明**: 当日/当月の利用状況
- **認証**: 必要

**Response 200 (Free ティア)**:
```json
{
  "data": {
    "chat_count": 3,
    "chat_limit": 5,
    "chat_remaining": 2,
    "period": "day",
    "tier": "free"
  }
}
```

**Response 200 (Standard ティア)**:
```json
{
  "data": {
    "chat_count": 45,
    "chat_limit": 300,
    "chat_remaining": 255,
    "period": "month",
    "tier": "standard"
  }
}
```

**Response 200 (Premium ティア)**:
```json
{
  "data": {
    "chat_count": 120,
    "chat_limit": null,
    "chat_remaining": null,
    "period": "month",
    "tier": "premium"
  }
}
```

---

### 8. Health Check

#### `GET /api/v1/health`

- **説明**: ヘルスチェック
- **認証**: 不要

**Response 200**:
```json
{
  "status": "ok",
  "version": "0.1.0",
  "services": {
    "database": "ok",
    "openclaw_gateway": "ok"
  }
}
```

---

## 変更履歴

- 2026-02-16: 初版作成
- 2026-02-17: Phase 0 アーキテクチャピボット反映（OC Runtime / memory_search / LLM routing / 課金体系更新）
- 2026-02-21: 6 Agent 体系反映（ドメイン一覧 6 active に更新、routing 分類ロジック更新）
