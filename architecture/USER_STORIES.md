# ユーザーストーリーと要件

## 画面一覧（MVP）

| # | 画面名 | パス/ルート | 主な機能 | プラットフォーム |
|---|--------|-----------|---------|---------------|
| S01 | スプラッシュ | `/` (初回) | ロゴ表示 + 言語選択 | Flutter (iOS/Android) |
| S02 | 言語選択 | `/language` | 5言語から選択 | Flutter 全プラットフォーム |
| S03 | ログイン | `/login` | Email/Password ログイン (Firebase Auth) | Flutter 全プラットフォーム |
| S04 | ユーザー登録 | `/register` | Email/Password 登録 (Firebase Auth) | Flutter 全プラットフォーム |
| S05 | パスワードリセット | `/reset-password` | メールでリセットリンク送信 (Firebase Auth) | Flutter 全プラットフォーム |
| S06 | オンボーディング | `/onboarding` | 国籍・在留資格・地域・来日日の入力 | Flutter 全プラットフォーム |
| S07 | ホーム | `/home` | ダッシュボード（クイックアクション、最近のチャット、手続き進捗） | Flutter 全プラットフォーム |
| S08 | AI チャット一覧 | `/chat` | チャットセッション一覧 | Flutter 全プラットフォーム |
| S09 | AI チャット会話 | `/chat/:id` | メッセージ送受信（ストリーミング） | Flutter 全プラットフォーム |
| S10 | Banking Navigator トップ | `/banking` | 銀行一覧 + レコメンド開始 | Flutter 全プラットフォーム |
| S11 | Banking レコメンド結果 | `/banking/recommend` | 条件入力 → おすすめ銀行表示 | Flutter 全プラットフォーム |
| S12 | Banking 個別ガイド | `/banking/:bankId` | 口座開設ステップガイド | Flutter 全プラットフォーム |
| S13 | Visa Navigator トップ | `/visa` | 手続き一覧 | Flutter 全プラットフォーム |
| S14 | Visa 手続き詳細 | `/visa/:procedureId` | ステップ・必要書類・費用 | Flutter 全プラットフォーム |
| S15 | Admin Tracker | `/tracker` | 手続きチェックリスト + 進捗管理 | Flutter 全プラットフォーム |
| S16 | Admin Tracker 詳細 | `/tracker/:id` | 手続き詳細 + ノート | Flutter 全プラットフォーム |
| S17 | Document Scanner | `/scanner` | カメラ起動 / ファイルアップロード | Flutter 全プラットフォーム |
| S18 | スキャン結果 | `/scanner/:id` | OCR テキスト + 翻訳 + 説明 | Flutter 全プラットフォーム |
| S19 | スキャン履歴 | `/scanner/history` | 過去のスキャン一覧 | Flutter 全プラットフォーム |
| S20 | Community 投稿一覧 | `/community` | チャンネル・カテゴリ別投稿一覧 | Flutter 全プラットフォーム |
| S21 | Community 投稿詳細 | `/community/:id` | 投稿本文 + 返信一覧 | Flutter 全プラットフォーム |
| S22 | Community 投稿作成 | `/community/new` | タイトル・本文・カテゴリ入力 | Flutter 全プラットフォーム |
| S23 | Medical Guide | `/medical` | 緊急時ガイド + フレーズ集 | Flutter 全プラットフォーム |
| S24 | プロフィール | `/profile` | プロフィール表示 | Flutter 全プラットフォーム |
| S25 | プロフィール編集 | `/profile/edit` | プロフィール情報変更 | Flutter 全プラットフォーム |
| S26 | 設定 | `/settings` | 言語設定、アカウント管理 | Flutter 全プラットフォーム |
| S27 | サブスクリプション | `/subscription` | プラン比較 + 現在のプラン表示 | Flutter 全プラットフォーム |
| S28 | LP（ランディングページ） | `/` (Web) | プロダクト紹介、App Store リンク | Astro 静的サイト (Web only) |

---

## 重要閉ループ

> 各閉ループが跑通（end-to-end 通過）= MVP 機能完成

### 閉ループ A: 初回利用 → AI チャットで問題解決

