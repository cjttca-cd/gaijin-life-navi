# Navigator UI 改善 Batch 2 — タスク仕様書

> Owner: PM
> 優先度: High
> 上流ドキュメント更新済み: BUSINESS_RULES.md §4, API_DESIGN.md §2, USER_STORIES.md US-202/203

## ⚠️ 回帰リスク管理（必読）

本 Batch は 5 ファイル + 1 新規ファイルに影響する。以下の依存関係を必ず把握してから着手すること。

### 影響マップ

```
Backend:
  navigator.py  ← Task A (tags 追加)
    └→ list_guides() / get_guide() のレスポンスに tags フィールド追加
    └→ 既存フィールドは一切変更しない（後方互換）

Frontend:
  navigator_domain.dart  ← Task B (model 拡張)
    └→ NavigatorGuide に tags 追加
    └→ NavigatorGuideDetail に tags + readingTimeMin 追加
    └→ 既存フィールドは一切削除しない

  guide_list_screen.dart  ← Task C (UI 改善)
    └→ _GuideCard リデザイン
    └→ Domain header 追加
    └→ ⚠️ DomainColors / AppSpacing への依存は変更しない

  guide_detail_screen.dart  ← Task D (UI 改善)
    └→ Hero header 追加
    └→ Related guides セクション追加
    └→ ⚠️ _markdownStyleSheet() は変更しない（message_bubble.dart にも同名メソッドがあるが独立）
    └→ ⚠️ _buildLockedView() のロジックは変更しない

  tracker_item_card.dart  ← Task E (確認フロー)
    └→ _SaveButton.onSave → BottomSheet 経由に変更
    └→ ⚠️ TrackerItemCards のレイアウト・表示条件は変更しない
    └→ ⚠️ trackerItemsProvider / isTrackerItemSavedProvider の API は変更しない

  tracker_edit_sheet.dart  ← Task E (新規ファイル)
    └→ 新規追加のみ、既存ファイルへの影響なし
```

### 実行順序（必須）

```
Task A (Backend) → Task B (Model) → Task C + D (並行可) → Task E
```

Task C/D は互いに独立だが、Task B の model 変更に依存。Task E は独立だが最後に実施（テスト時に全体を通して確認するため）。

---

## Task A: Backend — tags フィールドをガイド API に追加

**ファイル**: `backend/app_service/routers/navigator.py`

**要件**:
- `_parse_md_file()` が返す dict に `tags` フィールドを追加（frontmatter の `tags` リストをそのまま返す。なければ空リスト `[]`）
- `list_guides()` のレスポンスに `tags` を含める
- `get_guide()` のレスポンス（full content / locked 両方）に `tags` を含める
- `reading_time_min` を `get_guide()` のレスポンスに追加: CJK文字ベース `max(1, cjk_count // 500)`、Latin は `max(1, word_count // 200)`

**実装方針**:
```python
# _parse_md_file() に追加:
"tags": meta.get("tags", []),

# get_guide() の full content レスポンスに追加:
"tags": parsed["tags"],
"reading_time_min": _estimate_reading_time(parsed["body"]),

# list_guides() の各 guide に追加:
"tags": parsed["tags"],

# 新規ヘルパー:
def _estimate_reading_time(body: str) -> int:
    """Estimate reading time in minutes. CJK: ~500 chars/min, Latin: ~200 words/min."""
    import unicodedata
    cjk_count = sum(1 for c in body if unicodedata.category(c).startswith('Lo'))
    if cjk_count > len(body) * 0.3:  # Primarily CJK text
        return max(1, cjk_count // 500)
    else:
        return max(1, len(body.split()) // 200)
```

**後方互換性**: ✅ 新規フィールド追加のみ。既存フィールド変更なし。Flutter 側は `tags` がなくても `[]` になる設計。

**テスト**: 既存テスト (`test_navigator_access.py`) が pass すること + `tags` フィールドの存在を確認する新テスト追加。

---

## Task B: Frontend Model — NavigatorGuide / NavigatorGuideDetail 拡張

**ファイル**: `app/lib/features/navigate/domain/navigator_domain.dart`

**要件**:

