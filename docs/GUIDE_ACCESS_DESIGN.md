# 指南 & 知識アクセス制御設計 v2

> 作成: 2026-02-19
> v2 更新: 2026-02-20（knowledge/guides 分離アーキテクチャ）
> ステータス: 設計討論中

## 1. 概要

情報を **3 つのレイヤー** に分離し、それぞれの目的・読者・提供方法を明確化する。

**v1 からの変更点**: knowledge ファイルが「Agent 参照用」と「ユーザー閲覧用指南」を
兼用していた設計を廃止。完全に分離する。

## 2. 三層情報アーキテクチャ

```
┌──────────────────────────────────────────────┐
│  Layer 1: Free 指南（ユーザー向けドキュメント）   │
│  読者: 全ユーザー（ゲスト含む）                   │
│  内容: "こういう事がある" — 概要、存在の認知       │
│  目的: SEO 引流 + 認知 + 登録導線                │
│  ※ 領域によって存在しない場合あり                 │
│    例: 税務は free 指南なし                       │
└───────────────────┬──────────────────────────┘
                    │ 登録 + 有料化
┌───────────────────▼──────────────────────────┐
│  Layer 2: Premium 指南（ユーザー向けドキュメント） │
│  読者: Standard / Premium ユーザー               │
│  内容: "どうやるか" — 手順、チェックリスト         │
│  目的: 付費転換の価値証明                         │
│  ※ knowledge の全量は書かない                     │
│    核心ノウハウは Layer 3 に留保                   │
└───────────────────┬──────────────────────────┘
                    │ AI Chat を使う
┌───────────────────▼──────────────────────────┐
│  Layer 3: AI 向導（Agent 対話でのみ提供）         │
│  読者: AI Chat ユーザー（tier で深度制御）         │
│  内容: "あなたの場合は具体的にこうすべき"          │
│  目的: 他 AI / 他サービスとの差異化 = 核心壁壘    │
│  ソース: knowledge/ + モデル基礎知識 + web search  │
└──────────────────────────────────────────────┘
```

## 3. ファイル構成

```
svc-{domain}/workspace/
├── knowledge/                ← Agent 専用（Layer 3 ソース）
│   ├── experience-tips.md    ← 実践経験・暗黙知
│   ├── decision-logic.md     ← 推薦ロジック・判断基準
│   └── routing-rules.md      ← Agent 内部ルーティング
│
└── guides/                   ← ユーザー向け指南（Layer 1 + 2）
    ├── account-opening.md    ← access: free
    ├── banks-overview.md     ← access: premium
    ├── remittance.md         ← access: premium
    └── tax-payment.md        ← access: premium（free 指南なし）
```

### 重要な分離原則

| | knowledge/ | guides/ |
|---|---|---|
| **読者** | AI Agent のみ | エンドユーザー |
| **API 公開** | ❌ 非公開 | ✅ Navigator API で配信 |
| **前提知識** | モデルのベース知識あり | ユーザーは予備知識ゼロ |
| **内容** | 経験則、判断ロジック、暗黙知 | 体系的手順、チェックリスト |
| **具体的数字** | ❌ 書かない（web search で取得）| ✅ 生成時点の情報を記載 |
| **更新トリガー** | Z が経験追加時 | knowledge 更新時に自動再生成 |
| **多言語** | 不要（Agent が回答時に翻訳）| 必要（生成時に多言語版作成）|

## 4. 指南の生成フロー（一源生成）

```
Z が経験・暗黙知を提供
  ↓
knowledge/*.md に整理（Agent 専用）
  ↓ knowledge 更新を検知
OpenClaw Agent が自動で指南を再生成
  ├── free 指南: 概要レベル（存在の認知のみ）
  ├── premium 指南: 手順レベル（ただし核心 Tips は省略）
  └── 多言語版同時生成
  ↓
guides/*.md として保存
  ↓
Navigator API が guides/ を配信
```

### 生成ルール

