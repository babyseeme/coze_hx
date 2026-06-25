-- ============================================================================
-- 华夏航服 B2B2C v9 复核修复 SQL
-- 生成时间: 2025-06-26
-- 说明: 基于v9全量SQL复核, 修复6类问题:
--   1. 新增6张缺失的业务流转日志表
--   2. 新增会员资产版本控制(余额/积分日志+版本字段)
--   3. 新增会员等级体系表
--   4. 修复唯一索引缺deleted_at(软删除后无法重建)
--   5. 修复mall_favorite/mall_cart唯一索引缺tenant_id
--   6. 补充hotel_info/mall_goods缺失的deleted_at字段
-- ============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ══════════════════════════════════════════════════════════════════════════
-- 一、新增业务流转日志表 (6张)
-- ══════════════════════════════════════════════════════════════════════════

-- 1-1. 订单状态变更日志
-- 用途: 追踪order.status的每次变更(谁在什么时候从什么状态改为什么状态)
DROP TABLE IF EXISTS `order_status_log`;
CREATE TABLE `order_status_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `from_status` tinyint NOT NULL COMMENT '原状态',
  `to_status` tinyint NOT NULL COMMENT '新状态',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '触发来源类型: order/item_flight/item_train/item_hotel/item_mall/payment/refund/change/system',
  `biz_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '触发来源ID(如item_id/change_id/payment_id)',
  `operator_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人类型: member/admin/system/cron',
  `operator_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NOT NULL COMMENT '变更时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `to_status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_biz`(`biz_type` ASC, `biz_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单状态变更日志(全链路追踪)' ROW_FORMAT = Dynamic;

