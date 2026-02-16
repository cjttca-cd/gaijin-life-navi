# Epic: E1 — AI Chat Engine（コアバリュー）

## Goal
AI Life Concierge のコア機能を構築する。ユーザーが多言語で質問し、RAG ベースのパーソナライズ回答をストリーミングで受け取れるようにする。

## Milestone
M1（architecture/DEV_PHASES.md）

## Non-goals
- Banking/Visa/Admin Navigator（M2）
- Community Q&A（M3）
- Stripe 課金統合（M3 — 制限メッセージの表示のみ M1 で実装）

## Dependencies
- M0 完了（認証基盤、profiles テーブル、daily_usage テーブル）✅

## Features
| Feature | Status | Worker |
|---------|--------|--------|
| chat-engine | 🔲 未着手 | coder (2 steps) |

## 受入基準（DEV_PHASES.md M1 より）
- [ ] オンボーディング完了 → プロフィール更新 + 5 大手続き自動追加
- [ ] チャットセッション作成・一覧・削除が動作する
- [ ] AI チャットがストリーミングで表示される
- [ ] 回答にソース引用 URL が含まれる
- [ ] 免責事項が表示される
- [ ] セッションタイトルが自動生成される
- [ ] Free ティアで 6 回目のメッセージに制限メッセージが表示される
- [ ] 残り回数がチャット画面に表示される