- **free 指南**: そのトピックの概要だけ。"何があるか"は教えるが、"どうやるか"は教えない
- **premium 指南**: step-by-step の手順とチェックリスト。ただし knowledge の核心判断ロジック・経験の Tips は**含めない**（AI 向導でのみ提供）
- **領域別 free/premium 境界**: ドメインとトピックによって異なる（§6 参照）

## 5. AI 向導（Agent）の振る舞いルール

### 付費ユーザー（Standard / Premium）への対応

Agent は knowledge/ の全情報 + ベース知識 + web search を活用して、
**ユーザーの状況に合わせた具体的なアドバイスを直接提供する**。

- ✅ 「あなたの国籍と在留資格なら、○○銀行が最適です。理由は...」
- ✅ 「その送金額なら Wise が最安です。手数料は約 ¥X です（最新情報を検索中...）」
- ✅ knowledge の経験則・暗黙知をフル活用して回答
- ❌ 「指南を読んでください」とは言わない — 直接答える

### Free ユーザーへの対応

- ✅ 基本的な概要・一般論は回答 OK
- ✅ Layer 3 の Tips をワンポイントで自然に活用 OK
- ❌ 体系的な手順・チェックリスト・完全ガイドは提供しない
- → 概要回答の後に升级案内:

```
[質問への概要回答（2-3文）]

詳しい手順や個別アドバイスは Standard プラン（¥720/月）で
ご利用いただけます。AI 向導があなたの状況に合わせた
具体的なアドバイスをお伝えします。
```

### web search の活用ルール

- **具体的数字**（手数料、金利、申請費用等）→ **必ず web search** で最新情報を取得
- **制度変更の可能性がある情報** → web search で確認してから回答
- **一般的な概念・制度の仕組み** → ベース知識で回答 OK（検索不要）

## 6. 領域別 free/premium 境界（案 — Z 確認待ち）

### Banking
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 口座開設 | ✅ 概要 | ✅ 手順 | 国籍×ビザ別の最適銀行、拒否対策 |
| 銀行比較 | — | ✅ 比較表 | あなたの状況での推薦理由 |
| 海外送金 | — | ✅ 方法比較 | 送金先国別の最安ルート（web search） |
| 税金 | — | ✅ 基本説明 | 在留年数×収入での具体的試算 |
| ネットバンキング | — | ✅ 各行の特徴 | あなたの銀行でのセットアップ手順 |
| FAQ | ✅ 基本Q&A | — | — |

### Visa
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 在留資格一覧 | ✅ 概要 | — | — |
| ビザ更新 | — | ✅ 手順 | あなたのビザ×勤務先での必要書類 |
| 永住申請 | — | ✅ 要件と手順 | ポイント計算、合格可能性の分析 |
| 期限ルール | — | ✅ 一覧 | あなたの期限に基づくリマインド |
| 入管局情報 | — | ✅ 地域別 | 混雑予測、最適な訪問タイミング |
| FAQ | ✅ 基本Q&A | — | — |

### Medical
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 緊急対応119 | ✅ 全文 | — | — |
| 健康保険 | ✅ 概要 | — | 保険料計算、最適プラン |
| 病院ガイド | — | ✅ 受診手順 | 地域×症状での病院推薦 |
| 医療用語 | — | ✅ 用語集 | 症状の説明テンプレート |
| メンタルヘルス | — | ✅ 相談先 | 多言語対応施設の紹介 |
| 薬局 | — | ✅ 利用法 | 処方箋の読み方サポート |
| 予防接種 | — | ✅ スケジュール | あなたの国×年齢での推奨 |

### Concierge
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 生活基礎 | ✅ 概要 | — | — |
| ドメイン一覧 | ✅ 概要 | — | — |
| 文化 Tips | — | ✅ | 状況別の具体的アドバイス |
| 連絡先一覧 | — | ✅ | あなたの地域の連絡先 |

## 7. Navigator API の変更

### v1 → v2 の変更

| | v1（現在） | v2（新設計） |
|---|---|---|
| 参照ディレクトリ | `knowledge/` | `guides/` |
| frontmatter | `access: public/premium/agent-only` | `access: free/premium` |
| agent-only 扱い | 404 返却 | そもそも guides/ に存在しない |

