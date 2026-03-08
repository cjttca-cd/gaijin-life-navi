# Chat Credits System — 設計書

> 作成: 2026-03-07
> 作成者: Main + Z
> ステータス: **Z 承認済み設計 → PM 実装指示待ち**
> 関連: `tasks/ai-chat-tier-design.md`（v2）、`architecture/BUSINESS_RULES.md` §2

---

## 1. 概要

現行の `daily_usage.deep_count` による固定ルール追跡を、**Credit Ledger（クレジット台帳）** 方式に刷新する。

### 現行の問題

| 問題 | 詳細 |
|------|------|
| Re-engagement が硬直的 | 30日毎1回の固定ルール。特定ユーザーへの柔軟な付与不可 |
| 運営手段がない | キャンペーン、補償、推薦報酬等の付与手段が存在しない |
| 追跡不可 | deep_count は累計値のみ。何回がどの理由で使われたか不明 |
| 従量チャージとの統合困難 | 購入額度の管理に別系統が必要 |

### 新設計の核心

```
ユーザーの利用可能回数 = Σ(有効なクレジット行の remaining)

クレジットの種類:
  - subscription: 月額プランに付随（月末リセット）
  - grant: 運営/システムが付与（期限あり/なし）
  - purchase: ユーザーが購入（原則無期限）
```

---

## 2. データモデル

### 2.1 新テーブル: `chat_credits`

| フィールド | 型 | 制約 | デフォルト | 説明 |
|-----------|------|------|-----------|------|
| id | VARCHAR(36) | PK | UUID v4 | |
| user_id | VARCHAR(128) | FK → profiles(id), NOT NULL | — | 対象ユーザー |
| source | VARCHAR(20) | NOT NULL | — | `'subscription'` / `'grant'` / `'purchase'` |
| source_detail | VARCHAR(100) | NULLable | NULL | 詳細（例: `'spring-campaign-2026'`, `'admin-compensation'`, `'standard-monthly'`, `'pack-50'`） |
| initial_amount | INTEGER | NOT NULL | — | 付与時の総数 |
| remaining | INTEGER | NOT NULL | — | 残数 |
| expires_at | DATETIME | NULLable | NULL | 期限（NULL = 無期限） |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 付与日時 |
| updated_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 最終更新 |

**制約:**
```sql
CHECK (remaining >= 0)
CHECK (remaining <= initial_amount)
CHECK (source IN ('subscription', 'grant', 'purchase'))
```

**インデックス:**
```sql
-- 有効クレジット検索用（消費処理で頻用）
CREATE INDEX idx_chat_credits_user_active
    ON chat_credits(user_id, expires_at)
    WHERE remaining > 0;
```

### 2.2 既存テーブルとの関係

| テーブル | 変更 |
|---------|------|
| `daily_usage` | **変更なし**。`deep_count` は日次ログ（analytics 用）として引き続き increment。課金判定には使用しない |
| `profiles` | **変更なし**。`subscription_tier` は引き続きティア判定に使用 |

### 2.3 Migration

```sql
-- 004_create_chat_credits.sql

CREATE TABLE chat_credits (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(128) NOT NULL REFERENCES profiles(id),
    source VARCHAR(20) NOT NULL CHECK (source IN ('subscription', 'grant', 'purchase')),
    source_detail VARCHAR(100),
    initial_amount INTEGER NOT NULL,
    remaining INTEGER NOT NULL CHECK (remaining >= 0 AND remaining <= initial_amount),
    expires_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_chat_credits_user_active
    ON chat_credits(user_id, expires_at)
    WHERE remaining > 0;

-- 既存 Free ユーザーのマイグレーション:
-- lifetime deep_count を chat_credits に変換
-- INSERT INTO chat_credits (id, user_id, source, source_detail, initial_amount, remaining, expires_at)
-- SELECT hex(randomblob(16)), du_agg.user_id, 'grant', 'migration-free-5',
--        5, MAX(0, 5 - du_agg.total_deep), NULL
-- FROM (SELECT user_id, SUM(deep_count) as total_deep FROM daily_usage GROUP BY user_id) du_agg
-- JOIN profiles p ON p.id = du_agg.user_id
-- WHERE p.subscription_tier = 'free';
```

---

## 3. 消費ロジック

### 3.1 消費優先順位

**原則: 最早到期的先用（減少浪費）**

```python
# 有効クレジットの取得順序
SELECT * FROM chat_credits
WHERE user_id = :uid
  AND remaining > 0
  AND (expires_at IS NULL OR expires_at > NOW())
ORDER BY
  expires_at ASC NULLS LAST,           -- 期限が近いものを先に
  CASE source                          -- 同日到期時の tiebreaker
    WHEN 'grant' THEN 0                -- Grant 優先（無料分を先に消費）
    WHEN 'subscription' THEN 1         -- 次に訂閲
    WHEN 'purchase' THEN 2             -- 購入分は最後（ユーザーが払った分を保護）
  END,
  created_at ASC                       -- 最終 tiebreaker: FIFO
LIMIT 1;
```

### 3.2 消費フロー（2 段階: `check_balance()` + `consume_after_success()`）

