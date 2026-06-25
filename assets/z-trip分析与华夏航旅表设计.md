# Z-TRIP 项目架构分析与华夏航旅数据表借鉴设计

## 一、Z-TRIP 项目架构总结

### 1.1 产品定位

Z-TRIP 是一个 **TMC(Travel Management Company) 商旅管理后台**，服务于企业差旅场景。核心角色：

| 角色 | 说明 |
|------|------|
| TMC | 商旅管理公司(如华夏航服)，运营系统、处理任务、结算 |
| 企业客户 | 差旅消费方(如华为)，签署大客户协议、月结付款 |
| 出行人 | 企业员工，实际消费机票/酒店/火车 |
| 供应商 | 航司/OTA/12306/酒店，提供产品与出票 |

### 1.2 业务模块矩阵

```
┌──────────────────────────────────────────────────────────────┐
│                     Z-TRIP TMC后台                           │
├──────────┬──────────┬──────────┬──────────┬─────────────────┤
│ 客服中心  │ 订单中心  │ 财务中心  │ 企业管理  │ 系统管理       │
├──────────┼──────────┼──────────┼──────────┼─────────────────┤
│TMC服务台  │机票订单   │企业账单   │企业信息   │用户/角色/权限  │
│手工维护   │酒店订单   │账户设置   │大客户协议 │密码修改        │
│代客下单   │火车订单   │来款管理   │白名单管理 │                │
│          │保险订单   │供应商结算  │          │                │
│          │用车订单   │          │          │                │
└──────────┴──────────┴──────────┴──────────┴─────────────────┘
```

### 1.3 Z-TRIP 12种任务类型

| 任务类型 | 说明 | 对应业务 |
|----------|------|----------|
| domestic_flight | 国内机票 | 出票/退改签 |
| international_flight | 国际机票 | 出票/退改签 |
| hotel | 酒店 | 预订/退改 |
| hotel_night_audit | 酒店夜审 | NoShow确认 |
| train | 火车票 | 出票/退改 |
| insurance | 保险 | 投保/退保 |
| car | 用车 | 预订/取消 |
| eagle_eye | 鹰眼监控 | 航变/价格监控 |
| demand | 需求单 | 客户需求响应 |
| travel_customize | 差旅定制 | 定制行程 |
| corporate_agreement | 大客户协议 | 协议签署/变更 |
| corporate_direct | 大客户直连 | 直连对接 |

### 1.4 核心业务流转

```
出行人下单 → TMC服务台生成任务 → 客服领取/分配 → 处理(出票/预订)
                                              ↓
                                    完成/关闭任务 → 生成账单
                                              ↓
                               企业确认账单 → 付款(来款) → 清账
                                              ↓
                                    开票(发票) → 寄送 → 确认
```

### 1.5 财务结算双轨

```
销售侧(企业)                        采购侧(供应商)
─────────                           ──────────
企业结算账户 ←── 预存/授信            供应商账户 ←── 预存/授信
    ↓                                    ↓
企业账单 ←── 月/周/实时结算            供应商账单 ←── 月结对账
    ↓                                    ↓
企业来款 ←── 银行转账/支付宝           供应商付款 ←── 付款审批流
    ↓                                    ↓
发票 ←── 增值税普通/专用/电子          (供应商开票给我方)
```

---

## 二、Z-TRIP 业务表字段分析

### 2.1 酒店订单关键字段 (z-trip hotel_order)

| 字段维度 | 具体字段 | 借鉴要点 |
|----------|----------|----------|
| 酒店信息 | hotel_name/city_name/district/address | 需hotel_info基础表 |
| 房型 | room_type_name/bed_type/breakfast | 需hotel_room_type基础表 |
| 入住 | check_in_date/check_out_date/room_count/guest_count | 已有,需补充guest_id_type/guest_id_no |
| 价格 | total_price/avg_price_per_night | 已有,需补充cost_price |
| 供应商 | supplier_order_no | 需补充supplier_type/supplier_hotel_id/supplier_room_id |
| 特殊要求 | special_request | 需补充 |

### 2.2 火车票订单关键字段 (z-trip train_order)

| 字段维度 | 具体字段 | 借鉴要点 |
|----------|----------|----------|
| 列车 | train_no/train_type/dep_station/arr_station | 需train_station基础表,补充train_type |
| 座位 | seat_type/seat_no/carriage_no | 需train_seat_type基础表 |
| 票种 | is_student | 需补充学生票标识 |
| 供应商 | supplier_order_no | 需补充(12306订单号) |
| 退改 | cancel_rule | 需补充退改规则快照 |

### 2.3 保险订单关键字段 (z-trip insurance_order)

| 字段维度 | 具体字段 | 借鉴要点 |
|----------|----------|----------|
| 产品 | product_code/product_name/premium/coverage | 需insurance_product基础表 |
| 被保人 | insured_name/insured_id_type/insured_id_no | 需独立order_item_insurance子订单 |
| 保单 | policy_no/effective_date/expire_date | 需policy_no回填机制 |
| 关联 | related_order_type/related_order_id | 需与机票/火车票绑定 |

### 2.4 用车订单关键字段 (z-trip car_order)

