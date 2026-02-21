# 🌏 Gaijin Life Navi — 製品仕様書

> 作成日: 2026-02-15
> 最終更新: 2026-02-17（Phase 0 プロダクトピボット）
> ステータス: UPDATED — ピボット反映済み
> SSOT: `/docs/PHASE0_DESIGN.md`（Z 承認済み 2026-02-17）

---

## 1. 製品概要

### 1.1 ワンライナー
**AI Life Concierge — 在日外国人が日本での生活をAIチャットで解決するワンストップ・プラットフォーム**

### 1.2 ビジョン
在日外国人396万人が「日本で暮らすことの不安」をゼロにする。
Reddit r/japanlife に書き込む代わりに、このアプリのAIに聞けば即座に正確な答えが返ってくる世界。

**ピボット後の方針**: プロダクトの中核は **AI Chat（Life Concierge）** である。全ての機能は AI Chat を起点として設計される。Navigator（静的ガイド）はSEO流入と AI Chat への導線として機能し、Tracker は AI が会話から自動生成する。

### 1.3 USP（Unique Selling Proposition）
1. **AI Chat ファースト**: 静的ガイドではなく、個人の状況に合わせた AI 対話がプライマリ・インターフェース
2. **6ドメイン専門知識**: Finance, Tax, Visa, Medical, Life, Legal — 各ドメインに特化した Service Agent が高品質な回答を提供
3. **多言語ネイティブ**: 14言語対応（AI動的翻訳。テンプレ翻訳ではない）
4. **手続き完結型**: 情報提供だけでなく「次に何をすべきか」のアクション提示 + AI 自動 Tracker 生成
5. **ワンストップ**: 求人サイト、翻訳アプリ、Q&A掲示板が分断している現状を AI Chat 一本で統合

---

## 2. Gap → 機能マッピング

### 2.1 Stage 2 で発見した Gap と対応機能（ピボット後）

| # | Gap（Stage 2 で特定） | 対応機能 | 優先度 | Phase |
|---|----------------------|---------|--------|-------|
| G1 | AI×生活支援の統合プラットフォームが不在 | **AI Life Concierge**（6 専門 agent + 軽量ルーター） | Must | 0 |
| G2 | 銀行口座開設の言語障壁 | **Finance Navigator** + svc-finance | Must | 0 |
| G3 | ビザ・在留手続きの複雑さ | **Visa Navigator** + svc-visa | Must | 0 |
| G4 | 医療受診時の言語障壁 | **Medical Guide** + svc-medical | Must | 0 |
| G5 | 税務・年金・社保の複雑さ | **Tax Navigator** + svc-tax | Must | 0 |
| G6 | 日本語の公文書が読めない | ~~Document Scanner~~ → **AI Chat 画像送信で代替**（独立機能として廃止。OCR は AI Chat に統合：ユーザーが書類画像を送信 → AI が読み取り・解説） | — | 0 |
| G7 | 同じ境遇の人と情報交換できない | ~~Community Q&A~~ → **完全廃止**（AI が質問に直接回答。コミュニティはコールドスタート問題が深刻で、初期に価値を提供できない） | — | — |
| G8 | 個別の状況に合った情報がない | **AI パーソナライズ回答**（ユーザープロフィール連携） | Should | 0 |
| G9 | 住居・交通・行政・文化等の生活全般 | **Life Navigator** + svc-life | Must | 0 |
| G10 | 労働紛争・事故・犯罪被害等の法的問題 | **Legal Navigator** + svc-legal | Must | 0 |
| G11 | 食事・食材の情報（宗教対応等） | **Life Navigator**（svc-life のサブトピック） | Should | 0 |
| G12 | 企業の外国人オンボーディング支援 | B2B 企業ダッシュボード | Could | 2 |

### 2.2 機能 × ペルソナ マトリクス

