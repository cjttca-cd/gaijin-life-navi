# Patch: Chat Parser Reform — Inline □ Migration

## Change Summary

Migrated `_extract_blocks()` in `chat.py` from block-based (`---TRACKER---`/`---ACTIONS---`) parsing to inline `□` scanning. The function now:

1. Scans all lines for `^\s*□` patterns → extracts as `tracker_items`
2. Keeps `□` lines in the reply text (not removed)
3. Continues to extract and remove `---SOURCES---` blocks as before
4. Returns `actions` as always-empty list (deprecated)
5. Strips orphan `---TRACKER---`/`---ACTIONS---` markers from clean text

## Deleted Code

| Item | Description |
|------|-------------|
| `_TRACKER_RE` | `_build_block_re("TRACKER")` regex |
| `_ACTIONS_RE` | `_build_block_re("ACTIONS")` regex |
| TRACKER/ACTIONS `.finditer()` loops | Block-based extraction |
| TRACKER/ACTIONS `.sub()` calls | Block-based cleanup |
| Fallback: code block □ detection | `code_block_re` scanning |
| Fallback: consecutive □ line detection | `checkbox_run` logic |
| Fallback cleanup: `knowledge/` / `guides/` leak removal | Regex-based line removal |
| Fallback cleanup: `※` disclaimer removal | Trailing disclaimer strip |

## Preserved Code

- `_build_block_re()` — still used by `_SOURCES_RE`
- `_SOURCES_RE` — unchanged
- `_get_block_content()` — still used for SOURCES
- `_parse_source_lines()` — unchanged
- `_parse_tracker_lines()` — unchanged, now fed individual □ lines

## Verification

- `grep -n "TRACKER_RE\|ACTIONS_RE\|Fallback" backend/app_service/routers/chat.py` → 0 hits
- `ruff check` → all passed
- `pytest tests/ -v` → 49/49 passed (7 new + 42 existing)

## Test Cases (new: `test_extract_blocks.py`)

1. ✅ 3 □ lines → 3 tracker_items, □ lines remain in reply
2. ✅ No □ lines → empty tracker_items, reply unchanged
3. ✅ SOURCES + □ mixed → both extracted, SOURCES removed from reply
4. ✅ □ with parenthesised date → date field extracted
5. ✅ Scattered □ lines → all extracted
6. ✅ Orphan ---TRACKER---/---ACTIONS--- markers → stripped from reply
7. ✅ Old block format → □ lines still captured by inline scan, markers removed

## Risk & Rollback

- **Low risk**: `tracker_items` array structure unchanged; frontend needs no changes
- **Rollback**: `git revert b5cf7c0`
