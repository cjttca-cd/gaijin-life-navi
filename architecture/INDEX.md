# 在日外国人生活ナビ AI — Architecture Index

## 一句話目標

在日外国人が日本での生活手続きを AI と対話しながら解決できる多言語プラットフォームを構築する。

## SSOT 原則

- 各文書は各自の領域における唯一の真実源 (Single Source of Truth)
- 文書間の矛盾 = アーキテクチャバグ → PM/Z に報告
- strategy/ の事業方針には従う（技術で覆さない）
- **PHASE0_DESIGN.md が Phase 0 全体の SSOT** — 本 architecture/ 配下の文書は詳細化・補足

## 分層閲覧順序

### 最小開工セット（PM 初期化 + Coder 骨格構築に十分）

1. INDEX.md（本ファイル）
2. SYSTEM_DESIGN.md（技術全景 — OC Runtime アーキテクチャ）
3. DECISIONS.md（確定事項・デフォルト値・ADR 一覧）
4. DATA_MODEL.md（データ構造 — SQLite Phase 0）

### 機能開発時に追加

5. API_DESIGN.md（API 契約 — POST /api/v1/chat 中心）
6. BUSINESS_RULES.md（業務ロジック — 課金・制限・ルーティング）
7. USER_STORIES.md（要件分解 — AI Chat + Navigator 中心）

### 受入・QA 時に追加

8. DEV_PHASES.md（マイルストーン・検証方法）
9. MVP_ACCEPTANCE.md（受入チェックリスト）

---

## 技術スタック概要（Phase 0）

