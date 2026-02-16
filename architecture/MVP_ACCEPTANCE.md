# MVP 受入チェックリスト

> 全項目クリアで MVP 完成。PM はこのチェックリストで最終受入を判断する。

---

## 1. 認証とセキュリティ

- [ ] Email/Password で登録・ログイン・ログアウトが動作する（Firebase Auth）
- [ ] Apple Sign In でログインが動作する（iOS）
- [ ] 未ログインで認証必須画面/API にアクセスできない
- [ ] パスワードリセットメールが送信される
- [ ] Firebase ID Token が全 API リクエストに付与される
- [ ] API Gateway（CF Workers）で無効な JWT が拒否される（401）
- [ ] 他ユーザーのデータにアクセスできない（API 層の user_id チェック）
- [ ] PII がログに出力されていない
- [ ] アカウント削除が動作する（ソフトデリート + Firebase Auth 削除 + Stripe キャンセル）

## 2. 多言語対応

- [ ] 5 言語（EN/ZH/VI/KO/PT）の切り替えが動作する
- [ ] 言語選択が `preferred_language` として保存される
- [ ] 全画面の UI テキストが選択言語で表示される（ハードコード文字列なし）
- [ ] マスターデータ（銀行、ビザ手続き等）が `lang` パラメータで正しい言語を返す
- [ ] 欠損言語は `en` にフォールバックする

## 3. AI Chat Engine（コアバリュー）

- [ ] チャットセッション作成・一覧・削除が動作する
- [ ] メッセージ送信 → AI がストリーミング（SSE）で回答する
- [ ] 回答にソース引用 URL が含まれる（BUSINESS_RULES.md §3）
- [ ] セッションタイトルが初回メッセージ後に自動生成される
- [ ] セッションカテゴリが AI 判定で自動更新される
- [ ] 免責事項が全回答に表示される（BUSINESS_RULES.md §6）
- [ ] Free ティア: 5 回/日の制限が API 層で enforce される
- [ ] 制限超過時に TIER_LIMIT_EXCEEDED エラー + アップグレード導線が表示される
- [ ] 残り回数がチャット画面に表示される
- [ ] ユーザーのプロフィール（国籍、在留資格、地域）が AI コンテキストに反映される

## 4. Banking Navigator

- [ ] 銀行一覧が foreigner_friendly_score 順に表示される
- [ ] 銀行レコメンドのスコア計算が BUSINESS_RULES.md §7 通りに動作する
- [ ] レコメンド結果にマッチ理由と注意点が表示される
- [ ] 個別ガイド: 必要書類チェックリスト + 窓口会話テンプレート + トラブルシューティングが表示される
- [ ] 全コンテンツがユーザーの言語で表示される

## 5. Visa Navigator

- [ ] ユーザーの在留資格に適用可能な手続き一覧が表示される
- [ ] 手続き詳細: ステップガイド + 必要書類（取得方法付き）+ 費用 + 所要期間が表示される
- [ ] 免責事項が全レスポンスに表示される（BUSINESS_RULES.md §6）
- [ ] Premium: パーソナライズ情報が表示される / Free: 基本情報のみ

## 6. Admin Tracker

- [ ] オンボーディング完了時に 5 大手続きが自動追加される（BUSINESS_RULES.md §8）
- [ ] 期限が deadline_rule から正しく計算される
- [ ] 手続きの状態遷移（not_started → in_progress → completed）が動作する
- [ ] 完了時に `completed_at` が記録される
- [ ] 期限超過の手続きがハイライト表示される
- [ ] Free ティア: 3 件の制限が API 層で enforce される
- [ ] 手続き追加・削除が動作する

## 7. Document Scanner

- [ ] カメラ撮影/ギャラリーからのアップロードが動作する（JPEG/PNG/HEIC、最大 10MB）
- [ ] 処理中表示が出る
- [ ] OCR テキスト + 翻訳 + 内容説明が表示される
- [ ] 書類種別が自動判定される
- [ ] スキャン履歴一覧が表示される
- [ ] Free: 3 枚/月、Premium: 30 枚/月、Premium+: 無制限の制限が API 層で enforce される

## 8. Community Q&A

