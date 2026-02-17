# GOTCHAS.md - プロジェクト踩坑記録

> Workers はタスク実行前にこのファイルを読むこと。新しい問題が見つかったら更新すること。

## Flutter / Dart

- **l10n**: 全 UI テキストは ARB ファイル経由。ハードコード文字列禁止（英語エラーメッセージのみ例外）
- **drift**: キャッシュ専用。書き込みは常に API 経由。SSOT はサーバー DB
- **iOS 優先デザイン**: CupertinoNavigationBar 等を活用。Android は Material 3

## Backend / API

- **Firebase Auth ID Token**: 有効期限 1 時間。Cloudflare Workers で JWT 検証
- **Free/Premium 制限値**: BUSINESS_RULES.md §2 に一元定義。コードにハードコード禁止
- **免責事項**: AI チャット・Visa Navigator・Medical Guide の全レスポンスに必須。省略不可
- **ソース引用**: AI レスポンスには RAG 取得ドキュメントの出典 URL を必ず添付
- **PII**: ログに個人情報（メール、国籍、在留資格等）を出力しない

## データ

- **多言語 JSONB**: 5 言語キー (en/zh/vi/ko/pt) すべて含む。欠損言語は en にフォールバック
- **ソフトデリート対象**: profiles, chat_sessions, document_scans, community_posts, community_replies, user_procedures
- **ソフトデリート非対象**: chat_messages, community_votes, daily_usage, knowledge_sources, banking_guides, visa_procedures, admin_procedures, subscriptions
- **`deleted_at IS NOT NULL`** のレコードは API レスポンスに含めない

## Stripe / 課金

- **subscription_tier の更新**: Stripe Webhook のみが SSOT。クライアントやバッチから直接更新禁止
- **金額計算**: Flutter でしない。Stripe + バックエンドが管理

## セキュリティ

- **Firebase Admin SDK 秘密鍵**: バックエンドのみ。クライアントに含めない
- **Claude API / Cloud Vision API**: クライアントから直接呼び出し禁止。必ず AI Service 経由

## 開発環境（他プロジェクトの教訓）

- **Dev server と Worker の同時実行禁止**: webpack/ビルドキャッシュ損坏の原因（過去 3 回発生）
- **Dev server 起動前**: 必ず `rm -rf .next` 等のキャッシュクリア実行（本プロジェクトは Flutter なので `.dart_tool/` 等に注意）

## Flutter Web 截图（E2E テスト）

- **CanvasKit 非同期ロード**: Flutter Web は CanvasKit エンジンを非同期でロードする。`page.goto()` + `networkidle` だけでは不十分。**必ず `time.sleep(8)` 以上**を入れること
- **`--disable-gpu` 禁止**: Playwright の `chromium.launch()` に `--disable-gpu` を渡すと Canvas 渲染が壊れる
- **截图サイズチェック**: 正常な截图は 10KB 以上。< 5KB は白屏 → 即やり直し
- **截图保存先**: 必ずプロジェクト内 `artifacts/epics/<epic>/features/<feature>/screenshots/`。agent workspace への保存禁止
- **推奨手順**: `flutter build web --release` → `python3 -m http.server 3200` → Playwright sync API + sleep(8)
