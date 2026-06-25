# 华夏航旅 B2B2C 综合航旅服务平台 — 项目架构与数据库设计说明

> 版本: v7 | 数据库: MySQL 8.0.35 | 字符集: utf8mb4_unicode_ci | 总表数: 84

---

## 一、项目架构概览

### 1.1 业务定位

温州华夏航服 B2B2C 综合航旅服务平台，覆盖机票、火车票、酒店、商城四大业务线，服务于:
- **PMC端**: 平台运营方内部管理
- **TMC端**: 集团客户(差旅管理公司)管理其下属商户
- **MMC端**: 商户/分销商日常经营
- **C端**: 终端旅客(小程序/H5/Web)

### 1.2 技术栈

| 层级 | 技术 |
|------|------|
| 后端框架 | Hyperf 3.1 + Swoole |
| 数据库 | MySQL 8.0.35 |
| 缓存 | Redis |
| 消息队列 | RabbitMQ |
| B端前端 | Vue 3 + Element Plus |
| C端前端 | uni-app (微信小程序/H5) |
| 认证 | JWT + Casbin (RBAC+ABAC) |

### 1.3 多租户三端隔离架构

```
┌──────────────────────────────────────────────────────────────────┐
│                        PMC 平台端 (SaaS)                         │
│  pmc_user / pmc_role / pmc_menu / pmc_department / pmc_position │
│  全局共享菜单, 无 tenant_id                                       │
└──────────────────────────┬───────────────────────────────────────┘
                           │ 管理
┌──────────────────────────▼───────────────────────────────────────┐
│                      TMC 集团端 (Tenant)                         │
│  tmc_user / tmc_role / tmc_menu / tmc_department / tmc_position │
│  数据按 tenant_id 隔离, 菜单全局共享                              │
└──────────────────────────┬───────────────────────────────────────┘
                           │ 管辖
┌──────────────────────────▼───────────────────────────────────────┐
│                    MMC 商户/分销商端 (Tenant)                     │
│  mmc_user / mmc_role / mmc_menu / mmc_department / mmc_position │
│  数据按 tenant_id 隔离, 菜单全局共享                              │
└──────────────────────────────────────────────────────────────────┘
```

关键设计:
- **物理分表**: 三端各自独立用户/角色/部门/岗位表, 零数据交叉
- **菜单全局共享**: pmc_menu / tmc_menu / mmc_menu 无 tenant_id, 所有同端租户共享同一菜单树
- **权限控制**: Casbin rules 表 + data_permission_policy 表实现 RBAC + 数据权限
- **套餐体系**: tmc_package(TMC集团套餐) + mmc_package(MMC商户套餐, 支持TMC自定义派生)

---

## 二、数据库表全景 (84张)

### 2.1 表分组统计

| 分组 | 表数 | 说明 |
|------|------|------|
| PMC端基础设施 | 12 | 用户/角色/菜单/部门/岗位/日志 |
| TMC端基础设施 | 15 | 用户/角色/菜单/部门/岗位/套餐/日志 |
| MMC端基础设施 | 14 | 用户/角色/菜单/部门/岗位/套餐/日志 |
| 平台共享 | 7 | tenant/rules/attachment/data_permission/migrations/三方绑定/三方日志 |
| C端用户体系 | 9 | 自然人/会员/地址/旅客/大客户集团/签约/政策/成员/申报 |
| 大客户白名单 | 3 | 模板/批次/成员明细 |
| 订单体系 | 9 | 主订单/销售/采购/4类子订单/采购子订单/变更单 |
| 航空基础数据 | 13 | 航司/机场/区域/机型/舱位/燃油/客规/账号/平台/通知 |
| 政策匹配 | 2 | 匹配规则/匹配日志 |

### 2.2 完整表清单

#### PMC端 (12张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | pmc_user | 平台端用户(内部员工) |
| 2 | pmc_role | 平台端角色 |
| 3 | pmc_menu | 平台端菜单(全局共享) |
| 4 | pmc_department | 平台端部门 |
| 5 | pmc_position | 平台端岗位 |
| 6 | pmc_dept_leader | 部门领导 |
| 7 | pmc_user_role | 用户-角色关联 |
| 8 | pmc_user_dept | 用户-部门关联 |
| 9 | pmc_user_position | 用户-岗位关联 |
| 10 | pmc_role_menu | 角色-菜单关联 |
| 11 | pmc_login_log | 登录日志 |
| 12 | pmc_operation_log | 操作日志 |

