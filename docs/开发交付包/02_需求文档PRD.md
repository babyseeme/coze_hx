# 温州华夏航服B2B2C平台 — 需求文档PRD（开发岗位交付版）

> 版本: v2.0 | 日期: 2026-06-28 | 面向: 后端/前端开发团队

---

## 一、功能模块总览

### 1.1 PMC平台端 (pmc_* 表)

| 模块 | 子功能 | 核心接口 | 优先级 |
|------|--------|---------|--------|
| 系统管理 | 用户/角色/菜单/部门/岗位 | CRUD + Casbin策略同步 | P0 |
| 租户管理 | TMC创建/配置/启停 | tenant CRUD | P0 |
| TMC管理 | TMC资料/套餐/采购渠道配置/外采权限 | tmc_package CRUD | P0 |
| 采购渠道 | 渠道注册/账号管理/接口配置 | procurement_channel CRUD | P0 |
| 航线数据 | 航司/机场/舱位/运价/航线 | air_* CRUD + 导入 | P0 |
| 订单监控 | 全局订单查看/异常处理/人工出票 | order:query, ticket:manual | P0 |
| 财务总览 | 全平台营收/分润/结算监控 | finance:summary | P1 |
| 开放平台 | API管理/应用授权/频次计费/日志 | open_api/open_app CRUD | P1 |
| 数据报表 | 销售统计/渠道分析/大客户分析 | report:generate | P2 |

### 1.2 TMC集团端 (tmc_* 表)

| 模块 | 子功能 | 核心接口 | 优先级 |
|------|--------|---------|--------|
| 系统管理 | 用户/角色/菜单/部门 | CRUD + Casbin | P0 |
| MMC管理 | 商户创建/配置/权限/分润模式/结算方式 | mmc_merchant CRUD | P0 |
| 采购配置 | 可用渠道/外采开关/自动采购规则 | procurement_rule CRUD | P0 |
| 销售策略 | 加价规则/折扣规则/协议价 | pricing_rule CRUD | P0 |
| 费用配置 | 服务费/订座费/出票费 | service_fee_rule CRUD | P1 |
| 结算管理 | MMC额度/信用额度/月结账单 | settlement_config, finance CRUD | P1 |
| 分润管理 | 分润规则/分润日志/周期结算 | profit_sharing_rule CRUD | P1 |
| 大客户管理 | 航司协议/白名单/前置指令 | corporate_* CRUD + 批量导入 | P1 |
| OA对接 | 钉钉/飞书/企业微信审批配置 | oa_config CRUD | P1 |
| 订单管理 | 集团订单/外采核销/异常处理 | order:query, procurement:verify | P0 |

### 1.3 MMC商户端 (mmc_* 表)

| 模块 | 子功能 | 核心接口 | 优先级 |
|------|--------|---------|--------|
| 系统管理 | 用户/角色/菜单/部门 | CRUD + Casbin | P0 |
| 商户配置 | 基本资料/采购渠道选择/自动出票 | mmc_merchant:update, procurement_rule | P0 |
| 出票管理 | 自动出票监控/手动出票/出票规则 | ticket:auto, ticket:manual | P0 |
| 审批管理 | OA审批配置/审批实例查看 | oa_config, approval_instance:query | P1 |
| 客户管理 | C端用户/员工管理/部门绑定 | c_user CRUD | P0 |
| 优惠券 | 创建/发放/核销 | coupon CRUD, coupon_user | P2 |
| 装修管理 | 小程序首页DIY/广告位/公告 | decorate_page, ad_slot CRUD | P2 |
| 订单管理 | 商户订单/退款/售后 | order:query, after_sale CRUD | P0 |
| 积分商城 | 商品/SKU/分类/库存/订单 | mall_* CRUD | P2 |

### 1.4 C端 (c_* 表 + 小程序/Web)

| 模块 | 子功能 | 核心接口 | 优先级 |
|------|--------|---------|--------|
| 登录注册 | 手机号验证码/微信授权/绑定MMC | auth:login, auth:wechat | P0 |
| 机票预订 | 查询/选座/乘机人/下单/支付 | air:search, order:create | P0 |
| 酒店预订 | 查询/下单/支付 | hotel:search, order:create | P1 |
| 火车票 | 查询/下单/支付 | train:search, order:create | P1 |
| 订单管理 | 列表/详情/退改签/审批提交 | order:query, after_sale:create | P0 |
| 会员中心 | 积分/等级/签到/权益 | member:info, sign_in:create | P1 |
| 收藏 | 航线/酒店/商品收藏 | favorite CRUD | P2 |
| 评论 | 订单评论/评分 | comment_order CRUD | P2 |
| 积分商城 | 商品浏览/兑换/购物车 | mall:query, mall_order:create | P2 |

### 1.5 开放平台

| 模块 | 子功能 | 核心接口 | 优先级 |
|------|--------|---------|--------|
| 应用管理 | 创建应用/管理appkey/白名单 | open_app CRUD | P1 |
| API授权 | 接口权限/并发/频次配置 | open_api_auth CRUD | P1 |
| 计费管理 | 按次/按月计费配置 | open_billing_config CRUD | P1 |
| 调用日志 | API调用记录/错误追踪 | open_api_log query | P1 |

