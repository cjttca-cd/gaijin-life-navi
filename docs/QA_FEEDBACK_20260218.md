# QA Feedback — 2026-02-18 本地結合テスト

> テスター: Z (手動)
> 環境: iPhone 16e Simulator, iOS, Backend 192.168.18.185:8000 (mock auth)
> Flutter commit: `6dffdd3`
> 開始時刻: 14:20 JST

## 発見した問題一覧

| # | 画面 | 重要度 | 内容 | 状態 |
|---|------|--------|------|------|
| 1 | 全体 | 🟡 改善 | Chat tab の名称「対話」が汎用的すぎる → 日本生活専門 AI であることを強調する名前に | ⏳ 検討中 |
| 2 | 課金設計 | 🔴 仕様変更 | Free tier「毎日5回」は月150回で多すぎ → 新規登録時20回限り（使い切り）に変更 | ⏳ 要設計 |
| 3 | Navigator/Guide | 🔴 Critical | ガイド記事が全て日本語 → ユーザーの選択言語に対応すべき | ⏳ 要調査 |
| 4 | LoginScreen | 🟢 Minor | 副題「登録以使用全部功能」不要 → 削除 | 🔧 修正中 |
| 5 | ProfileScreen | 🔴 Critical | ログイン後「我的」→ 加載失敗、内容表示なし | ⏳ 要調査 |
| 6 | ChatListScreen | 🔴 Critical | ①写真添付不可 ②初回 Chat tab で過去会話に直行 ③戻ると「新規対話」画面だが過去の対話一覧なし ④マルチ対話の仕組みが未実装 | ⏳ 要設計 |
| 7 | Usage 表示不整合 | 🟡 Major | 対話画面 4/5 vs ホーム画面 5/5 — 使用回数カウントが同期していない | ⏳ 要調査 |
| 8 | 全体 UI | 🟡 改善 | iOS 26 のガラス感（glassmorphism）が感じられない — Design System に反映されているか確認 | ⏳ 要調査 |
| 9 | ChatGuestScreen | ✅ Fixed | 中文選択なのにチャットゲスト画面が日本語表示 (`6dffdd3`) | ✅ |
| 10 | LoginScreen | ✅ Fixed | Bottom Nav 消えてデッドエンド + 「欢迎回来」不適切 (`6dffdd3`) | ✅ |
| 11 | SplashScreen | ✅ Fixed | ゲストが Login に強制遷移 (`357fe33`) | ✅ |
| 12 | ChatConversation | ✅ Fixed | 戻るボタンなし (`b971d08`) | ✅ |
| 13 | firebase_options | ✅ Fixed | dummy API key → flutterfire configure で修正済 | ✅ |

## Z の方針・決定事項

### #1 Chat tab 命名
- 「対話」「AI 対話」は汎用的すぎる（ChatGPT/Gemini と差別化できない）
- **日本生活の専門 AI** であることを名前で表現すべき
- 候補検討中

### #2 課金体系変更
- ❌ 旧: Free = 毎日5回（月150回 = 多すぎ）
- ✅ 新: Free = 新規登録時 **20回のみ**（使い切り、日次リセットなし）
- Standard / Premium は既存のまま

### #6 マルチ対話の仕組み
- Phase 0 は **シングル対話** 設計（本地 state、バックエンド session key 固定）
- 今後マルチ対話にする場合: 本地に対話リスト保存 + バックエンド session ID 管理
- 写真添付: Phase 0 未実装（UI にはボタンあるが disabled）

### #8 デザイン
- iOS 26 glassmorphism 対応は Design System に含まれているか要確認
- 現状は Material 3 ベースで glass 効果なし

## 流程改善メモ

### 根因パターン
- **P1: l10n 未適用/混在** — Coder が翻訳を手書きして言語間混在
- **P2: ナビゲーションデッドエンド** — ページ遷移後に戻る手段がない
- **P3: コンテキスト不適切** — 未登録ユーザーに「おかえり」
- **P4: 仕様と実装の乖離** — Free tier の回数制限が仕様と実装で不一致
- **P5: バックエンド連携未検証** — Profile API が Flutter と噛み合っていない
- **P6: ガイド記事が静的日本語のみ** — l10n 対応されていない

### 対策（実施済み）
- Designer AGENTS.md: ナビゲーション動線セクション追加
- Tester AGENTS.md: ユーザーフロー検証 F1-F6 必須化
- Coder AGENTS.md: Designer 動線指示の遵守ルール追加

### 対策（検討中）
- [ ] Pipeline に「人間 QA レビュー」ステップを入れるか
- [ ] Coder が l10n を全言語チェックする仕組み
- [ ] Guide 記事のマルチ言語対応方式（バックエンド側 or フロント側）
- [ ] Design System に glassmorphism 指針を追加するか
