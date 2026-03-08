# Chat Inline Tracker Buttons — □ 行インラインセーブボタン

## 背景

現在: tracker_items がチャット回答の下に別カードとして表示される → テキスト截断で内容が見えない、文脈から切り離されている。
変更: □ 行を回答本文の中でそのまま表示し、各 □ 行の右端に小さなセーブボタンを配置。底部のカードセクションは廃止。

## 変更対象

Frontend のみ。Backend 変更なし。

## 要件

### Task A: message_bubble.dart — MarkdownBody を置き換え

現在 `MarkdownBody(data: message.content)` で回答全体をレンダリングしている。

□ 行を認識してインラインボタンを付けるため、**回答テキストを行単位で分割し、□ 行と通常テキストを別々にレンダリングする**方式に変更。

**実装方針:**

```dart
// message.content を行グループに分割
// - 通常テキスト行 → MarkdownBody でレンダリング
// - □ で始まる行 → _CheckboxActionRow ウィジェットでレンダリング

Widget _buildContentWithInlineTrackers(
  BuildContext context,
  String content,
  List<ChatTrackerItem>? trackerItems,
) {
  final segments = _splitByCheckboxLines(content);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: segments.map((seg) {
      if (seg.isCheckbox) {
        return _CheckboxActionRow(
          text: seg.text,           // □ を除いたテキスト
          trackerItem: seg.matchedItem,  // tracker_items から title マッチで取得
          onSave: () => _openTrackerEditSheet(context, seg.matchedItem),
        );
      } else {
        return MarkdownBody(
          data: seg.text,
          selectable: true,
          styleSheet: _markdownStyleSheet(context),
        );
      }
    }).toList(),
  );
}
```

### Task B: _CheckboxActionRow ウィジェット（新規）

□ 行 1 行分をレンダリングするウィジェット。

```
┌─────────────────────────────────────────────────┐
│ □ 在留カードを持って最寄りの銀行窓口へ行く  [💾] │
└─────────────────────────────────────────────────┘
```

仕様:
- 左: □ マーカー + テキスト（折り返し可、截断禁止）
- 右: 小さなセーブアイコンボタン（`Icons.bookmark_add_outlined` または `Icons.add_task`、サイズ 20）
- テキストは `bodyMedium` スタイル
- □ 記号はテキストの一部としてそのまま表示（ユーザーに「これは行動項目だ」と視覚的に伝える）
- 背景: 軽い surface variant（`colorScheme.surfaceContainerHighest` with low opacity）で通常テキストと区別
- パディング: 水平 12, 垂直 8
- 角丸: 8
- セーブボタン押下 → `TrackerEditSheet` を `showModalBottomSheet` で表示（既存の仕組みをそのまま利用）

### Task C: 底部 tracker カードセクション削除

`message_bubble.dart` から以下を削除:

```dart
// Tracker items section.
if (message.trackerItems != null &&
    message.trackerItems!.isNotEmpty)
  TrackerItemCards(items: message.trackerItems!),
```

`tracker_item_card.dart` ファイルは削除可（他で使われていなければ）。
`import 'tracker_item_card.dart';` も削除。

### Task D: _splitByCheckboxLines ヘルパー

`message.content` テキストを以下のセグメントに分割:

```dart
class _ContentSegment {
  final String text;
  final bool isCheckbox;
  final ChatTrackerItem? matchedItem;  // nullable
}
```

分割ルール:
- `^\s*□` にマッチする行 → `isCheckbox: true`
- 連続する通常行 → 1 つの `isCheckbox: false` セグメントにまとめる（MarkdownBody に渡す）
- `matchedItem`: `message.trackerItems` から `title` が含まれるものを探す。見つからなければ title=行テキスト, type="task" でフォールバック ChatTrackerItem を生成

### Task E: tracker_edit_sheet.dart との連携

既存の `TrackerEditSheet` をそのまま使う。`_CheckboxActionRow` のセーブボタン押下時:

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (_) => TrackerEditSheet(item: trackerItem),
);
```

変更なし（既存のまま）。

## NOT in scope

- Backend 変更なし
- `tracker_edit_sheet.dart` の変更なし
- `chat_response.dart` / `chat_message.dart` の変更なし
- l10n 追加不要（既存キーで足りる）
- `source_citation.dart` の変更なし

## 手動検証チェックリスト

1. □ 行が回答本文内にインラインで表示され、右端にセーブボタンがある
2. セーブボタン押下 → TrackerEditSheet が開き、タイトルが事前入力されている
3. □ 行のテキストが全文表示される（截断なし）
4. □ 行が背景色で通常テキストと視覚的に区別される
5. □ がない回答 → 通常通り MarkdownBody のみでレンダリング
6. 底部に tracker カードセクションが表示されない
7. 長い □ テキストが折り返される
8. 複数の □ 行が文中に散在している場合、全てにセーブボタンがある