---

## 二、核心接口定义

### 2.1 机票查询与预订

#### 查询航班
```
POST /api/flight/search
Request:
{
  "origin": "WZ",          // 出发城市三字码
  "destination": "PEK",    // 到达城市三字码
  "depart_date": "2026-07-01",
  "return_date": null,     // 单程null
  "trip_type": "ow",       // ow=单程 rt=往返
  "passenger_count": 1,
  "cabin_class": "Y"       // Y=经济 C=商务 F=头等
}
Response:
{
  "code": 0,
  "data": {
    "trace_id": "20260701100000_1_a3f2k1",
    "flights": [{
      "flight_no": "CA1562",
      "airline_code": "CA",
      "depart_time": "08:30",
      "arrive_time": "11:00",
      "depart_airport": "WZ",
      "arrive_airport": "PEK",
      "duration": 150,
      "aircraft_type": "737-800",
      "cabins": [{
        "cabin_code": "Y",
        "cabin_name": "经济舱",
        "price": 980.00,
        "discount": "8.5折",
        "seat_count": 23
      }]
    }]
  }
}
```

#### 创建订单
```
POST /api/order/create
Request:
{
  "order_type": "flight",       // flight/hotel/train/car/mall
  "mmc_id": 10001,
  "passengers": [{
    "name": "张三",
    "id_type": "NI",            // NI=身份证 PP=护照
    "id_number": "330102199001011234",
    "phone": "13800138000"
  }],
  "flights": [{
    "flight_no": "CA1562",
    "depart_date": "2026-07-01",
    "cabin_code": "Y",
    "price": 980.00
  }],
  "contact_name": "张三",
  "contact_phone": "13800138000",
  "payment_method": "online",   // online=在线支付 approval=差旅审批
}
Response:
{
  "code": 0,
  "data": {
    "order_no": "ORD20260701100001",
    "trace_id": "20260701100000_1_a3f2k1",
    "total_amount": 980.00,
    "status": "pending_payment",
    "payment_deadline": "2026-07-01 08:45:00"  // 15分钟支付时效
  }
}
```

### 2.2 支付接口

```
POST /api/payment/create
Request:
{
  "order_no": "ORD20260701100001",
  "payment_channel": "wechat_mini",  // wechat_mini/wechat_h5/alipay_h5/alipay_app
  "mmc_id": 10001
}
Response:
{
  "code": 0,
  "data": {
    "payment_no": "PAY20260701100001",
    "trace_id": "...",
    "prepay_params": { ... }  // 微信/支付宝预支付参数
  }
}
```

### 2.3 审批(OA对接)接口

#### 发起审批
```
POST /api/approval/create
Request:
{
  "mmc_id": 10001,
  "approval_type": "travel",     // travel=差旅 expense=费用
  "oa_platform": "dingtalk",     // dingtalk/feishu/wework
  "title": "出差审批-北京3日",
  "applicant_user_id": 50001,
  "applicant_name": "张三",
  "trip_info": {
    "destination": "北京",
    "start_date": "2026-07-01",
    "end_date": "2026-07-03",
    "reason": "客户拜访"
  },
  "order_no": null,              // 场景2:有订单号; 场景1/3:可为null
  "estimated_amount": 3500.00
}
Response:
{
  "code": 0,
  "data": {
    "approval_no": "APV20260701001",
    "third_party_id": "dingtalk_proc_12345",
    "status": "pending",
    "oa_url": "https://钉钉审批链接"
  }
}
```

#### OA审批回调
```
POST /api/approval/callback (由OA平台调用)
Request:
{
  "platform": "dingtalk",
  "process_instance_id": "dingtalk_proc_12345",
  "status": "approved",        // approved/rejected/canceled
  "approver_user_id": "manager_001",
  "approver_name": "李经理",
  "approve_time": "2026-07-01 09:30:00",
  "comment": "同意出差"
}
Response:
{ "code": 0, "message": "success" }
```

### 2.4 采购出票接口

#### 自动出票(内部队列消费)
```
无外部HTTP接口，由队列消费触发:
1. 订单支付成功 → 投递 ticket:issue 队列
2. 消费者从 queue_task 取任务
3. 按采购规则匹配渠道
4. 调用航司API验价 + 出票
5. 更新 order_item_flight.status = ticketed/refunded
6. 记录 procurement_verify_log
```

#### 外采核销导入
```
POST /api/procurement/verify/import
Request: multipart/form-data (Excel文件)
Response:
{
  "code": 0,
  "data": {
    "total": 150,
    "matched": 142,
    "unmatched": 8,
    "unmatched_details": [ ... ]
  }
}
```

### 2.5 开放平台接口