| 字段维度 | 具体字段 | 借鉴要点 |
|----------|----------|----------|
| 服务 | car_type(接送机/市内/日租) | 需order_item_car子订单 |
| 车辆 | car_model/car_brand/plate_no | 派车后回填 |
| 行程 | pickup_address/pickup_time/dropoff_address | 已有 |
| 司机 | driver_name/driver_phone | 派车后回填 |

---

## 三、华夏航旅 vs Z-TRIP 差异对比

| 维度 | Z-TRIP | 华夏航旅 | 设计决策 |
|------|--------|----------|----------|
| 租户模式 | 单TMC | B2B2C(PMC/TMC/MMC三端) | 所有表带tenant_id |
| 用户模型 | TMC员工+企业员工 | C端三层(c_user/c_member/c_passenger) | 保持现有模型 |
| 订单架构 | 按业务分表(hotel_order/train_order等) | 三层架构(order/sales+procurement/item_*) | 不改架构,增强item表 |
| 财务模型 | 企业账单+供应商结算 | 未建 | 双轨并行: 销售侧(企业)+采购侧(供应商) |
| 任务体系 | TMC服务台12种任务 | 未建 | 建service_task+service_task_log |
| 大客户 | 企业签约+白名单 | 已建(4层模型) | 保持,与财务账户打通 |

---

## 四、新增表设计说明 (22张表)

### 4.1 酒店基础数据 (3张)

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| hotel_brand | 酒店品牌 | brand_code, brand_name, level(1-4档) |
| hotel_info | 酒店信息 | hotel_code, city_code, star_rate, 经纬度, 设施标签JSON |
| hotel_room_type | 酒店房型 | hotel_id, bed_type, breakfast, max_occupancy, 取消政策 |

设计要点：
- hotel_info.city_code 复用 air_region 的城市编码体系，实现航旅+酒店城市联动
- hotel_room_type 取消政策快照，避免基础数据变动影响已下单的取消规则
- 支持4种供应商对接(携程/美团/飞猪/直连)，用supplier_type+supplier_hotel_id双字段

### 4.2 火车基础数据 (3张)

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| train_station | 火车站点 | station_code, city_code, 拼音/简拼, 经纬度 |
| train_type | 列车类型 | type_code(G/D/C/Z/T/K), 通用退改规则 |
| train_seat_type | 座席类型 | seat_code, 退票费率(24h/48h/8d三档) |

设计要点：
- train_station.city_code 复用 air_region，空铁联运场景城市统一
- train_seat_type 按24h/48h/8d三档存储退票费率，出票时快照到子订单
- train_type 存通用退改规则摘要，具体以12306实时查询为准

### 4.3 保险体系 (2张)

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| insurance_product | 保险产品 | insurance_type(航空/旅行/取消/延误), 保费/保额, 保障条款JSON |
| order_item_insurance | 保险子订单 | 被保人快照, 保单号(生效后回填), 关联业务类型+item_id |

设计要点：
- 一个出行人可绑定多份保险(如航空意外+延误险)，每份保险是独立子订单
- related_biz_type + related_item_id 实现与机票/火车票的强绑定
- policy_no 在保险公司承保后回填，之前状态为"待生效"
- product_snapshot JSON快照产品信息，防止产品变更影响历史保单

### 4.4 用车体系 (1张)

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| order_item_car | 用车子订单 | car_type(5种), 车型4档, 上下车地址/时间, 司机/车牌(派车后回填) |

设计要点：
- 5种用车类型: 接机/送机/市内接送/日租/时租
- 4种车型: 经济/舒适/商务/豪华
- 派车前driver_name/plate_no为空，派车后回填
- flight_no 关联航班号，支持航班延误自动延迟接机

### 4.5 TMC任务体系 (3张)

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| service_task | 服务任务主表 | 12种task_type, 11种task_status, 4级优先级, 分配人 |
| service_task_log | 任务操作日志 | 14种action, 状态变更记录, 操作人信息 |
| service_task_assign_rule | 任务分配规则 | 轮询/最少任务/技能匹配/手工4种策略 |

设计要点：
- 任务编号格式: TK+年月日时分秒+序号，可溯源
- 任务来源: SYSTEM(系统自动创建,如下单触发) / MANUAL(手工创建)
- 11种状态完整覆盖: 待处理→处理中→挂起→等待出票→等待提醒→退票审核→退票复核→改签出票→改签审核→已完成→已关闭
- 分配规则支持4种策略，按task_type配置不同策略

### 4.6 财务结算体系 (9张)

#### 销售侧(企业) - 4张

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| finance_company_account | 企业结算账户 | 预存/信用/混合三种模式, 授信额度+余额双维护 |
| finance_company_account_log | 企业账户流水 | 7种变动类型, 变动前后余额, 关联业务 |
| finance_company_bill | 企业账单 | 8种状态(DRAFT→PAID), 结算期间, 逾期管理 |
| finance_company_bill_item | 企业账单明细 | 按订单拆分明细, 销售额+服务费+保险费-退款=应结额 |

