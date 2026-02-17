# 🌏 Gaijin Life Navi — GTM（Go-to-Market）戦略

> 作成日: 2026-02-15
> 最終更新: 2026-02-17（Phase 0 プロダクトピボット）
> ステータス: UPDATED — ピボット反映済み
> SSOT: `/docs/PHASE0_DESIGN.md`（Z 承認済み 2026-02-17）

---

## 1. ターゲットセグメント

> ⚠️ AI が多言語対応のため、言語別にフェーズ分けしない。MVP Day 1 から5言語同時リリース。

### ローンチ時: 全セグメント同時攻略（5言語）

| セグメント | 言語 | 人口 | チャネル | 特徴 |
|-----------|------|------|---------|------|
| 英語圏エンジニア・駐在員 | EN | 横断 | Reddit r/japanlife, Tokyo Dev | 高CAC効率、口コミ力◎、AI Chat 早期採用者 |
| 中国語圏（技術者・留学生） | ZH | 82万人 | WeChat, 小紅書, Facebook | 最大人口 |
| ベトナム語圏（特定技能） | VI | 59万人 | Facebook グループ | B2B2C入口 |
| 韓国語圏 | KO | 41万人 | カカオトーク, Instagram | |
| ポルトガル語圏（日系ブラジル） | PT | 21万人 | Facebook, Instagram | 工場集住地域 |

**初動の重点**: Reddit r/japanlife（英語圏エンジニア）が AI Chat の最初のパワーユーザー。テック感度が高く口コミ効果が大きい。

### v1.0 以降: +5言語で全面展開
タガログ語、インドネシア語、ネパール語、ミャンマー語、スペイン語を追加。

---

## 2. ドメイン段階展開戦略

### 2.1 Phase 0（MVP）: 4 ドメイン

| ドメイン | Agent | Navigator | 選定理由 |
|---------|:-----:|:---------:|---------|
| Banking | ✅ svc-banking | ✅ | 来日直後の最重要ニーズ。AHA モーメント |
| Visa | ✅ svc-visa | ✅ | 全外国人が直面する高複雑度タスク |
| Medical | ✅ svc-medical | ✅ | 言語障壁が最も深刻。緊急性が高い |
| Admin | — (Ph1) | ✅ 基本のみ | Navigator コンテンツは提供、Agent は Phase 1 |

**+ svc-concierge**: 全ドメインの意図分類 + routing + 汎用 Q&A

### 2.2 Phase 1（v1.0、MVP +3ヶ月）: +4 ドメイン

| ドメイン | Agent | Navigator | 追加理由 |
|---------|:-----:|:---------:|---------|
| Housing | ✅ svc-housing | ✅ | 物件探し・契約は来日後の大きなペイン |
| Work | ✅ svc-work | ✅ | 労働法・社保は複雑で AI 支援の価値大 |
| Admin | ✅ svc-admin（昇格） | ✅ 完全版 | 転入届・マイナンバー等。Agent 化で品質向上 |
| Transport | ✅ svc-transport | ✅ | IC カード・免許は日常生活の基盤 |

### 2.3 Phase 1+: Food ドメイン
- Food Navigator: ハラール・ベジタリアン対応、食材入手、外食Tips
- AI Chat で食事相談に対応（svc-concierge が回答）

---

## 3. ユーザー獲得戦略

### 3.1 二層ファネル: Navigator (SEO) → AI Chat (Hook) → 課金

```
┌─────────────────────────────────────────────┐
│ Layer 1: Navigator (SEO 流入)                │
│                                              │
│  "How to open bank account in Japan"         │
│  "日本 ビザ更新 方法"                          │
│  "外国人 病院 英語"                            │
│      ↓ 検索流入（ゲストでも閲覧可）             │
│      ↓ CTA: 「AI に詳しく聞いてみる」           │
├─────────────────────────────────────────────┤
│ Layer 2: AI Chat (Hook + Conversion Driver)  │
│                                              │
│  Free: 5回/日 → 「もっと質問したい」            │
│      ↓ 回数制限ヒット                          │
│      ↓ Standard ¥720/月 への導線              │
│      ↓ or 従量チャージ ¥360/100回              │
├─────────────────────────────────────────────┤
│ Layer 3: Retention (Auto Tracker)            │
│                                              │
│  AI が生成した TODO → 定期的にアプリを開く        │
│  → 追加の質問 → 更なる Chat 利用               │
│  → Premium ¥1,360/月 へのアップグレード         │
└─────────────────────────────────────────────┘
```

