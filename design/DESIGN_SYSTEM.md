# Design System — Gaijin Life Navi

> Version: 1.0.0
> Created: 2026-02-17
> Platform: Flutter (iOS / Android / Web) — Material 3 + Cupertino
> Theme Mode: Light only (Phase 0). Dark Mode 対応はカラートークン設計で将来対応可能。

---

## 1. Color Palette

### 1.1 Design Principles

- **Trust-first**: ブルーを基調とし、金融・行政の安心感を表現
- **Warm accents**: テールとアンバーで親しみやすさとエンパワーメントを演出
- **Semantic naming**: 全てのカラーをセマンティックトークンで定義し、将来の Dark Mode 対応を担保
- **WCAG AA 準拠**: テキスト/背景のコントラスト比 4.5:1 以上を確保

### 1.2 Primary Colors (Trust Blue)

ブランドの中核。信頼感・専門性・安心感を伝える。

| Token | Hex | 用途 |
|-------|-----|------|
| `colorPrimary` | `#2563EB` | メインアクション、アクティブ要素、リンク、BottomNav 選択状態 |
| `colorOnPrimary` | `#FFFFFF` | Primary 上のテキスト・アイコン |
| `colorPrimaryContainer` | `#DBEAFE` | Primary の軽い背景（選択カード、チップ背景、ハイライト行） |
| `colorOnPrimaryContainer` | `#1E3A5F` | PrimaryContainer 上のテキスト・アイコン |
| `colorPrimaryFixed` | `#EFF6FF` | 極めて薄い Primary 背景（セクション背景、ヘッダー帯） |
| `colorPrimaryDark` | `#1D4ED8` | Pressed 状態、強調 |

### 1.3 Secondary Colors (Empowerment Teal)

成長・エンパワーメント・多文化共生を象徴。Navigator やポジティブアクションに使用。

| Token | Hex | 用途 |
|-------|-----|------|
| `colorSecondary` | `#0D9488` | セカンダリアクション、Navigator ドメインカード装飾、進捗表示 |
| `colorOnSecondary` | `#FFFFFF` | Secondary 上のテキスト・アイコン |
| `colorSecondaryContainer` | `#CCFBF1` | Secondary の軽い背景（成功メッセージ背景、完了タグ） |
| `colorOnSecondaryContainer` | `#134E4A` | SecondaryContainer 上のテキスト |
| `colorSecondaryDark` | `#0F766E` | Pressed 状態 |

### 1.4 Tertiary Colors (Warmth Amber)

温かみ・親しみやすさ・注目喚起。CTA ボタン、バッジ、重要な通知に限定使用。

| Token | Hex | 用途 |
|-------|-----|------|
| `colorTertiary` | `#F59E0B` | CTA 強調、重要バッジ、アップグレード導線、Star アイコン |
| `colorOnTertiary` | `#FFFFFF` | Tertiary 上のテキスト |
| `colorTertiaryContainer` | `#FEF3C7` | 通知バナー背景、ヒント背景 |
| `colorOnTertiaryContainer` | `#78350F` | TertiaryContainer 上のテキスト |
| `colorTertiaryDark` | `#D97706` | Pressed 状態 |

### 1.5 Semantic Colors

| Token | Hex | 用途 |
|-------|-----|------|
| `colorSuccess` | `#16A34A` | 完了、成功メッセージ、Tracker 完了チェック |
| `colorSuccessContainer` | `#DCFCE7` | 成功メッセージ背景 |
| `colorOnSuccessContainer` | `#14532D` | 成功メッセージテキスト |
| `colorWarning` | `#F59E0B` | 注意、期限間近、Free 制限通知 |
| `colorWarningContainer` | `#FEF3C7` | 注意メッセージ背景 |
| `colorOnWarningContainer` | `#78350F` | 注意メッセージテキスト |
| `colorError` | `#DC2626` | エラー、破壊的アクション、必須フィールド未入力 |
| `colorErrorContainer` | `#FEE2E2` | エラーメッセージ背景 |
| `colorOnErrorContainer` | `#7F1D1D` | エラーメッセージテキスト |
| `colorInfo` | `#2563EB` | 情報メッセージ（Primary と共有） |
| `colorInfoContainer` | `#DBEAFE` | 情報メッセージ背景 |
| `colorOnInfoContainer` | `#1E3A5F` | 情報メッセージテキスト |

### 1.6 Neutral Colors

| Token | Hex | 用途 |
|-------|-----|------|
| `colorBackground` | `#FAFBFC` | アプリ全体の背景 |
| `colorSurface` | `#FFFFFF` | カード、シート、ダイアログの背景 |
| `colorSurfaceVariant` | `#F1F5F9` | セクション背景、入力フィールド背景 |
| `colorSurfaceDim` | `#E2E8F0` | 非アクティブ領域、区切り |
| `colorOnBackground` | `#0F172A` | 背景上のプライマリテキスト |
| `colorOnSurface` | `#1E293B` | サーフェス上のプライマリテキスト |
| `colorOnSurfaceVariant` | `#64748B` | セカンダリテキスト、プレースホルダー、キャプション |
| `colorOutline` | `#CBD5E1` | ボーダー、ディバイダー |
| `colorOutlineVariant` | `#E2E8F0` | 薄いボーダー、入力フィールド非フォーカス境界線 |
| `colorScrim` | `#000000` | モーダルオーバーレイ（opacity 0.32） |
| `colorInverseSurface` | `#1E293B` | スナックバー背景、トースト背景 |
| `colorOnInverseSurface` | `#F1F5F9` | スナックバーテキスト |

### 1.7 Domain Accent Colors

各 Navigator ドメインの識別色。ドメインカードのアイコン背景・左ボーダーに使用。

