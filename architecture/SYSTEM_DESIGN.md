# システム設計

## 1. アーキテクチャ概要

**OpenClaw Runtime アーキテクチャ**

- **API Gateway**: FastAPI (Python, port 8000)（Firebase JWT 認証、Rate Limiting、Agent ルーティング、レスポンス構造化）
- **Agent Runtime**: OpenClaw Gateway (port 18789)（Session 管理、LLM 呼び出し、Tool 制御、memory_search）
- **Service Agents**: svc-finance / svc-tax / svc-visa / svc-medical / svc-life / svc-legal（各自 workspace + knowledge files）+ 軽量ルーター（分類判断のみ）
- **Client**: Flutter (Dart 3)（iOS / Android / Web — 単一コードベース）
- **Data Layer**: SQLite (aiosqlite) + Firebase Auth + memory_search (bge-m3, Ollama)

**選定理由**:
1. **OpenClaw as Runtime**: Session 管理・LLM 呼び出し・Tool 制御・knowledge 検索が全て組み込み済み。独自 AI Service 不要
2. **Flutter 統一**: iOS/Android/Web を単一 Dart コードベースでカバー。AGENTS.md 推奨スタック準拠
3. **memory_search**: 各 agent の workspace/knowledge/ に .md ファイル配置 → bge-m3 (Ollama) で意味検索。pgvector/Pinecone 不要
4. **SQLite (Phase 0)**: 軽量運用。profiles, usage, subscriptions のみ。将来 PostgreSQL 移行可
5. **コスト最適**: 独自 AI Service・Vector DB・Edge Workers を排除し、OpenClaw 1 プロセスに集約

---

## 2. 技術スタック

