/*
 Navicat MySQL Data Transfer

 Source Server         : 47.109.88.164（node-master）
 Source Server Type    : MySQL
 Source Server Version : 80035
 Source Host           : 47.109.88.164:30006
 Source Schema         : hx_b2b2c

 Target Server Type    : MySQL
 Target Server Version : 80035
 File Encoding         : 65001

 Date: 27/06/2026 01:12:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for air_airline
-- ----------------------------
DROP TABLE IF EXISTS `air_airline`;
CREATE TABLE `air_airline`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码(IATA)',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司简称',
  `full_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司全称',
  `ticket_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票3字码(IATA)',
  `area` enum('N','I') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT 'N=国内 I=国际',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'logo URL',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC, `deleted_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司主数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_airline_accounts
-- ----------------------------
DROP TABLE IF EXISTS `air_airline_accounts`;
CREATE TABLE `air_airline_accounts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_type` tinyint NOT NULL COMMENT '1=航司 2=OTA',
  `airline_id` int UNSIGNED NULL DEFAULT NULL COMMENT '航司ID(air_airline.id)',
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司2字码(冗余)',
  `platform_id` int UNSIGNED NULL DEFAULT NULL COMMENT 'OTA平台ID(air_platform.id)',
  `account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账号名/用户名',
  `account_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账号密码(AES加密存储)',
  `is_domestic` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支持国内: 0=否 1=是',
  `is_international` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支持国际: 0=否 1=是',
  `purchase_channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支持采购渠道(如BSP/B2B/BOP/OP)',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Office号(生编用)',
  `backend_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '后台地址',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `tenant_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属租户ID(为空=平台级)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_airline_code`(`airline_code` ASC) USING BTREE,
  INDEX `idx_airline_id`(`airline_id` ASC) USING BTREE,
  INDEX `idx_account_name`(`account_name` ASC) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司/OTA采购账号(B2B接口凭证)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_airline_notice
-- ----------------------------
DROP TABLE IF EXISTS `air_airline_notice`;
CREATE TABLE `air_airline_notice`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容(富文本/HTML)',
  `external_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '外部链接(航司官方)',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_airline_code`(`airline_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司预定须知/注意事项' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_airport
-- ----------------------------
DROP TABLE IF EXISTS `air_airport`;
CREATE TABLE `air_airport`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '机场3字码(IATA)',
  `name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '机场中文名',
  `name_en` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '机场英文名',
  `city_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市3字码',
  `city_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市中文名',
  `city_name_en` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市英文名',
  `province` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省/州',
  `country_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国家代码(ISO 3166-1 alpha-2)',
  `country_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国家中文名',
  `continent` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '洲',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_city_code`(`city_code` ASC) USING BTREE,
  INDEX `idx_country_code`(`country_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '机场主数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_cabin
-- ----------------------------
DROP TABLE IF EXISTS `air_cabin`;
CREATE TABLE `air_cabin`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `cabin_level_id` int UNSIGNED NOT NULL COMMENT '舱位等级ID',
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码(冗余,便于查询)',
  `cabin_code` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位编号(如Y/B/M/K等)',
  `discount` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '成人折扣(如\"45\"=4.5折)',
  `is_sellable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=可销售舱位 0=不可销售',
  `is_published` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=公布运价舱位 0=不公布',
  `baggage_override` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '行李额覆盖(为空则继承等级标准)',
  `base_agency_fee` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '基础代理费',
  `sort` int NOT NULL DEFAULT 10 COMMENT '权重: 越大越靠前',
  `effect_start` date NULL DEFAULT NULL COMMENT '生效日期',
  `effect_end` date NULL DEFAULT NULL COMMENT '失效日期',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_airline_cabin`(`airline_code` ASC, `cabin_code` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_cabin_level_id`(`cabin_level_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '舱位明细(等级下具体舱位)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_cabin_level
-- ----------------------------
DROP TABLE IF EXISTS `air_cabin_level`;
CREATE TABLE `air_cabin_level`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位等级名称(经济舱/公务舱/头等舱等)',
  `standard_cabin_code` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标准舱位代码(Y/C/F)',
  `child_discount` decimal(5, 2) NULL DEFAULT NULL COMMENT '儿童折扣(如67.00=6.7折)',
  `infant_discount` decimal(5, 2) NULL DEFAULT NULL COMMENT '婴儿折扣(如10.00=1折)',
  `baggage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标准行李额(如\"20KG\")',
  `sort` int NOT NULL DEFAULT 100 COMMENT '权重: 越大越靠前',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_airline_std_cabin`(`airline_code` ASC, `standard_cabin_code` ASC, `deleted_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司舱位等级' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_fuel
-- ----------------------------
DROP TABLE IF EXISTS `air_fuel`;
CREATE TABLE `air_fuel`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码',
  `adult_fuel` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '成人燃油费(元)',
  `child_fuel` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费(元)',
  `infant_fuel` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿燃油费(元)',
  `mileage_threshold` int NOT NULL DEFAULT 800 COMMENT '里程阈值(KM): 超过此值用另一档',
  `adult_fuel_long` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人燃油费-长航线(元)',
  `child_fuel_long` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费-长航线(元)',
  `infant_fuel_long` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿燃油费-长航线(元)',
  `effect_start` date NULL DEFAULT NULL COMMENT '生效日期',
  `effect_end` date NULL DEFAULT NULL COMMENT '失效日期',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_airline_effect`(`airline_code` ASC, `effect_start` ASC, `effect_end` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司燃油费(按里程分档)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_fuel_detail
-- ----------------------------
DROP TABLE IF EXISTS `air_fuel_detail`;
CREATE TABLE `air_fuel_detail`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码',
  `dep_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发机场3字码',
  `arr_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场3字码',
  `mileage` int NOT NULL DEFAULT 0 COMMENT '里程(KM)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_route`(`airline_code` ASC, `dep_code` ASC, `arr_code` ASC, `deleted_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航程里程(航司×出发×到达)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_gauge
-- ----------------------------
DROP TABLE IF EXISTS `air_gauge`;
CREATE TABLE `air_gauge`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码',
  `cabin_codes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用舱位编号集合(逗号分隔, 空=全部)',
  `gauge_type_id` int UNSIGNED NOT NULL COMMENT '客规时间段类型ID',
  `effect_start` datetime NULL DEFAULT NULL COMMENT '生效时间',
  `effect_end` datetime NULL DEFAULT NULL COMMENT '失效时间',
  `discount_scope` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '折扣范围(如\"1-3折/4折以上\")',
  `fee_rate` json NULL COMMENT '退改费率集合({refund_rate,change_rate,format})',
  `refund_desc` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票说明',
  `change_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '签转规定',
  `is_noshow` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为noshow规则',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_airline_cabin`(`airline_code` ASC, `gauge_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '客规(退改签规则)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_gauge_type
-- ----------------------------
DROP TABLE IF EXISTS `air_gauge_type`;
CREATE TABLE `air_gauge_type`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码',
  `change_type` tinyint UNSIGNED NOT NULL COMMENT '1=退票 2=改签',
  `hours_before` int UNSIGNED NULL DEFAULT NULL COMMENT '航班离站前N小时',
  `hours_before_inclusive` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'hours_before是否包含(0=不包含 1=包含)',
  `hours_after` int NULL DEFAULT NULL COMMENT '航班离站后N小时',
  `hours_after_inclusive` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'hours_after是否包含(0=不包含 1=包含)',
  `sort` int NOT NULL DEFAULT 10 COMMENT '排序: 越小越优先匹配',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_airline_type`(`airline_code` ASC, `change_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '客规时间段类型(退/改的时段定义)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_plane_model
-- ----------------------------
DROP TABLE IF EXISTS `air_plane_model`;
CREATE TABLE `air_plane_model`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '机型代码(如738/A320)',
  `manufacturer` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生产厂家(Boeing/Airbus/COMAC等)',
  `build_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '机建费(元)',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC, `deleted_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '机型数据(含机建费)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_platform
-- ----------------------------
DROP TABLE IF EXISTS `air_platform`;
CREATE TABLE `air_platform`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '平台名称(如IBE+/航班管家/TravelPort)',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '平台编码',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `auth_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回填票号授权码',
  `config_template` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置模板(JSON)',
  `data_source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '数据源标识(IBE/SNSTN等)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购平台(上游数据源配置)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_region
-- ----------------------------
DROP TABLE IF EXISTS `air_region`;
CREATE TABLE `air_region`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '行政区划代码',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `level` tinyint UNSIGNED NOT NULL COMMENT '层级: 1=省/直辖市 2=市 3=区县',
  `parent_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '父级行政区划代码',
  `province_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '顶级(省)行政区划代码',
  `city_iata_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市3字码(关联air_airport.city_code)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE,
  INDEX `idx_parent_code`(`parent_code` ASC) USING BTREE,
  INDEX `idx_province_code`(`province_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '行政区划(省/市/区三级)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for attachment
-- ----------------------------
DROP TABLE IF EXISTS `attachment`;
CREATE TABLE `attachment`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `storage_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local' COMMENT '存储模式:local=本地,oss=阿里云,qiniu=七牛云,cos=腾讯云',
  `origin_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原文件名',
  `object_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新文件名',
  `hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件hash',
  `mime_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源类型',
  `storage_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '存储目录',
  `suffix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件后缀',
  `size_byte` bigint NULL DEFAULT NULL COMMENT '字节数',
  `size_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件大小',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'url地址',
  `created_by` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updated_by` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `attachment_hash_unique`(`hash` ASC) USING BTREE,
  INDEX `attachment_storage_path_index`(`storage_path` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '上传文件信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for c_member
-- ----------------------------
DROP TABLE IF EXISTS `c_member`;
CREATE TABLE `c_member`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'c_user.id',
  `member_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '会员号(商户内唯一)',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '会员昵称',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '会员头像(可不同于c_user默认)',
  `level` smallint NULL DEFAULT 1 COMMENT '会员等级: 1=普通,2=银卡,3=金卡,4=钻石',
  `points_balance` int NULL DEFAULT 0 COMMENT '积分余额',
  `points_version` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '积分版本号(乐观锁,每次积分变更+1)',
  `grade_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '会员等级 c_member_grade.id',
  `total_earned_points` int NOT NULL DEFAULT 0 COMMENT '累计获取积分(用于等级判定,不减)',
  `wallet_balance` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '钱包余额',
  `balance_version` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '余额版本号(乐观锁,每次余额变更+1)',
  `total_spent` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '累计消费金额(升级依据)',
  `order_count` int NULL DEFAULT 0 COMMENT '累计订单数',
  `sign_count` int NULL DEFAULT 0 COMMENT '连续签到天数',
  `last_sign_date` date NULL DEFAULT NULL COMMENT '最后签到日期',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'mini' COMMENT '注册来源: mini/web/h5/app/ota',
  `status` tinyint NULL DEFAULT 1 COMMENT '1=正常,2=冻结,3=注销',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_member_no`(`tenant_id` ASC, `member_no` ASC) USING BTREE,
  INDEX `idx_tenant_user`(`tenant_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_tenant_level`(`tenant_id` ASC, `level` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'C端会员(商户维度隔离)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for c_member_address
-- ----------------------------
DROP TABLE IF EXISTS `c_member_address`;
CREATE TABLE `c_member_address`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `receiver_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收件人姓名',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收件人手机',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '省',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '市',
  `district` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '区/县',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '详细地址',
  `is_default` tinyint NULL DEFAULT 2 COMMENT '1=默认,2=非默认',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_member`(`tenant_id` ASC, `member_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员收货地址' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for c_member_balance_log
-- ----------------------------
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员余额变更日志(版本控制+乐观锁)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for c_member_corporate
-- ----------------------------
DROP TABLE IF EXISTS `c_member_corporate`;
CREATE TABLE `c_member_corporate`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'c_user.id(平台级自然人)',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '申报商户ID(哪个商户提交的申报)',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id(冗余,商户维度查询)',
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `group_id` bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id(所属集团)',
  `contract_id` bigint UNSIGNED NOT NULL COMMENT 'corporate_contract.id(所属签约关系)',
  `corp_member_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '大客户成员编号(航司分配或按规则生成)',
  `corp_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'enterprise' COMMENT 'enterprise/gp',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=有效,2=已退出,3=已过期,4=处罚冻结',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'auto' COMMENT 'auto=平台自动申报,manual=人工申报',
  `policy_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '触发自动申报的政策ID',
  `apply_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '最近一次生效的申报记录ID',
  `activated_at` datetime NULL DEFAULT NULL COMMENT '身份生效时间',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '身份过期时间(协议到期/资格到期)',
  `exited_at` datetime NULL DEFAULT NULL COMMENT '退出时间',
  `exit_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '退出原因',
  `penalty_note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '处罚备注(如: 同一航司重复申报被航司处罚)',
  `uk_guard` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS (if((`status` = 1),concat(`user_id`,_utf8mb4'-',`airline_code`),NULL)) STORED COMMENT '部分唯一约束守卫列(仅status=1时参与唯一校验)' NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_airline_active`(`uk_guard` ASC) USING BTREE,
  INDEX `idx_tenant_member`(`tenant_id` ASC, `member_id` ASC) USING BTREE,
  INDEX `idx_contract`(`contract_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_user_airline`(`user_id` ASC, `airline_code` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户成员身份(平台级,同航司唯一)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for c_member_corporate_apply
-- ----------------------------
DROP TABLE IF EXISTS `c_member_corporate_apply`;
CREATE TABLE `c_member_corporate_apply`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `apply_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申报单号',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'c_user.id',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '申报商户ID',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `group_id` bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id(目标集团)',
  `contract_id` bigint UNSIGNED NOT NULL COMMENT 'corporate_contract.id(目标签约关系)',
  `corp_member_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生成的大客户成员编号',
  `submit_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'api/file',
  `submit_status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待提交,2=已提交,3=审核中,4=已通过,5=已拒绝,6=已撤回,7=提交失败',
  `submit_at` datetime NULL DEFAULT NULL COMMENT '提交时间(向航司/供应商提交)',
  `batch_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '批量提交批次号(file方式用)',
  `file_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '上传文件ID(file方式,attachment.id)',
  `api_request` json NULL COMMENT 'API请求报文快照',
  `api_response` json NULL COMMENT 'API响应报文快照',
  `review_note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '审核备注/拒绝原因',
  `reviewed_at` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `corporate_id_result` bigint UNSIGNED NULL DEFAULT 0 COMMENT '审核通过后写入 c_member_corporate.id',
  `apply_source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'auto' COMMENT 'auto=平台自动/manual=人工',
  `policy_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '触发的自动申报政策ID',
  `conflict_check` json NULL COMMENT '申报前冲突检测结果快照',
  `fail_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '提交/审核失败原因',
  `retry_count` tinyint NULL DEFAULT 0 COMMENT '重试次数',
  `next_retry_at` datetime NULL DEFAULT NULL COMMENT '下次重试时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `uk_guard` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS (if((`submit_status` in (1,2,3)),concat(`user_id`,_utf8mb4'-',`airline_code`),NULL)) STORED COMMENT '部分唯一约束守卫列(防止重复提交待审核申报)' NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_apply_no`(`apply_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_user_airline_pending`(`uk_guard` ASC) USING BTREE,
  INDEX `idx_user_airline`(`user_id` ASC, `airline_code` ASC, `submit_status` ASC) USING BTREE,
  INDEX `idx_tenant_member`(`tenant_id` ASC, `member_id` ASC) USING BTREE,
  INDEX `idx_contract`(`contract_id` ASC, `submit_status` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC) USING BTREE,
  INDEX `idx_batch`(`batch_no` ASC) USING BTREE,
  INDEX `idx_status_retry`(`submit_status` ASC, `next_retry_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户成员申报记录(全量审计)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for c_member_grade
-- ----------------------------
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员等级定义(按商户自定义)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for c_member_points_log
-- ----------------------------
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员积分变更日志(版本控制+过期追踪)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for c_passenger
-- ----------------------------
DROP TABLE IF EXISTS `c_passenger`;
CREATE TABLE `c_passenger`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名(脱敏)',
  `name_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '姓名密文',
  `name_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '姓名HMAC',
  `id_type` tinyint NOT NULL COMMENT '证件类型: 1=身份证,2=护照,3=港澳通行证,4=台胞证,5=其他',
  `id_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号(脱敏)',
  `id_number_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '证件号密文',
  `id_number_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '证件号HMAC',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号(脱敏)',
  `phone_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '手机号密文',
  `phone_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '手机号HMAC',
  `nationality` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CN' COMMENT '国籍/地区码',
  `birthday` date NULL DEFAULT NULL COMMENT '出生日期',
  `gender` tinyint NULL DEFAULT 0 COMMENT '0=未知,1=男,2=女',
  `is_self` tinyint NULL DEFAULT 2 COMMENT '1=本人,2=他人',
  `is_default` tinyint NULL DEFAULT 2 COMMENT '1=默认,2=非默认',
  `flight_count` int NULL DEFAULT 0 COMMENT '乘机次数(排序依据)',
  `train_count` int NULL DEFAULT 0 COMMENT '乘车次数',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_member_id_hash`(`tenant_id` ASC, `member_id` ASC, `id_type` ASC, `id_number_hash` ASC) USING BTREE,
  INDEX `idx_tenant_member`(`tenant_id` ASC, `member_id` ASC) USING BTREE,
  INDEX `idx_phone_hash`(`phone_hash` ASC) USING BTREE,
  INDEX `idx_name_hash`(`name_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '常用旅客(商户会员维度)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for c_user
-- ----------------------------
DROP TABLE IF EXISTS `c_user`;
CREATE TABLE `c_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自然人ID',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号(脱敏: 138****8888)',
  `phone_encrypted` varbinary(255) NOT NULL COMMENT '手机号密文(AES-256-GCM)',
  `phone_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '手机号HMAC-SHA256(精确查找+唯一)',
  `real_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '真实姓名(脱敏: 张*明)',
  `real_name_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '真实姓名密文',
  `real_name_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '真实姓名HMAC',
  `id_type` tinyint NULL DEFAULT NULL COMMENT '证件类型: 1=身份证,2=护照,3=港澳通行证,4=台胞证,5=其他',
  `id_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号(脱敏: 310***********1234)',
  `id_number_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '证件号密文',
  `id_number_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '证件号HMAC(跨商户唯一校验)',
  `union_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '微信UnionID(跨小程序关联同一自然人)',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '默认头像',
  `gender` tinyint NULL DEFAULT 0 COMMENT '0=未知,1=男,2=女',
  `birthday` date NULL DEFAULT NULL COMMENT '出生日期',
  `status` tinyint NULL DEFAULT 1 COMMENT '1=正常,2=冻结,3=注销',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_phone_hash`(`phone_hash` ASC) USING BTREE,
  UNIQUE INDEX `uk_id_type_hash`(`id_type` ASC, `id_number_hash` ASC) USING BTREE,
  INDEX `idx_union_id`(`union_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_real_name_hash`(`real_name_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'C端自然人(平台级,全局唯一)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for corporate_contract
-- ----------------------------
DROP TABLE IF EXISTS `corporate_contract`;
CREATE TABLE `corporate_contract`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id` bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id',
  `airline_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '签约航司二字码(如: CA)',
  `contract_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '大客户协议编号',
  `corp_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'enterprise' COMMENT 'enterprise=企业大客户/gp=公务员',
  `is_realname` tinyint NOT NULL DEFAULT 1 COMMENT '1=实名制(需白名单),0=非实名(年龄范围内即可)',
  `age_min` tinyint NULL DEFAULT 0 COMMENT '非实名最小年龄(0=不限, 如: 20)',
  `age_max` tinyint NULL DEFAULT 0 COMMENT '非实名最大年龄(0=不限, 如: 65)',
  `multi_idcard` tinyint NULL DEFAULT 0 COMMENT '1=支持多证件上报(如CZ多证件模板),0=单证件',
  `pre_cmd_domestic` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '国内出票前置指令(如: RMK IC CZ/2602342)',
  `pre_cmd_intl` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '国际出票前置指令(如: SSR CKIN CA HK1 VICO0WN10FTG)',
  `price_cmd_domestic` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '国内运价指令(如: PAT:A#CDK2602342)',
  `price_cmd_intl` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '国际运价指令(如: QTE:/CZ///#CV2602342)',
  `biz_scope` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'both' COMMENT 'domestic=仅国内/intl=仅国际/both=国内+国际',
  `discount_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '优惠信息摘要(如: 经济舱95折/公务舱9折/无优惠送里程)',
  `travel_target` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '差旅指标(如: 20万/年)',
  `exclude_dates` json NULL COMMENT '不适用日期规则(JSON数组)',
  `submit_methods` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支持的申报方式: api/file/api+file',
  `api_config` json NULL COMMENT 'API申报配置(接口地址/认证方式/报文格式)',
  `whitelist_tpl_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '白名单模板ID(corporate_whitelist_template.id)',
  `submit_cycle` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'realtime' COMMENT '申报周期: realtime/daily/weekly/monthly',
  `review_days` smallint NULL DEFAULT 0 COMMENT '预估审核天数(0=实时)',
  `protocol_start` date NULL DEFAULT NULL COMMENT '协议开始日期(如: 2023-10-10)',
  `protocol_end` date NULL DEFAULT NULL COMMENT '协议结束日期(如: 2026-12-31)',
  `current_start` date NULL DEFAULT NULL COMMENT '当前有效期开始(如: 2023-10-10,每年续签会更新)',
  `current_end` date NULL DEFAULT NULL COMMENT '当前有效期结束(如: 2024-10-10)',
  `corp_code_rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '大客户员工编号生成规则(如: {airline}-{group}-{seq})',
  `status` tinyint NULL DEFAULT 1 COMMENT '1=有效,2=暂停,3=已过期',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `created_by` bigint NULL DEFAULT 0,
  `updated_by` bigint NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_airline`(`group_id` ASC, `airline_code` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_airline_status`(`airline_code` ASC, `status` ASC) USING BTREE,
  INDEX `idx_corp_type`(`corp_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_realname`(`is_realname` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户签约关系(集团×航司,航司特定配置)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for corporate_group
-- ----------------------------
DROP TABLE IF EXISTS `corporate_group`;
CREATE TABLE `corporate_group`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '大客户集团名称(如: 华为技术有限公司)',
  `group_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '集团编码(唯一标识,如: HUAWEI)',
  `unified_social_credit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '统一社会信用代码(企业唯一标识)',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '集团联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '集团联系电话',
  `address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '集团地址',
  `industry` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '行业分类(如: 通信/互联网/金融)',
  `scale` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '企业规模(如: 万人以上/千人/百人)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `status` tinyint NULL DEFAULT 1 COMMENT '1=有效,2=停用',
  `created_by` bigint NULL DEFAULT 0,
  `updated_by` bigint NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_code`(`group_code` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户集团主体(平台级,一个集团可跨航司签约)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for corporate_policy
-- ----------------------------
DROP TABLE IF EXISTS `corporate_policy`;
CREATE TABLE `corporate_policy`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `policy_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '政策名称(如: CA航司华北散客自动申报华为)',
  `policy_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '政策编码(唯一)',
  `airline_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '适用航司',
  `group_id` bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id(目标集团)',
  `contract_id` bigint UNSIGNED NOT NULL COMMENT 'corporate_contract.id(目标签约关系)',
  `conditions` json NOT NULL COMMENT '申报条件(航线/舱位/消费金额/航班次数等)',
  `priority` smallint NULL DEFAULT 0 COMMENT '优先级(数值越大越高,同航司多政策时取最高)',
  `auto_submit` tinyint NULL DEFAULT 1 COMMENT '1=匹配后自动提交申报,2=仅提示需人工确认',
  `status` tinyint NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_by` bigint NULL DEFAULT 0,
  `updated_by` bigint NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_policy_code`(`policy_code` ASC) USING BTREE,
  INDEX `idx_airline_status`(`airline_code` ASC, `status` ASC) USING BTREE,
  INDEX `idx_contract`(`contract_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户自动申报政策' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for corporate_policy_match_log
-- ----------------------------
DROP TABLE IF EXISTS `corporate_policy_match_log`;
CREATE TABLE `corporate_policy_match_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` bigint UNSIGNED NOT NULL COMMENT '签约ID',
  `group_id` bigint UNSIGNED NOT NULL COMMENT '集团ID',
  `rule_id` int UNSIGNED NULL DEFAULT NULL COMMENT '匹配到的规则ID(未匹配=NULL)',
  `match_type` tinyint UNSIGNED NOT NULL COMMENT '匹配类型: 1=自动下单匹配 2=批量散客匹配',
  `c_user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID',
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司2字码',
  `dep_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场',
  `arr_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场',
  `cabin_code` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位代码',
  `discount` decimal(5, 2) NULL DEFAULT NULL COMMENT '当前折扣',
  `match_result` enum('matched','not_matched','conflict') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '匹配结果',
  `match_snapshot` json NULL COMMENT '匹配快照(输入条件+匹配到的规则详情)',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联订单号(下单匹配时)',
  `apply_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联申报ID(c_member_corporate_apply.id)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_contract_id`(`contract_id` ASC) USING BTREE,
  INDEX `idx_c_user_id`(`c_user_id` ASC, `airline_code` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户政策匹配记录(自动匹配+批量匹配日志)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for corporate_policy_rule
-- ----------------------------
DROP TABLE IF EXISTS `corporate_policy_rule`;
CREATE TABLE `corporate_policy_rule`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` bigint UNSIGNED NOT NULL COMMENT '大客户签约ID',
  `group_id` bigint UNSIGNED NOT NULL COMMENT '大客户集团ID',
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司2字码(空=全部航司)',
  `dep_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场(空=全部)',
  `arr_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场(空=全部)',
  `cabin_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位等级(如Y/C/F, 空=全部)',
  `discount_min` decimal(5, 2) NULL DEFAULT NULL COMMENT '折扣下限(如30.00=3折起)',
  `discount_max` decimal(5, 2) NULL DEFAULT NULL COMMENT '折扣上限(如100.00=全价)',
  `trip_type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '行程类型: 1=单程 2=往返 3=多程(空=全部)',
  `is_domestic` tinyint(1) NULL DEFAULT NULL COMMENT '1=国内 0=国际 NULL=全部',
  `priority` int NOT NULL DEFAULT 100 COMMENT '优先级: 数值越小越优先',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_contract_id`(`contract_id` ASC) USING BTREE,
  INDEX `idx_airline_route`(`airline_code` ASC, `dep_code` ASC, `arr_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户政策匹配规则(航线/舱位/折扣匹配)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for corporate_whitelist_batch
-- ----------------------------
DROP TABLE IF EXISTS `corporate_whitelist_batch`;
CREATE TABLE `corporate_whitelist_batch`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `batch_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '批次号(如: WL20250701123456)',
  `contract_id` bigint UNSIGNED NOT NULL COMMENT '签约关系ID(corporate_contract.id)',
  `group_id` bigint UNSIGNED NOT NULL COMMENT '集团ID(corporate_group.id)',
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码(冗余)',
  `template_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '使用的模板ID(corporate_whitelist_template.id)',
  `submit_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'api/file',
  `action_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'A' COMMENT 'A=新增,D=删除,U=更新',
  `total_count` int NOT NULL DEFAULT 0 COMMENT '总条数',
  `success_count` int NOT NULL DEFAULT 0 COMMENT '成功条数',
  `fail_count` int NOT NULL DEFAULT 0 COMMENT '失败条数',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待提交,2=提交中,3=部分成功,4=全部成功,5=全部失败,6=已撤回',
  `file_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '上传文件ID(file方式,attachment.id)',
  `file_original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '原始文件名',
  `api_request` json NULL COMMENT 'API请求报文快照',
  `api_response` json NULL COMMENT 'API响应报文快照',
  `submit_at` datetime NULL DEFAULT NULL COMMENT '提交时间',
  `finished_at` datetime NULL DEFAULT NULL COMMENT '处理完成时间',
  `review_note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '审核/处理备注',
  `operator_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名(冗余)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_batch_no`(`batch_no` ASC) USING BTREE,
  INDEX `idx_contract`(`contract_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_airline_status`(`airline_code` ASC, `status` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '白名单提交批次(一次提交=一个批次)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for corporate_whitelist_member
-- ----------------------------
DROP TABLE IF EXISTS `corporate_whitelist_member`;
CREATE TABLE `corporate_whitelist_member`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `batch_id` bigint UNSIGNED NOT NULL COMMENT '批次ID(corporate_whitelist_batch.id)',
  `contract_id` bigint UNSIGNED NOT NULL COMMENT '签约关系ID(冗余)',
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码(冗余)',
  `line_no` int NOT NULL DEFAULT 0 COMMENT '原始行号(文件导入时)',
  `action` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'A' COMMENT 'A=新增,D=删除',
  `name_cn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '中文姓名',
  `name_en` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '英文姓名(姓/名拼接后)',
  `last_name_en` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '英文姓',
  `first_name_en` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '英文名',
  `id_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '证件类型(NI=身份证/PP=护照/HX=回乡证/HY=海员证/TW=台胞证/OTHER=其他)',
  `id_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '证件号码',
  `id_number_2_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '第二证件类型',
  `id_number_2` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '第二证件号码(如CZ多证件模式)',
  `id_number_3_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '第三证件类型',
  `id_number_3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '第三证件号码',
  `birthday` date NULL DEFAULT NULL COMMENT '出生日期',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'M=男/F=女',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '手机号码(CA国航要求)',
  `corp_member_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '大客户成员编码(3U川航/企业卡号等)',
  `employee_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '员工类型(CA国航: 普通管理员/管理员/领导)',
  `expiry_date` date NULL DEFAULT NULL COMMENT '协议截止日期(3U川航要求)',
  `extra_fields` json NULL COMMENT '模板扩展字段(航司特有字段)',
  `user_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '关联c_user.id(匹配后回填)',
  `member_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '关联c_member.id(匹配后回填)',
  `passenger_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '关联c_passenger.id(匹配后回填)',
  `match_status` tinyint NULL DEFAULT 0 COMMENT '0=未匹配,1=已匹配,2=多人匹配需人工,3=匹配失败',
  `match_log` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '匹配日志',
  `submit_status` tinyint NULL DEFAULT 1 COMMENT '1=待提交,2=已提交,3=已通过,4=已拒绝,5=提交失败',
  `submit_error` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '提交/审核失败原因',
  `corporate_member_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '审核通过后写入 c_member_corporate.id',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_batch`(`batch_id` ASC, `submit_status` ASC) USING BTREE,
  INDEX `idx_contract`(`contract_id` ASC, `action` ASC) USING BTREE,
  INDEX `idx_id_number`(`id_type` ASC, `id_number` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC, `airline_code` ASC) USING BTREE,
  INDEX `idx_match`(`match_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '白名单成员明细(航司视角名单数据)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for corporate_whitelist_template
-- ----------------------------
DROP TABLE IF EXISTS `corporate_whitelist_template`;
CREATE TABLE `corporate_whitelist_template`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称(如: CZ单证件白名单/CZ多证件白名单/3U白名单)',
  `template_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码(如: CZ_SINGLE_ID/CZ_MULTI_ID/3U_STANDARD)',
  `field_config` json NOT NULL COMMENT '字段配置(JSON,定义每个字段的名称/类型/必填/校验规则)',
  `sample_row` json NULL COMMENT '示例行数据(供前端展示/下载模板)',
  `max_rows_per_batch` int NULL DEFAULT 5000 COMMENT '单次最大导入行数',
  `supported_actions` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'A,D' COMMENT '支持的操作类型: A=新增,D=删除,U=更新',
  `encoding` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'UTF-8' COMMENT '文件编码要求',
  `file_format` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'xlsx' COMMENT '文件格式: xlsx/csv/txt',
  `submit_method` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'file' COMMENT '提交方式: api/file/both',
  `api_endpoint` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'API提交地址(如航司提供)',
  `api_config` json NULL COMMENT 'API鉴权/请求格式配置',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '模板说明/注意事项',
  `is_active` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,0=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_template_code`(`template_code` ASC) USING BTREE,
  INDEX `idx_airline`(`airline_code` ASC, `is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司白名单导入模板(各航司格式不同)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for data_permission_policy
-- ----------------------------
DROP TABLE IF EXISTS `data_permission_policy`;
CREATE TABLE `data_permission_policy`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pmc' COMMENT '所属端:pmc/tmc/mmc',
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '租户ID,saas端=0',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户ID（与角色二选一）',
  `position_id` bigint NOT NULL DEFAULT 0 COMMENT '岗位ID（与用户二选一）',
  `role_id` bigint NOT NULL DEFAULT 0 COMMENT '角色ID(user/position/role 三选一)',
  `policy_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '策略类型（DEPT_SELF, DEPT_TREE, ALL, SELF, CUSTOM_DEPT, CUSTOM_FUNC）',
  `resource` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '作用资源:order/customer/...',
  `is_default` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否默认策略（默认值：true）',
  `value` json NULL COMMENT '策略值',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_subject`(`platform` ASC, `tenant_id` ASC, `user_id` ASC, `role_id` ASC, `position_id` ASC) USING BTREE,
  INDEX `idx_resource`(`platform` ASC, `tenant_id` ASC, `resource` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '数据权限策略' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for finance_company_account
-- ----------------------------
DROP TABLE IF EXISTS `finance_company_account`;
CREATE TABLE `finance_company_account`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID(TMC)',
  `account_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账户编号(如: FA20250701001)',
  `account_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账户名称(如: 华夏航空-华为POC)',
  `group_id` bigint UNSIGNED NOT NULL COMMENT '企业集团ID corporate_group.id',
  `group_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '企业名称(冗余)',
  `account_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账户类型: PREPAID=预存/CREDIT=信用/MIXED=混合',
  `credit_limit` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '授信额度(account_type=CREDIT/MIXED时有效)',
  `credit_used` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '已用额度',
  `credit_available` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '可用额度',
  `balance` decimal(14, 2) NOT NULL DEFAULT 0.00 COMMENT '账户余额(预存部分)',
  `frozen_amount` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '冻结金额(在途订单占用)',
  `settle_period` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'MONTHLY' COMMENT '结算周期: REALTIME/WEEKLY/BIWEEKLY/MONTHLY',
  `settle_day` tinyint NULL DEFAULT NULL COMMENT '结算日(周期为月结时,每月几号,如: 15)',
  `overdue_grace_days` tinyint NULL DEFAULT 7 COMMENT '逾期宽限天数',
  `account_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AVAILABLE' COMMENT '账户状态: AVAILABLE/DISABLED/FROZEN/CLOSED',
  `open_at` datetime NULL DEFAULT NULL COMMENT '开户时间',
  `last_settle_at` datetime NULL DEFAULT NULL COMMENT '最近结算时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_account_no`(`tenant_id` ASC, `account_no` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC) USING BTREE,
  INDEX `idx_status`(`account_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业结算账户' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_company_account_log
-- ----------------------------
DROP TABLE IF EXISTS `finance_company_account_log`;
CREATE TABLE `finance_company_account_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `account_id` bigint UNSIGNED NOT NULL COMMENT '企业结算账户ID',
  `group_id` bigint UNSIGNED NOT NULL COMMENT '企业集团ID',
  `change_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '变动类型: RECHARGE=充值/CONSUME=消费/REFUND=退款回充/FREEZE=冻结/UNFREEZE=解冻/ADJUST=调整/CREDIT_RELEASE=信用释放',
  `amount` decimal(14, 2) NOT NULL COMMENT '变动金额(正=增,负=减)',
  `balance_before` decimal(14, 2) NOT NULL COMMENT '变动前余额',
  `balance_after` decimal(14, 2) NOT NULL COMMENT '变动后余额',
  `related_biz_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '关联业务类型: order/payment/bill/adjust',
  `related_biz_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '关联业务ID',
  `operator_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_account`(`account_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_tenant_type`(`tenant_id` ASC, `change_type` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业账户流水' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_company_bill
-- ----------------------------
DROP TABLE IF EXISTS `finance_company_bill`;
CREATE TABLE `finance_company_bill`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID(TMC)',
  `bill_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账单编号(如: B2026032300001)',
  `account_id` bigint UNSIGNED NOT NULL COMMENT '企业结算账户ID',
  `group_id` bigint UNSIGNED NOT NULL COMMENT '企业集团ID',
  `group_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '企业名称(冗余)',
  `period_start` date NOT NULL COMMENT '结算期间开始',
  `period_end` date NOT NULL COMMENT '结算期间结束',
  `bill_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NORMAL' COMMENT '账单类型: NORMAL=正常/ADJUSTMENT=调整/CREDIT_NOTE=贷项通知单/DEBIT_NOTE=借项通知单',
  `bill_category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NORMAL' COMMENT '账单分类: NORMAL=正常/ADJUSTMENT=调整',
  `total_amount` decimal(14, 2) NOT NULL COMMENT '账单总金额',
  `paid_amount` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '已付金额',
  `outstanding_amount` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '未付金额',
  `overdue_date` date NULL DEFAULT NULL COMMENT '逾期日期',
  `bill_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT' COMMENT '账单状态: DRAFT/PENDING/CONFIRMED/SENT/OVERDUE/PARTIAL_PAID/PAID/CANCELLED',
  `invoice_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NOT_INVOICED' COMMENT '开票状态: NOT_INVOICED/INVOICED/PARTIAL_INVOICED',
  `reconciliation_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNRECONCILED' COMMENT '清账状态: UNRECONCILED/PARTIAL_RECONCILED/RECONCILED',
  `adjustment_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '调整项类型: DISCOUNT/CHARGE/OTHER',
  `settle_user_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '结算员ID',
  `settle_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '结算员姓名',
  `confirm_at` datetime NULL DEFAULT NULL COMMENT '确认时间',
  `sent_at` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_bill_no`(`tenant_id` ASC, `bill_no` ASC) USING BTREE,
  INDEX `idx_account`(`account_id` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC, `bill_status` ASC) USING BTREE,
  INDEX `idx_status`(`bill_status` ASC, `overdue_date` ASC) USING BTREE,
  INDEX `idx_period`(`period_start` ASC, `period_end` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业账单(销售侧)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_company_bill_item
-- ----------------------------
DROP TABLE IF EXISTS `finance_company_bill_item`;
CREATE TABLE `finance_company_bill_item`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `bill_id` bigint UNSIGNED NOT NULL COMMENT '企业账单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单号(冗余)',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务类型: flight/train/hotel/mall/insurance/car',
  `sales_amount` decimal(12, 2) NOT NULL COMMENT '销售金额',
  `service_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `insurance_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '保险费',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `settle_amount` decimal(12, 2) NOT NULL COMMENT '应结金额(销售+服务+保险-退款)',
  `contract_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '大客户签约ID(用于政策匹配)',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_bill`(`bill_id` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业账单明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_company_payment
-- ----------------------------
DROP TABLE IF EXISTS `finance_company_payment`;
CREATE TABLE `finance_company_payment`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID(TMC)',
  `payment_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来款编号(如: CP2026032300001)',
  `account_id` bigint UNSIGNED NOT NULL COMMENT '企业结算账户ID',
  `group_id` bigint UNSIGNED NOT NULL COMMENT '企业集团ID',
  `group_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '企业名称(冗余)',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '付款方式: BANK_TRANSFER/ALIPAY/WECHAT/CASH/OTHER',
  `payment_amount` decimal(14, 2) NOT NULL COMMENT '付款金额',
  `payment_at` datetime NOT NULL COMMENT '付款时间',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '银行名称',
  `bank_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '银行账号',
  `voucher_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '付款凭证URL',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT '状态: PENDING/CONFIRMED/CANCELLED',
  `confirm_user_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '确认人ID',
  `confirm_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '确认人姓名',
  `confirm_at` datetime NULL DEFAULT NULL COMMENT '确认时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_payment_no`(`tenant_id` ASC, `payment_no` ASC) USING BTREE,
  INDEX `idx_account`(`account_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC, `payment_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业来款(客户付款记录)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_invoice
-- ----------------------------
DROP TABLE IF EXISTS `finance_invoice`;
CREATE TABLE `finance_invoice`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID(TMC)',
  `invoice_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发票号码(如: INV2026032300001)',
  `invoice_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发票类型: VAT_NORMAL=增值税普通/VAT_SPECIAL=增值税专用/ELECTRONIC=电子发票/TRAIN_INVOICE=火车票',
  `group_id` bigint UNSIGNED NOT NULL COMMENT '开票企业ID corporate_group.id',
  `group_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '开票企业名称(冗余)',
  `bill_id` bigint UNSIGNED NOT NULL COMMENT '关联账单ID(企业账单/供应商账单)',
  `bill_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '关联账单编号(冗余)',
  `bill_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'COMPANY' COMMENT '账单方向: COMPANY=企业账单/SUPPLIER=供应商账单',
  `invoice_amount` decimal(14, 2) NOT NULL COMMENT '发票金额',
  `tax_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '税额',
  `tax_rate` decimal(5, 4) NULL DEFAULT NULL COMMENT '税率(如: 0.06=6%)',
  `invoice_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发票抬头',
  `tax_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '税号',
  `invoice_content` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '发票内容(如: *经纪代理服务*)',
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '收件人姓名',
  `receiver_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '收件人电话',
  `receiver_address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '收件人地址',
  `invoice_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT '发票状态: PENDING/ISSUED/SENT/RECEIVED/INVALID/RETURNED',
  `issue_at` datetime NULL DEFAULT NULL COMMENT '开票时间',
  `send_at` datetime NULL DEFAULT NULL COMMENT '寄送时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_invoice_no`(`tenant_id` ASC, `invoice_no` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC) USING BTREE,
  INDEX `idx_bill`(`bill_type` ASC, `bill_id` ASC) USING BTREE,
  INDEX `idx_status`(`invoice_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '发票' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_refund
-- ----------------------------
DROP TABLE IF EXISTS `finance_refund`;
CREATE TABLE `finance_refund`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `refund_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '退款编号(如: REF2026032300001)',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务类型: flight/train/hotel/mall/insurance/car',
  `item_id` bigint UNSIGNED NOT NULL COMMENT '子订单ID(按biz_type指向对应item表)',
  `group_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '企业集团ID(大客户退款时)',
  `refund_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '退款类型: VOLUNTARY=自愿/INVOLUNTARY=非自愿(航变等)',
  `refund_amount` decimal(12, 2) NOT NULL COMMENT '退款金额',
  `refund_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款手续费',
  `actual_refund_amount` decimal(12, 2) NOT NULL COMMENT '实际退款金额(退款金额-手续费)',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '退款原因',
  `refund_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT '退款状态: PENDING/AUDIT_PASS/AUDIT_REJECT/PROCESSING/COMPLETED/FAILED/CANCELLED',
  `audit_user_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '审核人ID',
  `audit_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '审核人姓名',
  `audit_at` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '审核备注',
  `refund_at` datetime NULL DEFAULT NULL COMMENT '退款完成时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_refund_no`(`tenant_id` ASC, `refund_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_item`(`biz_type` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC) USING BTREE,
  INDEX `idx_status`(`refund_status` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款单(全业务线通用)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_refund_log
-- ----------------------------
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款流程日志(审核+审批+打款全追踪)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_supplier_account
-- ----------------------------
DROP TABLE IF EXISTS `finance_supplier_account`;
CREATE TABLE `finance_supplier_account`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID(TMC)',
  `account_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账户编号',
  `supplier_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '供应商类型: airline_b2b/airline_b2t/ota_ctrip/ota_qunar/ota_meituan/ota_fligy/railway_12306/hotel_supplier/mall_supplier/insurance_supplier',
  `supplier_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '供应商ID(如航司则关联air_airline.id)',
  `supplier_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '供应商名称',
  `account_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CREDIT' COMMENT '账户类型: PREPAID=预存/CREDIT=信用',
  `balance` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '账户余额(预存)',
  `credit_limit` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '授信额度',
  `credit_used` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '已用额度',
  `credit_available` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '可用额度',
  `settle_period` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'MONTHLY' COMMENT '结算周期',
  `account_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '账户状态: ACTIVE/INACTIVE/FROZEN',
  `open_at` datetime NULL DEFAULT NULL COMMENT '开户时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_account_no`(`tenant_id` ASC, `account_no` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_supplier_type`(`supplier_type` ASC, `supplier_id` ASC) USING BTREE,
  INDEX `idx_status`(`account_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '供应商账户(采购侧)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_supplier_bill
-- ----------------------------
DROP TABLE IF EXISTS `finance_supplier_bill`;
CREATE TABLE `finance_supplier_bill`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID(TMC)',
  `bill_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账单编号(如: SB2026032300001)',
  `supplier_account_id` bigint UNSIGNED NOT NULL COMMENT '供应商账户ID',
  `supplier_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '供应商类型',
  `supplier_id` bigint UNSIGNED NOT NULL COMMENT '供应商ID',
  `supplier_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商名称(冗余)',
  `period_start` date NOT NULL COMMENT '账单期间开始',
  `period_end` date NOT NULL COMMENT '账单期间结束',
  `bill_amount` decimal(14, 2) NOT NULL COMMENT '账单金额(应付)',
  `paid_amount` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '已付金额',
  `outstanding_amount` decimal(14, 2) NULL DEFAULT 0.00 COMMENT '未付金额',
  `bill_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT' COMMENT '状态: DRAFT/CONFIRMED/SENT/PARTIAL_PAID/PAID/OVERDUE/CANCELLED',
  `due_date` date NULL DEFAULT NULL COMMENT '到期日期',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_bill_no`(`tenant_id` ASC, `bill_no` ASC) USING BTREE,
  INDEX `idx_supplier_account`(`supplier_account_id` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_supplier`(`supplier_type` ASC, `supplier_id` ASC) USING BTREE,
  INDEX `idx_status`(`bill_status` ASC, `due_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '供应商账单(采购侧)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for finance_supplier_payment
-- ----------------------------
DROP TABLE IF EXISTS `finance_supplier_payment`;
CREATE TABLE `finance_supplier_payment`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID(TMC)',
  `payment_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '付款编号(如: SP2026032300001)',
  `supplier_bill_id` bigint UNSIGNED NOT NULL COMMENT '供应商账单ID',
  `supplier_account_id` bigint UNSIGNED NOT NULL COMMENT '供应商账户ID',
  `supplier_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '供应商类型',
  `supplier_id` bigint UNSIGNED NOT NULL COMMENT '供应商ID',
  `supplier_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商名称(冗余)',
  `payment_amount` decimal(14, 2) NOT NULL COMMENT '付款金额',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '付款方式: BANK_TRANSFER/ALIPAY/WECHAT/CASH/OTHER',
  `payment_at` datetime NOT NULL COMMENT '付款时间',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '收款银行',
  `bank_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '收款账号',
  `voucher_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '付款凭证URL',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT '状态: PENDING/APPROVED/PAID/CANCELLED',
  `approve_user_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '审批人ID',
  `approve_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '审批人姓名',
  `approve_at` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_payment_no`(`tenant_id` ASC, `payment_no` ASC) USING BTREE,
  INDEX `idx_bill`(`supplier_bill_id` ASC) USING BTREE,
  INDEX `idx_supplier`(`supplier_type` ASC, `supplier_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC, `payment_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '供应商付款(采购侧)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for hotel_brand
-- ----------------------------
DROP TABLE IF EXISTS `hotel_brand`;
CREATE TABLE `hotel_brand`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `brand_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '品牌编码(如: HILTON/ACCOR)',
  `brand_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '品牌名称(如: 希尔顿/雅高)',
  `brand_name_en` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '品牌英文名',
  `logo_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '品牌Logo URL',
  `level` tinyint NULL DEFAULT 0 COMMENT '品牌档次: 1=经济,2=舒适,3=高端,4=豪华',
  `country` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '所属国家',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序权重',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_brand_code`(`brand_code` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC, `sort_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '酒店品牌' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for hotel_info
-- ----------------------------
DROP TABLE IF EXISTS `hotel_info`;
CREATE TABLE `hotel_info`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `hotel_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '酒店编码(供应商侧唯一ID)',
  `hotel_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '酒店名称',
  `hotel_name_en` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '酒店英文名',
  `brand_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '品牌ID hotel_brand.id',
  `city_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '城市编码(对接air_region)',
  `city_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市名',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '行政区/商圈',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '详细地址',
  `longitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `latitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  `star_rate` tinyint NULL DEFAULT 0 COMMENT '星级: 1-5, 0=未评',
  `phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '酒店电话',
  `check_in_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '14:00' COMMENT '最早入住时间',
  `check_out_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '12:00' COMMENT '最晚退房时间',
  `facilities` json NULL COMMENT '设施标签(如: [\"WiFi\",\"停车场\",\"健身房\",\"游泳池\"])',
  `images` json NULL COMMENT '酒店图片列表(如: [{\"url\":\"...\",\"type\":\"exterior\",\"sort\":1}])',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '酒店简介',
  `supplier_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '数据来源: ota_ctrip/ota_meituan/ota_fligy/hotel_direct',
  `supplier_hotel_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商侧酒店ID',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序权重',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用,3=下架',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_hotel_code`(`hotel_code` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_city`(`city_code` ASC, `star_rate` ASC) USING BTREE,
  INDEX `idx_brand`(`brand_id` ASC) USING BTREE,
  INDEX `idx_supplier`(`supplier_type` ASC, `supplier_hotel_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC, `sort_order` ASC) USING BTREE,
  INDEX `idx_location`(`longitude` ASC, `latitude` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '酒店信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for hotel_room_type
-- ----------------------------
DROP TABLE IF EXISTS `hotel_room_type`;
CREATE TABLE `hotel_room_type`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `hotel_id` bigint UNSIGNED NOT NULL COMMENT '酒店ID hotel_info.id',
  `room_type_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '房型编码(供应商侧)',
  `room_type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '房型名称(如: 高级大床房)',
  `bed_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '床型: single_bed=单人大床/double_bed=双人双床/king_bed=豪华大床/twin_bed=标准双床',
  `area` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '面积(如: 35㎡)',
  `floor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '楼层范围(如: 5-12层)',
  `max_occupancy` tinyint NULL DEFAULT 2 COMMENT '最大入住人数',
  `breakfast` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '早餐: none=无早/single=单早/double=双早',
  `wifi` tinyint NULL DEFAULT 1 COMMENT '1=有WiFi,2=无WiFi',
  `window` tinyint NULL DEFAULT 1 COMMENT '1=有窗,2=无窗,3=部分有窗',
  `cancel_policy` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '取消政策摘要',
  `facilities` json NULL COMMENT '房型设施标签(如: [\"浴缸\",\"迷你吧\",\"保险箱\"])',
  `images` json NULL COMMENT '房型图片',
  `supplier_room_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商侧房型ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hotel`(`hotel_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_supplier`(`supplier_room_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '酒店房型' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for insurance_product
-- ----------------------------
DROP TABLE IF EXISTS `insurance_product`;
CREATE TABLE `insurance_product`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `product_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '产品编码',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '产品名称(如: 航空意外险-基础版)',
  `insurance_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '保险类型: aviation=航空意外/travel=旅行险/cancel=取消险/delay=延误险',
  `insurance_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '保险公司名称',
  `insurance_company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '保险公司编码',
  `premium` decimal(10, 2) NOT NULL COMMENT '保费(每份)',
  `coverage_amount` decimal(12, 2) NOT NULL COMMENT '保额',
  `coverage_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '保障内容摘要',
  `coverage_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '保障条款详情(JSON)',
  `effective_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生效规则(如: 出票后次日零时生效)',
  `duration_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'trip' COMMENT '保障期间: trip=单次行程/fixed=固定天数/year=年险',
  `duration_days` smallint NULL DEFAULT 0 COMMENT '固定天数(duration_type=fixed时有效)',
  `refund_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '退保规则',
  `sale_start_date` date NULL DEFAULT NULL COMMENT '销售开始日期',
  `sale_end_date` date NULL DEFAULT NULL COMMENT '销售结束日期',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序权重',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=上架,2=下架,3=停售',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code`(`tenant_id` ASC, `product_code` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_type`(`insurance_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_company`(`insurance_company_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险产品' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for mall_after_sale
-- ----------------------------
DROP TABLE IF EXISTS `mall_after_sale`;
CREATE TABLE `mall_after_sale`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `after_sale_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '售后单号',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `item_id` bigint UNSIGNED NOT NULL COMMENT '子订单ID order_item_mall.id',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID',
  `member_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户会员ID',
  `type` tinyint NOT NULL COMMENT '1=退货退款,2=换货,3=仅退款',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户申请原因',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '问题描述',
  `quantity` smallint NOT NULL DEFAULT 1 COMMENT '售后数量',
  `refund_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '申请退款金额',
  `agreed_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '商家同意退款金额',
  `actual_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '实际退款金额',
  `audit_status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待审核,2=审核通过,3=审核拒绝',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '审核备注/拒绝原因',
  `audit_at` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `user_shipped` tinyint NOT NULL DEFAULT 0 COMMENT '0=用户未发货,1=已发货',
  `user_express_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户退货快递公司ID',
  `user_express_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户退货快递单号',
  `user_shipped_at` datetime NULL DEFAULT NULL COMMENT '用户发货时间',
  `merchant_received` tinyint NOT NULL DEFAULT 0 COMMENT '0=商家未收货,1=已收货',
  `merchant_received_at` datetime NULL DEFAULT NULL COMMENT '商家收货时间',
  `merchant_shipped` tinyint NOT NULL DEFAULT 0 COMMENT '0=商家未发换货,1=已发换货',
  `merchant_express_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商家换货快递ID',
  `merchant_express_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商家换货快递单号',
  `merchant_shipped_at` datetime NULL DEFAULT NULL COMMENT '商家发货时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=进行中,2=已完成,3=已取消,4=已关闭',
  `refund_status` tinyint NOT NULL DEFAULT 0 COMMENT '0=未退款,1=退款中,2=已退款,3=退款失败',
  `refund_at` datetime NULL DEFAULT NULL COMMENT '退款到账时间',
  `refund_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '退款流水号',
  `completed_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_after_sale_no`(`after_sale_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_item`(`item_id` ASC) USING BTREE,
  INDEX `idx_user_status`(`user_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_tenant_audit`(`tenant_id` ASC, `audit_status` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '售后单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_after_sale_image
-- ----------------------------
DROP TABLE IF EXISTS `mall_after_sale_image`;
CREATE TABLE `mall_after_sale_image`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `after_sale_id` bigint UNSIGNED NOT NULL COMMENT '售后单ID',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片URL',
  `image_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=用户凭证,2=商家凭证',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_after_sale`(`after_sale_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '售后凭证图片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_after_sale_log
-- ----------------------------
DROP TABLE IF EXISTS `mall_after_sale_log`;
CREATE TABLE `mall_after_sale_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `after_sale_id` bigint UNSIGNED NOT NULL COMMENT '售后单ID',
  `operator_type` tinyint NOT NULL COMMENT '1=用户,2=商家,3=系统',
  `operator_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作人ID',
  `action` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '动作(如:提交申请/审核通过/用户发货)',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '日志内容',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_after_sale`(`after_sale_id` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '售后进度日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_cart
-- ----------------------------
DROP TABLE IF EXISTS `mall_cart`;
CREATE TABLE `mall_cart`  (
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
  UNIQUE INDEX `uk_user_sku`(`user_id` ASC, `tenant_id` ASC, `goods_id` ASC, `sku_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_user_sku`(`tenant_id` ASC, `member_id` ASC, `sku_id` ASC) USING BTREE,
  INDEX `idx_member`(`member_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '购物车' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_category
-- ----------------------------
DROP TABLE IF EXISTS `mall_category`;
CREATE TABLE `mall_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户ID, 0=平台公共分类',
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '父分类ID, 0=顶级',
  `name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分类图标URL',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序(小值靠前)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,0=禁用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_parent`(`tenant_id` ASC, `parent_id` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商城分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_comment
-- ----------------------------
DROP TABLE IF EXISTS `mall_comment`;
CREATE TABLE `mall_comment`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `item_id` bigint UNSIGNED NOT NULL COMMENT '子订单ID',
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID',
  `member_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户会员ID',
  `score` tinyint NOT NULL DEFAULT 5 COMMENT '评分(1-5)',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '评价内容',
  `is_anonymous` tinyint NOT NULL DEFAULT 0 COMMENT '1=匿名,0=实名',
  `reply_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商家回复',
  `reply_at` datetime NULL DEFAULT NULL COMMENT '回复时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=正常,2=隐藏',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item`(`item_id` ASC) USING BTREE,
  INDEX `idx_goods`(`goods_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品评价' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_comment_image
-- ----------------------------
DROP TABLE IF EXISTS `mall_comment_image`;
CREATE TABLE `mall_comment_image`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `comment_id` bigint UNSIGNED NOT NULL COMMENT '评价ID',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片URL',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_comment`(`comment_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '评价图片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_coupon
-- ----------------------------
DROP TABLE IF EXISTS `mall_coupon`;
CREATE TABLE `mall_coupon`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `coupon_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=满减券,2=折扣券',
  `reduce_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '满减金额(coupon_type=1)',
  `discount` tinyint NOT NULL DEFAULT 0 COMMENT '折扣率1-99(coupon_type=2, 如85=8.5折)',
  `min_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '最低消费金额',
  `max_discount_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '折扣券最多抵扣金额',
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
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '优惠券定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_coupon_scope
-- ----------------------------
DROP TABLE IF EXISTS `mall_coupon_scope`;
CREATE TABLE `mall_coupon_scope`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint UNSIGNED NOT NULL COMMENT '优惠券ID',
  `scope_type` tinyint NOT NULL COMMENT '1=商品,2=分类',
  `target_id` bigint UNSIGNED NOT NULL COMMENT '商品ID或分类ID',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coupon`(`coupon_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '优惠券适用范围' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_delivery_rule
-- ----------------------------
DROP TABLE IF EXISTS `mall_delivery_rule`;
CREATE TABLE `mall_delivery_rule`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `template_id` bigint UNSIGNED NOT NULL COMMENT '运费模板ID',
  `region_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '可配送区域(城市ID集,逗号分隔)',
  `first_unit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '首件/首重',
  `first_fee` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '首费(元)',
  `additional_unit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '续件/续重',
  `additional_fee` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '续费(元)',
  `is_free` tinyint NOT NULL DEFAULT 0 COMMENT '1=包邮(该区域免运费)',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_template`(`template_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '运费规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_delivery_template
-- ----------------------------
DROP TABLE IF EXISTS `mall_delivery_template`;
CREATE TABLE `mall_delivery_template`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '模板名称',
  `method` tinyint NOT NULL DEFAULT 1 COMMENT '1=按件数,2=按重量',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '运费模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_express
-- ----------------------------
DROP TABLE IF EXISTS `mall_express`;
CREATE TABLE `mall_express`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '快递公司编码(如:SF/YTO/ZTO)',
  `name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '快递公司名称',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,0=禁用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '快递公司' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_favorite
-- ----------------------------
DROP TABLE IF EXISTS `mall_favorite`;
CREATE TABLE `mall_favorite`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID c_user.id',
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_user_goods`(`tenant_id` ASC, `user_id` ASC, `goods_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品收藏' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods`;
CREATE TABLE `mall_goods`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `goods_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商品编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商品副标题/卖点',
  `category_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '主分类ID',
  `spec_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=单规格,2=多规格',
  `deduct_stock_type` tinyint NOT NULL DEFAULT 2 COMMENT '1=下单减库存,2=付款减库存',
  `main_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '主图URL',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '商品详情(富文本)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=上架,2=仓库中,3=回收站',
  `sort` int NOT NULL DEFAULT 100 COMMENT '排序',
  `sales_actual` int NOT NULL DEFAULT 0 COMMENT '实际销量',
  `sales_virtual` int NOT NULL DEFAULT 0 COMMENT '虚拟销量',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '浏览量',
  `is_virtual` tinyint NOT NULL DEFAULT 0 COMMENT '0=实物,1=虚拟商品',
  `virtual_auto` tinyint NOT NULL DEFAULT 0 COMMENT '虚拟商品是否自动发货 0=否,1=是',
  `virtual_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '虚拟商品内容(自动发货时)',
  `delivery_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '运费模板ID',
  `limit_num` int NOT NULL DEFAULT 0 COMMENT '限购数量,0=不限',
  `single_num` int NOT NULL DEFAULT 0 COMMENT '起购数量,0=不限',
  `weight` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '重量(Kg,运费计算)',
  `is_points_gift` tinyint NOT NULL DEFAULT 1 COMMENT '1=赠送积分,0=否',
  `is_points_discount` tinyint NOT NULL DEFAULT 1 COMMENT '1=允许积分抵扣,0=否',
  `max_points_discount` int NOT NULL DEFAULT 0 COMMENT '最大积分抵扣数量',
  `is_comment` tinyint NOT NULL DEFAULT 1 COMMENT '1=允许评价,0=否',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_goods_no`(`tenant_id` ASC, `goods_no` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `sort` ASC) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_category`;
CREATE TABLE `mall_goods_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `category_id` bigint UNSIGNED NOT NULL COMMENT '分类ID',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_goods_category`(`goods_id` ASC, `category_id` ASC) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品-分类关联' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_image
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_image`;
CREATE TABLE `mall_goods_image`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片URL',
  `image_type` tinyint NOT NULL DEFAULT 0 COMMENT '0=主图,1=详情图',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods`(`goods_id` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品图片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_sku`;
CREATE TABLE `mall_goods_sku`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `sku_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'SKU编码',
  `spec_values` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规格值组合(如: 颜色:红;尺码:XL)',
  `spec_value_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规格值ID组合(逗号分隔,排序后)',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'SKU图片',
  `price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '销售价',
  `line_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '划线价(原价)',
  `cost_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '成本价',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存',
  `stock_lock` int NOT NULL DEFAULT 0 COMMENT '锁定库存(已下单未付款)',
  `weight` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '重量(Kg)',
  `barcode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '条形码',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_goods_spec`(`goods_id` ASC, `spec_value_ids` ASC) USING BTREE,
  INDEX `idx_goods`(`goods_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品SKU' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_spec_rel
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_spec_rel`;
CREATE TABLE `mall_goods_spec_rel`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_id` bigint UNSIGNED NOT NULL COMMENT '商品ID',
  `spec_id` bigint UNSIGNED NOT NULL COMMENT '规格组ID',
  `spec_value_id` bigint UNSIGNED NOT NULL COMMENT '规格值ID',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods`(`goods_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品-规格值关联' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_spec
-- ----------------------------
DROP TABLE IF EXISTS `mall_spec`;
CREATE TABLE `mall_spec`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规格组名称(如:颜色)',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品规格组' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_spec_value
-- ----------------------------
DROP TABLE IF EXISTS `mall_spec_value`;
CREATE TABLE `mall_spec_value`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `spec_id` bigint UNSIGNED NOT NULL COMMENT '规格组ID',
  `value` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规格值(如:香槟金)',
  `sort` smallint NOT NULL DEFAULT 100 COMMENT '排序',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_spec`(`spec_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品规格值' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_user_coupon
-- ----------------------------
DROP TABLE IF EXISTS `mall_user_coupon`;
CREATE TABLE `mall_user_coupon`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `coupon_id` bigint UNSIGNED NOT NULL COMMENT '优惠券ID',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID c_user.id',
  `member_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户会员ID c_member.id',
  `coupon_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=满减,2=折扣(冗余防JOIN)',
  `reduce_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '满减金额(冗余)',
  `discount` tinyint NOT NULL DEFAULT 0 COMMENT '折扣率(冗余)',
  `min_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '最低消费(冗余)',
  `max_discount_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '最多抵扣(冗余)',
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
  INDEX `idx_user_status`(`user_id` ASC, `status` ASC, `end_time` ASC) USING BTREE,
  INDEX `idx_member_status`(`member_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_coupon`(`coupon_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户优惠券实例' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_department
-- ----------------------------
DROP TABLE IF EXISTS `mmc_department`;
CREATE TABLE `mmc_department`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_parent`(`tenant_id` ASC, `parent_id` ASC, `sort` ASC) USING BTREE,
  INDEX `idx_tenant_path`(`tenant_id` ASC, `path`(200) ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_dept_leader
-- ----------------------------
DROP TABLE IF EXISTS `mmc_dept_leader`;
CREATE TABLE `mmc_dept_leader`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dept_user`(`dept_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant部门领导' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_login_log
-- ----------------------------
DROP TABLE IF EXISTS `mmc_login_log`;
CREATE TABLE `mmc_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户租户ID',
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 mmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1,
  `message` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_user_time`(`tenant_id` ASC, `user_id` ASC, `login_time` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MMC 端登录日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_menu
-- ----------------------------
DROP TABLE IF EXISTS `mmc_menu`;
CREATE TABLE `mmc_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` tinyint NOT NULL DEFAULT 2 COMMENT '1=目录,2=菜单,3=按钮',
  `permission_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `meta` json NULL,
  `path` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `component` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `redirect` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_perm_key`(`permission_key` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant端菜单(全局共享)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `mmc_operation_log`;
CREATE TABLE `mmc_operation_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 mmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `router` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_user_time`(`tenant_id` ASC, `user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MMC 端操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_package
-- ----------------------------
DROP TABLE IF EXISTS `mmc_package`;
CREATE TABLE `mmc_package`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'system=平台标准模板,tmc=TMC自定义',
  `owner_tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'TMC租户ID,system=0',
  `package_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `package_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `applicable_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'merchant' COMMENT '应用对象:merchant=商户/distributor=分销商/all=通用',
  `source_template_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '派生自哪个system模板,0=完全自建',
  `account_count` int UNSIGNED NOT NULL DEFAULT 50 COMMENT '账号数量上限',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_owner_code`(`owner_type` ASC, `owner_tenant_id` ASC, `package_code` ASC) USING BTREE,
  INDEX `idx_owner_status`(`owner_type` ASC, `owner_tenant_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_template`(`source_template_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商户套餐表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_package_menu
-- ----------------------------
DROP TABLE IF EXISTS `mmc_package_menu`;
CREATE TABLE `mmc_package_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `package_id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL COMMENT '指向 mmc_menu.id',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_package_menu`(`package_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_menu`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商户套餐-菜单关联' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_position
-- ----------------------------
DROP TABLE IF EXISTS `mmc_position`;
CREATE TABLE `mmc_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_dept`(`tenant_id` ASC, `dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_role
-- ----------------------------
DROP TABLE IF EXISTS `mmc_role`;
CREATE TABLE `mmc_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `mmc_role_menu`;
CREATE TABLE `mmc_role_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `idx_menu`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant角色-菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_user
-- ----------------------------
DROP TABLE IF EXISTS `mmc_user`;
CREATE TABLE `mmc_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户/分销商租户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名(商户内唯一)',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `employee_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '手机号密文',
  `phone_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '手机号HMAC',
  `email` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '邮箱密文',
  `email_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '邮箱HMAC',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `signed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_owner` tinyint NOT NULL DEFAULT 2 COMMENT '是否商户主管理员:1=是,2=否',
  `status` tinyint NOT NULL DEFAULT 1,
  `enable_2fa` tinyint NOT NULL DEFAULT 2,
  `pwd_error_count` tinyint NOT NULL DEFAULT 0,
  `locked_until` datetime NULL DEFAULT NULL,
  `password_updated_at` datetime NULL DEFAULT NULL,
  `login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `login_time` timestamp NULL DEFAULT NULL,
  `backend_setting` json NULL,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_username`(`tenant_id` ASC, `username` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_phone_hash`(`tenant_id` ASC, `phone_hash` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_email_hash`(`tenant_id` ASC, `email_hash` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_phone_hash`(`phone_hash` ASC) USING BTREE,
  INDEX `idx_email_hash`(`email_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MMC 端用户表(商户/分销商)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_user_dept
-- ----------------------------
DROP TABLE IF EXISTS `mmc_user_dept`;
CREATE TABLE `mmc_user_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_dept`(`tenant_id` ASC, `user_id` ASC, `dept_id` ASC) USING BTREE,
  INDEX `idx_dept`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant用户-部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_user_position
-- ----------------------------
DROP TABLE IF EXISTS `mmc_user_position`;
CREATE TABLE `mmc_user_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `position_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_position`(`tenant_id` ASC, `user_id` ASC, `position_id` ASC) USING BTREE,
  INDEX `idx_position`(`position_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant用户-岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_user_role
-- ----------------------------
DROP TABLE IF EXISTS `mmc_user_role`;
CREATE TABLE `mmc_user_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role_tenant`(`tenant_id` ASC, `user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_role`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant用户-角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号(如: HX20250701123456)',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `user_id` bigint UNSIGNED NOT NULL COMMENT 'c_user.id(冗余,跨商户查询)',
  `business_types` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '涉及业务类型(逗号分隔): flight,train,hotel,mall',
  `order_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'normal' COMMENT 'normal=普通/group=团购/corporate=大客户/gp=公务员',
  `parent_order_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '父订单ID(拆单溯源,0=原始订单)',
  `split_from_item_ids` json NULL COMMENT '拆单来源item IDs(从原订单拆出的item)',
  `split_version` smallint NULL DEFAULT 1 COMMENT '拆单版本(1=原始,>1=被拆过)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待支付,2=已支付/处理中,3=部分完成,4=全部完成,5=已取消,6=部分退改,7=已关闭',
  `sales_count` smallint NULL DEFAULT 0 COMMENT '销售业务订单数',
  `item_count` smallint NULL DEFAULT 0 COMMENT '子订单总数',
  `passenger_count` smallint NULL DEFAULT 0 COMMENT '旅客人数',
  `total_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '订单总金额',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '累计退款金额',
  `change_diff` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '累计改签差价(正=补价,负=退差)',
  `service_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '服务费合计',
  `insurance_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '保险费合计',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '币种',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '联系人姓名',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '联系人手机',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付方式: wechat/alipay/balance/credit/mixed',
  `payment_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `payment_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付流水号',
  `delivery_type` tinyint NOT NULL DEFAULT 0 COMMENT '0=无(机票/酒店),1=快递,2=自提,3=无需物流',
  `coupon_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '优惠券ID',
  `coupon_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠券抵扣金额',
  `points_used` int NOT NULL DEFAULT 0 COMMENT '使用积分数量',
  `points_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '积分抵扣金额',
  `buyer_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '买家留言',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'mini' COMMENT '下单来源: mini/web/h5/app/ota/api',
  `channel_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '分销渠道ID(分销商场景)',
  `contract_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '大客户签约ID(大客户订单关联 corporate_contract.id)',
  `group_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '大客户集团ID(冗余, corporate_group.id)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '客户备注',
  `internal_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '内部备注(仅B端可见)',
  `task_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '关联任务ID service_task.id(代客下单时关联)',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下单IP',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_tenant_member`(`tenant_id` ASC, `member_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_order_id` ASC) USING BTREE,
  INDEX `idx_contract`(`contract_id` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '主订单(大订单)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_change
-- ----------------------------
DROP TABLE IF EXISTS `order_change`;
CREATE TABLE `order_change`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `change_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '变更单号(如: HX20250701123456-C001)',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id` bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `change_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'refund=退票/change=改签/endorse=签转/cancel=取消(酒店)',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'flight/train/hotel',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待审核,2=处理中,3=已完成,4=已拒绝,5=已取消',
  `origin_item_ids` json NOT NULL COMMENT '原item ID列表(按biz_type对应不同表)',
  `new_item_ids` json NULL COMMENT '新item ID列表(仅改签产生新item)',
  `change_reason` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '变更原因: voluntary=自愿/force=航司取消/weather=天气/schedule_change=航班变动',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `change_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '变更手续费',
  `change_diff` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '改签差价(正=补价,负=退差)',
  `refund_to` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'original' COMMENT '退款去向: original=原路退回/balance=退到钱包',
  `apply_at` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `confirm_at` datetime NULL DEFAULT NULL COMMENT '确认时间',
  `complete_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `operator_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'member' COMMENT 'member=用户申请/admin=后台操作/system=系统自动',
  `operator_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '操作人ID',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `internal_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '内部备注(仅B端)',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_change_no`(`change_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `change_type` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_member`(`member_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_type_status`(`biz_type` ASC, `change_type` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单变更记录(退/改/签)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_item_car
-- ----------------------------
DROP TABLE IF EXISTS `order_item_car`;
CREATE TABLE `order_item_car`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '子订单号',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待确认,2=已确认,3=进行中,4=已完成,5=取消中,6=已取消,7=预订失败',
  `member_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '会员ID c_member.id',
  `product_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '产品ID',
  `product_snapshot` json NULL COMMENT '产品快照',
  `item_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '子订单金额',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `service_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `car_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用车类型: airport_pickup=接机/airport_dropoff=送机/city_transfer=市内接送/daily_rent=日租/hourly_rent=时租',
  `car_model` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '车型: economy=经济型/comfort=舒适型/business=商务型/luxury=豪华型',
  `car_brand` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '车辆品牌(如: 帕萨特)',
  `plate_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '车牌号(派车后回填)',
  `driver_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '司机姓名(派车后回填)',
  `driver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '司机电话(派车后回填)',
  `pickup_city_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '上车城市编码',
  `pickup_city_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '上车城市名',
  `pickup_address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '上车地址',
  `pickup_time` datetime NOT NULL COMMENT '上车时间',
  `dropoff_city_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下车城市编码',
  `dropoff_city_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下车城市名',
  `dropoff_address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下车地址',
  `dropoff_time` datetime NULL DEFAULT NULL COMMENT '下车时间(完成后回填)',
  `passenger_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '乘车人姓名(快照)',
  `passenger_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '乘车人手机(快照)',
  `flight_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '关联航班号(接送机时)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `effective_at` datetime NULL DEFAULT NULL COMMENT '生效时间(上车时间)',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '失效时间(下车时间)',
  `cancel_deadline` datetime NULL DEFAULT NULL COMMENT '免费取消截止时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_no`(`item_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_pickup_date`(`pickup_city_code` ASC, `pickup_time` ASC) USING BTREE,
  INDEX `idx_effective`(`effective_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用车子订单(单次行程=最小操作单元)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for order_item_flight
-- ----------------------------
DROP TABLE IF EXISTS `order_item_flight`;
CREATE TABLE `order_item_flight`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '子订单号(如: HX20250701123456-001)',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待处理,2=处理中,3=已出票,4=已使用,5=退票中,6=已退票,7=改签中,8=已改签,9=已取消,10=出票失败',
  `parent_item_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '改签关联: 改签后新item指向原item,0=原始item',
  `change_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '变更单ID(退/改/签)',
  `member_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '会员ID c_member.id',
  `passenger_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '旅客ID c_passenger.id',
  `passenger_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '旅客姓名(下单快照)',
  `passenger_id_type` tinyint NULL DEFAULT NULL COMMENT '旅客证件类型(快照): 1=身份证,2=护照...',
  `passenger_id_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '旅客证件号(快照脱敏)',
  `product_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '产品ID',
  `product_snapshot` json NULL COMMENT '产品快照(下单时票价/舱位/规则等)',
  `unit_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '票价',
  `item_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '子订单金额(票价+机建+燃油)',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `change_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '改签手续费',
  `service_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `insurance_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '保险费',
  `journey_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '行程ID(同一次行程的多程item共享,0=无关联)',
  `journey_index` smallint NULL DEFAULT 0 COMMENT '行程序号(第几程,0=无关联,1=第一段,2=第二段...)',
  `flight_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航程类型: departure=去程/return=回程/oneway=单程/transit=中转',
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '票号(出票后回填,如: 999-1234567890)',
  `carrier_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '承运航司二字码(如: CA)',
  `flight_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号(如: CA1234)',
  `share_flight_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '共享航班号(如有)',
  `departure_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发机场三字码(如: PEK)',
  `departure_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '出发城市/机场名',
  `arrival_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场三字码(如: SHA)',
  `arrival_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '到达城市/机场名',
  `departure_time` datetime NOT NULL COMMENT '起飞时间',
  `arrival_time` datetime NOT NULL COMMENT '降落时间',
  `cabin_class` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位等级: Y=经济/C=公务/F=头等',
  `cabin_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '子舱位编码(如: Y/B/M/K)',
  `cabin_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '舱位中文名(如: 经济舱)',
  `aircraft_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '机型(如: 737-800)',
  `meal` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '餐食: M=餐/B=轻食/N=无',
  `stop_count` tinyint NULL DEFAULT 0 COMMENT '经停次数',
  `free_baggage` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '免费行李额(如: 20KG)',
  `refund_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '退票规则摘要(快照)',
  `change_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '改签规则摘要(快照)',
  `effective_at` datetime NULL DEFAULT NULL COMMENT '生效时间(起飞时间)',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '失效时间(降落时间)',
  `cancel_deadline` datetime NULL DEFAULT NULL COMMENT '免费取消截止时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_no`(`item_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_journey`(`journey_id` ASC, `journey_index` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_passenger`(`passenger_id` ASC) USING BTREE,
  INDEX `idx_parent_item`(`parent_item_id` ASC) USING BTREE,
  INDEX `idx_ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `idx_carrier_flight`(`carrier_code` ASC, `flight_no` ASC, `departure_time` ASC) USING BTREE,
  INDEX `idx_route`(`departure_code` ASC, `arrival_code` ASC, `departure_time` ASC) USING BTREE,
  INDEX `idx_effective`(`effective_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '机票子订单(人×程=最小操作单元)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_item_hotel
-- ----------------------------
DROP TABLE IF EXISTS `order_item_hotel`;
CREATE TABLE `order_item_hotel`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '子订单号',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待确认,2=处理中,3=已确认,4=已入住,5=取消中,6=已取消,7=已退房,8=预订失败',
  `change_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '变更单ID(取消/修改)',
  `member_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '会员ID c_member.id',
  `product_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '产品ID',
  `product_snapshot` json NULL COMMENT '产品快照',
  `unit_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '每晚房价',
  `item_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '子订单金额(房价×晚数×间数)',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `service_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `insurance_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '保险费',
  `cost_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '采购成本单价',
  `confirmation_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '酒店确认号(确认后回填)',
  `hotel_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '酒店ID',
  `hotel_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '酒店名称',
  `room_type_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '房型ID',
  `room_type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '房型名称(如: 高级大床房)',
  `city_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市编码',
  `city_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市名',
  `address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '酒店地址',
  `star_rate` tinyint NULL DEFAULT 0 COMMENT '星级(1-5)',
  `check_in_date` date NOT NULL COMMENT '入住日期',
  `check_out_date` date NOT NULL COMMENT '离店日期',
  `nights` smallint NULL DEFAULT 1 COMMENT '晚数',
  `room_count` smallint NULL DEFAULT 1 COMMENT '房间数',
  `breakfast` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '早餐: 无/单早/双早',
  `bed_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '床型: 大床/双床/大/双',
  `cancel_policy` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '取消政策摘要(快照)',
  `supplier_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商类型: ota_ctrip/ota_meituan/ota_fligy/hotel_direct',
  `supplier_hotel_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商侧酒店ID',
  `supplier_room_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商侧房型ID',
  `supplier_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商订单号(确认后回填)',
  `guest_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '入住人姓名(快照)',
  `guest_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '入住人手机(快照)',
  `guest_id_type` tinyint NULL DEFAULT NULL COMMENT '入住人证件类型(快照): 1=身份证,2=护照...',
  `guest_id_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '入住人证件号(快照脱敏)',
  `special_request` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '特殊要求(如: 无烟房/高楼层/加床)',
  `effective_at` datetime NULL DEFAULT NULL COMMENT '生效时间(入住日)',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '失效时间(离店日)',
  `cancel_deadline` datetime NULL DEFAULT NULL COMMENT '免费取消截止时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_no`(`item_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_hotel_date`(`hotel_id` ASC, `check_in_date` ASC) USING BTREE,
  INDEX `idx_effective`(`effective_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '酒店子订单(人×晚×间=最小操作单元)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_item_insurance
-- ----------------------------
DROP TABLE IF EXISTS `order_item_insurance`;
CREATE TABLE `order_item_insurance`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '子订单号',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待生效,2=已生效,3=已失效,4=退保中,5=已退保,6=已取消',
  `member_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '会员ID c_member.id',
  `passenger_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '旅客ID c_passenger.id(关联出行人)',
  `insured_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '被保险人姓名(快照)',
  `insured_id_type` tinyint NULL DEFAULT NULL COMMENT '被保险人证件类型(快照): 1=身份证,2=护照...',
  `insured_id_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '被保险人证件号(快照脱敏)',
  `product_id` bigint UNSIGNED NOT NULL COMMENT '保险产品ID insurance_product.id',
  `product_snapshot` json NULL COMMENT '产品快照(名称/保费/保额/条款等)',
  `premium` decimal(10, 2) NOT NULL COMMENT '保费',
  `paid_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退保金额',
  `policy_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '保单号(生效后回填)',
  `effective_at` datetime NULL DEFAULT NULL COMMENT '生效时间',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '失效时间',
  `related_biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '关联业务类型: flight/train/hotel(与哪类出行绑定)',
  `related_item_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '关联子订单ID(绑定的机票/火车票item)',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_no`(`item_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_passenger`(`passenger_id` ASC) USING BTREE,
  INDEX `idx_policy_no`(`policy_no` ASC) USING BTREE,
  INDEX `idx_effective`(`effective_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险子订单(按被保人+产品=最小操作单元)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for order_item_mall
-- ----------------------------
DROP TABLE IF EXISTS `order_item_mall`;
CREATE TABLE `order_item_mall`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '子订单号',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待发货,2=已发货,3=已收货,4=退货中,5=已退货,6=已取消',
  `member_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '会员ID c_member.id',
  `product_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品ID mall_goods.id',
  `product_snapshot` json NULL COMMENT '商品快照(名称/图片/规格等)',
  `unit_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '单价',
  `quantity` smallint NULL DEFAULT 1 COMMENT '数量',
  `item_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '子订单金额',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `after_sale_status` tinyint NOT NULL DEFAULT 0 COMMENT '0=无售后,1=售后中,2=售后完成',
  `coupon_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用的优惠券ID mall_user_coupon.id',
  `coupon_amount` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠券抵扣金额',
  `delivery_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=快递配送,2=上门自提,3=无需物流',
  `express_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '快递公司ID mall_express.id',
  `buyer_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '买家备注',
  `service_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `goods_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商品名称(快照)',
  `sku_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT 'SKU ID',
  `sku_attrs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'SKU属性(如: 颜色:红;尺码:XL)',
  `points_used` int NULL DEFAULT 0 COMMENT '使用积分数',
  `points_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '积分抵扣金额',
  `address_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '收货地址ID c_member_address.id',
  `logistics_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '物流单号',
  `logistics_company` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '物流公司',
  `shipped_at` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `received_at` datetime NULL DEFAULT NULL COMMENT '收货时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_no`(`item_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_address`(`address_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商城子订单(商品件=最小操作单元)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_item_status_log
-- ----------------------------
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '子订单状态变更日志(出票/退改/发货等全追踪)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for order_item_train
-- ----------------------------
DROP TABLE IF EXISTS `order_item_train`;
CREATE TABLE `order_item_train`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '子订单号',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待处理,2=处理中,3=已出票,4=已使用,5=退票中,6=已退票,7=改签中,8=已改签,9=已取消,10=出票失败',
  `parent_item_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '改签关联: 改签后新item指向原item,0=原始item',
  `change_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '变更单ID',
  `member_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '会员ID c_member.id',
  `passenger_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '旅客ID c_passenger.id',
  `passenger_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '旅客姓名(快照)',
  `passenger_id_type` tinyint NULL DEFAULT NULL COMMENT '旅客证件类型(快照)',
  `passenger_id_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '旅客证件号(快照脱敏)',
  `product_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '产品ID',
  `product_snapshot` json NULL COMMENT '产品快照',
  `unit_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '票价',
  `item_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '子订单金额',
  `paid_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `change_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '改签手续费',
  `service_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `cost_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '采购成本单价',
  `cancel_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '退改规则摘要(快照)',
  `insurance_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '保险费',
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '火车票号(出票后回填)',
  `train_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '车次(如: G101)',
  `train_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '列车类型(如: G/D/C/Z/T/K)',
  `departure_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发站编码',
  `departure_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '出发站名',
  `arrival_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达站编码',
  `arrival_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '到达站名',
  `departure_time` datetime NOT NULL COMMENT '出发时间',
  `arrival_time` datetime NOT NULL COMMENT '到达时间',
  `duration` int NULL DEFAULT 0 COMMENT '行程时长(分钟)',
  `seat_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '座位类型(如: 二等座/一等座/商务座/硬卧/软卧)',
  `seat_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '座位编码',
  `carriage_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '车厢号(出票后)',
  `seat_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '座位号(出票后)',
  `supplier_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商订单号(12306出票后回填)',
  `is_student` tinyint NULL DEFAULT 2 COMMENT '1=学生票,2=成人票',
  `effective_at` datetime NULL DEFAULT NULL COMMENT '生效时间(出发时间)',
  `expire_at` datetime NULL DEFAULT NULL COMMENT '失效时间(到达时间)',
  `cancel_deadline` datetime NULL DEFAULT NULL COMMENT '免费取消截止时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_no`(`item_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_passenger`(`passenger_id` ASC) USING BTREE,
  INDEX `idx_parent_item`(`parent_item_id` ASC) USING BTREE,
  INDEX `idx_ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `idx_train_date`(`train_no` ASC, `departure_time` ASC) USING BTREE,
  INDEX `idx_effective`(`effective_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '火车票子订单(人×程=最小操作单元)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_procure_item
-- ----------------------------
DROP TABLE IF EXISTS `order_procure_item`;
CREATE TABLE `order_procure_item`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `procurement_id` bigint UNSIGNED NOT NULL COMMENT '采购业务订单ID',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID(冗余)',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务类型: flight/train/hotel/mall',
  `sales_item_id` bigint UNSIGNED NOT NULL COMMENT '关联销售子订单ID(按biz_type指向对应表)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待采购,2=采购中,3=已出票/已确认,4=采购失败,5=已取消',
  `cost_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '采购成本单价',
  `cost_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '采购总金额',
  `settle_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '已结算金额',
  `supplier_ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商票号/确认号(出票后回填)',
  `supplier_pnr` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航司PNR(机票采购)',
  `fail_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '失败原因',
  `retry_count` tinyint NULL DEFAULT 0 COMMENT '重试次数',
  `next_retry_at` datetime NULL DEFAULT NULL COMMENT '下次重试时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_procurement`(`procurement_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sales_item`(`biz_type` ASC, `sales_item_id` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_status_retry`(`status` ASC, `next_retry_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购子订单(关联销售item,按渠道出票)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_procurement
-- ----------------------------
DROP TABLE IF EXISTS `order_procurement`;
CREATE TABLE `order_procurement`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `procurement_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '采购单号(如: HX20250701123456-P-CA01)',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NOT NULL COMMENT '来源销售业务订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务类型: flight/train/hotel/mall',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待采购,2=采购中,3=已出票/已确认,4=部分出票,5=采购失败,6=已取消',
  `staff_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '采购员ID(指向 mmc_user.id)',
  `staff_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购员姓名(冗余)',
  `item_count` smallint NULL DEFAULT 0 COMMENT '采购子订单数',
  `cost_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '采购成本金额',
  `settle_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '已结算金额',
  `supplier_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '供应商类型: airline_b2b/airline_b2t/ota_ctrip/ota_qunar/ota_meituan/ota_fligy/railway_12306/hotel_supplier/mall_supplier',
  `supplier_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '供应商ID',
  `supplier_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商名称',
  `supplier_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商账号(如航司B2B账号/携程代理账号)',
  `supplier_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商订单号(出票后回填)',
  `procure_at` datetime NULL DEFAULT NULL COMMENT '采购提交时间',
  `ticket_at` datetime NULL DEFAULT NULL COMMENT '出票/确认时间',
  `fail_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '失败原因',
  `retry_count` tinyint NULL DEFAULT 0 COMMENT '重试次数',
  `next_retry_at` datetime NULL DEFAULT NULL COMMENT '下次重试时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_procurement_no`(`procurement_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_id` ASC) USING BTREE,
  INDEX `idx_tenant_biz_status`(`tenant_id` ASC, `biz_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_tenant_staff`(`tenant_id` ASC, `staff_id` ASC) USING BTREE,
  INDEX `idx_supplier`(`supplier_type` ASC, `supplier_order_no` ASC) USING BTREE,
  INDEX `idx_status_retry`(`status` ASC, `next_retry_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购业务订单(按渠道拆分,绑采购员)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_sales
-- ----------------------------
DROP TABLE IF EXISTS `order_sales`;
CREATE TABLE `order_sales`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `sales_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售单号(如: HX20250701123456-S-F001)',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务类型: flight/train/hotel/mall',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=待处理,2=处理中,3=部分出票,4=全部完成,5=已取消,6=部分退改,7=出票失败待重采',
  `staff_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '销售员ID(指向 mmc_user.id)',
  `staff_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '销售员姓名(冗余)',
  `item_count` smallint NULL DEFAULT 0 COMMENT '子订单数',
  `passenger_count` smallint NULL DEFAULT 0 COMMENT '旅客人数',
  `sales_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '销售金额(售价合计)',
  `settle_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '已结算金额',
  `refund_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `service_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '服务费合计',
  `insurance_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '保险费合计',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'mini' COMMENT '来源: mini/web/h5/app/ota/api',
  `channel_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '分销渠道ID',
  `contract_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '大客户签约ID(corporate_contract.id)',
  `group_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '大客户集团ID(冗余)',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '联系电话',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '客户备注',
  `internal_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '内部备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sales_no`(`sales_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_tenant_biz_status`(`tenant_id` ASC, `biz_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_tenant_staff`(`tenant_id` ASC, `staff_id` ASC) USING BTREE,
  INDEX `idx_contract`(`contract_id` ASC) USING BTREE,
  INDEX `idx_group`(`group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售业务订单(按业务类型拆分,绑销售员)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_status_log
-- ----------------------------
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单状态变更日志(全链路追踪)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for payment_log
-- ----------------------------
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '支付流水日志(全流程追踪+对账)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for pmc_department
-- ----------------------------
DROP TABLE IF EXISTS `pmc_department`;
CREATE TABLE `pmc_department`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '物化路径 /1/3/7/',
  `level` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `sort` ASC) USING BTREE,
  INDEX `idx_path`(`path`(255) ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_dept_leader
-- ----------------------------
DROP TABLE IF EXISTS `pmc_dept_leader`;
CREATE TABLE `pmc_dept_leader`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `dept_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dept_user`(`dept_id` ASC, `user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS部门领导' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_login_log
-- ----------------------------
DROP TABLE IF EXISTS `pmc_login_log`;
CREATE TABLE `pmc_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 pmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1 COMMENT '1=成功,2=失败',
  `message` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `login_time` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC 端登录日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_menu
-- ----------------------------
DROP TABLE IF EXISTS `pmc_menu`;
CREATE TABLE `pmc_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` tinyint NOT NULL DEFAULT 2 COMMENT '1=目录,2=菜单,3=按钮',
  `permission_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '权限标识 e.g. order:export',
  `meta` json NULL,
  `path` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `component` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `redirect` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_perm_key`(`permission_key` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS平台端菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `pmc_operation_log`;
CREATE TABLE `pmc_operation_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 pmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `router` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC 端操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_position
-- ----------------------------
DROP TABLE IF EXISTS `pmc_position`;
CREATE TABLE `pmc_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dept`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_role
-- ----------------------------
DROP TABLE IF EXISTS `pmc_role`;
CREATE TABLE `pmc_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS平台端角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `pmc_role_menu`;
CREATE TABLE `pmc_role_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_menu`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS角色-菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_user
-- ----------------------------
DROP TABLE IF EXISTS `pmc_user`;
CREATE TABLE `pmc_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID,主键',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `phone_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '手机号密文(AES-256-GCM,应用层加密)',
  `phone_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '手机号HMAC-SHA256(用于精确查找)',
  `email` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `email_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '邮箱密文(AES-256-GCM)',
  `email_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '邮箱HMAC-SHA256',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户头像',
  `signed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '个人签名',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态:1=正常,2=停用',
  `enable_2fa` tinyint NOT NULL DEFAULT 2 COMMENT '是否启用2FA:1=是,2=否',
  `pwd_error_count` tinyint NOT NULL DEFAULT 0 COMMENT '连续密码错误次数',
  `locked_until` datetime NULL DEFAULT NULL COMMENT '锁定到此时间(NULL=未锁)',
  `password_updated_at` datetime NULL DEFAULT NULL COMMENT '密码上次修改时间',
  `login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `login_time` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `backend_setting` json NULL COMMENT '后台设置数据',
  `created_by` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updated_by` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_username_unique`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_user_phone_hash`(`phone_hash` ASC) USING BTREE,
  UNIQUE INDEX `uk_user_email_hash`(`email_hash` ASC) USING BTREE,
  INDEX `idx_phone_hash`(`phone_hash` ASC) USING BTREE,
  INDEX `idx_email_hash`(`email_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC 端用户表(平台内部员工)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_user_dept
-- ----------------------------
DROP TABLE IF EXISTS `pmc_user_dept`;
CREATE TABLE `pmc_user_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_dept`(`user_id` ASC, `dept_id` ASC) USING BTREE,
  INDEX `idx_dept`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC用户-部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_user_position
-- ----------------------------
DROP TABLE IF EXISTS `pmc_user_position`;
CREATE TABLE `pmc_user_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `position_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_position`(`user_id` ASC, `position_id` ASC) USING BTREE,
  INDEX `idx_position`(`position_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC用户-岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_user_role
-- ----------------------------
DROP TABLE IF EXISTS `pmc_user_role`;
CREATE TABLE `pmc_user_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_role`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC用户-角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for rules
-- ----------------------------
DROP TABLE IF EXISTS `rules`;
CREATE TABLE `rules`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `ptype` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v0` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v1` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v2` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v4` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v5` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ptype_v0_v1`(`ptype` ASC, `v0` ASC, `v1` ASC) USING BTREE,
  INDEX `idx_v1_v2`(`v1` ASC, `v2` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for service_task
-- ----------------------------
DROP TABLE IF EXISTS `service_task`;
CREATE TABLE `service_task`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `task_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务编号(如: TK20250701123456-001)',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `order_id` bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '销售业务订单ID',
  `task_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务类型: domestic_flight/international_flight/hotel/hotel_night_audit/train/insurance/car/eagle_eye/demand/travel_customize/corporate_agreement/corporate_direct',
  `task_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT '任务状态: PENDING/PROCESSING/SUSPENDED/WAITING_TICKET/WAITING_REMINDER/REFUND_AUDIT/REFUND_REVIEW/CHANGE_TICKET/CHANGE_AUDIT/COMPLETED/CLOSED',
  `task_source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SYSTEM' COMMENT '任务来源: SYSTEM=系统自动/MANUAL=手工创建',
  `priority` tinyint NULL DEFAULT 2 COMMENT '优先级: 1=低,2=中,3=高,4=紧急',
  `assign_to` bigint UNSIGNED NULL DEFAULT 0 COMMENT '分配给(mmc_user.id), 0=未分配',
  `assign_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '分配人姓名(冗余)',
  `assign_at` datetime NULL DEFAULT NULL COMMENT '分配时间',
  `process_at` datetime NULL DEFAULT NULL COMMENT '开始处理时间',
  `close_at` datetime NULL DEFAULT NULL COMMENT '关闭时间',
  `company_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '企业客户ID(corporate_group.id)',
  `company_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '企业名称(冗余)',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '联系电话',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_task_no`(`task_no` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_tenant_type_status`(`tenant_id` ASC, `task_type` ASC, `task_status` ASC) USING BTREE,
  INDEX `idx_assign`(`assign_to` ASC, `task_status` ASC) USING BTREE,
  INDEX `idx_status_priority`(`task_status` ASC, `priority` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_company`(`company_id` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '服务任务(TMC工单)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for service_task_assign_rule
-- ----------------------------
DROP TABLE IF EXISTS `service_task_assign_rule`;
CREATE TABLE `service_task_assign_rule`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `task_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务类型',
  `rule_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'round_robin' COMMENT '分配策略: round_robin=轮询/least_load=最少任务/skill=技能匹配/manual=手工分配',
  `target_user_ids` json NULL COMMENT '目标用户ID列表(轮询/技能匹配时用)',
  `skill_tags` json NULL COMMENT '技能标签(skill策略时用, 如: [\"国际机票\",\"退改签\"])',
  `priority` smallint NULL DEFAULT 0 COMMENT '规则优先级(数值越大越优先)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_type`(`tenant_id` ASC, `task_type` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务分配规则' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for service_task_log
-- ----------------------------
DROP TABLE IF EXISTS `service_task_log`;
CREATE TABLE `service_task_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `task_id` bigint UNSIGNED NOT NULL COMMENT '任务ID service_task.id',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `operator_id` bigint UNSIGNED NOT NULL COMMENT '操作人ID',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  `operator_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人类型: pmc/tmc/mmc/system',
  `action` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作: created/assigned/claimed/processed/suspended/resumed/transferred/refund_audit/refund_review/change_ticket/change_audit/completed/closed/reopened',
  `from_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '原状态',
  `to_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '新状态',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作内容/备注',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task`(`task_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_tenant_operator`(`tenant_id` ASC, `operator_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务操作日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tenant
-- ----------------------------
DROP TABLE IF EXISTS `tenant`;
CREATE TABLE `tenant`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '租户编号',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '租户名称',
  `tenant_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'merchant' COMMENT '租户类型:tmc=集团/merchant=商户/distributor=分销商',
  `parent_tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级租户ID,平台直建=0',
  `package_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '套餐编号(tmc 必填,merchant/distributor=0 改用 mmc_package_id)',
  `mmc_package_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'MMC套餐ID(tenant_type=merchant/distributor 时使用)',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户编号，租户管理员',
  `account_count` int UNSIGNED NOT NULL DEFAULT 100 COMMENT '账号最大数量',
  `contact_name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人手机',
  `bind_domain` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '绑定域名',
  `expire_at` datetime NOT NULL COMMENT '过期时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '租户状态:1=正常,2=停用',
  `created_by` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updated_by` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tenant_name_unique`(`name` ASC) USING BTREE,
  INDEX `idx_type_status`(`tenant_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_parent_type`(`parent_tenant_id` ASC, `tenant_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '租户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_department
-- ----------------------------
DROP TABLE IF EXISTS `tmc_department`;
CREATE TABLE `tmc_department`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_parent`(`tenant_id` ASC, `parent_id` ASC, `sort` ASC) USING BTREE,
  INDEX `idx_tenant_path`(`tenant_id` ASC, `path`(200) ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_dept_leader
-- ----------------------------
DROP TABLE IF EXISTS `tmc_dept_leader`;
CREATE TABLE `tmc_dept_leader`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dept_user`(`dept_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC部门领导' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_login_log
-- ----------------------------
DROP TABLE IF EXISTS `tmc_login_log`;
CREATE TABLE `tmc_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'TMC集团ID',
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 tmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1,
  `message` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_user_time`(`tenant_id` ASC, `user_id` ASC, `login_time` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC 端登录日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_menu
-- ----------------------------
DROP TABLE IF EXISTS `tmc_menu`;
CREATE TABLE `tmc_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` tinyint NOT NULL DEFAULT 2 COMMENT '1=目录,2=菜单,3=按钮',
  `permission_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `meta` json NULL,
  `path` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `component` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `redirect` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_perm_key`(`permission_key` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC端菜单(全局共享)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `tmc_operation_log`;
CREATE TABLE `tmc_operation_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 tmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `router` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_user_time`(`tenant_id` ASC, `user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC 端操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_package
-- ----------------------------
DROP TABLE IF EXISTS `tmc_package`;
CREATE TABLE `tmc_package`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '套餐ID',
  `package_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '套餐名称',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态:1=正常,2=停用',
  `created_by` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updated_by` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tenant_package_package_name_unique`(`package_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '多租户套餐' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_package_change_log
-- ----------------------------
DROP TABLE IF EXISTS `tmc_package_change_log`;
CREATE TABLE `tmc_package_change_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `package_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tmc_package/merchant_package',
  `from_package_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `to_package_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `change_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'upgrade/downgrade/bind/unbind',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `operator_id` bigint UNSIGNED NOT NULL,
  `operator_platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_time`(`tenant_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_operator`(`operator_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '租户套餐变更日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_package_menu
-- ----------------------------
DROP TABLE IF EXISTS `tmc_package_menu`;
CREATE TABLE `tmc_package_menu`  (
  `package_id` bigint UNSIGNED NOT NULL COMMENT '套餐ID',
  `menu_id` bigint UNSIGNED NOT NULL COMMENT '菜单ID',
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'mmc' COMMENT '菜单所属端:tmc/mmc',
  PRIMARY KEY (`package_id`, `menu_id`) USING BTREE,
  INDEX `idx_platform_menu`(`platform` ASC, `menu_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_position
-- ----------------------------
DROP TABLE IF EXISTS `tmc_position`;
CREATE TABLE `tmc_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_dept`(`tenant_id` ASC, `dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_role
-- ----------------------------
DROP TABLE IF EXISTS `tmc_role`;
CREATE TABLE `tmc_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT 'TMC集团ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `tmc_role_menu`;
CREATE TABLE `tmc_role_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `idx_menu`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC角色-菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_user
-- ----------------------------
DROP TABLE IF EXISTS `tmc_user`;
CREATE TABLE `tmc_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT 'TMC集团ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名(集团内唯一)',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `employee_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '工号',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `phone_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '手机号密文',
  `phone_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '手机号HMAC',
  `email` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `email_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '邮箱密文',
  `email_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '邮箱HMAC',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '头像',
  `signed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '个人签名',
  `is_owner` tinyint NOT NULL DEFAULT 2 COMMENT '是否集团主管理员:1=是,2=否',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态:1=正常,2=停用',
  `enable_2fa` tinyint NOT NULL DEFAULT 2 COMMENT '是否启用2FA:1=是,2=否',
  `pwd_error_count` tinyint NOT NULL DEFAULT 0 COMMENT '连续密码错误次数',
  `locked_until` datetime NULL DEFAULT NULL COMMENT '锁定到此时间(NULL=未锁)',
  `password_updated_at` datetime NULL DEFAULT NULL COMMENT '密码上次修改时间',
  `login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `login_time` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `backend_setting` json NULL COMMENT '后台设置数据',
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_username`(`tenant_id` ASC, `username` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_phone_hash`(`tenant_id` ASC, `phone_hash` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_email_hash`(`tenant_id` ASC, `email_hash` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_phone_hash`(`phone_hash` ASC) USING BTREE,
  INDEX `idx_email_hash`(`email_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC 端用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_user_dept
-- ----------------------------
DROP TABLE IF EXISTS `tmc_user_dept`;
CREATE TABLE `tmc_user_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_dept`(`tenant_id` ASC, `user_id` ASC, `dept_id` ASC) USING BTREE,
  INDEX `idx_dept`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC用户-部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_user_position
-- ----------------------------
DROP TABLE IF EXISTS `tmc_user_position`;
CREATE TABLE `tmc_user_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `position_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_position`(`tenant_id` ASC, `user_id` ASC, `position_id` ASC) USING BTREE,
  INDEX `idx_position`(`position_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC用户-岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_user_role
-- ----------------------------
DROP TABLE IF EXISTS `tmc_user_role`;
CREATE TABLE `tmc_user_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role_tenant`(`tenant_id` ASC, `user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_role`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC用户-角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for train_seat_type
-- ----------------------------
DROP TABLE IF EXISTS `train_seat_type`;
CREATE TABLE `train_seat_type`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `seat_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '座席编码(如: SWZ/ZY/ZE/RW/YW/RZ/YZ)',
  `seat_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '座席名称(如: 商务座/一等座/二等座/软卧/硬卧/软座/硬座)',
  `train_type_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '适用列车类型(空=通用, 如: G/D)',
  `cabin_class` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '舱位等级映射: business/first/second/sleeper',
  `refund_rate_24h` decimal(5, 2) NULL DEFAULT NULL COMMENT '24h内退票费率(如: 0.20=20%)',
  `refund_rate_48h` decimal(5, 2) NULL DEFAULT NULL COMMENT '48h内退票费率',
  `refund_rate_8d` decimal(5, 2) NULL DEFAULT NULL COMMENT '8天内退票费率',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序(商务>一等>二等...)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_seat_code`(`seat_code` ASC, `train_type_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '火车座席类型' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for train_station
-- ----------------------------
DROP TABLE IF EXISTS `train_station`;
CREATE TABLE `train_station`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `station_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '站点编码(如: BJN=北京南)',
  `station_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '站点名称(如: 北京南站)',
  `city_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属城市编码(对接air_region)',
  `city_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市名',
  `pinyin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '站名拼音(如: beiJingNan)',
  `short_pinyin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '简拼(如: BJN)',
  `longitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `latitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序权重',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_station_code`(`station_code` ASC, `deleted_at` ASC) USING BTREE,
  INDEX `idx_city`(`city_code` ASC) USING BTREE,
  INDEX `idx_pinyin`(`pinyin` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '火车站点' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for train_type
-- ----------------------------
DROP TABLE IF EXISTS `train_type`;
CREATE TABLE `train_type`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型编码(如: G/D/C/Z/T/K)',
  `type_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型名称(如: 高铁/动车/城际/直达/特快/普快)',
  `speed_level` tinyint NULL DEFAULT 0 COMMENT '速度等级: 1=最快(G),2=快(D/C),3=中(Z/T),4=慢(K/其他)',
  `refund_rule` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '退票规则摘要(按类型通用规则)',
  `change_rule` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '改签规则摘要',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_type_code`(`type_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '列车类型' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_third_party_auth
-- ----------------------------
DROP TABLE IF EXISTS `user_third_party_auth`;
CREATE TABLE `user_third_party_auth`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属端:pmc/tmc/mmc',
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '租户ID,saas=0',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '端内 user_id (按 platform 指向对应 *_user 表)',
  `provider` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'wechat_mp/wechat_open/wechat_work/wechat_mini/douyin/alipay/qq/dingtalk/feishu',
  `provider_app_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '三方应用 AppID (同 provider 可能多个应用)',
  `open_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '三方应用内唯一标识',
  `union_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '同主体下跨应用唯一标识(微信/支付宝)',
  `unionid_principal` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '开放平台主体ID(多主体场景区分)',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '三方昵称(缓存)',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '三方头像(缓存)',
  `access_token` varbinary(1024) NULL DEFAULT NULL COMMENT 'access_token 密文(AES-256-GCM)',
  `refresh_token` varbinary(1024) NULL DEFAULT NULL COMMENT 'refresh_token 密文',
  `expire_at` datetime NULL DEFAULT NULL COMMENT 'access_token 过期时间',
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '授权 scope (snsapi_userinfo 等)',
  `raw_info` json NULL COMMENT '三方原始返回信息',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态:1=已绑定,2=已解绑',
  `bound_at` datetime NULL DEFAULT NULL COMMENT '首次绑定时间',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最近一次三方登录时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_provider_app_openid`(`provider` ASC, `provider_app_id` ASC, `open_id` ASC) USING BTREE COMMENT '同应用内 open_id 全局唯一',
  UNIQUE INDEX `uk_user_provider`(`platform` ASC, `tenant_id` ASC, `user_id` ASC, `provider` ASC, `provider_app_id` ASC, `status` ASC) USING BTREE COMMENT '一个账号同一应用只能绑一次(status 参与避免历史解绑记录冲突)',
  INDEX `idx_provider_union`(`provider` ASC, `unionid_principal` ASC, `union_id` ASC) USING BTREE COMMENT '主体内通过 union_id 查全部账号',
  INDEX `idx_user`(`platform` ASC, `user_id` ASC) USING BTREE COMMENT '查某账号绑了哪些三方'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '三方授权绑定表(三端共享)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_third_party_login_log
-- ----------------------------
DROP TABLE IF EXISTS `user_third_party_login_log`;
CREATE TABLE `user_third_party_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属端:pmc/tmc/mmc',
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=未绑定/扫码失败/匿名扫码',
  `provider` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `open_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scene` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'login=三方登录,bind=绑定,unbind=解绑,refresh=刷新token',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1 COMMENT '1=成功,2=失败',
  `error_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '失败错误码',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`platform` ASC, `user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_provider_time`(`provider` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_openid_time`(`provider` ASC, `open_id` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '三方授权登录/绑定日志' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