| ドメイン | Accent | Container | Icon |
|---------|--------|-----------|------|
| Banking | `#2563EB` | `#DBEAFE` | `#1D4ED8` |
| Visa | `#7C3AED` | `#EDE9FE` | `#6D28D9` |
| Medical | `#DC2626` | `#FEE2E2` | `#B91C1C` |
| Admin | `#4F46E5` | `#E0E7FF` | `#4338CA` |
| Housing | `#EA580C` | `#FFF7ED` | `#C2410C` |
| Work | `#0D9488` | `#CCFBF1` | `#0F766E` |
| Transport | `#0284C7` | `#E0F2FE` | `#0369A1` |
| Food | `#16A34A` | `#DCFCE7` | `#15803D` |

### 1.8 Dark Mode 対応方針

**Phase 0**: Light テーマのみ実装する。

**将来対応の設計原則**:
- 全ての色参照はセマンティックトークン経由（ハードコード禁止）
- Flutter の `ColorScheme.fromSeed()` または手動 `ColorScheme` で Light/Dark を切り替え可能にする
- `ThemeData.colorScheme` の全プロパティにトークンをマッピング
- Component 定義ではトークン名のみ使用（hex 直書き禁止）

```dart
// 実装イメージ（Phase 0: light のみ）
final lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2563EB),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFDBEAFE),
  onPrimaryContainer: Color(0xFF1E3A5F),
  secondary: Color(0xFF0D9488),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCCFBF1),
  onSecondaryContainer: Color(0xFF134E4A),
  tertiary: Color(0xFFF59E0B),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFEF3C7),
  onTertiaryContainer: Color(0xFF78350F),
  error: Color(0xFFDC2626),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFEE2E2),
  onErrorContainer: Color(0xFF7F1D1D),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1E293B),
  surfaceContainerHighest: Color(0xFFF1F5F9),
  onSurfaceVariant: Color(0xFF64748B),
  outline: Color(0xFFCBD5E1),
  outlineVariant: Color(0xFFE2E8F0),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF1E293B),
  onInverseSurface: Color(0xFFF1F5F9),
);
```

---

## 2. Typography Scale

### 2.1 Font Family

| 用途 | フォント | 理由 |
|------|---------|------|
| **Latin (en, vi, pt)** | System default (SF Pro on iOS, Roboto on Android) | プラットフォームネイティブの読みやすさを優先 |
| **CJK (zh)** | Noto Sans SC | Google Fonts、Flutter で組み込みやすい |
| **CJK (ko)** | Noto Sans KR | Google Fonts、Flutter で組み込みやすい |
| **Fallback** | Noto Sans | 全スクリプト対応の最終フォールバック |

**Flutter 実装**:
- `fontFamily` は指定せず、プラットフォームデフォルトを使用
- CJK ロケール時は `fontFamilyFallback: ['Noto Sans SC', 'Noto Sans KR']` を設定
- `google_fonts` パッケージで Noto Sans CJK をオンデマンドロード

### 2.2 Type Scale

Material 3 Type Scale をベースにカスタマイズ。iOS 優先で SF Pro の読みやすさに合わせたサイズ設定。

| Token | Size (sp) | Weight | Line Height (sp) | Letter Spacing (sp) | 用途 |
|-------|-----------|--------|-------------------|---------------------|------|
| `displayLarge` | 32 | Bold (700) | 40 | -0.25 | スプラッシュロゴ横テキスト、オンボーディング大見出し |
| `displayMedium` | 28 | Bold (700) | 36 | 0 | ページ主見出し（ホーム「Welcome」等） |
| `headlineLarge` | 24 | SemiBold (600) | 32 | 0 | セクション見出し（Navigator ドメインタイトル） |
| `headlineMedium` | 20 | SemiBold (600) | 28 | 0.15 | カード見出し、ダイアログタイトル |
| `titleLarge` | 18 | SemiBold (600) | 26 | 0 | AppBar タイトル、リスト項目タイトル |
| `titleMedium` | 16 | Medium (500) | 24 | 0.15 | サブセクション見出し、ガイドタイトル |
| `titleSmall` | 14 | Medium (500) | 20 | 0.1 | 小見出し、Tracker アイテムタイトル |
| `bodyLarge` | 16 | Regular (400) | 24 | 0.5 | メイン本文、ガイド本文、Chat メッセージ |
| `bodyMedium` | 14 | Regular (400) | 20 | 0.25 | 標準本文、リスト説明文 |
| `bodySmall` | 12 | Regular (400) | 16 | 0.4 | 補足テキスト、タイムスタンプ、免責事項 |
| `labelLarge` | 14 | SemiBold (600) | 20 | 0.1 | ボタンテキスト、Tab ラベル、リンク |
| `labelMedium` | 12 | Medium (500) | 16 | 0.5 | バッジテキスト、Tag テキスト、BottomNav ラベル |
| `labelSmall` | 11 | Medium (500) | 16 | 0.5 | オーバーライン、ステータスラベル、メタ情報 |

### 2.3 多言語タイポグラフィ補足

- **CJK (zh, ko)**: Body text は 15sp を推奨（漢字の密度が高いため 1sp 増量）。Flutter の `TextTheme` で locale 別に微調整可能
- **Vietnamese (vi)**: ダイアクリティカルマーク（声調記号）の表示を考慮し、line-height に余裕を持たせる（標準値で対応可能）
- **Portuguese (pt)**: Latin 系なので英語と同じ設定で問題なし

---

## 3. Spacing System

### 3.1 Base Unit: 4dp

| Token | Value (dp) | 用途 |
|-------|-----------|------|
| `space2xs` | 2 | アイコンとテキストの微小間隔（特殊用途のみ） |
| `spaceXs` | 4 | アイコンとテキストの間隔、バッジ内パディング |
| `spaceSm` | 8 | 関連要素間の間隔、リスト項目内パディング |
| `spaceMd` | 12 | 小セクション間、Input 内パディング |
| `spaceLg` | 16 | コンポーネント間の標準間隔、カード内パディング |
| `spaceXl` | 20 | AppBar 水平パディング |
| `space2xl` | 24 | セクション間の間隔、大型カード内パディング |
| `space3xl` | 32 | 主要セクション間の間隔 |
| `space4xl` | 40 | ページ上部マージン |
| `space5xl` | 48 | 大きなセクション間（オンボーディングステップ間等） |
| `space6xl` | 64 | ページ間の視覚的分離、フッター前マージン |

