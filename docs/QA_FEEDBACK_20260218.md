# QA Feedback — 2026-02-18 本地結合テスト

> テスター: Z (手動)
> 環境: iPhone 16e Simulator, iOS, Backend 192.168.18.185:8000 (mock auth)
> Flutter commit: `b971d08`
> 開始時刻: 14:20 JST

## 発見した問題一覧

| # | 画面 | 重要度 | 内容 | 状態 |
|---|------|--------|------|------|
| 1 | ChatGuestScreen | 🔴 Critical | 中文選択なのにチャットゲスト画面が日本語表示。l10n が効いていない or ハードコード | 🔧 修正中 |
| 2 | LoginScreen | 🔴 Critical | Profile tab → Login にリダイレクト後、Bottom Nav が消える。他のページに戻れない（デッドエンド）。「欢迎回来」は未登録ユーザーに不適切 | 🔧 修正中 |
| 3 | ChatConversation | 🟡 Major | AI 応答前に空の吹き出し（content='' のエラーメッセージ）が表示される | ⏳ 待ち |
| 4 | SplashScreen→Login | ✅ Fixed | ゲストが Login に強制遷移 → Home 直行に修正済 (`357fe33`) | ✅ |
| 5 | ChatConversation | ✅ Fixed | 戻るボタンなし → AppBar leading 追加済 (`b971d08`) | ✅ |
| 6 | firebase_options | ✅ Fixed | dummy API key → flutterfire configure で修正済 | ✅ |

## 流程改善メモ

### 根因パターン
- **P1: l10n 未適用** — ハードコード文字列 or l10n key の言語カバー不足
- **P2: ナビゲーションデッドエンド** — ページ遷移後に戻る手段がない
- **P3: コンテキスト不適切** — 未登録ユーザーに「おかえり」等の既存ユーザー向けメッセージ

### 対策（実施済み）
- Designer AGENTS.md: ナビゲーション動線セクション追加
- Tester AGENTS.md: ユーザーフロー検証 F1-F6 必須化
- Coder AGENTS.md: Designer 動線指示の遵守ルール追加

### 対策（検討中）
- [ ] Pipeline に「人間 QA レビュー」ステップを入れるか
- [ ] Coder が l10n を全言語チェックする仕組み
- [ ] LoginScreen をフルスクリーンではなくモーダル/ボトムシートにする案