```
言語選択 → 登録 → オンボーディング(国籍/在留資格入力)
→ ホーム画面 → 「AIに聞く」 → 質問入力 → AI回答（ストリーミング表示 + ソース引用）
→ フォローアップ質問 → AI回答 → 「役に立った」実感
```

### 閉ループ B: 銀行口座開設ガイド

```
ホーム → Banking Navigator → 条件入力(国籍/在留資格)
→ おすすめ銀行表示（スコア順） → 銀行を選択
→ 口座開設ガイド（必要書類チェックリスト + 窓口会話テンプレート）
→ トラブルシューティング確認
```

### 閉ループ C: 来日直後の手続き管理

```
オンボーディング完了 → 自動で5大手続きがトラッカーに追加
→ トラッカー画面で手続き一覧確認（期限付き）
→ 「住民登録」をタップ → 詳細ガイド（必要書類 + 窓口情報）
→ 完了をマーク → 次の手続きへ
```

### 閉ループ D: 書類スキャン → 内容理解

```
ホーム → Document Scanner → カメラ起動 → 書類撮影
→ アップロード → 処理中表示 → 結果表示
（原文 + 翻訳 + 「これは年金の通知です。○月○日までに...」の説明）
```

### 閉ループ E: Community で質問 → 回答取得

```
ホーム → Community → チャンネル選択(言語) → カテゴリ選択
→ 既存投稿を閲覧 → 「質問する」(Premium) → 投稿作成
→ AI モデレーション通過 → 他ユーザーの返信表示
→ ベストアンサー設定
```

### 閉ループ F: Free → Premium アップグレード

```
AI チャット 5回目の回答後 →「本日の無料枠を使い切りました」表示
→ 「Premium にアップグレード」ボタン → サブスクリプション画面
→ プラン比較 → Stripe Checkout → 支払い完了
→ 即座に AI チャット無制限に
```

---

## ユーザーストーリー

### Epic 0: 認証とオンボーディング

#### US-001: ユーザー登録 [P0] [M]
- **As a** 新規ユーザー
- **I want** メールアドレスとパスワードでアカウントを作成したい
- **So that** アプリの機能を利用できるようになる

**受入条件:**
- Given ユーザーが登録画面にいる
- When 有効なメール + パスワード（8文字以上）を入力して登録ボタンを押す
- Then アカウントが作成され、オンボーディング画面に遷移する
- And メール認証のメールが送信される

**関連:** 画面: S04 | API: `POST /api/v1/auth/register` | ルール: —

#### US-002: ログイン [P0] [S]
- **As a** 既存ユーザー
- **I want** メールとパスワードでログインしたい
- **So that** 自分のデータにアクセスできる

**受入条件:**
- Given ユーザーがログイン画面にいる
- When 正しい認証情報を入力してログインボタンを押す
- Then ホーム画面に遷移する（オンボーディング未完了なら S06 に遷移）

**関連:** 画面: S03 | API: `POST /api/v1/auth/login` | ルール: —

#### US-003: 言語選択 [P0] [S]
- **As a** 初回起動のユーザー
- **I want** アプリの言語を自分の言語に設定したい
- **So that** 理解できる言語で操作できる

**受入条件:**
- Given 初回起動時
- When 5言語 (EN/ZH/VI/KO/PT) から1つを選択する
- Then アプリ全体の UI がその言語に切り替わる

**関連:** 画面: S02 | API: — (ローカル設定) | ルール: DECISIONS.md §2

#### US-004: オンボーディング [P0] [M]
- **As a** 新規登録ユーザー
- **I want** 国籍・在留資格・居住地域・来日日を入力したい
- **So that** パーソナライズされた情報を受け取れる

**受入条件:**
- Given ユーザーがオンボーディング画面にいる
- When 情報を入力して完了ボタンを押す（全フィールド任意、スキップ可能）
- Then プロフィールが更新され、`onboarding_completed = true` になる
- And 来日直後の5大手続きが自動で Admin Tracker に追加される（BUSINESS_RULES.md §8）
- And ホーム画面に遷移する

**関連:** 画面: S06 | API: `POST /api/v1/users/me/onboarding` | ルール: BUSINESS_RULES.md §8