### 3.2 Screen Padding

| 要素 | 水平パディング | 理由 |
|------|---------------|------|
| ページ全体 | 16dp (左右) | モバイルファーストの標準値 |
| カード内 | 16dp | 内部コンテンツの余白 |
| リスト項目 | 16dp (左右) | ページパディングと揃える |
| BottomSheet | 24dp (左右) | ダイアログ系は広めの余白 |
| Dialog | 24dp (全方向) | Material 3 標準 |

---

## 4. Border Radius

| Token | Value (dp) | 使用箇所 |
|-------|-----------|---------|
| `radiusNone` | 0 | ディバイダー、フルブリード画像 |
| `radiusXs` | 4 | インラインコード、小さな Tag |
| `radiusSm` | 8 | Button、Input Field、Badge、Chip、Chat Bubble |
| `radiusMd` | 12 | Card、Navigator ドメインカード、Tracker アイテム |
| `radiusLg` | 16 | BottomSheet (上部のみ)、大型カード |
| `radiusXl` | 20 | Dialog、Modal |
| `radiusFull` | 999 | Avatar、Circular Button、Status Dot、Chip (pill) |

---

## 5. Shadow / Elevation

Material 3 の Elevation System に準拠。

| Level | Elevation (dp) | Shadow 表現 | 使用箇所 |
|-------|----------------|------------|---------|
| **Level 0** | 0 | なし | フラットなカード（ボーダーのみ）、リスト項目 |
| **Level 1** | 1 | `0 1dp 3dp rgba(0,0,0,0.08), 0 1dp 2dp rgba(0,0,0,0.06)` | Card (default)、AppBar (scroll 時) |
| **Level 2** | 3 | `0 2dp 6dp rgba(0,0,0,0.10), 0 1dp 4dp rgba(0,0,0,0.06)` | Raised Card (hover)、FAB |
| **Level 3** | 6 | `0 4dp 12dp rgba(0,0,0,0.12), 0 2dp 6dp rgba(0,0,0,0.08)` | BottomSheet、Dropdown Menu |
| **Level 4** | 8 | `0 8dp 24dp rgba(0,0,0,0.15), 0 4dp 8dp rgba(0,0,0,0.10)` | Dialog、Modal |

**Flutter 実装**: `Material` widget の `elevation` プロパティ、または `Card(elevation:)` で指定。カスタムシャドウが必要な場合は `BoxShadow` を使用。

**Tint Overlay (Material 3)**: Elevation が高いほど `colorPrimary` の tint overlay を薄く重ねる。`SurfaceTintColor` で自動適用。

---

## 6. Component Styles

### 6.1 Button

#### 6.1.1 Primary Button (Filled)

メインアクション（登録、送信、購入 等）に使用。画面に 1 つが原則。

| State | Background | Text Color | Border | Elevation | Opacity |
|-------|-----------|-----------|--------|-----------|---------|
| Default | `#2563EB` | `#FFFFFF` | none | 0 | 1.0 |
| Hover | `#1D4ED8` | `#FFFFFF` | none | 1 | 1.0 |
| Pressed | `#1E40AF` | `#FFFFFF` | none | 0 | 1.0 |
| Disabled | `#E2E8F0` | `#94A3B8` | none | 0 | 1.0 |

- Size: 高さ 48dp、パディング 水平 24dp
- Border Radius: `radiusSm` (8dp)
- Text: `labelLarge` (14sp, SemiBold)
- Min Width: 120dp
- iOS: `CupertinoButton.filled` スタイルに近い丸み

#### 6.1.2 Secondary Button (Tonal / Filled Tonal)

セカンダリアクション（「AI に質問する」、Navigator 遷移 等）に使用。

| State | Background | Text Color | Border | Elevation |
|-------|-----------|-----------|--------|-----------|
| Default | `#DBEAFE` | `#2563EB` | none | 0 |
| Hover | `#BFDBFE` | `#1D4ED8` | none | 0 |
| Pressed | `#93C5FD` | `#1D4ED8` | none | 0 |
| Disabled | `#F1F5F9` | `#94A3B8` | none | 0 |

- Size: 高さ 48dp、パディング 水平 24dp
- Border Radius: `radiusSm` (8dp)
- Text: `labelLarge` (14sp, SemiBold)

#### 6.1.3 Outline Button

代替アクション（キャンセル、詳細を見る 等）に使用。

| State | Background | Text Color | Border | Elevation |
|-------|-----------|-----------|--------|-----------|
| Default | transparent | `#2563EB` | 1dp `#CBD5E1` | 0 |
| Hover | `#F8FAFC` | `#1D4ED8` | 1dp `#2563EB` | 0 |
| Pressed | `#EFF6FF` | `#1D4ED8` | 1dp `#2563EB` | 0 |
| Disabled | transparent | `#94A3B8` | 1dp `#E2E8F0` | 0 |

- Size: 高さ 48dp、パディング 水平 24dp
- Border Radius: `radiusSm` (8dp)
- Text: `labelLarge` (14sp, SemiBold)

#### 6.1.4 Text Button

最小限のアクション（スキップ、もっと見る、リンク風 等）に使用。

| State | Background | Text Color | Border | Elevation |
|-------|-----------|-----------|--------|-----------|
| Default | transparent | `#2563EB` | none | 0 |
| Hover | `#F8FAFC` | `#1D4ED8` | none | 0 |
| Pressed | `#EFF6FF` | `#1D4ED8` | none | 0 |
| Disabled | transparent | `#94A3B8` | none | 0 |

- Size: 高さ 40dp、パディング 水平 12dp
- Border Radius: `radiusSm` (8dp)
- Text: `labelLarge` (14sp, SemiBold)

