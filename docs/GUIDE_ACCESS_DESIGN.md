# 指南 & 知識アクセス制御設計 v2

> 作成: 2026-02-19
> v2 更新: 2026-02-20（knowledge/guides 分離アーキテクチャ）
> v3 更新: 2026-02-21（6 Agent 体系反映）
> ステータス: 設計討論中

## 1. 概要

> 更新: 2026-03-01（統一品質 Guide + AI Chat 概要級/深度級。Z 承認済み）

情報を **2 つのコンテンツ層** × **4 つのユーザー層** で管理する。

**v1 からの変更点**: knowledge ファイルが「Agent 参照用」と「ユーザー閲覧用指南」を
兼用していた設計を廃止。完全に分離する。

### 知識構成の原則

**Agent の知識根源** = モデルの base 知識 + knowledge/（Z の実践経験・暗黙知・判断ロジック含む）

- モデルが既に知っている一般知識は knowledge/ に書かない（重複排除）
- 具体的数字（手数料、金利等）は knowledge/ に書かない（web search でリアルタイム取得）
- knowledge/ に書くのは **「モデルが知らない + 検索でも出てこない情報」だけ**

**guides/ の生成ソース** = モデルの base 知識 + knowledge/（**最核心の経験・判断ロジックを除く**）

- guides/ は knowledge/ から AI が生成する派生コンテンツ
- knowledge/ の全量は guides/ に書かない — **核心ノウハウは AI 向導（Layer 3）でのみ提供**
- これが AI 向導の差別化壁壘（他 AI や静的ガイドとの差異化ポイント）

## 2. 情報アーキテクチャ（2層コンテンツ + AI Chat 深度分層）

```
┌──────────────────────────────────────────────────┐
│  Guide（統一品質 = 完整 how-to、1000-2000字）       │
│  ├── Free 8篇（Guest 可見）→ SEO 引流 + 品質証明   │
│  └── Registered 37篇（登録後可見）→ 数量で登録促進  │
│  ※ 品質差なし。差異は可見性のみ                     │
│  ※ 全6ドメイン各1篇以上の Free 指南                 │
└────────────────────┬─────────────────────────────┘
                     │ AI Chat を使う
┌────────────────────▼─────────────────────────────┐
│  AI Chat（2段階の回答深度）                         │
│  ├── 概要級: Guide 同等 + 対話式答疑                │
│  │   （Profile なし / AI-only なし / web_search なし）│
│  └── 深度級: 概要級 + Profile 個性化 + AI-only 全量  │
│      （具体機関 / 決策樹 / 地域差 / web_search）     │
│  ※ 概要級 = "どうやるか"（一般論、ChatGPT より正確） │
│  ※ 深度級 = "あなたはどうすべきか"（核心壁壘）       │
└──────────────────────────────────────────────────┘
```

## 3. ファイル構成

6 Agent 体系（svc-finance / svc-tax / svc-visa / svc-medical / svc-life / svc-legal）に対応:

```
svc-{domain}/workspace/
├── knowledge/                ← Agent 専用（Layer 3 ソース）
│   ├── experience-tips.md    ← 実践経験・暗黙知
│   ├── decision-logic.md     ← 推薦ロジック・判断基準
│   └── legal-constraints.md  ← 士業独占業務の法的制約ルール
│
└── guides/                   ← ユーザー向け指南（Layer 1 + 2）
    ├── account-opening.md    ← access: free（svc-finance の例）
    ├── banks-overview.md     ← access: premium
    ├── remittance.md         ← access: premium
    └── investment-basics.md  ← access: premium
```

各 Agent の guides/ の構成例:
- **svc-finance**: 口座開設(free)、銀行比較(premium)、送金(premium)、投資基礎(premium)
- **svc-tax**: 税概要(free)、確定申告(premium)、年金(premium)、ふるさと納税(premium)
- **svc-visa**: 在留資格概要(free)、更新手順(premium)、永住申請(premium)
- **svc-medical**: 緊急対応(free)、保険制度(free)、受診ガイド(premium)、薬局(premium)
- **svc-life**: 生活基礎(free)、住居(premium)、行政手続き(premium)、交通(premium)
- **svc-legal**: 権利概要(free)、労働紛争(premium)、消費者保護(premium)

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

### 概要級ユーザー（Guest / Free の概要級回数）への対応

- ✅ 完整操作手順 + 材料リスト + 注意事項（Guide と同等レベル）
- ✅ LLM旧知識修正を反映（保険証→マイナ保険証 等 — "ChatGPT より正確"の底線）
- ✅ 対話式答疑（追問・明確化）
- ❌ Profile 個性化なし（国籍/ビザ/地域に基づく推薦なし）
- ❌ AI-only 内容なし（具体機関名+評価、判断決策樹、地域差異、web_search、跨域連動、🔒情報）
- → 回答末尾に tier に応じた案内 + 深度級導線:

**Guest の場合:**

