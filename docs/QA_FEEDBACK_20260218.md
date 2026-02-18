# QA Feedback — 2026-02-18 本地結合テスト

> テスター: Z (手動)
> 環境: iPhone 16e Simulator, iOS, Backend 192.168.18.185:8000
> 最新 commit: `41d9ca2`
> 開始時刻: 14:20 JST

## 発見した問題一覧

| # | 画面 | 重要度 | 内容 | 状態 |
|---|------|--------|------|------|
| 1 | 全体 Tab 命名 | 🟡 改善 | 「対話」→「AI 向導」に変更 | ✅ Fixed `40b3194` |
| 2 | 課金設計 | 🔴 仕様変更 | Free tier 毎日5回→登録時20回(lifetime) | ✅ Fixed `40b3194` |
| 3 | Navigator/Guide | 🔴 Critical | ガイド記事が全て日本語→多言語版が必要 | 📋 Z が指南を選定後対応 |
| 4 | LoginScreen | 🟢 Minor | 副題「登録以使用全部功能」不要→削除 | ✅ Fixed `e753548` |
| 5 | ProfileScreen | 🔴 Critical | ログイン後「我的」→ 加載失敗 | ✅ Fixed `d6786f9` (auto-create + JWT decode) |
| 6 | ChatListScreen | 🔴 Critical | 空の対話リスト表示+新規ボタン→Phase 0は直接対話に | ✅ Fixed `d6786f9` (直接ChatConversation) |
| 7 | Usage 不整合 | 🟡 Major | 対話4/5 vs Home 5/5 → 共有provider+API取得 | ✅ Fixed `d6786f9` (fetchUsageProvider) |
| 8 | 全体 UI | 🟡 改善 | iOS 26 glassmorphism 不足 | 📋 今後のpipeline時にDesigner指示 |
| 17 | TrackerScreen | 🔴 Critical | 「行政追踪」表示、「+添加」ボタン不在、機能全壊 | ✅ Fixed `30e6711` |
| 18 | HomeScreen | 🟡 Major | 「浏览指南」セクション不要→Tracker摘要に差替え | ✅ Fixed `30e6711` |
| 19 | Tracker 設計 | 🔴 仕様変更 | Tracker→本地Todo List（日付設定可、AI建議から一键追加） | ✅ Fixed `30e6711` |
| 20 | Subscription | 🟡 改善 | l10n 修正: 「AI図片分析」→「AI図片分析（向导对话中）」、「热门类别指南」→「部分指南」、「所有类别指南」→「所有指南」 | ✅ Fixed `41d9ca2` |
| 21 | HomeScreen | 🟡 改善 | 「查看热门指南」カードグリッド→左アクセントバーのリスト形式に変更 | ✅ Fixed `41d9ca2` |
| 22 | NavigateScreen | 🟡 改善 | 指南ページにクロスドメイン検索機能追加 | ✅ Fixed `41d9ca2` |
| 9 | ChatGuestScreen | 🟡 Major | 中文選択なのに日本語表示(l10n混在) | ✅ Fixed `6dffdd3` |
| 10 | LoginScreen | 🔴 Critical | Bottom Nav消失→デッドエンド+「欢迎回来」 | ✅ Fixed `6dffdd3` |
| 11 | SplashScreen | 🔴 Critical | ゲストがLoginに強制遷移 | ✅ Fixed `357fe33` |
| 12 | ChatConversation | 🟡 Major | 戻るボタンなし | ✅ Fixed `b971d08` |
| 13 | firebase_options | 🔴 Critical | dummy API key → SIGABRT crash | ✅ Fixed (flutterfire configure) |
| 14 | Backend | 🔴 Critical | mock auth残留→JWT全体がuidに | ✅ Fixed `0f45109` (真Firebase Auth切替) |
| 15 | Backend | 🟢 Cleanup | 旧ai_service/shared残留(2784行) | ✅ Fixed `0f45109` (削除) |
| 16 | ChatConversation | 🟡 Major | 戻るボタン→ChatListScreen→再push→無限ループ | ✅ Fixed `f6f5d70` (go homeに変更) |