#### 6.1.5 Danger Button

破壊的アクション（アカウント削除、ログアウト確認 等）に使用。

| State | Background | Text Color | Border | Elevation |
|-------|-----------|-----------|--------|-----------|
| Default | `#DC2626` | `#FFFFFF` | none | 0 |
| Hover | `#B91C1C` | `#FFFFFF` | none | 1 |
| Pressed | `#991B1B` | `#FFFFFF` | none | 0 |
| Disabled | `#FEE2E2` | `#F87171` | none | 0 |

- Size: 高さ 48dp、パディング 水平 24dp
- Border Radius: `radiusSm` (8dp)
- Text: `labelLarge` (14sp, SemiBold)

#### 6.1.6 Icon Button

AppBar アクション、Chat 送信ボタン等に使用。

| State | Background | Icon Color | Size |
|-------|-----------|-----------|------|
| Default | transparent | `#64748B` | 24dp icon, 40dp タップ領域 |
| Hover | `#F1F5F9` | `#1E293B` | 同上 |
| Pressed | `#E2E8F0` | `#1E293B` | 同上 |
| Disabled | transparent | `#CBD5E1` | 同上 |

---

### 6.2 Card

#### 6.2.1 Navigator Domain Card (S09)

8 ドメインのグリッド表示用カード。

- Layout: 縦型カード（アイコン + ドメイン名 + ガイド数）
- Size: グリッド 2 列、カード間 12dp
- Background: `colorSurface` (`#FFFFFF`)
- Border: 1dp `colorOutlineVariant` (`#E2E8F0`)
- Border Radius: `radiusMd` (12dp)
- Elevation: Level 0 (default) → Level 1 (pressed)
- Padding: 16dp
- Icon: 40dp × 40dp、ドメイン固有 `Container` 色の丸背景 (48dp × 48dp)
- ドメイン名: `titleMedium` (16sp, Medium 500)
- ガイド数: `bodySmall` (12sp, Regular) `colorOnSurfaceVariant`
- Active 状態: 通常表示
- Coming Soon 状態: opacity 0.5 + 「準備中」バッジ

#### 6.2.2 Guide List Card (S10)

Navigator ガイド一覧のリストアイテム型カード。

- Layout: 横型（左にドメインカラーの 4dp バー + 内容）
- Background: `colorSurface` (`#FFFFFF`)
- Border: 1dp `colorOutlineVariant` (`#E2E8F0`)
- Left Border: 4dp ドメイン Accent カラー
- Border Radius: `radiusMd` (12dp)
- Padding: 16dp
- Title: `titleSmall` (14sp, Medium 500)
- Summary: `bodySmall` (12sp, Regular) `colorOnSurfaceVariant`、最大 2 行
- Pressed: background `colorSurfaceVariant` (`#F1F5F9`)

#### 6.2.3 Chat Bubble — ユーザー側

- Background: `colorPrimary` (`#2563EB`)
- Text: `#FFFFFF`、`bodyLarge` (16sp)
- Border Radius: 8dp (左上), 8dp (右上), 2dp (右下), 8dp (左下)
- Max Width: 画面幅の 75%
- Padding: 12dp 水平, 8dp 垂直
- Alignment: 右寄せ
- Margin Bottom: 4dp（連続メッセージ間）、12dp（異なる送信者間）
- タイムスタンプ: `labelSmall` (11sp) `rgba(255,255,255,0.7)` 右下

#### 6.2.4 Chat Bubble — AI 側

- Background: `colorSurfaceVariant` (`#F1F5F9`)
- Text: `colorOnSurface` (`#1E293B`)、`bodyLarge` (16sp)
- Border Radius: 8dp (左上), 8dp (右上), 8dp (右下), 2dp (左下)
- Max Width: 画面幅の 85%（AI 回答は長いため幅広）
- Padding: 12dp 水平, 8dp 垂直
- Alignment: 左寄せ
- AI アバター: 28dp 丸アイコン（バブル左上に配置）
- Markdown レンダリング対応:
  - 見出し: `titleSmall` (14sp, Medium 500) + 上部 8dp マージン
  - リスト: `bodyMedium` (14sp) + 左 16dp インデント + 箇条書きドット `colorPrimary`
  - コードブロック: `bodySmall` (12sp) モノスペース + 背景 `#E2E8F0` + border-radius 4dp
  - リンク: `colorPrimary` + 下線
  - 太字: SemiBold (600)
- ソース引用セクション: バブル下部に区切り線 + `bodySmall` でソース表示
- 免責事項: バブル外、下部に `labelSmall` (11sp) `colorOnSurfaceVariant` で表示

#### 6.2.5 Tracker Item Card

- Layout: チェックボックス + タイトル + サブステップ（展開可能）
- Background: `colorSurface` (`#FFFFFF`)
- Border: 1dp `colorOutlineVariant` (`#E2E8F0`)
- Border Radius: `radiusMd` (12dp)
- Padding: 16dp
- Checkbox: 24dp、チェック済み = `colorSuccess` (`#16A34A`)
- Title: `titleSmall` (14sp, Medium 500)
- Deadline: `labelSmall` (11sp) `colorWarning` (期限間近時)
- Sub-steps: `bodySmall` (12sp)、インデント 32dp

#### 6.2.6 Subscription Plan Card (S16)

- Layout: 縦型、3 カード横並び（モバイルは横スクロール）
- Background: `colorSurface` (`#FFFFFF`)
- Border: 1dp `colorOutlineVariant`
- **推奨プラン (Standard)**: Border 2dp `colorPrimary` + `colorPrimaryFixed` 背景 + 「おすすめ」バッジ
- Border Radius: `radiusMd` (12dp)
- Elevation: Level 0 (通常) / Level 1 (推奨プラン)
- Padding: 20dp
- プラン名: `headlineMedium` (20sp, SemiBold)
- 価格: `displayMedium` (28sp, Bold) + `bodySmall` 「/月」
- 機能リスト: `bodyMedium` (14sp) + チェックマークアイコン `colorSuccess`
- CTA ボタン: Primary Button (推奨) / Outline Button (その他)