#### TMC端 (15张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | tmc_user | TMC端用户 |
| 2 | tmc_role | TMC角色(tenant_id隔离) |
| 3 | tmc_menu | TMC端菜单(全局共享) |
| 4 | tmc_department | TMC部门 |
| 5 | tmc_position | TMC岗位 |
| 6 | tmc_dept_leader | 部门领导 |
| 7 | tmc_user_role | 用户-角色 |
| 8 | tmc_user_dept | 用户-部门 |
| 9 | tmc_user_position | 用户-岗位 |
| 10 | tmc_role_menu | 角色-菜单 |
| 11 | tmc_package | TMC集团套餐 |
| 12 | tmc_package_menu | 套餐-菜单(含platform字段区分tmc/mmc菜单) |
| 13 | tmc_package_change_log | 套餐变更日志 |
| 14 | tmc_login_log | 登录日志 |
| 15 | tmc_operation_log | 操作日志 |

#### MMC端 (14张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | mmc_user | 商户/分销商用户 |
| 2 | mmc_role | MMC角色(tenant_id隔离) |
| 3 | mmc_menu | MMC端菜单(全局共享) |
| 4 | mmc_department | 商户部门 |
| 5 | mmc_position | 商户岗位 |
| 6 | mmc_dept_leader | 部门领导 |
| 7 | mmc_user_role | 用户-角色 |
| 8 | mmc_user_dept | 用户-部门 |
| 9 | mmc_user_position | 用户-岗位 |
| 10 | mmc_role_menu | 角色-菜单 |
| 11 | mmc_package | 商户套餐(支持TMC自定义派生) |
| 12 | mmc_package_menu | 套餐-菜单 |
| 13 | mmc_login_log | 登录日志 |
| 14 | mmc_operation_log | 操作日志 |

#### 平台共享 (7张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | tenant | 租户表(tmc/merchant/distributor三类型) |
| 2 | rules | Casbin权限规则表 |
| 3 | attachment | 上传文件信息 |
| 4 | data_permission_policy | 数据权限策略 |
| 5 | migrations | 数据库迁移记录 |
| 6 | user_third_party_auth | 三方授权绑定(三端共享) |
| 7 | user_third_party_login_log | 三方授权登录日志 |

#### C端用户体系 (9张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | c_user | C端自然人(平台级,全局唯一) |
| 2 | c_member | C端会员(商户维度隔离) |
| 3 | c_member_address | 会员收货地址 |
| 4 | c_passenger | 常用旅客(脱敏+密文+HMAC三字段) |
| 5 | corporate_group | 大客户集团主体(跨航司) |
| 6 | corporate_contract | 大客户签约关系(集团x航司) |
| 7 | corporate_policy | 大客户自动申报政策 |
| 8 | c_member_corporate | 大客户成员身份(平台级,同航司唯一) |
| 9 | c_member_corporate_apply | 大客户成员申报记录(全量审计) |

#### 大客户白名单 (3张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | corporate_whitelist_template | 航司白名单导入模板(各航司格式不同) |
| 2 | corporate_whitelist_batch | 白名单提交批次 |
| 3 | corporate_whitelist_member | 白名单成员明细(航司视角) |

#### 订单体系 (9张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | order | 主订单(大订单) |
| 2 | order_sales | 销售业务订单(按业务类型拆分,绑销售员) |
| 3 | order_procurement | 采购业务订单(按渠道拆分,绑采购员) |
| 4 | order_item_flight | 机票子订单(人x程=最小操作单元) |
| 5 | order_item_train | 火车票子订单(人x程) |
| 6 | order_item_hotel | 酒店子订单(人x晚x间) |
| 7 | order_item_mall | 商城子订单(商品件) |
| 8 | order_procure_item | 采购子订单(关联销售item) |
| 9 | order_change | 订单变更记录(退/改/签) |

