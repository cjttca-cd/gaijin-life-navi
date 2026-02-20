# 業務ルールと検証

## 1. 共通ルール

### 認証要件

- `/api/v1/health`, `/api/v1/auth/register`, `/api/v1/emergency`, `/api/v1/navigator/*`, `/api/v1/subscription/plans` 以外の全 API エンドポイントは認証必須
- JWT は Firebase Auth が発行（ID Token）。有効期限 1 時間。Flutter クライアントは `firebase_auth` パッケージで自動リフレッシュを行う
- API Gateway (FastAPI) で Firebase Admin SDK を使用して JWT 検証 → 無効な場合は 401 を即返却

### データ隔離

- 全ユーザーデータはアプリケーション層（FastAPI）で `user_id = current_firebase_uid` を検証して制限
- ナビゲーターコンテンツは三層アクセス制御（詳細: `docs/GUIDE_ACCESS_DESIGN.md`）:
  - `access: public` → 全ユーザーに全文提供
  - `access: premium` → Standard/Premium に全文、Free/Guest に excerpt のみ
  - `access: agent-only` → Navigator API に出さない（Agent knowledge 専用）
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
| Banking 詳細ガイド（全機能） | ✅ | ✅ | ✅ | ✅ |
| Visa/Medical/Admin 等 詳細 | 概要+CTA | ✅ | ✅ | ✅ |
| AI Chat（テキスト + 画像） | ❌ | **5回/日** | **300回/月** | **無制限** |
| Auto Tracker（AI 提案） | ❌ | 3件 | 無制限 | 無制限 |
| 広告 | あり | あり | なし | なし |

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
  └── 全 Chat → 拒否 (0 回)
tier == 'free' の場合:
  └── AI Chat: lifetime chat_count >= 20 → 429 USAGE_LIMIT_EXCEEDED
  └── AI 回答深度: Layer 1 詳細 OK / Layer 2 概要のみ + 升级案内 / Layer 3 Tips のみ
tier == 'standard' の場合:
  └── AI Chat: 月間合計 chat_count >= 300 → 429 USAGE_LIMIT_EXCEEDED
tier == 'premium' の場合:
  └── 制限なし
```

### 日次 / 月次カウントのリセット

- **Free (日次)**: `daily_usage` テーブル。`usage_date` ごとにレコード。翌日は新しいレコードが作成されるため自動リセット
- **Standard (月次)**: `daily_usage` テーブルの月初〜当日の `chat_count` を SUM で集計。月変わりで自動リセット（バッチジョブ不要）
- **Premium (無制限)**: カウントは情報提供目的のみ

### 制限超過時の API レスポンス

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

---

## 3. AI チャットルール

### Agent ルーティング

2 層ルーティング方式:

1. **Emergency keyword 検出**（即座、LLM 不要）:
   - パターン: `119`, `110`, `救急`, `emergency`, `ambulance`, `緊急通報`, `救命`, `急救`, `救护车`
   - → svc-medical にルーティング

2. **LLM classification**（~4 秒）:
   - svc-concierge に分類プロンプトを送信
   - 4 ドメインから 1 つを判定: `banking`, `visa`, `medical`, `concierge`
   - Fallback: LLM 失敗時は `current_domain` or `svc-concierge`

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
| banking | Banking & Finance | 🟢 active | svc-banking |
| visa | Visa & Immigration | 🟢 active | svc-visa |
| medical | Medical & Health | 🟢 active | svc-medical |
| concierge | Life & General | 🟢 active | svc-concierge |
| housing | Housing & Utilities | 🔜 coming_soon | svc-housing (Phase 1) |
| employment | Employment & Tax | 🔜 coming_soon | svc-work (Phase 1) |
| education | Education & Childcare | 🔜 coming_soon | — |
| legal | Legal & Insurance | 🔜 coming_soon | — |

### ガイドコンテンツの管理

- ガイドは各 agent の `workspace/knowledge/*.md` に配置
- Navigator API は knowledge ディレクトリを直接走査して提供
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
- Navigator ガイド: knowledge ファイルの末尾に免責事項を含める
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
