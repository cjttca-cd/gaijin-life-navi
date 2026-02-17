# ARCHITECTURE — gaijin-life-navi

> **本文書は Worker 向けの実装ガイド（How）**。技術選定の理由（Why）は `architecture/SYSTEM_DESIGN.md` を参照。

## Tech Stack

| Layer | Technology | Version | 備考 |
|-------|-----------|---------|------|
| Mobile/Web | Flutter | stable 3.x (Dart 3) | iOS/Android/Web 単一コードベース |
| 状態管理 | Riverpod | 2.x + riverpod_generator | 型安全、コード生成 |
| ルーティング | go_router | 14.x | 宣言的ルーティング、Deep Link |
| ローカル DB | drift (SQLite) | 2.x | キャッシュ専用（SSOT はサーバー DB） |
| HTTP | dio | 5.x | インターセプター、SSE 対応 |
| 認証 | Firebase Auth | latest | Email/Password + Apple Sign In |
| i18n | Flutter intl (ARB) | built-in | 5 言語: en/zh/vi/ko/pt |
| UI | Material 3 + Cupertino | built-in | iOS 優先デザイン |
| API Gateway | Cloudflare Workers | Wrangler 3.x | エッジ JWT 検証 + Rate Limit |
| App Service | FastAPI (Python) | 0.115+ | CRUD, Webhook, Auth プロキシ |
| AI Service | FastAPI (Python) | 0.115+ | LLM, RAG, OCR |
| Python | Python | 3.12+ | |
| LLM | Claude API (Anthropic) | claude-sonnet-4-20250514 | |
| RAG | LangChain | 0.3.x | Pinecone 連携 |
| Vector DB | Pinecone | Serverless | embedding: text-embedding-3-small |
| OCR | Cloud Vision API | v1 | 日本語 OCR |
| Server DB | PostgreSQL | 15+ | マネージド（Supabase/Neon） |
| Object Storage | Cloudflare R2 | latest | S3 互換、エグレス無料 |
| 決済 | Stripe | latest SDK | サブスク管理 |
| LP | Astro | 5.x | 静的サイト → Cloudflare Pages |
| Hosting | Fly.io | nrt (東京) | App Service + AI Service |

## Monorepo 構成

```
gaijin-life-navi/
├── app/                           # Flutter App (iOS/Android/Web)
│   ├── lib/
│   │   ├── core/                  # DI, theme, constants, utils
│   │   ├── features/              # feature-first 構造
│   │   │   ├── auth/              # 登録/ログイン/ログアウト
│   │   │   ├── onboarding/        # 初回セットアップ
│   │   │   ├── home/              # ダッシュボード
│   │   │   ├── chat/              # AI チャット (SSE ストリーミング)
│   │   │   ├── banking/           # Banking Navigator
│   │   │   ├── visa/              # Visa Navigator
│   │   │   ├── tracker/           # Admin Tracker
│   │   │   ├── scanner/           # Document Scanner
│   │   │   ├── community/         # Community Q&A
│   │   │   ├── medical/           # Medical Guide
│   │   │   ├── subscription/      # サブスクリプション
│   │   │   ├── profile/           # プロフィール・設定
│   │   │   └── common/            # 共有ウィジェット
│   │   ├── l10n/                  # ARB 多言語ファイル (5 言語)
│   │   └── main.dart
│   ├── test/
│   └── pubspec.yaml
├── backend/
│   ├── app_service/               # FastAPI — CRUD, Webhook, Auth
│   │   ├── main.py
│   │   ├── routers/               # auth, banking, visa, procedures, community, subscriptions, medical, users
│   │   ├── models/
│   │   ├── services/
│   │   └── requirements.txt
│   ├── ai_service/                # FastAPI — AI, RAG, OCR
│   │   ├── main.py
│   │   ├── routers/               # chat, documents
│   │   ├── chat_engine/           # LLM + RAG パイプライン
│   │   ├── rag/                   # Pinecone + LangChain
│   │   ├── moderation/            # AI コンテンツモデレーション
│   │   └── requirements.txt
│   └── shared/                    # 共有ユーティリティ
├── infra/
│   ├── api-gateway/               # Cloudflare Workers スクリプト
│   ├── migrations/                # Alembic (PostgreSQL マイグレーション)
│   └── firebase/                  # Firebase 設定
├── lp/                            # Astro 静的サイト (LP)
├── docs/                          # アーキテクチャ文書
├── scripts/                       # CLI スクリプト（RAG 投入、マスタデータ等）
└── README.md
```

## Module Boundaries（モジュール境界）

### Client ↔ Backend
- Flutter → Cloudflare Workers (API Gateway) → App Service / AI Service
- Flutter → Firebase Auth（直接。ID Token 取得）
- **禁止**: Flutter → Claude API / Cloud Vision API 直接呼び出し（必ず AI Service 経由）

### App Service ↔ AI Service
- App Service: CRUD, 認証プロキシ, Webhook, マスタデータ配信
- AI Service: LLM チャット, RAG 検索, OCR, モデレーション
- 明確に分離。共有ユーティリティは backend/shared/ のみ