### NavigatorGuide に追加:
```dart
class NavigatorGuide {
  // 既存フィールドはすべて維持
  final List<String> tags;  // ← 追加

  const NavigatorGuide({
    // ...既存...
    this.tags = const [],  // ← 追加
  });

  factory NavigatorGuide.fromJson(Map<String, dynamic> json) {
    return NavigatorGuide(
      // ...既存...
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  NavigatorGuide withDomain(String domainId) {
    return NavigatorGuide(
      // ...既存...
      tags: tags,  // ← 追加
    );
  }
}
```

### NavigatorGuideDetail に追加:
```dart
class NavigatorGuideDetail {
  // 既存フィールドはすべて維持
  final List<String> tags;       // ← 追加
  final int readingTimeMin;      // ← 追加

  const NavigatorGuideDetail({
    // ...既存...
    this.tags = const [],
    this.readingTimeMin = 0,
  });

  factory NavigatorGuideDetail.fromJson(Map<String, dynamic> json) {
    return NavigatorGuideDetail(
      // ...既存...
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? const [],
      readingTimeMin: json['reading_time_min'] as int? ?? 0,
    );
  }
}
```

**後方互換性**: ✅ default 値あり。API が返さなくても crash しない。

---

## Task C: Guide List (S10) — UI 改善

**ファイル**: `app/lib/features/navigate/presentation/guide_list_screen.dart`

**要件**:

### C-1: Domain ヘッダー追加
ガイドリストの上部に domain 情報ヘッダーを追加:

```
┌──────────────────────────────────────┐
│  🏦  Finance & Banking              │
│  6 guides                           │
└──────────────────────────────────────┘
```

- 背景色: `colors.container` (domain 固有色の薄い版)
- アイコン: `DomainColors.iconForDomain(domain)` + `colors.icon`
- ラベル: `_getDomainLabel()` (既存メソッド流用)
- ガイド数: `"${guides.length} guides"` (l10n 対応: `guideCount`)
- 角丸: 12dp
- padding: `AppSpacing.spaceLg`

### C-2: GuideCard リデザイン

現在:
```
┌─────────────────────────────────────┐
│▌ Title                          🔒  │
│▌ Summary text...                    │
└─────────────────────────────────────┘
```

改善後:
```
┌─────────────────────────────────────┐
│▌ Title                      [FREE] │
│▌ Summary text...                    │
│▌ [tag1] [tag2] [tag3]              │
└─────────────────────────────────────┘
```

変更点:
1. **Access badge**: lock アイコンの代わりにバッジ表示
   - `free`/`public` → 緑バッジ `FREE`（色: `AppColors.success` / `AppColors.successContainer`）
   - `registered`/`premium` → ロック付きバッジ 🔒（色: `theme.colorScheme.outlineVariant`）
   - TestFlight mode では全て `FREE` 表示でも可（全コンテンツ見えるため）
2. **Tags chips**: summary の下に tags を `Wrap` + small chip で表示
   - 最大 3 個まで（4 個目以降は非表示）
   - サイズ: `labelSmall` / height 24dp
   - 色: `colors.container` 背景 + `colors.icon` テキスト
   - 角丸: 999 (pill shape)

### C-3: l10n キー追加

```
guideCount: "{count} guides" / "{count} 件のガイド" / "{count}篇指南"
guideFreeLabel: "FREE" / "無料" / "免费"
```

5言語 ARB ファイルに追加（zh/ja/en/vi/pt）。

---

## Task D: Guide Detail (S11) — UI 改善

**ファイル**: `app/lib/features/navigate/presentation/guide_detail_screen.dart`

**要件**:

### D-1: Hero ヘッダー改善

現在:
```
Title (headlineLarge)
──────────────────────
Markdown content...
```

改善後:
```
┌──────────────────────────────────────┐
│  🏦 Finance                         │
│                                      │
│  外国人银行开户指南                    │
│                                      │
│  📖 3 min read                       │
│  [银行] [开户] [外国人]               │
└──────────────────────────────────────┘
──────────────────────────────────────
Markdown content...
```