#### US-005: ログアウト [P0] [S]
- **As a** ログイン中のユーザー
- **I want** ログアウトしたい
- **So that** 安全にアプリを終了できる

**受入条件:**
- Given ユーザーが設定画面にいる
- When ログアウトボタンを押す
- Then ログイン画面に遷移し、セッションが無効化される

**関連:** 画面: S26 | API: `POST /api/v1/auth/logout` | ルール: —

#### US-006: パスワードリセット [P1] [S]
- **As a** パスワードを忘れたユーザー
- **I want** メールでパスワードをリセットしたい
- **So that** アカウントに再度アクセスできる

**受入条件:**
- Given ユーザーがログイン画面で「パスワードを忘れた」を押す
- When メールアドレスを入力して送信する
- Then リセットメールが送信される（アカウント有無に関わらず同一メッセージ）

**関連:** 画面: S05 | API: `POST /api/v1/auth/password/reset` | ルール: —

---

### Epic 1: AI Life Concierge

#### US-101: AI チャットセッション作成 [P0] [M]
- **As a** ユーザー
- **I want** AI に日本の生活に関する質問をしたい
- **So that** パーソナライズされた回答を得られる

**受入条件:**
- Given ユーザーがチャット一覧画面にいる
- When 新規チャットボタンを押す
- Then 新しいセッションが作成され、チャット画面に遷移する

**関連:** 画面: S08, S09 | API: `POST /api/v1/ai/chat/sessions` | ルール: —

#### US-102: AI チャットメッセージ送受信 [P0] [L]
- **As a** ユーザー
- **I want** 自分の言語で質問を入力し、AI の回答をストリーミングで受け取りたい
- **So that** リアルタイムに情報を得られる

**受入条件:**
- Given ユーザーがチャット画面にいる
- When メッセージを送信する
- Then AI の回答がストリーミング（文字が流れるように）で表示される
- And 回答にソース引用 (URL) が含まれる
- And 免責事項が表示される
- And セッションタイトルが自動生成される（初回メッセージ時）

**関連:** 画面: S09 | API: `POST /api/v1/ai/chat/sessions/:id/messages` | ルール: BUSINESS_RULES.md §3, §6

#### US-103: AI チャット Free 制限 [P0] [M]
- **As a** Free ユーザー
- **I want** 日次制限に達した時に明確な通知を受け取りたい
- **So that** Premium へのアップグレードを検討できる

**受入条件:**
- Given Free ユーザーが当日5回目のチャットを完了した
- When 6回目のメッセージを送信しようとする
- Then 「本日の無料枠を使い切りました」のメッセージが表示される
- And Premium アップグレードへの導線が表示される
- And 残り回数がチャット画面に表示される（常時）

**関連:** 画面: S09 | API: `POST /api/v1/ai/chat/sessions/:id/messages` → 403 | ルール: BUSINESS_RULES.md §2

#### US-104: チャット履歴一覧 [P1] [S]
- **As a** ユーザー
- **I want** 過去のチャット履歴を確認したい
- **So that** 以前の情報に戻れる

**受入条件:**
- Given ユーザーがチャット一覧画面にいる
- When 画面を表示する
- Then セッション一覧がタイトル + カテゴリ + 日時で表示される（新しい順）
- And スクロールで過去のセッションを読み込める（ページネーション）

**関連:** 画面: S08 | API: `GET /api/v1/ai/chat/sessions` | ルール: —

#### US-105: チャットセッション削除 [P1] [S]
- **As a** ユーザー
- **I want** 不要なチャットセッションを削除したい
- **So that** 一覧を整理できる

**受入条件:**
- Given ユーザーがチャット一覧画面にいる
- When セッションをスワイプして削除する
- Then セッションがソフトデリートされ、一覧から消える

**関連:** 画面: S08 | API: `DELETE /api/v1/ai/chat/sessions/:id` | ルール: —

---

### Epic 2: Banking Navigator

#### US-201: 銀行一覧表示 [P0] [M]
- **As a** ユーザー
- **I want** 日本で外国人が開設できる銀行の一覧を見たい
- **So that** 選択肢を把握できる

**受入条件:**
- Given ユーザーが Banking Navigator にいる
- When 画面を表示する
- Then 銀行一覧が外国人対応度スコア順に表示される
- And 各銀行の多言語対応、手数料、ATM 数が表示される