#### 第三方下单
```
POST /openapi/v1/order/create
Headers:
  X-App-Key: {app_key}
  X-Timestamp: {unix_timestamp}
  X-Sign: {hmac_sha256_sign}
  X-Trace-Id: {client_trace_id}
Request:
{
  "order_type": "flight",
  "passengers": [ ... ],
  "flights": [ ... ]
}
Response:
{
  "code": 0,
  "data": {
    "order_no": "ORD20260701100001",
    "trace_id": "...",
    "order_tag": {"source": "open_api", "app_id": 101}
  }
}
```

---

## 三、核心业务规则

### 3.1 价格验价规则(出票)

```
查询缓存价格: C端展示价格
实际采购价格: 航司实时报价

验价逻辑:
  差价 = |采购价 - 缓存价| / 缓存价
  if 差价 <= 阈值(默认3%, PMC可配置):
    自动出票
  elif 差价 <= 最大容忍值(默认10%):
    自动出票 + 记录差价日志 + 通知MMC
  else:
    挂起订单 + 通知MMC确认
```

### 3.2 信用额度校验

```
MMC下单前校验:
  可用额度 = 授信额度 - 已用额度 - 冻结额度
  if payment_method == 'approval' and 可用额度 < 订单金额:
    return 拒绝下单("额度不足")
  
  下单成功后:
    冻结额度 += 订单金额
  
  审批拒绝/退票:
    冻结额度 -= 订单金额
  
  月结结算:
    已用额度 += 结算金额
    冻结额度 -= 结算金额
```

### 3.3 分润计算规则

```
利润 = 销售价 - 采购价
分润基数 = 利润 - 服务费(可选)

PMC↔TMC分润:
  if 分润方式 == 'ratio':
    TMC分润 = 分润基数 × TMC分润比例
    PMC分润 = 分润基数 - TMC分润
  elif 分润方式 == 'fixed':
    PMC分润 = 固定金额
    TMC分润 = 分润基数 - PMC分润

TMC↔MMC分润: 同理，由TMC配置
分润时机: 按订单实时 / 按周期(月结时)
```

### 3.4 退改签规则

```
退票:
  C端发起退票 → 校验航司退票规则 → 计算退票手续费
  → 创建after_sale记录 → 提交航司退票
  → 退票成功 → 原路退款(在线支付) / 额度解冻(审批支付)
  → 退票失败 → 通知C端

改签:
  C端发起改签 → 查询可改航班 → 计算改签费+差价
  → C端补差价支付 → 提交航司改签
  → 改签成功 → 更新order_item_flight
  → 改签失败 → 退回差价
```

### 3.5 大客户出票规则

```
出票时自动匹配大客户:
  1. 查询乘机人身份证 → corporate_whitelist匹配
  2. 匹配到签约公司 → 查询corporate_contract
  3. 获取大客户政策 → corporate_policy_rule
  4. 生成前置指令 → corporate_pre_command
  5. 出票时携带大客户指令提交航司

约束: 一个员工在同一家航司只能隶属一个签约公司
```

---

## 四、数据状态机

### 4.1 订单状态

```
pending_payment → paid → ticketing → ticketed → completed
                    ↓         ↓
                 canceled  ticket_failed → manual_handling
                    ↓
              refunding → refunded
```

### 4.2 售后状态

```
pending → approved → processing → completed
            ↓            ↓
         rejected    failed → retry
```

### 4.3 审批实例状态

```
pending → in_approval → approved → order_creating → order_created
                ↓
            rejected → canceled
                ↓
         (场景3) refund_pending → refunded
```

### 4.4 采购核销状态

```
pending → verifying → verified → reconciled
              ↓
          unmatched → manual_matching → verified
```

---

## 五、验收标准

### 5.1 功能验收

| 模块 | 验收条件 |
|------|---------|
| 机票查询 | 查询响应<2s，缓存命中率>80%，价格误差<3% |
| 订单创建 | 支持单程/往返/多段，15分钟支付时效 |
| 在线支付 | 微信/支付宝成功率>99.5%，回调幂等 |
| 自动出票 | 验价通过率>90%，出票耗时<30s |
| 审批对接 | 钉钉/飞书/企微三端审批同步延迟<5s |
| 信用额度 | 下单实时校验，冻结/解冻准确性100% |
| 分润计算 | 分润金额精确到分，对账差异率<0.01% |
| 大客户出票 | 白名单匹配准确率100%，前置指令正确率100% |
| 开放平台 | API响应<1s，频次限制误差<5%，签名校验100% |

### 5.2 性能验收

| 指标 | 目标 |
|------|------|
| 并发查询 | 1000 QPS |
| 并发下单 | 200 TPS |
| 页面首屏 | <1.5s |
| 接口P99延迟 | <500ms |
| 出票队列消费 | <30s/笔 |
| 数据库慢查询 | <100ms (P95) |

### 5.3 安全验收

| 检查项 | 标准 |
|--------|------|
| SQL注入 | 0漏洞 |
| XSS攻击 | 0漏洞 |
| 敏感数据 | 手机号/身份证脱敏显示 |
| API签名 | HMAC-SHA256，防重放(5分钟时效) |
| 权限越权 | 水平/垂直越权测试0通过 |
| trace_id | 不包含敏感信息 |
