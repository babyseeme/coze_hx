# 华夏航服B2B2C - AI UI设计高保真提示词

> 以下提示词专为AI设计工具（Midjourney / DALL-E / Figma AI / v0 / 即梦等）优化，分别针对TMC集团管理端、MMC商户端、C端客户端三个角色生成高保真UI设计图。

---

## 一、全局设计规范提示词（Design System Prompt）

```
Design a comprehensive B2B2C aviation travel service platform called "华夏航服" (Huaxia Aviation Service). 

Global Design System:
- Primary color: Deep navy blue (#1e3a5f) with sky blue accent (#3b82f6)
- Secondary: Emerald green (#10b981) for success states, Amber (#f59e0b) for warnings
- Typography: Chinese - PingFang SC / Noto Sans SC; English - Inter; Monospace - JetBrains Mono for data
- Border radius: 8px for cards, 6px for buttons, 12px for modals
- Spacing: 8px base grid system
- Shadows: Subtle elevation shadows, sm: 0 1px 2px rgba(0,0,0,0.05), md: 0 4px 6px rgba(0,0,0,0.07)
- Icons: Lucide icon set, 20px size for navigation, 16px for inline actions
- Data visualization: Use gradient fills for charts, consistent color palette for series
- Layout: Sidebar navigation (220px) + content area with 24px padding
- Table style: Clean with subtle row hover, 13px font, alternating row hints
- Style: Professional enterprise SaaS, clean and data-dense, inspired by Linear + Ant Design Pro
- Language: All UI text in Simplified Chinese
```

---

## 二、TMC集团管理端 UI提示词

### 2.1 TMC工作台（Dashboard）

```
Create a high-fidelity dashboard UI for TMC (Team Management Center) - an aviation travel group management portal.

Page: TMC Dashboard / 工作台
Layout: Full-width admin dashboard with left sidebar (220px, dark navy #1e293b background) + main content area

Top bar: White background, left side shows breadcrumb "首页 / 工作台", right side shows notification bell icon + user avatar with name "温州航空集团-张经理"

Stats row: 4 metric cards in a row
- Card 1: "MMC商户数" with value "12" and green up arrow "+2"
- Card 2: "今日订单" with value "347" and green up arrow "+15%"
- Card 3: "今日交易额" with value "¥423K" in blue, green up arrow "+18%"
- Card 4: "出票成功率" with value "96.8%" in green, red down arrow "-0.5%"
Each card: White background, subtle border, rounded corners (12px), value in large bold 28px font

Below stats: Two-column layout
- Left (60%): Line chart showing "近7日交易趋势" with dual Y-axis (订单量 + 交易额), gradient blue fill under the line
- Right (40%): Pie chart showing "商户订单占比" with 3-4 segments in blue/green/amber/purple

Bottom: Data table "MMC商户概览" with columns: 商户名称, 类型(subsidiary/distributor badge), C端用户, 今日订单, 余额/额度, 状态(green/amber badge)

Sidebar shows: 华夏航服 logo + TMC green badge, nav groups: 系统管理(工作台/用户/角色), 商户管理(MMC管理/结算), 采购管理(渠道/规则/核销), 业务管理(销售策略/差旅政策/大客户/分润), 开放平台(应用管理)

Style: Professional enterprise SaaS, clean white cards on #f0f2f5 background, data-dense but breathable. All Chinese text. High resolution, Figma-quality mockup.
```

### 2.2 TMC结算管理

```
Create a high-fidelity UI for TMC Settlement Management page.

Page: 结算管理 / Settlement Management
Layout: Admin layout with sidebar + content area

Top section: 4 stat cards
- "应收总额" ¥2.86M (blue)
- "已收总额" ¥2.41M (green)  
- "待结算" ¥456K (amber)
- "逾期金额" ¥23K (red)

Main content: Data table "MMC结算概览"
Columns: 商户, 结算方式(信用额度/预付/月结 badge), 信用额度, 已用, 可用, 预警状态, 操作(调整额度/账单 buttons)
One row highlighted in red warning: 宁波差旅, 信用额度¥200K, 已用¥184K(92%), 预警=超额预警 red badge
Other rows in normal green status

Right side panel (collapsible): Quick action panel with buttons "生成月结账单" "批量催收" "导出报表"

Style: Financial data-heavy interface, numbers right-aligned, color-coded status indicators, professional and trustworthy feel. Chinese text. High-res Figma mockup.
```

### 2.3 TMC采购渠道配置