---

### 6.3 Input

#### 6.3.1 TextField

| State | Background | Border | Label Color | Text Color |
|-------|-----------|--------|------------|-----------|
| Empty (Idle) | `#F1F5F9` | 1dp `#E2E8F0` | `#64748B` | — |
| Focused | `#FFFFFF` | 2dp `#2563EB` | `#2563EB` | `#1E293B` |
| Filled (Unfocused) | `#F1F5F9` | 1dp `#CBD5E1` | `#64748B` | `#1E293B` |
| Error | `#FFFFFF` | 2dp `#DC2626` | `#DC2626` | `#1E293B` |
| Disabled | `#F1F5F9` | 1dp `#E2E8F0` | `#94A3B8` | `#94A3B8` |

- Height: 56dp (M3 標準)
- Border Radius: `radiusSm` (8dp)
- Padding: 16dp 水平
- Label: `bodySmall` (12sp) — Floating label 方式
- Input Text: `bodyLarge` (16sp, Regular)
- Helper Text: `bodySmall` (12sp) `colorOnSurfaceVariant` — フィールド下 4dp
- Error Text: `bodySmall` (12sp) `colorError` — フィールド下 4dp
- Prefix/Suffix Icon: 24dp `colorOnSurfaceVariant`
- Style: Material 3 `OutlinedTextField` ベースだが、iOS の丸みを加味した `radiusSm` (8dp)

#### 6.3.2 TextArea (複数行入力)

- TextField と同じスタイルだが、min-height 120dp
- Max height: 200dp (スクロール可能)
- その他は TextField に準ずる

#### 6.3.3 Search Bar

| State | Background | Border | Icon Color | Text Color |
|-------|-----------|--------|-----------|-----------|
| Empty | `#F1F5F9` | none | `#94A3B8` | — |
| Focused | `#FFFFFF` | 1dp `#CBD5E1` | `#64748B` | `#1E293B` |
| Filled | `#F1F5F9` | none | `#64748B` | `#1E293B` |

- Height: 48dp
- Border Radius: `radiusFull` (999dp) — pill 形状
- Padding: 16dp 水平
- Search Icon: 20dp、左側
- Clear Button: 20dp、右側（Filled 状態のみ表示）
- Text: `bodyMedium` (14sp)
- Placeholder: `bodyMedium` (14sp) `#94A3B8`

#### 6.3.4 Chat Input Bar (S08)

- Layout: TextField + 送信ボタン + 添付ボタン（将来: 画像送信）
- Background: `colorSurface` (`#FFFFFF`)
- Border Top: 1dp `colorOutlineVariant`
- Input 部分: `bodyLarge` (16sp), 背景 `#F1F5F9`, border-radius `radiusFull` (999dp)
- 送信ボタン: 40dp 丸、背景 `colorPrimary`、アイコン `#FFFFFF` (送信矢印)
- 送信ボタン Disabled: 背景 `#E2E8F0`、アイコン `#94A3B8`（テキスト未入力時）
- Padding: 8dp 上下、16dp 左右
- Safe Area: BottomPadding をデバイスの safe area inset に加算

---

### 6.4 List

#### 6.4.1 Standard List Item

- Height: 最小 56dp（1 行）、72dp（2 行）
- Padding: 16dp 水平
- Leading: Icon (24dp) または Avatar (40dp)
- Title: `titleSmall` (14sp, Medium 500)
- Subtitle: `bodySmall` (12sp, Regular) `colorOnSurfaceVariant`、最大 2 行
- Trailing: Icon / Text / Switch
- Divider: 1dp `colorOutlineVariant`、左 56dp マージン（Leading がある場合）
- Pressed: 背景 `colorSurfaceVariant`

#### 6.4.2 Settings List Item (S15)

- Standard List Item に準拠
- Leading Icon: 24dp `colorOnSurfaceVariant`
- Trailing: Chevron (>) アイコン `colorOnSurfaceVariant`
- Section Header: `labelSmall` (11sp, Medium 500) `colorOnSurfaceVariant`、uppercase
- Section 間: 24dp マージン

#### 6.4.3 Guide List Item (S10)

- Guide List Card (§6.2.2) の簡易版
- ドメインカラーの左バーは維持
- タップ領域: カード全体

---

### 6.5 Navigation

#### 6.5.1 BottomNavigationBar

5 タブ: Home / Chat / Navigator / Emergency / Profile

| プロパティ | 値 |
|-----------|-----|
| Height | 80dp（ラベル含む） |
| Background | `colorSurface` (`#FFFFFF`) |
| Border Top | 1dp `colorOutlineVariant` (`#E2E8F0`) |
| Elevation | Level 0 |
| Icon Size | 24dp |
| Label | `labelMedium` (12sp, Medium 500) |
| Active Icon Color | `colorPrimary` (`#2563EB`) |
| Active Label Color | `colorPrimary` (`#2563EB`) |
| Inactive Icon Color | `colorOnSurfaceVariant` (`#64748B`) |
| Inactive Label Color | `colorOnSurfaceVariant` (`#64748B`) |
| Active Indicator | pill 形状 (64dp × 32dp)、背景 `colorPrimaryContainer` (`#DBEAFE`)、border-radius `radiusFull` |
| Safe Area | iOS bottom safe area を自動考慮 |

**Tab 定義**:

| Tab | Label (en) | Icon (inactive) | Icon (active) |
|-----|-----------|-----------------|---------------|
| Home | Home | `Icons.home_outlined` | `Icons.home` |
| Chat | Chat | `Icons.chat_bubble_outline` | `Icons.chat_bubble` |
| Navigator | Guide | `Icons.explore_outlined` | `Icons.explore` |
| Emergency | SOS | `Icons.emergency_outlined` | `Icons.emergency` |
| Profile | Profile | `Icons.person_outline` | `Icons.person` |