- [ ] チャンネル（言語）+ カテゴリ別の投稿一覧が表示される
- [ ] 新着順/人気順の並び替えが動作する
- [ ] Free ユーザーは閲覧可能、投稿/返信/投票は不可（BUSINESS_RULES.md §2）
- [ ] Premium ユーザーで投稿作成が動作する
- [ ] AI モデレーションが非同期で実行される（BUSINESS_RULES.md §4）
  - [ ] pending: 投稿者本人のみ表示
  - [ ] approved: 全ユーザーに表示
  - [ ] flagged: 投稿者に「レビュー中」表示
  - [ ] rejected: 非表示
- [ ] 返信作成が動作する
- [ ] 投票がトグル動作する（1 ユーザー 1 票）
- [ ] ベストアンサー設定が動作する（投稿者のみ）
- [ ] ベストアンサー設定時に `is_answered = true` に更新される

## 9. Medical Guide

- [ ] 緊急時ガイド（119 の呼び方、必要情報、日本語フレーズ）が表示される
- [ ] 症状翻訳フレーズ集（日本語 + ふりがな + ユーザー言語訳）が表示される
- [ ] カテゴリ（症状/緊急/保険/一般）フィルタが動作する
- [ ] 免責事項が表示される（BUSINESS_RULES.md §6）

## 10. サブスクリプション

- [ ] プラン比較画面が表示される（Free/Premium/Premium+、月額/年額）
- [ ] Stripe Checkout で支払いが完了する
- [ ] 支払い完了後、即座に Premium 機能が開放される
- [ ] `profiles.subscription_tier` が正しく更新される
- [ ] Stripe Webhook が以下のイベントを正しく処理する（BUSINESS_RULES.md §9）:
  - [ ] `checkout.session.completed` → subscription 作成 + tier 更新
  - [ ] `customer.subscription.updated` → status/tier 更新
  - [ ] `customer.subscription.deleted` → tier を free に戻す
  - [ ] `invoice.payment_failed` → status を past_due に
  - [ ] `invoice.payment_succeeded` → status を active に（past_due からの復帰）
- [ ] キャンセルフロー: cancel_at_period_end = true → 期間終了まで Premium 維持

## 11. プロフィール・設定

- [ ] プロフィール表示・編集が動作する
- [ ] 言語変更が即座に反映される
- [ ] アバター画像のアップロードが動作する（R2）

## 12. LP（ランディングページ）

- [ ] 5 言語で LP が表示される
- [ ] App Store / Play Store リンクが正しく設定されている
- [ ] Lighthouse: Performance 90+, SEO 95+
- [ ] OGP メタタグが正しく設定されている

## 13. 非機能要件

- [ ] API レスポンス（CRUD）: p95 < 300ms
- [ ] AI チャット初回トークン: < 2 秒
- [ ] Flutter アプリ起動時間: < 3 秒
- [ ] Rate Limiting: 60 req/min (認証済み), 20 req/min (未認証) が動作する
- [ ] ソフトデリートされたレコードが API レスポンスに含まれない

---

## 閉ループ検証

> 各閉ループを端から端まで手動で実行し、全ステップが通過することを確認する。

- [ ] **閉ループ A**: 言語選択 → 登録 → オンボーディング → ホーム → AI チャット（質問 → ストリーミング回答 + ソース引用 + 免責事項 → フォローアップ質問 → 回答）
- [ ] **閉ループ B**: ホーム → Banking Navigator → 条件入力 → おすすめ銀行表示 → 個別ガイド（必要書類 + 会話テンプレート + トラブルシューティング）
- [ ] **閉ループ C**: オンボーディング完了 → 5 大手続き自動追加 → トラッカーで確認 → 詳細ガイド → 完了マーク → 次の手続き
- [ ] **閉ループ D**: ホーム → Scanner → カメラ撮影 → 処理中 → OCR + 翻訳 + 説明表示
- [ ] **閉ループ E**: ホーム → Community → チャンネル選択 → 投稿閲覧 → 質問投稿(Premium) → AI モデレーション通過 → 返信 → ベストアンサー
- [ ] **閉ループ F**: AI チャット 5 回目完了 → 制限メッセージ → アップグレード導線 → サブスク画面 → Stripe Checkout → 支払い → 即座に無制限に
