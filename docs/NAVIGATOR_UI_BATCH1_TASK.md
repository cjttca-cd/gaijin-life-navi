# Navigator UI 改善 Batch 1 — タスク仕様書

> Owner: PM  
> 優先度: High  
> 上流ドキュメント更新済み: BUSINESS_RULES.md §9, API_DESIGN.md §7, USER_STORIES.md

## 変更一覧

### Task A: TestFlight モードでサブスクリプション非表示

**ファイル**: `app/lib/features/profile/presentation/profile_screen.dart`

**要件**:
- `AppConfig.testFlightMode == true` の場合、アカウント画面の「サブスクリプション」項目（L422 付近）を非表示にする
- `AppConfig` は `app/lib/core/config/app_config.dart` に定義済み（`--dart-define=TESTFLIGHT_MODE=true` で制御）

**実装方針**:
```dart
if (!AppConfig.testFlightMode) ...[
  // subscription ListTile
],
```

---

### Task B: Navigator トップ — 検索バーを AI 向導誘導バナーに置換

**ファイル**: `app/lib/features/navigate/presentation/navigate_screen.dart`

**要件**:
- 既存の検索バー（`_buildSearchBar`）と検索結果表示（`_buildSearchResults`）を完全削除
- 代わりに、ドメイングリッドの上に AI 向導への誘導バナーを表示
- **措辞は正面的**: ❌「找不到信息」→ ✅「AI向導で智能検索、あなたに合った情報をお届け」

**バナーデザイン**:
```
┌─────────────────────────────────────┐
│ 🤖  AI向導でスマート検索              │
│     あなたの状況に合わせた            │
│     パーソナライズ情報をお届けします    │
│              [試してみる →]           │
└─────────────────────────────────────┘
```
- 背景: `theme.colorScheme.primaryContainer`
- ボタン: `FilledButton.tonal` → `context.go(AppRoutes.chat)`
- **5 言語の ARB キーを追加** (zh/ja/en/vi/pt):
  - `navAiSearchTitle`: 「AI向導でスマート検索」/ 「用AI向导智能搜索」
  - `navAiSearchSubtitle`: 「あなたの状況に合わせたパーソナライズ情報をお届けします」/ 「根据您的情况提供个性化信息」
  - `navAiSearchButton`: 「試してみる」/ 「立即体验」

**同時に guide_list_screen.dart の検索バーも削除する**（同じ理由）。

---

### Task C: Coming Soon ドメイン 3 件削除

**バックエンド**: `backend/app_service/routers/navigator.py`

**要件**:
- `DOMAINS` dict から以下 3 件を削除:
  - `housing` (Housing & Utilities)
  - `employment` (Employment & Tax)
  - `education` (Education & Childcare)
- これらは既存の 6 ドメイン (finance/tax/visa/medical/life/legal) に包含されている

**フロントエンド**: `navigate_screen.dart`
- `comingSoonDomains` 関連のコード（フィルタリング、Coming Soon グリッド、snackbar）を削除
- `_DomainCard` の `isComingSoon` パラメータを削除（全て active）

---

### Task D: ドメインカードに概要キーワード追加

**バックエンド**: `backend/app_service/routers/navigator.py`

**要件**:
- 各ドメインの dict に `description` フィールドを追加:

| domain | description (ja) | description (zh) |
|--------|-----------------|-----------------|
| finance | 銀行口座・送金・保険・年金 | 银行开户・汇款・保险・年金 |
| tax | 確定申告・源泉徴収・控除・住民税 | 报税・源泉税・扣除・住民税 |
| visa | 在留資格・更新・変更・永住 | 签证类型・更新・变更・永住 |
| medical | 健康保険・病院・薬局・救急 | 健康保险・就医・药店・急救 |
| life | 引越し・届出・運転免許・防災 | 搬家・行政手续・驾照・防灾 |
| legal | 労働法・契約・相談窓口・権利 | 劳动法・合同・咨询窗口・权利 |

- description は `?lang=xx` で言語切替（ja/zh 対応、他は ja fallback）

**フロントエンド**: `navigate_screen.dart` + `navigator_domain.dart`

- `NavigatorDomain` モデルに `description` フィールド追加
- `_DomainCard` で「X 篇指南」の下に description を 1 行表示:
  ```dart
  Text(
    domain.description ?? '',
    style: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
  ```

---

## テスト要件

- [ ] TestFlight モードでサブスクリプション項目が非表示であること
- [ ] 通常モードではサブスクリプション項目が表示されること
- [ ] Navigator トップに AI 誘導バナーが表示され、タップで Chat 画面に遷移すること
- [ ] Coming Soon カテゴリが表示されないこと
- [ ] 6 ドメイン全てに概要キーワードが表示されること（ja/zh 切替確認）
- [ ] 既存 pytest 全パス

## commit message prefix

`feat: navigator UI batch 1 — hide subscription in TF, replace search with AI banner, remove coming-soon, add domain descriptions`