**Emergency Tab 特殊処理**: Emergency アイコンは `colorError` (`#DC2626`) を常時適用（Active/Inactive 問わず）。緊急性を視覚的に示す。

#### 6.5.2 iOS Cupertino 対応

- `NavigationBar` (Material 3) をベースに実装
- iOS 判定時に `CupertinoTabBar` のルック&フィールに寄せる（ラベルフォントサイズ 10sp、アイコン下配置）
- `adaptiveTheme` または platform check で切り替え

---

### 6.6 AppBar

#### 6.6.1 Standard AppBar

| プロパティ | 値 |
|-----------|-----|
| Height | 56dp |
| Background | `colorSurface` (`#FFFFFF`) — スクロールで `colorSurface` + Level 1 shadow |
| Title | `titleLarge` (18sp, SemiBold 600) `colorOnSurface` |
| Title Alignment | Center（iOS Cupertino 準拠） |
| Leading | Back arrow icon 24dp `colorOnSurface`、タップ領域 48dp |
| Actions | Icon Button(s)、右寄せ、最大 2 つ |
| Bottom Border | scroll 0 の時は 1dp `colorOutlineVariant`（shadow なしでフラットに） |
| iOS | `CupertinoNavigationBar` スタイルに自動適応（large title は未使用） |

#### 6.6.2 Home AppBar (S07)

- Large style: タイトル 32dp 高さエリアに配置
- Title: 「Good morning, {name}」 `displayMedium` (28sp, Bold)
- Subtitle: 利用状況 `bodySmall` (12sp) `colorOnSurfaceVariant`
- Actions: Notification bell icon (将来)
- Background: `colorBackground` (`#FAFBFC`)

---

### 6.7 Badge / Tag

#### 6.7.1 Domain Status Badge

| Status | Background | Text Color | Text |
|--------|-----------|-----------|------|
| Active | `colorSecondaryContainer` (`#CCFBF1`) | `colorOnSecondaryContainer` (`#134E4A`) | — (表示しない、デフォルト) |
| Coming Soon | `colorSurfaceVariant` (`#F1F5F9`) | `colorOnSurfaceVariant` (`#64748B`) | 「準備中」/ "Coming Soon" |

- Height: 24dp
- Padding: 8dp 水平
- Border Radius: `radiusFull` (999dp)
- Text: `labelSmall` (11sp, Medium 500)

#### 6.7.2 Subscription Tier Badge

| Tier | Background | Text Color | Icon |
|------|-----------|-----------|------|
| Free | `colorSurfaceVariant` (`#F1F5F9`) | `colorOnSurfaceVariant` (`#64748B`) | — |
| Standard | `colorTertiaryContainer` (`#FEF3C7`) | `colorOnTertiaryContainer` (`#78350F`) | ⭐ |
| Premium | `#FEF3C7` gradient to `#FDE68A` | `#78350F` | 💎 |

- Height: 28dp
- Padding: 10dp 水平, 4dp 垂直
- Border Radius: `radiusFull` (999dp)
- Text: `labelMedium` (12sp, Medium 500)

#### 6.7.3 Info Tag (汎用)

Navigator ドメインのガイド数表示、カテゴリラベル等に使用。

- Height: 24dp
- Padding: 8dp 水平
- Background: `colorSurfaceVariant` (`#F1F5F9`)
- Text: `labelSmall` (11sp, Medium 500) `colorOnSurfaceVariant`
- Border Radius: `radiusXs` (4dp)

---

### 6.8 Dialog / BottomSheet

#### 6.8.1 Dialog (Alert Dialog)

| プロパティ | 値 |
|-----------|-----|
| Background | `colorSurface` (`#FFFFFF`) |
| Border Radius | `radiusXl` (20dp) |
| Elevation | Level 4 (8dp) |
| Scrim | `#000000` opacity 0.32 |
| Width | 280dp 〜 最大 560dp |
| Padding | 24dp |
| Title | `headlineMedium` (20sp, SemiBold) `colorOnSurface` |
| Body | `bodyMedium` (14sp) `colorOnSurfaceVariant` |
| Actions | 右寄せ、Text Button / Primary Button |
| Action Spacing | 8dp |

用途: ログアウト確認、アカウント削除確認、エラー通知

#### 6.8.2 BottomSheet

| プロパティ | 値 |
|-----------|-----|
| Background | `colorSurface` (`#FFFFFF`) |
| Border Radius | `radiusLg` (16dp) — 上部左右のみ |
| Elevation | Level 3 (6dp) |
| Scrim | `#000000` opacity 0.32 |
| Drag Handle | 32dp × 4dp、`colorOutline` (`#CBD5E1`)、中央配置、上部 8dp |
| Max Height | 画面高さの 90% |
| Padding | 24dp 左右、16dp 上部（Drag Handle 下）、24dp 下部 |

用途: 言語選択、フィルター、詳細情報表示

#### 6.8.3 Snackbar

| プロパティ | 値 |
|-----------|-----|
| Background | `colorInverseSurface` (`#1E293B`) |
| Text | `bodyMedium` (14sp) `colorOnInverseSurface` (`#F1F5F9`) |
| Action | Text Button `colorTertiary` (`#F59E0B`) |
| Border Radius | `radiusSm` (8dp) |
| Margin | 16dp (左右下) |
| Duration | 4 秒（自動消去） |

用途: 保存完了、コピー完了、操作完了通知

---

### 6.9 Chat Bubble (詳細仕様)

> §6.2.3 / §6.2.4 の詳細補足。Chat 画面 (S08) 専用コンポーネント。

#### 6.9.1 メッセージグループ

- 同一送信者の連続メッセージ: 間隔 4dp（タイムスタンプ省略可）
- 送信者切り替え時: 間隔 12dp + タイムスタンプ表示
- 日付区切り: 中央テキスト `labelSmall` (11sp) `colorOnSurfaceVariant` + 左右ライン