- Domain badge: アイコン + ドメイン名（`bodySmall` / `colors.icon`）
- Title: そのまま `headlineLarge`
- Reading time: `📖 {n} min` （`readingTimeMin` が 0 なら非表示）
- Tags: `Wrap` + pill chips（Task C と同じスタイル）
- 背景色: `colors.container` (domain 固有色)
- padding: screenPadding horizontal, spaceLg vertical
- 角丸: 下部のみ 16dp（AppBar と連続する見た目）

### D-2: Related Guides セクション

ガイド本文の下（Ask AI ボタンの上）に「同じ領域の他のガイド」を表示:

```
──────────────────────────────────────
📚 このドメインの他のガイド
┌──────────────────────────────────────┐
│▌ Credit Cards for Foreigners    🔒  │
│▌ Apply for credit cards in...       │
├──────────────────────────────────────┤
│▌ Insurance Basics              FREE │
│▌ Health insurance system...         │
└──────────────────────────────────────┘
```

- データソース: `domainGuidesProvider(domain)` を `ref.watch()` して、現在の slug を除外
- 最大 3 件表示
- 各アイテムは Task C の `_GuideCard` と同じデザイン（ただし tags は非表示 — コンパクトに）
- タップで `context.push('${AppRoutes.navigate}/$domain/${guide.slug}')`

### D-3: l10n キー追加

```
guideReadingTime: "{min} min read" / "約{min}分" / "约{min}分钟"
guideRelatedTitle: "Other guides in this domain" / "このドメインの他のガイド" / "同领域其他指南"
```

5言語 ARB ファイルに追加。

### D-4: ⚠️ 変更禁止箇所

以下は **絶対に変更しないこと**（回帰リスク）:
- `_buildLockedView()` のロジック・レイアウト
- `_markdownStyleSheet()` の定義
- `_GuestContentGate` / `_PremiumContentGate` ウィジェット
- アクセス制御分岐ロジック (`showFullContent`, `isLocked`)
- Analytics イベント (`logGuideViewed`, `logUpgradeCTATapped`)

---

## Task E: Tracker Item 確認フロー

**ファイル**:
- `app/lib/features/chat/presentation/widgets/tracker_item_card.dart` （既存修正）
- `app/lib/features/chat/presentation/widgets/tracker_edit_sheet.dart` （**新規作成**）

**要件**:

### E-1: TrackerEditSheet（新規 BottomSheet）

「Save」ボタン押下時に直接保存する代わりに、BottomSheet を表示して内容を確認・編集してから保存する。

```
┌──────────────────────────────────────┐
│  ── ドラッグハンドル ──               │
│                                      │
│  📋 Add to Tracker                   │
│                                      │
│  Title                               │
│  ┌──────────────────────────────────┐│
│  │ 区役所で転入届を提出する          ││
│  └──────────────────────────────────┘│
│                                      │
│  Memo (optional)                     │
│  ┌──────────────────────────────────┐│
│  │                                  ││
│  │                                  ││
│  └──────────────────────────────────┘│
│                                      │
│  Due Date (optional)                 │
│  ┌──────────────────────────────────┐│
│  │ 📅  2026-03-15              [×] ││
│  └──────────────────────────────────┘│
│                                      │
│  ┌──────────────────────────────────┐│
│  │          Save to Tracker         ││
│  └──────────────────────────────────┘│
│                                      │
│  Cancel                              │
└──────────────────────────────────────┘
```

**フィールド**:
- **Title**: `TextFormField` — pre-filled with `item.title`。編集可能。required。
- **Memo**: `TextFormField` — 空。任意。maxLines: 3。
- **Due Date**: Date picker。pre-filled with `item.date` (パース可能な場合)。クリアボタン付き。
  - `item.date` のパース: `DateTime.tryParse()` を試みる。失敗したら空のまま。
  - タップで `showDatePicker()` 表示
- **Save ボタン**: `FilledButton`。Title が空なら disabled。
- **Cancel**: `TextButton` — BottomSheet を閉じるだけ。

**保存処理**:
```dart
// 既存の trackerItemsProvider.notifier.add() を呼ぶ
final newItem = TrackerItem(
  id: TrackerItem.generateId(),
  title: titleController.text.trim(),
  memo: memoController.text.trim().isEmpty ? null : memoController.text.trim(),
  dueDate: selectedDate,
  tag: item.type,  // ChatTrackerItem.type → TrackerItem.tag
  completed: false,
  createdAt: DateTime.now(),
);
await ref.read(trackerItemsProvider.notifier).add(newItem);
```

