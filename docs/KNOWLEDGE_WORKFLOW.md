# svc-* Knowledge 采集・提取・部署 流程

> 创建: 2026-02-26
> 用途: 为 svc-{tax,legal,visa,medical,life,finance} 六个 agent 采集真实经验，提取 knowledge 的标准流程
> 历史: 整合自 finance-knowledge-harvest.md, 4domain-knowledge-harvest.md, knowledge-restructure-plan.md, knowledge-pipeline-optimization-plan.md, memory-knowledge-optimization-plan.md, verification-system-design.md

---

## 一、Knowledge 判定原则

### 什么该写入 knowledge/

knowledge/ 存放 **LLM 无法可靠提供** 的信息。注意：**"LLM 知道" ≠ "LLM 的回答正确且最新"**。

| ✅ 写入 | ❌ 不写入 |
|---------|----------|
| 踩坑经验 + 解法（真实案例） | LLM 已知且**经官方验证仍然正确**的一般制度说明 |
| 判断逻辑（什么情况下该怎么选） | 具体金额/费率（会变，用 web_search） |
| 隐性知识（官方没写但实操需要知道的） | 通用的日本生活常识（且未过时的） |
| 外国人特有的障碍和绕过方法 | 翻译/术语对照表（LLM 能做） |
| 时效性经验（政策执行的实际情况 vs 纸面规定） | |
| **⚠️ LLM 知道但已过时的信息**（制度变更/新要求） | |
| **官方信息的实操补充**（官网条件 vs 实际执行的差异） | |

### 判定口诀

> **"能看懂，能用上"** — 不是知识库，是经验库
> **"大模型知道 ≠ 大模型答得对"** — 过时的 LLM 知识是最危险的，必须写入 knowledge 修正

### ⚠️ LLM 已知信息的判定流程（不可跳过）

"这条信息 LLM 已经知道了"不是剔除理由。必须走以下流程：

1. **查官方来源** — 这条信息的当前官方版本是什么？
2. **比对 LLM 回答** — LLM 给出的信息与当前官方一致吗？
3. 判定：
   - 一致且正确 → 可以不写入（但高频问题仍可保留以确保质量）
   - **LLM 回答过时或不准确** → **必须写入 knowledge**，标注 `⚠️ LLM旧知識修正: [具体说明哪里过时了]`
   - **LLM 完全不知道** → 写入 knowledge

### 来源时效

- 只采纳 **2021年以后** 的帖子/文章（制度结构性信息可放宽，但要标注年份）
- **越新的信息准确度越高** — 同一话题有新旧两条矛盾信息时，优先采信新的

---

## 二、信息源

### 五大信息源（按权威性排序）

| # | 来源 | 角色 | 搜索方式 |
|---|------|------|---------|
| ① | **官方网站** | **事实基准**（最高权威）。银行主页、政府机构主页、入管局等 | web_search 直接搜官网 + web_fetch 抓取 |
| ② | **小红书 (XHS)** | **隐性知识源**。中文用户一手体验，踩坑经验，官方未写的实操技巧 | **必须用 XHS MCP**（见下方说明） |
| ③ | **Reddit** | **英文社区验证**。r/japanlife, r/JapanFinance, r/movingtojapan 等 | web_search `site:reddit.com` |
| ④ | **知乎** | **中文深度**。长文分析较多 | web_search `site:zhihu.com` |
| ⑤ | **Blog/专业站** | **结构化参考**。GaijinPot, tokyocheapo, retirejapan 等 | web_search 关键词 |

### ⚠️ 信息源交叉验证规则

- **事实性信息**（所需材料、手续流程、费用等）以**官方网站为准**
- **经验性信息**（技巧、坑、实际执行差异）以**经验贴为准**（官方不会写这些）
- 经验贴与官方矛盾时 → 记录两者并标注，可能是"规定是这样但实际执行不同"
- 多个独立来源描述同一经验 → 可信度高

### 🔴 小红书 MCP 使用方法

小红书需要登录才能搜索和查看详情，**禁止用 web_search 搜小红书**（搜不到有效内容）。

**MCP 配置**: mcporter 已注册 `xhs` server（`http://localhost:18060/mcp`），配置文件在 `/root/.openclaw/workspace/config/mcporter.json`。