**関連:** 画面: S10 | API: `GET /api/v1/banking/banks` | ルール: —

#### US-202: 銀行レコメンド [P0] [M]
- **As a** ユーザー
- **I want** 自分の状況に合った銀行を推薦してほしい
- **So that** 最適な銀行を選べる

**受入条件:**
- Given ユーザーが Banking Navigator で「おすすめを見る」を押す
- When 条件（国籍、在留資格、優先事項）を入力する（プロフィールから自動入力 + 編集可能）
- Then マッチスコア順に銀行が表示される
- And 各銀行のマッチ理由と注意点が表示される

**関連:** 画面: S11 | API: `POST /api/v1/banking/recommend` | ルール: BUSINESS_RULES.md §7

#### US-203: 銀行口座開設ガイド [P0] [L]
- **As a** ユーザー
- **I want** 選んだ銀行の口座開設手順を詳しく知りたい
- **So that** 迷わず口座を開設できる

**受入条件:**
- Given ユーザーが銀行を選択した
- When 銀行ガイド画面を表示する
- Then 必要書類チェックリスト、手続きステップ、窓口会話テンプレート、トラブルシューティングが表示される
- And 全コンテンツがユーザーの言語で表示される

**関連:** 画面: S12 | API: `GET /api/v1/banking/banks/:bank_id/guide` | ルール: —

---

### Epic 3: Visa Navigator

#### US-301: ビザ手続き一覧 [P0] [M]
- **As a** ユーザー
- **I want** 自分に関連するビザ手続きの一覧を見たい
- **So that** 必要な手続きを把握できる

**受入条件:**
- Given ユーザーが Visa Navigator にいる
- When 画面を表示する
- Then ユーザーの在留資格に適用可能な手続きが表示される
- And 各手続きの複雑度と期限目安が表示される

**関連:** 画面: S13 | API: `GET /api/v1/visa/procedures` | ルール: —

#### US-302: ビザ手続き詳細 [P0] [L]
- **As a** ユーザー
- **I want** ビザ手続きの詳細（手順・必要書類・費用・期限）を知りたい
- **So that** 手続きの準備ができる

**受入条件:**
- Given ユーザーがビザ手続きを選択した
- When 詳細画面を表示する
- Then ステップバイステップのガイド、必要書類リスト（取得方法付き）、費用、所要期間が表示される
- And 免責事項が表示される

**関連:** 画面: S14 | API: `GET /api/v1/visa/procedures/:id` | ルール: BUSINESS_RULES.md §6

---

### Epic 4: Admin Tracker

#### US-401: 手続きチェックリスト表示 [P0] [M]
- **As a** ユーザー
- **I want** やるべき行政手続きの一覧を進捗付きで確認したい
- **So that** 漏れなく手続きを完了できる

**受入条件:**
- Given ユーザーがトラッカー画面にいる
- When 画面を表示する
- Then 追跡中の手続きが進捗状態 (not_started/in_progress/completed) 別に表示される
- And 期限がある手続きには期限が表示される
- And 期限超過の手続きは赤色でハイライト

**関連:** 画面: S15 | API: `GET /api/v1/procedures/my` | ルール: BUSINESS_RULES.md §8

#### US-402: 手続き進捗更新 [P0] [S]
- **As a** ユーザー
- **I want** 手続きの進捗を更新したい
- **So that** 完了した手続きを記録できる

**受入条件:**
- Given ユーザーがトラッカー画面にいる
- When 手続きのステータスを変更する（タップで完了マーク等）
- Then ステータスが更新される
- And 完了時に completed_at が記録される

**関連:** 画面: S15 | API: `PATCH /api/v1/procedures/my/:id` | ルール: BUSINESS_RULES.md §8

#### US-403: 手続き追加 [P1] [S]
- **As a** ユーザー
- **I want** 新しい手続きをトラッカーに追加したい
- **So that** 自分に必要な手続きを追跡できる

**受入条件:**
- Given ユーザーがトラッカー画面で「追加」を押す
- When 手続きテンプレートから選択する
- Then 手続きがトラッカーに追加される
- And Free ユーザーの場合、3件を超えると制限メッセージが表示される

