-- ============================================================
-- 温州华夏航服B2B2C平台 - 数据字典新增表 (MySQL 8.0+)
-- 生成日期: 2026-06-27
-- 说明: 基于 04_数据字典_新增表.md 自动生成
-- 字符集: utf8mb4 | 排序: utf8mb4_unicode_ci | 引擎: InnoDB
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 一、审批流程系统 (8张表)
-- ============================================================

-- 1.1 审批流程定义表
DROP TABLE IF EXISTS `approval_flow`;
CREATE TABLE `approval_flow` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL DEFAULT 0 COMMENT '租户ID(0=全局)',
  `flow_code` VARCHAR(64) NOT NULL COMMENT '流程编码 如WF202606140001',
  `flow_name` VARCHAR(128) NOT NULL COMMENT '流程名称',
  `flow_type` VARCHAR(32) NOT NULL COMMENT '流程类型: travel_approval=差旅审批, expense_approval=费用审批',
  `version` INT NOT NULL DEFAULT 1 COMMENT '流程版本',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0=草稿, 1=已发布, 2=已停用',
  `description` TEXT DEFAULT NULL COMMENT '流程描述',
  `created_by` BIGINT DEFAULT NULL COMMENT '创建人',
  `published_at` DATETIME DEFAULT NULL COMMENT '发布时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_flow_code_version` (`tenant_id`, `flow_code`, `version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批流程定义表';

