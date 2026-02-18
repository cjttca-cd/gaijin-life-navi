# 開発フェーズ（マイルストーン）

> **必ず順番通りに実装。** スキップ・一括実装は禁止。
> 各マイルストーンの受入基準を全てクリアしてから次へ進む。
> Phase 0 = 3 週間。Phase 1 = 追加 Agent + デプロイ。

---

## Phase 0: MVP（3 週間）

### Week 1: 基盤構築（E0 + E1）

#### Day 1-2: Service Agent 作成 + OC Runtime 確認

**範囲:**
- svc-concierge + svc-banking の Agent 作成
  - workspace/AGENTS.md + IDENTITY.md + SOUL.md + TOOLS.md
  - workspace/knowledge/ に知識ファイル配置
  - OpenClaw config に agent 追加（tool 制限: web_search, web_fetch, read, memory_search, memory_get）
- 動作確認: `openclaw agent --agent svc-banking --json` テスト
- Session 持続性テスト: 同一 session ID で連続会話

**含まれるストーリー:** —（インフラ準備）

**産出物:**
- `~/.openclaw/agents/svc-concierge/workspace/` — Agent workspace + knowledge/
- `~/.openclaw/agents/svc-banking/workspace/` — Agent workspace + knowledge/
- OpenClaw config 更新（tool 制限設定）

**検証方法:**
```bash
# Agent 呼び出しテスト
openclaw agent --agent svc-banking --session-id test_banking \
  --message "日本で銀行口座を開設するには？" --json --thinking low

# 期待: JSON レスポンス、3-5 秒、knowledge ベースの回答
```

**受入基準:**
- [ ] svc-concierge, svc-banking が `--json` で正常応答する
- [ ] memory_search が knowledge/ ファイルから関連情報を取得する
- [ ] tool 制限が機能する（exec, write 等が使用不可）
- [ ] Session 持続性: 同一 session ID で文脈が保持される

#### Day 3: API Gateway scaffold

**範囲:**
- FastAPI プロジェクト初期化
- Firebase Auth middleware（JWT 検証）
- Agent 呼び出し service (`services/agent.py`: subprocess → `openclaw agent --json`)
- POST /api/v1/chat endpoint
- SQLite DB 初期化（profiles, daily_usage テーブル）
- Usage service（ティア別制限チェック + インクリメント）

**含まれるストーリー:** US-001 (登録), US-002 (ログイン)

**産出物:**
- `backend/app_service/` — FastAPI プロジェクト
  - main.py, config.py, database.py
  - routers/chat.py, routers/auth.py, routers/health.py
  - services/agent.py, services/auth.py, services/usage.py
  - models/profile.py, models/daily_usage.py

**検証方法:**
```bash
cd backend/app_service && uvicorn main:app --reload
curl http://localhost:8000/api/v1/health  # {"status": "ok"}

# POST /api/v1/chat テスト（認証付き）
curl -X POST http://localhost:8000/api/v1/chat \
  -H "Authorization: Bearer {firebase_token}" \
  -H "Content-Type: application/json" \
  -d '{"message": "口座開設したい", "locale": "ja"}'
```

**受入基準:**
- [ ] FastAPI が起動し、health check が OK
- [ ] Firebase JWT 検証が動作する
- [ ] POST /api/v1/chat → Agent 呼び出し → 構造化レスポンス返却
- [ ] Free ティア 5回/日の制限が enforce される
- [ ] SQLite に profiles, daily_usage テーブルが作成される

#### Day 4-5: 残り Agent + 知識ファイル作成

**範囲:**
- svc-visa + svc-medical Agent 追加
- 全 4 agent の knowledge/ ディレクトリに知識 .md ファイル作成
- memory_search 動作確認（検索精度テスト）
- LLM ルーティング（svc-concierge による分類）の実装確認

**産出物:**
- `~/.openclaw/agents/svc-visa/workspace/` — Agent workspace + knowledge/
- `~/.openclaw/agents/svc-medical/workspace/` — Agent workspace + knowledge/

**受入基準:**
- [ ] 全 4 agent が正常に応答する
- [ ] Emergency keyword (119, 救急 等) で svc-medical に即座にルーティングされる
- [ ] LLM 分類で banking/visa/medical/concierge が正しく判定される
- [ ] memory_search が各 agent の knowledge/ から適切な情報を取得する

---

### Week 2: Navigator + Flutter 改造（E2 + E3）

#### Day 1-2: Navigator + Emergency + Subscription endpoints

