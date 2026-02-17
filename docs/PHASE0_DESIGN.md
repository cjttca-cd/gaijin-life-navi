# Phase 0 設計書 — gaijin-life-navi

> 作成日: 2026-02-17
> ステータス: APPROVED（Z 承認済み）
> 最終更新: 2026-02-17

---

## 1. アーキテクチャ概要

### コンセプト
OpenClaw を Production Runtime として使用。API Gateway (FastAPI) が Flutter frontend からのリクエストを受け、
`openclaw agent --json` CLI 経由で Service Agent を呼び出す。

### 全体構成
```
Flutter App (iOS/Android/Web)
    ↓ HTTPS
API Gateway (FastAPI, port 8000)
    ├── Firebase JWT 認証
    ├── Rate Limiting (per user tier)
    ├── Intent Analysis → Agent Routing
    ├── Session Mapping: app:{uid}:{domain}
    ├── Model/Thinking 選択
    └── Response 構造化
    ↓ subprocess
OpenClaw Gateway (port 18789)
    ├── svc-concierge (路由 + 統合)
    ├── svc-banking   (銀行ドメイン)
    ├── svc-visa      (ビザ・在留)
    ├── svc-medical   (医療)
    ├── [Phase 1+] svc-housing / svc-work / svc-admin / svc-transport
    └── memory_search (workspace/knowledge/*.md)
```

### 通信方式
```bash
openclaw agent \
  --agent svc-banking \
  --session-id "app_{user_id}_banking" \
  --message "{user_message}" \
  --json --thinking low \
  --timeout 60
```

### テスト実績 (2026-02-17 実施)
- 基本呼出し: ✅ (3.4秒)
- Session 持続性: ✅ (prompt cache 有効)
- 並行 3 路: ✅ (12.8秒で全完了)
- メッセージ漏洩: なし (deliver=false で安全)

---

## 2. Service Agent 設計

### 開発用 Agent と完全分離
- 開発用: main, pm, strategist, architect, coder, designer, tester, writer（Telegram/WhatsApp 経由）
- Service用: svc-* agents（API Gateway 経由のみ、channel binding なし）

### MVP Agent 一覧 (4体)

| Agent ID | 役割 | 知識ドメイン |
|----------|------|------------|
| svc-concierge | 意図分類 + domain routing + 汎用 Q&A | 全ドメイン横断 |
| svc-banking | 口座開設 wizard、送金比較、税金支払い | 金融庁、全銀協、各行公式 |
| svc-visa | 更新/変更/永住フロー、期限計算 | 入管庁、ISA ポータル |
| svc-medical | 症状→診療科、保険説明、緊急対応 | 厚労省、多言語医療ガイド |

### Phase 1+ 追加 Agent (4体)

| Agent ID | 役割 |
|----------|------|
| svc-housing | 物件探し、契約用語、退去トラブル |
| svc-work | 労働法、社保、確定申告、転職 |
| svc-admin | 転入届、マイナンバー、年金、国保 |
| svc-transport | IC カード、定期券、免許切替 |

### 共通設定

```jsonc
// 各 svc-agent の config (openclaw.json 抜粋)
{
  "id": "svc-banking",
  "model": "anthropic/claude-sonnet-4-5",
  "tools": {
    "allow": ["web_search", "web_fetch", "read", "memory_search", "memory_get"]
  }
}
// thinkingDefault: "high" は defaults から継承
// allow リスト以外のツールは自動的に禁止される
```

### Workspace 構造
```
~/.openclaw/agents/svc-banking/workspace/
  ├── AGENTS.md          # Agent の役割・行動規範
  ├── TOOLS.md           # 利用可能ツールのメモ
  ├── IDENTITY.md        # Agent のアイデンティティ
  └── knowledge/         # 知識ファイル（memory_search + read 対象）
      ├── banks-overview.md         # 主要銀行比較表
      ├── account-opening.md        # 口座開設手順・必要書類
      ├── remittance.md             # 海外送金方法比較
      ├── tax-payment.md            # 税金支払い方法
      ├── online-banking.md         # ネットバンキング・ATM
      └── faq.md                    # よくある質問
```

### 知識ファイルの配置
- `workspace/knowledge/` に配置 → defaults の `memorySearch.extraPaths: ["knowledge"]` で自動検索対象
- `workspace/MEMORY.md` + `workspace/memory/*.md` も検索対象（セッション記録用、将来利用）
- 各 agent の workspace は完全分離 → 他 agent の知識は一切見えない

---

## 3. 知識管理設計（memory_search ベース）