**関連:** 画面: S15 | API: `POST /api/v1/procedures/my` | ルール: BUSINESS_RULES.md §2

---

### Epic 5: Document Scanner

#### US-501: 書類スキャン [P1] [L]
- **As a** ユーザー
- **I want** 日本語の書類を撮影して翻訳と説明を得たい
- **So that** 書類の内容を理解できる

**受入条件:**
- Given ユーザーが Scanner 画面にいる
- When カメラで書類を撮影する（または画像をアップロードする）
- Then 処理中の表示が出る
- And OCR テキスト + 翻訳 + 内容説明が表示される
- And 書類の種類が自動判定される

**関連:** 画面: S17, S18 | API: `POST /api/v1/ai/documents/scan`, `GET /api/v1/ai/documents/:id` | ルール: BUSINESS_RULES.md §5

#### US-502: スキャン履歴 [P1] [S]
- **As a** ユーザー
- **I want** 過去にスキャンした書類の一覧を見たい
- **So that** 以前の翻訳結果を確認できる

**受入条件:**
- Given ユーザーがスキャン履歴画面にいる
- When 画面を表示する
- Then 過去のスキャン一覧がサムネイル + 書類種別 + 日時で表示される

**関連:** 画面: S19 | API: `GET /api/v1/ai/documents` | ルール: —

---

### Epic 6: Community Q&A

#### US-601: 投稿一覧閲覧 [P1] [M]
- **As a** ユーザー
- **I want** 自分の言語チャンネルの投稿を閲覧したい
- **So that** 同じ境遇の人の情報を参考にできる

**受入条件:**
- Given ユーザーが Community 画面にいる
- When チャンネル（言語）とカテゴリを選択する
- Then 投稿一覧が表示される（新着順/人気順で切り替え可能）
- And Free ユーザーでも閲覧は可能

**関連:** 画面: S20 | API: `GET /api/v1/community/posts` | ルール: BUSINESS_RULES.md §2, §4

#### US-602: 投稿作成 [P1] [M]
- **As a** Premium ユーザー
- **I want** コミュニティに質問を投稿したい
- **So that** 他のユーザーからアドバイスをもらえる

**受入条件:**
- Given Premium ユーザーが Community 画面にいる
- When 「投稿する」ボタンを押し、タイトル + 本文 + カテゴリを入力して送信する
- Then 投稿が作成される（AI モデレーション通過後に公開）
- And Free ユーザーが投稿しようとすると Premium アップグレード導線が表示される

**関連:** 画面: S22 | API: `POST /api/v1/community/posts` | ルール: BUSINESS_RULES.md §2, §4

#### US-603: 返信・投票 [P1] [M]
- **As a** Premium ユーザー
- **I want** 投稿に返信し、有用な回答に投票したい
- **So that** コミュニティに貢献できる

**受入条件:**
- Given Premium ユーザーが投稿詳細画面にいる
- When 返信を入力して送信する
- Then 返信が追加される
- When 投稿または返信の投票ボタンを押す
- Then upvote_count が増加する（再度押すと取消）

**関連:** 画面: S21 | API: `POST /api/v1/community/posts/:id/replies`, `POST /api/v1/community/posts/:id/vote` | ルール: BUSINESS_RULES.md §4

---

### Epic 7: サブスクリプション

#### US-701: プラン比較表示 [P0] [S]
- **As a** ユーザー
- **I want** Free と Premium の違いを比較したい
- **So that** アップグレードの判断ができる

**受入条件:**
- Given ユーザーがサブスクリプション画面にいる
- When 画面を表示する
- Then 各プランの機能比較表と料金が表示される
- And 現在のプランがハイライトされる

**関連:** 画面: S27 | API: `GET /api/v1/subscriptions/plans` | ルール: —

#### US-702: Premium 購入 [P0] [L]
- **As a** Free ユーザー
- **I want** Premium に課金したい
- **So that** 全機能を利用できる

**受入条件:**
- Given ユーザーがサブスクリプション画面でプランを選択する
- When 「購入」ボタンを押す
- Then Stripe Checkout 画面に遷移する
- When 支払いを完了する
- Then アプリに戻り、即座に Premium 機能が開放される
- And プロフィールの subscription_tier が premium に更新される