### 3.2 チャネル × 期待効果

| チャネル | CAC | ボリューム | 初期効果 | 長期効果 | AI Chat との親和性 |
|---------|-----|----------|---------|---------|:------------------:|
| Reddit コミュニティ | ¥0 | 中 | ◎ | ○ | ◎ |
| SEO（多言語 Navigator 記事） | ¥300 | 大 | △ | ◎ | ◎ |
| Facebook 外国人グループ | ¥0 | 大 | ◎ | ○ | ○ |
| Twitter/X | ¥200 | 中 | ○ | ○ | ○ |
| App Store ASO | ¥100 | 大 | ○ | ◎ | ◎ |
| Google 広告 | ¥2,000 | 大 | ○ | ○ | ○ |
| 在留外国人支援団体連携 | ¥0 | 中 | ○ | ◎ | ○ |
| 日本語学校提携 | ¥0 | 中 | ○ | ◎ | ○ |

### 3.3 Phase 0 の重点チャネル（予算 ¥250K/月）

| チャネル | 月額予算 | 施策 |
|---------|---------|------|
| Reddit r/japanlife | ¥0 | 有用情報投稿 → 「AI に聞いてみた」体験シェア |
| Facebook グループ | ¥0 | 5言語別グループで「AI 相談」の体験談を投稿 |
| SEO ブログ（Navigator 連動） | ¥50K | Navigator コンテンツの Web 版を SEO 記事化 |
| Twitter/X 広告 | ¥50K | 在日外国人向けターゲティング |
| Google 広告 | ¥100K | "Japan bank account foreigner" "Japan visa renewal" |
| ASO 最適化 | ¥50K | App Store/Google Play キーワード最適化 |

---

## 4. 課金コミュニケーション戦略

### 4.1 Free → Standard 転換シナリオ

**トリガー**: AI Chat 5回/日の制限到達

**UI フロー**:
```
[ユーザー] 6回目の Chat を送信
    ↓
[アプリ] 「本日の無料 Chat 回数を使い切りました」
    ├── Option A: Standard プラン (¥720/月) — 300回/月 + 広告なし
    ├── Option B: 従量チャージ (¥360/100回) — 今すぐ追加
    └── Option C: 明日また無料で使う
    ↓
[追加メッセージ] 「Standard なら 1日あたり約¥24。コーヒー半杯分で生活の不安を解消。」
```

### 4.2 Standard → Premium アップセル

**トリガー**: Standard の 300回/月上限に近づいた時（残り 30回以下）

**UI フロー**:
```
[アプリ] 「今月の残り Chat 回数: 28回」
    ├── Option A: Premium (¥1,360/月) にアップグレード — 無制限
    ├── Option B: 従量チャージ (¥180/50回) で追加
    └── Option C: 来月リセットを待つ
```

### 4.3 価格訴求ポイント

| ティア | 訴求メッセージ | ターゲット |
|--------|-------------|-----------|
| Standard ¥720 | 「1日¥24。電車の乗り換え検索より安い」 | Free ヘビーユーザー |
| Premium ¥1,360 | 「行政書士に1回相談すると ¥5,000〜。AI なら月額で何度でも」 | 複雑な手続きを抱えるユーザー |
| 従量 ¥360/100回 | 「月額不要、使いたい時だけ」 | サブスク嫌いのユーザー |

---

## 5. 競合差別化（AI ファースト・ポジショニング）

### 5.1 Substitutability Analysis（代替可能性分析）

