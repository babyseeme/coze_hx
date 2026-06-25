# 华夏航服 B2B2C 综合航旅服务平台 — 项目交付文档

> 版本: v9 | 数据库: 128+7张表 | 架构: Hyperf 3.1 + Swoole / MySQL 8.0 / Redis / RabbitMQ
>
> 文档生成时间: 2025-06-26

---

## 目录

1. [项目架构说明](#一项目架构说明)
2. [业务流转思维脑图](#二业务流转思维脑图)
3. [数据库表结构设计说明](#三数据库表结构设计说明)
4. [功能需求列表及注意事项](#四功能需求列表及注意事项)
5. [核心功能实现代码示例](#五核心功能实现代码示例)

---

# 一、项目架构说明

## 1.1 产品定位

温州华夏航服 B2B2C 综合航旅服务平台 — 面向航旅行业的多租户 SaaS 平台，连接航空公司/供应商(供)、航旅商户(销)、终端旅客(客)，覆盖机票、火车票、酒店、商城、保险、用车六大业务线。

## 1.2 三端隔离架构

```
┌─────────────────────────────────────────────────────┐
│                   平台 PMC (Platform)                │
│  超级管理员 | 系统配置 | 航司对接 | 全局风控 | 对账   │
└──────────────────────┬──────────────────────────────┘
                       │
          ┌────────────┼────────────┐
          ▼                         ▼
┌──────────────────┐      ┌──────────────────┐
│  集团 TMC (Tenant) │      │  商户 MMC (Merchant) │
│  多商户管理         │      │  独立运营            │
│  员工体系           │      │  客户管理            │
│  分销体系           │      │  订单/出票           │
│  资金池             │      │  大客户管理          │
└──────────────────┘      └──────────────────┘
          │                         │
          └────────────┬────────────┘
                       ▼
              ┌─────────────────┐
              │  C端 用户 (User)  │
              │  微信/支付宝登录   │
              │  会员体系         │
              │  常用旅客         │
              │  钱包/积分        │
              └─────────────────┘
```

### 三端物理分表

| 端 | 表前缀 | 数量 | 职责 |
|---|---|---|---|
| PMC | pmc_* | 12 | 平台运营: 用户/部门/岗位/角色/菜单/日志 |
| TMC | tmc_* | 17 | 集团管理: 用户/部门/岗位/角色/套餐/分销 |
| MMC | mmc_* | 17 | 商户运营: 用户/部门/岗位/角色/套餐/套餐菜单 |
| 共享 | — | 7 | 附件/权限策略/迁移/租户/规则/三方授权 |

## 1.3 技术架构

```
                    ┌──────────────┐
                    │   Nginx/Cdn   │
                    └──────┬───────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                 ▼
   ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
   │  Vue3+Element │ │  uni-app H5  │ │  uni-app 小程│
   │   PMC/TMC后台  │ │   C端用户端   │ │   序/APP     │
   └──────┬───────┘ └──────┬───────┘ └──────┬───────┘
          │                │                 │
          └────────────────┼─────────────────┘
                           ▼
                  ┌─────────────────┐
                  │  Hyperf 3.1      │
                  │  + Swoole 协程   │
                  │  HTTP + WebSocket│
                  └────────┬────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                 ▼
   ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
   │  MySQL 8.0    │ │  Redis 7     │ │  RabbitMQ    │
   │  主从+读写分离 │ │  缓存+会话   │ │  异步任务队列 │
   └──────────────┘ └──────────────┘ └──────────────┘
```

## 1.4 核心设计原则

| 原则 | 说明 |
|---|---|
| **零外键** | 全库无 FOREIGN KEY，应用层 ORM 维护关联，避免级联锁 |
| **多租户隔离** | 所有业务表含 tenant_id，C端表含 tenant_id + member_id |
| **脱敏三字段法** | phone(脱敏明文) + phone_encrypted(AES-256-GCM) + phone_hash(HMAC-SHA256) |
| **订单三层架构** | order(主) → order_sales/order_procurement(业务) → order_item_*(子订单) |
| **销售/采购分轨** | 销售侧(面向客户) 与 采购侧(面向供应商) 平行，通过 procure_item.sales_item_id 关联 |
| **软删除** | deleted_at 字段，UNIQUE INDEX 含 deleted_at |
| **乐观锁版本控制** | 余额/积分等资产字段配合 version + log 双重保障 |

---

# 二、业务流转思维脑图

## 2.1 机票业务全流程

```
机票业务流
├── 搜索报价
│   ├── C端用户搜索航班
│   ├── 查询 air_airline + air_airport + air_cabin 组合
│   ├── 匹配 corporate_policy 大客户政策
│   └── 返回报价(含政策优惠)
│
├── 下单支付
│   ├── 创建 order (待支付)
│   ├── 创建 order_sales (销售业务单)
│   ├── 创建 order_item_flight (子订单)
│   ├── 写入 order_status_log (状态: pending→unpaid)
│   ├── C端支付 → payment_log (待支付→支付成功)
│   ├── 更新 order.status = paid
│   └── 写入 order_status_log (状态: unpaid→paid)
│
├── 采购出票
│   ├── 创建 order_procurement (采购业务单)
│   ├── 创建 order_procure_item (关联 sales_item_id)
│   ├── 向航司提交出票请求
│   ├── 写入出票前置指令(RMK/SSR/PAT)
│   ├── 出票成功 → order_item_flight.status = ticketed
│   ├── 写入 order_item_status_log (paid→ticketed)
│   └── 写入 order_status_log (paid→ticketed)
│
├── 航变处理
│   ├── 接收航司航变通知 (air_airline_notice)
│   ├── 创建 service_task (航变任务)
│   ├── 通知旅客 + 处理改签/退票
│   └── service_task_log 记录处理过程
│
├── 退改签
│   ├── C端申请退/改 → order_change
│   ├── 计算 air_gauge 退改手续费
│   ├── 匹配大客户退改政策
│   ├── 退票: order_item_flight.status → refunding
│   │   ├── 创建 finance_refund
│   │   ├── finance_refund_log (审核→审批→打款)
│   │   └── 退款成功 → order_item_flight.status = refunded
│   └── 改签: order_item_flight.status → changing
│       └── 改签成功 → 新的 order_item_flight
│
└── 财务结算
    ├── 企业账户 → company_bill (月结账单)
    ├── 供应商账户 → supplier_bill (采购账单)
    └── finance_invoice (开票)
```

## 2.2 大客户业务全流程

```
大客户业务流
├── 集团签约
│   ├── 创建 corporate_group (集团主体: 如"华为")
│   ├── 创建 corporate_contract (签约关系: 华为×CA)
│   │   ├── identity_type: 实名/非实名
│   │   ├── pre_commands: 出票前置指令(RMK/SSR)
│   │   ├── blackout_dates: 不适用日期
│   │   └── age_restriction: 年龄限制(非实名)
│   └── 创建 corporate_policy (自动申报政策)
│       ├── policy_type: 返点/定额/固定折扣
│       └── corporate_policy_rule (政策规则条件)
│
├── 白名单管理(实名制)
│   ├── corporate_whitelist_template (航司字段模板)
│   ├── 企业提交白名单 → corporate_whitelist_batch
│   ├── corporate_whitelist_member (成员明细)
│   ├── 审核通过 → c_member_corporate (成员身份)
│   └── 审核拒绝 → corporate_whitelist_member.status = rejected
│
├── 员工加入(实名)
│   ├── C端用户注册 → c_user
│   ├── 加入商户 → c_member
│   ├── 申请大客户身份 → c_member_corporate_apply
│   ├── 白名单校验 (姓名+证件号 匹配)
│   ├── 审核通过 → c_member_corporate
│   └── 关联 contract_id + group_id
│
├── 自动申报(出票时)
│   ├── 出票前匹配 corporate_policy_rule
│   ├── 条件: 航司+舱位+航线+淡旺季+提前天数
│   ├── 匹配成功 → corporate_policy_match_log
│   ├── 写入PNR前置指令
│   └── 出票 → 自动申报完成
│
└── 非实名制(无需白名单)
    ├── 仅校验年龄限制
    └── 校验黑名单日期(blackout_dates)
```

## 2.3 酒店业务全流程

```
酒店业务流
├── 搜索预订
│   ├── C端搜索酒店 → hotel_info (城市+星级+品牌)
│   ├── 选择房型 → hotel_room_type
│   └── 创建 order_item_hotel (子订单)
│
├── 确认/拒绝
│   ├── 供应商确认 → status = confirmed
│   ├── 供应商拒绝 → status = rejected + 退款
│   └── 超时未确认 → 自动取消 + 退款
│
├── 入住/离店
│   ├── 入住 → status = checked_in
│   └── 离店 → status = checked_out
│
└── 售后
    └── mall_after_sale (酒店复用商城售后体系)
```

## 2.4 火车票业务全流程

```
火车票业务流
├── 搜索
│   ├── 查询 train_station + train_type
│   └── 返回车次+座位类型+价格
│
├── 下单出票
│   ├── 创建 order_item_train
│   ├── 选座(高铁: A/B/C/D/F)
│   ├── 12306下单 → 出票
│   └── status = ticketed
│
├── 退改
│   ├── 退票: 按 train_seat_type 退票费率
│   │   ├── >8天: 0%
│   │   ├── 48h~8天: 5%
│   │   ├── 24h~48h: 10%
│   │   └── <24h: 20%
│   └── 改签: 一次改签限制
│
└── 财务
    └── 走采购结算(supplier_bill)
```

## 2.5 商城业务全流程

```
商城业务流
├── 商品管理
│   ├── mall_category (分类树)
│   ├── mall_goods + mall_goods_sku (SPU+SKU)
│   ├── mall_spec + mall_spec_value (规格定义)
│   └── mall_goods_spec_rel (规格关联)
│
├── 购物车+下单
│   ├── mall_cart (加购)
│   ├── 创建 order_item_mall
│   ├── 优惠券抵扣 → mall_user_coupon
│   ├── 积分抵扣 → c_member_points_log
│   └── 余额支付 → c_member_balance_log
│
├── 发货
│   ├── mall_delivery_template + mall_delivery_rule (运费计算)
│   ├── mall_express (快递公司)
│   └── 物流单号回填
│
├── 售后
│   ├── mall_after_sale (退款/退货/换货)
│   ├── mall_after_sale_log (进度日志)
│   └── mall_after_sale_image (凭证)
│
└── 评价
    └── mall_comment + mall_comment_image
```

## 2.6 财务结算全流程

```
财务结算流
├── 销售侧(企业→平台)
│   ├── 企业充值 → finance_company_account
│   │   └── finance_company_account_log (充值记录)
│   ├── 企业消费 → company_account_log (扣款记录)
│   ├── 月结出账 → finance_company_bill
│   │   └── finance_company_bill_item (账单明细)
│   └── 企业来款 → finance_company_payment (线下打款)
│
├── 采购侧(平台→供应商)
│   ├── 供应商账户 → finance_supplier_account
│   ├── 采购出账 → finance_supplier_bill
│   └── 供应商付款 → finance_supplier_payment
│
├── 退款
│   ├── finance_refund (统一退款单)
│   ├── finance_refund_log (审核+审批+打款)
│   └── 退款来源: 自愿退/非自愿退/航变退/售后退
│
└── 发票
    └── finance_invoice (开票记录)
```

## 2.7 会员资产流转

```
会员资产流
├── 余额
│   ├── 充值 → c_member_balance_log(change_type=recharge)
│   ├── 消费 → c_member_balance_log(change_type=payment)
│   ├── 退款 → c_member_balance_log(change_type=refund)
│   ├── 调整 → c_member_balance_log(change_type=adjust)
│   └── 版本控制: balance_version 乐观锁
│
├── 积分
│   ├── 消费返积分 → c_member_points_log(change_type=earn)
│   ├── 积分抵扣 → c_member_points_log(change_type=consume)
│   ├── 积分过期 → c_member_points_log(change_type=expire)
│   ├── 版本控制: points_version 乐观锁
│   └── 等级判定: total_earned_points → c_member_grade
│
└── 等级
    ├── c_member_grade (等级定义)
    ├── 升级: total_earned_points 达到 min_points
    ├── 降级: 定期结算 total_earned_points 不达标
    └── 等级权益: 折扣率/积分倍率/升舱/休息室等
```

---

# 三、数据库表结构设计说明

## 3.1 表总览 (135张, v9 + v9_fix)

### 基础设施层 (PMC/TMC/MMC/共享) — 53张

| 分组 | 表数 | 表名 |
|---|---|---|
| PMC端 | 12 | pmc_user/department/position/role/menu/login_log/operation_log/dept_leader/user_dept/user_position/role_menu |
| TMC端 | 17 | tmc_user/department/position/role/menu/login_log/operation_log/package/package_menu/package_change_log/dept_leader/user_dept/user_position/role_menu/distributor/distributor_relation |
| MMC端 | 17 | mmc_user/department/position/role/menu/login_log/operation_log/package/package_menu/dept_leader/user_dept/user_position/role_menu/distributor/distributor_relation |
| 共享 | 7 | attachment/data_permission_policy/data_permission_policy_module/migrations/rules/tenant/user_third_party_auth/user_third_party_login_log |

### C端用户层 — 13张

| 表名 | 说明 |
|---|---|
| c_user | 平台自然人(手机号+身份信息) |
| c_member | 商户会员(钱包+积分+等级) |
| c_member_address | 收货地址 |
| c_member_corporate | 大客户成员身份(contract_id+group_id) |
| c_member_corporate_apply | 大客户申请记录 |
| c_member_grade | 会员等级定义(银卡/金卡/白金/钻石) |
| c_member_balance_log | 余额变更日志(版本控制) |
| c_member_points_log | 积分变更日志(版本控制+过期追踪) |
| c_passenger | 常用旅客(脱敏三字段法) |
| corporate_group | 大客户集团主体(跨航司) |
| corporate_contract | 航司签约关系(前置指令/黑名单/白名单配置) |
| corporate_policy | 自动申报政策(返点/定额/折扣) |
| corporate_policy_rule | 政策匹配规则(航司+舱位+航线+淡旺季) |

### 白名单体系 — 3张

| 表名 | 说明 |
|---|---|
| corporate_whitelist_template | 航司白名单字段模板(每航司格式不同) |
| corporate_whitelist_batch | 白名单提交批次 |
| corporate_whitelist_member | 白名单成员明细 |

### 订单体系 — 16张

| 表名 | 说明 |
|---|---|
| order | 主订单(支付+状态+金额汇总) |
| order_sales | 销售业务订单(面向客户) |
| order_procurement | 采购业务订单(面向供应商) |
| order_item_flight | 机票子订单 |
| order_item_train | 火车票子订单 |
| order_item_hotel | 酒店子订单 |
| order_item_mall | 商城子订单 |
| order_item_insurance | 保险子订单(绑定出行子订单) |
| order_item_car | 用车子订单 |
| order_procure_item | 采购明细(关联sales_item_id) |
| order_change | 退改签记录 |
| order_status_log | 主订单状态变更日志 |
| order_item_status_log | 子订单状态变更日志 |
| payment_log | 支付流水日志(全流程+对账) |
| finance_refund_log | 退款流程日志(审核+打款) |
| service_task | 服务任务(航变/退改/特殊需求) |

### 航空基础 — 13张

| 表名 | 说明 |
|---|---|
| air_airline | 航司信息 |
| air_airport | 机场信息 |
| air_region | 行政区域(省市,空铁酒共享) |
| air_plane_model | 机型 |
| air_cabin_level | 舱位等级(F/C/Y) |
| air_cabin | 舱位信息(退改规则+价格) |
| air_fuel | 燃油附加费 |
| air_fuel_detail | 燃油费明细 |
| air_gauge_type | 退改时间段 |
| air_gauge | 退改规则 |
| air_airline_accounts | 航司账户(采购用) |
| air_platform | 平台信息 |
| air_airline_notice | 航司通知(航变等) |

### 火车基础 — 3张

| 表名 | 说明 |
|---|---|
| train_station | 火车站(城市编码复用air_region) |
| train_type | 车次类型(G/D/C/Z/T/K) |
| train_seat_type | 座位类型+退票费率 |

### 酒店基础 — 3张

| 表名 | 说明 |
|---|---|
| hotel_brand | 酒店品牌 |
| hotel_info | 酒店信息(4种供应商对接) |
| hotel_room_type | 房型 |

### 商城体系 — 21张

| 分组 | 表数 | 表名 |
|---|---|---|
| 商品 | 8 | mall_category/spec/spec_value/goods/goods_sku/goods_image/goods_category/goods_spec_rel |
| 营销 | 3 | mall_coupon/coupon_scope/user_coupon |
| 购物 | 2 | mall_cart/favorite |
| 售后 | 3 | mall_after_sale/after_sale_image/after_sale_log |
| 物流 | 3 | mall_delivery_template/delivery_rule/express |
| 评价 | 2 | mall_comment/comment_image |

### 保险 — 1张

| 表名 | 说明 |
|---|---|
| insurance_product | 保险产品定义(航意险/延误险/取消险) |

### 服务任务 — 3张

| 表名 | 说明 |
|---|---|
| service_task | 服务任务(12种类型+11种状态) |
| service_task_log | 任务操作日志 |
| service_task_assign_rule | 分配规则(轮询/最少任务/技能/手工) |

### 财务结算 — 10张

| 分组 | 表数 | 表名 |
|---|---|---|
| 企业侧 | 5 | finance_company_account/company_account_log/company_bill/company_bill_item/company_payment |
| 供应商侧 | 3 | finance_supplier_account/supplier_bill/supplier_payment |
| 退款+发票 | 2 | finance_refund/finance_invoice |

### 政策匹配 — 2张

| 表名 | 说明 |
|---|---|
| corporate_policy_match_log | 政策匹配日志(出票时自动匹配记录) |

## 3.2 核心数据模型

### C端用户三层模型

```
c_user (平台自然人)
  │  phone_hash 唯一(跨商户)
  │  id_type + id_number_hash 唯一
  │
  ├── c_member (商户会员) ── 1:N (一个自然人可属多个商户)
  │     │  tenant_id 隔离
  │     │  wallet_balance + balance_version (乐观锁)
  │     │  points_balance + points_version (乐观锁)
  │     │  grade_id → c_member_grade
  │     │
  │     ├── c_member_address (收货地址)
  │     ├── c_member_corporate (大客户身份) → corporate_contract
  │     ├── c_member_balance_log (余额变更)
  │     └── c_member_points_log (积分变更)
  │
  └── c_passenger (常用旅客) ── 1:N
        id_number_hash (脱敏三字段)
```

### 大客户四层模型

```
corporate_group (集团主体: "华为")
  │
  └── corporate_contract (签约关系: "华为×CA", "华为×MU")
        │  airline_code + group_id 联合唯一
        │  identity_type: 实名/非实名
        │  pre_commands: 出票前置指令
        │  blackout_dates: 不适用日期
        │
        ├── corporate_policy (自动申报政策)
        │     └── corporate_policy_rule (匹配规则)
        │
        ├── corporate_whitelist_batch (白名单批次)
        │     └── corporate_whitelist_member (成员明细)
        │
        └── c_member_corporate (员工成员身份)
              └── c_member_corporate_apply (申请记录)
```

### 订单三层架构

```
order (主订单)
  │  order_no 全局唯一
  │  status: pending→unpaid→paid→ticketed→completed→cancelled→closed
  │  payment_no / payment_method / payment_time
  │
  ├── order_sales (销售业务订单 — 面向客户)
  │     │  sales_no
  │     │  total_amount / discount_amount / pay_amount
  │     │
  │     ├── order_item_flight (机票子订单)
  │     │     carrier_code / flight_no / departure/arrival
  │     │     cabin_class / cabin_code
  │     │     passenger_name (脱敏) + passenger_id_hash
  │     │     ticket_no / pnr
  │     │
  │     ├── order_item_train (火车票子订单)
  │     │     train_no / from_station / to_station
  │     │     seat_type / seat_no
  │     │
  │     ├── order_item_hotel (酒店子订单)
  │     │     hotel_id / room_type_id
  │     │     check_in_date / check_out_date
  │     │     confirmation_no (确认号)
  │     │
  │     ├── order_item_mall (商城子订单)
  │     │     goods_id / sku_id / quantity
  │     │     delivery_type / express_id
  │     │
  │     ├── order_item_insurance (保险子订单)
  │     │     insurance_id / related_biz_type / related_item_id
  │     │
  │     └── order_item_car (用车子订单)
  │           car_type / pickup_location / dropoff_location
  │
  ├── order_procurement (采购业务订单 — 面向供应商)
  │     │  procure_no
  │     │  supplier_type / supplier_id
  │     │
  │     └── order_procure_item (采购明细)
  │           sales_item_id (关联销售子订单)
  │           procure_price (采购价)
  │
  ├── order_change (退改签记录)
  ├── order_status_log (主订单状态日志)
  ├── order_item_status_log (子订单状态日志)
  ├── payment_log (支付流水)
  └── finance_refund → finance_refund_log (退款流程)
```

## 3.3 脱敏三字段法

适用于: c_user, c_member, c_passenger, pmc_user, tmc_user, mmc_user

| 字段 | 类型 | 用途 | 示例 |
|---|---|---|---|
| phone | varchar(20) | 脱敏明文(展示用) | 138****5678 |
| phone_encrypted | varbinary(512) | AES-256-GCM 密文 | 二进制 |
| phone_hash | char(64) | HMAC-SHA256 查找用 | a1b2c3...f8 |

规则:
- phone_hash 建唯一索引(登录查找)
- phone_hash 建普通索引(列表过滤)
- UNIQUE 索引对 NULL 不生效, 补普通 INDEX
- 明文永不存储, 密钥放 Vault/KMS

## 3.4 索引策略

| 策略 | 说明 |
|---|---|
| **租户隔离** | 所有业务查询首列 tenant_id, 组合索引第一列 |
| **时间范围** | 状态+时间组合索引, 支持管理后台分页查询 |
| **唯一索引含 deleted_at** | 软删除后可重建同名记录 |
| **脱敏hash索引** | phone_hash/id_number_hash 用于登录和查找 |
| **采购关联索引** | order_procure_item.sales_item_id 跨轨关联 |

---

# 四、功能需求列表及注意事项

## 4.1 核心功能模块

### P0 — 必须实现

| 模块 | 功能 | 注意事项 |
|---|---|---|
| **C端用户** | 微信/支付宝登录 | union_id 跨应用关联; 三方绑定解绑需写 user_third_party_login_log |
| **C端用户** | 常用旅客管理 | 新增/编辑需校验 id_number_hash 唯一; 证件号脱敏存储 |
| **C端用户** | 会员等级 | total_earned_points 累计不减少; 定时任务检查升级/降级 |
| **机票** | 航班搜索+报价 | 先查缓存再查航司接口; 报价需实时匹配 corporate_policy |
| **机票** | 下单出票 | 出票前写入前置指令(RMK/SSR/PAT); 乐观锁防重复出票 |
| **机票** | 退改签 | 退改费按 air_gauge 计算; 大客户退改走 corporate_policy |
| **大客户** | 白名单导入 | 按航司模板校验; 批量导入需限制单批上限(建议≤5000) |
| **大客户** | 自动申报 | 出票时实时匹配规则; 匹配失败不影响出票但需记 log |
| **酒店** | 搜索预订 | 确认型酒店需超时自动取消; 拒绝需自动触发退款 |
| **订单** | 状态流转 | 每次变更必须写 order_status_log + order_item_status_log |
| **支付** | 微信/支付宝 | 异步回调必须验签; payment_log 存原始报文; 幂等处理 |
| **支付** | 余额支付 | 乐观锁(c_member.balance_version); 变更必须写 balance_log |
| **财务** | 企业月结 | 账单生成需幂等; 账单明细关联 order_id |
| **财务** | 退款流程 | 至少2级审核; 打款失败可重试; 退款来源需区分自愿/非自愿 |

### P1 — 重要功能

| 模块 | 功能 | 注意事项 |
|---|---|---|
| **火车票** | 搜索+下单 | 12306接口限流; 选座仅高铁支持; 退票费率按时间段 |
| **商城** | 商品SPU+SKU | 规格值组合唯一; 库存扣减需乐观锁; 价格变更不影响已下订单 |
| **商城** | 优惠券 | user_coupon 冗余核心字段(防止改券影响已领实例); 核销幂等 |
| **商城** | 售后 | 售后期限(7天退货/15天换货); 退款走 finance_refund 体系 |
| **保险** | 购买+理赔 | 保险绑定出行子订单(related_biz_type); 一人可买多份 |
| **用车** | 预约+派车 | 预约时间校验; 派车回填车牌号/司机信息 |
| **航变** | 航变处理 | 航变通知入库; 自动创建 service_task; 分配处理人 |
| **积分** | 获取+消耗+过期 | 积分过期需定时任务; 消耗需乐观锁; 兑换比例可配 |

### P2 — 优化功能

| 模块 | 功能 | 注意事项 |
|---|---|---|
| **分销** | TMC/MMC 分销体系 | 佣金计算; 多级分销需防套利 |
| **营销** | 拼团/秒杀/砍价 | 参考jjjshop但暂不建表, 按需扩展 |
| **发票** | 电子发票 | 开票金额需与订单金额对齐; 红冲需关联原发票 |
| **对账** | 自动对账 | 第三方交易号对账; 差异报告 |

## 4.2 关键注意事项

### 并发安全

| 场景 | 风险 | 解决方案 |
|---|---|---|
| 余额扣减 | 并发扣成负数 | 乐观锁: balance_version + WHERE version = ? |
| 积分消耗 | 积分被重复使用 | 乐观锁: points_version + WHERE version = ? |
| 库存扣减 | 超卖 | mall_goods_sku.stock + 乐观锁或 Redis DECR |
| 重复出票 | 同一PNR出两张票 | order_item_flight.status 乐观锁: WHERE status = 'paid' |
| 重复支付 | 同一订单支付两次 | payment_no 唯一 + 幂等校验 |

### 数据一致性

| 场景 | 方案 |
|---|---|
| 余额变更 | c_member.wallet_balance ↔ c_member_balance_log 双写, 定时对账 |
| 积分变更 | c_member.points_balance ↔ c_member_points_log 双写, 定时对账 |
| 订单金额 | order.total_amount = SUM(order_sales.total_amount) |
| 销售采购关联 | order_procure_item.sales_item_id 外联, 无FK由应用保证 |

### 性能优化

| 场景 | 方案 |
|---|---|
| 航班搜索 | Redis 缓存航司+机场+航线基础数据; 搜索结果5分钟缓存 |
| 白名单校验 | corporate_whitelist_member 按 contract_id + id_number_hash 建索引; 热点数据Redis缓存 |
| 订单列表 | 分库分表前置: 先按 tenant_id 隔离, 量级达千万再按月分表 |
| 大客户匹配 | corporate_policy_rule 条件字段建联合索引; 匹配逻辑用内存规则引擎 |

---

# 五、核心功能实现代码示例

## 5.1 会员余额变更(乐观锁)

```php
<?php
/**
 * 会员余额变更 - 乐观锁版本控制
 * 表: c_member (balance_version) + c_member_balance_log
 */

namespace App\Service\Member;

use App\Model\CMember;
use App\Model\CMemberBalanceLog;
use Hyperf\DbConnection\Db;
use Throwable;

class BalanceService
{
    /**
     * 变更会员余额
     *
     * @param int $memberId c_member.id
     * @param string $changeType recharge|payment|refund|withdraw|gift|adjust|freeze|unfreeze
     * @param float $amount 变更金额(正=增加, 负=减少)
     * @param string $bizType 关联业务: order|refund|coupon|manual
     * @param string $bizId 关联业务ID
     * @param string $operatorType member|admin|system
     * @param int $operatorId 操作人ID
     * @param string $remark 备注
     * @return CMemberBalanceLog
     * @throws Throwable
     */
    public function change(
        int $memberId,
        string $changeType,
        float $amount,
        string $bizType = '',
        string $bizId = '0',
        string $operatorType = 'system',
        int $operatorId = 0,
        string $remark = ''
    ): CMemberBalanceLog {
        return Db::transaction(function () use (
            $memberId, $changeType, $amount, $bizType, $bizId,
            $operatorType, $operatorId, $remark
        ) {
            // 1. 悲观读 → 乐观锁: 读取当前余额和版本号
            $member = CMember::where('id', $memberId)->firstOrFail();
            $beforeBalance = (float) $member->wallet_balance;
            $afterBalance = bcadd($beforeBalance, $amount, 2);
            $currentVersion = $member->balance_version;

            // 2. 余额校验
            if ($afterBalance < 0) {
                throw new \RuntimeException('余额不足');
            }

            // 3. 乐观锁更新: WHERE id = ? AND balance_version = ?
            $affected = CMember::where('id', $memberId)
                ->where('balance_version', $currentVersion)
                ->update([
                    'wallet_balance' => $afterBalance,
                    'balance_version' => $currentVersion + 1,
                ]);

            if ($affected === 0) {
                throw new \RuntimeException('余额变更失败(并发冲突), 请重试');
            }

            // 4. 写入变更日志
            $log = CMemberBalanceLog::create([
                'tenant_id'       => $member->tenant_id,
                'member_id'       => $memberId,
                'change_type'     => $changeType,
                'amount'          => $amount,
                'before_balance'  => $beforeBalance,
                'after_balance'   => $afterBalance,
                'version'         => $currentVersion + 1,  // 新版本号
                'biz_type'        => $bizType,
                'biz_id'          => $bizId,
                'operator_type'   => $operatorType,
                'operator_id'     => $operatorId,
                'remark'          => $remark,
                'created_at'      => date('Y-m-d H:i:s'),
            ]);

            return $log;
        });
    }
}
```

## 5.2 订单状态变更(全链路日志)

```php
<?php
/**
 * 订单状态变更 - 双日志(主订单+子订单)
 * 表: order_status_log + order_item_status_log
 */

namespace App\Service\Order;

use App\Model\Order;
use App\Model\OrderStatusLog;
use App\Model\OrderItemStatusLog;
use Hyperf\DbConnection\Db;

class OrderStatusService
{
    /**
     * 变更主订单状态
     */
    public function changeOrderStatus(
        int $orderId,
        int $toStatus,
        string $bizType = '',
        int $bizId = 0,
        string $operatorType = 'system',
        int $operatorId = 0,
        string $operatorName = '',
        string $remark = ''
    ): OrderStatusLog {
        return Db::transaction(function () use (
            $orderId, $toStatus, $bizType, $bizId,
            $operatorType, $operatorId, $operatorName, $remark
        ) {
            $order = Order::where('id', $orderId)->firstOrFail();
            $fromStatus = $order->status;

            // 状态合法性校验(状态机)
            if (!$this->isTransitionAllowed($fromStatus, $toStatus)) {
                throw new \RuntimeException(
                    "订单状态流转非法: {$fromStatus} -> {$toStatus}"
                );
            }

            // 更新订单状态
            $order->status = $toStatus;
            $order->save();

            // 写入日志
            return OrderStatusLog::create([
                'order_id'      => $orderId,
                'tenant_id'     => $order->tenant_id,
                'from_status'   => $fromStatus,
                'to_status'     => $toStatus,
                'biz_type'      => $bizType,
                'biz_id'        => $bizId,
                'operator_type' => $operatorType,
                'operator_id'   => $operatorId,
                'operator_name' => $operatorName,
                'remark'        => $remark,
                'created_at'    => date('Y-m-d H:i:s'),
            ]);
        });
    }

    /**
     * 变更子订单状态
     */
    public function changeItemStatus(
        string $itemType,  // flight/train/hotel/mall/insurance/car
        int $itemId,
        int $toStatus,
        string $triggerType = '',
        int $triggerId = 0,
        string $operatorType = 'system',
        int $operatorId = 0,
        string $operatorName = '',
        string $remark = ''
    ): OrderItemStatusLog {
        // 根据item_type获取对应模型
        $modelClass = $this->getItemModelClass($itemType);
        $item = $modelClass::where('id', $itemId)->firstOrFail();
        $fromStatus = $item->status;

        $item->status = $toStatus;
        $item->save();

        return OrderItemStatusLog::create([
            'item_type'     => $itemType,
            'item_id'       => $itemId,
            'order_id'      => $item->order_id,
            'sales_id'      => $item->sales_id,
            'tenant_id'     => $item->tenant_id,
            'from_status'   => $fromStatus,
            'to_status'     => $toStatus,
            'trigger_type'  => $triggerType,
            'trigger_id'    => $triggerId,
            'operator_type' => $operatorType,
            'operator_id'   => $operatorId,
            'operator_name' => $operatorName,
            'remark'        => $remark,
            'created_at'    => date('Y-m-d H:i:s'),
        ]);
    }

    /**
     * 订单状态机: 合法流转定义
     *
     * order.status:
     *   1=pending  2=unpaid  3=paid  4=ticketed
     *   5=completed  6=cancelled  7=closed
     */
    private function isTransitionAllowed(int $from, int $to): bool
    {
        $transitions = [
            1 => [2],          // pending → unpaid
            2 => [3, 6],       // unpaid → paid / cancelled
            3 => [4, 6],       // paid → ticketed / cancelled
            4 => [5, 6],       // ticketed → completed / cancelled
            5 => [7],          // completed → closed
            6 => [],           // cancelled (终态)
            7 => [],           // closed (终态)
        ];

        return in_array($to, $transitions[$from] ?? []);
    }

    private function getItemModelClass(string $itemType): string
    {
        return match ($itemType) {
            'flight'    => \App\Model\OrderItemFlight::class,
            'train'     => \App\Model\OrderItemTrain::class,
            'hotel'     => \App\Model\OrderItemHotel::class,
            'mall'      => \App\Model\OrderItemMall::class,
            'insurance' => \App\Model\OrderItemInsurance::class,
            'car'       => \App\Model\OrderItemCar::class,
            default     => throw new \RuntimeException("未知子订单类型: {$itemType}"),
        };
    }
}
```

## 5.3 大客户白名单校验+自动申报

```php
<?php
/**
 * 大客户白名单校验 + 自动申报匹配
 * 表: corporate_whitelist_member / corporate_policy_rule / corporate_policy_match_log
 */

namespace App\Service\Corporate;

use App\Model\CorporateContract;
use App\Model\CorporateWhitelistMember;
use App\Model\CorporatePolicyRule;
use App\Model\CorporatePolicyMatchLog;
use Hyperf\Di\Annotation\Inject;

class CorporatePolicyService
{
    /**
     * 出票前: 白名单校验(实名制集团)
     *
     * @param int $contractId corporate_contract.id
     * @param string $idType 证件类型
     * @param string $idNumberHash 证件号hash(脱敏三字段)
     * @return bool 是否在白名单中
     */
    public function verifyWhitelist(
        int $contractId,
        string $idType,
        string $idNumberHash
    ): bool {
        $contract = CorporateContract::findOrFail($contractId);

        // 非实名制: 跳过白名单, 仅校验年龄+黑名单日期
        if ($contract->identity_type !== 'real_name') {
            return $this->checkNonRealNameRules($contract);
        }

        // 实名制: 在白名单中查找
        return CorporateWhitelistMember::where('contract_id', $contractId)
            ->where('id_type', $idType)
            ->where('id_number_hash', $idNumberHash)
            ->where('status', 1)  // 1=有效
            ->exists();
    }

    /**
     * 出票时: 自动匹配大客户政策
     *
     * @param int $contractId 签约ID
     * @param string $airlineCode 航司二字码
     * @param string $cabinCode 舱位代码
     * @param string $depCode 出发城市
     * @param string $arrCode 到达城市
     * @param string $flightDate 航班日期 Y-m-d
     * @param int $advanceDays 提前购票天数
     * @return CorporatePolicyMatchLog|null 匹配到的政策(未匹配返回null)
     */
    public function matchPolicy(
        int $contractId,
        string $airlineCode,
        string $cabinCode,
        string $depCode,
        string $arrCode,
        string $flightDate,
        int $advanceDays
    ): ?CorporatePolicyMatchLog {
        $contract = CorporateContract::findOrFail($contractId);
        $policies = $contract->policies()->where('status', 1)->get();

        foreach ($policies as $policy) {
            // 查找匹配规则
            $matchedRule = CorporatePolicyRule::where('policy_id', $policy->id)
                ->where('status', 1)
                ->where(function ($q) use ($airlineCode) {
                    $q->whereNull('airline_code')
                      ->orWhere('airline_code', '')
                      ->orWhere('airline_code', $airlineCode);
                })
                ->where(function ($q) use ($cabinCode) {
                    $q->whereNull('cabin_code')
                      ->orWhere('cabin_code', '')
                      ->orWhere('cabin_code', $cabinCode);
                })
                ->where(function ($q) use ($depCode) {
                    $q->whereNull('dep_code')
                      ->orWhere('dep_code', '')
                      ->orWhere('dep_code', $depCode);
                })
                ->where(function ($q) use ($arrCode) {
                    $q->whereNull('arr_code')
                      ->orWhere('arr_code', '')
                      ->orWhere('arr_code', $arrCode);
                })
                ->where(function ($q) use ($flightDate) {
                    // 淡旺季日期范围
                    $q->whereNull('season_start')
                      ->orWhere(function ($q2) use ($flightDate) {
                          $q2->where('season_start', '<=', $flightDate)
                             ->where('season_end', '>=', $flightDate);
                      });
                })
                ->where(function ($q) use ($advanceDays) {
                    $q->whereNull('min_advance_days')
                      ->orWhere('min_advance_days', '<=', $advanceDays);
                })
                ->where(function ($q) use ($advanceDays) {
                    $q->whereNull('max_advance_days')
                      ->orWhere('max_advance_days', '>=', $advanceDays);
                })
                ->first();

            if ($matchedRule) {
                // 记录匹配日志
                $log = CorporatePolicyMatchLog::create([
                    'contract_id'   => $contractId,
                    'group_id'      => $contract->group_id,
                    'policy_id'     => $policy->id,
                    'rule_id'       => $matchedRule->id,
                    'match_result'  => 'matched',
                    'match_detail'  => json_encode([
                        'airline_code' => $airlineCode,
                        'cabin_code'   => $cabinCode,
                        'dep_code'     => $depCode,
                        'arr_code'     => $arrCode,
                        'flight_date'  => $flightDate,
                        'advance_days' => $advanceDays,
                    ]),
                    'created_at'    => date('Y-m-d H:i:s'),
                ]);

                return $log;
            }
        }

        // 未匹配: 也记日志(用于分析漏配原因)
        CorporatePolicyMatchLog::create([
            'contract_id'   => $contractId,
            'group_id'      => $contract->group_id,
            'policy_id'     => 0,
            'rule_id'       => 0,
            'match_result'  => 'not_matched',
            'match_detail'  => json_encode([
                'airline_code' => $airlineCode,
                'cabin_code'   => $cabinCode,
                'dep_code'     => $depCode,
                'arr_code'     => $arrCode,
            ]),
            'created_at'    => date('Y-m-d H:i:s'),
        ]);

        return null;
    }

    /**
     * 非实名制规则校验(年龄+黑名单日期)
     */
    private function checkNonRealNameRules(CorporateContract $contract): bool
    {
        // 黑名单日期校验
        if ($contract->blackout_dates) {
            $blackout = json_decode($contract->blackout_dates, true) ?? [];
            $today = date('Y-m-d');
            if (in_array($today, $blackout)) {
                return false;
            }
        }

        // 年龄限制校验(由调用方传入年龄)
        // 这里仅返回基础通过, 年龄校验在业务层处理
        return true;
    }
}
```

## 5.4 脱敏三字段加解密

```php
<?php
/**
 * 脱敏三字段法: 明文(脱敏) + 密文(AES-256-GCM) + 哈希(HMAC-SHA256)
 */

namespace App\Service\Security;

class SensitiveDataService
{
    // AES-256-GCM 密钥(从 Vault/KMS 获取, 严禁硬编码)
    private function getEncryptionKey(): string
    {
        return env('SENSITIVE_DATA_KEY');
    }

    // HMAC-SHA256 密钥(从 Vault/KMS 获取)
    private function getHashKey(): string
    {
        return env('SENSITIVE_HASH_KEY');
    }

    /**
     * 手机号加密(三字段)
     *
     * @param string $plainPhone 明文手机号: 13812345678
     * @return array{phone: string, phone_encrypted: string, phone_hash: string}
     */
    public function encryptPhone(string $plainPhone): array
    {
        return [
            'phone'           => $this->maskPhone($plainPhone),   // 138****5678
            'phone_encrypted' => $this->aesEncrypt($plainPhone),  // AES-256-GCM 密文
            'phone_hash'      => $this->hmacHash($plainPhone),    // HMAC-SHA256
        ];
    }

    /**
     * 证件号加密(三字段)
     */
    public function encryptIdNumber(string $plainIdNumber): array
    {
        return [
            'id_number'           => $this->maskIdNumber($plainIdNumber),
            'id_number_encrypted' => $this->aesEncrypt($plainIdNumber),
            'id_number_hash'      => $this->hmacHash($plainIdNumber),
        ];
    }

    /**
     * AES-256-GCM 加密
     */
    private function aesEncrypt(string $plaintext): string
    {
        $key = hex2bin($this->getEncryptionKey());
        $iv = random_bytes(openssl_cipher_iv_length('aes-256-gcm'));
        $tag = '';

        $ciphertext = openssl_encrypt(
            $plaintext, 'aes-256-gcm', $key,
            OPENSSL_RAW_DATA, $iv, $tag
        );

        // 存储: iv(12字节) + tag(16字节) + 密文
        return base64_encode($iv . $tag . $ciphertext);
    }

    /**
     * AES-256-GCM 解密
     */
    public function aesDecrypt(string $encoded): string
    {
        $key = hex2bin($this->getEncryptionKey());
        $data = base64_decode($encoded);

        $ivLen = openssl_cipher_iv_length('aes-256-gcm');
        $iv = substr($data, 0, $ivLen);
        $tag = substr($data, $ivLen, 16);
        $ciphertext = substr($data, $ivLen + 16);

        return openssl_decrypt(
            $ciphertext, 'aes-256-gcm', $key,
            OPENSSL_RAW_DATA, $iv, $tag
        );
    }

    /**
     * HMAC-SHA256 哈希(用于查找)
     */
    private function hmacHash(string $plaintext): string
    {
        return hash_hmac('sha256', $plaintext, $this->getHashKey());
    }

    /**
     * 手机号脱敏: 138****5678
     */
    private function maskPhone(string $phone): string
    {
        return substr($phone, 0, 3) . '****' . substr($phone, -4);
    }

    /**
     * 证件号脱敏: 3301********1234
     */
    private function maskIdNumber(string $idNumber): string
    {
        $len = strlen($idNumber);
        return substr($idNumber, 0, 4) . str_repeat('*', $len - 8) . substr($idNumber, -4);
    }

    /**
     * 按手机号哈希查找用户
     */
    public function findUserByPhone(string $plainPhone): ?object
    {
        $hash = $this->hmacHash($plainPhone);
        return \App\Model\CUser::where('phone_hash', $hash)->first();
    }
}
```

## 5.5 积分过期定时任务

```php
<?php
/**
 * 积分过期定时任务
 * 表: c_member_points_log.expire_at
 * 运行: 每天凌晨 02:00
 */

namespace App\Job;

use App\Model\CMemberPointsLog;
use App\Model\CMember;
use Hyperf\DbConnection\Db;
use Hyperf\Cron\Annotation\Cron;

#[Cron(name: "PointsExpireJob", rule: "0 2 * * *", memo: "积分过期处理")]
class PointsExpireJob
{
    public function handle(): void
    {
        $now = date('Y-m-d H:i:s');

        // 查找已过期但未处理的积分记录
        $expiredLogs = CMemberPointsLog::where('expire_at', '<=', $now)
            ->where('change_type', 'earn')
            ->where('after_points', '>', 0)  // 还有余额
            ->get();

        foreach ($expiredLogs as $log) {
            Db::transaction(function () use ($log) {
                $member = CMember::where('id', $log->member_id)
                    ->firstOrFail();

                // 计算过期积分数(该笔剩余未消耗的积分)
                // 简化: 按FIFO消耗, 最老的积分先过期
                $expirePoints = $log->points;  // 实际需按FIFO计算剩余

                // 乐观锁扣减
                $affected = CMember::where('id', $member->id)
                    ->where('points_version', $member->points_version)
                    ->update([
                        'points_balance' => max(0, $member->points_balance - $expirePoints),
                        'points_version' => $member->points_version + 1,
                    ]);

                if ($affected === 0) {
                    return; // 并发冲突, 跳过下次重试
                }

                // 写入过期日志
                CMemberPointsLog::create([
                    'tenant_id'     => $member->tenant_id,
                    'member_id'     => $member->id,
                    'change_type'   => 'expire',
                    'points'        => -$expirePoints,
                    'before_points' => $member->points_balance,
                    'after_points'  => max(0, $member->points_balance - $expirePoints),
                    'version'       => $member->points_version + 1,
                    'biz_type'      => 'expire',
                    'biz_id'        => (string) $log->id,
                    'expire_at'     => null,  // 过期记录本身不再有过期时间
                    'operator_type' => 'cron',
                    'remark'        => "积分过期: 原获取记录ID={$log->id}",
                    'created_at'    => date('Y-m-d H:i:s'),
                ]);

                // 标记原记录已过期
                $log->after_points = 0;
                $log->save();
            });
        }
    }
}
```

## 5.6 优惠券核销(防重复)

```php
<?php
/**
 * 优惠券核销 - 幂等处理
 * 表: mall_user_coupon
 */

namespace App\Service\Mall;

use App\Model\MallUserCoupon;
use App\Model\Order;
use Hyperf\DbConnection\Db;
use Throwable;

class CouponService
{
    /**
     * 核销优惠券
     *
     * @param int $couponId mall_user_coupon.id
     * @param int $orderId 关联订单ID
     * @return MallUserCoupon
     * @throws Throwable
     */
    public function consume(int $couponId, int $orderId): MallUserCoupon
    {
        return Db::transaction(function () use ($couponId, $orderId) {
            // 乐观锁: WHERE status = 1 (未使用)
            $coupon = MallUserCoupon::where('id', $couponId)
                ->where('status', 1)  // 1=未使用
                ->firstOrFail();

            // 校验有效期
            if ($coupon->expire_at && $coupon->expire_at < date('Y-m-d H:i:s')) {
                throw new \RuntimeException('优惠券已过期');
            }

            // 校验最低消费
            $order = Order::findOrFail($orderId);
            if ($coupon->min_amount > 0 && $order->total_amount < $coupon->min_amount) {
                throw new \RuntimeException('订单金额不满足优惠券最低消费');
            }

            // 核销: status → 2(已使用)
            $affected = MallUserCoupon::where('id', $couponId)
                ->where('status', 1)
                ->update([
                    'status'       => 2,
                    'used_at'      => date('Y-m-d H:i:s'),
                    'order_id'     => $orderId,
                ]);

            if ($affected === 0) {
                throw new \RuntimeException('优惠券核销失败(可能已被使用)');
            }

            return $coupon->refresh();
        });
    }

    /**
     * 优惠券退回(订单取消时)
     */
    public function rollback(int $couponId): MallUserCoupon
    {
        return Db::transaction(function () use ($couponId) {
            $coupon = MallUserCoupon::where('id', $couponId)
                ->where('status', 2)  // 已使用
                ->firstOrFail();

            // 检查是否还在退回期内
            if ($coupon->expire_at && $coupon->expire_at < date('Y-m-d H:i:s')) {
                // 已过期, 不退回, 改为已过期状态
                $coupon->status = 3; // 3=已过期
                $coupon->save();
                return $coupon;
            }

            $coupon->status = 1;  // 恢复未使用
            $coupon->used_at = null;
            $coupon->order_id = null;
            $coupon->save();

            return $coupon;
        });
    }
}
```

## 5.7 出票前置指令拼接

```php
<?php
/**
 * 出票前置指令拼接
 * 表: corporate_contract.pre_commands
 */

namespace App\Service\Corporate;

use App\Model\CorporateContract;

class PreCommandService
{
    /**
     * 生成出票前置指令
     *
     * @param int $contractId 签约ID
     * @param array $passengerInfo 旅客信息[name, id_type, id_number]
     * @return array 指令列表[rmk, ssr, pat, qte]
     */
    public function buildCommands(int $contractId, array $passengerInfo): array
    {
        $contract = CorporateContract::findOrFail($contractId);

        if (empty($contract->pre_commands)) {
            return [];
        }

        $template = json_decode($contract->pre_commands, true) ?? [];
        $commands = [];

        foreach ($template as $cmd) {
            $content = $this->renderTemplate($cmd['content'], [
                'corporate_code' => $contract->corporate_code,
                'agent_no'       => $contract->agent_no ?? '',
                'passenger_name' => $passengerInfo['name'] ?? '',
                'id_type'        => $passengerInfo['id_type'] ?? '',
                'id_number'      => $passengerInfo['id_number'] ?? '',
                'fare_basis'     => $cmd['fare_basis'] ?? '',
            ]);

            $commands[] = [
                'type'    => $cmd['type'],    // RMK/SSR/PAT/QTE
                'content' => $content,
                'order'   => $cmd['order'] ?? 0,
            ];
        }

        // 按order排序
        usort($commands, fn($a, $b) => $a['order'] <=> $b['order']);

        return $commands;
    }

    /**
     * 模板变量替换
     * 例: "RMK HKG{{corporate_code}}" → "RMK HKGCA001"
     */
    private function renderTemplate(string $template, array $vars): string
    {
        foreach ($vars as $key => $value) {
            $template = str_replace("{{{$key}}}", $value, $template);
        }
        return $template;
    }
}
```

---

## 附录: v9 复核问题清单

### 必须修复 (BUG)

| # | 问题 | 影响 | 修复方案 |
|---|---|---|---|
| BUG-1 | 缺少6张业务流转日志表 | 无法追踪订单/支付/退款状态变更,无法审计 | 新建6张log表(见v9_fix.sql) |
| BUG-2 | c_member 余额/积分无版本控制 | 并发扣款导致余额为负,积分欺诈 | 加 balance_version/points_version 字段 |
| BUG-3 | corporate_group/contract 唯一索引缺deleted_at | 软删除后无法重建同名记录 | 重建唯一索引含deleted_at |
| BUG-4 | mall_favorite 唯一索引缺tenant_id | 跨商户收藏冲突 | 重建唯一索引含tenant_id |
| BUG-5 | mall_cart 无唯一索引 | 同SKU重复加购 | 新增 uk_tenant_user_sku |
| BUG-6 | hotel_info/mall_goods 缺deleted_at | 无法软删除 | ADD COLUMN deleted_at |

### 改进建议

| # | 建议 | 优先级 |
|---|---|---|
| IMP-1 | 统一timestamp为datetime(v6原始表) | P1 |
| IMP-2 | 新增会员等级表 c_member_grade | P1 |
| IMP-3 | 新增 c_member.total_earned_points 累计积分(等级判定) | P1 |
| IMP-4 | 支付回调增加 payment_log.callback_raw 存档 | P0(已含) |
| IMP-5 | 积分过期定时任务(基于 expire_at) | P1 |

修复SQL: `assets/hx_b2b2c_v9_fix.sql`
