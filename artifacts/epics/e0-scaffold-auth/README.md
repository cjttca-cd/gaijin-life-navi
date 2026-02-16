# Epic: E0 — プロジェクト骨格 + 認証

## Goal
Monorepo 構成でプロジェクトの骨格を構築し、Firebase Auth ベースの認証フローを End-to-End で動作させる。M0 完了 = 他の全機能の前提条件が揃う。

## Milestone
M0（architecture/DEV_PHASES.md）

## Non-goals
- AI Chat Engine（M1）
- UI デザインの洗練（M0 は機能骨格のみ）
- CI/CD パイプライン構築（手動デプロイで十分）

## Features
| Feature | Status | Worker |
|---------|--------|--------|
| scaffold-auth | 🔲 未着手 | coder (2 steps) |

## 受入基準（DEV_PHASES.md M0 より）
- [ ] Flutter アプリが iOS/Android/Web で起動する
- [ ] Email/Password で登録・ログイン・ログアウトが動作する
- [ ] 未ログインは認証必須画面にアクセスできない（go_router redirect）
- [ ] profiles テーブルにユーザーデータが保存される
- [ ] 5 言語の切り替えが動作する（UI テキストが切り替わる）
- [ ] API Gateway 経由で App Service にリクエストが到達する