**可用工具**:

```bash
# 搜索（返回笔记列表，含 feed_id 和 xsec_token）
mcporter call xhs.search_feeds keyword="搜索词" --output json

# 带筛选的搜索（按时间/排序/类型）
mcporter call xhs.search_feeds keyword="搜索词" filters='{"sort_by":"最多点赞","publish_time":"半年内","note_type":"图文"}' --output json

# 获取笔记详情 + 评论（需要 feed_id 和 xsec_token）
mcporter call xhs.get_feed_detail feed_id="笔记ID" xsec_token="token" --output json

# 获取详情 + 加载更多评论
mcporter call xhs.get_feed_detail feed_id="笔记ID" xsec_token="token" load_all_comments=true limit=20 --output json
```

**采集流程**:
1. `search_feeds` 搜索关键词 → 获取笔记列表（含标题、点赞数、收藏数）
2. 筛选高赞/高收藏的笔记 → 用 `get_feed_detail` 获取正文 + 评论
3. 从正文和评论中提取经验要点

**注意**:
- MCP 调用可能较慢（每次 10-30秒），不要并发过多
- `xsec_token` 从 search_feeds 返回的每条笔记中获取，传入 get_feed_detail
- 输出为 JSON，需要用 Python 解析提取文本内容
- 如果登录过期，需要 Z 重新扫码（`mcporter call xhs.get_login_qrcode`）

### 采集规则

1. **官方信息必须采集** — 每个话题先查官网，建立事实基准
2. 每个维度至少 **2个不同信息源** 的数据（官方 + 至少 1 个经验源）
3. 每个域总体 **5种信息源都要有引用**（官方必须有）
4. 优先高赞/高互动的帖子（经过社区验证）
5. 提取要点，不复制原文。每条标注 `(来源 年份)`
6. 评论区的补充经验同样采集（有时比正文更有价值）
7. **标注信息时间** — 每条信息标注发布/更新时间，越新越可信

---

## 三、执行流程

### 总览

```
场景/维度定义 → 搜索词设计 → 采集 → 整理+剔除 → 与现有knowledge对比 → 增量draft → Z审阅 → 部署
```

### Step 1: 场景/维度定义

**输入**: Z 提供的高价值场景清单，或某个域需要补全的维度

操作:
- 将场景拆解为涉及的域和具体维度
- 例: "外国人子女在日出生" → visa(在留资格取得) + life(出生届) + medical(出産) + finance(児童手当)
- 列出每个维度需要搜索的关键问题

### Step 2: 搜索词设计

每个维度设计 4组搜索词（对应4个信息源）:

```
维度: [名称]
- 小红书: "[中文搜索词1]" / "[中文搜索词2]"
- Reddit: "[英文搜索词]" site:reddit.com
- 知乎: "[中文搜索词]" site:zhihu.com
- Blog: "[英文关键词]" [目标站点]
```

### Step 3: 采集

**方式**: 以 sub-agent 执行。按域分配，每个域一个 sub-agent。

Sub-agent task 必须包含:
1. 搜索词清单
2. 采集规则（Section 二）
3. 输出路径: `tasks/{domain}-harvest/raw-{topic}.md`
4. 输出格式要求（每条标注来源+年份）
5. 验收条件（grep 命令，见 Section 五）

**并行策略**:
- 不同域的 sub-agent 可并行
- 同一域的不同信息源可在同一 agent 内串行

### Step 4: 整理 + 信息评估

**输入**: raw 采集数据 + 现有 knowledge/ 文件

操作:
1. 读取 raw 数据，按主题归类
2. **官方基准建立**: 以官方网站信息为事实基准，标注每条信息的权威来源
3. **LLM 知识评估**（⚠️ 不是简单剔除）:
   - 对每条关键信息，检查 LLM 给出的回答是否与当前官方一致
   - LLM 回答正确且最新 → 可跳过（但高频问题仍可保留）
   - **LLM 回答过时或不准确 → 必须保留**，标注 `⚠️ LLM旧知識修正`
