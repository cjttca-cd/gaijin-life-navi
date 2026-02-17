# 確定済み判断とデフォルト値

## 1. 使用方式

- **MVP**: 個人利用（1 ユーザー = 1 アカウント）
- **将来拡張**: B2B 企業プラン（v1.5）で `organization_id` を導入。現時点では DB スキーマに予約しない（YAGNI）。B2B 導入時にマイグレーションで対応。

## 2. インターフェースと言語

| 項目 | 値 |
|------|-----|
| MVP 対応 UI 言語 | 5 言語: `en`, `zh`, `vi`, `ko`, `pt` |
| デフォルト UI 言語 | `en`（端末ロケールで自動選択、未対応言語は英語にフォールバック） |
| AI チャット対応言語 | ユーザーの入力言語を自動検出 → 同言語で応答（14 言語以上対応可能、Claude の多言語能力に依存） |
| 内部列挙・コード | 英語（`standard`, `in_progress`, `banking` 等） |
| 通貨単位 | 日本円 (JPY)。サブスク金額は円建て。 |
| 日付形式 (API) | ISO 8601 (`2026-02-16T02:25:00Z`) |
| 日付表示 (UI) | ロケール依存（Flutter の `intl` パッケージで `DateFormat.yMMMd(locale)` 等を使用） |

## 3. ビジネスデフォルト値

### ユーザー (profiles)

| フィールド | デフォルト値 | 理由 |
|-----------|------------|------|
| `preferred_language` | 端末ロケールから推定 → `en` (フォールバック) | 初回起動で言語選択画面を表示 |
| `subscription_tier` | `free` | 全ユーザーは Free から開始 |
| `onboarding_completed` | `false` | オンボーディング完了で `true` |
| `nationality` | NULL | オンボーディングで入力（任意） |
| `residence_status` | NULL | オンボーディングで入力（任意） |
| `residence_region` | NULL | オンボーディングで入力（任意） |
| `arrival_date` | NULL | オンボーディングで入力（任意） |

### 日次利用 (daily_usage)

| フィールド | デフォルト値 | 理由 |
|-----------|------------|------|
| `chat_count` | `0` | 日次リセット（Free）/ 月次集計（Standard） |

### サブスクリプション (subscriptions)

| フィールド | デフォルト値 | 理由 |
|-----------|------------|------|
| `status` | `active` | IAP 検証 + Server Notification で状態管理 |

## 4. 不可変ルール（Coder が変更してはならない鉄則）

### SSOT 宣言

| ロジック | 最終権威文書 |
|---------|------------|
| 全体アーキテクチャ | PHASE0_DESIGN.md |
| DB スキーマ（テーブル・フィールド） | DATA_MODEL.md |
| API 契約（エンドポイント・I/O） | API_DESIGN.md |
| 業務ルール（制限値・状態遷移・計算） | BUSINESS_RULES.md |
| 受入基準（完成の定義） | MVP_ACCEPTANCE.md |

### 鉄則

1. **Free/Standard/Premium の制限値はすべて BUSINESS_RULES.md §2 に定義** — クライアント（Flutter）にハードコードしない。API が制限を enforce し、Flutter は API のレスポンスに従う
2. **AI チャットの利用回数制限はバックエンド（API Gateway）で enforce** — Flutter は表示のみ。クライアントだけで制限しても API 直叩きで回避可能
3. **サブスクリプション状態は IAP Server Notification / レシート検証が SSOT** — クライアントやバッチジョブから直接更新しない
4. **認可は全 API のアプリケーション層で enforce** — 全ユーザーデータ API で `user_id` チェック必須。Firebase Auth の ID Token から取得した UID を使用
5. **免責事項は AI チャット・Visa 情報・Medical Guide の全レスポンスに付与** — 省略不可（BUSINESS_RULES.md §5）
6. **PII (個人情報) はログに出力しない** — メール、国籍、在留資格等を console.log や Sentry に送信しない
7. **i18n キーを直接文字列にしない** — 全 UI テキストは Flutter の l10n (ARB) ファイル経由。ハードコード文字列は英語のエラーメッセージのみ許可
8. **AI レスポンスにはソース引用を必須とする** — knowledge ファイルの出典 URL を必ず添付
9. **ローカル DB (drift) はキャッシュ専用** — サーバー SQLite が SSOT。drift はオフライン表示のためのキャッシュであり、書き込みは常に API 経由
10. **svc-* Agent には許可ツールのみ使用させる** — `web_search`, `web_fetch`, `read`, `memory_search`, `memory_get` のみ。`exec`, `write`, `edit`, `browser`, `message` 等は禁止