### Data Flow
```
Flutter → CF Workers (JWT検証+RateLimit) → App Service → PostgreSQL
                                         → AI Service → Claude API / Pinecone / Cloud Vision
                                                      → PostgreSQL (チャット/スキャン保存)
```

## External Dependencies

| 依存 | 用途 | MVP 月額想定 | フォールバック |
|------|------|-------------|-------------|
| Claude API | LLM (チャット,翻訳,モデレーション) | ¥30,000 | GPT-4o-mini (LangChain 抽象) |
| OpenAI Embedding | RAG 埋め込み | ¥1,000 | Cohere Embed |
| Cloud Vision API | OCR | ¥10,000 | Tesseract (精度低下) |
| Firebase Auth | 認証 | ¥0 (50K MAU 無料) | — |
| PostgreSQL (managed) | RDBMS | ¥5,000 | — |
| Pinecone | Vector DB | ¥3,000 | pgvector |
| Cloudflare (Workers/R2/Pages) | Gateway+Storage+LP | ¥3,000 | — |
| Stripe | 決済 | ¥0 (売上連動) | — |
| Fly.io | Backend Hosting | ¥4,000 | Railway/Render |

## Build & Deploy

- **Flutter App**:
  - `cd app && flutter run` (dev)
  - `flutter build ios --release` / `flutter build appbundle --release` / `flutter build web --release`
- **Backend (App/AI Service)**:
  - `cd backend/app_service && uvicorn main:app --reload` (dev, port 8000)
  - `cd backend/ai_service && uvicorn main:app --reload` (dev, port 8001)
  - 本番: Fly.io (Docker, nrt リージョン)
- **API Gateway**: `cd infra/api-gateway && wrangler deploy`
- **DB Migration**: `cd infra/migrations && alembic upgrade head`
- **LP**: `cd lp && npm run build` → Cloudflare Pages
- **Git ブランチ**: `master`（⚠️ `main` ではない）
- **CI/CD**: GitHub master push → 自動デプロイ（Fly.io + Wrangler + Pages）

## 環境

| 環境 | 用途 | URL |
|------|------|-----|
| development | ローカル | localhost (Flutter), localhost:8000/8001 (API) |
| staging | PR テスト | Fly.io preview + Flutter Web preview |
| production | 本番 | gaijin-life-navi.com (仮) |

## 不可変ルール（Worker 必読 — architecture/DECISIONS.md §4 より）

1. **Free/Premium の制限値は BUSINESS_RULES.md に定義** → Flutter にハードコード禁止
2. **AI チャット日次回数制限はバックエンド enforce** → クライアントは表示のみ
3. **サブスクリプション状態は Stripe Webhook が SSOT** → 直接更新禁止
4. **全 API で user_id 認可チェック必須**（Firebase ID Token の UID 使用）
5. **免責事項**: AI チャット・Visa Navigator・Medical Guide の全レスポンスに必須
6. **PII をログに出力しない**
7. **全 UI テキストは Flutter l10n (ARB) 経由** → ハードコード文字列禁止
8. **AI レスポンスにはソース引用 URL 必須**
9. **多言語 JSONB は 5 言語キー必須**（欠損 → en フォールバック）
10. **drift (ローカル DB) はキャッシュ専用** → SSOT はサーバー DB

### 禁止事項
- ❌ Flutter で金額計算しない（Stripe + バックエンドが管理）
- ❌ Flutter → Claude API / Cloud Vision API 直接呼び出し
- ❌ `deleted_at IS NOT NULL` を API レスポンスに含めない
- ❌ `subscription_tier` をクライアントから直接更新しない
- ❌ Firebase Admin SDK 秘密鍵をクライアントに含めない

## 命名規則
| 対象 | ルール | 例 |
|------|--------|-----|
| DB テーブル | snake_case, 複数形 | `chat_sessions` |
| DB カラム | snake_case | `user_id` |
| API パス | kebab-case, 複数形 | `/api/v1/chat/sessions` |
| Dart 変数 | camelCase | `chatSession` |
| Dart クラス | PascalCase | `ChatSession` |
| Dart ファイル | snake_case | `chat_session.dart` |
| Python 変数/関数 | snake_case | `get_user` |
| Python クラス | PascalCase | `ChatEngine` |
| 環境変数 | SCREAMING_SNAKE | `FIREBASE_PROJECT_ID` |
| i18n (ARB) | camelCase | `welcomeMessage` |

## 参考文書（Architect 産出 — 詳細はこちら）
- `architecture/SYSTEM_DESIGN.md` — 技術選定理由、システム構成図、データフロー
- `architecture/DECISIONS.md` — 確定済み判断、デフォルト値、不可変ルール
- `architecture/DATA_MODEL.md` — DB テーブル・フィールド定義
- `architecture/API_DESIGN.md` — API エンドポイント・I/O 仕様
- `architecture/BUSINESS_RULES.md` — 業務ルール・制限値・計算式