| 機能 | Chen Wei (技術者) | Nguyen Thi Lan (特定技能) | Kim Jihye (留学生) | 企業HR |
|------|:---:|:---:|:---:|:---:|
| AI Life Concierge (Chat) | ◎ | ◎ | ◎ | — |
| Finance Navigator + Agent | ◎ | ◎ | ○ | — |
| Tax Navigator + Agent | ◎ | ◎ | ○ | ○ |
| Visa Navigator + Agent | ◎ | ◎ | ◎ | ○ |
| Medical Guide + Agent | ○ | ◎ | ○ | — |
| Life Navigator + Agent | ◎ | ◎ | ◎ | — |
| Legal Navigator + Agent | ◎ | ◎ | ○ | ○ |
| Auto Tracker | ◎ | ◎ | ◎ | ○ |
| ~~Doc Scanner~~ | — | — | — | — |
| ~~Community Q&A~~ | — | — | — | — |

---

## 3. コア機能の詳細設計

### 3.1 AI Life Concierge（プライマリ・インターフェース）

**概要**: 多言語 AI チャットインターフェース。ユーザーの質問にドメイン専門 Agent が対話形式で回答し、具体的なアクション（手続きの手順、必要書類、窓口情報）を提示する。画像送信にも対応（書類の読み取り・翻訳・解説を含む）。

**アーキテクチャ（PHASE0_DESIGN.md 準拠）**:
```
ユーザー入力（テキスト or 画像、任意言語）
    ↓ Flutter App
API Gateway (FastAPI)
    ├── Firebase JWT 認証
    ├── Rate Limiting (per user tier)
    ├── Intent Analysis → Domain Routing
    └── Session Mapping: app:{uid}:{domain}
    ↓ subprocess
OpenClaw Gateway
    ├── 軽量ルーター  → 6 ドメイン分類（旧 svc-concierge）
    ├── svc-finance   → 金融ドメイン
    ├── svc-tax       → 税務ドメイン
    ├── svc-visa      → ビザ・在留
    ├── svc-medical   → 医療
    ├── svc-life      → 生活全般
    └── svc-legal     → 法律
    ↓ memory_search (bge-m3)
workspace/knowledge/*.md（Agent 専用: 経験則・判断ロジック）
workspace/guides/*.md（ユーザー向け指南: Navigator API で配信）
    ↓
回答生成 + ソース引用 + 次のアクション提示 + Tracker 項目自動抽出
```

**LLM routing**:
- 軽量ルーター（旧 svc-concierge を分類専用に変更）がユーザーの意図を 6 ドメインに分類
- Emergency keyword → svc-medical に即座にルーティング
- 専門ドメイン → 該当の svc-* agent にルーティング（finance / tax / visa / medical / life / legal）
- 画像付きメッセージ → AI が画像を解読（書類翻訳・解説含む）

**RAG ナレッジベース（memory_search ベース）**:

| ドメイン | 主要ソース | 更新頻度 | Agent |
|---------|-----------|---------|-------|
| Finance | 金融庁、全銀協、主要銀行公式 | 半年 | svc-finance |
| Tax | 国税庁、年金機構、各自治体 | 法改正時・年次 | svc-tax |
| Visa | 入管庁、ISA ポータル | 法改正時 | svc-visa |
| Medical | 厚労省、AMDA 多文化共生ガイド | 四半期 | svc-medical |
| Life | ISA 外国人生活支援ポータル（17言語）、各自治体、不動産ポータル | 月次 | svc-life |
| Legal | 法テラス、弁護士会、厚労省（労働関連） | 法改正時 | svc-legal |

**差別化ポイント**:
- 汎用 ChatGPT との違い: 6ドメインに特化した RAG + ユーザープロフィール（在留資格、国籍、地域）に応じたパーソナライズ + 日本の行政手続きに最適化された Agent 群 + 士業独占業務の法的制約を組み込んだ安全設計
- 既存アプリとの違い: 「読む」のではなく「聞く」体験。会話の中で段階的に情報を提供 + 自動 Tracker 生成

**免責事項**: 全ての回答に「一般的な情報提供であり、法的助言ではありません。最新情報は関係機関にご確認ください」を表示。ソースURLを必ず引用。

### 3.2 Navigator（6ドメイン静的ガイド + SEO 流入口）

**概要**: ドメイン別の静的ガイドコンテンツ。SEO 流入口として機能し、AI Chat への導線を作る。ゲストでも閲覧可能（一部制限あり）。

**6ドメイン（Phase 0 で全て active）**:

| # | ドメイン | Agent | コンテンツ例 |
|---|---------|-------|-------------|
| 1 | **Finance** | svc-finance | 口座開設ガイド、銀行比較、送金方法、投資・保険基礎 |
| 2 | **Tax** | svc-tax | 確定申告、年金、社会保険、ふるさと納税 |
| 3 | **Visa** | svc-visa | 在留資格更新、資格変更、永住申請、家族滞在 |
| 4 | **Medical** | svc-medical | 診療科検索、保険制度、緊急対応（119の呼び方）、薬局、メンタルヘルス |
| 5 | **Life** | svc-life | 住居探し、交通、行政手続き（転入届・マイナンバー）、買い物、文化、教育 |
| 6 | **Legal** | svc-legal | 労働紛争、事故対応、犯罪被害、消費者保護、権利案内 |

**Note**: Phase 0 で 6 ドメイン全てが active。旧 Phase 1 で追加予定だった Housing / Work / Admin / Transport は svc-life に統合。Tax / Legal は新設。

### 3.3 Auto Tracker（AI 自動生成 TODO）

**概要**: ~~手動入力の手続きチェックリスト~~ → AI Chat の会話から自動的に TODO / チェックリストを生成する機能。

**ピボット理由**: 手動で手続きを管理するより、AI が会話内容から自動的に「次にやるべきこと」を抽出・構造化する方がユーザー体験が優れている。

**仕組み**:
1. ユーザーが AI Chat で相談（例:「銀行口座を開設したい」）
2. AI が回答と同時に `tracker_items` を自動生成（API レスポンスに含まれる）
3. Flutter App が Tracker 画面に自動追加
4. ユーザーは完了チェックのみ操作

**レスポンス例**（PHASE0_DESIGN.md §4 準拠）:
```json
{
  "reply": "銀行口座の開設についてご案内します...",
  "tracker_items": [
    {
      "title": "銀行口座開設",
      "deadline": null,
      "steps": ["在留カード準備", "住民票取得", "窓口予約", "来店"]
    }
  ]
}
```

### 3.4 ~~Document Scanner & Translator~~ → 廃止

> **廃止理由**: 独立した OCR 機能は不要。AI Chat に画像を送信すれば、AI が直接書類を読み取り・翻訳・解説する。Cloud Vision API 等の追加コストも不要（LLM のマルチモーダル機能で対応）。
>
> **代替**: AI Chat への画像送信機能として統合。ユーザーは書類を撮影 → Chat に送信 → AI が内容を解読・翻訳・次のアクションを提示。

### 3.5 ~~Community Q&A~~ → 完全廃止

> **廃止理由**: 
> 1. **コールドスタート問題**: MVP 段階でコミュニティに十分なユーザーがおらず、質問しても回答がつかない
> 2. **AI が代替**: ドメイン専門 Agent が直接回答するため、ユーザー同士の Q&A は不要
> 3. **モデレーションコスト**: 多言語コミュニティの品質管理は極めて高コスト
> 4. **開発リソース集中**: AI Chat の品質向上にリソースを集中させる

### 3.6 Medical Emergency Guide（全ユーザー無料公開）

**概要**: 緊急医療情報は認証不要・ゲストでもアクセス可能。

**内容**:
- 救急車の呼び方（119）、多言語対応
- 最寄り救急病院検索
- 基本的な症状説明フレーズ
- 毒物・事故時の対応フロー

---

## 4. Brand & Visual Direction

### 4.1 ブランドトーン
- **信頼できる (Trustworthy)**: 公式情報源に基づく正確な回答
- **親しみやすい (Approachable)**: 官僚的ではなく、友人に相談するような体験
- **エンパワーメント (Empowering)**: 「困っている人を助ける」のではなく「自立を支援する」
- **多文化共生 (Inclusive)**: 特定の国籍・文化を優遇しない
- **プロフェッショナル (Professional)**: カジュアルすぎず、信頼感のある佇まい

### 4.2 避けるべき印象
- 上から目線、お役所的、冷たい
- 子供っぽい、ゲーム的
- 特定の国旗・民族的ステレオタイプ