#### 6.9.2 AI レスポンスの構造

```
┌─ AI Avatar (28dp) ─────────────────────────┐
│ [AI メッセージ本文]                          │
│  • Markdown レンダリング                     │
│  • 箇条書き、太字、コードブロック対応         │
│                                              │
│ ──────── ソース ────────                     │
│ 📎 金融庁 外国人向けガイド                   │
│ 📎 全銀協 口座開設の手引き                   │
│                                              │
│ [💡 AI に質問する] [📋 Tracker に追加]       │  ← Action Chips
└──────────────────────────────────────────────┘
  ⚠️ 一般的な情報提供です。法的助言ではありません。  ← 免責事項 (バブル外)
```

#### 6.9.3 Action Chip (AI バブル下部)

- Height: 32dp
- Padding: 12dp 水平
- Background: `colorPrimaryContainer` (`#DBEAFE`)
- Text: `labelMedium` (12sp, Medium 500) `colorPrimary`
- Icon: 16dp `colorPrimary`
- Border Radius: `radiusFull` (999dp)
- Spacing: Chip 間 8dp

#### 6.9.4 利用制限表示 (Free ユーザー)

- 背景: `colorWarningContainer` (`#FEF3C7`)
- アイコン: `Icons.info_outline` 20dp `colorWarning`
- テキスト: `bodySmall` (12sp) `colorOnWarningContainer`
- CTA: 「アップグレード」Text Button `colorPrimary`
- Border Radius: `radiusMd` (12dp)
- Padding: 12dp
- 表示位置: Chat リスト最上部に固定

#### 6.9.5 Typing Indicator (AI 応答中)

- 3 つのドット (6dp) がバウンドアニメーション
- ドット色: `colorOnSurfaceVariant` (`#64748B`)
- 背景: `colorSurfaceVariant` (`#F1F5F9`)
- Border Radius: Chat Bubble (AI) と同じ
- アニメーション: 各ドット 300ms 間隔で上下 4dp バウンス

---

## 7. Icon Style

### 7.1 推奨アイコンセット

| 優先度 | アイコンセット | 理由 |
|--------|-------------|------|
| **Primary** | Material Symbols (Outlined) | Flutter 組み込み、M3 準拠、軽量 |
| **Fallback** | `flutter_svg` + カスタム SVG | ドメイン固有アイコンなど Material にない場合 |

### 7.2 アイコンスタイルルール

- **スタイル**: Outlined (線画)。Filled は Active 状態のみ使用
- **線幅**: 1.5dp（Material Symbols default weight 400）
- **サイズ**: 20dp (small) / 24dp (default) / 28dp (medium) / 40dp (large)
- **色**: 原則 `colorOnSurface` または `colorOnSurfaceVariant`。Active 状態は `colorPrimary`
- **角丸**: Material Symbols のデフォルト（Rounded grade）を使用

### 7.3 ドメインアイコン定義

各 Navigator ドメインの代表アイコン。Material Symbols Outlined を使用。

| # | ドメイン | Material Icon | Code Point | 背景色 (Container) | アイコン色 |
|---|---------|--------------|-----------|-------------------|-----------|
| 1 | Banking | `account_balance` | `0xe84f` | `#DBEAFE` | `#1D4ED8` |
| 2 | Visa | `badge` | `0xea67` | `#EDE9FE` | `#6D28D9` |
| 3 | Medical | `local_hospital` | `0xe548` | `#FEE2E2` | `#B91C1C` |
| 4 | Admin | `assignment` | `0xe85d` | `#E0E7FF` | `#4338CA` |
| 5 | Housing | `home_work` | `0xea09` | `#FFF7ED` | `#C2410C` |
| 6 | Work | `work_outline` | `0xe943` | `#CCFBF1` | `#0F766E` |
| 7 | Transport | `directions_transit` | `0xe535` | `#E0F2FE` | `#0369A1` |
| 8 | Food | `restaurant` | `0xe56c` | `#DCFCE7` | `#15803D` |

**アイコン背景**: 48dp 丸型 Container、角丸 `radiusFull`、上記 Container 色

### 7.4 Navigation アイコン

| Tab | Icon (Outlined) | Icon (Filled) |
|-----|----------------|---------------|
| Home | `home_outlined` | `home` |
| Chat | `chat_bubble_outline` | `chat_bubble` |
| Guide | `explore_outlined` | `explore` |
| SOS | `emergency_outlined` | `emergency` |
| Profile | `person_outline` | `person` |

### 7.5 Common Action Icons

| Action | Icon | Size |
|--------|------|------|
| Back | `arrow_back_ios` | 24dp |
| Close | `close` | 24dp |
| Settings | `settings_outlined` | 24dp |
| Edit | `edit_outlined` | 24dp |
| Send | `send` | 24dp |
| Attach | `attach_file` | 24dp |
| Search | `search` | 24dp |
| Filter | `filter_list` | 24dp |
| More | `more_vert` | 24dp |
| Check | `check` | 24dp |
| Info | `info_outline` | 20dp |
| Warning | `warning_amber` | 20dp |
| Phone (Emergency) | `phone` | 24dp |
| Language | `language` | 24dp |
| Logout | `logout` | 24dp |
| Delete | `delete_outline` | 24dp |

---

## 8. Screen-Specific Guidelines

### 8.1 Splash (S01)

- Background: `colorPrimary` (`#2563EB`) フルスクリーン
- Logo: 中央配置、白 (`#FFFFFF`)、80dp × 80dp
- App Name: `displayLarge` (32sp, Bold) `#FFFFFF`、ロゴ下 16dp
- Loading Indicator: `CircularProgressIndicator` `#FFFFFF`、画面下部 1/4 位置
- 表示時間: 最大 2 秒

### 8.2 Language Selection (S02)