```
Create a high-fidelity UI for TMC Procurement Channel Configuration page.

Page: 采购渠道管理 / Procurement Channel Management

Main table: "采购渠道配置"
Columns: 渠道名称, 类型(内采blue badge/外采amber badge), 账号状态, 自动采购(已开启/关闭 toggle), 验价阈值(%), 操作(规则/账号/核销 buttons)

Example rows:
- "国航B2B直连" - 内采 - 已配置 green - toggle ON - 5% - [规则] [账号]
- "中航信1E系统" - 内采 - 已配置 green - toggle ON - 3% - [规则] [账号]
- "东航B2B(自签)" - 外采 amber - 已配置 green - toggle ON - 8% - [规则] [核销]

Above table: Filter bar with search input, type dropdown, "新增外采渠道" primary button

Below table: Expandable section "自动采购规则配置" showing a rule list:
- Rule 1: CA全航线 → 国航B2B直连, 阈值5%, 优先级10
- Rule 2: MU 温州-上海 → 中航信1E, 阈值3%, 优先级20
Each rule has edit/delete inline actions

Style: Technical configuration interface, clean table with clear status indicators, toggle switches with blue active state. Chinese text. Professional SaaS style.
```

---

## 三、MMC商户端 UI提示词

### 3.1 MMC出票管理

```
Create a high-fidelity UI for MMC Ticketing Management page (出票管理).

Page: 出票管理 / Ticketing Management

Stats row: 4 cards
- "待出票" 5 (amber)
- "出票中" 2 (blue)
- "今日已出票" 79 (green)
- "出票失败" 1 (red)

Main table: "待出票队列"
Columns: 订单号, 乘机人, 航线(如WZS→PEK), 航司(2-letter code badge), 采购渠道, 验价状态, 操作

Key visual detail: 验价状态 column uses 3-level color coding:
- Green badge "验价通过" - auto ticket button primary
- Amber badge "价格偏差2%" - ticket button + verify button
- Red badge "验价超阈值" - "人工处理" warning button

Top right: "批量导出" outline button

Below table: Real-time status bar showing "自动采购运行中" with green dot animation and "最近出票: 2分钟前 CA1567 张三"

Style: Operation-critical interface, clear visual hierarchy, status colors prominently displayed, action buttons contextually colored. Chinese text. Professional operations dashboard.
```

### 3.2 MMC审批流程设计器

```
Create a high-fidelity UI for MMC Approval Workflow Designer (审批流程设计器).

Page: 审批流程设计器

Layout: Full-page designer with toolbar at top and canvas below

Toolbar tabs: 基础信息(outline) | 流程设计(primary active) | 表单设计(outline) | 其他设置(outline)
Right side: "保存草稿" outline + "发布" primary buttons

Canvas area: Light gray (#f9fafb) background with dot grid pattern

Flow diagram (horizontal, left to right):
1. START node: Green border, "开始" title, "全员可提交" subtitle, rounded rectangle
2. Arrow connector →
3. CONDITION node: Amber border, "条件分支" title, "2组3条条件" subtitle, diamond shape
4. Three branches going right:
   - Top branch: Green label "≤1天" → END node "自动通过" (gray)
   - Middle branch: Blue label "1-3天" → APPROVAL node "领导审批 直属上级" → END "自动通过"
   - Bottom branch: Red label ">5天" → APPROVAL node "BOSS审批 超级管理员" → APPROVAL "领导审批 直属上级" → END "自动通过"

Each node: White card with colored left border (4px), rounded corners (12px), subtle shadow
Connectors: Blue arrows with smooth bezier curves
Selected node: Blue glow outline + right panel showing node configuration

Right panel (320px, when node selected): "BOSS审批(超管)" configuration
- 审批类型: manual/autopass/autoreject radio
- 审批人: role/superior/self/specified radio, currently "角色=超级管理员" selected
- 多人审批方式: sequential/countersign/or_sign radio, currently "依次审批" selected
- 审批人为空: admin/specified radio

Style: Clean flow chart design, nodes have clear visual distinction by type (start=green, condition=amber, approval=blue, end=gray), professional BPM tool aesthetic like钉钉审批/飞书审批. Chinese text. High-res Figma mockup.
```

### 3.3 MMC小程序装修编辑器