#### 航空基础数据 (13张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | air_airline | 航司主数据 |
| 2 | air_airport | 机场主数据 |
| 3 | air_region | 行政区划(省/市/区三级) |
| 4 | air_plane_model | 机型数据(含机建费) |
| 5 | air_cabin_level | 航司舱位等级(经济/公务/头等) |
| 6 | air_cabin | 舱位明细(等级下具体舱位) |
| 7 | air_fuel | 航司燃油费(按里程分档) |
| 8 | air_fuel_detail | 航程里程(航司x出发x到达) |
| 9 | air_gauge_type | 客规时间段类型(退/改时段定义) |
| 10 | air_gauge | 客规(退改签规则) |
| 11 | air_airline_accounts | 航司/OTA采购账号(B2B接口凭证) |
| 12 | air_platform | 采购平台(上游数据源配置) |
| 13 | air_airline_notice | 航司预定须知/注意事项 |

#### 政策匹配 (2张)
| # | 表名 | 说明 |
|---|------|------|
| 1 | corporate_policy_rule | 大客户政策匹配规则(航线/舱位/折扣) |
| 2 | corporate_policy_match_log | 政策匹配记录(自动+批量匹配日志) |

---

## 三、核心数据模型

### 3.1 C端用户三层模型

```
c_user (平台自然人)
  │  一个自然人全局唯一 (phone_hash / id_type+id_number_hash)
  │
  ├── c_member (商户会员) ──── 按商户隔离, 一个自然人可注册多个商户
  │     │
  │     ├── c_member_address (收货地址)
  │     │
  │     ├── c_passenger (常用旅客)
  │     │     脱敏三字段: name/name_encrypted/name_hash
  │     │                 id_number/id_number_encrypted/id_number_hash
  │     │                 phone/phone_encrypted/phone_hash
  │     │
  │     └── c_member_corporate (大客户成员身份)
  │           平台级, 同一自然人同一航司只能有一个有效身份
  │           通过 uk_guard 生成列实现部分唯一约束
  │
  └── c_member_corporate_apply (大客户申报记录)
        全量审计, 记录每一次申报及其完整生命周期
```

**脱敏三字段法**:
| 字段 | 用途 | 类型 |
|------|------|------|
| phone | 前端展示(138****8888) | varchar(20) |
| phone_encrypted | 解密取明文(AES-256-GCM) | varbinary(255) |
| phone_hash | 精确查找+唯一约束(HMAC-SHA256) | char(64) ascii |

### 3.2 大客户体系四层模型

```
corporate_group (集团主体)
  │  例: 华为技术有限公司
  │  platform-level, 一个集团可跨航司签约
  │
  └── corporate_contract (签约关系) ──── 集团x航司 = 一条签约
        │  例: 华为 x CA, 华为 x MU
        │  包含航司特定配置: 前置指令/运价指令/实名制/白名单模板/申报方式等
        │
        ├── corporate_policy (自动申报政策)
        │     定义什么条件触发自动大客户申报
        │
        ├── corporate_policy_rule (匹配规则)
        │     航线/舱位/折扣/行程类型等维度
        │
        ├── c_member_corporate (成员身份)
        │     通过 uk_guard 保证: 同一user_id + airline_code 仅一条有效记录
        │
        ├── c_member_corporate_apply (申报记录)
        │     通过 uk_guard 保证: 同一user_id + airline_code 无重复待审核申报
        │
        └── corporate_whitelist_template (白名单模板)
              │  各航司白名单格式不同(CZ多证件/3U要编码/CA要员工类型)
              │
              └── corporate_whitelist_batch (提交批次)
                    │  一次提交 = 一个批次
                    │
                    └── corporate_whitelist_member (成员明细)
                          航司视角的名单数据, 含匹配回填字段
```

**uk_guard 生成列技术** (MySQL部分唯一索引):
```sql
-- c_member_corporate: 仅 status=1(有效) 时参与唯一校验
uk_guard VARCHAR(60) GENERATED ALWAYS AS (
  IF(status = 1, CONCAT(user_id, '-', airline_code), NULL)
) STORED

UNIQUE INDEX uk_user_airline_active(uk_guard)
-- 效果: 同一用户同一航司只能有一个有效身份, 退出/过期后可重新加入
```

### 3.3 订单三层架构