### 禁止事項

- ❌ クライアント（Flutter）で金額計算しない（サブスク金額は IAP + バックエンドが管理）
- ❌ クライアントから直接 Claude API を呼ばない（すべて API Gateway → OpenClaw 経由）
- ❌ `deleted_at IS NOT NULL` のレコードを API レスポンスに含めない
- ❌ ユーザーの `subscription_tier` をクライアントから直接更新しない
- ❌ Firebase Admin SDK の秘密鍵をクライアントに含めない（バックエンドのみ使用）
- ❌ OpenClaw session ID にコロンを使用しない（アンダースコアのみ）
- ❌ svc-* Agent に `exec` / `write` / `edit` ツールを許可しない

## 5. MVP 段階的割り切り

| # | 割り切り事項 | 理由 | 将来対応 |
|---|------------|------|---------|
| C1 | ~~Community Q&A~~ | Phase 0 ピボットで削除。AI Chat で代替 | 検討中 |
| C2 | ~~Document Scanner (独立機能)~~ | AI Chat の画像入力に統合 | Phase 1 |
| C3 | ~~AI Service (port 8001)~~ | OpenClaw Runtime に統合 | — |
| C4 | ~~Pinecone / pgvector~~ | memory_search (bge-m3) で代替 | 必要時に DB 追加 |
| C5 | ~~Cloudflare Workers (Edge)~~ | API Gateway (FastAPI) に統合 | 必要時に導入 |
| C6 | SSE ストリーミングなし | Phase 0 は同期レスポンス | Phase 1 で検討 |
| C7 | Admin Panel なし | DB 直接操作 + 管理スクリプトで代替 | v1.0 |
| C8 | AI 音声対話なし | 技術的複雑性 | v2.0 |
| C9 | プッシュ通知なし | MVP では不要 | v1.0 |
| C10 | LP（ランディングページ）なし | Phase 0 スコープ外 | Phase 1 |
| C11 | SQLite のみ（PostgreSQL なし） | Phase 0 軽量運用 | 必要時に移行 |

---

## 6. ADR (Architecture Decision Records)

### ADR-001: OpenClaw を Production Runtime として使用

- **状態**: 承認（2026-02-17）
- **コンテキスト**: 旧アーキテクチャでは独立した AI Service (FastAPI, port 8001) + LangChain + Pinecone で RAG を構築していた。開発・運用コストが高く、テスト困難。
- **決定**: OpenClaw Gateway を Production Runtime として使用。`openclaw agent --json` CLI を API Gateway から subprocess で呼び出す。
- **理由**:
  - Session 管理、LLM 呼び出し、Tool 制御、memory_search が全て組み込み済み
  - 開発用 Agent (main, pm, coder 等) と同一基盤で動作 → 学習コストゼロ
  - テスト実績: 基本呼出し 3.4 秒、session 持続性確認済み、並行 3 路 12.8 秒で完了
- **トレードオフ**:
  - subprocess 呼び出しのオーバーヘッド（~100ms）
  - OpenClaw の API 安定性に依存
  - SSE ストリーミングは Phase 0 では未対応

### ADR-002: memory_search で pgvector / Pinecone を代替

- **状態**: 承認（2026-02-17）
- **コンテキスト**: 旧アーキテクチャでは Pinecone (Vector DB) + text-embedding-3-small (OpenAI) で RAG を構築。月額 ¥4,000+ のコスト。
- **決定**: OpenClaw の memory_search (bge-m3, Ollama) を使用。各 agent の workspace/knowledge/ に .md ファイルとして知識を配置。
- **理由**:
  - 知識量が小さい（各 agent ~30KB, ~15-20 files）→ memory_search で十分
  - bge-m3 が Ollama でセルフホスト済み → 追加コスト ¥0
  - bge-m3 は多言語対応（日中英）→ ユーザーの言語に関わらず検索可能
  - ファイル編集 = 知識更新 → パイプライン不要