| コア機能 | 既存代替手段 | 代替の弱点 | 自社の増分価値 | 護城河 |
|---------|------------|-----------|-------------|--------|
| AI Chat (生活相談) | ChatGPT / Gemini | 日本の行政に非特化、RAG なし、パーソナライズなし | 8ドメイン特化 RAG + 在留資格・国籍連携 + Tracker 自動生成 | 🟡 中（RAG の質で差別化） |
| Banking ガイド | Google 検索 / Reddit | 断片的、古い情報、個人の状況に非対応 | ウィザード形式 + 銀行比較 + 書類チェックリスト | 🟢 高 |
| Visa ガイド | 入管庁サイト / 行政書士 | 日本語のみ、複雑、高コスト（行政書士 ¥5万〜） | 多言語 AI + 無料アクセス + 期限管理 | 🟢 高 |
| 医療アクセス | Google Maps / AMDA | 多言語対応病院の検索困難 | 症状→診療科 AI 分類 + 受診フレーズ生成 | 🟡 中 |
| 書類翻訳 | Google Translate / ChatGPT | 行政書類の文脈理解が浅い | ~~Doc Scanner~~ → AI Chat 画像送信で統合 | 🟡 中 |
| コミュニティ Q&A | Reddit / Facebook | ~~冷スタ問題~~ → AI が直接回答するため不要 | — | — |

### 5.2 vs. ChatGPT / Gemini（汎用 AI の脅威）

**ChatGPT が日本の外国人生活に対応する可能性への防御策**:

| 差別化軸 | 自社 | ChatGPT |
|---------|------|---------|
| ドメイン知識 | 8ドメイン × 専門 Agent + 公式ソース RAG | 汎用知識。日本の行政に特化していない |
| パーソナライズ | 在留資格・国籍・地域に基づく回答 | ユーザープロフィールなし |
| アクション連携 | Auto Tracker 生成 + 手続きガイド | 情報提供のみ |
| Navigator (SEO) | ドメイン別構造化コンテンツ + AI Chat 連動 | なし |
| 更新性 | knowledge files の定期更新 + web_search 補完 | 学習データのカットオフに依存 |
| 価格 | Free 5回/日 → Standard ¥720 | ChatGPT Plus $20/月（≈ ¥3,000） |

**核心**: ChatGPT は「何でも聞ける」が「日本での生活」に最適化されていない。当社は「日本で暮らす外国人」に100%フォーカスし、ドメイン知識 + パーソナライズ + アクション連携で差別化する。

### 5.3 vs. 既存の外国人支援アプリ

| 競合 | 特徴 | 自社の優位性 |
|------|------|------------|
| yolo japan | 求人特化 | 生活全般をカバー。AI Chat で相談可能 |
| Guidable | ニュース・求人 | AI ファースト。対話型で個別回答 |
| JASSO | 留学生特化 | 全在留資格対応。8ドメイン |
| 各自治体アプリ | 地域限定 | 全国対応。多言語。AI 対話 |

---

## 6. Acquisition Funnel Design

### 6.1 完全ファネル: 認知 → 試用 → 登録 → 課金

```
                    ┌──────────────────┐
                    │   AWARENESS      │
                    │                  │
   SEO 記事 ───────>│  Navigator       │<──── Google 広告
   Reddit  ────────>│  (Web 版)        │<──── SNS
   Facebook ───────>│                  │<──── ASO
                    └────────┬─────────┘
                             ↓
                    ┌──────────────────┐
                    │   TRIAL          │
                    │                  │
                    │  AI Chat 体験    │  ← ゲスト: Navigator のみ
                    │  (Free 5回/日)   │  ← 登録: AI Chat 利用可
                    │                  │
                    └────────┬─────────┘
                             ↓
                    ┌──────────────────┐
                    │   REGISTRATION   │
                    │                  │
                    │  Firebase Auth   │  ← メール or ソーシャル
                    │  プロフィール設定  │  ← 在留資格・国籍・地域
                    │                  │
                    └────────┬─────────┘
                             ↓
                    ┌──────────────────┐
                    │   CONVERSION     │
                    │                  │
                    │  回数制限到達     │  ← 5回/日 ヒット
                    │  Standard ¥720   │  ← or 従量 ¥360/100回
                    │  Premium ¥1,360  │  ← ヘビーユーザー
                    │                  │
                    └──────────────────┘
```