```
Create a high-fidelity UI for MMC Mini-Program Page Decoration Editor (小程序页面装修编辑器).

Page: 小程序装修编辑器

Layout: Three-column layout
- Left (240px): Component library panel with drag handle
- Center (375px): Phone preview frame showing the mini-program page
- Right (320px): Property editor panel

Left panel - "组件库":
Categorized components with drag icons:
- 基础组件: 轮播图🖼️, 导航宫格📋, 公告栏📢, 富文本📄
- 业务组件: 机票搜索框✈️, 酒店搜索框🏨, 热门航线🔥, 商品列表🛒
- 营销组件: 广告位📢, 活动Banner🎯, 优惠券券🎨

Center - Phone Preview:
iPhone-like frame (375px width) showing:
- Status bar (time, battery)
- Header: "温州商旅" with member badge "金卡"
- Search bar: 机票/火车票/酒店 tabs + city inputs
- Quick nav grid: 8 icons (2 rows x 4 columns)
- Banner: "暑期特惠" gradient blue-purple
- Hot flights: Horizontal scroll cards (温州→北京 ¥680起)
- Bottom tab bar: 首页/订单/商城/我的

One component (轮播图) is visually selected with blue dashed border and resize handles

Right panel - "轮播图 属性":
- Height: 160px input
- Autoplay: toggle ON
- Interval: 3s input
- Image list: 3 items with thumbnail, link, sort handle, delete button
- + "添加图片" button

Style: Visual page builder, clean component library with subtle hover effects, phone preview with realistic device frame. Inspired by 有赞微商城/微擎装修编辑器. Chinese text. Professional SaaS tool aesthetic.
```

---

## 四、C端客户端 UI提示词

### 4.1 C端首页（小程序）

```
Create a high-fidelity mobile UI for the C-end customer mini-program homepage.

Device: iPhone 15 Pro, 390px width, status bar visible
App: 温州商旅 (Huaxia Travel Service by WZ Aviation)

Screen structure (top to bottom):

1. Header area (gradient blue #3b82f6 → #1d4ed8):
   - App name "温州商旅" in white 18px bold
   - Subtitle "温州航空集团旗下 | 会员等级: 金卡" in white 12px 80% opacity
   - Right side: notification bell icon + settings gear icon

2. Search card (white, -20px overlap with header, rounded 12px, shadow):
   - Tab bar: ✈️机票(active blue) | 🚄火车票 | 🏨酒店 | 🚗用车
   - City swap input: "温州" ↔ [swap button] ↔ "北京"
   - Date inputs: "2026-07-01" | "返程(选填)"
   - Big blue search button "🔍 搜索航班"

3. Quick navigation (8 icons, 2 rows x 4):
   Row 1: ✈️机票(blue bg), 🚄火车票(green bg), 🏨酒店(amber bg), 🚗用车(pink bg)
   Row 2: 🌱签到(purple bg), 🎁优惠券(blue bg), 🛒积分商城(green bg), ❤️收藏(red bg)
   Each: 48px colored circle icon + 12px label below

4. Banner (rounded 10px, gradient blue-purple):
   "暑期特惠" large text + "温州出发 机票低至3折" subtitle
   Decorative airplane silhouette

5. Hot flights section:
   Title "热门航线" with "更多❤️" right-aligned
   Horizontal scroll cards:
   - 温州→北京 ¥680起
   - 温州→上海 ¥380起
   - 温州→广州 ¥520起
   - 温州→成都 ¥580起
   Each card: white bg, route in 14px bold, price in 16px red bold with "起" in gray 11px

6. Bottom tab bar (white, fixed):
   🏠首页(active blue) | 📋订单 | 🛒商城 | 👤我的

Style: Modern Chinese travel app, clean white cards, blue primary, data-light and visual-rich. Inspired by 携程/飞猪 mini-program aesthetic but with distinct corporate aviation branding. All Chinese text. High-res, pixel-perfect mobile UI mockup.
```

### 4.2 C端订单列表（小程序）

```
Create a high-fidelity mobile UI for the C-end order list page.

Device: iPhone 15 Pro, 390px width

Page: 我的订单

Top: Navigation bar with back arrow + "我的订单" title

Tab bar: 全部 | 待支付 | 待出票 | 已出票 | 退改签
Active tab has blue underline indicator

Order cards (vertical list, each card white rounded 12px, 12px gap):

Card 1 (待出票 status):
- Top row: CA 国航 logo + "CA1567" flight number + amber badge "待出票"
- Route: "温州 WZS → 北京 PEK" with airplane icon
- Date: "2026-07-01 08:30" + "经济舱"
- Passenger: "张三"
- Bottom row: left "¥1,280" red bold price | right "差旅审批" outline button + "详情" primary button

Card 2 (已出票 status):
- Top: MU 东航 + "MU5234" + green badge "已出票"
- Route: "温州 → 上海"
- Date: "2026-06-28 14:00"
- Bottom: "¥680" | "申请退改" outline + "详情" primary

Card 3 (商城 order):
- Top: 🛒 icon + "积分商城" + green badge "已发货"
- Product: "华为FreeBuds耳机" with small product image
- Bottom: "2,000积分" | "查看物流" outline + "确认收货" primary

Floating bottom: "差旅审批" special button with briefcase icon, showing "3条待审批" badge count

Style: Clean card-based list, status colors prominent, airline logos as 2-letter codes in colored circles, swipe-to-action hints. Chinese text. Modern mobile UI.
```

