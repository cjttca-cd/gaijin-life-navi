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
| 内部列挙・コード | 英語（`premium`, `in_progress`, `banking` 等） |
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

### チャット (chat_sessions)

| フィールド | デフォルト値 | 理由 |
|-----------|------------|------|
| `title` | NULL → AI が最初のメッセージから自動生成 | ChatGPT 方式 |
| `category` | `general` | AI が意図分析後に自動更新 |
| `language` | ユーザーの `preferred_language` | 最初のメッセージの言語で上書き |
| `message_count` | `0` | メッセージ追加時にインクリメント |

### 日次利用 (daily_usage)

| フィールド | デフォルト値 | 理由 |
|-----------|------------|------|
| `chat_count` | `0` | 日次リセット |
| `scan_count` | `0` | 月次リセット（scan は月次制限） |

### 手続き追跡 (user_procedures)

| フィールド | デフォルト値 | 理由 |
|-----------|------------|------|
| `status` | `not_started` | ユーザーが手動で進捗更新 |
| `due_date` | NULL | 手続きの期限ルールから自動提案、ユーザーが確定 |

### コミュニティ投稿 (community_posts)

| フィールド | デフォルト値 | 理由 |
|-----------|------------|------|
| `is_answered` | `false` | ベストアンサー設定で `true` |
| `view_count` | `0` | 閲覧時にインクリメント |
| `upvote_count` | `0` | 投票時に更新 |
| `reply_count` | `0` | 返信追加時にインクリメント |
| `ai_moderation_status` | `pending` | AI チェック完了で `approved` / `flagged` |

### サブスクリプション (subscriptions)

| フィールド | デフォルト値 | 理由 |
|-----------|------------|------|
| `status` | `active` | Stripe Webhook で状態管理 |

## 4. 不可変ルール（Coder が変更してはならない鉄則）

### SSOT 宣言

| ロジック | 最終権威文書 |
|---------|------------|
| DB スキーマ（テーブル・フィールド） | DATA_MODEL.md |
| API 契約（エンドポイント・I/O） | API_DESIGN.md |
| 業務ルール（制限値・状態遷移・計算） | BUSINESS_RULES.md |
| 受入基準（完成の定義） | MVP_ACCEPTANCE.md |

### 鉄則

1. **Free/Premium の制限値はすべて BUSINESS_RULES.md §2 に定義** — クライアント（Flutter）にハードコードしない。API が制限を enforce し、Flutter は API のレスポンスに従う
2. **AI チャットの日次回数制限はバックエンド（AI Service）で enforce** — Flutter は表示のみ。クライアントだけで制限しても API 直叩きで回避可能
3. **サブスクリプション状態は Stripe Webhook が SSOT** — クライアントやバッチジョブから直接更新しない
4. **認可は全 API のアプリケーション層で enforce** — 全ユーザーデータ API で `user_id` チェック必須。Firebase Auth の ID Token から取得した UID を使用
5. **免責事項は AI チャット・Visa Navigator・Medical Guide の全レスポンスに付与** — 省略不可（BUSINESS_RULES.md §6）
6. **PII (個人情報) はログに出力しない** — メール、国籍、在留資格等を console.log や Sentry に送信しない
7. **i18n キーを直接文字列にしない** — 全 UI テキストは Flutter の l10n (ARB) ファイル経由。ハードコード文字列は英語のエラーメッセージのみ許可
8. **AI レスポンスにはソース引用を必須とする** — RAG で取得したドキュメントの出典 URL を必ず添付
9. **多言語コンテンツの JSONB フィールドは 5 言語キーすべてを含む** — 欠損言語は `en` にフォールバック
10. **ローカル DB (drift) はキャッシュ専用** — サーバー DB が SSOT。drift はオフライン表示のためのキャッシュであり、書き込みは常に API 経由

### 禁止事項

- ❌ クライアント（Flutter）で金額計算しない（サブスク金額は Stripe + バックエンドが管理）
- ❌ クライアントから直接 Claude API / Cloud Vision API を呼ばない（すべて AI Service 経由）
- ❌ `deleted_at IS NOT NULL` のレコードを API レスポンスに含めない
- ❌ ユーザーの `subscription_tier` をクライアントから直接更新しない
- ❌ Firebase Admin SDK の秘密鍵をクライアントに含めない（バックエンドのみ使用）

## 5. MVP 段階的割り切り

| # | 割り切り事項 | 理由 | 将来対応 |
|---|------------|------|---------|
| C1 | Community Q&A のリアルタイム通知なし | Realtime の活用は v1.0 | v1.0 でポーリング → WebSocket/FCM に切替 |
| C2 | Admin Panel なし（DB 直接操作 + 管理用スクリプトで代替） | 開発コスト削減 | v1.0 で管理画面を構築 |
| C3 | 画像最適化は R2 アップロード時のリサイズのみ | CDN 画像変換は過剰 | v1.0 で Cloudflare Images 検討 |
| C4 | RAG ナレッジベースは手動更新（CLI スクリプト） | 自動クローリングは複雑 | v1.0 で定期自動更新パイプライン |
| C5 | Analytics は簡易カスタムイベント（Firebase Analytics） | 専用基盤は過剰 | v1.0 で Mixpanel or PostHog |
| C6 | テスト: E2E テストは主要フローのみ、単体テストは計算ロジックに集中 | 全カバレッジは MVP に不要 | v1.0 でカバレッジ目標 70% |
| C7 | Premium+ は Premium と同じ機能 + Doc Scanner 無制限のみ | 1on1 サポートは Phase 2 | v1.5 で差別化機能を追加 |
| C8 | 音声読み上げなし | TTS は v2.0 | v2.0 で AI 音声対話 |
| C9 | オフライン対応は drift によるキャッシュ表示のみ（書き込みは不可） | 完全オフラインは複雑 | v1.5 で部分的オフライン書き込み |
| C10 | Medical Guide は静的コンテンツのみ（病院検索 API 連携なし） | 外部 API 未調査 | v1.0 で JMIP 等の API 連携 |
