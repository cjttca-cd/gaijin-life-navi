# PROJECT_MEMORY — gaijin-life-navi

## Now
プロジェクト初期化完了。Architect の設計文書（9 ファイル）と Strategist の事業文書（3 ファイル）を基に PM artifacts を作成済み。開発はまだ開始していない。

## Status

### Project Docs
| Document | Status |
|----------|--------|
| BRIEF.md | ✅ done |
| REQUIREMENTS.md | ✅ done |
| ARCHITECTURE.md | ✅ done |
| PROJECT_MEMORY.md | ✅ done (this file) |
| GOTCHAS.md | ✅ done |

### Architect Docs
| Document | Status |
|----------|--------|
| architecture/INDEX.md | ✅ 読込済 |
| architecture/SYSTEM_DESIGN.md | ✅ 読込済 → ARCHITECTURE.md に反映 |
| architecture/DECISIONS.md | ✅ 読込済 → ARCHITECTURE.md 制約に反映 |
| architecture/DATA_MODEL.md | ✅ 存在確認（Worker 共有用） |
| architecture/API_DESIGN.md | ✅ 存在確認（Worker 共有用） |
| architecture/BUSINESS_RULES.md | ✅ 存在確認（Worker 共有用） |
| architecture/USER_STORIES.md | ✅ 読込済 → REQUIREMENTS.md に反映 |
| architecture/DEV_PHASES.md | ✅ 読込済 → Epic 計画に反映 |
| architecture/MVP_ACCEPTANCE.md | ✅ 存在確認（最終受入用） |

### Strategy Docs
| Document | Status |
|----------|--------|
| strategy/product-spec.md | ✅ 読込済 → BRIEF.md に反映 |
| strategy/business-plan.md | ✅ 存在確認 |
| strategy/gtm-plan.md | ✅ 存在確認 |

### Epics（Architect DEV_PHASES.md ベース）
| Epic | Milestone | Status | Features |
|------|-----------|--------|----------|
| E0: 骨格 + 認証 | M0 | 🔵 進行中 | Flutter scaffold, Firebase Auth, FastAPI scaffold, API Gateway, 認証フロー, BottomNav, l10n 基盤 |
| E1: AI Chat Engine | M1 | 🔲 未着手 | AI Service, RAG, チャット CRUD, SSE ストリーミング, 日次制限, オンボーディング |
| E2: Banking Navigator | M2 | 🔲 未着手 | 銀行一覧, レコメンド, 口座開設ガイド |
| E3: Visa Navigator | M2 | 🔲 未着手 | 手続き一覧, 詳細ガイド |
| E4: Admin Tracker | M2 | 🔲 未着手 | チェックリスト, 進捗管理, 手続き追加 |
| E5: Document Scanner | M2 | 🔲 未着手 | OCR + 翻訳 + 説明, 履歴 |
| E6: Community Q&A | M3 | 🔲 未着手 | 投稿 CRUD, 返信, 投票, AI モデレーション |
| E7: サブスクリプション | M3 | 🔲 未着手 | Stripe Checkout, Webhook, プラン管理 |
| E8: Medical Guide | M2 | 🔲 未着手 | 緊急時ガイド, フレーズ集 |
| E9: プロフィール・設定 | M4 | 🔲 未着手 | プロフィール編集, 言語変更, アカウント削除 |
| E10: LP | M4 | 🔲 未着手 | Astro LP, 5 言語, SEO |
| E11: 統合テスト + ローンチ | M4 | 🔲 未着手 | E2E テスト, ビルド, 本番デプロイ |

### Milestone Dependencies
```
M0 (骨格+認証) → M1 (AI Chat) → M2 (ナビゲーター群) → M3 (Community+課金) → M4 (統合+ローンチ)
```

## Next
E0（プロジェクト骨格 + 認証）の Pipeline を計画・開始する。

## Decisions
| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-02-16 | プロジェクト初期化 | Architect + Strategist 産出物を基に PM artifacts 作成 |
| 2026-02-16 | 技術スタック: Flutter + FastAPI + Firebase Auth | Architect 確定（DECISIONS.md）。strategy の React Native → Flutter に変更済み |
| 2026-02-16 | Monorepo 構成（app/backend/infra/lp） | Architect SYSTEM_DESIGN.md §6 確定 |
| 2026-02-16 | Epic 順序: E0→E1→E2〜E5(M2)→E6〜E7(M3)→E8〜E11(M4) | Architect DEV_PHASES.md ベース |

## Glossary
| Term | Definition |
|------|-----------|
| RAG | Retrieval-Augmented Generation — ナレッジベースから関連情報を検索し LLM に注入 |
| SSE | Server-Sent Events — AI チャットのストリーミングレスポンス方式 |
| ARB | Application Resource Bundle — Flutter の多言語ファイル形式 |
| drift | Flutter 用の型安全 SQLite ORM（ローカルキャッシュ専用） |
| ISA | 出入国在留管理庁（Immigration Services Agency） |
| AHA モーメント | ユーザーが製品の価値を実感する瞬間（本プロジェクトでは Banking Navigator） |
