# MVP 受入チェックリスト

> 全項目クリアで Phase 0 MVP 完成。PM はこのチェックリストで最終受入を判断する。

---

## 1. 認証とセキュリティ

- [ ] Email/Password で登録・ログイン・ログアウトが動作する（Firebase Auth）
- [ ] Apple Sign In でログインが動作する（iOS）
- [ ] 未ログインで認証必須画面/API にアクセスできない
- [ ] パスワードリセットメールが送信される
- [ ] Firebase ID Token が全 API リクエストに付与される
- [ ] API Gateway で無効な JWT が拒否される（401）
- [ ] 他ユーザーのデータにアクセスできない（API 層の user_id チェック）
- [ ] PII がログに出力されていない
- [ ] アカウント削除が動作する（ソフトデリート + Firebase Auth 削除）

## 2. 多言語対応

- [ ] 5 言語（EN/ZH/VI/KO/PT）の切り替えが動作する
- [ ] 言語選択が `preferred_language` として保存される
- [ ] 全画面の UI テキストが選択言語で表示される（ハードコード文字列なし）
- [ ] AI Chat が入力言語を検出し同言語で応答する（locale ヒントも使用）

## 3. AI Chat（コアバリュー）

### ルーティング

- [ ] Emergency keyword (119, 110, 救急, emergency 等) で即座に svc-medical にルーティングされる
- [ ] LLM 分類で banking/visa/medical/concierge が正しく判定される（精度 80% 以上）
- [ ] domain ヒント指定時に LLM routing がスキップされる
- [ ] LLM 分類失敗時に svc-concierge にフォールバックする

### 回答品質

- [ ] メッセージ送信 → AI が回答を返す（同期レスポンス）
- [ ] 回答にソース引用が含まれる（sources 配列）
- [ ] 免責事項が AI 回答に含まれる（BUSINESS_RULES.md §5）
- [ ] domain フィールドがルーティング先を正しく示す
- [ ] 適切な場合、actions や tracker_items が提案される
- [ ] Session 持続性: 同一ユーザー・同一ドメインで文脈が保持される

### 利用制限

- [ ] Free ティア: 5 回/日の制限が API 層で enforce される（429 USAGE_LIMIT_EXCEEDED）
- [ ] Standard ティア: 300 回/月の制限が API 層で enforce される
- [ ] Premium ティア: 無制限に Chat が利用可能
- [ ] 制限超過時にアップグレード導線が表示される
- [ ] 残り回数が usage フィールドで返却される

### パフォーマンス

- [ ] AI Chat レスポンスタイム: routing 含み < 8 秒（p95）
- [ ] AI Chat レスポンスタイム: domain hint 指定時 < 5 秒（p95）
- [ ] Agent タイムアウト時に 502 AGENT_ERROR が返却される

## 4. Navigator（8 ドメイン）

- [ ] GET /api/v1/navigator/domains → 8 ドメイン返却（4 active + 4 coming_soon）
- [ ] Active ドメイン（banking, visa, medical, concierge）のガイド一覧が表示される
- [ ] ガイド詳細（markdown 全文）が表示される
- [ ] Coming_soon ドメインは「準備中」表示
- [ ] Navigator API は認証不要で公開アクセス可能
- [ ] ガイドコンテンツが knowledge ファイルから正しく読み込まれる

## 5. Emergency ガイド