4. **剔除现有 knowledge 已有的**: 与 svc-{domain}/workspace/knowledge/ 对比，已覆盖的不重复
5. **合并同类**: 多个来源说的同一件事 → 合并为一条，标注多个来源
6. **信息分类标注**: 每条信息标注类型（官方事实 / 经验技巧 / LLM修正 / 隐性知识）
7. 输出: `tasks/{domain}-knowledge-draft/{version}/` 下的 draft 文件

### Step 5: 增量 Draft 生成

**关键**: 不是重写整个 knowledge 文件，而是生成**增量内容**

输出格式:
```markdown
# [文件名] 补全建议

## 新增条目

### [新增节标题]
- 新内容... (来源 年份)
- 新内容... (来源 年份)

## 已有条目的补充

### [已有节标题] — 追加
- 补充内容... (来源 年份)
```

### Step 6: Z 审阅

- Z 逐文件审阅 draft
- 确认/修改/删除
- 标注是否批准部署

### Step 7: 部署

- 将批准的增量内容写入对应 svc-{domain}/workspace/knowledge/ 文件
- git commit（svc-* 不纳入 git，直接写入即可）
- 验证: 读回文件确认写入正确

---

## 四、文件结构

```
tasks/
├── svc-knowledge-workflow.md          ← 本文件（流程定义）
├── {场景名}-search-plan.md            ← 每次搜索的计划（Step 1-2 的输出）
├── {domain}-harvest/
│   └── raw-{topic}.md                 ← 采集原始数据（Step 3 的输出）
├── {domain}-knowledge-draft/
│   └── {version}/
│       └── {file}-supplement.md       ← 增量 draft（Step 5 的输出）
```

---

## 五、验收标准

### 采集阶段验收（Step 3 完成后）

```bash
# 信息源覆盖率 — 每个域的 raw 文件中 4 种来源都有
grep -ci "小红书\|XHS\|小红薯" tasks/{domain}-harvest/raw-*.md   # > 0
grep -ci "Reddit" tasks/{domain}-harvest/raw-*.md                  # > 0
grep -ci "知乎\|zhihu" tasks/{domain}-harvest/raw-*.md            # > 0
grep -ci "GaijinPot\|blog\|tokyocheapo" tasks/{domain}-harvest/raw-*.md  # > 0

# 每条都有来源标注
grep -c "(.*20[2-3][0-9])" tasks/{domain}-harvest/raw-*.md        # 接近内容行数
```

### Draft 验收（Step 5 完成后）

```bash
# 不含制度说明
grep -c "とは\|について\|制度概要" tasks/{domain}-knowledge-draft/**/*.md    # = 0

# 不含具体金额（税法阈值除外）
grep "[0-9]円" tasks/{domain}-knowledge-draft/**/*.md              # 极少或 0

# 行数在合理范围
wc -l tasks/{domain}-knowledge-draft/**/*.md                       # 单文件 < 80 行
```

### 抽查发现问题 → 升级为详查

抽查中发现任何一个问题 → 全量检查。一个问题 = 其他地方大概率也有。

---

## 六、Sub-agent 任务模板