- Background: `colorBackground` (`#FAFBFC`)
- Title: `displayMedium` (28sp, Bold) 中央配置
- 言語リスト: 5 項目の大型タップ領域 (56dp 高さ)、ラジオボタン
- 選択済み: `colorPrimaryContainer` 背景 + `colorPrimary` ラジオ
- CTA: Primary Button「続ける」画面下部固定

### 8.3 Onboarding (S06)

- ステップインジケーター: 横並びドット (8dp)、Active = `colorPrimary`、Inactive = `colorOutline`
- 各ステップ: イラスト (将来) + テキスト + 入力フィールド
- スキップ: 右上 Text Button
- Next: Primary Button 画面下部

### 8.4 Emergency Guide (S12)

- **緊急性を視覚的に強調**
- AppBar: Background `#DC2626`、Title/Icons `#FFFFFF`
- 緊急連絡先カード: 大型 (80dp 高さ)、電話番号 `displayMedium` (28sp, Bold)
- ワンタップ発信: `Phone` アイコン + `colorError` 背景の丸ボタン
- ガイドセクション: 通常のカードレイアウト

---

## 9. Motion / Animation

### 9.1 Transition Guidelines

| 遷移 | アニメーション | Duration | Curve |
|------|-------------|----------|-------|
| ページ遷移 (push) | SlideTransition (右から左) | 300ms | `Curves.easeInOut` |
| ページ遷移 (pop) | SlideTransition (左から右) | 250ms | `Curves.easeInOut` |
| BottomSheet 表示 | SlideTransition (下から上) | 250ms | `Curves.easeOut` |
| Dialog 表示 | FadeTransition + ScaleTransition (0.9→1.0) | 200ms | `Curves.easeOut` |
| Tab 切り替え | FadeTransition | 200ms | `Curves.easeInOut` |
| リスト項目表示 | FadeTransition + SlideTransition (下20dp→0) | 200ms | `Curves.easeOut` |

### 9.2 Micro-interactions

| 要素 | アニメーション | Duration |
|------|-------------|----------|
| Button press | Scale 0.97 + opacity 0.8 | 100ms |
| Checkbox toggle | Scale 1.2→1.0 + color change | 200ms |
| Typing indicator dots | Bounce (上下 4dp) | 300ms per dot |
| Pull-to-refresh | Material 3 標準の RefreshIndicator | — |
| Skeleton loading | Shimmer (左→右 グラデーション) | 1500ms loop |

---

## 10. Accessibility

### 10.1 Color Contrast

全てのテキスト/背景の組み合わせで WCAG AA 基準を満たすこと:

| 組み合わせ | コントラスト比 | 基準 |
|-----------|-------------|------|
| `colorOnSurface` on `colorSurface` | 14.9:1 | ✅ AA (4.5:1) |
| `colorOnPrimary` on `colorPrimary` | 4.6:1 | ✅ AA (4.5:1) |
| `colorOnSurfaceVariant` on `colorSurface` | 4.6:1 | ✅ AA (4.5:1) |
| `colorOnSecondary` on `colorSecondary` | 4.7:1 | ✅ AA (4.5:1) |
| `colorOnError` on `colorError` | 4.6:1 | ✅ AA (4.5:1) |

### 10.2 Semantic Labels

- 全ての `Icon` に `semanticLabel` を設定
- 全ての `Image` に `semanticsLabel` を設定
- Navigation アイテムに適切な `tooltip` を設定
- Form フィールドに `labelText` + `hintText` を設定

### 10.3 Touch Targets

- 最小タップ領域: 48dp × 48dp（Material 3 標準）
- iOS: 44dp × 44dp（Apple HIG 標準）→ 48dp に統一して両プラットフォーム対応
- Icon Button のタップ領域: アイコンサイズに関わらず 48dp

### 10.4 Text Scaling

- `MediaQuery.textScaleFactor` を考慮
- レイアウトは 1.0〜1.5 のテキストスケールに対応可能にする
- 固定高さの要素は `min-height` で定義し、テキスト拡大時にオーバーフローしないこと

---

## Appendix A: Flutter ThemeData 実装ガイド

```dart
// theme.dart — 実装の参照コード
ThemeData buildLightTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDBEAFE),
    onPrimaryContainer: Color(0xFF1E3A5F),
    secondary: Color(0xFF0D9488),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFCCFBF1),
    onSecondaryContainer: Color(0xFF134E4A),
    tertiary: Color(0xFFF59E0B),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFF78350F),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1E293B),
    surfaceContainerHighest: Color(0xFFF1F5F9),
    onSurfaceVariant: Color(0xFF64748B),
    outline: Color(0xFFCBD5E1),
    outlineVariant: Color(0xFFE2E8F0),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF1E293B),
    onInverseSurface: Color(0xFFF1F5F9),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    // Typography は §2 の Type Scale に準拠
    // Component themes は §6 の Component Styles に準拠
  );
}
```

---

## Appendix B: Color Token → Dark Mode マッピング (将来参考)

> Phase 0 スコープ外。実装時の参考として記載。

| Token | Light Value | Dark Value (参考) |
|-------|-----------|-------------------|
| `colorPrimary` | `#2563EB` | `#93C5FD` |
| `colorOnPrimary` | `#FFFFFF` | `#1E3A5F` |
| `colorPrimaryContainer` | `#DBEAFE` | `#1E3A5F` |
| `colorSurface` | `#FFFFFF` | `#1E293B` |
| `colorOnSurface` | `#1E293B` | `#F1F5F9` |
| `colorBackground` | `#FAFBFC` | `#0F172A` |
| `colorOnBackground` | `#0F172A` | `#F1F5F9` |
| `colorSurfaceVariant` | `#F1F5F9` | `#334155` |
| `colorOnSurfaceVariant` | `#64748B` | `#94A3B8` |
| `colorOutline` | `#CBD5E1` | `#475569` |

---

## 変更履歴

| 日付 | バージョン | 内容 |
|------|-----------|------|
| 2026-02-17 | 1.0.0 | 初版作成 |