### 方針: OpenClaw memory_search をそのまま RAG として使用

**決定理由**:
1. 各 svc-* agent の workspace は完全分離 → 開発用 agent の個人データは見えない
2. 知識量が小さい（各 agent ~30KB, ~15-20 files）→ memory_search で十分
3. pgvector 不要 → インフラ・運用コスト削減
4. bge-m3 多言語モデルが Ollama で既に稼働中 → 中日英対応済み
5. ファイル編集 = 知識更新 → パイプライン不要

**将来の拡張**: 精確なデータ検索（例: 特定の在留資格番号、税率テーブル）が必要になった場合は
データベース（PostgreSQL 等）を追加する。memory_search（意味検索）+ DB（正確検索）の二層構成。

### 知識ファイル配置

各 agent の `workspace/knowledge/` ディレクトリに .md ファイルとして配置。
`memorySearch.extraPaths: ["knowledge"]` が defaults で設定済みのため、自動的に検索対象になる。

### 知識源

| ドメイン | 主要ソース | 更新頻度 | ファイル数（目安） |
|---------|-----------|---------|-----------------|
| Banking | 金融庁、全銀協、主要銀行公式サイト | 半年 | ~6 files |
| Visa | 入管庁、ISA ポータル | 法改正時 | ~6 files |
| Medical | 厚労省、AMDA 多文化共生ガイド | 四半期 | ~7 files |
| General | ISA 外国人生活支援ポータル（17言語）| 月次 | ~5 files |

### Agent からの利用方式
1. `memory_search`: ユーザーの質問から関連知識を意味検索 → 上位 snippets を参考に回答
2. `memory_get`: 検索ヒット後、必要な行だけを取得（コンテキスト節約）
3. `read`: 構造化データ（比較表、フロー定義等）を直接読み込み
4. `web_search` / `web_fetch`: 知識ファイルにない最新情報を補完

---

## 4. API Gateway 設計

### エンドポイント

| Method | Path | 説明 | 認証 |
|--------|------|------|------|
| POST | /api/v1/chat | AI Chat（テキスト + 画像） | Required |
| GET | /api/v1/tracker | 待办リスト | Required |
| POST | /api/v1/tracker | 手動追加 | Required |
| GET | /api/v1/navigator/{domain}/guides | ドメイン別ガイド一覧 | Public |
| GET | /api/v1/navigator/{domain}/guides/{id} | ガイド詳細 | Tier-based |
| GET | /api/v1/emergency | 緊急連絡先・救急ガイド | Public |
| POST | /api/v1/auth/register | ユーザー登録 | Public |
| POST | /api/v1/auth/login | ログイン | Public |
| GET | /api/v1/profile | プロフィール取得 | Required |
| PUT | /api/v1/profile | プロフィール更新 | Required |
| GET | /api/v1/subscription/plans | 料金プラン一覧 | Public |
| POST | /api/v1/subscription/purchase | 購入処理 | Required |
| GET | /api/v1/usage | 利用状況（残回数等） | Required |

### Chat リクエスト/レスポンス

```json
// Request
{
  "message": "銀行口座を開設したいのですが",
  "image": null,
  "context": null,
  "locale": "zh"
}

// Response
{
  "reply": "銀行口座の開設についてご案内します...",
  "sources": [
    {"title": "金融庁 外国人向けガイド", "url": "https://..."}
  ],
  "actions": [
    {"type": "checklist", "items": ["在留カード", "パスポート", "住民票"]},
    {"type": "next_step", "text": "最寄りの三井住友銀行支店を検索しますか？"}
  ],
  "tracker_items": [
    {"title": "銀行口座開設", "deadline": null, "steps": ["書類準備", "窓口予約", "来店"]}
  ],
  "navigator": "banking",
  "usage": {"used": 3, "limit": 5, "tier": "free"}
}
```

---

## 5. 課金体系

### サブスクリプション

| プラン | 月額 | AI Chat（画像解読含む） | Tracker | 広告 |
|--------|------|----------------------|---------|------|
| 🆓 Free | ¥0 | 5回/日 | 3件 | あり |
| ⭐ Standard | ¥720/月 | 300回/月 | 無制限 | なし |
| 💎 Premium | ¥1,360/月 | 無制限 | 無制限 | なし |

### 従量チャージ（都度購入）

| パック | 価格 | 単価 |
|--------|------|------|
| 100回 | ¥360 | ¥3.6/回 |
| 50回 | ¥180 | ¥3.6/回 |