保存後:
1. BottomSheet を閉じる
2. SnackBar: `l10n.trackerItemSaved`
3. `isTrackerItemSavedProvider(item.title)` が `true` になる（既存メカニズム）

### E-2: _SaveButton 修正

**変更**: `_onSave()` で直接保存する代わりに BottomSheet を開く。

```dart
Future<void> _onSave(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final limitReached = ref.read(trackerLimitReachedProvider);

  if (limitReached) {
    // 既存のリミット超過ロジックはそのまま維持
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.trackerLimitReached),
          action: SnackBarAction(
            label: l10n.chatLimitUpgrade,
            onPressed: () => context.push(AppRoutes.subscription),
          ),
        ),
      );
    }
    return;
  }

  // BottomSheet を開く（直接保存の代わり）
  if (context.mounted) {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TrackerEditSheet(item: item),
    );
  }
}
```

### E-3: l10n キー追加

```
trackerEditTitle: "Add to Tracker" / "トラッカーに追加" / "添加到待办"
trackerEditFieldTitle: "Title" / "タイトル" / "标题"
trackerEditFieldMemo: "Memo (optional)" / "メモ（任意）" / "备注（可选）"
trackerEditFieldDate: "Due Date (optional)" / "期日（任意）" / "截止日期（可选）"
trackerEditSave: "Save to Tracker" / "トラッカーに保存" / "保存到待办"
trackerEditCancel: "Cancel" / "キャンセル" / "取消"
```

5言語 ARB ファイルに追加。

### E-4: ⚠️ 変更禁止箇所

以下は **絶対に変更しないこと**:
- `TrackerItemCards` のレイアウト・Column 構造
- `_TrackerItemCard` の表示レイアウト（icon, title, date, saved badge）
- `trackerItemsProvider` / `isTrackerItemSavedProvider` の API
- `saveFromChat()` メソッド（今回は使わなくなるが削除しない — 後方互換）

---

## テスト要件

### 既存テスト（パス必須）
- `backend/tests/test_navigator_access.py` — 全 pass
- Flutter: `flutter analyze` — エラー 0

### 新規テスト
1. **Backend**: `test_navigator_access.py` に `tags` フィールド存在確認テストを追加
2. **Backend**: `reading_time_min` が正の整数であることを確認
3. **Frontend**: 既存の widget test があれば、新 UI でも pass すること確認

### 手動確認チェックリスト
- [ ] Guide List: domain header が正しいアイコン・色・ラベルで表示される
- [ ] Guide List: FREE badge と 🔒 badge が正しい guide に表示される
- [ ] Guide List: tags が最大 3 つまで表示される
- [ ] Guide Detail: hero header にドメイン badge + タイトル + 読了時間 + tags が表示される
- [ ] Guide Detail: Related Guides が現在のガイド以外を最大 3 件表示する
- [ ] Guide Detail: Related Guide タップで正しいガイドに遷移する
- [ ] Guide Detail: Locked view が従来通り動作する（回帰テスト）
- [ ] Chat: Tracker item の「Save」ボタンで BottomSheet が開く
- [ ] Chat: Title が pre-filled されている
- [ ] Chat: Date が parsable な場合 pre-filled されている
- [ ] Chat: Memo を入力して保存 → Tracker 画面で memo が表示される
- [ ] Chat: 保存後に「Saved」バッジに変わる
- [ ] Chat: Limit 到達時は BottomSheet ではなく既存の SnackBar が出る

---

## Git コミット方針

```
feat(navigator): add tags + reading time to guide API [batch2-A]
feat(navigator): extend guide models with tags + readingTime [batch2-B]
feat(navigator): enhance guide list UI with domain header + badges + tags [batch2-C]
feat(navigator): enhance guide detail with hero header + related guides [batch2-D]
feat(chat): add tracker item edit sheet with confirmation flow [batch2-E]
```

各 Task ごとに commit。全 Task 完了後に push。
