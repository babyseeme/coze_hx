-- ============================================================
-- 温州华夏航服B2B2C平台 - V11数据库复核整改SQL
-- 基于: docs/08_V11数据库复核报告.md
-- 执行顺序: 按BLOCK→SHOULD→MAY优先级排列
-- 数据库: MySQL 8.0+
-- 字符集: utf8mb4
-- 生成日期: 2026-06-28
-- ============================================================

-- ============================================================
-- PART 1: BLOCK — 必须整改 (审批方案冲突)
-- ============================================================

-- -----------------------------------------------------------
-- 1.1 删除自建审批流程设计器表 (已确认对接第三方OA为主方案)
-- 如需保留为备用方案，请注释以下DROP语句
-- -----------------------------------------------------------

DROP TABLE IF EXISTS `approval_condition_item`;
DROP TABLE IF EXISTS `approval_condition_group`;
DROP TABLE IF EXISTS `approval_edge`;
DROP TABLE IF EXISTS `approval_node`;
DROP TABLE IF EXISTS `approval_form`;
DROP TABLE IF EXISTS `approval_flow`;

-- -----------------------------------------------------------
-- 1.2 approval_instance: 移除自建流程设计器相关字段
-- 保留OA对接字段: oa_platform, oa_process_id, oa_callback_url, oa_data
-- 移除设计器字段: flow_id, flow_version
-- -----------------------------------------------------------

ALTER TABLE `approval_instance`
  DROP COLUMN `flow_id`,
  DROP COLUMN `flow_version`;


-- ============================================================
-- PART 2: SHOULD — 强烈建议整改 (tenant_id + trace_id)
-- ============================================================

-- -----------------------------------------------------------
-- 2.1 审批相关表补充 tenant_id
-- -----------------------------------------------------------

ALTER TABLE `approval_record` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID' AFTER `id`;
ALTER TABLE `approval_record` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.2 售后子表冗余 tenant_id (主表after_sale已有tenant_id)
-- 理由: 子表独立查询场景需租户过滤; Casbin数据权限自动注入需每表有tenant_id; 微服务拆分后JOIN不可用
-- -----------------------------------------------------------

ALTER TABLE `after_sale_flight` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `after_sale_flight` ADD INDEX `idx_tenant_id` (`tenant_id`);

ALTER TABLE `after_sale_hotel` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `after_sale_hotel` ADD INDEX `idx_tenant_id` (`tenant_id`);

ALTER TABLE `after_sale_train` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `after_sale_train` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.3 收藏子表冗余 tenant_id
-- -----------------------------------------------------------

ALTER TABLE `favorite_flight` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `favorite_flight` ADD INDEX `idx_tenant_id` (`tenant_id`);

ALTER TABLE `favorite_hotel` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `favorite_hotel` ADD INDEX `idx_tenant_id` (`tenant_id`);

ALTER TABLE `favorite_mall` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `favorite_mall` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.4 通知表补充 tenant_id
-- -----------------------------------------------------------

ALTER TABLE `notify_template` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID' AFTER `id`;
ALTER TABLE `notify_template` ADD INDEX `idx_tenant_id` (`tenant_id`);

ALTER TABLE `notify_config` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID' AFTER `id`;
ALTER TABLE `notify_config` ADD INDEX `idx_tenant_id` (`tenant_id`);

ALTER TABLE `notify_inbox` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID' AFTER `id`;
ALTER TABLE `notify_inbox` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.5 开放平台 open_api 补充 tenant_id
-- API接口属于TMC租户私有资源
-- -----------------------------------------------------------

ALTER TABLE `open_api` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(TMC)' AFTER `id`;
ALTER TABLE `open_api` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.6 采购相关表补充 tenant_id
-- procurement_channel: 采购渠道如按TMC配置则需隔离
-- procurement_verify_log: 核销日志需租户隔离
-- -----------------------------------------------------------

ALTER TABLE `procurement_channel` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(TMC), NULL表示PMC全局渠道' AFTER `id`;
ALTER TABLE `procurement_channel` ADD INDEX `idx_tenant_id` (`tenant_id`);

ALTER TABLE `procurement_verify_log` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `procurement_verify_log` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.7 队列任务表补充 tenant_id
-- 异步任务含租户敏感数据, 需按租户隔离避免跨租户泄露
-- -----------------------------------------------------------

ALTER TABLE `queue_task` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID' AFTER `id`;
ALTER TABLE `queue_task` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.8 供应商表补充 tenant_id
-- 供应商可能为租户私有(如TMC独签航司), NULL表示全局共享
-- -----------------------------------------------------------

ALTER TABLE `supplier` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID, NULL表示全局共享供应商' AFTER `id`;
ALTER TABLE `supplier` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.9 优惠券领券记录冗余 tenant_id
-- -----------------------------------------------------------

ALTER TABLE `coupon_user` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `coupon_user` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.10 评论图片表冗余 tenant_id
-- -----------------------------------------------------------

ALTER TABLE `comment_image` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `comment_image` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.11 广告位表补充 tenant_id
-- 广告位按租户(MMC)管理, NULL表示全局广告位
-- -----------------------------------------------------------