```
order (主订单/大订单)
  │  一个C端会员的一次下单行为 = 一个主订单
  │  包含支付/金额汇总/大客户关联等
  │
  ├── order_sales (销售业务订单) ──── 按业务类型(flight/train/hotel/mall)拆分
  │     │  绑销售员, 记录售价/服务费/保险费
  │     │  可关联大客户签约(contract_id/group_id)
  │     │
  │     ├── order_item_flight (机票子订单)
  │     │     人x程 = 最小操作单元
  │     │     含航班/舱位/票号/退改规则快照
  │     │     journey_id 关联同一行程多程
  │     │     parent_item_id 关联改签前后
  │     │
  │     ├── order_item_train (火车票子订单)
  │     │     人x程, 含车次/座位/车厢号
  │     │
  │     ├── order_item_hotel (酒店子订单)
  │     │     人x晚x间, 含入住/离店/取消政策
  │     │
  │     └── order_item_mall (商城子订单)
  │           商品件, 含SKU/物流/积分抵扣
  │
  ├── order_procurement (采购业务订单) ──── 按供应商渠道拆分
  │     │  绑采购员, 记录成本/结算
  │     │  supplier_type: airline_b2b/ota_ctrip/railway_12306/...
  │     │
  │     └── order_procure_item (采购子订单)
  │           通过 biz_type + sales_item_id 多态关联销售子订单
  │           含成本价/供应商票号/PNR/重试调度
  │
  └── order_change (变更记录)
        退票/改签/签转/取消
        通过 origin_item_ids / new_item_ids 关联子订单
```

**销售/采购分轨设计**:
```
C端下单 → order → order_sales (售价侧)
                    │
                    └── order_item_flight/train/hotel/mall
                          │ sales_item_id
                          ▼
                    order_procure_item ← order_procurement (成本侧)
```

### 3.4 航空基础数据模型

```
air_airline (航司)
  ├── air_cabin_level (舱位等级: 经济/公务/头等)
  │     └── air_cabin (舱位明细: Y/B/M/K...)
  ├── air_fuel (燃油费, 按里程分档)
  │     └── air_fuel_detail (航程里程)
  ├── air_gauge_type (客规时段定义)
  │     └── air_gauge (退改签规则)
  ├── air_airline_accounts (采购账号)
  ├── air_airline_notice (预定须知)
  └── (间接) air_platform (采购平台)

air_airport (机场) ←── air_region (行政区划, city_iata_code关联)
air_plane_model (机型, 含机建费)
```

---

## 四、核心业务流程

### 4.1 大客户自动申报流程

```
C端用户下单(机票)
  │
  ├── 1. 查询用户是否已有 c_member_corporate (该航司有效身份)
  │     └── 有 → 直接应用大客户价, 出票时写入前置指令
  │
  └── 无 → 2. 遍历 corporate_policy_rule 匹配
        │     条件: 航司/航线/舱位/折扣/行程类型
        │
        ├── 匹配成功 → 3. 创建 c_member_corporate_apply
        │     │     (uk_guard防重复提交)
        │     │
        │     ├── auto_submit=1 → 自动提交申报(API/文件)
        │     │     ├── 审核通过 → 写入 c_member_corporate
        │     │     └── 审核拒绝 → 记录原因, 不影响原订单
        │     │
        │     └── auto_submit=2 → 仅提示, 需人工确认
        │
        └── 匹配失败 → 按普通票处理
  
  记录: corporate_policy_match_log (全量匹配日志)
```

### 4.2 大客户白名单提交流程

```
选择 corporate_whitelist_template (航司模板)
  │
  ├── API方式:
  │     逐条 → c_member_corporate_apply (submit_method=api)
  │     批量 → corporate_whitelist_batch + corporate_whitelist_member
  │
  └── 文件方式:
        上传Excel → corporate_whitelist_batch (file_id)
        解析 → corporate_whitelist_member (逐行)
          │
          ├── 匹配系统用户 (user_id/member_id/passenger_id 回填)
          │     match_status: 0=未匹配, 1=已匹配, 2=多人需人工, 3=失败
          │
          └── 提交航司
                submit_status: 1=待提交 → 2=已提交 → 3=已通过/4=已拒绝
                审核通过 → 写入 c_member_corporate.corporate_member_id
```

### 4.3 订单全生命周期

