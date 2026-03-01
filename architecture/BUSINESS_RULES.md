# 業務ルールと検証

## 1. 共通ルール

### 認証要件

- `/api/v1/health`, `/api/v1/auth/register`, `/api/v1/emergency`, `/api/v1/navigator/*`, `/api/v1/subscription/plans` 以外の全 API エンドポイントは認証必須
- JWT は Firebase Auth が発行（ID Token）。有効期限 1 時間。Flutter クライアントは `firebase_auth` パッケージで自動リフレッシュを行う
- API Gateway (FastAPI) で Firebase Admin SDK を使用して JWT 検証 → 無効な場合は 401 を即返却

### データ隔離

- 全ユーザーデータはアプリケーション層（FastAPI）で `user_id = current_firebase_uid` を検証して制限
- ナビゲーターコンテンツは knowledge/ と guides/ に分離（詳細: `docs/GUIDE_ACCESS_DESIGN.md` v2）:
  - **knowledge/** — Agent 専用（経験・判断ロジック・暗黙知）。Navigator API には公開しない
  - **guides/** — ユーザー向け指南。Navigator API で配信（統一品質：全 Guide = 完整 how-to）:
    - `access: free` → 全ユーザーに全文提供（8篇、話題熱度で選定、全6ドメインをカバー）
    - `access: registered` → Free/Standard/Premium に全文提供、Guest には excerpt+登録CTA（37篇）
- Agent 間の workspace は完全分離 → 他 agent の知識は見えない
- 開発用 Agent と Service Agent は完全に分離された名前空間で動作

### ソフトデリート

- 対象テーブル: profiles
- `deleted_at IS NOT NULL` のレコードは全 API レスポンスから除外
- 物理削除は行わない（法的保持要件。GDPR データ削除要求時のみ物理削除を実施）

---

## 2. サブスクリプションティア制限

### ⚠️ 本セクションが制限値の SSOT — フロントもバックエンドもこの値を参照

| 機能 | 🔓 ゲスト | 🆓 Free (¥0) | ⭐ Standard (¥720/月) | 💎 Premium (¥1,360/月) |
|------|:---------:|:------------:|:--------------------:|:---------------------:|
| Medical Emergency Guide | ✅ | ✅ | ✅ | ✅ |
| Navigator 一覧・概要閲覧（全ドメイン） | ✅ | ✅ | ✅ | ✅ |
| Free 指南（8篇、全文） | ✅ | ✅ | ✅ | ✅ |
| Registered 指南（37篇） | excerpt+登録CTA | ✅ 全文 | ✅ 全文 | ✅ 全文 |
| AI Chat 深度級 | — | **5回/lifetime** | **300回/月** | **無制限** |
| AI Chat 概要級 | **5回/lifetime** | **3回/lifetime** | — | — |
| Re-engagement（30日毎1回深度級） | — | ✅（全回数消費後） | — | — |
| 従量チャージ（深度級） | — | ✅ | ✅ | — |
| Auto Tracker（AI 提案） | ❌ | ✅ | ✅ | ✅ |
| 広告 | あり | あり | なし | なし |

> **Guide 品質**: 全 Guide 統一品質（完整 how-to、1000-2000字）。Free/Registered の差異は可見性のみ。
> **Free 消費順序**: 注册後、先に深度級5回を消費 → 使い切ったら概要級3回に切替。
> **AI Chat 分層設計の詳細**: `tasks/ai-chat-tier-design.md`（2026-03-01 Z 承認済み）

### 従量チャージ（都度購入）

| パック | 価格 | 単価 |
|--------|------|------|
| 100回 | ¥360 | ¥3.6/回 |
| 50回 | ¥180 | ¥3.6/回 |

従量チャージはサブスク制限を超えた後に消費される。サブスク回数が残っている場合はサブスク側から消費。

### 制限チェックのフロー

```
リクエスト受信 (POST /api/v1/chat)
  ↓
JWT からユーザー ID 取得
  ↓
profiles.subscription_tier 取得
  ↓
tier == 'guest' の場合:
  └── AI Chat: lifetime chat_count >= 5 → 429 USAGE_LIMIT_EXCEEDED
  └── AI 回答深度: 概要級のみ + 登録案内
tier == 'free' の場合:
  └── 深度級: lifetime deep_count >= 5 → 概要級にフォールバック
  └── 概要級: lifetime summary_count >= 3 → 429 USAGE_LIMIT_EXCEEDED
  └── Re-engagement: 全回数消費後、30日毎に深度級1回を付与
  └── AI 回答深度: 深度級残 → 深度級 / 深度級使い切り → 概要級 + アップグレード案内
tier == 'standard' の場合:
  └── AI Chat: 月間合計 chat_count >= 300 → 429 USAGE_LIMIT_EXCEEDED（従量チャージで継続可）
  └── AI 回答深度: 深度級
tier == 'premium' の場合:
  └── 制限なし
  └── AI 回答深度: 深度級
```

### カウント管理

- **Guest (lifetime)**: `daily_usage` テーブルの全行合計。リセットなし（概要級5回で終了）
- **Free (lifetime)**: 深度級5回 + 概要級3回 = 合計8回。`daily_usage` に `deep_count` と `summary_count` を分離追跡。全消費後、30日毎に深度級1回を付与（re-engagement）
- **Standard (月次)**: `daily_usage` テーブルの月初〜当日の `chat_count` を SUM で集計。月変わりで自動リセット（バッチジョブ不要）。全回答 = 深度級
- **Premium (無制限)**: カウントは情報提供目的のみ。全回答 = 深度級

### 注册時の必須 Profile（⚠️ 新規要件）

登録フローで以下3フィールドを必須入力とする:

| フィールド | 必須 | 用途 |
|-----------|:----:|------|
| 国籍 (nationality) | ✅ | 租税条約・ビザ要件・銀行推薦 |
| 在留資格 (residence_status) | ✅ | 就労制限・税務フロー・行政手続き分岐 |
| 居住地域 (residence_region) | ✅ | 地域差異・窓口案内 |

これにより深度級の初回体験で Profile 個性化が確実に機能する。

### 制限超過時の API レスポンス

```json
{
  "error": {
    "code": "USAGE_LIMIT_EXCEEDED",
    "message": "Chat limit reached for your plan. Used 10/10 chats.",
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

---

### 概要級 / 深度級 定義（⚠️ AI Chat の回答品質を制御する SSOT）

> 詳細: `tasks/ai-chat-tier-design.md`

**概要級**（Guest + Free の残り回数）:
- ✅ 完整操作手順 + 材料リスト + 注意事項（Guide と同等レベル）
- ✅ LLM旧知識修正（保険証→マイナ保険証、103万→123万 等）
- ✅ 対話式答疑（追問/明確化 — 静的 Guide にはない対話価値）
- ❌ Profile 個性化なし（国籍/ビザ/地域を使わない）
- ❌ AI-only 内容なし（具体機関評価、判断決策樹、地域差異、web_search、跨域連動、🔒情報）
- 回答末尾に深度級への導線を付与:「あなたの状況に合わせた具体的なおすすめは深度級で」

**深度級**（Free 先行5回 + Standard/Premium + 従量チャージ）:
- ✅ 概要級の全機能
- ✅ Profile 個性化 → 「XX国籍XXビザ住XX → 推薦...」
- ✅ 具体機関名+評価 → 「ゆうちょは電話番号不要」
- ✅ 判断決策樹 → 「中国籍留学生 → 租税条約全額免税」
- ✅ web_search → リアルタイム金額・制度変更
- ✅ 跨域連動 → 「口座開設と携帯を同時解決」
- ✅ 🔒 AI-only 情報（状況に応じて）

---

## 3. AI チャットルール

### Agent ルーティング

2 層ルーティング方式:

1. **Emergency keyword 検出**（即座、LLM 不要）:
   - パターン: `119`, `110`, `救急`, `emergency`, `ambulance`, `緊急通報`, `救命`, `急救`, `救护车`
   - → svc-medical にルーティング

2. **LLM 軽量分類**（~3 秒）:
   - API Gateway が LLM に分類プロンプトを送信（旧 svc-concierge の分類機能を軽量ルーターに移行）
   - 6 ドメインから 1 つを判定: `finance`, `tax`, `visa`, `medical`, `life`, `legal`
   - Fallback: LLM 失敗時は `current_domain` or `svc-life`

3. **Domain hint**: クライアントが `domain` パラメータを指定した場合、LLM routing をスキップ

### Session 管理

- Session ID: `app_{user_id}_{domain}` 形式
- 同一ユーザー・同一ドメインの会話は同じ session で継続
- OpenClaw が prompt cache で会話履歴を保持

### Agent Tool 制限

全 svc-* agent に適用:
- ✅ 許可: `web_search`, `web_fetch`, `read`, `memory_search`, `memory_get`
- ❌ 禁止: `exec`, `write`, `edit`, `browser`, `message`, その他すべて

### レスポンス構造化

Agent のテキストレスポンスから以下のブロックを解析:
```
[SOURCES]
- title: Source Title | url: https://...
[/SOURCES]

[ACTIONS]
- type: checklist | items: item1, item2, item3
[/ACTIONS]

[TRACKER]
- type: deadline | title: Task Name | date: 2026-04-01
[/TRACKER]
```

### トークン制限

| 項目 | 値 |
|------|-----|
| ユーザーメッセージ最大長 | 4,000 文字 |
| Agent タイムアウト | CLI 60 秒 + subprocess 75 秒 |
| LLM classification タイムアウト | 15 秒 |
| LLM モデル | Claude Sonnet 4.5（全 svc-* agent） |
| Thinking | low（defaults から継承） |

---

## 4. Navigator ルール

### ドメイン一覧

| ドメイン | ラベル | ステータス | Agent |
|---------|--------|----------|-------|
| finance | Finance & Banking | 🟢 active | svc-finance |
| tax | Tax & Pension | 🟢 active | svc-tax |
| visa | Visa & Immigration | 🟢 active | svc-visa |
| medical | Medical & Health | 🟢 active | svc-medical |
| life | Life & Daily Living | 🟢 active | svc-life |
| legal | Legal & Rights | 🟢 active | svc-legal |

### ガイドコンテンツの管理

- ガイドは各 agent の `workspace/guides/*.md` に配置（ユーザー向け指南）
- knowledge/ は Agent 専用（経験則・判断ロジック）。Navigator API には公開しない
- Navigator API は guides/ ディレクトリを直接走査して提供
- .md ファイルの先頭 `# heading` がタイトル、最初の段落がサマリー

---

## 5. 免責事項ルール

### ⚠️ 以下の免責事項は省略不可 — 該当する全レスポンスに含めること

#### AI チャット（全レスポンス）

Agent の system prompt に免責事項生成を指示:
```
This information is for general guidance only and does not constitute legal advice.
Please verify with relevant authorities for the most up-to-date information.
```
> ユーザーの言語で動的に出力

#### Visa 関連情報

```
IMPORTANT: This is general information about visa procedures and does not
constitute immigration advice. Immigration laws and procedures may change.
Always consult the Immigration Services Agency or a qualified immigration
lawyer (行政書士) for your specific situation.
```

#### Medical Guide

```
This guide provides general health information and is not a substitute
for professional medical advice. In an emergency, call 119 immediately.
```

### 免責事項の実装方法

- AI チャット: 各 agent の AGENTS.md に免責事項生成を指示
- Navigator ガイド: guides ファイルの末尾に免責事項を含める
- フロントエンド: disclaimer 系テキストが含まれる場合に専用コンポーネントで表示

---

## 6. サブスクリプションルール

### 決済方式

| プラットフォーム | 決済 | 検証方式 |
|--------------|------|---------|
| iOS | Apple IAP | App Store Server API / レシート検証 |
| Android | Google Play Billing | Play Developer API / purchase token 検証 |

### IAP 購入フロー

```
Flutter: StoreKit / Google Billing Library で購入
  ↓
Flutter → API Gateway: POST /api/v1/subscription/purchase (receipt/token)
  ↓
API Gateway → App Store / Play Store API: レシート検証
  ↓
検証成功 → subscriptions テーブル更新 + profiles.subscription_tier 更新
  ↓
API Gateway → Flutter: subscription 状態返却
```

### Apple IAP 価格調整

実際の価格は App Store Connect の利用可能な価格点に合わせて微調整:
- Standard ¥720 → ¥700 or ¥750（要確認）
- Premium ¥1,360 → ¥1,400（要確認）

### Tier 変更時の動作

- Free → Standard/Premium: 即座に機能を開放
- Standard → Premium: 即座にアップグレード
- Premium → Standard: ダウングレードは次回更新時に反映
- Standard/Premium → Free (キャンセル): 期間終了まで現ティアを維持
- 従量チャージ: サブスク制限消費後に自動的に使用開始

---

## 7. Rate Limiting ルール

| 対象 | 制限 | ウィンドウ |
|------|------|-----------|
| 全 API (認証済み) | 60 req/min | Sliding window |
| 全 API (未認証) | 20 req/min | Sliding window |
| AI Chat | ティアによる (§2) | 日次 or 月次 |
| Auth (register) | 5 req/min per IP | Fixed window |

超過時: 429 `RATE_LIMITED` を返却、`Retry-After` ヘッダーを付与。

---

## 8. 士業独占業務の法的制約（全 Agent 必須）

### ⚠️ 以下の制約は全 svc-* Agent の AGENTS.md に明記し、厳守すること

#### 8.1 Agent 別リスクと法的根拠

| Agent | リスク | 根拠法 | 許可される範囲 | 禁止される範囲 |
|-------|:------:|--------|--------------|--------------|
| svc-tax | **🔴 高** | 税理士法52条（無償でも違法） | 公開制度の説明、該当判断（「あなたは確定申告が必要」）、書類記入案内 | 個別税額計算、節税戦略の提案、税務代理 |
| svc-legal | **🔴 高** | 弁護士法72条 | 制度説明、事例紹介（「類似ケースでは一般的にこうする」）、権利案内、専門家誘導 | 個別法律事件の法的判断・助言 |
| svc-visa | **🟡 中** | 行政書士法19条 | 手続き説明、必要書類案内 | 書類作成代行 |
| svc-finance | **🟡 低〜中** | 金商法 | 制度説明、商品比較 | 個別投資助言 |
| svc-medical | **🟡 低** | 医師法17条 | 一般健康情報 | 診断、処方 |
| svc-life | **🟢 低** | — | ほぼ制約なし | — |

#### 8.2 共通ルール（全 Agent に適用）

**合法（全 agent 共通で OK）:**
- ✅ 公開情報の適用判断 —「あなたの状況は確定申告が必要なケースに該当します」
- ✅ 公開書類の記入方法の平易な解説 —「この欄は源泉徴収票のこの金額を転記します」
- ✅ 制度の仕組みの説明 — 難しい公式文書を外国人にわかる言葉に
- ✅ 手続きフロー・期限・届出先の案内
- ✅ 必要書類のリスト案内
- ✅ 「類似ケースでは一般的にこうする」という事例紹介

**違法（絶対 NG）:**
- ❌ 個別の税額計算・節税戦略の提案（税理士法52条、無償でも違法）
- ❌ 個別法律事件の法的判断・助言（弁護士法72条）
- ❌ 申請書類の作成代行（行政書士法19条）
- ❌ 医療の診断・処方（医師法17条）
- ❌ 個別銘柄の投資推奨（金商法）

#### 8.3 判例・先例

- **国税庁チャットボット「ふたば」**: 確定申告に関する一般的な Q&A を提供 → 公開情報に基づく制度説明・手続き案内・該当判断は適法の証左
- **法務省ガイドライン（令和5年8月）**: AI 契約書レビューについて、一般的な場面を想定した支援で、個別事案の法的処理でなければ弁護士法72条に違反しない

#### 8.4 svc-tax 特有の制約と対策

svc-tax は最もリスクが高い（税理士法52条は無償でも違法）。以下を厳守:

- 全回答に「税理士への相談を推奨」する誘導を含める
- 個別の税額計算を求められた場合は「税理士に相談してください」と拒否
- 公開されている記入例の参照・解説は OK（国税庁の記入例を基に案内）
- ふるさと納税の限度額シミュレーションは「概算参考値」として提供可（公開計算式の適用）

#### 8.5 svc-legal 特有の制約と対策

- 全回答に「弁護士・行政書士への相談を推奨」する誘導を含める
- 「あなたのケースではこうすべき」ではなく「一般的にこのような制度があります」という表現を使用
- 法テラス（0570-078374）等の無料相談窓口を積極的に案内

---

## ~~Phase 0 ピボットで削除されたルール~~

以下のルールは Phase 0 ピボットで削除:
- ~~§4: コミュニティ Q&A ルール~~ → Community 機能削除
- ~~§5: Document Scanner ルール~~ → AI Chat 画像入力に統合
- ~~§7: Banking Navigator レコメンドスコア計算~~ → AI Chat に統合（svc-banking が知識ベースで推薦）
- ~~§8: Admin Tracker 来日直後の必須手続き自動追加~~ → AI Chat の Tracker 自動生成に簡素化
- ~~§9: Stripe Webhook 処理~~ → Apple IAP / Google Play Billing に変更

---

## 変更履歴

- 2026-02-16: 初版作成
- 2026-02-17: Phase 0 アーキテクチャピボット反映（OC Runtime / memory_search / LLM routing / 課金体系更新）
- 2026-02-21: 6 Agent 体系反映（ドメイン更新、§8 士業独占業務の法的制約追加）