-- 1-2. 子订单状态变更日志
-- 用途: 追踪各order_item_*表的status每次变更
DROP TABLE IF EXISTS `order_item_status_log`;
CREATE TABLE `order_item_status_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '子订单类型: flight/train/hotel/mall/insurance/car',
  `item_id` bigint UNSIGNED NOT NULL COMMENT '子订单ID(指向对应item表)',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID(冗余,便于查询)',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `from_status` tinyint NOT NULL COMMENT '原状态',
  `to_status` tinyint NOT NULL COMMENT '新状态',
  `trigger_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '触发类型: purchase_confirm/ticket_issue/refund_apply/refund_confirm/change_apply/change_confirm/cancel/ship/receive/system',
  `trigger_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '触发ID(如procure_item_id/change_id/after_sale_id)',
  `operator_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人类型: member/admin/system/cron',
  `operator_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注(如出票失败原因)',
  `created_at` datetime NOT NULL COMMENT '变更时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_item`(`item_type` ASC, `item_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_tenant_type`(`tenant_id` ASC, `item_type` ASC, `to_status` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '子订单状态变更日志(出票/退改/发货等全追踪)' ROW_FORMAT = Dynamic;

-- 1-3. 会员余额变更日志(带版本控制)
-- 用途: 追踪c_member.wallet_balance的每次变更, 乐观锁防并发
DROP TABLE IF EXISTS `c_member_balance_log`;
CREATE TABLE `c_member_balance_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `change_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '变更类型: recharge=充值/payment=消费/refund=退款/withdraw=提现/gift=赠送/adjust=调整/freeze=冻结/unfreeze=解冻',
  `amount` decimal(12, 2) NOT NULL COMMENT '变更金额(正=增加,负=减少)',
  `before_balance` decimal(12, 2) NOT NULL COMMENT '变更前余额',
  `after_balance` decimal(12, 2) NOT NULL COMMENT '变更后余额',
  `version` int UNSIGNED NOT NULL COMMENT '余额版本号(乐观锁,每次变更+1)',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '关联业务: order/refund/coupon/manual',
  `biz_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '关联业务ID(订单号/退款单号等)',
  `operator_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人类型: member/admin/system',
  `operator_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '操作人ID',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NOT NULL COMMENT '变更时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_member`(`member_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_tenant_type`(`tenant_id` ASC, `change_type` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_biz`(`biz_type` ASC, `biz_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员余额变更日志(版本控制+乐观锁)' ROW_FORMAT = Dynamic;

-- 1-4. 会员积分变更日志(带版本控制)
-- 用途: 追踪c_member.points_balance的每次变更, 防积分欺诈
DROP TABLE IF EXISTS `c_member_points_log`;
CREATE TABLE `c_member_points_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `change_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '变更类型: earn=获取(消费返)/consume=消耗(积分抵扣)/expire=过期/gift=赠送/adjust=调整',
  `points` int NOT NULL COMMENT '变更积分数(正=增加,负=减少)',
  `before_points` int NOT NULL COMMENT '变更前积分',
  `after_points` int NOT NULL COMMENT '变更后积分',
  `version` int UNSIGNED NOT NULL COMMENT '积分版本号(乐观锁,每次变更+1)',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '关联业务: order/refund/manual/activity',
  `biz_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '关联业务ID',
  `points_value` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '积分等值金额(1积分=N分,用于兑换时)',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '积分过期时间(获取时计算)',
  `operator_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人类型: member/admin/system/cron',
  `operator_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '操作人ID',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NOT NULL COMMENT '变更时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_member`(`member_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_tenant_type`(`tenant_id` ASC, `change_type` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_expire`(`expire_at` ASC) USING BTREE COMMENT '定时任务扫描过期积分'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员积分变更日志(版本控制+过期追踪)' ROW_FORMAT = Dynamic;

-- 1-5. 支付流水日志
-- 用途: 追踪支付全流程(下单->支付->回调->成功/失败/重试)
DROP TABLE IF EXISTS `payment_log`;
CREATE TABLE `payment_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `payment_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支付流水号(唯一)',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `pay_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支付方式: wechat/alipay/balance/credit/mixed',
  `pay_channel` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付渠道(微信JSAPI/微信H5/支付宝APP等)',
  `amount` decimal(12, 2) NOT NULL COMMENT '支付金额',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '币种',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待支付,2=支付中,3=支付成功,4=支付失败,5=已关闭,6=已退款',
  `callback_status` tinyint NULL DEFAULT 0 COMMENT '回调状态: 0=未回调,1=成功,2=失败,3=重复回调',
  `transaction_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '第三方支付交易号(微信/支付宝返回)',
  `callback_at` datetime NULL DEFAULT NULL COMMENT '回调时间',
  `callback_raw` json NULL COMMENT '回调原始报文(存档备查)',
  `retry_count` tinyint NULL DEFAULT 0 COMMENT '重试次数',
  `next_retry_at` datetime NULL DEFAULT NULL COMMENT '下次重试时间',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '支付过期时间(超时未支付自动关闭)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_payment_no`(`payment_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_member`(`member_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_transaction`(`transaction_id` ASC) USING BTREE COMMENT '对账用: 按第三方交易号查',
  INDEX `idx_status_retry`(`status` ASC, `next_retry_at` ASC) USING BTREE COMMENT '定时任务: 扫描待重试支付'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '支付流水日志(全流程追踪+对账)' ROW_FORMAT = Dynamic;

-- 1-6. 退款流程日志
-- 用途: 追踪finance_refund的审核/审批/打款全流程
DROP TABLE IF EXISTS `finance_refund_log`;
CREATE TABLE `finance_refund_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `refund_id` bigint UNSIGNED NOT NULL COMMENT 'finance_refund.id',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `from_status` tinyint NOT NULL COMMENT '原状态',
  `to_status` tinyint NOT NULL COMMENT '新状态',
  `action` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作: apply=申请/audit_pass=审核通过/audit_reject=审核驳回/review_pass=审批通过/review_reject=审批驳回/transfer=打款/transfer_fail=打款失败/cancel=取消',
  `operator_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人类型: member/admin/system/cron',
  `operator_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '审核意见/打款备注',
  `created_at` datetime NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_refund`(`refund_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `to_status` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款流程日志(审核+审批+打款全追踪)' ROW_FORMAT = Dynamic;


-- ══════════════════════════════════════════════════════════════════════════
-- 二、新增会员等级体系表
-- ══════════════════════════════════════════════════════════════════════════

DROP TABLE IF EXISTS `c_member_grade`;
CREATE TABLE `c_member_grade`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID(0=平台通用)',
  `grade_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '等级编码(如: normal/silver/gold/platinum/diamond)',
  `grade_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '等级名称(如: 普通/银卡/金卡/白金/钻石)',
  `level` smallint NOT NULL DEFAULT 0 COMMENT '等级排序(数值越大等级越高)',
  `min_points` int NOT NULL DEFAULT 0 COMMENT '升级所需积分(累计获取积分)',
  `max_points` int NULL DEFAULT NULL COMMENT '上限积分(NULL=无上限, 下一等级min_points-1)',
  `discount_rate` decimal(3, 2) NULL DEFAULT 1.00 COMMENT '折扣率(如: 0.95=95折, 1.00=无折扣)',
  `points_earn_rate` decimal(5, 2) NULL DEFAULT 1.00 COMMENT '积分获取倍率(如: 1.5=1.5倍积分)',
  `free_upgrade_flight` tinyint NOT NULL DEFAULT 2 COMMENT '免费升舱权益: 1=有,2=无',
  `free_lounge` tinyint NOT NULL DEFAULT 2 COMMENT '贵宾休息室: 1=有,2=无',
  `priority_boarding` tinyint NOT NULL DEFAULT 2 COMMENT '优先登机: 1=有,2=无',
  `extra_baggage` smallint NULL DEFAULT 0 COMMENT '额外行李额(KG, 0=无)',
  `benefits_desc` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '权益描述(JSON: 其他自定义权益)',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '等级图标URL',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code`(`tenant_id` ASC, `grade_code` ASC) USING BTREE,
  INDEX `idx_tenant_level`(`tenant_id` ASC, `level` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员等级定义(按商户自定义)' ROW_FORMAT = Dynamic;


-- ══════════════════════════════════════════════════════════════════════════
-- 三、c_member 增加版本控制字段
-- ══════════════════════════════════════════════════════════════════════════

-- 3-1. 增加余额版本号(乐观锁防并发)
ALTER TABLE `c_member` ADD COLUMN `balance_version` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '余额版本号(乐观锁,每次余额变更+1)' AFTER `wallet_balance`;

-- 3-2. 增加积分版本号(乐观锁防并发)
ALTER TABLE `c_member` ADD COLUMN `points_version` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '积分版本号(乐观锁,每次积分变更+1)' AFTER `points_balance`;

-- 3-3. 增加等级字段
ALTER TABLE `c_member` ADD COLUMN `grade_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '会员等级 c_member_grade.id' AFTER `points_version`;

-- 3-4. 增加累计获取积分(用于等级判定,与可用积分分开)
ALTER TABLE `c_member` ADD COLUMN `total_earned_points` int NOT NULL DEFAULT 0 COMMENT '累计获取积分(用于等级判定,不减)' AFTER `grade_id`;


-- ══════════════════════════════════════════════════════════════════════════
-- 四、修复唯一索引缺 deleted_at (软删除后无法重建同名记录)
-- ══════════════════════════════════════════════════════════════════════════

-- 4-1. corporate_group: uk_group_code 加入 deleted_at
ALTER TABLE `corporate_group` DROP INDEX `uk_group_code`,
  ADD UNIQUE INDEX `uk_group_code`(`group_code` ASC, `deleted_at` ASC) USING BTREE;

-- 4-2. corporate_contract: uk_group_airline 加入 deleted_at
ALTER TABLE `corporate_contract` DROP INDEX `uk_group_airline`,
  ADD UNIQUE INDEX `uk_group_airline`(`group_id` ASC, `airline_code` ASC, `deleted_at` ASC) USING BTREE;


-- ══════════════════════════════════════════════════════════════════════════
-- 五、修复 mall 唯一索引缺 tenant_id (跨商户数据冲突)
-- ══════════════════════════════════════════════════════════════════════════

-- 5-1. mall_favorite: uk_user_goods 加入 tenant_id
ALTER TABLE `mall_favorite` DROP INDEX `uk_user_goods`,
  ADD UNIQUE INDEX `uk_tenant_user_goods`(`tenant_id` ASC, `user_id` ASC, `goods_id` ASC) USING BTREE;

-- 5-2. mall_cart: 新增唯一索引(防止同SKU重复加购)
ALTER TABLE `mall_cart` ADD UNIQUE INDEX `uk_tenant_user_sku`(`tenant_id` ASC, `member_id` ASC, `sku_id` ASC) USING BTREE;


-- ══════════════════════════════════════════════════════════════════════════
-- 六、补充缺失的 deleted_at 字段
-- ══════════════════════════════════════════════════════════════════════════

-- 6-1. hotel_info 缺 deleted_at
ALTER TABLE `hotel_info` ADD COLUMN `deleted_at` datetime NULL DEFAULT NULL AFTER `updated_at`;

-- 6-2. mall_goods 缺 deleted_at
ALTER TABLE `mall_goods` ADD COLUMN `deleted_at` datetime NULL DEFAULT NULL AFTER `updated_at`;


SET FOREIGN_KEY_CHECKS = 1;