ALTER TABLE `ad_slot` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID, NULL表示全局广告位' AFTER `id`;
ALTER TABLE `ad_slot` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.12 用户标签关联表冗余 tenant_id
-- -----------------------------------------------------------

ALTER TABLE `user_tag_relation` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID(冗余)' AFTER `id`;
ALTER TABLE `user_tag_relation` ADD INDEX `idx_tenant_id` (`tenant_id`);

-- -----------------------------------------------------------
-- 2.13 OA回调日志表补充 tenant_id
-- -----------------------------------------------------------

ALTER TABLE `oa_callback_log` ADD COLUMN `tenant_id` bigint NULL COMMENT '租户ID' AFTER `id`;
ALTER TABLE `oa_callback_log` ADD INDEX `idx_tenant_id` (`tenant_id`);


-- ============================================================
-- PART 2B: SHOULD — 关键流水表补充 trace_id
-- ============================================================

-- -----------------------------------------------------------
-- 2.14 P0级别 — 订单/支付/结算核心链路 (必须加)
-- -----------------------------------------------------------

ALTER TABLE `order_item_flight` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `order_item_flight` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `order_item_hotel` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `order_item_hotel` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `order_item_train` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `order_item_train` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `order_procurement` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `order_procurement` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `payment_log` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `payment_log` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `finance_refund` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `finance_refund` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `finance_company_payment` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `finance_company_payment` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `finance_supplier_payment` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `finance_supplier_payment` ADD INDEX `idx_trace_id` (`trace_id`);

-- -----------------------------------------------------------
-- 2.15 P1级别 — 余额/积分/售后/客服链路 (建议加)
-- -----------------------------------------------------------

ALTER TABLE `order_item_car` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `order_item_car` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `order_item_mall` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `order_item_mall` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `order_item_insurance` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `order_item_insurance` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `order_change` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `order_change` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `c_member_balance_log` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `c_member_balance_log` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `c_member_points_log` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `c_member_points_log` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `mall_after_sale` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `mall_after_sale` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `mall_after_sale_log` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `mall_after_sale_log` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `service_task_log` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `service_task_log` ADD INDEX `idx_trace_id` (`trace_id`);

ALTER TABLE `corporate_policy_match_log` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `id`;
ALTER TABLE `corporate_policy_match_log` ADD INDEX `idx_trace_id` (`trace_id`);


-- ============================================================
-- PART 3: MAY — 可选优化
-- ============================================================

-- -----------------------------------------------------------
-- 3.1 order_tag 改为 JSON 类型 (支持多维度标签)
-- 注意: 如果已有数据, 需先迁移:
--   UPDATE `order` SET order_tag = JSON_OBJECT('tag', order_tag) WHERE order_tag IS NOT NULL AND JSON_VALID(order_tag) = 0;
-- -----------------------------------------------------------

ALTER TABLE `order` MODIFY COLUMN `order_tag` json NULL COMMENT '订单标签(JSON: {"source":"open_api","tmc_id":1,"mmc_id":2,"promotion":"summer_2026"})';

-- -----------------------------------------------------------
-- 3.2 order_item_car 用车服务字段扩展
-- -----------------------------------------------------------

ALTER TABLE `order_item_car`
  ADD COLUMN `pickup_address` varchar(256) NULL COMMENT '上车地址' AFTER `service_type`,
  ADD COLUMN `dropoff_address` varchar(256) NULL COMMENT '下车地址' AFTER `pickup_address`,
  ADD COLUMN `pickup_time` datetime NULL COMMENT '预约用车时间' AFTER `dropoff_address`,
  ADD COLUMN `car_model` varchar(64) NULL COMMENT '车型(经济型/舒适型/商务型)' AFTER `pickup_time`,
  ADD COLUMN `driver_info` json NULL COMMENT '司机信息(JSON: {"name":"张师傅","phone":"138xxxx","plate":"浙C12345"})' AFTER `car_model`;

-- -----------------------------------------------------------
-- 3.3 comment_image 拆分为 comment_order_image
-- 保持数据隔离: 订单评论图片独立于商城评论图片
-- 步骤: 1)创建新表 2)迁移数据 3)删除旧表
-- -----------------------------------------------------------

-- 创建订单评论图片表
CREATE TABLE IF NOT EXISTS `comment_order_image` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint NULL COMMENT '租户ID(冗余)',
  `comment_id` bigint NOT NULL COMMENT '评论ID(关联comment_order)',
  `image_url` varchar(512) NOT NULL COMMENT '图片URL',
  `sort` tinyint NULL DEFAULT 0 COMMENT '排序',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_comment_id` (`comment_id`),
  INDEX `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单评论图片表';

-- 迁移数据(从comment_image迁移订单评论的图片)
-- INSERT INTO `comment_order_image` (`tenant_id`, `comment_id`, `image_url`, `sort`, `created_at`)
-- SELECT co.tenant_id, ci.comment_id, ci.image_url, ci.sort, ci.created_at
-- FROM `comment_image` ci
-- INNER JOIN `comment_order` co ON ci.comment_id = co.id;

