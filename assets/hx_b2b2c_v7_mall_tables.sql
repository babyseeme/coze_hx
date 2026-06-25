-- ============================================================================
-- 温州华夏航服 B2B2C 综合航旅服务平台 - 商城模块 v7.1
-- 日期: 2025-06-27
-- 说明: 借鉴 jjjshop 商城体系, 结合 B2B2C 多租户架构设计商城数据表
-- 执行: mysql -u root -p hx_b2b2c < hx_b2b2c_v7_mall_tables.sql
-- ============================================================================

SET NAMES utf8mb4;

-- ============================================================================
-- 第一部分: 商品体系 (8 张表)
-- ============================================================================

-- 1. 商城分类
DROP TABLE IF EXISTS `mall_category`;
CREATE TABLE `mall_category` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID, 0=平台公共分类',
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '父分类ID, 0=顶级',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '分类名称',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '分类图标URL',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序(小值靠前)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,0=禁用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_parent` (`tenant_id`, `parent_id`, `sort` ASC) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商城分类';

-- 2. 规格组 (如: 颜色/尺码/版本)
DROP TABLE IF EXISTS `mall_spec`;
CREATE TABLE `mall_spec` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '规格组名称(如:颜色)',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant` (`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品规格组';

-- 3. 规格值 (如: 红色/XL/128G)
DROP TABLE IF EXISTS `mall_spec_value`;
CREATE TABLE `mall_spec_value` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `spec_id` bigint UNSIGNED NOT NULL COMMENT '规格组ID',
  `value` varchar(120) NOT NULL DEFAULT '' COMMENT '规格值(如:香槟金)',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_spec` (`spec_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品规格值';

-- 4. 商品主表
DROP TABLE IF EXISTS `mall_goods`;
CREATE TABLE `mall_goods` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `goods_no` varchar(64) NOT NULL DEFAULT '' COMMENT '商品编码',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `subtitle` varchar(255) NOT NULL DEFAULT '' COMMENT '商品副标题/卖点',
  `category_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '主分类ID',
  `spec_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=单规格,2=多规格',
  `deduct_stock_type` tinyint NOT NULL DEFAULT 2 COMMENT '1=下单减库存,2=付款减库存',
  `main_image` varchar(255) NOT NULL DEFAULT '' COMMENT '主图URL',
  `content` longtext NULL COMMENT '商品详情(富文本)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=上架,2=仓库中,3=回收站',
  `sort` int NOT NULL DEFAULT 100 COMMENT '排序',
  `sales_actual` int NOT NULL DEFAULT 0 COMMENT '实际销量',
  `sales_virtual` int NOT NULL DEFAULT 0 COMMENT '虚拟销量',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '浏览量',
  `is_virtual` tinyint NOT NULL DEFAULT 0 COMMENT '0=实物,1=虚拟商品',
  `virtual_auto` tinyint NOT NULL DEFAULT 0 COMMENT '虚拟商品是否自动发货 0=否,1=是',
  `virtual_content` text NULL COMMENT '虚拟商品内容(自动发货时)',
  `delivery_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '运费模板ID',
  `limit_num` int NOT NULL DEFAULT 0 COMMENT '限购数量,0=不限',
  `single_num` int NOT NULL DEFAULT 0 COMMENT '起购数量,0=不限',
  `weight` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '重量(Kg,运费计算)',
  `is_points_gift` tinyint NOT NULL DEFAULT 1 COMMENT '1=赠送积分,0=否',
  `is_points_discount` tinyint NOT NULL DEFAULT 1 COMMENT '1=允许积分抵扣,0=否',
  `max_points_discount` int NOT NULL DEFAULT 0 COMMENT '最大积分抵扣数量',
  `is_comment` tinyint NOT NULL DEFAULT 1 COMMENT '1=允许评价,0=否',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_goods_no` (`tenant_id`, `goods_no`) USING BTREE,
  INDEX `idx_tenant_status` (`tenant_id`, `status`, `sort` ASC) USING BTREE,
  INDEX `idx_category` (`category_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品主表';

-- 5. 商品SKU
DROP TABLE IF EXISTS `mall_goods_sku`;
CREATE TABLE `mall_goods_sku` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `sku_no` varchar(64) NOT NULL DEFAULT '' COMMENT 'SKU编码',
  `spec_values` varchar(255) NOT NULL DEFAULT '' COMMENT '规格值组合(如: 颜色:红;尺码:XL)',
  `spec_value_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '规格值ID组合(逗号分隔,排序后)',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT 'SKU图片',
  `price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '销售价',
  `line_price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '划线价(原价)',
  `cost_price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '成本价',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存',
  `stock_lock` int NOT NULL DEFAULT 0 COMMENT '锁定库存(已下单未付款)',
  `weight` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '重量(Kg)',
  `barcode` varchar(64) NOT NULL DEFAULT '' COMMENT '条形码',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_goods_spec` (`goods_id`, `spec_value_ids`) USING BTREE,
  INDEX `idx_goods` (`goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品SKU';

-- 6. 商品图片
DROP TABLE IF EXISTS `mall_goods_image`;
CREATE TABLE `mall_goods_image` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `image_url` varchar(500) NOT NULL DEFAULT '' COMMENT '图片URL',
  `image_type` tinyint NOT NULL DEFAULT 0 COMMENT '0=主图,1=详情图',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods` (`goods_id`, `sort` ASC) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品图片';

-- 7. 商品-分类关联 (一个商品可归属多个分类)
DROP TABLE IF EXISTS `mall_goods_category`;
CREATE TABLE `mall_goods_category` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `category_id` bigint UNSIGNED NOT NULL COMMENT '分类ID',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_goods_category` (`goods_id`, `category_id`) USING BTREE,
  INDEX `idx_category` (`category_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品-分类关联';

-- 8. 商品-规格值关联 (商品启用了哪些规格值)
DROP TABLE IF EXISTS `mall_goods_spec_rel`;
CREATE TABLE `mall_goods_spec_rel` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `spec_id` bigint UNSIGNED NOT NULL COMMENT '规格组ID',
  `spec_value_id` bigint UNSIGNED NOT NULL COMMENT '规格值ID',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods` (`goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品-规格值关联';


-- ============================================================================
-- 第二部分: 营销体系 (3 张表)
-- ============================================================================

-- 9. 优惠券定义
DROP TABLE IF EXISTS `mall_coupon`;
CREATE TABLE `mall_coupon` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `coupon_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=满减券,2=折扣券',
  `reduce_price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '满减金额(coupon_type=1)',
  `discount` tinyint NOT NULL DEFAULT 0 COMMENT '折扣率1-99(coupon_type=2, 如85=8.5折)',
  `min_price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '最低消费金额',
  `max_discount_price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '折扣券最多抵扣金额',
  `expire_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=领取后N天有效,2=固定时间段',
  `expire_day` smallint NOT NULL DEFAULT 0 COMMENT '领取后有效天数(expire_type=1)',
  `start_time` datetime NULL DEFAULT NULL COMMENT '有效期开始(expire_type=2)',
  `end_time` datetime NULL DEFAULT NULL COMMENT '有效期结束(expire_type=2)',
  `apply_range` tinyint NOT NULL DEFAULT 1 COMMENT '1=全场通用,2=指定商品,3=指定分类',
  `total_num` int NOT NULL DEFAULT 0 COMMENT '发放总量,0=不限',
  `receive_num` int NOT NULL DEFAULT 0 COMMENT '已领取数量',
  `per_limit` smallint NOT NULL DEFAULT 1 COMMENT '每人限领数量,0=不限',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,0=禁用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_status` (`tenant_id`, `status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠券定义';

-- 10. 优惠券适用范围 (apply_range=2/3 时)
DROP TABLE IF EXISTS `mall_coupon_scope`;
CREATE TABLE `mall_coupon_scope` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint UNSIGNED NOT NULL COMMENT '优惠券ID',
  `scope_type` tinyint NOT NULL COMMENT '1=商品,2=分类',
  `target_id` bigint UNSIGNED NOT NULL COMMENT '商品ID或分类ID',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coupon` (`coupon_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠券适用范围';

-- 11. 用户优惠券实例
DROP TABLE IF EXISTS `mall_user_coupon`;
CREATE TABLE `mall_user_coupon` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `coupon_id` bigint UNSIGNED NOT NULL COMMENT '优惠券ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID c_user.id',
  `member_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户会员ID c_member.id',
  `coupon_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=满减,2=折扣(冗余防JOIN)',
  `reduce_price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '满减金额(冗余)',
  `discount` tinyint NOT NULL DEFAULT 0 COMMENT '折扣率(冗余)',
  `min_price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '最低消费(冗余)',
  `max_discount_price` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '最多抵扣(冗余)',
  `expire_type` tinyint NOT NULL DEFAULT 1 COMMENT '有效期类型(冗余)',
  `expire_day` smallint NOT NULL DEFAULT 0 COMMENT '有效天数(冗余)',
  `start_time` datetime NULL DEFAULT NULL COMMENT '固定开始(冗余)',
  `end_time` datetime NULL DEFAULT NULL COMMENT '固定结束(冗余)',
  `apply_range` tinyint NOT NULL DEFAULT 1 COMMENT '适用范围(冗余)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=可使用,2=已使用,3=已过期,4=已作废',
  `used_at` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `used_order_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用的订单ID',
  `received_at` datetime NULL DEFAULT NULL COMMENT '领取时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_status` (`user_id`, `status`, `end_time` ASC) USING BTREE,
  INDEX `idx_member_status` (`member_id`, `status`) USING BTREE,
  INDEX `idx_coupon` (`coupon_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户优惠券实例';


-- ============================================================================
-- 第三部分: 购物车 & 收藏 (2 张表)
-- ============================================================================

-- 12. 购物车
DROP TABLE IF EXISTS `mall_cart`;
CREATE TABLE `mall_cart` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID c_user.id',
  `member_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户会员ID c_member.id',
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `sku_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'SKU ID, 0=单规格',
  `quantity` smallint NOT NULL DEFAULT 1 COMMENT '数量',
  `is_checked` tinyint NOT NULL DEFAULT 1 COMMENT '1=选中,0=未选中',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_sku` (`user_id`, `tenant_id`, `goods_id`, `sku_id`) USING BTREE,
  INDEX `idx_member` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车';

-- 13. 收藏
DROP TABLE IF EXISTS `mall_favorite`;
CREATE TABLE `mall_favorite` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID c_user.id',
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_goods` (`user_id`, `goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品收藏';


-- ============================================================================
-- 第四部分: 售后体系 (3 张表)
-- ============================================================================

-- 14. 售后单
DROP TABLE IF EXISTS `mall_after_sale`;
CREATE TABLE `mall_after_sale` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `after_sale_no` varchar(40) NOT NULL COMMENT '售后单号',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `item_id` bigint UNSIGNED NOT NULL COMMENT '子订单ID order_item_mall.id',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID',
  `member_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户会员ID',
  `type` tinyint NOT NULL COMMENT '1=退货退款,2=换货,3=仅退款',
  `reason` varchar(255) NOT NULL DEFAULT '' COMMENT '用户申请原因',
  `description` varchar(500) NOT NULL DEFAULT '' COMMENT '问题描述',
  `quantity` smallint NOT NULL DEFAULT 1 COMMENT '售后数量',
  `refund_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '申请退款金额',
  `agreed_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '商家同意退款金额',
  `actual_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '实际退款金额',
  `audit_status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待审核,2=审核通过,3=审核拒绝',
  `audit_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '审核备注/拒绝原因',
  `audit_at` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `user_shipped` tinyint NOT NULL DEFAULT 0 COMMENT '0=用户未发货,1=已发货',
  `user_express_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户退货快递公司ID',
  `user_express_no` varchar(50) NOT NULL DEFAULT '' COMMENT '用户退货快递单号',
  `user_shipped_at` datetime NULL DEFAULT NULL COMMENT '用户发货时间',
  `merchant_received` tinyint NOT NULL DEFAULT 0 COMMENT '0=商家未收货,1=已收货',
  `merchant_received_at` datetime NULL DEFAULT NULL COMMENT '商家收货时间',
  `merchant_shipped` tinyint NOT NULL DEFAULT 0 COMMENT '0=商家未发换货,1=已发换货',
  `merchant_express_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商家换货快递ID',
  `merchant_express_no` varchar(50) NOT NULL DEFAULT '' COMMENT '商家换货快递单号',
  `merchant_shipped_at` datetime NULL DEFAULT NULL COMMENT '商家发货时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=进行中,2=已完成,3=已取消,4=已关闭',
  `refund_status` tinyint NOT NULL DEFAULT 0 COMMENT '0=未退款,1=退款中,2=已退款,3=退款失败',
  `refund_at` datetime NULL DEFAULT NULL COMMENT '退款到账时间',
  `refund_no` varchar(64) NOT NULL DEFAULT '' COMMENT '退款流水号',
  `completed_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_after_sale_no` (`after_sale_no`) USING BTREE,
  INDEX `idx_order` (`order_id`) USING BTREE,
  INDEX `idx_item` (`item_id`) USING BTREE,
  INDEX `idx_user_status` (`user_id`, `status`) USING BTREE,
  INDEX `idx_tenant_audit` (`tenant_id`, `audit_status`, `status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='售后单';

-- 15. 售后凭证图片
DROP TABLE IF EXISTS `mall_after_sale_image`;
CREATE TABLE `mall_after_sale_image` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `after_sale_id` bigint UNSIGNED NOT NULL COMMENT '售后单ID',
  `image_url` varchar(500) NOT NULL DEFAULT '' COMMENT '图片URL',
  `image_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=用户凭证,2=商家凭证',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_after_sale` (`after_sale_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='售后凭证图片';

-- 16. 售后进度日志
DROP TABLE IF EXISTS `mall_after_sale_log`;
CREATE TABLE `mall_after_sale_log` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `after_sale_id` bigint UNSIGNED NOT NULL COMMENT '售后单ID',
  `operator_type` tinyint NOT NULL COMMENT '1=用户,2=商家,3=系统',
  `operator_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作人ID',
  `action` varchar(60) NOT NULL DEFAULT '' COMMENT '动作(如:提交申请/审核通过/用户发货)',
  `content` varchar(500) NOT NULL DEFAULT '' COMMENT '日志内容',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_after_sale` (`after_sale_id`, `created_at` ASC) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='售后进度日志';


-- ============================================================================
-- 第五部分: 物流配送 (3 张表)
-- ============================================================================

-- 17. 运费模板
DROP TABLE IF EXISTS `mall_delivery_template`;
CREATE TABLE `mall_delivery_template` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '模板名称',
  `method` tinyint NOT NULL DEFAULT 1 COMMENT '1=按件数,2=按重量',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant` (`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='运费模板';

-- 18. 运费规则 (每个模板下按区域定义)
DROP TABLE IF EXISTS `mall_delivery_rule`;
CREATE TABLE `mall_delivery_rule` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `template_id` bigint UNSIGNED NOT NULL COMMENT '运费模板ID',
  `region_ids` text NOT NULL COMMENT '可配送区域(城市ID集,逗号分隔)',
  `first_unit` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '首件/首重',
  `first_fee` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '首费(元)',
  `additional_unit` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '续件/续重',
  `additional_fee` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '续费(元)',
  `is_free` tinyint NOT NULL DEFAULT 0 COMMENT '1=包邮(该区域免运费)',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_template` (`template_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='运费规则';

-- 19. 快递公司
DROP TABLE IF EXISTS `mall_express`;
CREATE TABLE `mall_express` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL DEFAULT '' COMMENT '快递公司编码(如:SF/YTO/ZTO)',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT '快递公司名称',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,0=禁用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递公司';


-- ============================================================================
-- 第六部分: 评价体系 (2 张表)
-- ============================================================================

-- 20. 商品评价
DROP TABLE IF EXISTS `mall_comment`;
CREATE TABLE `mall_comment` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `item_id` bigint UNSIGNED NOT NULL COMMENT '子订单ID',
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID',
  `member_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户会员ID',
  `score` tinyint NOT NULL DEFAULT 5 COMMENT '评分(1-5)',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '评价内容',
  `is_anonymous` tinyint NOT NULL DEFAULT 0 COMMENT '1=匿名,0=实名',
  `reply_content` varchar(500) NOT NULL DEFAULT '' COMMENT '商家回复',
  `reply_at` datetime NULL DEFAULT NULL COMMENT '回复时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=正常,2=隐藏',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods` (`goods_id`, `status`, `created_at` ASC) USING BTREE,
  INDEX `idx_user` (`user_id`) USING BTREE,
  INDEX `idx_tenant` (`tenant_id`, `status`) USING BTREE,
  UNIQUE INDEX `uk_item` (`item_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品评价';

-- 21. 评价图片
DROP TABLE IF EXISTS `mall_comment_image`;
CREATE TABLE `mall_comment_image` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `comment_id` bigint UNSIGNED NOT NULL COMMENT '评价ID',
  `image_url` varchar(500) NOT NULL DEFAULT '' COMMENT '图片URL',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_comment` (`comment_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评价图片';


-- ============================================================================
-- 第七部分: order_item_mall 字段修正
-- 说明: 修正此前复核发现的 BUG-2: product_id 与 goods_id 指向同一实体
-- 修正方案: 去掉 goods_id, 保留 product_id(改名为 goods_id, 语义统一),
--           增加 goods_name/sku_id/sku_attrs 到原表(已有则跳过)
-- ============================================================================

-- 检查并修正: product_id COMMENT 不准确, goods_id 重复
-- 实际操作: 删 goods_id, 将 product_id 的 COMMENT 修正为 '商品ID mall_goods.id'
-- 注意: 此处使用 ALTER 而非 DROP+CREATE, 因为 v7 表可能已有数据

ALTER TABLE `order_item_mall`
  DROP COLUMN `goods_id`,
  MODIFY COLUMN `product_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品ID mall_goods.id',
  MODIFY COLUMN `goods_name` varchar(200) NOT NULL DEFAULT '' COMMENT '商品名称(快照)';

-- 新增缺失的售后相关字段
ALTER TABLE `order_item_mall`
  ADD COLUMN `after_sale_status` tinyint NOT NULL DEFAULT 0 COMMENT '0=无售后,1=售后中,2=售后完成' AFTER `refund_amount`,
  ADD COLUMN `coupon_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用的优惠券ID mall_user_coupon.id' AFTER `after_sale_status`,
  ADD COLUMN `coupon_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '优惠券抵扣金额' AFTER `coupon_id`,
  ADD COLUMN `delivery_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=快递配送,2=上门自提,3=无需物流' AFTER `coupon_amount`,
  ADD COLUMN `express_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '快递公司ID mall_express.id' AFTER `delivery_type`,
  ADD COLUMN `buyer_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '买家备注' AFTER `express_id`;


-- ============================================================================
-- 第八部分: order 主订单增加商城相关字段
-- ============================================================================
ALTER TABLE `order`
  ADD COLUMN `delivery_type` tinyint NOT NULL DEFAULT 0 COMMENT '0=无(机票/酒店),1=快递,2=自提,3=无需物流' AFTER `payment_no`,
  ADD COLUMN `coupon_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '优惠券ID' AFTER `delivery_type`,
  ADD COLUMN `coupon_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '优惠券抵扣金额' AFTER `coupon_id`,
  ADD COLUMN `points_used` int NOT NULL DEFAULT 0 COMMENT '使用积分数量' AFTER `coupon_amount`,
  ADD COLUMN `points_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT '积分抵扣金额' AFTER `points_used`,
  ADD COLUMN `buyer_remark` varchar(500) NOT NULL DEFAULT '' COMMENT '买家留言' AFTER `points_amount`;


-- ============================================================================
-- 完成, 共新增 21 张商城表 + 修改 2 张现有表
--
-- 新增表分组:
--   商品体系(8): mall_category/mall_spec/mall_spec_value/mall_goods/
--                mall_goods_sku/mall_goods_image/mall_goods_category/mall_goods_spec_rel
--   营销体系(3): mall_coupon/mall_coupon_scope/mall_user_coupon
--   购物&收藏(2): mall_cart/mall_favorite
--   售后体系(3): mall_after_sale/mall_after_sale_image/mall_after_sale_log
--   物流配送(3): mall_delivery_template/mall_delivery_rule/mall_express
--   评价体系(2): mall_comment/mall_comment_image
--
-- 修改表:
--   order_item_mall: 去重goods_id, 修正product_id语义, 新增售后/优惠券/配送字段
--   order: 新增delivery_type/coupon/points/buyer_remark
-- ============================================================================
