# PROJECT_MEMORY — gaijin-life-navi

## Now
E0 + E1 + E2〜E5/E8 完了。M0〜M2 マイルストーン達成。次は M3（Community Q&A + 課金）へ。

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
| E0: 骨格 + 認証 | M0 | ✅ 完了 | ✅ Backend scaffold (task-018) → ✅ Flutter scaffold (task-019) |
| E1: AI Chat Engine | M1 | ✅ 完了 | ✅ AI Service backend (task-020b) → ✅ Flutter Chat UI + Onboarding (task-021) |
| E2: Banking Navigator | M2 | ✅ 完了 | 銀行一覧, レコメンド, 口座開設ガイド |
| E3: Visa Navigator | M2 | ✅ 完了 | 手続き一覧, 詳細ガイド |
| E4: Admin Tracker | M2 | ✅ 完了 | チェックリスト, 進捗管理, 手続き追加 |
| E5: Document Scanner | M2 | ✅ 完了 | OCR + 翻訳 + 説明, 履歴 |
| E6: Community Q&A | M3 | 🔲 未着手 | 投稿 CRUD, 返信, 投票, AI モデレーション |
| E7: サブスクリプション | M3 | 🔲 未着手 | Stripe Checkout, Webhook, プラン管理 |
| E8: Medical Guide | M2 | ✅ 完了 | 緊急時ガイド, フレーズ集 |
| E9: プロフィール・設定 | M4 | 🔲 未着手 | プロフィール編集, 言語変更, アカウント削除 |
| E10: LP | M4 | 🔲 未着手 | Astro LP, 5 言語, SEO |
| E11: 統合テスト + ローンチ | M4 | 🔲 未着手 | E2E テスト, ビルド, 本番デプロイ |

### Milestone Dependencies
```
M0 (骨格+認証) → M1 (AI Chat) → M2 (ナビゲーター群) → M3 (Community+課金) → M4 (統合+ローンチ)
```

## Next
M3（Community Q&A + Stripe 課金）の Epic 計画 → Pipeline 設計 → 実行。

## Decisions
| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-02-16 | プロジェクト初期化 | Architect + Strategist 産出物を基に PM artifacts 作成 |
| 2026-02-16 | 技術スタック: Flutter + FastAPI + Firebase Auth | Architect 確定（DECISIONS.md）。strategy の React Native → Flutter に変更済み |
| 2026-02-16 | Monorepo 構成（app/backend/infra/lp） | Architect SYSTEM_DESIGN.md §6 確定 |
| 2026-02-16 | Epic 順序: E0→E1→E2〜E5(M2)→E6〜E7(M3)→E8〜E11(M4) | Architect DEV_PHASES.md ベース |
| 2026-02-16 | E0 Pipeline 開始: Step1=Backend scaffold, Step2=Flutter scaffold | pipeline-004 |
| 2026-02-16 | Step 1 完了（task-018）: FastAPI + Alembic + CF Workers scaffold | 検証済み（import OK, migration OK, 6 endpoints） |
| 2026-02-16 | Step 2 完了（task-019）: Flutter App scaffold + Auth + l10n | 検証済み（analyze OK, 17 tests passed, web build OK） |
| 2026-02-16 | E0 Pipeline 完了（pipeline-004） | Backend + Flutter 基盤構築完了 |
| 2026-02-16 | E1 Pipeline 開始+完了（pipeline-005） | AI Service + Flutter Chat UI |
| 2026-02-16 | Step 1 完了（task-020b）: AI Service Chat Backend | 7 endpoints, SSE streaming, RAG mock, daily limit |
| 2026-02-16 | Step 2 完了（task-021）: Flutter Chat UI + Onboarding | 125 l10n keys × 5 langs, 40 tests, SSE parser |
| 2026-02-16 | M2 Pipeline 完了（pipeline-006） | Backend + Flutter UI 全 5 機能 |
| 2026-02-16 | Step 1 完了（task-022）: M2 Backend 全 API | 10 tables, 29 endpoints, seed data |
| 2026-02-16 | Step 2 完了（task-023）: M2 Flutter UI 全画面 | 12 画面, 73 tests, 51 files |

## Glossary
| Term | Definition |
|------|-----------|
| RAG | Retrieval-Augmented Generation — ナレッジベースから関連情報を検索し LLM に注入 |
| SSE | Server-Sent Events — AI チャットのストリーミングレスポンス方式 |
| ARB | Application Resource Bundle — Flutter の多言語ファイル形式 |
| drift | Flutter 用の型安全 SQLite ORM（ローカルキャッシュ専用） |
| ISA | 出入国在留管理庁（Immigration Services Agency） |
| AHA モーメント | ユーザーが製品の価値を実感する瞬間（本プロジェクトでは Banking Navigator） |
