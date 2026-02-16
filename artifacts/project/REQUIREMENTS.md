# REQUIREMENTS — gaijin-life-navi

## Must-have（必須）

### 機能要件（P0 ストーリー）

#### Epic 0: 認証・オンボーディング
- [ ] US-001: Email/Password ユーザー登録（Firebase Auth）
- [ ] US-002: ログイン（Firebase Auth → JWT）
- [ ] US-003: 言語選択（5 言語: EN/ZH/VI/KO/PT）
- [ ] US-004: オンボーディング（国籍・在留資格・地域・来日日 → 5 大手続き自動追加）
- [ ] US-005: ログアウト

#### Epic 1: AI Life Concierge（コアバリュー）
- [ ] US-101: チャットセッション作成
- [ ] US-102: メッセージ送受信（SSE ストリーミング + ソース引用 + 免責事項）
- [ ] US-103: Free 日次制限（5 回/日）+ Premium アップグレード導線

#### Epic 2: Banking Navigator
- [ ] US-201: 銀行一覧（外国人対応度スコア順）
- [ ] US-202: 銀行レコメンド（条件ベーススコアリング）
- [ ] US-203: 口座開設ガイド（必要書類 + 窓口会話テンプレート + トラブルシューティング）

#### Epic 3: Visa Navigator
- [ ] US-301: ビザ手続き一覧（在留資格フィルタ）
- [ ] US-302: 手続き詳細（ステップガイド + 必要書類 + 費用 + 免責事項）

#### Epic 4: Admin Tracker
- [ ] US-401: 手続きチェックリスト（進捗状態 + 期限表示）
- [ ] US-402: 進捗更新（ステータス遷移: not_started → in_progress → completed）

#### Epic 7: サブスクリプション
- [ ] US-701: プラン比較表示
- [ ] US-702: Stripe Checkout → Premium 即時開放

### 技術要件
- [ ] Flutter (Dart 3) で iOS/Android/Web 単一コードベース
- [ ] Firebase Auth（Email/Password + Apple Sign In）
- [ ] FastAPI (Python) バックエンド（App Service + AI Service 分離）
- [ ] Cloudflare Workers API Gateway（JWT 検証 + Rate Limiting）
- [ ] PostgreSQL（マネージド）+ Pinecone（RAG 用 Vector DB）
- [ ] Claude API (Sonnet) + LangChain (RAG)
- [ ] Flutter l10n (ARB) で 5 言語 UI 多言語対応
- [ ] Monorepo 構成（app/ + backend/ + infra/ + lp/）

### パフォーマンス
- [ ] API CRUD レスポンス: p95 < 300ms
- [ ] AI チャット初回トークン: < 2 秒
- [ ] アプリ起動時間 (Cold Start): < 3 秒
- [ ] 可用性: 99.5%（MVP）

### セキュリティ
- [ ] 通信: TLS 1.3
- [ ] 全 API で user_id 認可チェック
- [ ] PII はログに出力しない
- [ ] アカウント削除機能（GDPR/個人情報保護法）

## Nice-to-have（あると良い）

#### Epic 1 追加
- [ ] US-104: チャット履歴一覧（ページネーション）
- [ ] US-105: チャットセッション削除

#### Epic 4 追加
- [ ] US-403: 手続き追加（テンプレートから選択 + Free 3 件制限）

#### Epic 5: Document Scanner
- [ ] US-501: 書類スキャン（カメラ/アップロード → OCR → 翻訳 → 説明）
- [ ] US-502: スキャン履歴一覧

#### Epic 6: Community Q&A
- [ ] US-601: 投稿一覧（チャンネル + カテゴリフィルタ）
- [ ] US-602: 投稿作成（Premium 限定 + AI モデレーション）
- [ ] US-603: 返信・投票・ベストアンサー

#### Epic 7 追加
- [ ] US-703: サブスクリプション管理（状態確認 + キャンセル）

#### Epic 8: Medical Guide
- [ ] US-801: 緊急時ガイド（119 の呼び方 + 免責事項）
- [ ] US-802: 症状翻訳フレーズ集（日本語 + ふりがな + ユーザー言語）

#### Epic 9: プロフィール・設定
- [ ] US-901: プロフィール編集
- [ ] US-902: 言語変更
- [ ] US-903: アカウント削除

#### Epic 10: LP
- [ ] US-1001: ランディングページ（Astro + 5 言語 + SEO）

## Out-of-scope（MVP 除外）
- B2B 企業ダッシュボード
- Premium+ 1 対 1 チャットサポート
- AI 音声対話
- 住居検索・求人連携 API
- マイナンバー連携
- プッシュ通知
- 完全オフライン対応
- A/B テスト基盤
- 管理画面（Admin Panel）
- 5 言語以外（タガログ語、インドネシア語、ネパール語等は v1.0）

## Constraints（制約）
- **月額ランニング**: ¥55,000 以内（strategy/product-spec.md §5.4）
- **技術スタック**: Architect 確定済み — Flutter + FastAPI + Firebase Auth + Claude API（変更は Z 承認必須）
- **免責事項**: AI チャット・Visa Navigator・Medical Guide の全レスポンスに必須表示
- **制限値**: すべて BUSINESS_RULES.md に定義、クライアントにハードコード禁止
- **ソース引用**: AI レスポンスには RAG 取得ドキュメントの出典 URL 必須
- **i18n**: 全 UI テキストは ARB ファイル経由、ハードコード文字列禁止
- **マイルストーン順守**: M0→M1→M2→M3→M4 の順番通り（スキップ禁止）

## 参考文書
- architecture/USER_STORIES.md — 全ユーザーストーリー詳細
- architecture/BUSINESS_RULES.md — ビジネスルール・制限値
- architecture/DECISIONS.md — 確定済み判断・デフォルト値