**範囲:**
- Navigator API (GET /api/v1/navigator/*)
- Emergency API (GET /api/v1/emergency)
- Subscription plans API (GET /api/v1/subscription/plans)
- Usage API (GET /api/v1/usage)
- Profile API (GET/PATCH /api/v1/users/me, POST /api/v1/users/me/onboarding)

**含まれるストーリー:** US-201〜203 (Navigator), US-301 (Emergency), US-401 (Plans)

**産出物:**
- `backend/app_service/routers/navigator.py`
- `backend/app_service/routers/usage_router.py`
- `backend/app_service/routers/subscriptions.py`
- `backend/app_service/routers/profile_router.py`

**受入基準:**
- [ ] GET /api/v1/navigator/domains → 8 ドメイン (4 active + 4 coming_soon) 返却
- [ ] GET /api/v1/navigator/banking/guides → knowledge/*.md 一覧返却
- [ ] GET /api/v1/navigator/banking/guides/account-opening → ガイド全文返却
- [ ] GET /api/v1/emergency → 緊急連絡先 + ガイドコンテンツ返却
- [ ] GET /api/v1/subscription/plans → 3 プラン + 従量チャージ返却
- [ ] GET /api/v1/usage → ティア別利用状況返却

#### Day 3-4: Flutter 改造

**範囲:**
- Chat UI（テキスト送信 + レスポンス表示。sources, actions, tracker_items の表示）
- Navigator UI（ドメイン一覧 + ガイド一覧 + ガイド詳細の markdown レンダリング）
- Emergency UI
- API 接続層（dio + Firebase Auth interceptor）
- 認証フロー（登録 → ログイン → オンボーディング）
- 多言語基盤（Flutter l10n + ARB ファイル、5 言語スケルトン）

**含まれるストーリー:** US-001〜006 (認証), US-101〜104 (Chat), US-201〜203 (Navigator)

**産出物:**
- `app/lib/features/chat/` — Chat 画面
- `app/lib/features/navigator/` — Navigator 画面群
- `app/lib/features/emergency/` — Emergency 画面
- `app/lib/features/auth/` — 認証画面群
- `app/lib/features/onboarding/` — オンボーディング
- `app/lib/features/home/` — ホーム画面
- `app/lib/core/` — DI, theme, API client

**受入基準:**
- [ ] Flutter アプリが iOS/Android で起動する
- [ ] Email/Password で登録・ログイン・ログアウトが動作する
- [ ] Chat 画面でメッセージ送信 → AI 回答表示 → sources 表示
- [ ] Navigator 画面でドメイン一覧 → ガイド一覧 → ガイド詳細が表示される
- [ ] Emergency 画面で緊急連絡先が表示される
- [ ] 5 言語の切り替えが動作する

#### Day 5: 結合テスト

**範囲:**
- 閉ループ A〜D の手動テスト
- Usage 制限テスト
- ルーティング精度テスト

**受入基準:**
- [ ] 閉ループ A: 登録 → オンボーディング → Chat → 回答 が通る
- [ ] 閉ループ B: Navigator → ガイド閲覧 → Chat 遷移 が通る
- [ ] 閉ループ C: Emergency → 緊急連絡先 → Chat で svc-medical ルーティング が通る

---

### Week 3: 品質 + デプロイ（E4）

#### Day 1-2: IAP 統合 + Access Boundary

**範囲:**
- Apple IAP / Google Play Billing の Flutter 側実装
- POST /api/v1/subscription/purchase のレシート検証実装
- subscriptions テーブル + tier 更新ロジック
- Access Boundary 実装（ゲスト/Free/Standard/Premium のコンテンツ制限）

**含まれるストーリー:** US-402 (購入), US-403 (管理)

**受入基準:**
- [ ] IAP 購入フローが動作する（テスト環境）
- [ ] 購入後に subscription_tier が即座に更新される
- [ ] 閉ループ D: Free 制限 → アップグレード → 制限解除 が通る

#### Day 3: E2E テスト + パフォーマンス確認

**範囲:**
- 全閉ループ A〜D の E2E テスト
- AI Chat レスポンスタイム確認（目標: routing 含み < 8 秒）
- 知識ファイル品質レビュー

**受入基準:**
- [ ] 全閉ループが跑通する
- [ ] Chat レスポンスタイム p95 < 8 秒
- [ ] CRUD API レスポンスタイム p95 < 300ms

#### Day 4: Backend deploy

**範囲:**
- VPS セットアップ（OpenClaw + API Gateway + Ollama）
- 本番環境での動作確認
- ドメイン / SSL 設定

**受入基準:**
- [ ] 本番環境で全 API が正常応答する
- [ ] OpenClaw Gateway が安定稼働する
- [ ] SSL (TLS 1.3) が有効

#### Day 5: App Store 準備

**範囲:**
- Xcode signing + build
- App Store Connect メタデータ（スクリーンショット、説明文、5 言語）
- Google Play Console 準備

**受入基準:**
- [ ] Flutter アプリが iOS/Android でリリースビルドに成功する
- [ ] App Store / Play Store への提出準備が完了

---

## データマイルストーン（ソフトウェアと並行実施）

> ソフトウェアだけでなくデータも MVP の構成要素。以下のデータマイルストーンはソフトウェアマイルストーンと **並行実行可能** だが、MVP_ACCEPTANCE の「データ就緒」チェック前に全て完了していること。
> 根拠: strategy/product-spec.md §8 Data Readiness Definition。

### DM1: ナレッジベース初期投入（Week 1 Day 4-5 と並行）

**範囲:**
- 4 agent × knowledge/ ディレクトリに初期ファイルを作成
- 公式ソース（金融庁、入管庁、厚労省、ISA）から情報を収集・構造化
- 各ファイルに情報ソース URL と最終更新日を記載

**必要データ（product-spec §8.1 準拠）:**

| Agent | ファイル数 | 主要コンテンツ | ソース |
|-------|----------|-------------|--------|
| svc-banking | 6 files | 5大銀行比較、口座開設手順、送金方法、ATM、ネットバンキング、FAQ | 金融庁、全銀協、各行公式 |
| svc-visa | 6 files | 在留更新、資格変更、永住、再入国、資格外活動、家族滞在 | 入管庁、ISA |
| svc-medical | 7 files | 診療科ガイド、保険制度、緊急対応、受診フレーズ、薬局、健診、メンタルヘルス | 厚労省、AMDA |
| svc-concierge | 5 files | 来日直後チェックリスト、生活基盤、FAQ、地域情報、ルーティングルール | ISA 17言語ポータル |
| **合計** | **~24 files** | **~120KB** | |

**検証方法:**
```bash
# 各 agent の knowledge/ ファイル数を確認
ls ~/.openclaw/agents/svc-banking/workspace/knowledge/*.md | wc -l  # 期待: 6
ls ~/.openclaw/agents/svc-visa/workspace/knowledge/*.md | wc -l     # 期待: 6
ls ~/.openclaw/agents/svc-medical/workspace/knowledge/*.md | wc -l  # 期待: 7
ls ~/.openclaw/agents/svc-concierge/workspace/knowledge/*.md | wc -l # 期待: 5

# memory_search 動作テスト
openclaw agent --agent svc-banking --session-id test_dm1 \
  --message "日本で銀行口座を開設するには何が必要ですか？" --json --thinking low
# 期待: knowledge/ の account-opening.md から関連情報を引用した回答
```

**受入基準:**
- [ ] 全 4 agent の knowledge/ に product-spec §8.1 に定義された最低限のファイルが配置されている
- [ ] 各ファイルに情報ソース URL と最終更新日が記載されている
- [ ] Visa / Medical 関連ファイルに免責事項が含まれている

### DM2: 検索精度テスト + 品質改善（Week 2-3 と並行）

**範囲:**
- 各ドメインの代表的質問（5問以上）で memory_search の精度を検証
- 日本語・英語・中国語の 3 言語クエリテスト（bge-m3 多言語対応の検証）
- 精度が不十分なファイルの加筆・リライト
- Navigator API 経由でのガイド表示確認

**検証方法:**
```bash
# 精度テスト: 各 agent に代表的質問を投げて回答品質を確認
# Banking
openclaw agent --agent svc-banking --session-id test_accuracy \
  --message "Which banks allow foreigners to open accounts easily?" --json --thinking low
# 期待: banks-overview.md の情報に基づく具体的な銀行名と条件の回答

# Visa (中国語テスト)
openclaw agent --agent svc-visa --session-id test_accuracy_zh \
  --message "如何更新在留卡？" --json --thinking low
# 期待: visa-renewal.md の情報に基づく中国語での回答

# Navigator API 経由
curl http://localhost:8000/api/v1/navigator/banking/guides
# 期待: 6 ガイドが title + summary 付きで返却
```

**受入基準:**
- [ ] 各 agent に対する 5 問の代表的質問に、knowledge ファイルに基づいた正確な回答が返ること
- [ ] 日本語・英語・中国語の 3 言語で memory_search が関連情報を取得できること
- [ ] Navigator API 経由で全ガイドが正しく表示されること（title + summary + content）

---

## Launch Preparation（MVP ソフトウェア + データ完了後 → リリースまで）

### LP1: Production 環境構築

**範囲:**
- VPS (東京リージョン) に API Gateway + OpenClaw + Ollama をデプロイ
- SQLite マイグレーション（本番用）
- ドメイン取得 + DNS 設定 + SSL (Let's Encrypt)
- 環境変数・シークレット管理（Firebase Admin SDK 秘密鍵、API キー等）

**受入基準:**
- [ ] 本番 URL で全 API が正常応答する
- [ ] TLS 1.3 が有効（`curl -vI` で確認）
- [ ] シークレットがソースコードに含まれていない

### LP2: Monitoring & Alerting

**範囲:**
- Firebase Crashlytics 統合疎通確認
- Firebase Analytics の全カスタムイベント（SYSTEM_DESIGN.md §11.2）が本番で送信されていることを確認
- API Gateway エラーログ監視設定
- Uptime Robot で API ヘルスチェック監視

**受入基準:**
- [ ] テストクラッシュが Crashlytics に表示される
- [ ] Firebase DebugView で全カスタムイベントが確認できる
- [ ] API ダウン時にアラート通知が飛ぶ

### LP3: App Store 準備

**範囲:**
- スクリーンショット作成（5 言語 × iPhone + Android）
- ストア説明文（5 言語）+ ASO キーワード（SYSTEM_DESIGN.md §12.4 準拠）
- Privacy Policy / Terms of Service ページ URL 準備
- アプリアイコン（1024x1024）
- App Review ガイドライン対応確認（IAP 周りのリジェクトリスク事前確認）

**受入基準:**
- [ ] App Store Connect / Play Console にメタデータが全言語で入力済み
- [ ] Privacy Policy / ToS が公開 URL でアクセス可能
- [ ] アプリアイコンが設定済み

### LP4: Beta Testing

**範囲:**
- TestFlight (iOS) / Internal Testing Track (Android) で配布
- テスト対象者: Z + 内部テスター
- フィードバック収集: TestFlight 内フィードバック + 手動テスト結果
- 閉ループ A〜E の跑通確認

**受入基準:**
- [ ] Beta 版で全閉ループ (A〜E) が跑通する
- [ ] Z が Beta 版を承認している

### LP5: Final Checklist

- [ ] Production 環境で全閉ループが跑通する
- [ ] Crash Reporting がエラーを捕捉している（テストクラッシュで確認）
- [ ] Analytics イベントが Production でも送信されている
- [ ] Privacy Policy / ToS が公開 URL でアクセスできる
- [ ] Beta Testing で Z が承認している
- [ ] App Store メタデータが全 5 言語で入力済み

---

## Phase 1: 拡張（Phase 0 完了後）

### 範囲
- **追加 4 Agent**: svc-housing, svc-work, svc-admin, svc-transport（knowledge files + workspace 作成）
- **AI Chat 画像入力**: image フィールドの実装（書類撮影 → AI 解読）
- **SSE ストリーミング**: Chat レスポンスのストリーミング対応
- **Navigator 拡張**: coming_soon → active（4 ドメイン追加）
- **LP（ランディングページ）**: Next.js + SSR (Cloudflare Pages) で構築（SYSTEM_DESIGN.md §12.3 準拠）
- **Tracker 強化**: AI 提案の Tracker アイテムを DB に保存、CRUD
- **PostgreSQL 移行**: 必要に応じて SQLite → PostgreSQL

---

## マイルストーン間の依存関係

```mermaid
graph LR
    W1D12[W1 Day1-2:<br/>Agent 作成 + OC 確認] --> W1D3[W1 Day3:<br/>API Gateway]
    W1D12 --> W1D45[W1 Day4-5:<br/>残り Agent + 知識]
    W1D3 --> W2D12[W2 Day1-2:<br/>Navigator + API]
    W1D45 --> W2D12
    W2D12 --> W2D34[W2 Day3-4:<br/>Flutter 改造]
    W2D34 --> W2D5[W2 Day5:<br/>結合テスト]
    W2D5 --> W3D12[W3 Day1-2:<br/>IAP + Access]
    W3D12 --> W3D3[W3 Day3:<br/>E2E テスト]
    W3D3 --> W3D4[W3 Day4:<br/>Deploy]
    W3D4 --> W3D5[W3 Day5:<br/>App Store]

    DM1[DM1: ナレッジ初期投入] --> DM2[DM2: 検索精度テスト]
    W1D45 -.->|並行| DM1
    DM2 -.->|データ就緒前提| W3D3

    W3D5 --> LP1[LP1: Production 構築]
    LP1 --> LP2[LP2: Monitoring]
    LP2 --> LP3[LP3: App Store 準備]
    LP3 --> LP4[LP4: Beta Testing]
    LP4 --> LP5[LP5: Final Checklist]
```

---

## 変更履歴

- 2026-02-16: 初版作成
- 2026-02-17: Phase 0 アーキテクチャピボット反映（OC Runtime / memory_search / LLM routing / 課金体系更新）
- 2026-02-18: strategy/ 連携補完（Data Readiness マイルストーン DM1/DM2 追加 / Launch Preparation LP1-LP5 追加）