## Z の決定事項

### #1 Chat tab 命名 → 「AI 向導」に決定
- 全5言語更新済み (zh/en/ko/vi/pt)

### #2 課金体系変更
- ❌ 旧: Free = 毎日5回（月150回 = 多すぎ）
- ✅ 新: Free = 新規登録時 **20回のみ**（使い切り、日次リセットなし）
- Standard ¥720 / Premium ¥1,360 / 従量パック → 変更なし

### #3 ガイド多言語
- 全公開ではなく**選定した数篇を5言語で用意**
- 静的コンテンツとしてフロントエンドに配信
- Z が指南を選定後に実施

### #6 対話機制 (Phase 0)
- **シングル対話**: Flutter側は本地メモリ、バックエンド側はOpenClaw session持続
- session_id = `app_{uid}_{domain}` で固定（同一ユーザー・同一ドメインは同一会話）
- 写真添付: Phase 0 未実装（UIボタンはdisabled表示）
- マルチ対話: Phase 1以降

### #8 iOS デザイン
- 今は Material 3 ベースのまま
- 今後の pipeline で Designer に iOS 最新推奨スタイルを指示

### #14 Firebase Auth
- mock auth 完全撤廃、真 Firebase Admin SDK で token 検証
- service account: `secrets/firebase-service-account.json`

## 流程改善（実施済み）

### Agent 改善 (3 agent 同時改修)
- **Designer AGENTS.md**: Part 1.5 ナビゲーション動線セクション追加
  - 全ページの AppBar 要素(戻るボタン有無)・遷移先・未認証ガード・デッドエンド禁止
- **Tester AGENTS.md**: ユーザーフロー検証 F1-F6 必須化
  - F1:ゲスト初回起動 F2:Tab巡回 F3:登録導線 F4:対話フロー F5:ナビ完全性 F6:認証ガード
  - 1つでもFAIL→テスト全体FAIL
- **Coder AGENTS.md**: Designer動線指示の遵守ルール追加
  - handoffに記載のない遷移を勝手に追加しない

### 根因パターン（識別済み）
- P1: l10n 混在（Coderが翻訳手書き→言語間混在）
- P2: ナビデッドエンド（遷移後に戻る手段なし）
- P3: コンテキスト不適切（未登録者に「おかえり」）
- P4: 仕様と実装の乖離（Free回数、ゲスト導線）
- P5: バックエンド連携未検証（Profile API不一致）
- P6: mock auth が production code に混入（PM判断ミス）

### LESSONS_LEARNED.md 更新済み
- ページ遷移デッドエンド + ゲスト導線バグの全経緯と対策を記録

### #17-19 Tracker 重設計 + 首頁レイアウト変更 (Z 指示 16:15)

**Z の原文フィードバック**:
1. 追踪器ページ：「行政追踪」表示、「+添加」と書いてあるのに+ボタンがない。機能もページも全然ダメ
2. 首頁の「浏览指南」は重複コンテンツで無意味。追踪機能の情報を表示すべき
3. 追踪機能 = シンプルな Todo List。日付設定可能、AI 向導の提案を一键登録、手動追加も可能。バックエンド不要

**Z 承認済み設計**:
- **Tracker = 純ローカル Todo List**（SharedPreferences）
- データ: `{id, title, memo, dueDate?, completed, createdAt}`
- ソース: ① AI 向導回答から一键追加 ② ユーザー手動追加
- 機能: 追加/完了/削除/日付ソート
- **首頁**: 「浏览指南」→ Tracker カード摘要に差替え
- **実装**: Pipeline 不使用、直接実装

## 流程改善（検討中）
- [ ] Pipeline に「人間 QA レビュー」ステップを入れるか
- [ ] Coder が l10n を全言語チェックする仕組み
- [ ] Guide 記事のマルチ言語対応方式