### 4.3 C端差旅审批提交（小程序）

```
Create a high-fidelity mobile UI for the C-end travel approval submission flow.

Device: iPhone 15 Pro, 390px width

Page: 差旅审批 / 提交审批

Step indicator at top: ①填写信息(active) → ②选择行程 → ③提交确认

Form section (white card, rounded 12px):
- 出差类型: 商务出差 / 个人出差 (radio buttons)
- 出差事由: [text input "北京客户拜访"]
- 出差日期: "2026-07-01" ~ "2026-07-03" (3天)
- 目的城市: "北京"

Trip section (card):
- 推荐航班: CA1567 温州→北京 07-01 08:30 ¥1,280
- [选择此航班] button
- or [自行搜索航班] link

Payment method selection (critical UI):
- ○ 在线支付 (微信/支付宝 icon) - 立即付款
- ● 差旅审批 (briefcase icon) - 审批通过后抵扣额度 ← SELECTED with blue highlight

Approval info preview (blue info card):
- 审批流程: 直属上级审批
- 预计审批时长: 1-2小时
- 额度抵扣: ¥1,280 从公司差旅额度中扣除

Bottom fixed bar: "提交审批" large blue button, full width

Style: Professional corporate travel booking, clear form sections, approval flow transparent to user, payment method selection prominent. Chinese text. Clean enterprise mobile UI.
```

### 4.4 C端会员中心（小程序）

```
Create a high-fidelity mobile UI for the C-end member center page.

Device: iPhone 15 Pro, 390px width

Page: 我的 / Member Center

Top section (gradient blue-purple with decorative curve):
- Avatar circle (64px) with "张" initial
- Name: "张三" + 金卡 member badge (gold gradient)
- Member ID: "HX2026010001"
- Points: "3,580 积分" with "签到" button (if not signed today)

Quick stats row (3 columns):
- 优惠券: "5张" 
- 收藏: "12"
- 足迹: "86"

Member tier progress bar:
- Current: 金卡 (Gold)
- Progress: 3,580 / 5,000 points to 铂金 (Platinum)
- Visual: gradient progress bar with airplane icon at current position
- Benefits preview: "还差1,420积分升级铂金，享免费选座+贵宾厅"

Menu grid (2 columns, white cards):
Row 1: 📋 我的订单 | ✈️ 常旅客管理
Row 2: 🏢 企业差旅 | 💼 差旅审批(3)
Row 3: 🎫 优惠券 | 🛒 积分商城
Row 4: ⭐ 收藏夹 | 📞 客服中心
Row 5: ⚙️ 设置 | 📄 关于

Style: Premium travel membership feel, gradient header with curves, gold accents for member tier, clean icon grid menu. Inspired by 航司会员App (国航/南航) but modernized. Chinese text. High-res mobile UI.
```

---

## 五、通用组件提示词

### 5.1 订单来源Tag组件

```
Design a set of order source tag/badge components for a B2B2C aviation platform:
- "小程序" - gray badge with phone icon
- "Web端" - blue badge with monitor icon  
- "OpenAPI" - purple badge with code icon
- "App" - green badge with mobile icon
- "内部OA" - amber badge with building icon

Each badge: pill shape, 11px font, subtle left icon, consistent sizing. Show them in context of a table cell and as standalone elements. Professional SaaS style.
```

### 5.2 结算方式可视化组件

```
Design a visual component showing the 3-tier settlement chain of a B2B2C aviation platform:

C端用户 → MMC商户 → TMC集团 → 供应商/PMC平台

Each arrow should show the settlement type:
- C→MMC: 实时支付 (green, with WeChat/Alipay icons)
- MMC→TMC: 预付/月结/信用额度 (configurable, shown as dropdown/toggle)
- TMC→供应商: 预付/月结/信用额度 (configurable)

Each entity shown as a card with icon, name, and current balance/credit status.
Visual style: Flow diagram with animated arrows, professional financial dashboard aesthetic. Chinese labels. Dark mode variant included.
```

---

## 使用说明

1. **Midjourney/DALL-E**: 将以上提示词直接粘贴，建议追加 `--ar 16:9 --style raw --v 6` (Midjourney) 或指定分辨率 `1920x1080`
2. **Figma AI / v0.dev**: 提示词可直接使用，系统会生成可编辑的组件
3. **即梦/通义万相**: 中文提示词已内嵌，直接使用即可
4. 建议每个提示词单独生成，不要合并多个页面到一个提示词
5. 生成后如需调整配色，修改提示词中的色值即可
6. 移动端提示词建议追加 `mobile UI, iOS style, iPhone 15 Pro frame` 增强真实感