-- 删除旧表(迁移完成后再执行)
-- DROP TABLE IF EXISTS `comment_image`;

-- -----------------------------------------------------------
-- 3.4 tmc_package_change_log 增加 trace_id
-- -----------------------------------------------------------

ALTER TABLE `tmc_package_change_log` ADD COLUMN `trace_id` varchar(64) NULL COMMENT '全链路追踪ID' AFTER `change_content`;
ALTER TABLE `tmc_package_change_log` ADD INDEX `idx_trace_id` (`trace_id`);


-- ============================================================
-- PART 4: 数据迁移脚本 (手动执行, 需确认后逐条运行)
-- ============================================================

-- -----------------------------------------------------------
-- 4.1 售后子表: 从主表after_sale回填tenant_id
-- -----------------------------------------------------------

-- UPDATE `after_sale_flight` af
--   INNER JOIN `after_sale` a ON af.after_sale_id = a.id
--   SET af.tenant_id = a.tenant_id
--   WHERE af.tenant_id IS NULL;

-- UPDATE `after_sale_hotel` ah
--   INNER JOIN `after_sale` a ON ah.after_sale_id = a.id
--   SET ah.tenant_id = a.tenant_id
--   WHERE ah.tenant_id IS NULL;

-- UPDATE `after_sale_train` at2
--   INNER JOIN `after_sale` a ON at2.after_sale_id = a.id
--   SET at2.tenant_id = a.tenant_id
--   WHERE at2.tenant_id IS NULL;

-- -----------------------------------------------------------
-- 4.2 收藏子表: 从主表favorite回填tenant_id
-- -----------------------------------------------------------

-- UPDATE `favorite_flight` ff
--   INNER JOIN `favorite` f ON ff.favorite_id = f.id
--   SET ff.tenant_id = f.tenant_id
--   WHERE ff.tenant_id IS NULL;

-- UPDATE `favorite_hotel` fh
--   INNER JOIN `favorite` f ON fh.favorite_id = f.id
--   SET fh.tenant_id = f.tenant_id
--   WHERE fh.tenant_id IS NULL;

-- UPDATE `favorite_mall` fm
--   INNER JOIN `favorite` f ON fm.favorite_id = f.id
--   SET fm.tenant_id = f.tenant_id
--   WHERE fm.tenant_id IS NULL;

-- -----------------------------------------------------------
-- 4.3 优惠券领券: 从coupon回填tenant_id
-- -----------------------------------------------------------

-- UPDATE `coupon_user` cu
--   INNER JOIN `coupon` c ON cu.coupon_id = c.id
--   SET cu.tenant_id = c.tenant_id
--   WHERE cu.tenant_id IS NULL;

-- -----------------------------------------------------------
-- 4.4 评论图片: 从comment_order回填tenant_id
-- -----------------------------------------------------------

-- UPDATE `comment_image` ci
--   INNER JOIN `comment_order` co ON ci.comment_id = co.id
--   SET ci.tenant_id = co.tenant_id
--   WHERE ci.tenant_id IS NULL;

-- -----------------------------------------------------------
-- 4.5 标签关联: 从user_tag回填tenant_id
-- -----------------------------------------------------------

-- UPDATE `user_tag_relation` utr
--   INNER JOIN `user_tag` ut ON utr.tag_id = ut.id
--   SET utr.tenant_id = ut.tenant_id
--   WHERE utr.tenant_id IS NULL;

-- -----------------------------------------------------------
-- 4.6 通知相关: 需根据业务逻辑确认tenant_id来源
-- -----------------------------------------------------------

-- notify_template: 从MMC配置中获取tenant_id
-- notify_config: 从MMC配置中获取tenant_id
-- notify_inbox: 从C端用户所属MMC获取tenant_id

-- -----------------------------------------------------------
-- 4.7 order_tag: 旧数据迁移为JSON格式
-- -----------------------------------------------------------

-- UPDATE `order`
--   SET order_tag = JSON_OBJECT('tag', order_tag)
--   WHERE order_tag IS NOT NULL
--     AND order_tag != ''
--     AND JSON_VALID(order_tag) = 0;


-- ============================================================
-- 执行统计
-- ============================================================
-- PART 1 (BLOCK):
--   DROP TABLE: 6张 (审批流程设计器表)
--   ALTER TABLE DROP COLUMN: 1张 (approval_instance移除flow_id/flow_version)
--
-- PART 2 (SHOULD - tenant_id):
--   ALTER TABLE ADD COLUMN + INDEX: 24张表补充tenant_id
--
-- PART 2 (SHOULD - trace_id):
--   ALTER TABLE ADD COLUMN + INDEX: 18张流水表补充trace_id
--
-- PART 3 (MAY):
--   ALTER TABLE MODIFY: 1张 (order_tag改JSON)
--   ALTER TABLE ADD COLUMN: 1张 (order_item_car补充5个用车字段)
--   CREATE TABLE: 1张 (comment_order_image)
--   ALTER TABLE ADD COLUMN: 1张 (tmc_package_change_log加trace_id)
--
-- PART 4 (数据迁移):
--   手动执行, 需逐条确认后运行
-- ============================================================
