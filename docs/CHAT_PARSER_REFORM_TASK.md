# Chat Parser Reform: □ インライン方式への移行

## 背景

Agent が `---TRACKER---` ブロック形式に従わず、tracker items がパースできない問題が繰り返し発生。
根本原因: ブロック形式は LLM の自然な生成フローに反するため、遵守率が低い。

**解決**: ブロック形式を廃止し、Agent が回答本文中で `□` をインラインで使う方式に移行。

## 変更対象

`backend/app_service/routers/chat.py` の `_extract_blocks()` 関数。

## 要件

### 1. □ 行抽出（新規）

- テキスト全体から `^\s*□` にマッチする行を抽出 → `tracker_items` 配列に格納
- 各 □ 行を `_parse_tracker_lines()` に通して `{type, title, date?}` を生成
- **□ 行は `reply`（clean text）から削除しない** — 本文にそのまま残す

### 2. 廃止する機能

- `_TRACKER_RE`（`---TRACKER---` ブロック正規表現）→ **削除**
- `_ACTIONS_RE`（`---ACTIONS---` ブロック正規表現）→ **削除**
- `_build_block_re("TRACKER")` / `_build_block_re("ACTIONS")` の呼び出し → **削除**
- Fallback parser（コードブロック内 □ 検出、連続 □ 行検出）→ **全削除**
- Fallback cleanup（`knowledge/` / `guides/` 漏洩除去、`※` 免責除去）→ **全削除**

### 3. 維持する機能

- `_SOURCES_RE`（`---SOURCES---` ブロック）→ **そのまま維持**
- `_build_block_re("SOURCES")` → **維持**
- `_parse_source_lines()` → **維持**
- `_parse_tracker_lines()` → **維持**（□ 行のパースに引き続き使用）
- `---SOURCES---` マーカーの clean text からの除去 → **維持**

### 4. 新しい `_extract_blocks()` の動作

```python
def _extract_blocks(text: str) -> tuple[str, list[dict], list[dict], list[dict]]:
    sources = []
    actions = []  # 常に空（廃止）
    tracker_items = []

    # 1. SOURCES ブロック抽出（従来通り）
    for match in _SOURCES_RE.finditer(text):
        sources.extend(_parse_source_lines(_get_block_content(match)))

    # 2. □ 行抽出（新方式）
    for line in text.splitlines():
        if re.match(r'\s*□', line):
            parsed = _parse_tracker_lines(line)
            tracker_items.extend(parsed)

    # 3. Clean reply: SOURCES ブロックのみ除去、□ 行は残す
    clean = _SOURCES_RE.sub("", text)
    clean = re.sub(r"\n?---\s*[A-Z]{2,}\s*---\s*", "", clean)  # orphan markers
    clean = re.sub(r"\n{3,}", "\n\n", clean)
    clean = clean.strip()

    return clean, sources, actions, tracker_items
```

### 5. テスト要件

既存テストのうち `---TRACKER---` 形式を前提としたものは □ 形式に書き換え。
最低限のテストケース：

1. □ 行が 3 つある回答 → `tracker_items` に 3 件抽出、`reply` に □ 行がそのまま残る
2. □ 行がない回答 → `tracker_items` 空、`reply` そのまま
3. `---SOURCES---` + □ 行の混在 → 両方正しく抽出、SOURCES は reply から除去
4. □ 行にカッコ付き日付 → `date` フィールドが抽出される
5. □ 行が連続でなく本文に散在 → 全て抽出される

### 6. 削除対象コード一覧

- `_TRACKER_RE = _build_block_re("TRACKER")`
- `_ACTIONS_RE = _build_block_re("ACTIONS")`
- `for match in _ACTIONS_RE.finditer(text):` ブロック
- `for match in _TRACKER_RE.finditer(text):` ブロック
- `clean = _ACTIONS_RE.sub("", clean)`
- `clean = _TRACKER_RE.sub("", clean)`
- Fallback セクション全体（`# ── Fallback:` から始まるブロック全て）

## NOT in scope

- Frontend 変更なし（`tracker_items` 配列の構造は変わらない）
- `_parse_tracker_lines()` のロジック変更なし
- `_parse_source_lines()` のロジック変更なし
- SOURCES 形式の変更なし