```
[質問への完整回答]

💡 あなたの国籍・ビザ・地域に合わせた具体的なおすすめは、
深度級回答でご確認いただけます。
無料会員登録で、すべてのガイドと深度級 AI 相談5回をご利用いただけます。
```

**Free（概要級残り回数）の場合:**

```
[質問への完整回答]

💡 あなたの状況に合わせた個別アドバイス（どの銀行が最適か、
あなたのビザ種類での注意点など）は深度級でご案内できます。
[Standard プラン ¥720/月] [従量チャージ ¥180/50回]
```

### web search の活用ルール

- **具体的数字**（手数料、金利、申請費用等）→ **必ず web search** で最新情報を取得
- **制度変更の可能性がある情報** → web search で確認してから回答
- **一般的な概念・制度の仕組み** → ベース知識で回答 OK（検索不要）

## 6. 領域別 free/premium 境界（案 — Z 確認待ち）

### Finance（svc-finance）
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 口座開設 | ✅ 概要 | ✅ 手順 | 国籍×ビザ別の最適銀行、拒否対策 |
| 銀行比較 | — | ✅ 比較表 | あなたの状況での推薦理由 |
| 海外送金 | — | ✅ 方法比較 | 送金先国別の最安ルート（web search） |
| 投資・保険 | — | ✅ 基本説明 | 制度説明のみ（個別投資助言は金商法 NG） |
| ネットバンキング | — | ✅ 各行の特徴 | あなたの銀行でのセットアップ手順 |
| FAQ | ✅ 基本Q&A | — | — |

### Tax（svc-tax）⚠️ 税理士法52条 — 最高リスク
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 税制度概要 | ✅ 概要 | — | — |
| 確定申告 | — | ✅ 手順・記入案内 | 該当判断（「あなたは申告が必要」）、書類記入サポート |
| 年金 | — | ✅ 制度説明 | 在留資格×加入期間での該当制度案内 |
| 社会保険 | — | ✅ 制度説明 | あなたの雇用形態での適用判断 |
| ふるさと納税 | — | ✅ 基本手順 | 概算限度額（公開計算式の適用、個別節税 NG） |
| FAQ | ✅ 基本Q&A | — | — |

> **法的制約**: 個別税額計算・節税戦略の提案は税理士法52条により禁止（無償でも違法）。全回答に「税理士への相談推奨」を含める。

### Visa（svc-visa）
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 在留資格一覧 | ✅ 概要 | — | — |
| ビザ更新 | — | ✅ 手順 | あなたのビザ×勤務先での必要書類 |
| 永住申請 | — | ✅ 要件と手順 | ポイント計算、合格可能性の分析 |
| 期限ルール | — | ✅ 一覧 | あなたの期限に基づくリマインド |
| 入管局情報 | — | ✅ 地域別 | 混雑予測、最適な訪問タイミング |
| FAQ | ✅ 基本Q&A | — | — |

### Medical（svc-medical）
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 緊急対応119 | ✅ 全文 | — | — |
| 健康保険 | ✅ 概要 | — | 保険料計算、最適プラン |
| 病院ガイド | — | ✅ 受診手順 | 地域×症状での病院推薦 |
| 医療用語 | — | ✅ 用語集 | 症状の説明テンプレート |
| メンタルヘルス | — | ✅ 相談先 | 多言語対応施設の紹介 |
| 薬局 | — | ✅ 利用法 | 処方箋の読み方サポート |
| 予防接種 | — | ✅ スケジュール | あなたの国×年齢での推奨 |

### Life（svc-life）
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 生活基礎 | ✅ 概要 | — | — |
| 住居 | — | ✅ 物件探し・契約 | あなたの地域・予算での推薦 |
| 交通 | — | ✅ IC カード・定期券 | あなたの通勤ルートでの最適解 |
| 行政手続き | — | ✅ 転入届・マイナンバー | あなたの居住地での窓口案内 |
| 買い物 | — | ✅ 日用品・食材 | あなたの地域の店舗情報 |
| 文化 Tips | — | ✅ | 状況別の具体的アドバイス |
| 教育 | — | ✅ 学校・保育園 | あなたの地域での選択肢 |
| 就労基礎 | — | ✅ 労働法基礎 | あなたの在留資格での就労制限 |

### Legal（svc-legal）⚠️ 弁護士法72条
| トピック | free 指南 | premium 指南 | AI 向導のみ |
|---------|----------|-------------|------------|
| 権利概要 | ✅ 概要 | — | — |
| 労働紛争 | — | ✅ 制度説明・事例紹介 | 「類似ケースでは一般的にこうする」、相談窓口案内 |
| 事故対応 | — | ✅ 手順・連絡先 | あなたのケースでの一般的対応フロー |
| 消費者保護 | — | ✅ 制度説明 | クーリングオフ等の手続き案内 |
| 犯罪被害 | — | ✅ 対応手順・連絡先 | 多言語対応相談窓口の案内 |

> **法的制約**: 個別法律事件の法的判断・助言は弁護士法72条により禁止。全回答に「弁護士/行政書士への相談推奨」を含め、法テラス（0570-078374）等を積極的に案内。

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