```
C端下单 → order(待支付)
  │
  ├── 支付成功 → order(已支付/处理中)
  │     │
  │     ├── order_sales(待处理) → 分配销售员
  │     │     └── order_item_*(待处理)
  │     │
  │     └── order_procurement(待采购) → 分配采购员
  │           └── order_procure_item(待采购) → 供应商出票
  │                 │
  │                 ├── 出票成功 → 回填票号/PNR → order_item_*(已出票)
  │                 └── 出票失败 → 重试/换渠道 → order_procure_item(采购失败)
  │
  ├── 退票/改签 → order_change
  │     ├── 退票: origin_item_ids → 退款 → order_item_*(已退票)
  │     └── 改签: origin_item_ids → 新item → order_item_*(已改签)
  │
  └── 全部完成 → order(全部完成)
```

---

## 五、复核发现的问题与改进建议

### 5.1 必须修复 (BUG)

#### BUG-1: 类型不匹配 — corporate_policy_match_log / corporate_policy_rule

**现状**: 这两张表的 `contract_id` 和 `group_id` 使用 `int UNSIGNED`, 但被引用表 `corporate_contract.id` 和 `corporate_group.id` 是 `bigint UNSIGNED`。

**影响**: 当ID超过 2^32-1 (约42亿) 时关联失败; JOIN时类型不匹配导致隐式转换, 索引失效。

**修复**:
```sql
-- corporate_policy_match_log
ALTER TABLE corporate_policy_match_log
  MODIFY contract_id bigint UNSIGNED NOT NULL COMMENT '签约ID',
  MODIFY group_id bigint UNSIGNED NOT NULL COMMENT '集团ID';

-- corporate_policy_rule
ALTER TABLE corporate_policy_rule
  MODIFY contract_id bigint UNSIGNED NOT NULL COMMENT '大客户签约ID',
  MODIFY group_id bigint UNSIGNED NOT NULL COMMENT '大客户集团ID';
```

#### BUG-2: order_item_mall 字段冗余 — product_id 与 goods_id

**现状**: `product_id` (line 1329, COMMENT '商品ID(goods_id)') 和 `goods_id` (line 1337, COMMENT '商品ID') 指向同一实体, 存在语义重复。

**修复**: 保留 `goods_id`, 移除 `product_id`; 或者统一为 `product_id` 并移除 `goods_id`。建议统一为 `product_id` 以保持与其他 item 表一致。同时 `product_snapshot` 已经包含商品快照信息。

#### BUG-3: 唯一索引缺少 deleted_at — 软删除后无法重建

**现状**: 以下唯一索引不包含 `deleted_at`, 软删除后同名记录无法创建:
- `corporate_group.uk_group_code(group_code)` — 删除华为后无法新建华为
- `corporate_contract.uk_group_airline(group_id, airline_code)` — 删除后无法重建签约

**对比**: `air_airline.uk_code(code, deleted_at)` / `air_airport.uk_code(code, deleted_at)` 已正确包含 deleted_at。

**修复**:
```sql
ALTER TABLE corporate_group
  DROP INDEX uk_group_code,
  ADD UNIQUE INDEX uk_group_code(group_code, deleted_at);

ALTER TABLE corporate_contract
  DROP INDEX uk_group_airline,
  ADD UNIQUE INDEX uk_group_airline(group_id, airline_code, deleted_at);
```

### 5.2 建议改进 (Important)

#### IMP-1: air_cabin 日期字段类型不当

**现状**: `effect_start` / `effect_end` 为 `varchar(30)`

**问题**: 无法做日期范围查询, 无法用索引做日期比较

**建议**: 改为 `date` 或 `datetime` 类型
```sql
ALTER TABLE air_cabin
  MODIFY effect_start date NULL DEFAULT NULL COMMENT '生效日期',
  MODIFY effect_end date NULL DEFAULT NULL COMMENT '失效日期';
```

#### IMP-2: 字段类型不一致 — airline_code

**现状**:
| 表 | 字段 | 类型 | 应为 |
|----|------|------|------|
| c_member_corporate | airline_code | varchar(10) | char(2) |
| c_member_corporate_apply | airline_code | varchar(10) | char(2) |
| order_item_flight | carrier_code | varchar(5) | char(2) |

**建议**: 航司二字码全局统一使用 `char(2)`, 节省空间且语义明确