#### 采购侧(供应商) - 3张

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| finance_supplier_account | 供应商账户 | 10种供应商类型, 预存/信用双模式 |
| finance_supplier_bill | 供应商账单 | 7种状态, 应付/已付/未付, 到期管理 |
| finance_supplier_payment | 供应商付款 | 4种状态(待审批→已付款), 审批流 |

#### 通用 - 2张

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| finance_refund | 退款单 | 全业务线通用, 自愿/非自愿区分, 审核流 |
| finance_invoice | 发票 | 4种发票类型, 开票→寄送→确认, 增值税信息 |

设计要点：
- 企业账户支持预存(先充后用)和信用(先用后结)双模式，可混合
- 企业账单8态流转: 草稿→待确认→已确认→已发送→逾期→部分支付→已支付 / 已作废
- 供应商类型枚举: airline_b2b/airline_b2t/ota_ctrip/ota_qunar/ota_meituan/ota_fligy/railway_12306/hotel_supplier/mall_supplier/insurance_supplier
- 退款单统一管理全业务线退款，区分自愿(扣手续费)/非自愿(航变全额退)
- 发票支持增值税普通/专用/电子发票，抬头+税号+税率为必填

---

## 五、现有表增强 (3张)

### 5.1 order_item_hotel (+8字段)

| 新增字段 | 类型 | 说明 |
|----------|------|------|
| special_request | varchar(500) | 特殊要求(无烟房/高楼层/加床) |
| guest_id_type | tinyint | 入住人证件类型 |
| guest_id_no | varchar(30) | 入住人证件号(脱敏快照) |
| supplier_type | varchar(30) | 供应商类型(携程/美团/飞猪/直连) |
| supplier_hotel_id | varchar(50) | 供应商侧酒店ID |
| supplier_room_id | varchar(50) | 供应商侧房型ID |
| supplier_order_no | varchar(64) | 供应商订单号(确认后回填) |
| insurance_fee | decimal(12,2) | 保险费 |
| cost_price | decimal(12,2) | 采购成本单价 |

### 5.2 order_item_train (+5字段)

| 新增字段 | 类型 | 说明 |
|----------|------|------|
| train_type | varchar(10) | 列车类型(G/D/C/Z/T/K) |
| is_student | tinyint | 1=学生票,2=成人票 |
| supplier_order_no | varchar(64) | 12306订单号 |
| insurance_fee | decimal(12,2) | 保险费 |
| cost_price | decimal(12,2) | 采购成本单价 |
| cancel_rule | varchar(200) | 退改规则摘要(快照) |

### 5.3 order (+1字段)

| 新增字段 | 类型 | 说明 |
|----------|------|------|
| task_id | bigint UNSIGNED | 关联任务ID(代客下单时关联) |

---

## 六、表关系全景

### 6.1 酒店业务链

```
hotel_brand ──1:N── hotel_info ──1:N── hotel_room_type
                                  │
                     order_item_hotel (引用 hotel_info.id / hotel_room_type.id)
                                  │
                     insurance_product ←── order_item_insurance (关联酒店item)
```

### 6.2 火车业务链

```
train_station ──────── train_type ──────── train_seat_type
     │                                          │
     └── order_item_train (引用departure/arrival station)
                                                │
                     insurance_product ←── order_item_insurance (关联火车item)
```

### 6.3 任务流转链

```
service_task ──1:N── service_task_log
      │
      ├── service_task_assign_rule (按type配置分配策略)
      │
      └── order.task_id (关联主订单)
```

### 6.4 财务结算链

```
[销售侧]
finance_company_account ──1:N── finance_company_account_log
        │
        ├──1:N── finance_company_bill ──1:N── finance_company_bill_item
        │                    │
        │                    └──1:N── finance_invoice
        │
        └──1:N── finance_company_payment (来款)

[采购侧]
finance_supplier_account ──1:N── finance_supplier_bill
        │                          │
        │                          └──1:N── finance_supplier_payment
        │
        └── (与供应商账单关联)

[通用]
finance_refund (关联order + item)
finance_invoice (关联company_bill / supplier_bill)
```

---

## 七、完整表清单汇总

### v8 原有 84 张表 + 新增 22 张 = 106 张

| 分组 | 原有 | 新增 | 合计 |
|------|------|------|------|
| PMC端 | 12 | 0 | 12 |
| TMC端 | 15 | 0 | 15 |
| MMC端 | 14 | 0 | 14 |
| 共享基础 | 7 | 0 | 7 |
| C端用户 | 9 | 0 | 9 |
| 白名单 | 3 | 0 | 3 |
| 订单体系 | 9 | 2(保险+用车item) | 11 |
| 航空基础 | 13 | 0 | 13 |
| 政策匹配 | 2 | 0 | 2 |
| 商城 | 21 | 0 | 21 |
| **酒店基础** | 0 | **3** | **3** |
| **火车基础** | 0 | **3** | **3** |
| **保险** | 0 | **2** | **2** |
| **用车** | 0 | **1** | **1** |
| **任务体系** | 0 | **3** | **3** |
| **财务结算** | 0 | **9** | **9** |
| **合计** | **105** | **22** | **127** |

注: 原v8有84张表, 加上商城21张=105张, 再增22张=127张