### 4.3 ターゲット感情
「このアプリがあれば、日本での生活は怖くない」— 安心感と自信

### 4.4 ビジュアル参考プロダクト
1. **Wise (旧TransferWise)**: 金融×グローバル、クリーンで信頼感
2. **Duolingo**: 親しみやすさ、多言語、達成感の演出
3. **Google Maps**: 情報の正確性、直感的ナビゲーション

### 4.5 配色方向
- メイン: 信頼感のあるブルー系（金融・行政の安心感）
- アクセント: 温かみのあるオレンジ or グリーン（親しみやすさ・エンパワーメント）
- 背景: クリーンなホワイト系
- ⚠️ hex コード・フォント名・px 値は Designer が決定

---

## 5. Access Boundary Matrix

| 機能 | 🔓 ゲスト | 🆓 Free | ⭐ Standard | 💎 Premium |
|------|:---------:|:-------:|:-----------:|:----------:|
| Medical Emergency Guide | ✅ | ✅ | ✅ | ✅ |
| 公開指南（各ドメイン 1-2 篇） | ✅ | ✅ | ✅ | ✅ |
| 付費指南（タイトル + 冒頭 excerpt） | 🔒 excerpt | 🔒 excerpt | ✅ 全文 | ✅ 全文 |
| AI Chat（テキスト + 画像解読） | ❌ | 20回/生涯 | 300回/月 | 無制限 |
| AI Chat の回答深度 | — | 概要+Tips | 全知識活用 | 全知識活用 |
| Auto Tracker | ❌ | ✅ | ✅ | ✅ |
| 広告 | あり | あり | なし | なし |

**三層指南アーキテクチャ** (詳細: `docs/GUIDE_ACCESS_DESIGN.md` v2):
- **Layer 1 (Free 指南)**: SEO 引流用。各ドメイン 1-2 篇、5 言語対応。ソース: `guides/`（`access: free`）
- **Layer 2 (Premium 指南)**: Standard/Premium で全文閲覧。Free にはタイトル + excerpt + 升级 CTA。ソース: `guides/`（`access: premium`）
- **Layer 3 (AI 向導)**: API 非公開。Agent が `knowledge/`（経験則・判断ロジック・暗黙知）+ ベース知識 + web_search で直接回答

**設計原則**:
- Free で「このアプリがないと困る」と感じさせる。Free 指南 + AI 概要回答で初回体験
- 付費指南の**体系的情報**が Standard/Premium 転換のドライバー
- AI Chat: 付費ユーザーには knowledge の全情報を活用して直接回答（「指南を読め」とは言わない）。Free ユーザーには概要回答 + 升级案内
- ゲストでも Free 指南 + Emergency にアクセス可能 → 登録への導線

---

## 6. 課金体系

### 6.1 サブスクリプション

| プラン | 月額 | AI Chat（画像解読含む） | Tracker | 広告 |
|--------|------|----------------------|---------|------|
| 🆓 Free | ¥0 | 5回/日 | 3件 | あり |
| ⭐ Standard | ¥720/月 | 300回/月 | 無制限 | なし |
| 💎 Premium | ¥1,360/月 | 無制限 | 無制限 | なし |

### 6.2 従量チャージ（都度購入）

| パック | 価格 | 単価 |
|--------|------|------|
| 100回 | ¥360 | ¥3.6/回 |
| 50回 | ¥180 | ¥3.6/回 |

### 6.3 廃止プラン

| プラン | 旧価格 | 廃止理由 |
|--------|--------|---------|
| ~~Premium+~~ | ~~¥1,500/月~~ | Premium ¥1,360 との差額 ¥140 に対して十分な差別化ができない |
| ~~旧 Premium~~ | ~~¥500/月~~ | 3ティア制に再構築。Standard ¥720 が実質的な後継 |

### 6.4 Apple IAP / Google Play 価格調整
実際の価格は各ストアの利用可能な価格点に合わせて微調整:
- ¥720 → ¥700 or ¥750（要確認）
- ¥1,360 → ¥1,400（要確認）

---

## 7. Non-functional Requirements