### API エンドポイント（変更なし）

- `GET /api/v1/navigator/{domain}/guides` — 一覧（access フィールド付き）
- `GET /api/v1/navigator/{domain}/guides/{slug}` — 詳細（tier で全文/excerpt 切り替え）

### レスポンス形式（変更なし）

```json
// Free ユーザーが premium 指南にアクセス
{
  "slug": "remittance",
  "title": "海外送金ガイド",
  "access": "premium",
  "locked": true,
  "excerpt": "海外への送金方法を比較...",
  "upgrade_cta": true
}
```

### Frontend への影響

**変更なし。** API のレスポンス形式は v1 と同一。バックエンドの参照先が
`knowledge/` → `guides/` に変わるだけ。

## 8. 指南自動生成パイプライン

knowledge/ が更新されたら、OpenClaw Agent が自動で guides/ を再生成する。

### トリガー

- knowledge/*.md ファイルの更新を検知（cron / watch / 手動）
- 初期は手動実行、安定したら cron 化

### 生成 Agent のタスク

```
入力: knowledge/*.md + 生成ルール（§4, §6）
出力: guides/*.md（free/premium × 多言語）

ルール:
1. knowledge の内容を元に、ユーザー向けの読みやすい指南を生成
2. free 指南: 概要のみ、手順は含めない
3. premium 指南: 手順とチェックリスト含む。ただし knowledge の
   核心 Tips / 判断ロジック / 経験則は含めない
4. 多言語: 日本語をマスターとし、EN/ZH を同時生成
5. frontmatter に access: free/premium を付与
```

### 格納パス

```
svc-{domain}/workspace/guides/
├── {slug}.md          ← 日本語（マスター）
├── {slug}.en.md       ← 英語
├── {slug}.zh.md       ← 中国語
├── {slug}.ko.md       ← 韓国語（将来）
├── {slug}.vi.md       ← ベトナム語（将来）
└── {slug}.pt.md       ← ポルトガル語（将来）
```

## 9. 実装ロードマップ

### 完了（v1 で実装済み）
- [x] Backend: tier 情報を Agent prompt に注入 (`ba477ec`)
- [x] svc-* AGENTS.md: アクセス制御ルール追加 (`e4ecfc0`)
- [x] knowledge frontmatter 付与 (`ba477ec`)
- [x] Navigator API: tier ベースフィルタ + excerpt (`ba477ec`)
- [x] Frontend: ロック表示 + 升级 CTA (`e4ecfc0`)

### Phase 1: アーキテクチャ変更（knowledge/guides 分離）
- [ ] 各 svc-*/workspace/ に `guides/` ディレクトリ新設
- [ ] Navigator API: 参照先を `knowledge/` → `guides/` に変更
- [ ] frontmatter 値を `public/premium` → `free/premium` に変更
- [ ] svc-* AGENTS.md: 新しい振る舞いルールに書き換え
- [ ] GUIDE_ACCESS_DESIGN.md を v2 に更新 ← 今ここ

### Phase 2: Knowledge 再構築
- [ ] Z の実践経験をヒアリング（Banking から開始）
- [ ] 既存 knowledge から一般知識を削除、経験・ロジックのみ残す
- [ ] web_search 活用ルールを AGENTS.md に追加

### Phase 3: 指南生成
- [ ] 生成ルール定義（free/premium 境界 per ドメイン）
- [ ] AI で guides/*.md を生成
- [ ] Z レビュー → 確定
- [ ] 多言語版生成

### Phase 4: 自動化
- [ ] knowledge 更新 → guides 自動再生成パイプライン構築
- [ ] 他ドメイン展開（Visa → Medical → Concierge）

## 10. 関連ドキュメント

- 製品仕様: `strategy/product-spec.md`
- ビジネスルール: `architecture/BUSINESS_RULES.md`
- API 設計: `architecture/API_DESIGN.md`
- 再設計討論 Memo: `docs/KNOWLEDGE_REDESIGN_MEMO.md`
- QA: `docs/QA_FEEDBACK_20260218.md`