```markdown
# Task: {domain} Knowledge 补全采集

## 背景
为 svc-{domain} agent 补全 knowledge，场景: {场景描述}

## 搜索词
{从 search-plan.md 复制}

## 工具使用

### 小红书（必须用 MCP，禁止用 web_search）
mcporter 已配置 xhs server（config: /root/.openclaw/workspace/config/mcporter.json）

搜索:
exec: mcporter call xhs.search_feeds keyword="关键词" --output json
→ 返回 JSON，包含 feeds[].id, feeds[].xsecToken, feeds[].noteCard.displayTitle, feeds[].noteCard.interactInfo

获取详情+评论:
exec: mcporter call xhs.get_feed_detail feed_id="ID" xsec_token="TOKEN" --output json
→ 返回正文内容和评论列表

带筛选搜索（推荐）:
exec: mcporter call xhs.search_feeds keyword="关键词" filters='{"sort_by":"最多点赞","publish_time":"半年内"}' --output json

解析 JSON 用 Python:
exec: mcporter call xhs.search_feeds keyword="关键词" --output json | python3 -c "
import sys, json
data = json.load(sys.stdin)
for f in data.get('feeds', []):
    nc = f.get('noteCard', {})
    info = nc.get('interactInfo', {})
    print(f'ID: {f[\"id\"]} | {nc.get(\"displayTitle\",\"\")} | 赞:{info.get(\"likedCount\",0)} 藏:{info.get(\"collectedCount\",0)}')
    print(f'  token: {f.get(\"xsecToken\",\"\")}')
"

### Reddit / 知乎 / Blog
web_search "[关键词] site:reddit.com"
web_search "[关键词] site:zhihu.com"
web_search "[关键词]"
→ 用 web_fetch 打开 top 结果获取详情

## 采集规则
1. 只采纳 2021年以后的帖子
2. 每个维度至少 2 个不同信息源
3. 提取要点，不复制原文。每条标注 (来源 年份)
4. 评论区的补充经验同样采集（小红书用 get_feed_detail 获取评论）
5. LLM 已知的一般信息不采集 — 只要踩坑经验、判断逻辑、隐性知识
6. 如果某个搜索词搜不到有价值的结果，记录"无有效结果"并跳过

## 输出
- 路径: `tasks/{domain}-harvest/raw-{topic}.md`
- 格式: 每条 `- 内容... (来源 年份)`，按维度分节

## 验收条件（spawner 会用以下命令检查）
- `grep -ci "Reddit" raw-*.md` → 每个域 > 0
- `grep -ci "小红书\|XHS" raw-*.md` → 每个域 > 0
- `grep -c "(.*20[2-3])" raw-*.md` → 接近内容行数（每条有来源标注）
```

---

## 七、现有 Knowledge 概况（2026-02-26 时点）

供执行时参考，判断哪些文件需要补全、哪些已经足够。

| 域 | 文件 | 行数 | 内容密度评估 |
|---|------|------|------------|
| **finance** | account-opening.md | 53 | 充实 |
| | banks-overview.md | 56 | 充实 |
| | credit-cards.md | 57 | 充实 |
| | insurance.md | 114 | 最充实 |
| | investment.md | 47 | 充实（NISA/iDeCo/券商比较详细） |
| | leaving-japan.md | 54 | 充实 |
| | loans.md | 40 | 充实（银行对比表+交涉经验） |
| | remittance.md | 58 | 充实 |
| **visa** | immigration-tips.md | 70 | 充实 |
| | permanent-residency.md | 66 | 充实 |
| | status-change.md | 56 | 充实 |
| | visa-renewal-traps.md | 44 | 充实（全是实战经验） |
| **medical** | dental-experience.md | 27 | ⚠️ 偏薄（3个话题） |
| | emergency-experience.md | 36 | 适中 |
| | hospital-traps.md | 38 | 适中 |
| | mental-health.md | 38 | 适中 |
| | pharmacy-tips.md | 40 | 适中 |
| | pregnancy-birth.md | 50 | 充实 |
| **life** | daily-life-hacks.md | 21 | ⚠️ 偏薄（3个小节） |
| | driving-license.md | 35 | 适中 |
| | housing-traps.md | 44 | 充实 |
| | moving-admin.md | 28 | ⚠️ 结构好但条目少 |
| | phone-internet.md | 32 | 适中 |
| **legal** | consumer-protection.md | 40 | 适中 |
| | family-law.md | 53 | 充实 |
| | labor-disputes.md | 51 | 充实 |
| | legal-resources.md | 48 | 充实 |
| | traffic-accidents.md | 59 | 充实 |

**总计**: 26 files, 1,072 lines

---

## 八、维护规则

### 何时触发本流程
1. Z 提出新的高价值场景需要覆盖
2. 用户反馈发现某个域的 knowledge 有盲区
3. 定期（季度）review knowledge 覆盖度

### 信息时效
- knowledge 中标注的来源年份超过 3 年 → 复查是否仍然准确
- 日本政策/制度有重大变更时 → 针对性搜索更新

### 与自动化 Pipeline 的关系
- **本流程 = 手动深度补全**（场景驱动，Z 主导）
- **daily-extraction cron = 自动提取**（从日常对话中提取新经验）
- **weekly-evolution cron = 自动升华**（将积累的知识固化为规则/skill）
- 三者互补，不冲突