### 7.1 パフォーマンス
- AI Chat 応答: 初回トークン 3秒以内（テスト実績: 3.4秒で完了）
- Navigator ページ読込: 2秒以内
- 並行処理: 3ユーザー同時リクエストで 13秒以内（テスト実績: 12.8秒）

### 7.2 対応デバイス・プラットフォーム
- iOS (iPhone): App Store 配信
- Android: Google Play 配信
- Web: ブラウザ対応（Flutter Web）
- 技術要件: クロスプラットフォーム対応が必要

### 7.3 オフライン対応
- Navigator の静的コンテンツ: オフラインキャッシュ対応（Should）
- AI Chat: オンライン必須（LLM 呼び出しのため）
- Emergency Guide: オフラインキャッシュ対応（Must）

### 7.4 アクセシビリティ
- 画面読み上げ対応（VoiceOver / TalkBack）
- 文字サイズ変更対応
- 高コントラストモード

### 7.5 多言語
- MVP: 5言語（英語、中国語簡体、ベトナム語、韓国語、ポルトガル語）
- AI Chat: LLM が動的に 14+ 言語に対応
- UI 文言: i18n ファイル（AI翻訳 + ネイティブチェック）

---

## 8. Data Readiness Definition

### 8.1 MVP ローンチに必要な最低限データ

| ドメイン | 必要ファイル数 | 必要コンテンツ | 言語 | ソース |
|---------|-------------|-------------|------|--------|
| Finance (svc-finance) | 6 files | 5大銀行比較、口座開設手順、送金方法、投資・保険基礎、ネットバンキング、FAQ | JA（AI が多言語対応） | 金融庁、全銀協、各行公式 |
| Tax (svc-tax) | 6 files | 税制度概要、確定申告、年金制度、社会保険、ふるさと納税、FAQ | JA | 国税庁、年金機構 |
| Visa (svc-visa) | 6 files | 在留更新、資格変更、永住、再入国、資格外活動、家族滞在 | JA | 入管庁、ISA |
| Medical (svc-medical) | 7 files | 診療科ガイド、保険制度、緊急対応、受診フレーズ、薬局、健診、メンタルヘルス | JA | 厚労省、AMDA |
| Life (svc-life) | 8 files | 住居、交通、行政手続き、買い物、文化Tips、教育、就労基礎、FAQ | JA | ISA 17言語ポータル |
| Legal (svc-legal) | 5 files | 労働紛争、事故対応、消費者保護、犯罪被害、FAQ | JA | 法テラス、弁護士会 |
| **合計** | **~38 files** | **~200KB** | | |

### 8.2 データ準備基準
- ソフトウェアが動いてもナレッジファイルが空なら MVP 未完成
- 各 agent の `workspace/knowledge/` に最低限のファイルが配置されていること
- memory_search で質問に対して関連 snippet が返ること（検索精度テスト必須）

---

## 9. Legal & Compliance Risk Map

### 9.1 機能別リスクレベル

| 機能 | リスクレベル | 主要リスク | 必須措置 |
|------|:---------:|-----------|---------|
| AI Chat 全般 | 🟡 中 | 誤情報による損害 | 免責表示必須、ソース引用、「法的助言ではない」明示 |
| svc-tax | 🔴 高 | 税理士法52条（無償でも違法） | 個別税額計算・節税戦略 NG、「税理士に要相談」の誘導を常に含める |
| svc-legal | 🔴 高 | 弁護士法72条 | 個別法律事件の法的判断 NG、「弁護士/行政書士に要相談」の誘導を常に含める |
| svc-visa | 🟡 中 | 行政書士法19条（書類作成代行） | 「情報提供」の範囲厳守、書類作成・代行は行わない、行政書士マッチングに誘導 |
| svc-finance | 🟡 中 | 金商法（投資助言に該当する可能性） | 投資助言は行わない、制度説明・商品比較に限定 |
| svc-medical | 🟡 低〜中 | 医師法17条 | 「診断」は行わない、「情報提供」に限定、緊急時は119誘導 |
| svc-life | 🟢 低 | — | ほぼ制約なし |
| Navigator (静的ガイド) | 🟢 低 | 情報の正確性 | 出典明示、更新日表示 |

### 9.2 「情報提供」と「代行」の境界線

