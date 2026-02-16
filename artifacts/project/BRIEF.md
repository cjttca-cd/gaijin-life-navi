# BRIEF — gaijin-life-navi

## Vision
在日外国人 396 万人が「日本で暮らすことの不安」をゼロにする。
AI と対話しながら生活手続きを解決できる多言語プラットフォーム。

## Owner
- **名前**: Z
- **ドメイン**: gaijin-life-navi.com（仮）
- **主要事業**:
  - 在日外国人向け AI 生活支援プラットフォーム
  - Freemium モデル（Free / Premium ¥500/月 / Premium+ ¥1,500/月）

## Target Users
1. **Chen Wei（技術者ペルソナ）** — エンジニアビザで来日、英語/中国語話者。銀行口座・ビザ更新・行政手続きに苦戦
2. **Nguyen Thi Lan（特定技能ペルソナ）** — ベトナム語話者、日本語限定的。公文書が読めない、医療アクセスに不安
3. **Kim Jihye（留学生ペルソナ）** — 韓国語話者。アルバイト資格・在留期間更新・国民健康保険の理解が必要

## Value Proposition
- **AI 対話式**: 静的ガイドではなく、個人の状況（国籍・在留資格・居住地域）に合わせたパーソナライズ回答
- **多言語ネイティブ**: MVP Day 1 から 5 言語（EN/ZH/VI/KO/PT）、AI 動的翻訳で 14 言語以上対応可能
- **手続き完結型**: 情報提供 + 「次に何をすべきか」のアクション提示
- **ワンストップ**: 銀行・ビザ・医療・行政・コミュニティを統合

## USP（Unique Selling Proposition）
- 汎用 ChatGPT との違い: 日本の行政手続き特化 RAG + ユーザープロフィールによるパーソナライズ
- 既存アプリとの違い: 「読む」ではなく「聞く」体験。会話の中で段階的に情報を提供

## Goals
1. MVP 3 ヶ月で 10,000 DL 達成
2. Free → Premium 転換率 8% 以上
3. 初回セッションの 60% が Banking Navigator を利用（AHA モーメント）
4. 月額ランニング ¥55,000 以内で運用

## Non-goals
- B2B 企業ダッシュボード（Phase 2 / v1.5）
- Premium+ 1 対 1 チャットサポート（Phase 2）
- AI 音声対話（v2.0）
- 住居検索・求人連携（v2.0）
- マイナンバー連携（v2.5）
- 管理画面 Admin Panel（v1.0 — MVP は DB 直接操作 + 管理スクリプトで代替）
- 5 言語以外の言語（v1.0 で +5 言語追加予定）

## リスク・待確認事項
| # | 項目 | 状態 | 影響 |
|---|------|------|------|
| R1 | 行政書士法のリーガルチェック | Week 1-2 で並行実施予定 | 免責文言、Visa Navigator の提供範囲 |
| R2 | Cloud Vision API の日本語 OCR 精度（手書き） | 未検証 | Document Scanner の UX |
| R3 | Stripe の日本円サブスク対応 | 確認済み（対応可） | 課金フロー |

## 参考文書
- strategy/product-spec.md — 事業仕様（Strategist 産出）
- architecture/INDEX.md — 技術全体像（Architect 産出）