| レイヤー | 技術 | バージョン | 選定理由 |
|---------|------|-----------|---------|
| **Mobile/Web** | Flutter | stable 3.x (Dart 3) | AGENTS.md 推奨。iOS/Android/Web を単一コードベースでコンパイル。iOS 優先デザイン対応 |
| **状態管理** | Riverpod | 2.x (+ riverpod_generator) | 型安全、テスタブル、コード生成で boilerplate 削減 |
| **ルーティング** | go_router | 14.x | 宣言的ルーティング、Deep Link 対応、リダイレクトガード |
| **ローカル DB** | drift (SQLite) | 2.x | 型安全 ORM、オフラインキャッシュ |
| **HTTP クライアント** | dio | 5.x | インターセプター、リトライ |
| **認証** | Firebase Auth | latest (firebase_auth) | Email/Password + Apple Sign In。無料枠 50K MAU |
| **i18n** | Flutter intl (ARB) | built-in | Flutter 公式の多言語対応。5 言語 ARB ファイルで管理 |
| **UI** | Material 3 + Cupertino | Flutter built-in | iOS 優先デザイン |
| **API Gateway** | FastAPI (Python 3.12+) | 0.115+ | async 対応、OpenClaw CLI subprocess 呼び出しに最適 |
| **Agent Runtime** | OpenClaw Gateway | latest | Session 管理、LLM 呼び出し、Tool 制御、memory_search |
| **LLM** | Claude Sonnet 4.5 (Anthropic) | claude-sonnet-4-5 | 全 svc-* agent のデフォルト。コスト効率。複雑な判断時のみ Opus に昇格 |
| **Knowledge / RAG** | memory_search (bge-m3, Ollama) | latest | workspace/knowledge/*.md を意味検索。多言語対応（日中英） |
| **Server DB** | SQLite (aiosqlite) | latest | Phase 0 軽量運用。将来 PostgreSQL 移行可 |
| **Auth** | Firebase Auth | latest | Email/Password + Apple Sign In。JWT 発行 |
| **決済** | Apple IAP + Google Play Billing | latest SDK | ネイティブ決済 |
| **Hosting** | VPS (東京リージョン) | — | OpenClaw + API Gateway 同居 |

### ~~旧技術スタック（Phase 0 ピボットで廃止）~~

以下は Phase 0 ピボットで廃止された技術:
- ~~Cloudflare Workers (API Gateway)~~ → FastAPI に統合
- ~~AI Service (FastAPI, port 8001)~~ → OpenClaw Runtime に統合
- ~~Pinecone (Vector DB)~~ → memory_search (bge-m3) に代替
- ~~LangChain (RAG Framework)~~ → OpenClaw memory_search に代替
- ~~OpenAI Embedding (text-embedding-3-small)~~ → bge-m3 (Ollama) に代替
- ~~Google Cloud Vision API (OCR)~~ → AI Chat 画像入力に統合
- ~~PostgreSQL (マネージド)~~ → SQLite (Phase 0)
- ~~Cloudflare R2 (Object Storage)~~ → Phase 0 では不要
- ~~Stripe~~ → Apple IAP + Google Play Billing
- ~~Astro (LP)~~ → Phase 0 スコープ外

---

## 3. システムコンポーネント図

```mermaid
graph TB
    subgraph Clients
        iOS[iOS App<br/>Flutter / Dart 3]
        Android[Android App<br/>Flutter / Dart 3]
        Web[Web App<br/>Flutter Web]
    end

    subgraph APIGateway["API Gateway (FastAPI, port 8000)"]
        AuthMW[Firebase JWT 認証]
        RateLimit[Rate Limiting]
        Router[Intent Router<br/>Emergency keyword + LLM 軽量分類]
        Structurizer[Response 構造化<br/>blocks → JSON]
    end

    subgraph OCRuntime["OpenClaw Gateway (port 18789)"]
        SvcFinance[svc-finance<br/>金融ドメイン]
        SvcTax[svc-tax<br/>税務ドメイン]
        SvcVisa[svc-visa<br/>ビザ・在留]
        SvcMedical[svc-medical<br/>医療]
        SvcLife[svc-life<br/>生活全般]
        SvcLegal[svc-legal<br/>法律]

        MemSearch[memory_search<br/>bge-m3 / Ollama]
    end

    subgraph DataLayer["Data Layer"]
        SQLite[(SQLite<br/>profiles / usage / subscriptions)]
        Firebase[Firebase Auth]
        Claude[Claude Sonnet 4.5<br/>Anthropic API]
        Ollama[Ollama<br/>bge-m3 Embedding]
    end

    subgraph Knowledge["Knowledge & Guides"]
        KB_Finance[svc-finance/workspace/knowledge/*.md<br/>svc-finance/workspace/guides/*.md]
        KB_Tax[svc-tax/workspace/knowledge/*.md<br/>svc-tax/workspace/guides/*.md]
        KB_Visa[svc-visa/workspace/knowledge/*.md<br/>svc-visa/workspace/guides/*.md]
        KB_Medical[svc-medical/workspace/knowledge/*.md<br/>svc-medical/workspace/guides/*.md]
        KB_Life[svc-life/workspace/knowledge/*.md<br/>svc-life/workspace/guides/*.md]
        KB_Legal[svc-legal/workspace/knowledge/*.md<br/>svc-legal/workspace/guides/*.md]
    end

    iOS --> AuthMW
    Android --> AuthMW
    Web --> AuthMW

    iOS -.->|Auth| Firebase
    Android -.->|Auth| Firebase
    Web -.->|Auth| Firebase

    AuthMW --> RateLimit
    RateLimit --> Router
    Router -->|subprocess: openclaw agent --json| SvcFinance
    Router -->|subprocess: openclaw agent --json| SvcTax
    Router -->|subprocess: openclaw agent --json| SvcVisa
    Router -->|subprocess: openclaw agent --json| SvcMedical
    Router -->|subprocess: openclaw agent --json| SvcLife
    Router -->|subprocess: openclaw agent --json| SvcLegal

    SvcFinance -->|memory_search| MemSearch
    SvcTax -->|memory_search| MemSearch
    SvcVisa -->|memory_search| MemSearch
    SvcMedical -->|memory_search| MemSearch
    SvcLife -->|memory_search| MemSearch
    SvcLegal -->|memory_search| MemSearch

    MemSearch --> Ollama
    SvcFinance --> Claude
    SvcTax --> Claude
    SvcVisa --> Claude
    SvcMedical --> Claude
    SvcLife --> Claude
    SvcLegal --> Claude

    MemSearch -.-> KB_Finance
    MemSearch -.-> KB_Tax
    MemSearch -.-> KB_Visa
    MemSearch -.-> KB_Medical
    MemSearch -.-> KB_Life
    MemSearch -.-> KB_Legal

    Router --> SQLite
    Structurizer --> SQLite
```

---

## 4. Agent トポロジー

### 4.1 開発用 Agent と Service Agent の完全分離

| 種別 | Agent 例 | 呼び出し元 | 特徴 |
|------|---------|-----------|------|
| 開発用 | main, pm, strategist, architect, coder, designer, tester, writer | Telegram/WhatsApp | 個人データ・プロジェクト情報にアクセス |
| Service用 | svc-finance, svc-tax, svc-visa, svc-medical, svc-life, svc-legal | API Gateway (subprocess) | ユーザーデータは最小限。knowledge/ + guides/ を保持。API は guides/ のみ配信 |

### 4.2 Service Agent 一覧（6体）

| Agent ID | 役割 | 思維モード | 知識ドメイン | 知識ファイル数 |
|----------|------|-----------|------------|-------------|
| svc-finance | 銀行口座開設、送金比較、投資・保険・クレジットカード | コスト/リスク/収益分析 | 金融庁、全銀協、各行公式 | ~6 files |
| svc-tax | 確定申告、年金、社会保険、ふるさと納税 | 法的義務/期限/該当判断 | 国税庁、年金機構 | ~6 files |
| svc-visa | 更新/変更/永住フロー、期限計算、家族滞在 | 法的合規/期限管理 | 入管庁、ISA ポータル | ~6 files |
| svc-medical | 症状→診療科、保険説明、緊急対応、薬局、メンタルヘルス | 緊急判断/医療制度 | 厚労省、多言語医療ガイド | ~7 files |
| svc-life | 住居、交通、就労、行政手続き、買い物、文化、教育 | how-to/実用情報 | ISA 生活支援ポータル | ~8 files |
| svc-legal | 労働紛争、事故、犯罪被害、消費者保護、離婚、権利 | 処境分析+専門家誘導 | 法テラス、弁護士会 | ~5 files |

### 4.3 ルーター（旧 svc-concierge）

Concierge を専門 agent として廃止し、軽量ルーターに変更。API Gateway で LLM 軽量分類（分類判断のみ）を行い、6 ドメインのいずれかにルーティングする。専門 prompt 不要。

**Agent 分離の基準** — 「異なる思維モードが必要か？」:
- finance = コスト/リスク/収益分析
- tax = 法的義務/期限/該当判断
- visa = 法的合規/期限管理
- medical = 緊急判断/医療制度
- life = how-to/実用情報
- legal = 処境分析+専門家誘導

**跨領域対応**: 現段階は主 agent が回答 + 他領域への案内テンプレ方式を採用。

### 4.4 Agent 共通設定

```jsonc
{
  "id": "svc-finance",
  "model": "anthropic/claude-sonnet-4-5",
  "tools": {
    "allow": ["web_search", "web_fetch", "read", "memory_search", "memory_get"]
  }
}
```

### 4.5 Agent Workspace 構造

```
~/.openclaw/agents/svc-finance/workspace/
  ├── AGENTS.md          # Agent の役割・行動規範
  ├── IDENTITY.md        # Agent のアイデンティティ
  ├── TOOLS.md           # 利用可能ツールのメモ
  ├── SOUL.md            # Agent の個性定義
  ├── knowledge/         # Agent 専用知識（経験則・判断ロジック・暗黙知）
  │   ├── banks-overview.md
  │   ├── account-opening.md
  │   ├── remittance.md
  │   ├── investment-insurance.md
  │   ├── online-banking.md
  │   └── faq.md
  └── guides/            # ユーザー向け指南（Navigator API で配信）
      ├── account-opening.md   # access: free
      ├── banks-overview.md    # access: premium
      ├── remittance.md        # access: premium
      ├── investment-basics.md # access: premium
      ├── online-banking.md    # access: premium
      └── faq.md               # access: premium
```

---

## 5. 通信フロー

### 5.1 Agent 呼び出し方式

API Gateway から OpenClaw agent を subprocess で呼び出す:

```bash
openclaw agent \
  --agent svc-finance \
  --session-id "app_{user_id}_finance" \
  --message "{user_message}" \
  --json --thinking low \
  --timeout 60
```

**特性**:
- 同期呼び出し（Phase 0 では SSE ストリーミングなし）
- Session 持続性: OpenClaw が session_id でコンテキストを保持（prompt cache 有効）
- タイムアウト: CLI 60 秒 + subprocess 75 秒（15 秒バッファ）

### 5.2 AI チャットフロー（コアフロー）

```mermaid
sequenceDiagram
    participant U as User (Flutter App)
    participant FB as Firebase Auth
    participant GW as API Gateway (FastAPI)
    participant DB as SQLite
    participant OC as OpenClaw Gateway
    participant Agent as svc-* Agent
    participant MS as memory_search (bge-m3)
    participant CL as Claude Sonnet 4.5

    U->>FB: Firebase Auth Sign In → ID Token
    U->>GW: POST /api/v1/chat<br/>(Bearer: Firebase ID Token)
    GW->>GW: JWT 検証
    GW->>DB: profiles.subscription_tier 取得
    GW->>DB: daily_usage.chat_count チェック

    alt 利用制限超過
        GW-->>U: 429 USAGE_LIMIT_EXCEEDED
    end

    GW->>GW: Emergency keyword 検出?
    alt 緊急キーワード (119/110/救急/emergency)
        GW->>GW: → svc-medical にルーティング
    else LLM 軽量分類
        GW->>CL: 分類プロンプト（6 ドメイン判定）
        CL-->>GW: "finance" / "tax" / "visa" / "medical" / "life" / "legal"
    end

    GW->>OC: subprocess: openclaw agent --agent svc-{domain}
    OC->>MS: memory_search (ユーザーメッセージ)
    MS-->>OC: 関連 knowledge snippets
    OC->>CL: system prompt + knowledge + user message
    CL-->>OC: agent response (text + structured blocks)
    OC-->>GW: JSON response

    GW->>GW: [SOURCES]/[ACTIONS]/[TRACKER] ブロック解析
    GW->>DB: daily_usage.chat_count += 1
    GW-->>U: ChatResponse JSON
```

### 5.3 Navigator フロー

```mermaid
sequenceDiagram
    participant U as User (Flutter App)
    participant GW as API Gateway (FastAPI)
    participant FS as File System

    U->>GW: GET /api/v1/navigator/domains
    GW->>FS: guides/ ディレクトリ走査
    GW-->>U: 6 ドメイン一覧 (全 active)

    U->>GW: GET /api/v1/navigator/finance/guides
    GW->>FS: svc-{domain}/workspace/guides/*.md 読み込み
    GW-->>U: ガイド一覧 (slug + title + summary)

    U->>GW: GET /api/v1/navigator/finance/guides/account-opening
    GW->>FS: guides/account-opening.md 読み込み + パース
    GW-->>U: ガイド詳細 (title + summary + content)
```

### 5.4 認証フロー

```mermaid
sequenceDiagram
    participant U as User (Flutter)
    participant FB as Firebase Auth
    participant GW as API Gateway (FastAPI)
    participant DB as SQLite

    U->>FB: createUserWithEmailAndPassword()
    FB-->>U: Firebase ID Token + UID
    U->>GW: POST /api/v1/auth/register (Bearer: ID Token)
    GW->>GW: Firebase JWT 検証
    GW->>DB: profiles レコード作成 (id = firebase_uid)
    GW-->>U: profile オブジェクト
```

### 5.5 サブスクリプションフロー

```mermaid
sequenceDiagram
    participant U as User (Flutter)
    participant IAP as Apple IAP / Google Play
    participant GW as API Gateway
    participant DB as SQLite

    U->>IAP: 購入リクエスト
    IAP-->>U: レシート / purchase token
    U->>GW: POST /api/v1/subscription/purchase (receipt)
    GW->>IAP: レシート検証 (App Store / Play Store API)
    IAP-->>GW: 検証結果
    GW->>DB: subscriptions 更新 + profiles.subscription_tier 更新
    GW-->>U: subscription 状態
```

---

## 6. 知識管理設計（memory_search ベース）

### 6.1 方針

OpenClaw memory_search をそのまま RAG として使用。

**決定理由**:
1. 各 svc-* agent の workspace は完全分離 → 開発用 agent の個人データは見えない
2. 知識量が小さい（各 agent ~30KB, ~15-20 files）→ memory_search で十分
3. pgvector/Pinecone 不要 → インフラ・運用コスト削減
4. bge-m3 多言語モデルが Ollama で既に稼働中 → 中日英対応済み
5. ファイル編集 = 知識更新 → パイプライン不要

### 6.2 知識ファイル配置

各 agent の workspace に 2 つのディレクトリを配置:
- **`knowledge/`** — Agent 専用の知識ベース（経験則・判断ロジック・暗黙知）。memory_search + read の対象。Navigator API には公開しない。
- **`guides/`** — ユーザー向け指南コンテンツ。Navigator API で配信。Agent は参照しない。

`memorySearch.extraPaths: ["knowledge"]` が defaults で設定済みのため、knowledge/ は自動的に検索対象になる。

### 6.3 現在の知識ファイル一覧

| Agent | ファイル | 内容 |
|-------|---------|------|
| svc-finance | banks-overview.md | 主要銀行比較表 |
| | account-opening.md | 口座開設手順・必要書類 |
| | remittance.md | 海外送金方法比較 |
| | investment-insurance.md | 投資・保険の基礎 |
| | online-banking.md | ネットバンキング・ATM |
| | faq.md | よくある質問 |
| svc-tax | tax-overview.md | 税制度概要（所得税・住民税） |
| | kakutei-shinkoku.md | 確定申告ガイド |
| | nenkin.md | 年金制度 |
| | social-insurance.md | 社会保険 |
| | furusato-nozei.md | ふるさと納税 |
| | faq.md | よくある質問 |
| svc-visa | residence-status-overview.md | 在留資格概要 |
| | visa-renewal.md | ビザ更新手順 |
| | permanent-residency.md | 永住権申請 |
| | immigration-offices.md | 入管局一覧 |
| | deadline-rules.md | 期限ルール |
| | faq.md | よくある質問 |
| svc-medical | emergency.md | 緊急連絡先・救急ガイド |
| | health-insurance.md | 健康保険制度 |
| | hospital-guide.md | 病院受診ガイド |
| | medical-terms.md | 医療用語集 |
| | mental-health.md | メンタルヘルス |
| | pharmacy-guide.md | 薬局ガイド |
| | vaccination.md | 予防接種 |
| svc-life | housing.md | 住居探し・契約 |
| | transportation.md | 交通・IC カード・免許 |
| | admin-procedures.md | 行政手続き（転入届・マイナンバー） |
| | shopping.md | 買い物・日用品 |
| | cultural-tips.md | 文化 Tips |
| | education.md | 教育・保育 |
| | work-basics.md | 就労の基礎知識 |
| | faq.md | よくある質問 |
| svc-legal | labor-disputes.md | 労働紛争 |
| | accidents.md | 事故対応 |
| | consumer-protection.md | 消費者保護 |
| | crime-victims.md | 犯罪被害 |
| | faq.md | よくある質問 |

### 6.4 知識源と更新頻度

| ドメイン | 主要ソース | 更新頻度 |
|---------|-----------|---------|
| Finance | 金融庁、全銀協、主要銀行公式サイト | 半年 |
| Tax | 国税庁、年金機構、各自治体 | 法改正時・年次 |
| Visa | 入管庁、ISA ポータル | 法改正時 |
| Medical | 厚労省、AMDA 多文化共生ガイド | 四半期 |
| Life | ISA 外国人生活支援ポータル（17言語）、各自治体 | 月次 |
| Legal | 法テラス、弁護士会、厚労省（労働関連） | 法改正時 |

### 6.5 Agent からの知識利用方式

1. `memory_search`: ユーザーの質問から関連知識を意味検索 → 上位 snippets を参考に回答
2. `memory_get`: 検索ヒット後、必要な行だけを取得（コンテキスト節約）
3. `read`: 構造化データ（比較表、フロー定義等）を直接読み込み
4. `web_search` / `web_fetch`: 知識ファイルにない最新情報を補完

### 6.6 将来の拡張

精確なデータ検索（例: 特定の在留資格番号、税率テーブル）が必要になった場合は
データベース（PostgreSQL 等）を追加する。memory_search（意味検索）+ DB（正確検索）の二層構成。

---

## 7. 外部依存

| サービス | 用途 | 料金モデル | MVP 月額想定 | フォールバック |
|---------|------|-----------|-------------|-------------|
| **Claude Sonnet 4.5** (Anthropic) | 全 svc-* agent の LLM | 従量課金 | ¥30,000 | Haiku に切替（品質低下） |
| **Ollama (bge-m3)** | テキスト埋め込み (memory_search) | セルフホスト（無料） | ¥0 | — |
| **Firebase Auth** | 認証 (Email + Apple Sign In) | 50K MAU 無料 | ¥0 (MVP) | 自前 JWT |
| **Apple IAP** | iOS 決済 | 30% 手数料 | 売上連動 | — |
| **Google Play Billing** | Android 決済 | 30% 手数料 | 売上連動 | — |
| **VPS** | OpenClaw + API Gateway 同居 | 月額固定 | ¥5,000-10,000 | — |

**月額合計（MVP）**: 約 ¥35,000-40,000（旧アーキテクチャの ¥56,000 から大幅削減）

---

## 8. デプロイアーキテクチャ

### ホスティング

| コンポーネント | ホスト | 理由 |
|--------------|--------|------|
| Flutter (iOS) | App Store | Flutter build → Xcode Archive → App Store Connect |
| Flutter (Android) | Google Play | Flutter build → AAB → Play Console |
| Flutter (Web) | VPS (nginx) or Cloudflare Pages | 静的ファイルデプロイ |
| API Gateway (FastAPI) | VPS (東京リージョン) | Docker or systemd、OpenClaw と同居 |
| OpenClaw Gateway | VPS (東京リージョン) | 常時稼働デーモン |
| Ollama (bge-m3) | VPS (同上) | memory_search 用 embedding サーバー |
| DB | VPS (同上) | SQLite ファイル |

### CI/CD

```
GitHub Repository (monorepo)
├── app/                       → Flutter App (iOS/Android/Web)
│   ├── lib/
│   │   ├── core/              → DI, theme, constants
│   │   ├── features/          → feature-first 構造
│   │   ├── l10n/              → ARB 多言語ファイル (5言語)
│   │   └── main.dart
│   ├── test/
│   └── pubspec.yaml
├── backend/
│   └── app_service/           → FastAPI (API Gateway)
│       ├── main.py
│       ├── routers/           → chat, navigator, auth, etc.
│       ├── services/          → agent, usage, auth
│       ├── models/            → SQLAlchemy models
│       └── config.py
└── docs/                      → 設計文書
```

**CI/CD パイプライン**:
- `main` push → VPS (API Gateway) 自動デプロイ
- `main` push → SQLite マイグレーション適用
- Release tag → Flutter build ios/android → App Store / Google Play 提出

### 環境

| 環境 | 用途 | URL |
|------|------|-----|
| `development` | ローカル開発 | `localhost:8000` (API Gateway) |
| `production` | 本番 | VPS IP / ドメイン |

---

## 9. 非機能要件

| 項目 | 目標値 | 計測方法 |
|------|--------|---------|
| **API レスポンス時間** (CRUD) | p95 < 300ms | FastAPI ログ |
| **AI Chat レスポンス（routing 含む）** | < 8 秒 (routing ~4s + agent ~4s) | API Gateway ログ |
| **AI Chat レスポンス（routing skip）** | < 5 秒 | domain hint 指定時 |
| **アプリ起動時間** (Cold Start) | < 3 秒 | Flutter DevTools |
| **可用性** | 99.5% (MVP) | Uptime Robot (無料枠) |
| **同時接続** | 100 (MVP 初期) | 負荷テスト |
| **データ暗号化** | 通信: TLS 1.3 | 設定確認 |
| **認証** | Firebase Auth、ID Token 有効期限 1 時間 | 設定確認 |
| **認可** | アプリケーション層で user_id チェック（全 API） | コードレビュー + テスト |
| **個人情報** | PII は SQLite のみに保存。ログに PII を出力しない | コードレビュー |
| **Agent 分離** | svc-* agent 間の knowledge/session は相互不可視 | OpenClaw workspace 分離 |

---

## 10. セキュリティ設計

### Service Agent Tool 制限

- ✅ 許可: `web_search`, `web_fetch`, `read`, `memory_search`, `memory_get`
- ❌ 禁止: 上記以外の全ツール（`exec`, `write`, `edit`, `browser`, `message` 等）

### データ隔離

- Service Agent は OpenClaw 開発用 workspace にアクセス不可
- 各 svc-* agent の memory_search は自 workspace のみ検索
- User データは API Gateway の SQLite に保持（OpenClaw session にはユーザー PII を最小限に）

### Session Key 設計

- 形式: `app_{user_id}_{domain}`（コロン不可 → アンダースコア使用）
- 例: `app_firebase_uid_abc123_banking`
- 開発用 session (`agent:main:*`, `agent:pm:*`) とは名前空間が完全に分離
- `build_session_id()` 関数でコロン等の禁止文字を自動サニタイズ

---

## 変更履歴

- 2026-02-16: 初版作成
- 2026-02-17: Phase 0 アーキテクチャピボット反映（OC Runtime / memory_search / LLM routing / 課金体系更新）
- 2026-02-21: 6 Agent 体系への変更反映（ADR-009: svc-finance / svc-tax / svc-life / svc-legal 追加、concierge 廃止→軽量ルーター）