Agent 呼出前に credit を消費しない。成功後のみ消費する（Plan B）。

**Step A: Pre-flight チェック（`check_balance()`、Agent 呼出前）**
```
1. tier == 'guest' → 403 CHAT_REQUIRES_AUTH
2. tier == 'premium' or 'premium_plus' → 無制限（直接許可）
3. 有効クレジット残高を照会（消費しない）
   → remaining > 0 → allowed=True
   → remaining == 0 → Re-engagement 判定 → 付与されれば allowed=True / なければ 429
```

**Step B: 成功後消費（`consume_after_success()`、Agent 呼出成功後）**
```
1. premium/premium_plus → deep_count +1 のみ（クレジット不要）
2. 有効クレジット行を優先順で 1 行取得 → remaining -= 1
3. deep_count +1（analytics 用）
4. 競合状態: check_balance〜consume 間にクレジット枯渇した場合
   → Agent 応答は正常返却（失敗させない）
   → warning ログ記録、1 回分は無料扱い
```

**設計根拠**: Agent 呼出が失敗（502/タイムアウト）した場合、ユーザーの
クレジットは消費されない。成功した応答に対してのみ課金する。

### 3.3 残高照会

```python
# ユーザーの利用可能残高
SELECT
  SUM(remaining) as total_remaining,
  SUM(CASE WHEN source = 'subscription' THEN remaining ELSE 0 END) as subscription_remaining,
  SUM(CASE WHEN source = 'grant' THEN remaining ELSE 0 END) as grant_remaining,
  SUM(CASE WHEN source = 'purchase' THEN remaining ELSE 0 END) as purchase_remaining
FROM chat_credits
WHERE user_id = :uid
  AND remaining > 0
  AND (expires_at IS NULL OR expires_at > NOW());
```

---

## 4. クレジット付与パターン

### 4.1 訂閲額度（Subscription Credits）

| ティア | 月次付与 | 期限 |
|--------|---------|------|
| Free | 初回登録時に 5 回（lifetime、無期限） | NULL（無期限） |
| Standard | 毎月初に 300 回 | 当月末 |
| Premium | なし（クレジット不要、コード側で無制限判定） | — |

**Standard の月次リセット:**
- 請求サイクル開始時に新しい `chat_credits` 行を作成
- `source='subscription'`, `source_detail='standard-monthly'`
- `initial_amount=300`, `remaining=300`
- `expires_at=請求サイクル終了日`
- 前月の未使用分は期限切れにより自動消滅（繰越なし）

### 4.2 Grant（運営付与）

柔軟な付与メカニズム。以下のシナリオを全てカバー:

| シナリオ | source_detail 例 | amount | expires_at |
|---------|-----------------|--------|------------|
| Re-engagement（自動） | `re-engagement-2026-03` | 1〜N（設定可） | 30日後 |
| 季節キャンペーン | `spring-campaign-2026` | 3 | キャンペーン終了日 |
| 客服補償 | `admin-compensation` | 5 | 90日後 or NULL |
| 推薦報酬 | `referral-reward` | 2 | NULL |
| Profile 完善報酬 | `profile-completion` | 1 | NULL |
| バグ補償 | `bug-compensation-#123` | 3 | NULL |

### 4.3 Purchase（従量チャージ）

| パック | 価格 | amount | expires_at |
|--------|------|--------|------------|
| 50回パック | ¥180 | 50 | NULL（無期限） |
| 100回パック | ¥360 | 100 | NULL（無期限） |

※ Apple IAP / Google Play の実装は Phase D（将来）。

---

## 5. Re-engagement ルール（Grant 自動付与）

**現行設計（廃止）:** 30日毎に1回、全 Free ユーザーに固定付与

**新設計:** 設定可能なルールエンジン（初期はシンプル実装）

### 5.1 初期ルール（config.py で設定）

```python
REENGAGE_CONFIG = {
    "enabled": True,
    "eligible_tiers": ["free"],          # 対象ティア
    "condition": "all_credits_exhausted", # 全クレジット消費済み
    "cooldown_days": 30,                 # 前回付与からの最低間隔
    "grant_amount": 1,                   # 付与数
    "grant_expires_days": 30,            # 付与の有効期限（日数）
    "source_detail": "re-engagement",    # 追跡用ラベル
}
```

### 5.2 判定ロジック

```
ユーザーが Chat にアクセスした時:
1. 有効クレジット残高 > 0 → 通常消費フロー
2. 有効クレジット残高 == 0 → Re-engagement 判定:
   a. tier が eligible_tiers に含まれるか
   b. 最後の re-engagement grant の created_at + cooldown_days < NOW()
   c. 全条件 OK → Grant 自動作成 → 消費フロー へ
   d. 条件 NG → 429 + 購入/アップグレード CTA
```

### 5.3 将来拡張

ルールを DB テーブルに移し、管理画面から CRUD 可能にする（Phase 2 以降）。

---

## 6. API 設計

### 6.1 ユーザー向け API

#### `GET /api/v1/credits/balance`

ユーザーの利用可能残高を返す。