| ✅ 許可される範囲（情報提供） | ❌ 踏み込んではいけない範囲（代行） |
|----------------------------|--------------------------------|
| 手続きの一般的な流れを説明 | 個別の申請書を作成する |
| 必要書類の一覧を提示 | 書類を代理で提出する |
| 窓口の場所・連絡先を案内 | ユーザーの代わりに窓口に連絡する |
| 在留資格の一般的な要件を説明 | 個別のケースで「申請が通る」と断言する |
| 症状に対する一般的な情報提供 | 「あなたは○○病です」と診断する |

### 9.3 Privacy Policy / Terms of Service 要件

**収集データ**:
- Firebase Auth: メールアドレス、UID
- プロフィール: 国籍、在留資格、居住地域（任意入力）
- 利用データ: Chat 利用回数、Tracker 項目
- 画像: AI Chat に送信された画像（処理後は保持しない方針）

**第三者共有**:
- Anthropic (Claude API): Chat メッセージ（匿名化）
- Firebase (Google): 認証情報
- Apple / Google: 決済情報（各プラットフォーム経由）

**ユーザー権利**:
- データ閲覧・エクスポート権
- アカウント削除権（全データ消去）
- Chat 履歴削除権

---

## 10. 多言語設計

**MVP Day 1 から5言語同時リリース**（AI が多言語対応のため、言語フェーズ分けは不要）

| 言語 | 在留外国人数 | 備考 |
|------|------------|------|
| 英語 | 横断（全国籍のブリッジ言語） | r/japanlife 等 |
| 中国語（簡体） | 約82万人 | 最大人口 |
| ベトナム語 | 約59万人 | 特定技能で急増 |
| 韓国語 | 約41万人 | |
| ポルトガル語 | 約21万人 | 日系ブラジル人 |

**v1.0 以降**: +5言語（タガログ語、インドネシア語、ネパール語、ミャンマー語、スペイン語）

**実装方式**:
- UI 文言: i18n ファイル（AI翻訳 + ネイティブチェック）
- AI Chat: LLM が動的に対応（追加言語は Agent 設定のみで対応可能）
- Navigator コンテンツ: 日本語ソース → AI 翻訳 → ネイティブチェック

---

## 11. MVP スコープ

### 11.1 MVP に含める機能

| # | 機能 | MoSCoW | MVP 仕様 | Phase |
|---|------|--------|---------|-------|
| 1 | AI Life Concierge | **Must** | 軽量ルーター + 6 専門 agent、テキスト + 画像対応 | 0 |
| 2 | Finance Navigator + Agent | **Must** | 静的ガイド + svc-finance（口座開設 wizard、送金比較） | 0 |
| 3 | Tax Navigator + Agent | **Must** | 静的ガイド + svc-tax（確定申告、年金、社保） | 0 |
| 4 | Visa Navigator + Agent | **Must** | 静的ガイド + svc-visa（更新・変更フロー） | 0 |
| 5 | Medical Guide + Agent | **Must** | 静的ガイド + svc-medical（症状→診療科、緊急対応） | 0 |
| 6 | Life Navigator + Agent | **Must** | 静的ガイド + svc-life（住居、交通、行政、文化） | 0 |
| 7 | Legal Navigator + Agent | **Must** | 静的ガイド + svc-legal（労働紛争、権利案内） | 0 |
| 8 | Auto Tracker | **Must** | AI Chat から自動生成（手動追加も可） | 0 |
| 9 | Emergency Guide | **Must** | 全ユーザー無料、オフライン対応 | 0 |
| 10 | ~~Doc Scanner~~ | **Won't** | ~~廃止~~ AI Chat 画像送信で代替 | — |
| 11 | ~~Community Q&A~~ | **Won't** | ~~完全廃止~~ AI が直接回答 | — |
| 12 | B2B Dashboard | **Won't** | Phase 2 | 2 |

### 11.2 MVP で検証する仮説