#### IMP-3: 字段类型不一致 — airport code

**现状**:
| 表 | 字段 | 类型 | 应为 |
|----|------|------|------|
| order_item_flight | departure_code | varchar(5) | char(3) |
| order_item_flight | arrival_code | varchar(5) | char(3) |

**建议**: 机场三字码全局统一使用 `char(3)`

#### IMP-4: FK 哨兵值应使用 NULL 而非 0

**现状**: 以下字段默认值 0 表示"无关联", 语义上应为 NULL:
- `order.parent_order_id` DEFAULT 0
- `order.contract_id` DEFAULT 0
- `order.group_id` DEFAULT 0
- `c_member_corporate.policy_id` DEFAULT 0
- `c_member_corporate.apply_id` DEFAULT 0
- `order_item_flight.parent_item_id` DEFAULT 0
- `order_item_flight.change_id` DEFAULT 0
- ... (多处类似)

**影响**: 0 不是有效ID, 查询时需要 `WHERE parent_order_id != 0` 而非更直观的 `WHERE parent_order_id IS NOT NULL`; 且 0 值可能误命中 ID=0 的记录。

**建议**: 全部改为 `NULL DEFAULT NULL`, 查询使用 `IS NULL` / `IS NOT NULL`

#### IMP-5: 时间戳字段风格不统一

**现状**:
- 航空基础数据表: `timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP`
- C端/订单表: `datetime NULL DEFAULT NULL`

**影响**: `timestamp` 有2038年上限且受时区影响; `datetime` 无上限但需应用层写入。

**建议**: 短期可容忍不一致; 长期统一为 `datetime` + 应用层写入, 或统一为 `timestamp` + DEFAULT。不建议混用。

### 5.3 设计缺口 (未来需补建)

| # | 缺失表 | 优先级 | 说明 |
|---|--------|--------|------|
| 1 | payment_record | 高 | 支付流水记录(目前order只有payment_no单字段) |
| 2 | settlement_record | 高 | 采购结算记录(目前只有settle_amount汇总) |
| 3 | reconciliation_sheet | 高 | 对账单(航司/供应商月结对账) |
| 4 | flight_product | 中 | 航班产品/运价(目前order_item_flight.product_id无对应表) |
| 5 | hotel_product | 中 | 酒店产品/房型库存 |
| 6 | train_product | 中 | 火车票产品/座席库存 |
| 7 | goods / goods_sku | 中 | 商城商品/SKU(order_item_mall引用但无表) |
| 8 | notification | 中 | 站内信/推送记录 |
| 9 | audit_log | 低 | 通用审计日志(关键数据变更追踪) |
| 10 | flight_change_notice | 中 | 航变通知(航班取消/延误/换机型) |

---

## 六、关键索引策略

### 6.1 脱敏字段的唯一/查找索引

所有敏感字段采用 **hash 索引** 实现精确查找和唯一约束:
```sql
-- c_user: 手机号唯一
UNIQUE INDEX uk_phone_hash(phone_hash)

-- c_user: 证件号唯一(同一证件类型)
UNIQUE INDEX uk_id_type_hash(id_type, id_number_hash)

-- c_passenger: 同一商户同一会员下证件不重复
UNIQUE INDEX uk_tenant_member_id_hash(tenant_id, member_id, id_type, id_number_hash)
```

### 6.2 部分唯一索引 (uk_guard 生成列)

```sql
-- c_member_corporate: 同一用户同一航司仅一条有效身份
uk_guard = IF(status = 1, CONCAT(user_id, '-', airline_code), NULL)
UNIQUE INDEX uk_user_airline_active(uk_guard)

-- c_member_corporate_apply: 同一用户同一航司无重复待审核申报
uk_guard = IF(submit_status IN (1,2,3), CONCAT(user_id, '-', airline_code), NULL)
UNIQUE INDEX uk_user_airline_pending(uk_guard)
```

### 6.3 核心查询索引