```json
{
  "data": {
    "total_remaining": 8,
    "breakdown": {
      "subscription": { "remaining": 5, "expires_at": "2026-03-31T23:59:59Z" },
      "grant": { "remaining": 3, "expires_at": "2026-04-15T00:00:00Z" },
      "purchase": { "remaining": 0, "expires_at": null }
    },
    "next_expiry": "2026-03-31T23:59:59Z",
    "tier": "standard"
  }
}
```

#### `POST /api/v1/chat`（既存 — レスポンス拡張）

Chat レスポンスの `usage` オブジェクトを拡張:

```json
{
  "usage": {
    "credit_used_from": "grant",
    "total_remaining": 7,
    "tier": "standard"
  }
}
```

### 6.2 管理者向け API（将来）

初期は Backend の直接 DB 操作 or Admin CLI で対応。
管理画面 API は Phase 2 以降:

```
POST /api/v1/admin/credits/grant          — 単一ユーザーへの付与
POST /api/v1/admin/credits/grant-batch    — 条件指定の一括付与
GET  /api/v1/admin/credits/{user_id}      — ユーザーのクレジット履歴
```

---

## 7. 影響範囲

### 7.1 Backend 変更

| ファイル | 変更内容 | 規模 |
|---------|---------|------|
| `models/chat_credit.py` | **新規**: ChatCredit モデル | 新規 |
| `models/__init__.py` | ChatCredit を追加 | 1行 |
| `migrations/004_create_chat_credits.sql` | **新規**: テーブル作成 + 既存データ移行 | 新規 |
| `services/usage.py` | `check_balance()` + `consume_after_success()` の 2 段階消費。Agent 成功後のみ credit 消費 | 大改修 |
| `services/credits.py` | **新規**: Grant 付与、残高照会、Re-engagement 判定 | 新規 |
| `routers/chat.py` | usage レスポンスの拡張 | 小修正 |
| `routers/usage_router.py` | balance エンドポイント追加 or 既存レスポンス拡張 | 中修正 |
| `config.py` | Re-engagement 設定追加 | 小修正 |

### 7.2 Frontend 変更

| ファイル | 変更内容 | 規模 |
|---------|---------|------|
| Chat UI（usage_counter.dart） | 残高表示を source 別に更新 | 中修正 |
| Chat response model | `credit_used_from` フィールド追加 | 小修正 |

### 7.3 変更しないもの

| ファイル | 理由 |
|---------|------|
| `daily_usage` テーブル | Analytics 用として維持。deep_count は引き続き increment |
| `profiles.subscription_tier` | ティア判定のソースとして維持 |
| Navigator API | Guide アクセスに Credit は関係しない |

---

## 8. 設計文書の更新対象

| ファイル | 更新内容 |
|---------|---------|
| `architecture/DATA_MODEL.md` | §新規: chat_credits テーブル定義 |
| `architecture/BUSINESS_RULES.md` §2 | Credit Ledger 方式への書き換え + Re-engagement 柔軟化 |
| `architecture/API_DESIGN.md` | credits/balance エンドポイント追加 + chat レスポンス拡張 |
| `tasks/ai-chat-tier-design.md` §1 | Re-engagement を「Grant の一種」に再定義 |
| `tasks/ai-chat-implementation-gap.md` | Gap 1/2/8 を本設計で統合解決と明記 |

---

## 9. テスト要件

### 9.1 単体テスト

- [ ] Credit 消費: 最早到期先用
- [ ] Credit 消費: 同日到期時の tiebreaker（grant → subscription → purchase）
- [ ] Credit 消費: 期限切れ行をスキップ
- [ ] Credit 消費: 残高ゼロで 429
- [ ] Re-engagement: 条件充足で自動 Grant 作成
- [ ] Re-engagement: cooldown 期間内で拒否
- [ ] Re-engagement: 対象外ティアで拒否
- [ ] Premium: Credit 不要で無制限通過
- [ ] Guest: 403
- [ ] 残高照会: source 別の正確な集計

### 9.2 Integration テスト

- [ ] Free ユーザー: 5回消費 → 429 → 30日後 re-engagement → 1回消費
- [ ] Standard ユーザー: 月次クレジット + Grant 併用時の消費順序
- [ ] マイグレーション: 既存 daily_usage データからの正確な変換

---

## 10. 実装順序（PM への指示）

### Phase 1: Core（最優先）
1. `chat_credit.py` モデル作成
2. `004_create_chat_credits.sql` マイグレーション
3. `credits.py` サービス（付与、消費、残高照会）
4. `usage.py` リファクタ（Credit Ledger ベース）
5. 単体テスト

### Phase 2: API + Frontend
6. `usage_router.py` に balance エンドポイント
7. `chat.py` レスポンス拡張
8. Flutter: usage_counter.dart 更新
9. Integration テスト

### Phase 3: Re-engagement
10. Re-engagement 自動判定ロジック
11. config.py にルール設定
12. Re-engagement テスト

### Phase 4: 設計文書同期
13. DATA_MODEL.md, BUSINESS_RULES.md, API_DESIGN.md 更新

---

## 変更履歴

- 2026-03-07: 初版作成（Z 承認済み設計方針に基づく）