| # | 仮説 | 検証方法 | 成功基準 |
|---|------|---------|---------|
| H1 | 在日外国人は生活手続きの AI Concierge に需要がある | DL数 + DAU | 3ヶ月で10,000 DL |
| H2 | AI Chat の回数制限で Standard 転換が起きる | Free→Standard 転換率 | 8%以上 |
| H3 | Finance Navigator が最初の AHA モーメントになる | 機能別利用率 | 初回セッションの60%が Finance |
| H4 | ユーザーは月¥720を払う意思がある | 課金率 | DL数の8%が Standard 課金 |
| H5 | ~~コミュニティが自律的に成長する~~ → 廃止 | — | — |
| H6 | AI 自動 Tracker がユーザーの継続利用を促進する | Tracker 完了率、リテンション | 7日リテンション 40%以上 |

### 11.3 MVP 開発タイムライン（PHASE0_DESIGN.md §7 準拠）

| Week | 内容 |
|------|------|
| Week 1 | 基盤構築: 6 Agent 作成（svc-finance, svc-tax, svc-visa, svc-medical, svc-life, svc-legal）+ 軽量ルーター、API Gateway scaffold (FastAPI)、知識ファイル作成 |
| Week 2 | 拡張: Flutter Chat UI + Navigator UI + API 接続、Tracker 自動生成、6 ドメイン Navigator |
| Week 3 | 品質: 知識庫拡充、Access Boundary 実装、E2E テスト、Backend deploy、App Store 準備 |

### 11.4 MVP コスト見積（硬性支出のみ）

> ⚠️ 内部 AI Agent（PM/Coder/Designer/QA）による開発のため、人件費は発生しない。

#### 初期一次性支出

| 項目 | 金額 | 備考 |
|------|------|------|
| 法務費用（行政書士法リーガルチェック） | ¥300,000 | 弁護士相談。法的リスク回避のため必須 |
| ドメイン・初期設定 | ¥5,000 | |
| **初期合計** | **¥305,000** | |

#### 月額ランニング（MVP 初期フェーズ）

| 項目 | 月額 | 備考 |
|------|------|------|
| AI API (Claude Sonnet 4.5) | ¥30,000 | $3/MTok input, $15/MTok output。初期ユーザー少数 |
| Firebase (Auth + Firestore) | ¥0〜¥5,000 | Spark→Blaze プラン |
| VPS / Fly.io (API Gateway + OC) | ¥5,000〜¥10,000 | OpenClaw 稼働環境 |
| PostgreSQL (ユーザーDB) | ¥3,000 | |
| ~~Cloud Vision API (OCR)~~ | ~~¥10,000~~ | 廃止（AI Chat のマルチモーダルで代替） |
| ~~Pinecone (Vector DB)~~ | ~~¥3,000~~ | 廃止（memory_search bge-m3 で代替） |
| ~~Cloudflare Workers~~ | ~~¥3,000~~ | 廃止（FastAPI に統合） |
| **月額合計** | **~¥43,000** | 旧 ¥51,000 から削減 |

---

## 12. MVP → V1.0 拡張パス

| Version | Phase | 追加内容 | 時期 |
|---------|-------|---------|------|
| MVP (v0.1) | Phase 0 | AI Chat (6 Agent + 軽量ルーター) + Navigator (6 domain) + Auto Tracker + Emergency | Week 3 |
| v0.5 | Phase 0.5 | 知識庫拡充、パフォーマンス改善、多言語品質向上 | MVP +1ヶ月 |
| v1.0 | Phase 1 | SSE ストリーミング、AI Chat 画像入力、知識庫深化、LP | MVP +3ヶ月 |
| v1.5 | Phase 1.5 | +5言語、B2B 企業ダッシュボード、士業マッチング（行政書士/税理士/弁護士） | MVP +6ヶ月 |
| v2.0 | Phase 2 | 住居検索連携、求人連携（API）、AI 音声対話 | MVP +12ヶ月 |

---

## 変更履歴
- 2026-02-15: 初版作成
- 2026-02-16: Z レビュー APPROVED
- 2026-02-17: Phase 0 プロダクトピボット反映（AI Concierge 中心化 / 課金体系再構築 / OC Runtime）
- 2026-02-21: 6 Agent 体系反映（svc-finance / svc-tax / svc-life / svc-legal 追加、concierge 廃止→軽量ルーター、Phase 0 = 6 agent 全部）