- [ ] GET /api/v1/emergency → 緊急連絡先 (110, 119, #7119 等) が返却される
- [ ] 救急ガイドコンテンツ（svc-medical/knowledge/emergency.md）が表示される
- [ ] 認証不要でアクセス可能
- [ ] 免責事項が表示される

## 6. Knowledge 品質

- [ ] svc-banking: 6 knowledge files が配置され、memory_search で検索可能
- [ ] svc-visa: 6 knowledge files が配置され、memory_search で検索可能
- [ ] svc-medical: 7 knowledge files が配置され、memory_search で検索可能
- [ ] svc-concierge: 5 knowledge files が配置され、memory_search で検索可能
- [ ] 各 agent の knowledge ファイルに正確な情報が含まれる（公式ソース準拠）
- [ ] memory_search が多言語クエリ（日中英）で関連情報を取得できる

## 7. Agent 分離とセキュリティ

- [ ] svc-* agent に許可ツール（web_search, web_fetch, read, memory_search, memory_get）のみ使用可能
- [ ] exec, write, edit, browser, message 等の禁止ツールが使用不可
- [ ] 各 agent の knowledge/ は他 agent から参照不可（workspace 分離）
- [ ] Service agent と開発用 agent (main, pm 等) の workspace が相互不可視
- [ ] Session ID にコロンが含まれない（`app_{uid}_{domain}` 形式）

## 8. サブスクリプション

- [ ] プラン比較画面が表示される（Free/Standard/Premium + 従量チャージ）
- [ ] Apple IAP / Google Play Billing で購入が完了する（テスト環境）
- [ ] 購入完了後、即座にアップグレード後の機能が開放される
- [ ] `profiles.subscription_tier` が正しく更新される
- [ ] キャンセルフロー: 期間終了まで現ティアを維持

## 9. プロフィール・設定

- [ ] プロフィール表示・編集が動作する
- [ ] 言語変更が即座に反映される
- [ ] オンボーディングが完了し、onboarding_completed が true になる

## 10. 非機能要件

- [ ] API レスポンス（CRUD）: p95 < 300ms
- [ ] AI Chat レスポンス: p95 < 8 秒（routing 含み）
- [ ] Flutter アプリ起動時間: < 3 秒
- [ ] Rate Limiting: 60 req/min (認証済み), 20 req/min (未認証) が動作する
- [ ] ソフトデリートされたレコードが API レスポンスに含まれない
- [ ] 本番環境で OpenClaw Gateway が安定稼働する

## 11. データ就緒（Data Readiness）

> ソフトウェアが動いてもデータが空なら MVP 未完成。
> strategy/product-spec.md §8 の Data Readiness Definition に基づく。

### ナレッジベース投入基準

| Agent | 必要ファイル数 | 必要コンテンツ | 検証方法 |
|-------|-------------|-------------|---------|
| svc-banking | 6 files | 5大銀行比較、口座開設手順、送金方法、ATM、ネットバンキング、FAQ | knowledge/ に 6 ファイル配置確認 |
| svc-visa | 6 files | 在留更新、資格変更、永住、再入国、資格外活動、家族滞在 | knowledge/ に 6 ファイル配置確認 |
| svc-medical | 7 files | 診療科ガイド、保険制度、緊急対応、受診フレーズ、薬局、健診、メンタルヘルス | knowledge/ に 7 ファイル配置確認 |
| svc-concierge | 5 files | 来日直後チェックリスト、生活基盤、FAQ、地域情報、ルーティングルール | knowledge/ に 5 ファイル配置確認 |
| **合計** | **~24 files** | **~120KB** | |

### 検索精度テスト（memory_search）

- [ ] 各ドメインの代表的な質問 5 問以上に対し、`memory_search` が関連 snippet を返すこと
- [ ] 日本語・英語・中国語の 3 言語クエリで各 agent が関連情報を取得できること（bge-m3 多言語対応の検証）
- [ ] 検索精度テスト: 各 agent に対し「口座開設に必要な書類は？」等の実問を投げ、knowledge ファイルの内容に基づいた回答が返ること

### コンテンツ品質基準

- [ ] 全 knowledge ファイルの情報ソースが公式機関（金融庁、入管庁、厚労省等）に基づくこと
- [ ] 各ファイルに最終更新日と情報ソース URL が含まれること
- [ ] 免責事項が Visa / Medical 関連のファイルに含まれること（BUSINESS_RULES.md §5）
- [ ] Navigator API 経由でガイドコンテンツが正しく表示されること（title + summary + content）

## 12. Observability（計測基盤）

> strategy/business-plan.md §7 で定義された KPI が全て計測可能になっていること。

- [ ] Firebase Analytics SDK が Flutter アプリに正しく初期化されている
- [ ] Firebase Crashlytics SDK が統合され、テストクラッシュが捕捉されている
- [ ] SYSTEM_DESIGN.md §11.2 で定義した全カスタムイベントが Flutter コードに実装されている
- [ ] `chat_message_sent` イベントが Chat 成功時に送信されている（Firebase DebugView で確認）
- [ ] `guide_viewed` イベントが Navigator ガイド閲覧時に送信されている
- [ ] `subscription_started` イベントが購入完了時に送信されている
- [ ] `usage_limit_reached` イベントが制限到達時に送信されている
- [ ] Firebase Console でイベントストリームが閲覧可能（最低限のダッシュボード）
- [ ] API Gateway のログに Agent 呼出し時間・トークン消費量が記録されている

---

## 閉ループ検証

> 各閉ループを端から端まで手動で実行し、全ステップが通過することを確認する。

- [ ] **閉ループ A**: 言語選択 → 登録 → オンボーディング → ホーム → AI Chat（質問 → 回答 + ソース引用 + 免責事項 → フォローアップ質問 → 回答）
- [ ] **閉ループ B**: ホーム → Navigator → ドメイン選択 (Banking) → ガイド一覧 → ガイド詳細 → 「AI に質問する」→ Chat 画面で詳細質問
- [ ] **閉ループ C**: Emergency タブ → 緊急連絡先確認 → Chat で「119を呼びたい」→ svc-medical が即座に対応手順を回答
- [ ] **閉ループ D**: AI Chat 5回目完了 → 制限メッセージ → アップグレード導線 → サブスク画面 → IAP 購入 → 即座に制限解除
- [ ] **閉ループ E**: ゲスト導線 — アプリ起動（未ログイン）→ Navigator 一覧 → Banking ガイド全文閲覧 → Emergency 確認 → 「AI に質問する」→ 登録促進画面 → 登録 → AI Chat 利用

## Launch Readiness（MVP 完了 → リリース判断。DEV_PHASES §LP 完了後に検証）

- [ ] Production 環境で全閉ループ (A〜E) が跑通する
- [ ] Crash Reporting (Firebase Crashlytics) が動作している（テストクラッシュで確認）
- [ ] Analytics イベントが Production で送信されている（Firebase Console で確認）
- [ ] Privacy Policy / ToS が公開 URL でアクセスできる
- [ ] App Store メタデータが全 5 言語で入力済み
- [ ] Beta Testing で Z が承認している
- [ ] 全 5 言語の Localization QA が完了している（文字切れ・レイアウト崩れなし）

---

## ~~Phase 0 ピボットで削除された受入基準~~

以下の受入基準は Phase 0 ピボットで削除:
- ~~§4: Banking Navigator (専用 UI + レコメンドスコア計算)~~ → Navigator 汎用 UI
- ~~§5: Visa Navigator (専用 UI + パーソナライズ)~~ → Navigator 汎用 UI
- ~~§6: Admin Tracker (CRUD + 自動追加 + 状態遷移)~~ → AI Chat Tracker 提案
- ~~§7: Document Scanner (OCR + 翻訳 + 説明)~~ → Phase 1 (AI Chat 画像入力)
- ~~§8: Community Q&A (投稿 + 返信 + 投票 + モデレーション)~~ → 削除
- ~~§9: Medical Guide (専用 UI + フレーズ集)~~ → Navigator + Emergency
- ~~§10: サブスクリプション (Stripe Checkout + Webhook)~~ → Apple IAP / Google Play Billing
- ~~§12: LP (ランディングページ)~~ → Phase 0 スコープ外
- ~~SSE ストリーミング~~ → Phase 1

---

## 変更履歴

- 2026-02-16: 初版作成
- 2026-02-17: Phase 0 アーキテクチャピボット反映（OC Runtime / memory_search / LLM routing / 課金体系更新）
- 2026-02-18: strategy/ 連携補完（Data Readiness 受入基準 / Observability 受入基準 / ゲスト導線 閉ループ E / Launch Readiness）