### Apple IAP 価格調整
実際の価格は App Store Connect の利用可能な価格点に合わせて微調整する。
- ¥720 → ¥700 or ¥750（要確認）
- ¥1,360 → ¥1,400（要確認）

---

## 6. Access Boundary Matrix

| 機能 | 🔓 ゲスト | 🆓 Free | ⭐ Standard | 💎 Premium |
|------|:---------:|:-------:|:-----------:|:----------:|
| Medical Emergency Guide | ✅ | ✅ | ✅ | ✅ |
| Navigator 一覧・概要閲覧（全ドメイン） | ✅ | ✅ | ✅ | ✅ |
| Banking 詳細ガイド（全機能） | ✅ | ✅ | ✅ | ✅ |
| Visa/Medical/Admin 等 詳細 | 概要+CTA | ✅ | ✅ | ✅ |
| AI Chat（テキスト + 画像） | ❌ | 5回/日 | 300回/月 | 無制限 |
| Auto Tracker | ❌ | 3件 | 無制限 | 無制限 |
| 広告 | あり | あり | なし | なし |

---

## 7. 開発ロードマップ

### Week 1: 基盤構築
- [ ] Day 1-2: Service Agent 作成 (svc-concierge + svc-banking)
  - workspace/AGENTS.md + skills/ + knowledge/
  - OpenClaw config に agent 追加（tool 制限付き）
  - 動作確認: `openclaw agent --agent svc-banking --json` テスト
- [ ] Day 3: API Gateway scaffold (FastAPI)
  - Firebase Auth middleware
  - Agent 呼び出し service (`subprocess` → `openclaw agent`)
  - /api/v1/chat endpoint
- [ ] Day 4-5: 知識ファイル作成
  - 全 4 agent の knowledge/ ディレクトリに知識 .md ファイル作成
  - memory_search 動作確認（検索精度テスト）

### Week 2: 拡張 + Flutter
- [ ] Day 1-2: svc-visa + svc-medical Agent 追加
- [ ] Day 3-4: Flutter 改造
  - Chat UI（テキスト + 画像送信）
  - Navigator UI（ドメイン別一覧 + 詳細）
  - API 接続層
- [ ] Day 5: 結合テスト + Tracker 自動生成

### Week 3: 品質 + デプロイ
- [ ] Day 1-2: 知識庫拡充 + Access Boundary 実装
- [ ] Day 3: E2E テスト + パフォーマンス確認
- [ ] Day 4: Backend deploy (Fly.io or VPS)
- [ ] Day 5: App Store 準備 (Xcode signing, screenshots, description)

---

## 8. 技術スタック

| レイヤー | 技術 | 理由 |
|---------|------|------|
| Frontend | Flutter + Dart 3 | 既存コードベース活用、クロスプラットフォーム |
| API Gateway | Python + FastAPI | 軽量、async 対応、OpenClaw CLI 呼び出しに最適 |
| Agent Runtime | OpenClaw | Session 管理、Agent 調度、LLM 呼び出し、全部入り |
| LLM | Claude Sonnet 4.5 (default) | コスト効率。複雑な判断時のみ Opus に昇格 |
| Knowledge | memory_search (bge-m3) | workspace 分離で安全。pgvector 不要でインフラ簡素化 |
| Auth | Firebase Auth | 既存構成を活用 |
| 決済 | Apple IAP + Google Play Billing | ネイティブ決済（Stripe は Web のみ） |
| DB | PostgreSQL | ユーザーデータ、利用状況、Tracker |
| Hosting | VPS or Fly.io | OpenClaw 稼働 + API Gateway |

---

## 9. セキュリティ設計

### Service Agent Tool 制限
- ✅ 許可: web_search, web_fetch, read, memory_search, memory_get
- ❌ 禁止: allow リスト以外の全ツール（exec, write, edit, browser, message 等）

### データ隔離
- Service Agent は OpenClaw 開発用 workspace にアクセス不可
- 各 svc-* agent の memory_search は自 workspace のみ検索（他 agent の知識・main の個人データは見えない）
- User データは API Gateway の DB に保持（OpenClaw session にはユーザー PII を最小限に）

### Session Key 設計
- 形式: `app_{user_id}_{domain}`（コロン不可 → アンダースコア使用）
- 例: `app_firebase_uid_abc123_banking`
- 開発用 session (agent:main:*, agent:pm:*) とは名前空間が完全に分離

---

## 変更履歴
- 2026-02-17: 初版作成（Z 承認）
- 2026-02-17: RAG を pgvector → memory_search に変更（Z 承認）。Session ID 形式をコロン→アンダースコアに修正。tools.allow に memory_search/memory_get 追加。