### 6.2 App Store 提出戦略

**カテゴリ**: Lifestyle（ライフスタイル）> サブカテゴリなし
- 「Education」も候補だが、「Lifestyle」の方が生活全般のイメージに合致
- 「Travel」は短期滞在のイメージが強いため除外

**キーワード方針**:
- EN: "japan life guide", "japan foreigner", "japan visa", "japan bank account", "AI life assistant"
- JA: "外国人 生活", "在留資格", "AI アシスタント"
- 各言語でローカライズ

**スクリーンショット構成**（5枚）:
1. AI Chat 画面（多言語対応を強調）
2. Banking Navigator（口座開設ウィザード）
3. Visa Navigator（手続きフロー）
4. Auto Tracker（自動生成 TODO）
5. Emergency Guide（安心感の訴求）

**段階的ロールアウト**:
- Phase 0: 日本の App Store のみ（主ターゲット市場）
- Phase 1: 海外の App Store にも展開（在日前の情報収集ニーズ）

### 6.3 Web Demo / LP

**ランディングページの役割**:
- SEO 流入の受け皿（Navigator コンテンツの Web 版）
- AI Chat のデモ体験（制限付き、登録不要で1回お試し）
- App Store / Google Play へのダウンロード導線

**Flutter Web を活用**:
- Navigator コンテンツは Flutter Web でも閲覧可能
- AI Chat は Web 版でも利用可能（PWA 対応）
- LP は別途作成（SEO 最適化のため SSR が必要な場合）

---

## 7. ローンチタイムライン

### 7.1 Phase 0 ローンチ（MVP、3 weeks）

> PHASE0_DESIGN.md §7 準拠

```
Week 1: 基盤構築
├── Day 1-2: svc-concierge + svc-banking 作成
├── Day 3: API Gateway scaffold (FastAPI + Firebase Auth)
├── Day 4-5: 全 4 agent の knowledge/ ファイル作成
└── 目標: "openclaw agent --agent svc-banking --json" 動作確認

Week 2: 拡張 + Flutter
├── Day 1-2: svc-visa + svc-medical 追加
├── Day 3-4: Flutter Chat UI + Navigator UI + API 接続
├── Day 5: Tracker 自動生成 + 結合テスト
└── 目標: Flutter ↔ API Gateway ↔ OC の E2E 動作

Week 3: 品質 + デプロイ
├── Day 1-2: 知識庫拡充 + Access Boundary 実装
├── Day 3: E2E テスト + パフォーマンス確認
├── Day 4: Backend deploy (VPS or Fly.io)
├── Day 5: App Store 提出準備
└── 目標: Production deploy + App Store 審査提出

Week 4: ローンチ + マーケティング開始
├── App Store / Google Play 公開
├── Reddit + Facebook + SNS 告知開始
├── Google 広告開始
└── SEO 記事（初回 5 本）公開
```

### 7.2 Phase 1 展開（v1.0、MVP +3ヶ月）

```
Month 1-2: Phase 1 Agent 開発
├── svc-housing + svc-work 作成 + knowledge/ 構築
├── svc-admin + svc-transport 作成 + knowledge/ 構築
├── Navigator コンテンツ拡充（8ドメイン完成）
└── svc-concierge routing 拡張（8ドメイン対応）

Month 3: Phase 1 リリース
├── 8ドメイン完全版リリース
├── +5言語追加準備
├── B2B プラン準備開始
└── SEO 記事（累計 30 本）
```

---

## 8. パートナーシップ戦略

### 8.1 提携候補（ピボット後、優先度更新）