- **トレードオフ**:
  - 大量データには不向き（~100 ファイル超で性能懸念）
  - 精確なデータ検索（税率テーブル等）には DB が必要 → 将来追加

### ADR-003: LLM ベース intent routing

- **状態**: 承認（2026-02-17）
- **コンテキスト**: ユーザーメッセージを適切なドメイン agent にルーティングする必要がある。
- **決定**: 2 層ルーティング方式:
  1. **Emergency keyword 検出**（即座、LLM 不要）: 119/110/救急/emergency/ambulance → svc-medical
  2. **LLM classification**: svc-concierge に分類プロンプトを送信 → banking/visa/medical/concierge の 4 ドメインから判定
- **理由**:
  - 緊急時は keyword で即座にルーティング（レイテンシ最小化）
  - 一般メッセージは LLM が意図を正確に分類（keyword ベースでは多言語対応が困難）
  - Fallback: LLM 失敗時は current_domain or svc-concierge
- **トレードオフ**:
  - routing に ~4 秒追加（LLM 呼び出し）
  - domain hint を指定すれば routing をスキップ可能

### ADR-004: プロダクトピボット（Scanner → Chat 画像、Community → 削除、Navigator 拡張）

- **状態**: 承認（2026-02-17）
- **コンテキスト**: MVP の機能セットを再評価。
- **決定**:
  - **Scanner → AI Chat 画像入力**: 独立機能として維持せず、Chat の画像送信機能に統合（Phase 1）
  - **Community Q&A → 削除**: AI Chat が質問回答を十分にカバー。コミュニティ機能の開発・モデレーションコストが高い
  - **Tracker → AI 自動生成**: AI Chat の回答から自動的に待办項目を生成
  - **Navigator → 8 ドメイン**: 旧 2 ドメイン（Banking, Visa）→ 8 ドメイン（4 active + 4 coming_soon）
- **理由**: AI Chat をコア機能として集中投資。周辺機能は AI Chat から自然に派生。

### ADR-005: 新課金体系（3 ティア + 従量チャージ）

- **状態**: 承認（2026-02-17）
- **コンテキスト**: 旧体系: Free / Premium ¥500 / Premium+ ¥1,500（Stripe）
- **決定**: Free ¥0 (5回/日) / Standard ¥720 (300回/月) / Premium ¥1,360 (無制限) + 従量チャージ (50回 ¥180 / 100回 ¥360)
- **理由**:
  - Standard ティアを追加 → 低価格帯のコンバージョン向上
  - 従量チャージ → サブスク未加入ユーザーへの収益機会
  - Apple IAP + Google Play Billing → ネイティブ決済でコンバージョン向上（Stripe Web のみの問題を解消）
- **Apple IAP 価格点**: 実際の価格は App Store Connect の利用可能な価格点に合わせて微調整（¥720→¥700 or ¥750 等）

### ADR-006: SQLite (Phase 0)

- **状態**: 承認（2026-02-17）
- **コンテキスト**: 旧アーキテクチャでは PostgreSQL (マネージド) を使用。月額 ¥5,000。
- **決定**: Phase 0 は SQLite (aiosqlite) を使用。profiles, daily_usage, subscriptions のみ。
- **理由**:
  - テーブル数が大幅減少（15 → 4）。旧マスターデータテーブルは knowledge files に移行
  - 単一 VPS でのデプロイが容易
  - aiosqlite で SQLAlchemy async 対応済み
  - 将来 PostgreSQL へ移行可能（SQLAlchemy ORM 層で抽象化）
- **トレードオフ**: 同時書き込み性能の制約（MVP の規模では問題なし）

### ADR-007: Session ID 形式

- **状態**: 承認（2026-02-17）
- **決定**: `app_{user_id}_{domain}` 形式。コロン (`:`) は使用不可 → アンダースコア (`_`) で代替。
- **理由**: OpenClaw がコロンを含む session ID を拒否するため。
- **例**: `app_firebase_uid_abc123_banking`, `app_firebase_uid_abc123_visa`

---

## 変更履歴

- 2026-02-16: 初版作成
- 2026-02-17: Phase 0 アーキテクチャピボット反映（OC Runtime / memory_search / LLM routing / 課金体系更新）