| レイヤー | 技術 | 備考 |
|---------|------|------|
| Frontend | Flutter + Dart 3 | iOS/Android/Web クロスプラットフォーム |
| API Gateway | Python + FastAPI (port 8000) | Firebase Auth + Agent 呼び出し + 構造化レスポンス |
| Agent Runtime | OpenClaw Gateway (port 18789) | Session 管理、LLM 呼び出し、Tool 制御 |
| LLM | Claude Sonnet 4.5 | 全 svc-* agent のデフォルト |
| Knowledge / RAG | memory_search (bge-m3, Ollama) | workspace/knowledge/*.md を意味検索 |
| Auth | Firebase Auth | Email/Password + Apple Sign In |
| DB | SQLite (aiosqlite) | Phase 0 軽量運用。将来 PostgreSQL 移行可 |
| 決済 | Apple IAP + Google Play Billing | ネイティブ決済 |
| Hosting | VPS (OpenClaw + API Gateway 同居) | 東京リージョン |

---

## 全文書共通の約定

### エラーフォーマット

すべての API エラーは以下の統一形式で返す:

```json
{
  "error": {
    "code": "ERROR_CODE_SNAKE_UPPER",
    "message": "Human-readable message in request language",
    "details": {}
  }
}
```

### 命名規則

| 対象 | ルール | 例 |
|------|--------|-----|
| DB テーブル名 | snake_case, 複数形 | `profiles`, `daily_usage` |
| DB カラム名 | snake_case | `user_id`, `created_at` |
| API パス | kebab-case or snake_case | `/api/v1/chat`, `/api/v1/navigator` |
| API パラメータ | snake_case | `session_id`, `page_size` |
| Dart 変数 | camelCase | `chatSession`, `userId` |
| Dart クラス | PascalCase | `ChatSession`, `UserProfile` |
| Dart ファイル | snake_case | `chat_screen.dart`, `user_profile.dart` |
| Python 変数/関数 | snake_case | `chat_count`, `get_user` |
| Python クラス | PascalCase | `ChatRequest`, `AgentResponse` |
| 環境変数 | SCREAMING_SNAKE_CASE | `FIREBASE_PROJECT_ID`, `DATABASE_URL` |
| OpenClaw Agent ID | kebab-case, svc- prefix | `svc-concierge`, `svc-banking` |
| OpenClaw Session ID | app_{uid}_{domain} | `app_firebase_uid_abc_banking` |
| i18n キー (ARB) | camelCase | `welcomeMessage`, `sendButton` |

### 共通フィールド（全テーブル共通）

| フィールド | 型 | 備考 |
|-----------|------|------|
| `id` | VARCHAR(36) PK | UUID v4 文字列（SQLite 互換） |
| `created_at` | DATETIME | NOT NULL, DEFAULT `CURRENT_TIMESTAMP` |
| `updated_at` | DATETIME | NOT NULL, DEFAULT `CURRENT_TIMESTAMP` |

- `deleted_at` (DATETIME, NULLable) はソフトデリート対象テーブルのみ付与
- ソフトデリート対象: `profiles`
- ソフトデリート非対象（物理削除 or 不変）: `daily_usage`, `subscriptions`, `charge_packs`

### タイムゾーン

- DB: すべて UTC
- API: ISO 8601 形式（`2026-02-16T02:25:00Z`）
- Flutter: ユーザーのローカルタイムゾーンで表示

---

## 範囲境界（Phase 0 で「やらないこと」）

### Phase 0 ピボットで除外されたもの

| # | 除外項目 | 理由 | 将来対応 |
|---|---------|------|---------|
| X1 | ~~Community Q&A~~ | Phase 0 ピボットで削除。AI Chat で代替 | 検討中 |
| X2 | ~~Document Scanner (独立機能)~~ | AI Chat の画像入力に統合 | Phase 1 |
| X3 | ~~AI Service (port 8001)~~ | OpenClaw Runtime に統合。別サービス不要 | — |
| X4 | ~~Pinecone / pgvector~~ | memory_search (bge-m3) で代替 | 必要時に DB 追加 |
| X5 | ~~Cloudflare Workers (Edge)~~ | API Gateway (FastAPI) に統合 | 必要時に導入 |
| X6 | ~~SSE ストリーミング~~ | Phase 0 は同期レスポンス | Phase 1 で検討 |
| X7 | B2B 企業ダッシュボード | Phase 2 スコープ | v1.5 |
| X8 | AI 音声対話 | 技術的複雑性 | v2.0 |
| X9 | プッシュ通知 | MVP では不要 | v1.0 |
| X10 | 管理画面 (Admin Panel) | DB 直接操作 + 管理スクリプトで代替 | v1.0 |

### Phase 0 に含めるが最小実装にするもの

- **Medical Guide**: 緊急連絡先 + 基本ガイド（svc-medical の knowledge/ から提供）
- **Tracker**: AI Chat から自動生成される待办リスト（手動 CRUD + AI 提案）
- **Navigator**: 8 ドメイン中 4 ドメインがアクティブ（banking, visa, medical, concierge）、残り 4 は「coming_soon」

---

## 建議する最初の Epic + Pipeline パターン

### Phase 0 Epic 順序

```
E0: OC Runtime + 4 Service Agents + Knowledge Files
  ↓
E1: API Gateway (FastAPI) + POST /api/v1/chat
  ↓
E2: Navigator / Emergency / Plans / Usage endpoints
  ↓
E3: Flutter 改造 (Chat UI + Navigator UI + API 接続)
  ↓
E4: 結合テスト + デプロイ
```

---

## リスク・待確認事項

| # | 項目 | 状態 | 影響範囲 |
|---|------|------|---------|
| R1 | 行政書士法のリーガルチェック結果 | 未完了 | 免責文言、Visa 情報提供範囲 |
| R2 | OpenClaw agent --json の長期安定性 | テスト済み (3.4s 応答確認) | Agent 呼び出し全体 |
| R3 | Apple IAP 価格点の確定 | 未確定（¥720→¥700 or ¥750） | 課金フロー |
| R4 | bge-m3 の日中英検索精度 | Ollama で稼働中、要品質テスト | knowledge 検索品質 |

---

## 変更履歴

- 2026-02-16: 初版作成
- 2026-02-17: Phase 0 アーキテクチャピボットを反映（OC Runtime / memory_search / LLM routing / 課金体系更新）