| 表 | 索引 | 覆盖场景 |
|----|------|----------|
| order | idx_tenant_status(tenant_id, status, created_at) | 商户订单列表+筛选 |
| order | idx_tenant_member(tenant_id, member_id, status) | 会员订单查询 |
| order_item_flight | idx_carrier_flight(carrier_code, flight_no, departure_time) | 航班维度统计 |
| order_item_flight | idx_route(departure_code, arrival_code, departure_time) | 航线维度统计 |
| order_procure_item | idx_status_retry(status, next_retry_at) | 采购重试调度 |
| c_member_corporate_apply | idx_status_retry(submit_status, next_retry_at) | 申报重试调度 |

---

## 七、数据安全设计

### 7.1 零外键策略

全库无 FOREIGN KEY 约束, 所有关联由应用层 ORM (Hyperf Model) 维护。
- 优势: 写入性能, 灵活删数据, 无级联风险
- 风险: 需应用层严格保证引用完整性
- 对策: ORM 层做关联校验 + 定期数据一致性巡检

### 7.2 软删除策略

| 策略 | 适用表 | deleted_at |
|------|--------|------------|
| 软删除 | 基础配置表(航司/机场/舱位/客规...) | timestamp NULL |
| 状态机 | 业务流转表(订单/采购/申报...) | 无, 用status字段 |
| 永久保留 | 审计日志表(匹配日志/登录日志...) | 无 |

---

## 八、ER关系速查

```
tenant ─────────────────────────────────────────────────────┐
  │ tenant_id 隔离                                           │
  ├── tmc_user / tmc_role / tmc_department / tmc_position   │
  ├── mmc_user / mmc_role / mmc_department / mmc_position   │
  └── c_member / c_member_address / c_passenger              │
                                                              │
c_user (平台级, 无 tenant_id)                                 │
  ├── 1:N → c_member (通过 user_id)                          │
  └── 1:N → c_member_corporate (通过 user_id)               │
                                                              │
corporate_group (平台级)                                      │
  └── 1:N → corporate_contract (group_id)                   │
        ├── 1:N → corporate_policy (contract_id)             │
        ├── 1:N → corporate_policy_rule (contract_id)        │
        ├── 1:N → c_member_corporate (contract_id)          │
        ├── 1:N → c_member_corporate_apply (contract_id)    │
        └── 1:1 → corporate_whitelist_template (whitelist_tpl_id)
              └── 1:N → corporate_whitelist_batch (template_id)
                    └── 1:N → corporate_whitelist_member (batch_id)
                                                              │
order (tenant_id 隔离) ◄─────────────────────────────────────┘
  ├── 1:N → order_sales (order_id)
  │     └── 1:N → order_item_*/order_procure_item (sales_id)
  ├── 1:N → order_procurement (order_id)
  │     └── 1:N → order_procure_item (procurement_id)
  └── 1:N → order_change (order_id)
```

---

## 九、附录: 表关系卡片

### A. 订单 → 子订单关联路径

```
order.id
  ├── order_sales.order_id → order_sales.id
  │     ├── order_item_flight.sales_id
  │     ├── order_item_train.sales_id
  │     ├── order_item_hotel.sales_id
  │     └── order_item_mall.sales_id
  │
  ├── order_procurement.order_id → order_procurement.id
  │     └── order_procure_item.procurement_id
  │           └── order_procure_item.sales_item_id (多态: biz_type决定指向哪个item表)
  │
  └── order_change.order_id
        ├── order_change.sales_id → order_sales.id
        └── order_change.origin_item_ids / new_item_ids (JSON, 按biz_type对应不同item表)
```

### B. 大客户校验流程 (出票时)

```
1. 取 order.contract_id → corporate_contract
2. 检查 contract.is_realname:
   ├── 实名制 → 查 c_member_corporate(user_id, airline_code, status=1)
   │     └── 无有效身份 → 拒绝出票或按普通票处理
   └── 非实名 → 检查 passenger 年龄是否在 [age_min, age_max] 范围内
3. 检查 contract.exclude_dates (JSON黑名单日期)
4. 写入前置指令:
   ├── 国内: contract.pre_cmd_domestic → PNR 中 RMK/SSR
   └── 国际: contract.pre_cmd_intl → PNR 中 SSR
5. 运价指令:
   ├── 国内: contract.price_cmd_domestic → PAT:A#CDK...
   └── 国际: contract.price_cmd_intl → QTE:/CZ///#CV...
```

---

> 文档版本: v7 | 生成日期: 2025-07 | 总表数: 84 (基础设施48 + 业务36)