**関連:** 画面: S27 | API: `POST /api/v1/subscriptions/checkout`, Stripe Webhook | ルール: BUSINESS_RULES.md §9

#### US-703: サブスクリプション管理 [P1] [S]
- **As a** Premium ユーザー
- **I want** サブスクリプションの状態確認とキャンセルがしたい
- **So that** 課金を管理できる

**受入条件:**
- Given ユーザーがサブスクリプション画面にいる
- When 現在のプラン情報を表示する
- Then プラン名、次回更新日、キャンセルボタンが表示される
- When キャンセルボタンを押す
- Then 「期間終了まで利用可能」の確認メッセージが表示され、cancel_at_period_end が true になる

**関連:** 画面: S27 | API: `GET /api/v1/subscriptions/me`, `POST /api/v1/subscriptions/cancel` | ルール: BUSINESS_RULES.md §9

---

### Epic 8: Medical Guide (静的)

#### US-801: 緊急時ガイド [P1] [S]
- **As a** ユーザー
- **I want** 日本での緊急時の対処法を知りたい
- **So that** 緊急事態に対応できる

**受入条件:**
- Given ユーザーが Medical Guide 画面にいる
- When 「緊急時」セクションを表示する
- Then 119 の呼び方、必要な情報、日本語フレーズが表示される
- And 免責事項が表示される

**関連:** 画面: S23 | API: `GET /api/v1/medical/emergency-guide` | ルール: BUSINESS_RULES.md §6

#### US-802: 症状翻訳フレーズ集 [P1] [S]
- **As a** ユーザー
- **I want** 病院で使える日本語フレーズを確認したい
- **So that** 医療機関で症状を伝えられる

**受入条件:**
- Given ユーザーが Medical Guide のフレーズ集を表示する
- When カテゴリ (症状/緊急/保険/一般) を選択する
- Then 日本語フレーズ + ふりがな + ユーザー言語訳 が一覧表示される

**関連:** 画面: S23 | API: `GET /api/v1/medical/phrases` | ルール: —

---

### Epic 9: プロフィール・設定

#### US-901: プロフィール編集 [P1] [S]
- **As a** ユーザー
- **I want** 国籍や在留資格等のプロフィールを変更したい
- **So that** パーソナライズの精度を上げられる

**受入条件:**
- Given ユーザーがプロフィール編集画面にいる
- When 情報を変更して保存する
- Then プロフィールが更新される

**関連:** 画面: S25 | API: `PATCH /api/v1/users/me` | ルール: —

#### US-902: 言語変更 [P1] [S]
- **As a** ユーザー
- **I want** アプリの表示言語を変更したい
- **So that** 他の言語で利用できる

**受入条件:**
- Given ユーザーが設定画面にいる
- When 言語を変更する
- Then アプリ全体の UI が即座に切り替わる
- And preferred_language がサーバーに保存される

**関連:** 画面: S26 | API: `PATCH /api/v1/users/me` | ルール: —

#### US-903: アカウント削除 [P2] [M]
- **As a** ユーザー
- **I want** アカウントを削除したい
- **So that** 個人情報が消去される

**受入条件:**
- Given ユーザーが設定画面にいる
- When 「アカウント削除」を押し、確認ダイアログで承認する
- Then アカウントがソフトデリートされ、ログイン画面に遷移する
- And 有料サブスクリプションがある場合は自動キャンセルされる

**関連:** 画面: S26 | API: `DELETE /api/v1/users/me` | ルール: —

---

### Epic 10: LP（Web）

#### US-1001: ランディングページ [P1] [M]
- **As a** 潜在ユーザー
- **I want** アプリの概要と価値を理解したい
- **So that** ダウンロード・登録を判断できる

**受入条件:**
- Given Web ブラウザで LP にアクセスする
- When ページを表示する
- Then プロダクト説明、主要機能紹介、プラン比較、App Store/Play Store リンクが表示される
- And 5言語で閲覧可能（URL パス `/en`, `/zh`, `/vi`, `/ko`, `/pt`）
- And SEO 最適化（meta tags, OGP, structured data）

**関連:** 画面: S28 | API: — (SSG) | ルール: —