| パートナー | 連携内容 | 優先度 | アプローチ |
|-----------|---------|--------|-----------|
| **行政書士事務所（3-5社）** | AI Chat からの紹介先 | ★★★★★ | MVP前に確保。紹介手数料の合意 |
| **ネット銀行（楽天/住信SBI）** | 口座開設アフィリエイト | ★★★★ | 公式アフィリプログラム |
| **日本語学校** | 留学生への紹介 | ★★★ | 無料導入を提案 |
| **登録支援機関** | 特定技能外国人への導入 | ★★★★ | B2B プラン提案（Phase 2） |
| **外国人支援NPO** | 紹介チャネル | ★★★ | Free 版の提供 |
| **自治体多文化共生課** | 公式ツール採用 | ★★ | 実績構築後 |

---

## 9. コンテンツ / マーケティング計画

### 9.1 SEO 記事（Phase 0 で 10 記事、Phase 1 で累計 30 記事）

**Navigator コンテンツと連動**: 静的ガイドの Web 版を SEO 記事として公開し、AI Chat への導線を作る。

| 記事テーマ | 言語 | 想定KW | 月間検索 | 対応ドメイン |
|-----------|------|--------|---------|------------|
| How to open bank account in Japan as foreigner | EN | japan bank account foreigner | 5,000+ | Banking |
| Japan visa renewal guide 2026 | EN | japan visa renewal | 4,000+ | Visa |
| Renting apartment in Japan as foreigner | EN | japan apartment foreigner | 4,000+ | Housing |
| Health insurance in Japan for foreigners | EN | japan health insurance foreigner | 3,000+ | Medical |
| How to see a doctor in Japan without Japanese | EN | doctor japan english | 2,000+ | Medical |
| 外国人の銀行口座開設ガイド | JA+多言語 | 外国人 口座開設 | 3,000+ | Banking |
| 在留期間更新の手続き方法 | JA+多言語 | 在留期間更新 | 2,000+ | Visa |
| 日本での確定申告（外国人向け） | JA+多言語 | 外国人 確定申告 | 1,500+ | Work |
| 外国人の賃貸契約ガイド | JA+多言語 | 外国人 賃貸 | 2,000+ | Housing |
| IC カード・定期券ガイド | JA+多言語 | IC カード 外国人 | 1,000+ | Transport |

### 9.2 SNS 戦略

| プラットフォーム | 投稿頻度 | コンテンツ |
|----------------|---------|-----------|
| Reddit r/japanlife | 週1回 | 「AI に聞いてみた」シリーズ — 銀行・ビザ・医療の tips |
| Twitter/X | 日1回 | Tips、ニュース、AI Chat のユースケース紹介 |
| Facebook グループ | 週2回 | 5言語別グループで情報提供 |
| Note.com | 月2回 | 深い分析記事（日本語、外国人支援者向け） |

---

## 10. リスク対策タイムライン

| リスク | 対策 | 期限 |
|--------|------|------|
| 行政書士法 | 弁護士に相談、「情報提供」の範囲確認、免責事項設計 | **MVP 前（Week 1）** |
| AI 精度 | knowledge/ ファイルの品質チェック、memory_search 精度テスト | **Week 2** |
| 多言語品質 | 主要5言語でネイティブチェック | **Week 3** |
| 個人情報保護 | Privacy Policy + ToS 作成 | **Week 3** |
| App Store リジェクト | Apple ガイドライン事前確認（特に IAP 周り） | **Week 3** |
| OC 障害 | API Gateway にフォールバック（直接 Anthropic API）設計 | **Phase 1** |

---

## 11. 定期レビュースケジュール

| 時期 | レビュー内容 |
|------|------------|
| 毎週 | KPI ダッシュボード確認（DAU, DL数, 課金率, Chat 利用率） |
| 月次 | P/L 実績 vs 計画、AI 回答品質レポート、ユーザーフィードバック |
| 四半期 | 事業計画見直し、知識ファイル更新、競合動向分析 |
| 半年 | Go/No-Go 再判定、Phase 移行判断 |

---

## 変更履歴
- 2026-02-15: 初版作成
- 2026-02-16: Z レビュー APPROVED
- 2026-02-17: Phase 0 プロダクトピボット反映（AI Concierge 中心化 / 課金体系再構築 / OC Runtime）
