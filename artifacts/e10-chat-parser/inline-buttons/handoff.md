# Chat Inline Tracker Buttons — Handoff

## Intent
Replace bottom-of-bubble tracker card section with inline □-line save buttons rendered within the message body.

## Non-goals
- Backend changes
- tracker_edit_sheet.dart changes
- l10n additions

## Status: ✅ Complete

## Changes

### Modified
- `app/lib/features/chat/presentation/widgets/message_bubble.dart`
  - `_AiBubble`: replaced single `MarkdownBody` with `_buildContentWithInlineTrackers()` method
  - Removed `TrackerItemCards` section and its import
  - Added `_buildContentWithInlineTrackers()` on `_AiBubble` — splits content via `_splitByCheckboxLines`, renders □ lines as `_CheckboxActionRow`, normal text as `MarkdownBody`
  - Added import for `chat_response.dart` (for `ChatTrackerItem` constructor) and `tracker_edit_sheet.dart`

### New (in message_bubble.dart)
- `_ContentSegment` — data class with `text`, `isCheckbox`, `matchedItem`
- `_splitByCheckboxLines(content, trackerItems)` — splits text into segments; consecutive normal lines merged; □ lines matched to `trackerItems` by title containment with fallback
- `_CheckboxActionRow` — StatelessWidget: □ text + `Icons.bookmark_add_outlined` (20px) save button; `surfaceContainerHighest` @ 0.4 alpha bg; padding 12h/8v; radius 8; taps open `TrackerEditSheet`

### Deleted
- `app/lib/features/chat/presentation/widgets/tracker_item_card.dart` — was only imported by message_bubble.dart

## Verification
1. `flutter analyze` → No issues found
2. `dart format --set-exit-if-changed` → 0 changed
3. Manual checklist:
   - □ lines render inline with save buttons
   - Non-□ messages render as pure MarkdownBody
   - Save button opens TrackerEditSheet with title pre-filled
   - No bottom tracker card section
   - Multiple scattered □ lines all get buttons
   - □ text wraps (no truncation)

## Gaps
- Unit tests not added (UI rendering logic; verified via static analysis only)

## Next Steps
- Visual QA on device
