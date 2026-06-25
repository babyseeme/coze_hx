# Z-TRIP 后台管理系统 - 业务表字段信息

**产品名称：** Z-TRIP 商旅后台管理系统  
**公司名称：** 温州华夏航空服务有限公司  
**文档版本：** V1.0  
**编写日期：** 2026-03-23  

---

## 目录

1. [用户信息表](#1-用户信息表)
2. [任务表](#2-任务表)
3. [订单表](#3-订单表)
4. [企业账户表](#4-企业账户表)
5. [企业账单表](#5-企业账单表)
6. [企业来款表](#6-企业来款表)
7. [供应商账户表](#7-供应商账户表)
8. [供应商账单表](#8-供应商账单表)
9. [供应商付款表](#9-供应商付款表)
10. [发票表](#10-发票表)
11. [退款表](#11-退款表)
12. [枚举值汇总](#12-枚举值汇总)

---

## 1. 用户信息表

### 1.1 用户基础信息表 (sys_user / platform_user)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值                |
|--------|----------|------|------|--------------------|
| user_id | BIGINT | 是 | 用户ID | 10001              |
| user_name | VARCHAR(50) | 是 | 姓名 | 雄                  |
| mobile | VARCHAR(20) | 是 | 手机号码 | 199xxxx5739        |
| email | VARCHAR(100) | 否 | 邮箱 | -                  |
| employee_code | VARCHAR(50) | 否 | 员工编码 | -                  |
| pinyin | VARCHAR(100) | 否 | 姓名拼音 | gaoxiong           |
| password | VARCHAR(255) | 是 | 密码（加密存储） | -                  |
| status | TINYINT | 是 | 状态：0-禁用，1-启用 | 1                  |
| create_time | DATETIME | 是 | 创建时间 | 2026-01-01 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:00:00 |
| last_login_time | DATETIME | 否 | 最后登录时间 | 2026-03-23 08:30:00 |

### 1.2 密码修改表单

| 字段名 | 字段类型 | 必填 | 验证规则 | 说明 |
|--------|----------|------|----------|------|
| old_password | VARCHAR(255) | 是 | 原密码 | 当前登录密码 |
| new_password | VARCHAR(255) | 是 | 至少8位，数字+符号+字母 | 新密码 |
| confirm_password | VARCHAR(255) | 是 | 与新密码一致 | 确认新密码 |

---

## 2. 任务表

### 2.1 任务主表 (service_task)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| task_id | BIGINT | 是 | 任务ID | 2026032300001 |
| order_id | VARCHAR(50) | 是 | 关联订单号 | ORD2026032300001 |
| task_type | VARCHAR(20) | 是 | 任务类型 | 见任务类型枚举 |
| task_status | VARCHAR(20) | 是 | 任务状态 | 见任务状态枚举 |
| task_source | VARCHAR(20) | 否 | 任务来源 | SYSTEM/Manual |
| priority | INT | 否 | 优先级：1-低，2-中，3-高 | 2 |
| assign_to | BIGINT | 否 | 分配给的用户ID | 10001 |
| assign_time | DATETIME | 否 | 分配时间 | 2026-03-23 10:00:00 |
| process_time | DATETIME | 否 | 处理时间 | 2026-03-23 10:30:00 |
| close_time | DATETIME | 否 | 关闭时间 | 2026-03-23 11:00:00 |
| remark | TEXT | 否 | 备注 | - |
| create_time | DATETIME | 是 | 创建时间 | 2026-03-23 09:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:00:00 |

### 2.2 任务类型枚举

| 枚举值 | 说明 | 英文标识 |
|--------|------|----------|
| DOMESTIC_FLIGHT | 国内机票 | 国内机票 |
| INTERNATIONAL_FLIGHT | 国际机票 | 国际机票 |
| HOTEL | 酒店任务 | 酒店任务 |
| HOTEL_NIGHT_AUDIT | 酒店夜审 | 酒店夜审 |
| EAGLE_EYE | 鹰眼任务 | 鹰眼任务 |
| TRAIN | 火车任务 | 火车任务 |
| INSURANCE | 保险任务 | 保险任务 |
| DEMAND | 需求任务 | 需求任务 |
| CAR_RENTAL | 用车任务 | 用车任务 |
| TRAVEL_CUSTOMIZE | 行程定制 | 行程定制 |
| CORPORATE_AGREEMENT | 企业协议 | 企业协议 |
| CORPORATE_DIRECT | 企业直销 | 企业直销 |

### 2.3 任务状态枚举

| 枚举值 | 说明 |
|--------|------|
| PENDING | 待处理 |
| PROCESSING | 处理中 |
| SUSPENDED | 挂起中 |
| WAITING_TICKET | 待出票 |
| WAITING_REMINDER | 待催单 |
| REFUND_AUDIT | 退审核 |
| REFUND_REVIEW | 退复核 |
| CHANGE_TICKET | 改签出票 |
| CHANGE_AUDIT | 改签审核 |
| COMPLETED | 已完成 |
| CLOSED | 已关闭 |

### 2.4 任务手工维护表单

| 字段名 | 字段类型 | 必填 | 说明 | 可选值 |
|--------|----------|------|------|--------|
| order_no | VARCHAR(50) | 是 | 订单号 | - |
| task_category | VARCHAR(20) | 是 | 任务类型 | 国内机票、国际机票/港澳台、国内酒店、国际酒店、酒店夜审、火车、保险、鹰眼、其他 |
| action_type | VARCHAR(20) | 是 | 处理方式 | 创建任务、关闭任务 |
| task_type_detail | VARCHAR(20) | 是 | 具体任务类型 | 出票任务、改签任务、催单任务、退款任务、退复核任务 |

### 2.5 任务搜索条件

| 字段名 | 字段类型 | 说明 |
|--------|----------|------|
| order_no | VARCHAR(50) | 订单号（精确查询） |
| task_type | VARCHAR(20) | 任务类型 |
| task_status | VARCHAR(20) | 任务状态 |
| date_range | DATE_RANGE | 日期范围 |
| assignee | BIGINT | 处理人 |

---

## 3. 订单表

### 3.1 订单主表 (order)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| order_id | VARCHAR(50) | 是 | 订单ID | ORD2026032300001 |
| order_no | VARCHAR(50) | 是 | 订单号 | 2026032300001 |
| order_type | VARCHAR(20) | 是 | 订单类型 | FLIGHT/HOTEL/TRAIN等 |
| order_status | VARCHAR(20) | 是 | 订单状态 | 见订单状态枚举 |
| company_id | BIGINT | 是 | 企业ID | 1001 |
| company_name | VARCHAR(100) | 是 | 企业名称 | 温州华夏航空服务有限公司 |
| user_id | BIGINT | 否 | 下单用户ID | 10001 |
| user_name | VARCHAR(50) | 否 | 下单用户姓名 | 张三 |
| user_mobile | VARCHAR(20) | 否 | 下单用户手机 | 13800138000 |
| total_amount | DECIMAL(12,2) | 是 | 订单总金额 | 1500.00 |
| paid_amount | DECIMAL(12,2) | 否 | 已支付金额 | 1500.00 |
| refund_amount | DECIMAL(12,2) | 否 | 已退款金额 | 0.00 |
| create_time | DATETIME | 是 | 创建时间 | 2026-03-23 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:30:00 |
| pay_time | DATETIME | 否 | 支付时间 | 2026-03-23 10:05:00 |

### 3.2 机票订单扩展表 (flight_order)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| flight_order_id | BIGINT | 是 | 机票订单ID | 1 |
| order_id | VARCHAR(50) | 是 | 关联订单号 | ORD2026032300001 |
| flight_type | VARCHAR(20) | 是 | 航班类型 | DOMESTIC/INTERNATIONAL |
| airline_code | VARCHAR(10) | 是 | 航司二字码 | CA |
| airline_name | VARCHAR(50) | 是 | 航司名称 | 中国国航 |
| flight_no | VARCHAR(20) | 是 | 航班号 | CA1234 |
| departure_city | VARCHAR(50) | 是 | 出发城市 | 北京 |
| departure_airport | VARCHAR(50) | 是 | 出发机场 | 首都国际机场T3 |
| arrival_city | VARCHAR(50) | 是 | 到达城市 | 上海 |
| arrival_airport | VARCHAR(50) | 是 | 到达机场 | 浦东国际机场T2 |
| departure_time | DATETIME | 是 | 出发时间 | 2026-03-25 08:00:00 |
| arrival_time | DATETIME | 是 | 到达时间 | 2026-03-25 10:30:00 |
| cabin_class | VARCHAR(20) | 是 | 舱位等级 | ECONOMY/BUSINESS/FIRST |
| cabin_code | VARCHAR(10) | 是 | 舱位代码 | Y |
| ticket_price | DECIMAL(10,2) | 是 | 票价 | 800.00 |
| tax_amount | DECIMAL(10,2) | 否 | 税费 | 50.00 |
| passenger_name | VARCHAR(50) | 是 | 乘客姓名 | 张三 |
| passenger_type | VARCHAR(20) | 是 | 乘客类型 | ADULT/CHILD/BABY |
| id_type | VARCHAR(20) | 是 | 证件类型 | ID_CARD/PASSPORT |
| id_no | VARCHAR(50) | 是 | 证件号码 | 110101199001011234 |
| ticket_no | VARCHAR(50) | 否 | 票号 | 881-1234567890 |
| ticket_status | VARCHAR(20) | 是 | 出票状态 | UNISSUED/ISSUED/REFUNDED |

### 3.3 酒店订单扩展表 (hotel_order)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| hotel_order_id | BIGINT | 是 | 酒店订单ID | 1 |
| order_id | VARCHAR(50) | 是 | 关联订单号 | ORD2026032300002 |
| hotel_name | VARCHAR(100) | 是 | 酒店名称 | 上海外滩酒店 |
| hotel_address | VARCHAR(200) | 否 | 酒店地址 | 上海市黄浦区中山东一路100号 |
| city | VARCHAR(50) | 是 | 城市 | 上海 |
| check_in_date | DATE | 是 | 入住日期 | 2026-03-25 |
| check_out_date | DATE | 是 | 离店日期 | 2026-03-27 |
| room_type | VARCHAR(50) | 是 | 房型 | 高级大床房 |
| room_count | INT | 是 | 房间数量 | 1 |
| night_count | INT | 是 | 入住晚数 | 2 |
| daily_rate | DECIMAL(10,2) | 是 | 日均房价 | 500.00 |
| total_amount | DECIMAL(10,2) | 是 | 订单总金额 | 1000.00 |
| guest_name | VARCHAR(50) | 是 | 入住人姓名 | 张三 |
| guest_mobile | VARCHAR(20) | 否 | 入住人电话 | 13800138000 |
| special_request | TEXT | 否 | 特殊要求 | 无烟房 |

### 3.4 火车票订单扩展表 (train_order)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| train_order_id | BIGINT | 是 | 火车票订单ID | 1 |
| order_id | VARCHAR(50) | 是 | 关联订单号 | ORD2026032300003 |
| train_no | VARCHAR(20) | 是 | 车次 | G1234 |
| train_type | VARCHAR(20) | 是 | 列车类型 | G(高铁)/D(动车)/K(普快) |
| departure_station | VARCHAR(50) | 是 | 出发站 | 北京南 |
| arrival_station | VARCHAR(50) | 是 | 到达站 | 上海虹桥 |
| departure_time | DATETIME | 是 | 出发时间 | 2026-03-25 08:00:00 |
| arrival_time | DATETIME | 是 | 到达时间 | 2026-03-25 12:30:00 |
| seat_type | VARCHAR(20) | 是 | 座位类型 | BUSINESS/FIRST/SECOND |
| seat_no | VARCHAR(20) | 否 | 座位号 | 05A |
| ticket_price | DECIMAL(10,2) | 是 | 票价 | 553.00 |
| passenger_name | VARCHAR(50) | 是 | 乘客姓名 | 张三 |
| id_type | VARCHAR(20) | 是 | 证件类型 | ID_CARD |
| id_no | VARCHAR(50) | 是 | 证件号码 | 110101199001011234 |
| ticket_no | VARCHAR(50) | 否 | 取票号 | 12345678 |

### 3.5 保险订单扩展表 (insurance_order)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| insurance_order_id | BIGINT | 是 | 保险订单ID | 1 |
| order_id | VARCHAR(50) | 是 | 关联订单号 | ORD2026032300004 |
| insurance_type | VARCHAR(50) | 是 | 保险类型 | 航空意外险/旅行险 |
| insurance_company | VARCHAR(100) | 是 | 保险公司 | 中国人保 |
| policy_no | VARCHAR(50) | 否 | 保单号 | POL2026032300001 |
| insured_name | VARCHAR(50) | 是 | 被保险人 | 张三 |
| id_type | VARCHAR(20) | 是 | 证件类型 | ID_CARD |
| id_no | VARCHAR(50) | 是 | 证件号码 | 110101199001011234 |
| start_date | DATETIME | 是 | 生效时间 | 2026-03-25 00:00:00 |
| end_date | DATETIME | 是 | 终止时间 | 2026-03-26 23:59:59 |
| premium | DECIMAL(10,2) | 是 | 保费 | 30.00 |
| coverage_amount | DECIMAL(12,2) | 是 | 保额 | 500000.00 |

### 3.6 订单状态枚举

| 枚举值 | 说明 |
|--------|------|
| UNPAID | 待支付 |
| PAID | 已支付 |
| CONFIRMED | 已确认 |
| ISSUED | 已出票 |
| COMPLETED | 已完成 |
| CANCELLED | 已取消 |
| REFUNDING | 退款中 |
| REFUNDED | 已退款 |
| PARTIAL_REFUNDED | 部分退款 |

### 3.7 代客下单-用户搜索条件

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| keyword | VARCHAR(100) | 是 | 搜索关键词 | 张三 |
| search_type | VARCHAR(20) | 否 | 搜索类型 | name/pinyin/mobile/email/employee_code |

---

## 4. 企业账户表

### 4.1 企业账户主表 (company_account)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| account_id | BIGINT | 是 | 账户ID | 1 |
| account_name | VARCHAR(100) | 是 | 账户名称 | 华夏航空-POC |
| company_id | BIGINT | 是 | 企业ID | 1001 |
| company_name | VARCHAR(200) | 是 | 企业名称 | 温州华夏航空服务有限公司 |
| tmc_id | BIGINT | 是 | 所属TMC ID | 1 |
| tmc_name | VARCHAR(200) | 是 | 所属TMC名称 | 温州华夏航空服务有限公司（后台） |
| account_type | VARCHAR(20) | 是 | 账户类型 | PREPAID(预存账户)/CREDIT(信用账户) |
| credit_limit | DECIMAL(12,2) | 否 | 授信额度 | 0.00 |
| credit_available | DECIMAL(12,2) | 否 | 可用额度 | 0.00 |
| balance | DECIMAL(12,2) | 是 | 账户余额 | 0.00 |
| account_status | VARCHAR(20) | 是 | 账户状态 | AVAILABLE(可用)/DISABLED(停用) |
| open_time | DATETIME | 是 | 开户时间 | 2026-01-13 18:19:00 |
| update_time | DATETIME | 是 | 最后修改时间 | 2026-03-11 13:46:00 |
| update_by | BIGINT | 是 | 最后修改人ID | 10002 |
| update_name | VARCHAR(50) | 是 | 最后修改人姓名 | 贺勇 |

### 4.2 账户状态枚举

| 枚举值 | 说明 |
|--------|------|
| AVAILABLE | 可用的 |
| DISABLED | 停用的 |
| FROZEN | 冻结的 |
| CLOSED | 已关闭 |

### 4.3 账户类型枚举

| 枚举值 | 说明 |
|--------|------|
| PREPAID | 预存账户 |
| CREDIT | 信用账户 |
| MIXED | 混合账户 |

### 4.4 结算账户设置-查询条件

| 字段名 | 字段类型 | 说明 |
|--------|----------|------|
| company_name | VARCHAR(200) | 企业名称（下拉选择） |
| account_name | VARCHAR(100) | 账户名称（文本输入） |

### 4.5 结算账户设置-批量操作

| 操作名称 | 说明 |
|----------|------|
| 批量生成账单 | 批量为企业生成结算账单 |
| 批量设置结算规则 | 批量设置结算规则 |

### 4.6 结算账户设置-操作按钮

| 操作名称 | 说明 |
|----------|------|
| 结算 | 查看账户结算明细 |
| 结算配置 | 配置账户结算规则 |
| 创建账单 | 为账户创建新账单 |

---

## 5. 企业账单表

### 5.1 企业账单主表 (company_bill)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| bill_id | BIGINT | 是 | 账单ID | 1 |
| bill_no | VARCHAR(50) | 是 | 账单编号 | B2026032300001 |
| order_no | VARCHAR(50) | 否 | 销售订单号 | ORD2026032300001 |
| company_id | BIGINT | 是 | 企业ID | 1001 |
| company_name | VARCHAR(200) | 是 | 企业名称 | 温州华夏航空服务有限公司 |
| account_id | BIGINT | 是 | 账户ID | 1 |
| account_name | VARCHAR(100) | 是 | 账户名称 | 华夏航空-POC |
| settlement_period_start | DATE | 是 | 结算期间开始 | 2026-03-01 |
| settlement_period_end | DATE | 是 | 结算期间结束 | 2026-03-31 |
| bill_type | VARCHAR(20) | 是 | 账单类型 | 见账单类型枚举 |
| bill_category | VARCHAR(20) | 是 | 账单分类 | NORMAL(正常)/ADJUSTMENT(调整) |
| total_amount | DECIMAL(12,2) | 是 | 账单总金额 | 10000.00 |
| outstanding_amount | DECIMAL(12,2) | 是 | 未清账金额 | 5000.00 |
| overdue_date | DATE | 否 | 逾期日期 | 2026-04-15 |
| bill_status | VARCHAR(20) | 是 | 账单状态 | 见账单状态枚举 |
| invoice_status | VARCHAR(20) | 是 | 开票状态 | 见开票状态枚举 |
| reconciliation_status | VARCHAR(20) | 是 | 清账状态 | 见清账状态枚举 |
| settlement_user_id | BIGINT | 否 | 结算员ID | 10001 |
| settlement_user_name | VARCHAR(50) | 否 | 结算员姓名 | 高雄 |
| adjustment_type | VARCHAR(20) | 否 | 调整项类型 | DISCOUNT/CHARGE/OTHER |
| create_time | DATETIME | 是 | 创建时间 | 2026-03-23 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:30:00 |
| confirm_time | DATETIME | 否 | 确认时间 | - |
| invoice_time | DATETIME | 否 | 开票时间 | - |

### 5.2 账单类型枚举

| 枚举值 | 说明 |
|--------|------|
| NORMAL | 正常账单 |
| ADJUSTMENT | 调整账单 |
| CREDIT_NOTE | 贷项通知单 |
| DEBIT_NOTE | 借项通知单 |

### 5.3 账单分类枚举

| 枚举值 | 说明 |
|--------|------|
| ALL | 全部 |
| NORMAL | 正常 |
| ADJUSTMENT | 调整 |

### 5.4 账单状态枚举

| 枚举值 | 说明 |
|--------|------|
| DRAFT | 草稿 |
| PENDING | 待确认 |
| CONFIRMED | 已确认 |
| SENT | 已发送 |
| OVERDUE | 已逾期 |
| PARTIAL_PAID | 部分支付 |
| PAID | 已支付 |
| CANCELLED | 已作废 |

### 5.5 开票状态枚举

| 枚举值 | 说明 |
|--------|------|
| NOT_INVOICED | 未开票 |
| INVOICED | 已开票 |
| PARTIAL_INVOICED | 部分开票 |

### 5.6 清账状态枚举

| 枚举值 | 说明 |
|--------|------|
| UNRECONCILED | 未清账 |
| PARTIAL_RECONCILED | 部分清账 |
| RECONCILED | 已清账 |

### 5.7 调整项类型枚举

| 枚举值 | 说明 |
|--------|------|
| DISCOUNT | 折扣 |
| CHARGE | 补收 |
| OTHER | 其他 |

### 5.8 企业账单管理-查询条件

| 字段名 | 字段类型 | 必填 | 说明 | 默认值 |
|--------|----------|------|------|--------|
| settlement_period | DATE_RANGE | 是 | 结算期间 | 2025/10/01 - 2026/03/31 |
| company_name | VARCHAR(200) | 否 | 企业名称 | - |
| account_name | VARCHAR(100) | 否 | 企业账户 | - |
| legal_name | VARCHAR(100) | 否 | 法人名称 | - |
| org_company | VARCHAR(200) | 否 | 组织公司 | - |
| bill_status | VARCHAR(20) | 否 | 账单状态 | 草稿 |
| bill_type | VARCHAR(20) | 否 | 账单类型 | - |
| overdue_date | DATE_RANGE | 否 | 逾期日期 | - |
| invoice_status | VARCHAR(20) | 否 | 开票状态 | - |
| reconciliation_status | VARCHAR(20) | 否 | 清账状态 | 未清账 |
| settlement_user_name | VARCHAR(50) | 否 | 结算员 | - |
| adjustment_type | VARCHAR(20) | 否 | 调整项 | - |
| order_no | VARCHAR(50) | 否 | 订单号 | - |
| bill_id | BIGINT | 否 | 账单ID | - |
| bill_no | VARCHAR(50) | 否 | 账单编码 | - |
| bill_category | VARCHAR(20) | 否 | 账单分类 | 全部 |

### 5.9 企业账单管理-列表显示字段

| 字段名 | 说明 |
|--------|------|
| 结算期间 | 账单结算的时间范围 |
| 企业名称 | 客户企业名称 |
| 企业账户 | 企业结算账户 |
| 账单类型 | 账单分类 |
| 账单总金额 | 账单总额 |
| 逾期日期 | 逾期结算日期 |
| 账单状态 | 当前状态 |
| 未清账金额 | 未结清金额 |

### 5.10 企业账单管理-批量操作

| 操作名称 | 说明 |
|----------|------|
| 批量下载账单 | 下载选中账单文件 |
| 批量下载数电票 | 下载电子发票 |
| 导出列表 | 导出账单列表Excel |
| 字段选择 | 自定义列表显示字段 |
| 批量作废 | 作废选中账单 |
| 批量发送 | 发送账单给客户 |
| 批量确认 | 确认账单 |
| 批量确认开票信息 | 确认开票信息 |

---

## 6. 企业来款表

### 6.1 企业来款主表 (company_payment)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| payment_id | BIGINT | 是 | 来款ID | 1 |
| payment_no | VARCHAR(50) | 是 | 来款编号 | PAY2026032300001 |
| company_id | BIGINT | 是 | 企业ID | 1001 |
| company_name | VARCHAR(200) | 是 | 企业名称 | 温州华夏航空服务有限公司 |
| account_id | BIGINT | 是 | 账户ID | 1 |
| payment_method | VARCHAR(20) | 是 | 付款方式 | 见付款方式枚举 |
| payment_amount | DECIMAL(12,2) | 是 | 付款金额 | 5000.00 |
| payment_time | DATETIME | 是 | 付款时间 | 2026-03-23 10:00:00 |
| bank_name | VARCHAR(100) | 否 | 银行名称 | 中国工商银行 |
| bank_account | VARCHAR(50) | 否 | 银行账号 | 6222021234567890 |
| remark | TEXT | 否 | 备注 | - |
| status | VARCHAR(20) | 是 | 状态 | PENDING/CONFIRMED/CANCELLED |
| create_time | DATETIME | 是 | 创建时间 | 2026-03-23 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:30:00 |

### 6.2 付款方式枚举

| 枚举值 | 说明 |
|--------|------|
| BANK_TRANSFER | 银行转账 |
| ALIPAY | 支付宝 |
| WECHAT | 微信支付 |
| CASH | 现金 |
| OTHER | 其他 |

---

## 7. 供应商账户表

### 7.1 供应商账户主表 (supplier_account)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| supplier_account_id | BIGINT | 是 | 供应商账户ID | 1 |
| supplier_id | BIGINT | 是 | 供应商ID | 2001 |
| supplier_name | VARCHAR(200) | 是 | 供应商名称 | 中国国航 |
| supplier_type | VARCHAR(20) | 是 | 供应商类型 | AIRLINE/HOTEL/TRAIN |
| account_no | VARCHAR(50) | 是 | 账户编号 | SA2026032300001 |
| account_type | VARCHAR(20) | 是 | 账户类型 | 见账户类型枚举 |
| balance | DECIMAL(12,2) | 是 | 账户余额 | 0.00 |
| credit_limit | DECIMAL(12,2) | 否 | 信用额度 | 10000.00 |
| account_status | VARCHAR(20) | 是 | 账户状态 | ACTIVE/INACTIVE |
| open_time | DATETIME | 是 | 开户时间 | 2026-01-01 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:00:00 |

### 7.2 供应商类型枚举

| 枚举值 | 说明 |
|--------|------|
| AIRLINE | 航空公司 |
| HOTEL | 酒店 |
| TRAIN | 火车 |
| CAR | 用车 |
| INSURANCE | 保险 |
| OTHER | 其他 |

---

## 8. 供应商账单表

### 8.1 供应商账单主表 (supplier_bill)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| supplier_bill_id | BIGINT | 是 | 供应商账单ID | 1 |
| supplier_bill_no | VARCHAR(50) | 是 | 账单编号 | SB2026032300001 |
| supplier_id | BIGINT | 是 | 供应商ID | 2001 |
| supplier_name | VARCHAR(200) | 是 | 供应商名称 | 中国国航 |
| supplier_account_id | BIGINT | 是 | 供应商账户ID | 1 |
| order_no | VARCHAR(50) | 否 | 采购订单号 | PO2026032300001 |
| bill_period_start | DATE | 是 | 账单期间开始 | 2026-03-01 |
| bill_period_end | DATE | 是 | 账单期间结束 | 2026-03-31 |
| bill_amount | DECIMAL(12,2) | 是 | 账单金额 | 50000.00 |
| paid_amount | DECIMAL(12,2) | 是 | 已付金额 | 30000.00 |
| outstanding_amount | DECIMAL(12,2) | 是 | 未付金额 | 20000.00 |
| bill_status | VARCHAR(20) | 是 | 账单状态 | DRAFT/CONFIRMED/PAID |
| due_date | DATE | 否 | 到期日期 | 2026-04-15 |
| create_time | DATETIME | 是 | 创建时间 | 2026-03-23 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:30:00 |

### 8.2 供应商账单状态枚举

| 枚举值 | 说明 |
|--------|------|
| DRAFT | 草稿 |
| CONFIRMED | 已确认 |
| SENT | 已发送 |
| PARTIAL_PAID | 部分支付 |
| PAID | 已支付 |
| OVERDUE | 已逾期 |
| CANCELLED | 已作废 |

---

## 9. 供应商付款表

### 9.1 供应商付款主表 (supplier_payment)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| supplier_payment_id | BIGINT | 是 | 付款ID | 1 |
| payment_no | VARCHAR(50) | 是 | 付款编号 | SP2026032300001 |
| supplier_bill_id | BIGINT | 是 | 关联供应商账单ID | 1 |
| supplier_id | BIGINT | 是 | 供应商ID | 2001 |
| supplier_name | VARCHAR(200) | 是 | 供应商名称 | 中国国航 |
| payment_amount | DECIMAL(12,2) | 是 | 付款金额 | 10000.00 |
| payment_method | VARCHAR(20) | 是 | 付款方式 | BANK_TRANSFER |
| payment_time | DATETIME | 是 | 付款时间 | 2026-03-23 10:00:00 |
| bank_name | VARCHAR(100) | 否 | 收款银行 | 中国工商银行 |
| bank_account | VARCHAR(50) | 否 | 收款账号 | 6222021234567890 |
| remark | TEXT | 否 | 备注 | - |
| status | VARCHAR(20) | 是 | 状态 | PENDING/APPROVED/PAID/CANCELLED |
| create_time | DATETIME | 是 | 创建时间 | 2026-03-23 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:30:00 |

### 9.2 供应商付款状态枚举

| 枚举值 | 说明 |
|--------|------|
| PENDING | 待审批 |
| APPROVED | 已审批 |
| PAID | 已付款 |
| CANCELLED | 已取消 |

---

## 10. 发票表

### 10.1 发票主表 (invoice)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| invoice_id | BIGINT | 是 | 发票ID | 1 |
| invoice_no | VARCHAR(50) | 是 | 发票号码 | INV2026032300001 |
| invoice_type | VARCHAR(20) | 是 | 发票类型 | 见发票类型枚举 |
| company_id | BIGINT | 是 | 开票企业ID | 1001 |
| company_name | VARCHAR(200) | 是 | 开票企业名称 | 温州华夏航空服务有限公司 |
| bill_id | BIGINT | 是 | 关联账单ID | 1 |
| bill_no | VARCHAR(50) | 是 | 关联账单编号 | B2026032300001 |
| invoice_amount | DECIMAL(12,2) | 是 | 发票金额 | 10000.00 |
| tax_amount | DECIMAL(12,2) | 否 | 税额 | 900.00 |
| tax_rate | DECIMAL(5,4) | 否 | 税率 | 0.09 |
| invoice_title | VARCHAR(200) | 是 | 发票抬头 | 某某公司 |
| tax_number | VARCHAR(50) | 是 | 税号 | 91110000XXXXXXXX |
| invoice_content | VARCHAR(200) | 是 | 发票内容 | *经纪代理服务* |
| receiver_name | VARCHAR(50) | 否 | 收件人姓名 | 张三 |
| receiver_mobile | VARCHAR(20) | 否 | 收件人电话 | 13800138000 |
| receiver_address | VARCHAR(200) | 否 | 收件人地址 | 北京市朝阳区XXX |
| invoice_status | VARCHAR(20) | 是 | 发票状态 | 见发票状态枚举 |
| issue_time | DATETIME | 否 | 开票时间 | 2026-03-23 10:00:00 |
| send_time | DATETIME | 否 | 寄送时间 | 2026-03-23 14:00:00 |
| create_time | DATETIME | 是 | 创建时间 | 2026-03-23 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:30:00 |

### 10.2 发票类型枚举

| 枚举值 | 说明 |
|--------|------|
| VAT_NORMAL | 增值税普通发票 |
| VAT_SPECIAL | 增值税专用发票 |
| ELECTRONIC | 电子发票 |
| TRAIN_INVOICE | 火车票 |

### 10.3 发票状态枚举

| 枚举值 | 说明 |
|--------|------|
| PENDING | 待开票 |
| ISSUED | 已开票 |
| SENT | 已寄送 |
| RECEIVED | 已签收 |
| INVALID | 已作废 |
| RETURNED | 已退回 |

---

## 11. 退款表

### 11.1 退款主表 (refund)

| 字段名 | 字段类型 | 必填 | 说明 | 示例值 |
|--------|----------|------|------|--------|
| refund_id | BIGINT | 是 | 退款ID | 1 |
| refund_no | VARCHAR(50) | 是 | 退款编号 | REF2026032300001 |
| order_id | VARCHAR(50) | 是 | 关联订单号 | ORD2026032300001 |
| order_type | VARCHAR(20) | 是 | 订单类型 | FLIGHT/HOTEL/TRAIN |
| company_id | BIGINT | 是 | 企业ID | 1001 |
| company_name | VARCHAR(200) | 是 | 企业名称 | 温州华夏航空服务有限公司 |
| refund_type | VARCHAR(20) | 是 | 退款类型 | VOLUNTARY(自愿)/INVOLUNTARY(非自愿) |
| refund_amount | DECIMAL(12,2) | 是 | 退款金额 | 500.00 |
| refund_fee | DECIMAL(12,2) | 否 | 退款手续费 | 20.00 |
| actual_refund_amount | DECIMAL(12,2) | 是 | 实际退款金额 | 480.00 |
| refund_reason | VARCHAR(500) | 是 | 退款原因 | 航班取消/用户取消 |
| refund_status | VARCHAR(20) | 是 | 退款状态 | 见退款状态枚举 |
| audit_user_id | BIGINT | 否 | 审核人ID | 10002 |
| audit_user_name | VARCHAR(50) | 否 | 审核人姓名 | 李四 |
| audit_time | DATETIME | 否 | 审核时间 | 2026-03-23 10:30:00 |
| audit_remark | TEXT | 否 | 审核备注 | - |
| refund_time | DATETIME | 否 | 退款时间 | 2026-03-23 11:00:00 |
| create_time | DATETIME | 是 | 创建时间 | 2026-03-23 10:00:00 |
| update_time | DATETIME | 是 | 更新时间 | 2026-03-23 10:30:00 |

### 11.2 退款状态枚举

| 枚举值 | 说明 |
|--------|------|
| PENDING | 待审核 |
| AUDIT_PASS | 审核通过 |
| AUDIT_REJECT | 审核拒绝 |
| PROCESSING | 处理中 |
| COMPLETED | 已完成 |
| FAILED | 退款失败 |
| CANCELLED | 已取消 |

---

## 12. 枚举值汇总

### 12.1 任务类型

| 值 | 说明 |
|----|------|
| DOMESTIC_FLIGHT | 国内机票 |
| INTERNATIONAL_FLIGHT | 国际机票 |
| HOTEL | 酒店任务 |
| HOTEL_NIGHT_AUDIT | 酒店夜审 |
| EAGLE_EYE | 鹰眼任务 |
| TRAIN | 火车任务 |
| INSURANCE | 保险任务 |
| DEMAND | 需求任务 |
| CAR_RENTAL | 用车任务 |
| TRAVEL_CUSTOMIZE | 行程定制 |
| CORPORATE_AGREEMENT | 企业协议 |
| CORPORATE_DIRECT | 企业直销 |

### 12.2 任务状态

| 值 | 说明 |
|----|------|
| PENDING | 待处理 |
| PROCESSING | 处理中 |
| SUSPENDED | 挂起中 |
| WAITING_TICKET | 待出票 |
| WAITING_REMINDER | 待催单 |
| REFUND_AUDIT | 退审核 |
| REFUND_REVIEW | 退复核 |
| CHANGE_TICKET | 改签出票 |
| CHANGE_AUDIT | 改签审核 |
| COMPLETED | 已完成 |
| CLOSED | 已关闭 |

### 12.3 订单类型

| 值 | 说明 |
|----|------|
| FLIGHT | 机票订单 |
| HOTEL | 酒店订单 |
| TRAIN | 火车票订单 |
| INSURANCE | 保险订单 |
| CAR | 用车订单 |
| CUSTOM | 定制订单 |

### 12.4 订单状态

| 值 | 说明 |
|----|------|
| UNPAID | 待支付 |
| PAID | 已支付 |
| CONFIRMED | 已确认 |
| ISSUED | 已出票 |
| COMPLETED | 已完成 |
| CANCELLED | 已取消 |
| REFUNDING | 退款中 |
| REFUNDED | 已退款 |
| PARTIAL_REFUNDED | 部分退款 |

### 12.5 账户状态

| 值 | 说明 |
|----|------|
| AVAILABLE | 可用的 |
| DISABLED | 停用的 |
| FROZEN | 冻结的 |
| CLOSED | 已关闭 |

### 12.6 账单状态

| 值 | 说明 |
|----|------|
| DRAFT | 草稿 |
| PENDING | 待确认 |
| CONFIRMED | 已确认 |
| SENT | 已发送 |
| OVERDUE | 已逾期 |
| PARTIAL_PAID | 部分支付 |
| PAID | 已支付 |
| CANCELLED | 已作废 |

### 12.7 开票状态

| 值 | 说明 |
|----|------|
| NOT_INVOICED | 未开票 |
| INVOICED | 已开票 |
| PARTIAL_INVOICED | 部分开票 |

### 12.8 清账状态

| 值 | 说明 |
|----|------|
| UNRECONCILED | 未清账 |
| PARTIAL_RECONCILED | 部分清账 |
| RECONCILED | 已清账 |

---

*文档说明：本字段信息文档基于Z-TRIP后台系统界面分析整理，实际数据库字段可能有所差异，建议与开发团队确认后使用。*
