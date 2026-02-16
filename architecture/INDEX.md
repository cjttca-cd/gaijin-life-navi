# 在日外国人生活ナビ AI — Architecture Index

## 一句話目標

在日外国人が日本での生活手続きを AI と対話しながら解決できる多言語プラットフォームを構築する。

## SSOT 原則

- 各文書は各自の領域における唯一の真実源 (Single Source of Truth)
- 文書間の矛盾 = アーキテクチャバグ → PM/Z に報告
- strategy/ の事業方針には従う（技術で覆さない）

## 分層閲覧順序

### 最小開工セット（PM 初期化 + Coder 骨格構築に十分）

1. INDEX.md（本ファイル）
2. SYSTEM_DESIGN.md（技術全景）
3. DECISIONS.md（確定事項・デフォルト値）
4. DATA_MODEL.md（データ構造）

### 機能開発時に追加

5. API_DESIGN.md（API 契約）
6. BUSINESS_RULES.md（業務ロジック）
7. USER_STORIES.md（要件分解）

### 受入・QA 時に追加

8. DEV_PHASES.md（マイルストーン・検証方法）
9. MVP_ACCEPTANCE.md（受入チェックリスト）

---

## 全文書共通の約定

### エラーフォーマット

すべての API エラーは以下の統一形式で返す:

```json
{
  "error": {
    "code": "ERROR_CODE_SNAKE_UPPER",
    "message": "Human-readable message in request language",
    "details": {}
  }
}
```

### 命名規則

| 対象 | ルール | 例 |
|------|--------|-----|
| DB テーブル名 | snake_case, 複数形 | `chat_sessions`, `community_posts` |
| DB カラム名 | snake_case | `user_id`, `created_at` |
| API パス | kebab-case, 複数形 | `/api/v1/chat/sessions` |
| API パラメータ | snake_case | `session_id`, `page_size` |
| Dart 変数 | camelCase | `chatSession`, `userId` |
| Dart クラス | PascalCase | `ChatSession`, `UserProfile` |
| Dart ファイル | snake_case | `chat_session.dart`, `user_profile.dart` |
| Dart 定数 | camelCase | `defaultPageSize`, `maxChatLength` |
| Python 変数/関数 | snake_case | `chat_session`, `get_user` |
| Python クラス | PascalCase | `ChatEngine`, `RAGPipeline` |
| 環境変数 | SCREAMING_SNAKE_CASE | `FIREBASE_PROJECT_ID`, `CLAUDE_API_KEY` |
| i18n キー (ARB) | camelCase | `welcomeMessage`, `sendButton` |

### 共通フィールド（全テーブル共通）

| フィールド | 型 | 備考 |
|-----------|------|------|
| `id` | UUID (PK) | UUID v4 生成 |
| `created_at` | timestamptz | NOT NULL, DEFAULT `now()` |
| `updated_at` | timestamptz | NOT NULL, DEFAULT `now()`（トリガーまたはアプリ層で自動更新） |

- `deleted_at` (timestamptz, NULLable) はソフトデリート対象テーブルのみ付与
- ソフトデリート対象: `profiles`, `chat_sessions`, `document_scans`, `community_posts`, `community_replies`, `user_procedures`
- ソフトデリート非対象（物理削除 or 不変）: `chat_messages`, `community_votes`, `daily_usage`, `knowledge_sources`, `banking_guides`, `visa_procedures`, `admin_procedures`, `subscriptions`

### タイムゾーン

- DB: すべて UTC (timestamptz)
- API: ISO 8601 形式（`2026-02-16T02:25:00Z`）
- Flutter: ユーザーのローカルタイムゾーンで表示

---

## 範囲境界（MVP で「やらないこと」）

### 明確に除外するもの

| # | 除外項目 | 理由 | 将来対応 |
|---|---------|------|---------|
| X1 | B2B 企業ダッシュボード | Phase 2 スコープ (product-spec §5.1) | v1.5 |
| X2 | Premium+ 1 対 1 チャットサポート | 運用体制未整備 | v1.5 |
| X3 | Medical Guide 完全版（病院検索連携） | 外部 API 連携が必要 | v1.0 |
| X4 | 行政書士マッチング機能 | 紹介先確保が前提 (MVP では LP レベル) | v1.0 |
| X5 | AI 音声対話 | 技術的複雑性 | v2.0 |
| X6 | 住居検索・求人連携 | 外部 API 連携 | v2.0 |
| X7 | マイナンバー連携 | 行政 API 未公開 | v2.5 |
| X8 | プッシュ通知 | MVP では不要 | v1.0 |
| X9 | 完全オフライン対応 | 複雑性（drift でローカルキャッシュは実装） | v1.5 |
| X10 | A/B テスト基盤 | MVP 後に導入 | v1.0 |
| X11 | 管理画面 (Admin Panel) | MVP では DB 直接操作 + 管理用スクリプトで代替 | v1.0 |
| X12 | 5 言語以外の言語 | MVP は EN/ZH/VI/KO/PT | v1.0 (+5 言語) |

### MVP に含めるが最小実装にするもの

- **Medical Guide**: 緊急時ガイド（119 の呼び方）+ 症状翻訳フレーズ集のみ。静的コンテンツ。
- **Expert Matching**: 行政書士事務所の紹介ページ（LP レベル、外部リンクのみ）

---

## 建議する最初の Epic + Pipeline パターン

### 推奨開始 Epic: **E0 — プロジェクト骨格 + 認証**

```
Pipeline パターン:
  PM → Coder (Flutter scaffold + Firebase Auth) → Coder (API scaffold) → QA
  並行: Designer → Flutter theme + l10n ARB files
```

**理由**: 認証とプロジェクト骨格は他の全機能の前提条件。M0 完了後に M1（AI Chat）に進む。

### Epic 順序

```
E0: 骨格 + 認証 (M0)
  ↓
E1: AI Chat Engine (M1) ← コアバリュー
  ↓
E2: Banking Navigator (M2)
E3: Visa Navigator (M2)     ← 並行可能
E4: Admin Tracker (M2)
  ↓
E5: Document Scanner (M2)
  ↓
E6: Community Q&A (M3)
E7: 課金・サブスク (M3)      ← 並行可能
  ↓
E8: 統合テスト + ローンチ準備 (M4)
```

---

## リスク・待確認事項

| # | 項目 | 状態 | 影響範囲 |
|---|------|------|---------|
| R1 | 行政書士法のリーガルチェック結果 | strategy/ で Week 1-2 に並行実施予定 | 免責文言、Visa Navigator の提供範囲 |
| R2 | Cloud Vision API の日本語 OCR 精度（手書き含む） | 未検証 | Document Scanner の UX |
| R3 | Stripe の日本円サブスク対応の詳細仕様 | 確認済み（対応可） | 課金フロー |

> R1 は法務判断であり技術側での解決不可。免責文言を UI に組み込む設計は完了済み（BUSINESS_RULES.md §6）。リーガルチェック結果により Visa Navigator の「情報提供」範囲が変わる可能性があるが、現設計は「情報提供のみ・代行なし」で安全側に倒している。