-- 1.2 审批流程节点表
DROP TABLE IF EXISTS `approval_node`;
CREATE TABLE `approval_node` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `flow_id` BIGINT NOT NULL COMMENT 'FK→approval_flow.id',
  `node_code` VARCHAR(64) NOT NULL COMMENT '节点编码',
  `node_name` VARCHAR(128) NOT NULL COMMENT '节点名称',
  `node_type` VARCHAR(32) NOT NULL COMMENT '节点类型: start=开始, condition=条件分支, approval=人工审批, auto_pass=自动通过, auto_reject=自动拒绝, end=结束',
  `approval_type` VARCHAR(32) DEFAULT NULL COMMENT '审批类型: manual=人工审核, auto_pass=自动通过, auto_reject=自动拒绝',
  `approver_type` VARCHAR(32) DEFAULT NULL COMMENT '审批人类型: role=角色, superior=上级, self=发起人, specified=指定成员, multi_superior=连续多级上级, self_select=自选',
  `approver_ids` JSON DEFAULT NULL COMMENT '审批人ID列表(JSON数组)',
  `multi_approval_mode` VARCHAR(32) DEFAULT NULL COMMENT '多人审批方式: sequential=依次审批, countersign=会签, or_sign=或签',
  `empty_handler` VARCHAR(32) DEFAULT NULL COMMENT '审批人为空处理: admin=转交审批管理员, specified=指定人员',
  `empty_handler_id` BIGINT DEFAULT NULL COMMENT '指定人员ID',
  `position_x` INT DEFAULT NULL COMMENT '画布X坐标',
  `position_y` INT DEFAULT NULL COMMENT '画布Y坐标',
  `sort_order` INT DEFAULT NULL COMMENT '排序',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_flow_id` (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批流程节点表';

-- 1.3 审批流程连线表
DROP TABLE IF EXISTS `approval_edge`;
CREATE TABLE `approval_edge` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `flow_id` BIGINT NOT NULL COMMENT 'FK→approval_flow.id',
  `from_node_id` BIGINT NOT NULL COMMENT 'FK→approval_node.id 源节点',
  `to_node_id` BIGINT NOT NULL COMMENT 'FK→approval_node.id 目标节点',
  `edge_type` VARCHAR(32) NOT NULL COMMENT '连线类型: normal=正常, condition=条件分支',
  `condition_group_id` BIGINT DEFAULT NULL COMMENT '条件组ID',
  `label` VARCHAR(128) DEFAULT NULL COMMENT '连线标签',
  `sort_order` INT DEFAULT NULL COMMENT '排序',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_flow_id` (`flow_id`),
  KEY `idx_from_node` (`from_node_id`),
  KEY `idx_to_node` (`to_node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批流程连线表';

-- 1.4 审批条件组表
DROP TABLE IF EXISTS `approval_condition_group`;
CREATE TABLE `approval_condition_group` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `node_id` BIGINT NOT NULL COMMENT 'FK→approval_node.id 条件分支节点',
  `group_name` VARCHAR(128) DEFAULT NULL COMMENT '条件组名称',
  `is_default` TINYINT NOT NULL DEFAULT 0 COMMENT '是否默认分支(0=否, 1=是)',
  `sort_order` INT DEFAULT NULL COMMENT '排序',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_node_id` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批条件组表';

-- 1.5 审批条件项表
DROP TABLE IF EXISTS `approval_condition_item`;
CREATE TABLE `approval_condition_item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_id` BIGINT NOT NULL COMMENT 'FK→approval_condition_group.id',
  `field_key` VARCHAR(64) NOT NULL COMMENT '条件字段: amount/days/department等',
  `operator` VARCHAR(32) NOT NULL COMMENT '运算符: eq=等于, neq=不等于, gt=大于, gte=大于等于, lt=小于, lte=小于等于, in=包含, between=区间',
  `field_value` JSON NOT NULL COMMENT '条件值(JSON)',
  `logic` VARCHAR(8) NOT NULL DEFAULT 'AND' COMMENT '逻辑: AND/OR',
  `sort_order` INT DEFAULT NULL COMMENT '排序',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批条件项表';

-- 1.6 审批表单设计表
DROP TABLE IF EXISTS `approval_form`;
CREATE TABLE `approval_form` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `flow_id` BIGINT NOT NULL COMMENT 'FK→approval_flow.id',
  `form_name` VARCHAR(128) NOT NULL COMMENT '表单名称',
  `form_config` JSON NOT NULL COMMENT '表单配置(字段列表/验证规则/布局)',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_flow_id` (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批表单设计表';

-- 1.7 审批实例表(运行时)
DROP TABLE IF EXISTS `approval_instance`;
CREATE TABLE `approval_instance` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
  `flow_id` BIGINT NOT NULL COMMENT 'FK→approval_flow.id',
  `flow_version` INT NOT NULL COMMENT '流程版本',
  `instance_no` VARCHAR(64) NOT NULL COMMENT '审批单号',
  `title` VARCHAR(256) NOT NULL COMMENT '审批标题',
  `form_data` JSON DEFAULT NULL COMMENT '表单数据',
  `biz_type` VARCHAR(32) DEFAULT NULL COMMENT '业务类型: flight/hotel/train',
  `biz_id` BIGINT DEFAULT NULL COMMENT '业务ID',
  `mode_type` VARCHAR(32) DEFAULT NULL COMMENT '审批模式: pre_order=先审后单, approval_order=审批下单, post_order=先付后审',
  `initiator_id` BIGINT NOT NULL COMMENT '发起人ID',
  `initiator_type` VARCHAR(16) NOT NULL COMMENT '发起人类型: mmc_user=MMC用户, c_user=C端用户',
  `current_node_id` BIGINT DEFAULT NULL COMMENT '当前节点ID',
  `status` VARCHAR(32) NOT NULL COMMENT '状态: pending=审批中, approved=已通过, rejected=已拒绝, cancelled=已撤销, terminated=已终止',
  `submit_at` DATETIME DEFAULT NULL COMMENT '提交时间',
  `finish_at` DATETIME DEFAULT NULL COMMENT '完成时间',
  `approval_deadline` DATETIME DEFAULT NULL COMMENT '审批期限(模式3)',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instance_no` (`instance_no`),
  KEY `idx_tenant_id` (`tenant_id`),
  KEY `idx_flow_id` (`flow_id`),
  KEY `idx_initiator` (`initiator_id`, `initiator_type`),
  KEY `idx_status` (`status`),
  KEY `idx_biz` (`biz_type`, `biz_id`),
  KEY `idx_trace_id` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批实例表(运行时)';

-- 1.8 审批记录表(运行时)
DROP TABLE IF EXISTS `approval_record`;
CREATE TABLE `approval_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` BIGINT NOT NULL COMMENT 'FK→approval_instance.id',
  `node_id` BIGINT NOT NULL COMMENT 'FK→approval_node.id',
  `node_name` VARCHAR(128) DEFAULT NULL COMMENT '节点名称(冗余)',
  `handler_id` BIGINT NOT NULL COMMENT '处理人ID',
  `handler_name` VARCHAR(64) DEFAULT NULL COMMENT '处理人姓名(冗余)',
  `handler_type` VARCHAR(16) NOT NULL COMMENT '处理人类型: mmc_user=MMC用户, system=系统',
  `action` VARCHAR(32) NOT NULL COMMENT '操作: approve=同意, reject=拒绝, transfer=转交, cancel=撤销, terminate=终止',
  `opinion` TEXT DEFAULT NULL COMMENT '审批意见',
  `transfer_to_id` BIGINT DEFAULT NULL COMMENT '转交目标ID',
  `transfer_to_name` VARCHAR(64) DEFAULT NULL COMMENT '转交目标姓名',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_instance_id` (`instance_id`),
  KEY `idx_handler` (`handler_id`, `handler_type`),
  KEY `idx_trace_id` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批记录表(运行时)';

-- ============================================================
-- 二、采购渠道与规则 (5张表)
-- ============================================================

-- 2.1 采购渠道表
DROP TABLE IF EXISTS `procurement_channel`;
CREATE TABLE `procurement_channel` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `channel_code` VARCHAR(64) NOT NULL COMMENT '渠道编码(唯一)',
  `channel_name` VARCHAR(128) NOT NULL COMMENT '渠道名称',
  `channel_type` VARCHAR(32) NOT NULL COMMENT '渠道类型: airline_b2b=航司B2B, travelport=中航信, third_party=第三方接口, manual=人工外采',
  `supplier_type` VARCHAR(32) DEFAULT NULL COMMENT '供应类型: flight=机票, hotel=酒店, train=火车票, insurance=保险',
  `api_url` VARCHAR(512) DEFAULT NULL COMMENT '接口地址',
  `api_config` JSON DEFAULT NULL COMMENT '接口配置(认证方式/参数映射)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_code` (`channel_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购渠道表';

-- 2.2 采购渠道账号表
DROP TABLE IF EXISTS `procurement_account`;
CREATE TABLE `procurement_account` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `channel_id` BIGINT NOT NULL COMMENT 'FK→procurement_channel.id',
  `tmc_tenant_id` BIGINT NOT NULL COMMENT 'TMC租户ID',
  `account_name` VARCHAR(128) DEFAULT NULL COMMENT '账号名称',
  `account_no` VARCHAR(128) DEFAULT NULL COMMENT '账号',
  `account_config` JSON DEFAULT NULL COMMENT '认证配置(加密存储)',
  `quota_limit` INT DEFAULT NULL COMMENT '调用配额限制',
  `quota_used` INT DEFAULT NULL COMMENT '已使用配额',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_channel_id` (`channel_id`),
  KEY `idx_tmc_tenant_id` (`tmc_tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购渠道账号表';

-- 2.3 自动采购规则表
DROP TABLE IF EXISTS `procurement_rule`;
CREATE TABLE `procurement_rule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '规则所属租户(0=PMC全局)',
  `tenant_type` VARCHAR(16) NOT NULL COMMENT '租户类型: pmc=平台, tmc=集团, mmc=商户',
  `rule_name` VARCHAR(128) NOT NULL COMMENT '规则名称',
  `product_type` VARCHAR(32) NOT NULL COMMENT '产品类型: flight/hotel/train',
  `airline_code` VARCHAR(16) DEFAULT NULL COMMENT '航司代码(空=不限)',
  `departure_code` VARCHAR(16) DEFAULT NULL COMMENT '出发城市代码',
  `arrival_code` VARCHAR(16) DEFAULT NULL COMMENT '到达城市代码',
  `cabin_class` VARCHAR(16) DEFAULT NULL COMMENT '舱位等级',
  `price_min` DECIMAL(12,2) DEFAULT NULL COMMENT '金额范围-最小',
  `price_max` DECIMAL(12,2) DEFAULT NULL COMMENT '金额范围-最大',
  `time_start` TIME DEFAULT NULL COMMENT '有效时间-开始',
  `time_end` TIME DEFAULT NULL COMMENT '有效时间-结束',
  `week_days` VARCHAR(16) DEFAULT NULL COMMENT '有效星期(1-7逗号分隔)',
  `channel_id` BIGINT DEFAULT NULL COMMENT 'FK→procurement_channel.id',
  `procurement_type` VARCHAR(16) NOT NULL COMMENT '采购方式: auto=自动, manual=手动',
  `verify_threshold_type` VARCHAR(16) DEFAULT NULL COMMENT '验价阈值类型: percent=百分比, fixed=固定值',
  `verify_threshold_value` DECIMAL(12,2) DEFAULT NULL COMMENT '验价阈值',
  `priority` INT NOT NULL DEFAULT 0 COMMENT '优先级(越大越优先)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant` (`tenant_id`, `tenant_type`),
  KEY `idx_product_type` (`product_type`),
  KEY `idx_channel_id` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='自动采购规则表';

-- 2.4 采购验价日志表
DROP TABLE IF EXISTS `procurement_verify_log`;
CREATE TABLE `procurement_verify_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` BIGINT NOT NULL COMMENT '关联订单ID',
  `order_item_id` BIGINT NOT NULL COMMENT '关联订单项ID',
  `channel_id` BIGINT DEFAULT NULL COMMENT 'FK→procurement_channel.id',
  `cache_price` DECIMAL(12,2) DEFAULT NULL COMMENT '缓存价格',
  `real_price` DECIMAL(12,2) DEFAULT NULL COMMENT '实时验价',
  `threshold_type` VARCHAR(16) DEFAULT NULL COMMENT '验价阈值类型',
  `threshold_value` DECIMAL(12,2) DEFAULT NULL COMMENT '验价阈值',
  `price_diff` DECIMAL(12,2) DEFAULT NULL COMMENT '价格差异',
  `verify_result` VARCHAR(16) NOT NULL COMMENT '验价结果: pass=通过, fail=不通过, retry=重试',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_channel_id` (`channel_id`),
  KEY `idx_trace_id` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购验价日志表';

-- 2.5 外采核销记录表
DROP TABLE IF EXISTS `procurement_reconciliation`;
CREATE TABLE `procurement_reconciliation` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tmc_tenant_id` BIGINT NOT NULL COMMENT 'TMC租户ID',
  `batch_no` VARCHAR(64) NOT NULL COMMENT '导入批次号',
  `order_id` BIGINT DEFAULT NULL COMMENT '关联订单ID',
  `order_item_id` BIGINT DEFAULT NULL COMMENT '关联订单项ID',
  `pnr` VARCHAR(64) DEFAULT NULL COMMENT 'PNR',
  `ticket_no` VARCHAR(64) DEFAULT NULL COMMENT '票号',
  `procurement_price` DECIMAL(12,2) DEFAULT NULL COMMENT '采购价',
  `status` VARCHAR(16) NOT NULL COMMENT '状态: pending=待核销, matched=已匹配, failed=匹配失败',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_tmc_tenant_id` (`tmc_tenant_id`),
  KEY `idx_batch_no` (`batch_no`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_trace_id` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='外采核销记录表';

-- ============================================================
-- 三、销售策略 (2张表)
-- ============================================================

-- 3.1 加价规则表
DROP TABLE IF EXISTS `pricing_rule`;
CREATE TABLE `pricing_rule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '规则所属租户',
  `tenant_type` VARCHAR(16) NOT NULL COMMENT '租户类型: tmc=集团, mmc=商户',
  `rule_name` VARCHAR(128) NOT NULL COMMENT '规则名称',
  `product_type` VARCHAR(32) NOT NULL COMMENT '产品类型: flight/hotel/train',
  `markup_type` VARCHAR(16) NOT NULL COMMENT '加价类型: fixed=固定加价, percent=比例加价, mixed=固定+比例',
  `fixed_amount` DECIMAL(12,2) DEFAULT NULL COMMENT '固定加价金额',
  `percent_rate` DECIMAL(5,4) DEFAULT NULL COMMENT '浮动比例(0.0500=5%)',
  `min_markup` DECIMAL(12,2) DEFAULT NULL COMMENT '最低加价(比例时保底)',
  `max_markup` DECIMAL(12,2) DEFAULT NULL COMMENT '最高加价(比例时封顶)',
  `service_fee` DECIMAL(12,2) DEFAULT NULL COMMENT '服务费',
  `priority` INT NOT NULL DEFAULT 0 COMMENT '优先级',
  `effective_start` DATETIME DEFAULT NULL COMMENT '生效开始',
  `effective_end` DATETIME DEFAULT NULL COMMENT '生效结束',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant` (`tenant_id`, `tenant_type`),
  KEY `idx_product_type` (`product_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='加价规则表';

-- 3.2 服务费规则表
DROP TABLE IF EXISTS `service_fee_rule`;
CREATE TABLE `service_fee_rule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
  `tenant_type` VARCHAR(16) NOT NULL COMMENT '租户类型: tmc/mmc',
  `rule_name` VARCHAR(128) NOT NULL COMMENT '规则名称',
  `product_type` VARCHAR(32) NOT NULL COMMENT '产品类型: flight/hotel/train',
  `fee_type` VARCHAR(32) NOT NULL COMMENT '费用类型: booking=订座费, ticketing=出票费, refund=退票费, change=改签费, service=服务费',
  `calc_type` VARCHAR(16) NOT NULL COMMENT '计算方式: fixed=固定, percent=比例, tiered=阶梯',
  `tiered_config` JSON DEFAULT NULL COMMENT '阶梯配置',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant` (`tenant_id`, `tenant_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务费规则表';

-- ============================================================
-- 四、结算方式配置 (1张表)
-- ============================================================

DROP TABLE IF EXISTS `settlement_config`;
CREATE TABLE `settlement_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '上级租户ID(TMC或PMC)',
  `target_tenant_id` BIGINT NOT NULL COMMENT '下级租户ID(MMC或TMC)',
  `target_tenant_type` VARCHAR(16) NOT NULL COMMENT '下级类型: mmc=商户, tmc=集团',
  `settlement_type` VARCHAR(32) NOT NULL COMMENT '结算方式: prepaid=预付, monthly=月结, credit=信用额度, mixed=混合',
  `credit_amount` DECIMAL(14,2) DEFAULT NULL COMMENT '信用额度',
  `credit_used` DECIMAL(14,2) NOT NULL DEFAULT 0.00 COMMENT '已使用信用额度',
  `credit_warning_rate` DECIMAL(5,4) DEFAULT NULL COMMENT '额度预警比例(0.8000=80%)',
  `credit_frozen` TINYINT NOT NULL DEFAULT 0 COMMENT '是否冻结(0=否, 1=是)',
  `monthly_settle_day` INT DEFAULT NULL COMMENT '月结出账日(每月几号)',
  `monthly_payment_day` INT DEFAULT NULL COMMENT '月结付款日(每月几号前)',
  `payment_terms` INT DEFAULT NULL COMMENT '付款期限(天)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant_id` (`tenant_id`),
  KEY `idx_target_tenant` (`target_tenant_id`, `target_tenant_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='结算方式配置表';

-- ============================================================
-- 五、分润管理 (2张表)
-- ============================================================

-- 5.1 分润规则表
DROP TABLE IF EXISTS `profit_sharing_rule`;
CREATE TABLE `profit_sharing_rule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '上级租户ID(PMC或TMC)',
  `target_tenant_id` BIGINT NOT NULL COMMENT '下级租户ID(TMC或MMC)',
  `rule_name` VARCHAR(128) NOT NULL COMMENT '规则名称',
  `product_type` VARCHAR(32) NOT NULL COMMENT '产品类型: flight/hotel/train',
  `calc_type` VARCHAR(16) NOT NULL COMMENT '计算方式: fixed=固定金额, percent=比例, tiered=阶梯',
  `calc_config` JSON DEFAULT NULL COMMENT '计算配置(固定值/比例值/阶梯规则)',
  `sharing_timing` VARCHAR(16) NOT NULL COMMENT '分润时机: order=按订单, period=按周期',
  `period_type` VARCHAR(16) DEFAULT NULL COMMENT '周期类型: weekly=周, monthly=月(按周期时)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant` (`tenant_id`),
  KEY `idx_target_tenant` (`target_tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分润规则表';

-- 5.2 分润记录表
DROP TABLE IF EXISTS `profit_sharing_log`;
CREATE TABLE `profit_sharing_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rule_id` BIGINT DEFAULT NULL COMMENT 'FK→profit_sharing_rule.id',
  `order_id` BIGINT DEFAULT NULL COMMENT '关联订单',
  `from_tenant_id` BIGINT NOT NULL COMMENT '付款方租户ID',
  `to_tenant_id` BIGINT NOT NULL COMMENT '收款方租户ID',
  `order_amount` DECIMAL(12,2) DEFAULT NULL COMMENT '订单金额',
  `sharing_amount` DECIMAL(12,2) NOT NULL COMMENT '分润金额',
  `calc_detail` JSON DEFAULT NULL COMMENT '计算明细',
  `status` VARCHAR(16) NOT NULL COMMENT '状态: pending=待结算, settled=已结算, failed=失败',
  `settled_at` DATETIME DEFAULT NULL COMMENT '结算时间',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_rule_id` (`rule_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_from_tenant` (`from_tenant_id`),
  KEY `idx_to_tenant` (`to_tenant_id`),
  KEY `idx_status` (`status`),
  KEY `idx_trace_id` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分润记录表';

-- ============================================================
-- 六、通用售后系统 (4张表)
-- ============================================================

-- 6.1 全局售后总表
DROP TABLE IF EXISTS `after_sale`;
CREATE TABLE `after_sale` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
  `after_sale_no` VARCHAR(64) NOT NULL COMMENT '售后单号(唯一)',
  `order_id` BIGINT NOT NULL COMMENT '关联订单ID',
  `order_item_id` BIGINT DEFAULT NULL COMMENT '关联订单项ID',
  `biz_type` VARCHAR(32) NOT NULL COMMENT '业务类型: flight/hotel/train/mall/car/insurance',
  `biz_id` BIGINT DEFAULT NULL COMMENT '业务售后表ID',
  `user_id` BIGINT NOT NULL COMMENT 'C端用户ID',
  `type` VARCHAR(32) NOT NULL COMMENT '售后类型: refund=退款, return=退货, exchange=换货, change=改签',
  `reason` VARCHAR(256) DEFAULT NULL COMMENT '售后原因',
  `amount` DECIMAL(12,2) DEFAULT NULL COMMENT '售后金额',
  `status` VARCHAR(32) NOT NULL COMMENT '状态: pending/approved/rejected/processing/completed/cancelled',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_after_sale_no` (`after_sale_no`),
  KEY `idx_tenant_id` (`tenant_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_biz_type` (`biz_type`, `biz_id`),
  KEY `idx_status` (`status`),
  KEY `idx_trace_id` (`trace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局售后总表';

-- 6.2 机票售后表
DROP TABLE IF EXISTS `after_sale_flight`;
CREATE TABLE `after_sale_flight` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `after_sale_id` BIGINT NOT NULL COMMENT 'FK→after_sale.id',
  `order_item_flight_id` BIGINT NOT NULL COMMENT '订单项-机票ID',
  `type` VARCHAR(32) NOT NULL COMMENT '售后类型: refund=退票, change=改签',
  `refund_fee` DECIMAL(12,2) DEFAULT NULL COMMENT '退票费',
  `refund_amount` DECIMAL(12,2) DEFAULT NULL COMMENT '退款金额',
  `change_flight_info` JSON DEFAULT NULL COMMENT '改签航班信息',
  `change_fee` DECIMAL(12,2) DEFAULT NULL COMMENT '改签费',
  `pnr` VARCHAR(64) DEFAULT NULL COMMENT 'PNR',
  `ticket_nos` TEXT DEFAULT NULL COMMENT '票号(逗号分隔)',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_after_sale_id` (`after_sale_id`),
  KEY `idx_order_item_flight_id` (`order_item_flight_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='机票售后表';

-- 6.3 酒店售后表
DROP TABLE IF EXISTS `after_sale_hotel`;
CREATE TABLE `after_sale_hotel` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `after_sale_id` BIGINT NOT NULL COMMENT 'FK→after_sale.id',
  `order_item_hotel_id` BIGINT NOT NULL COMMENT '订单项-酒店ID',
  `type` VARCHAR(32) NOT NULL COMMENT '售后类型: refund=退款, change=修改',
  `refund_amount` DECIMAL(12,2) DEFAULT NULL COMMENT '退款金额',
  `refund_fee` DECIMAL(12,2) DEFAULT NULL COMMENT '退款手续费',
  `change_room_info` JSON DEFAULT NULL COMMENT '修改房型信息',
  `change_fee` DECIMAL(12,2) DEFAULT NULL COMMENT '修改费',
  `check_in_date` DATE DEFAULT NULL COMMENT '入住日期',
  `check_out_date` DATE DEFAULT NULL COMMENT '离店日期',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_after_sale_id` (`after_sale_id`),
  KEY `idx_order_item_hotel_id` (`order_item_hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='酒店售后表';

-- 6.4 火车票售后表
DROP TABLE IF EXISTS `after_sale_train`;
CREATE TABLE `after_sale_train` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `after_sale_id` BIGINT NOT NULL COMMENT 'FK→after_sale.id',
  `order_item_train_id` BIGINT NOT NULL COMMENT '订单项-火车票ID',
  `type` VARCHAR(32) NOT NULL COMMENT '售后类型: refund=退票, change=改签',
  `refund_fee` DECIMAL(12,2) DEFAULT NULL COMMENT '退票费',
  `refund_amount` DECIMAL(12,2) DEFAULT NULL COMMENT '退款金额',
  `change_train_info` JSON DEFAULT NULL COMMENT '改签车次信息',
  `change_fee` DECIMAL(12,2) DEFAULT NULL COMMENT '改签费',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_after_sale_id` (`after_sale_id`),
  KEY `idx_order_item_train_id` (`order_item_train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='火车票售后表';

-- ============================================================
-- 七、评论系统 (2张表 - 按业务分表)
-- ============================================================

-- 7.1 订单评论表
DROP TABLE IF EXISTS `comment_order`;
CREATE TABLE `comment_order` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
  `order_id` BIGINT NOT NULL COMMENT '订单ID',
  `order_item_id` BIGINT DEFAULT NULL COMMENT '订单项ID',
  `biz_type` VARCHAR(32) NOT NULL COMMENT '业务类型: flight/hotel/train/car',
  `user_id` BIGINT NOT NULL COMMENT 'C端用户ID',
  `is_anonymous` TINYINT NOT NULL DEFAULT 0 COMMENT '是否匿名(0=否, 1=是)',
  `overall_score` TINYINT NOT NULL DEFAULT 5 COMMENT '综合评分(1-5)',
  `service_score` TINYINT DEFAULT NULL COMMENT '服务评分(1-5)',
  `price_score` TINYINT DEFAULT NULL COMMENT '价格评分(1-5)',
  `experience_score` TINYINT DEFAULT NULL COMMENT '体验评分(1-5)',
  `content` TEXT DEFAULT NULL COMMENT '评论内容',
  `reply_content` TEXT DEFAULT NULL COMMENT '商户/平台回复',
  `reply_at` DATETIME DEFAULT NULL COMMENT '回复时间',
  `reply_by` BIGINT DEFAULT NULL COMMENT '回复人ID',
  `append_content` TEXT DEFAULT NULL COMMENT '追评内容',
  `append_at` DATETIME DEFAULT NULL COMMENT '追评时间',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=隐藏, 1=显示',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant_id` (`tenant_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_biz_type` (`biz_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单评论表';

-- 7.2 评论图片表
DROP TABLE IF EXISTS `comment_image`;
CREATE TABLE `comment_image` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `comment_type` VARCHAR(32) NOT NULL COMMENT '评论类型: order/mall',
  `comment_id` BIGINT NOT NULL COMMENT '评论ID',
  `image_url` VARCHAR(512) NOT NULL COMMENT '图片URL',
  `sort_order` INT DEFAULT NULL COMMENT '排序',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_comment` (`comment_type`, `comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论图片表(通用)';

-- ============================================================
-- 八、收藏系统 (4张表 - 全局总表+业务附表)
-- ============================================================

-- 8.1 全局收藏总表
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` BIGINT NOT NULL COMMENT 'C端用户ID',
  `biz_type` VARCHAR(32) NOT NULL COMMENT '业务类型: flight/hotel/mall',
  `biz_id` BIGINT NOT NULL COMMENT '业务对象ID',
  `title` VARCHAR(256) DEFAULT NULL COMMENT '标题(冗余)',
  `image` VARCHAR(512) DEFAULT NULL COMMENT '封面图(冗余)',
  `mmc_tenant_id` BIGINT DEFAULT NULL COMMENT '归属商户ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_biz` (`user_id`, `biz_type`, `biz_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_biz_type` (`biz_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局收藏总表';

-- 8.2 机票收藏附表
DROP TABLE IF EXISTS `favorite_flight`;
CREATE TABLE `favorite_flight` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `favorite_id` BIGINT NOT NULL COMMENT 'FK→favorite.id',
  `departure_code` VARCHAR(16) NOT NULL COMMENT '出发城市代码',
  `arrival_code` VARCHAR(16) NOT NULL COMMENT '到达城市代码',
  `departure_name` VARCHAR(64) DEFAULT NULL COMMENT '出发城市名称',
  `arrival_name` VARCHAR(64) DEFAULT NULL COMMENT '到达城市名称',
  `airline_code` VARCHAR(16) DEFAULT NULL COMMENT '航司代码',
  `cabin_class` VARCHAR(16) DEFAULT NULL COMMENT '舱位等级',
  `price` DECIMAL(12,2) DEFAULT NULL COMMENT '收藏时价格',
  `flight_date` DATE DEFAULT NULL COMMENT '航班日期',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_favorite_id` (`favorite_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='机票收藏附表';

-- 8.3 酒店收藏附表
DROP TABLE IF EXISTS `favorite_hotel`;
CREATE TABLE `favorite_hotel` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `favorite_id` BIGINT NOT NULL COMMENT 'FK→favorite.id',
  `hotel_id` BIGINT NOT NULL COMMENT '酒店ID',
  `hotel_name` VARCHAR(256) DEFAULT NULL COMMENT '酒店名称',
  `city_code` VARCHAR(16) DEFAULT NULL COMMENT '城市代码',
  `star_rate` TINYINT DEFAULT NULL COMMENT '星级',
  `min_price` DECIMAL(12,2) DEFAULT NULL COMMENT '最低价',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_favorite_id` (`favorite_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='酒店收藏附表';

-- 8.4 商品收藏附表
DROP TABLE IF EXISTS `favorite_mall`;
CREATE TABLE `favorite_mall` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `favorite_id` BIGINT NOT NULL COMMENT 'FK→favorite.id',
  `goods_id` BIGINT NOT NULL COMMENT '商品ID',
  `sku_id` BIGINT DEFAULT NULL COMMENT 'SKU ID',
  `goods_name` VARCHAR(256) DEFAULT NULL COMMENT '商品名称',
  `price` DECIMAL(12,2) DEFAULT NULL COMMENT '收藏时价格',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_favorite_id` (`favorite_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品收藏附表';

-- ============================================================
-- 九、通用优惠券 (2张表 - 仅MMC可创建)
-- ============================================================

-- 9.1 优惠券模板表
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mmc_tenant_id` BIGINT NOT NULL COMMENT '创建商户ID(仅MMC可创建)',
  `coupon_name` VARCHAR(128) NOT NULL COMMENT '优惠券名称',
  `coupon_type` VARCHAR(32) NOT NULL COMMENT '类型: discount=折扣券, reduction=满减券, cash=直减券, flight=机票券, hotel=酒店券, general=通用券',
  `apply_type` VARCHAR(32) NOT NULL COMMENT '适用: flight=机票, hotel=酒店, train=火车票, mall=商城, general=通用',
  `discount_rate` DECIMAL(3,2) DEFAULT NULL COMMENT '折扣率(0.85=85折)',
  `reduction_threshold` DECIMAL(12,2) DEFAULT NULL COMMENT '满减门槛金额',
  `reduction_amount` DECIMAL(12,2) DEFAULT NULL COMMENT '满减/直减金额',
  `total_count` INT NOT NULL DEFAULT 0 COMMENT '发放总量(0=不限)',
  `used_count` INT NOT NULL DEFAULT 0 COMMENT '已使用数量',
  `per_user_limit` INT NOT NULL DEFAULT 1 COMMENT '每人限领',
  `effective_start` DATETIME DEFAULT NULL COMMENT '生效开始',
  `effective_end` DATETIME DEFAULT NULL COMMENT '生效结束',
  `valid_days` INT DEFAULT NULL COMMENT '领取后有效天数(替代固定时间)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_mmc_tenant_id` (`mmc_tenant_id`),
  KEY `idx_coupon_type` (`coupon_type`),
  KEY `idx_apply_type` (`apply_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通用优惠券模板表';

-- 9.2 用户优惠券表
DROP TABLE IF EXISTS `coupon_user`;
CREATE TABLE `coupon_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `coupon_id` BIGINT NOT NULL COMMENT 'FK→coupon.id',
  `user_id` BIGINT NOT NULL COMMENT 'C端用户ID',
  `status` VARCHAR(16) NOT NULL DEFAULT 'unused' COMMENT '状态: unused=未使用, used=已使用, expired=已过期',
  `received_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '领取时间',
  `used_at` DATETIME DEFAULT NULL COMMENT '使用时间',
  `order_id` BIGINT DEFAULT NULL COMMENT '使用时关联订单',
  `expired_at` DATETIME DEFAULT NULL COMMENT '过期时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_coupon_id` (`coupon_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户优惠券表';

-- ============================================================
-- 十、签到系统 (2张表)
-- ============================================================

-- 10.1 签到规则表
DROP TABLE IF EXISTS `sign_in_rule`;
CREATE TABLE `sign_in_rule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mmc_tenant_id` BIGINT NOT NULL COMMENT '商户ID',
  `reward_type` VARCHAR(32) NOT NULL COMMENT '奖励类型: point=积分, coupon=优惠券',
  `reward_amount` INT NOT NULL DEFAULT 0 COMMENT '奖励数量/积分值',
  `reward_coupon_id` BIGINT DEFAULT NULL COMMENT '奖励优惠券ID',
  `continuous_days` INT NOT NULL DEFAULT 7 COMMENT '连续签到天数要求',
  `continuous_bonus` INT NOT NULL DEFAULT 0 COMMENT '连续签到额外奖励',
  `continuous_bonus_coupon_id` BIGINT DEFAULT NULL COMMENT '连续签到额外优惠券ID',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_mmc_tenant_id` (`mmc_tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='签到规则表';

-- 10.2 签到记录表
DROP TABLE IF EXISTS `sign_in_log`;
CREATE TABLE `sign_in_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` BIGINT NOT NULL COMMENT 'C端用户ID',
  `mmc_tenant_id` BIGINT NOT NULL COMMENT '商户ID',
  `sign_date` DATE NOT NULL COMMENT '签到日期',
  `continuous_days` INT NOT NULL DEFAULT 1 COMMENT '当前连续签到天数',
  `reward_type` VARCHAR(32) NOT NULL COMMENT '奖励类型',
  `reward_amount` INT NOT NULL DEFAULT 0 COMMENT '获得奖励数量',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_mmc_date` (`user_id`, `mmc_tenant_id`, `sign_date`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_sign_date` (`sign_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='签到记录表';

-- ============================================================
-- 十一、用户标签 (2张表)
-- ============================================================

-- 11.1 用户标签定义表
DROP TABLE IF EXISTS `user_tag`;
CREATE TABLE `user_tag` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
  `tenant_type` VARCHAR(16) NOT NULL COMMENT '租户类型: pmc/tmc/mmc',
  `tag_name` VARCHAR(64) NOT NULL COMMENT '标签名称',
  `tag_color` VARCHAR(16) DEFAULT NULL COMMENT '标签颜色',
  `tag_type` VARCHAR(16) NOT NULL DEFAULT 'manual' COMMENT '标签类型: manual=手动, auto=自动',
  `auto_rule` JSON DEFAULT NULL COMMENT '自动打标规则(自动标签时)',
  `user_count` INT NOT NULL DEFAULT 0 COMMENT '关联用户数',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant` (`tenant_id`, `tenant_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户标签定义表';

-- 11.2 用户标签关联表
DROP TABLE IF EXISTS `user_tag_relation`;
CREATE TABLE `user_tag_relation` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tag_id` BIGINT NOT NULL COMMENT 'FK→user_tag.id',
  `user_id` BIGINT NOT NULL COMMENT 'C端用户ID',
  `source` VARCHAR(16) NOT NULL DEFAULT 'manual' COMMENT '来源: manual=手动, auto=自动',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tag_user` (`tag_id`, `user_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户标签关联表';

-- ============================================================
-- 十二、消息通知 (4张表)
-- ============================================================

-- 12.1 通知模板表
DROP TABLE IF EXISTS `notify_template`;
CREATE TABLE `notify_template` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `template_code` VARCHAR(64) NOT NULL COMMENT '模板编码(唯一)',
  `template_name` VARCHAR(128) NOT NULL COMMENT '模板名称',
  `channel` VARCHAR(32) NOT NULL COMMENT '渠道: sms=短信, wechat=微信模板消息, miniprogram=小程序订阅消息, inbox=站内信, email=邮件',
  `template_content` TEXT NOT NULL COMMENT '模板内容(支持变量: {{var}})',
  `third_template_id` VARCHAR(128) DEFAULT NULL COMMENT '第三方模板ID(如微信模板ID)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_template_code` (`template_code`),
  KEY `idx_channel` (`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知模板表';

-- 12.2 通知场景配置表
DROP TABLE IF EXISTS `notify_config`;
CREATE TABLE `notify_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `scene_code` VARCHAR(64) NOT NULL COMMENT '场景编码: ticket_issued/flight_change/refund_done/approval_pending/monthly_bill/promotion等',
  `scene_name` VARCHAR(128) NOT NULL COMMENT '场景名称',
  `channels` JSON NOT NULL COMMENT '启用的渠道列表(JSON数组) 如["sms","wechat","inbox"]',
  `is_configurable` TINYINT NOT NULL DEFAULT 1 COMMENT '用户是否可配置(0=强制, 1=可配置)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_scene_code` (`scene_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知场景配置表';

-- 12.3 通知记录表
DROP TABLE IF EXISTS `notify_log`;
CREATE TABLE `notify_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `scene_code` VARCHAR(64) DEFAULT NULL COMMENT '场景编码',
  `channel` VARCHAR(32) NOT NULL COMMENT '发送渠道',
  `template_id` BIGINT DEFAULT NULL COMMENT 'FK→notify_template.id',
  `user_id` BIGINT NOT NULL COMMENT '接收用户ID',
  `user_type` VARCHAR(16) NOT NULL DEFAULT 'c_user' COMMENT '用户类型: c_user/mmc_user/tmc_user/pmc_user',
  `content` TEXT DEFAULT NULL COMMENT '实际发送内容',
  `receiver` VARCHAR(128) DEFAULT NULL COMMENT '接收地址(手机号/openid/邮箱)',
  `send_status` VARCHAR(16) NOT NULL COMMENT '发送状态: pending/sending/success/failed',
  `third_msg_id` VARCHAR(128) DEFAULT NULL COMMENT '第三方消息ID',
  `error_msg` VARCHAR(512) DEFAULT NULL COMMENT '失败原因',
  `retry_count` TINYINT NOT NULL DEFAULT 0 COMMENT '重试次数',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_scene_code` (`scene_code`),
  KEY `idx_user` (`user_id`, `user_type`),
  KEY `idx_send_status` (`send_status`),
  KEY `idx_trace_id` (`trace_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知记录表';

-- 12.4 站内信表
DROP TABLE IF EXISTS `notify_inbox`;
CREATE TABLE `notify_inbox` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `user_type` VARCHAR(16) NOT NULL DEFAULT 'c_user' COMMENT '用户类型: c_user/mmc_user',
  `title` VARCHAR(256) NOT NULL COMMENT '标题',
  `content` TEXT DEFAULT NULL COMMENT '内容',
  `biz_type` VARCHAR(32) DEFAULT NULL COMMENT '关联业务类型',
  `biz_id` BIGINT DEFAULT NULL COMMENT '关联业务ID',
  `is_read` TINYINT NOT NULL DEFAULT 0 COMMENT '是否已读(0=否, 1=是)',
  `read_at` DATETIME DEFAULT NULL COMMENT '阅读时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`, `user_type`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内信表';

-- ============================================================
-- 十三、开放平台 (5张表)
-- ============================================================

-- 13.1 API接口定义表
DROP TABLE IF EXISTS `open_api`;
CREATE TABLE `open_api` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `api_code` VARCHAR(64) NOT NULL COMMENT '接口编码(唯一)',
  `api_name` VARCHAR(128) NOT NULL COMMENT '接口名称',
  `api_path` VARCHAR(256) NOT NULL COMMENT '接口路径 如 /openapi/v1/flight/search',
  `http_method` VARCHAR(8) NOT NULL DEFAULT 'POST' COMMENT 'HTTP方法',
  `version` VARCHAR(16) NOT NULL DEFAULT 'v1' COMMENT '版本号',
  `description` TEXT DEFAULT NULL COMMENT '接口描述',
  `request_schema` JSON DEFAULT NULL COMMENT '请求参数Schema',
  `response_schema` JSON DEFAULT NULL COMMENT '响应参数Schema',
  `rate_limit_per_sec` INT DEFAULT NULL COMMENT '频率限制(次/秒)',
  `rate_limit_per_day` INT DEFAULT NULL COMMENT '频率限制(次/天)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_api_code_version` (`api_code`, `version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='开放平台API接口定义表';

-- 13.2 API应用表(TMC创建)
DROP TABLE IF EXISTS `open_app`;
CREATE TABLE `open_app` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tmc_tenant_id` BIGINT NOT NULL COMMENT 'TMC租户ID',
  `mmc_tenant_id` BIGINT NOT NULL COMMENT '绑定的MMC租户ID(订单归属)',
  `app_name` VARCHAR(128) NOT NULL COMMENT '应用名称',
  `app_key` VARCHAR(64) NOT NULL COMMENT '应用AppKey',
  `app_secret` VARCHAR(128) NOT NULL COMMENT '应用AppSecret(加密存储)',
  `ip_whitelist` JSON DEFAULT NULL COMMENT 'IP白名单(JSON数组)',
  `concurrency_limit` INT DEFAULT NULL COMMENT '并发限制',
  `rate_limit_per_sec` INT DEFAULT NULL COMMENT '频率限制(次/秒)',
  `rate_limit_per_day` INT DEFAULT NULL COMMENT '频率限制(次/天)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_app_key` (`app_key`),
  KEY `idx_tmc_tenant_id` (`tmc_tenant_id`),
  KEY `idx_mmc_tenant_id` (`mmc_tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='开放平台API应用表';

-- 13.3 API接口授权表
DROP TABLE IF EXISTS `open_api_auth`;
CREATE TABLE `open_api_auth` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tmc_tenant_id` BIGINT NOT NULL COMMENT 'TMC租户ID',
  `api_id` BIGINT NOT NULL COMMENT 'FK→open_api.id',
  `auth_status` TINYINT NOT NULL DEFAULT 1 COMMENT '授权状态: 0=未授权, 1=已授权',
  `authorized_at` DATETIME DEFAULT NULL COMMENT '授权时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tmc_api` (`tmc_tenant_id`, `api_id`),
  KEY `idx_api_id` (`api_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='开放平台API接口授权表';

-- 13.4 TMC计费配置表
DROP TABLE IF EXISTS `open_billing_config`;
CREATE TABLE `open_billing_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tmc_tenant_id` BIGINT NOT NULL COMMENT 'TMC租户ID',
  `billing_type` VARCHAR(16) NOT NULL COMMENT '计费方式: per_call=按次, monthly=按月',
  `unit_price` DECIMAL(12,2) DEFAULT NULL COMMENT '单价(按次时)',
  `monthly_price` DECIMAL(12,2) DEFAULT NULL COMMENT '月费(按月时)',
  `monthly_call_limit` INT DEFAULT NULL COMMENT '月调用上限(按月时)',
  `effective_start` DATETIME DEFAULT NULL COMMENT '生效开始',
  `effective_end` DATETIME DEFAULT NULL COMMENT '生效结束',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_tmc_tenant_id` (`tmc_tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='开放平台TMC计费配置表';

-- 13.5 API调用日志表
DROP TABLE IF EXISTS `open_api_log`;
CREATE TABLE `open_api_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `app_id` BIGINT NOT NULL COMMENT 'FK→open_app.id',
  `api_id` BIGINT NOT NULL COMMENT 'FK→open_api.id',
  `tmc_tenant_id` BIGINT NOT NULL COMMENT 'TMC租户ID',
  `request_id` VARCHAR(64) DEFAULT NULL COMMENT '请求ID',
  `request_params` JSON DEFAULT NULL COMMENT '请求参数',
  `response_code` INT DEFAULT NULL COMMENT 'HTTP响应码',
  `response_body` JSON DEFAULT NULL COMMENT '响应内容',
  `duration` INT DEFAULT NULL COMMENT '耗时(毫秒)',
  `client_ip` VARCHAR(64) DEFAULT NULL COMMENT '客户端IP',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_app_id` (`app_id`),
  KEY `idx_api_id` (`api_id`),
  KEY `idx_tmc_tenant_id` (`tmc_tenant_id`),
  KEY `idx_trace_id` (`trace_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='开放平台API调用日志表';

-- ============================================================
-- 十四、小程序装修与内容管理 (4张表)
-- ============================================================

-- 14.1 小程序装修页面表
DROP TABLE IF EXISTS `decorate_page`;
CREATE TABLE `decorate_page` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mmc_tenant_id` BIGINT NOT NULL COMMENT '商户ID',
  `page_type` VARCHAR(32) NOT NULL COMMENT '页面类型: home=首页, category=分类, custom=自定义页',
  `page_name` VARCHAR(128) NOT NULL COMMENT '页面名称',
  `page_config` JSON NOT NULL COMMENT '页面配置(组件列表: 轮播图/导航宫格/搜索框/商品列表/广告位/banner/公告栏/富文本等)',
  `is_published` TINYINT NOT NULL DEFAULT 0 COMMENT '是否已发布(0=否, 1=是)',
  `published_at` DATETIME DEFAULT NULL COMMENT '发布时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_mmc_tenant_id` (`mmc_tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='小程序装修页面表';

-- 14.2 广告位表
DROP TABLE IF EXISTS `ad_slot`;
CREATE TABLE `ad_slot` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `slot_code` VARCHAR(64) NOT NULL COMMENT '广告位编码(唯一)',
  `slot_name` VARCHAR(128) NOT NULL COMMENT '广告位名称',
  `slot_type` VARCHAR(32) NOT NULL COMMENT '类型: banner=轮播图, popup=弹窗, float=浮动, fixed=固定',
  `position` VARCHAR(32) NOT NULL COMMENT '位置: home_top=首页顶部, home_middle=首页中部, order_success=下单成功页等',
  `width` INT DEFAULT NULL COMMENT '宽度(px)',
  `height` INT DEFAULT NULL COMMENT '高度(px)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_slot_code` (`slot_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='广告位表';

-- 14.3 广告内容表
DROP TABLE IF EXISTS `ad_content`;
CREATE TABLE `ad_content` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `slot_id` BIGINT NOT NULL COMMENT 'FK→ad_slot.id',
  `mmc_tenant_id` BIGINT DEFAULT NULL COMMENT '商户ID(空=全局)',
  `title` VARCHAR(128) DEFAULT NULL COMMENT '广告标题',
  `image_url` VARCHAR(512) NOT NULL COMMENT '图片URL',
  `link_type` VARCHAR(32) DEFAULT NULL COMMENT '跳转类型: page=内部页面, url=外部链接, mini_program=小程序页面',
  `link_url` VARCHAR(512) DEFAULT NULL COMMENT '跳转地址',
  `sort_order` INT DEFAULT NULL COMMENT '排序',
  `effective_start` DATETIME DEFAULT NULL COMMENT '生效开始',
  `effective_end` DATETIME DEFAULT NULL COMMENT '生效结束',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_slot_id` (`slot_id`),
  KEY `idx_mmc_tenant_id` (`mmc_tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='广告内容表';

-- 14.4 公告管理表
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
  `tenant_type` VARCHAR(16) NOT NULL COMMENT '租户类型: pmc/tmc/mmc',
  `title` VARCHAR(256) NOT NULL COMMENT '公告标题',
  `content` TEXT NOT NULL COMMENT '公告内容',
  `type` VARCHAR(32) NOT NULL DEFAULT 'notice' COMMENT '类型: notice=通知, activity=活动, policy=政策',
  `is_top` TINYINT NOT NULL DEFAULT 0 COMMENT '是否置顶(0=否, 1=是)',
  `effective_start` DATETIME DEFAULT NULL COMMENT '生效开始',
  `effective_end` DATETIME DEFAULT NULL COMMENT '生效结束',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=草稿, 1=已发布, 2=已下架',
  `published_at` DATETIME DEFAULT NULL COMMENT '发布时间',
  `created_by` BIGINT DEFAULT NULL COMMENT '创建人',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant` (`tenant_id`, `tenant_type`),
  KEY `idx_type` (`type`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告管理表';

-- ============================================================
-- 十五、队列任务 (1张表 - 含版本快照控制)
-- ============================================================

DROP TABLE IF EXISTS `queue_task`;
CREATE TABLE `queue_task` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_type` VARCHAR(64) NOT NULL COMMENT '任务类型: ticket_issue/refund/price_verify/batch_import/bill_generate等',
  `task_version` INT NOT NULL DEFAULT 1 COMMENT '任务版本(代码版本兼容, 快照版本)',
  `queue_name` VARCHAR(64) NOT NULL COMMENT '队列名称',
  `payload` JSON NOT NULL COMMENT '任务参数',
  `snapshot` JSON DEFAULT NULL COMMENT '业务数据快照(创建时业务数据副本, 用于版本回溯)',
  `priority` TINYINT NOT NULL DEFAULT 0 COMMENT '优先级(0=普通, 1=高, 2=紧急)',
  `max_retry` TINYINT NOT NULL DEFAULT 3 COMMENT '最大重试次数',
  `retry_count` TINYINT NOT NULL DEFAULT 0 COMMENT '已重试次数',
  `status` VARCHAR(16) NOT NULL DEFAULT 'pending' COMMENT '状态: pending=待执行, running=执行中, success=成功, failed=失败, cancelled=已取消',
  `error_msg` TEXT DEFAULT NULL COMMENT '失败原因',
  `biz_type` VARCHAR(32) DEFAULT NULL COMMENT '关联业务类型',
  `biz_id` BIGINT DEFAULT NULL COMMENT '关联业务ID',
  `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID',
  `started_at` DATETIME DEFAULT NULL COMMENT '开始执行时间',
  `finished_at` DATETIME DEFAULT NULL COMMENT '完成时间',
  `next_run_at` DATETIME DEFAULT NULL COMMENT '下次执行时间(延迟任务)',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_task_type` (`task_type`),
  KEY `idx_status` (`status`),
  KEY `idx_queue_name` (`queue_name`),
  KEY `idx_biz` (`biz_type`, `biz_id`),
  KEY `idx_trace_id` (`trace_id`),
  KEY `idx_next_run_at` (`next_run_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='队列任务表(含版本快照控制)';

-- ============================================================
-- 十六、差旅政策 (1张表)
-- ============================================================

DROP TABLE IF EXISTS `travel_policy`;
CREATE TABLE `travel_policy` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
  `tenant_type` VARCHAR(16) NOT NULL COMMENT '租户类型: tmc/mmc',
  `policy_name` VARCHAR(128) NOT NULL COMMENT '政策名称',
  `rules` JSON NOT NULL COMMENT '政策规则(航线限制/舱位限制/价格上限/酒店标准/火车席别标准等)',
  `violation_action` VARCHAR(16) NOT NULL DEFAULT 'warn' COMMENT '违规处理: warn=仅提醒, block=拦截禁止',
  `apply_scope` VARCHAR(16) NOT NULL DEFAULT 'all' COMMENT '适用范围: all=全员, department=按部门, specified=指定人员',
  `scope_config` JSON DEFAULT NULL COMMENT '范围配置(部门ID列表/人员ID列表)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_tenant` (`tenant_id`, `tenant_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='差旅政策表';

-- ============================================================
-- 十七、会员体系扩展 (2张表)
-- ============================================================

-- 17.1 会员升级规则表
DROP TABLE IF EXISTS `member_grade_rule`;
CREATE TABLE `member_grade_rule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mmc_tenant_id` BIGINT NOT NULL COMMENT '商户ID',
  `from_grade_id` BIGINT NOT NULL COMMENT '当前等级ID FK→c_member_grade.id',
  `to_grade_id` BIGINT NOT NULL COMMENT '目标等级ID FK→c_member_grade.id',
  `rule_type` VARCHAR(32) NOT NULL COMMENT '规则类型: point=积分达到, order_count=订单数达到, amount_total=消费金额达到',
  `threshold` DECIMAL(12,2) NOT NULL COMMENT '升级阈值',
  `is_auto_upgrade` TINYINT NOT NULL DEFAULT 1 COMMENT '是否自动升级(0=否, 1=是)',
  `is_auto_downgrade` TINYINT NOT NULL DEFAULT 0 COMMENT '是否自动降级(0=否, 1=是)',
  `downgrade_rule` JSON DEFAULT NULL COMMENT '降级规则(如N天未消费)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_mmc_tenant_id` (`mmc_tenant_id`),
  KEY `idx_grade` (`from_grade_id`, `to_grade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员升级规则表';

-- 17.2 会员权益表
DROP TABLE IF EXISTS `member_benefit`;
CREATE TABLE `member_benefit` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mmc_tenant_id` BIGINT NOT NULL COMMENT '商户ID',
  `grade_id` BIGINT NOT NULL COMMENT '等级ID FK→c_member_grade.id',
  `benefit_type` VARCHAR(32) NOT NULL COMMENT '权益类型: discount=折扣, coupon=专属优惠券, point_rate=积分倍率, free_upgrade=免费升舱, priority_service=优先服务',
  `benefit_config` JSON NOT NULL COMMENT '权益配置(具体参数)',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_mmc_tenant_id` (`mmc_tenant_id`),
  KEY `idx_grade_id` (`grade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员权益表';

-- ============================================================
-- 十八、促销活动 (1张表)
-- ============================================================

DROP TABLE IF EXISTS `promotion_activity`;
CREATE TABLE `promotion_activity` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mmc_tenant_id` BIGINT NOT NULL COMMENT '商户ID(仅MMC)',
  `activity_name` VARCHAR(128) NOT NULL COMMENT '活动名称',
  `activity_type` VARCHAR(32) NOT NULL COMMENT '活动类型: seckill=秒杀, group_buy=团购, full_reduction=满减, flash_sale=闪购',
  `activity_config` JSON NOT NULL COMMENT '活动配置(时间/规则/商品/价格等)',
  `effective_start` DATETIME NOT NULL COMMENT '活动开始时间',
  `effective_end` DATETIME NOT NULL COMMENT '活动结束时间',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0=草稿, 1=已发布, 2=已结束, 3=已取消',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_mmc_tenant_id` (`mmc_tenant_id`),
  KEY `idx_activity_type` (`activity_type`),
  KEY `idx_status` (`status`),
  KEY `idx_effective_time` (`effective_start`, `effective_end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='促销活动表';

-- ============================================================
-- 十九、通用供应商管理 (1张表)
-- ============================================================

DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `supplier_name` VARCHAR(128) NOT NULL COMMENT '供应商名称',
  `supplier_type` VARCHAR(32) NOT NULL COMMENT '供应商类型: airline=航司, hotel=酒店, insurance=保险, car=用车, ticket=门票, other=其他',
  `contact_name` VARCHAR(64) DEFAULT NULL COMMENT '联系人',
  `contact_phone` VARCHAR(32) DEFAULT NULL COMMENT '联系电话',
  `contact_email` VARCHAR(128) DEFAULT NULL COMMENT '联系邮箱',
  `contract_no` VARCHAR(64) DEFAULT NULL COMMENT '合同编号',
  `contract_start` DATE DEFAULT NULL COMMENT '合同开始日期',
  `contract_end` DATE DEFAULT NULL COMMENT '合同结束日期',
  `settlement_type` VARCHAR(32) DEFAULT NULL COMMENT '结算方式: prepaid=预付, monthly=月结, credit=信用额度',
  `bank_name` VARCHAR(128) DEFAULT NULL COMMENT '开户行',
  `bank_account` VARCHAR(64) DEFAULT NULL COMMENT '银行账号',
  `remark` TEXT DEFAULT NULL COMMENT '备注',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` DATETIME DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_supplier_type` (`supplier_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通用供应商管理表';

-- ============================================================
-- 二十、报表快照 (1张表)
-- ============================================================

DROP TABLE IF EXISTS `report_snapshot`;
CREATE TABLE `report_snapshot` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
  `tenant_type` VARCHAR(16) NOT NULL COMMENT '租户类型: pmc/tmc/mmc',
  `report_type` VARCHAR(32) NOT NULL COMMENT '报表类型: sales=销售, procurement=采购, finance=财务, user=用户, product=产品',
  `dimension` VARCHAR(32) NOT NULL COMMENT '维度: daily=日, weekly=周, monthly=月',
  `dimension_date` DATE NOT NULL COMMENT '维度日期',
  `metrics` JSON NOT NULL COMMENT '指标数据(订单量/销售额/采购额/退款额/利润等)',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_report_dimension` (`tenant_id`, `tenant_type`, `report_type`, `dimension`, `dimension_date`),
  KEY `idx_tenant` (`tenant_id`, `tenant_type`),
  KEY `idx_report_type` (`report_type`),
  KEY `idx_dimension_date` (`dimension_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='报表快照表';

-- ============================================================
-- 原有表字段新增
-- ============================================================

-- 订单表(order)新增字段
ALTER TABLE `order` ADD COLUMN `order_tag` VARCHAR(32) DEFAULT NULL COMMENT '订单来源标识: openapi=开放平台, mini_program=小程序, web=Web端, app=App端' AFTER `updated_at`;
ALTER TABLE `order` ADD COLUMN `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID' AFTER `order_tag`;

-- 订单项-用车(order_item_car)新增字段
ALTER TABLE `order_item_car` ADD COLUMN `car_type` VARCHAR(32) DEFAULT NULL COMMENT '车型: economy/comfort/business/luxury' AFTER `updated_at`;
ALTER TABLE `order_item_car` ADD COLUMN `service_type` VARCHAR(32) DEFAULT NULL COMMENT '服务类型: airport_pickup/airport_dropoff/city/cross_city' AFTER `car_type`;
ALTER TABLE `order_item_car` ADD COLUMN `pickup_address` VARCHAR(256) DEFAULT NULL COMMENT '上车地址' AFTER `service_type`;
ALTER TABLE `order_item_car` ADD COLUMN `dropoff_address` VARCHAR(256) DEFAULT NULL COMMENT '下车地址' AFTER `pickup_address`;
ALTER TABLE `order_item_car` ADD COLUMN `pickup_time` DATETIME DEFAULT NULL COMMENT '预约上车时间' AFTER `dropoff_address`;
ALTER TABLE `order_item_car` ADD COLUMN `driver_name` VARCHAR(64) DEFAULT NULL COMMENT '司机姓名' AFTER `pickup_time`;
ALTER TABLE `order_item_car` ADD COLUMN `driver_phone` VARCHAR(32) DEFAULT NULL COMMENT '司机电话' AFTER `driver_name`;
ALTER TABLE `order_item_car` ADD COLUMN `car_no` VARCHAR(32) DEFAULT NULL COMMENT '车牌号' AFTER `driver_phone`;
ALTER TABLE `order_item_car` ADD COLUMN `fee_detail` JSON DEFAULT NULL COMMENT '费用明细' AFTER `car_no`;

-- 原有日志表新增 trace_id 字段
ALTER TABLE `order_status_log` ADD COLUMN `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID' AFTER `updated_at`;
ALTER TABLE `operation_log` ADD COLUMN `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID' AFTER `updated_at`;
ALTER TABLE `finance_balance_log` ADD COLUMN `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID' AFTER `updated_at`;
ALTER TABLE `service_task_log` ADD COLUMN `trace_id` VARCHAR(64) DEFAULT NULL COMMENT '全链路追踪ID' AFTER `updated_at`;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 统计: 新增 42 张表, 修改 5 张原有表
-- ============================================================
