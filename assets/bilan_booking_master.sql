/*
 Navicat MySQL Data Transfer

 Source Server         : 192.168.2.4
 Source Server Type    : MySQL
 Source Server Version : 80027
 Source Host           : 192.168.2.4:33006
 Source Schema         : bilan_booking_master

 Target Server Type    : MySQL
 Target Server Version : 80027
 File Encoding         : 65001

 Date: 25/06/2026 17:42:19
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for advert
-- ----------------------------
DROP TABLE IF EXISTS `advert`;
CREATE TABLE `advert`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '广告标题',
  `url_type` tinyint(1) NULL DEFAULT 1 COMMENT '链接类型:1=URL,2=PATH路径,3=快捷跳转',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片路径',
  `path` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '跳转路径',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '跳转链接',
  `status` tinyint UNSIGNED NULL DEFAULT 2 COMMENT '状态=1：显示；0：隐藏',
  `weight` int NOT NULL DEFAULT 9 COMMENT '权重,越大越靠前',
  `channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '广告渠道',
  `pos` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '广告位置',
  `show_time` int NULL DEFAULT 3000 COMMENT '显示毫秒',
  `params_id` int NULL DEFAULT 0 COMMENT '参数模版id',
  `params_value` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '参数内容',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '广告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for advert_params
-- ----------------------------
DROP TABLE IF EXISTS `advert_params`;
CREATE TABLE `advert_params`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名字',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型',
  `desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `params` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '参数模版',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '广告参数模版' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_airline
-- ----------------------------
DROP TABLE IF EXISTS `air_airline`;
CREATE TABLE `air_airline`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `air_line_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司2字码',
  `air_line_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司名称',
  `air_line_company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司公司名称',
  `mk_ticket_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票三字码',
  `area` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地区I:国际  N:国内',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'logo地址',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `air_line_code`(`air_line_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1182 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_airline_accounts
-- ----------------------------
DROP TABLE IF EXISTS `air_airline_accounts`;
CREATE TABLE `air_airline_accounts`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type_of` tinyint NULL DEFAULT 0 COMMENT '类型：1航司，2OTA',
  `airline_id` int NULL DEFAULT 0 COMMENT '航司ID',
  `airline_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司二字码',
  `ota_id` int NULL DEFAULT 0 COMMENT 'OTA_id',
  `domestic` tinyint NULL DEFAULT 0 COMMENT '是否支持国内：0否1是',
  `international` tinyint NULL DEFAULT 0 COMMENT '是否支持国际：0否1是',
  `account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账户名',
  `account_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账户密码',
  `purchase_channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支持采购渠道',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '后台地址',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE,
  INDEX `accountName`(`account_name` ASC) USING BTREE,
  INDEX `airline_code`(`airline_code` ASC) USING BTREE,
  INDEX `airline_id`(`airline_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 144 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'B2B 航司账号信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_airline_notice
-- ----------------------------
DROP TABLE IF EXISTS `air_airline_notice`;
CREATE TABLE `air_airline_notice`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `airline` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '标题',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方url',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司预定须知列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_airports
-- ----------------------------
DROP TABLE IF EXISTS `air_airports`;
CREATE TABLE `air_airports`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `air_port` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '机场三字码',
  `air_port_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '机场中文名',
  `air_port_ename` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '机场英文名',
  `country` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国家中文名',
  `country_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国家英文名',
  `province` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '州/省',
  `chau` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '洲',
  `chan_chird` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '所属小洲',
  `city_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市中文名',
  `city_ename` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市英文名',
  `city_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市三字码',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `air_port`(`air_port` ASC) USING BTREE,
  INDEX `country`(`country` ASC) USING BTREE,
  INDEX `country_code`(`country_code` ASC) USING BTREE,
  INDEX `city_code`(`city_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10922 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_cabin
-- ----------------------------
DROP TABLE IF EXISTS `air_cabin`;
CREATE TABLE `air_cabin`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sort` int NOT NULL DEFAULT 10 COMMENT '权重：越大越靠前',
  `is_sell` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否为可销售舱位：1:是2:否',
  `is_fd` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否为公布运价：1:是2:否',
  `cabin_level_id` int NULL DEFAULT NULL COMMENT '舱位等级',
  `cabin_code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位编号',
  `adt_rebate` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '成人折扣',
  `start_force_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生效时间',
  `flight_force_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `cabin_baggage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '舱位行李额【为空及同标准舱行李额】',
  `basic_agency_fee` float(10, 2) NULL DEFAULT 0.00 COMMENT '基础代理费',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1410 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '舱位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_cabin_level
-- ----------------------------
DROP TABLE IF EXISTS `air_cabin_level`;
CREATE TABLE `air_cabin_level`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `cabin_level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位等级名称',
  `air_line_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司编码',
  `standard_cabin_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标准舱位编码',
  `cnn_rebate` float NULL DEFAULT NULL COMMENT '儿童折扣',
  `inf_rebate` float NULL DEFAULT NULL COMMENT '婴儿折扣',
  `baggage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '行李额',
  `sort` int NOT NULL DEFAULT 100 COMMENT '权重：越大显示越前',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '编辑时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 233 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司舱位等级' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_cnn_inf
-- ----------------------------
DROP TABLE IF EXISTS `air_cnn_inf`;
CREATE TABLE `air_cnn_inf`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `air_line_code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司二字码',
  `cnn_number` int NOT NULL DEFAULT 2 COMMENT '携带儿童数量',
  `has_inf_cnn_number` int UNSIGNED NOT NULL DEFAULT 1 COMMENT '存在婴儿携带儿童数量',
  `has_inf_inf_number` int UNSIGNED NOT NULL DEFAULT 1 COMMENT '存在婴儿携带婴儿数量',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `air_line`(`air_line_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司携带儿童婴儿数量' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_eterm_traffic
-- ----------------------------
DROP TABLE IF EXISTS `air_eterm_traffic`;
CREATE TABLE `air_eterm_traffic`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `office` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Office',
  `cmd` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '命令',
  `full_cmd` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '完整指令',
  `month` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '月份',
  `day` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日期',
  `number` decimal(2, 1) NULL DEFAULT NULL COMMENT '流量条数',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 56127 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ibe流量统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_everyday_flying
-- ----------------------------
DROP TABLE IF EXISTS `air_everyday_flying`;
CREATE TABLE `air_everyday_flying`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `air_company` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `push` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '推送地址',
  `retrieve` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回填地址',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '天天飞配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_fd_price
-- ----------------------------
DROP TABLE IF EXISTS `air_fd_price`;
CREATE TABLE `air_fd_price`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dep` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发地',
  `arr` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目的地',
  `air_company` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `cabin` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位代码',
  `price` decimal(8, 2) NOT NULL COMMENT 'fd价格',
  `start_date` date NOT NULL COMMENT '有效开始时间',
  `end_date` date NOT NULL COMMENT '有效结束时间',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `dep`(`dep` ASC) USING BTREE,
  INDEX `arr`(`arr` ASC) USING BTREE,
  INDEX `start_date`(`start_date` ASC) USING BTREE,
  INDEX `end_date`(`end_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70770 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'fd运价缓存' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_fuel
-- ----------------------------
DROP TABLE IF EXISTS `air_fuel`;
CREATE TABLE `air_fuel`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `air_line_code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司编号',
  `fuel_cost` int NULL DEFAULT NULL COMMENT '燃油费',
  `start_force_time` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生效时间',
  `mileage` int NOT NULL DEFAULT 800 COMMENT '里程：超过XXX多少',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 97 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司燃油费管理\r\n\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_fuel_detail
-- ----------------------------
DROP TABLE IF EXISTS `air_fuel_detail`;
CREATE TABLE `air_fuel_detail`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `air_line_code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司编号',
  `departure_airport` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场',
  `arrive_airport` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场',
  `mileage` int NULL DEFAULT NULL COMMENT '里程',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `air_index`(`air_line_code` ASC, `departure_airport` ASC, `arrive_airport` ASC, `mileage` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13327 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司下的 航程 里程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_gauge
-- ----------------------------
DROP TABLE IF EXISTS `air_gauge`;
CREATE TABLE `air_gauge`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `air_line_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司编码',
  `cabin_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位编号集合/分割',
  `effect_start_time` datetime NULL DEFAULT NULL COMMENT '生效时间',
  `effect_end_time` datetime NULL DEFAULT NULL COMMENT '失效时间',
  `discount_scope` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '折扣范围',
  `gauge_type_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '退改签规则类型值集合序列化存储',
  `back_msg` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退改说明',
  `endorsement_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '签转规定',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 828 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '客规' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_gauge_inter
-- ----------------------------
DROP TABLE IF EXISTS `air_gauge_inter`;
CREATE TABLE `air_gauge_inter`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `air_line_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `noshow_time` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'noshow时间',
  `noshow_refund` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'noshow后是否允许退票',
  `lock_ticket` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否允许锁票',
  `before_cancel_seat_submit` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否允许飞前取位飞后提交',
  `noshow_prop` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '对赌盈亏比例',
  `cancel_or_enter` tinyint(1) NULL DEFAULT 1 COMMENT '1=取位为准;2=录入为准',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际退改规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_gauge_type
-- ----------------------------
DROP TABLE IF EXISTS `air_gauge_type`;
CREATE TABLE `air_gauge_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1:退票2:改签',
  `time_before` int UNSIGNED NULL DEFAULT NULL COMMENT '航班离站之前 单位（小时）',
  `time_before_is_contain` tinyint(1) NOT NULL DEFAULT 0 COMMENT '航班离站之前是否包含',
  `time_after` int NULL DEFAULT NULL COMMENT '航班离站之后 单位（小时）',
  `time_after_is_contain` tinyint(1) NOT NULL DEFAULT 1 COMMENT '航班离站之后是否包含',
  `air_line_code` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '所属组（航司二字码）',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1078 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '客规退改签时间类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_ibe_ota_forward
-- ----------------------------
DROP TABLE IF EXISTS `air_ibe_ota_forward`;
CREATE TABLE `air_ibe_ota_forward`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `air_company` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `platform_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '平台代码,多个逗号分隔',
  `office_no` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '生编OFFICE号',
  `data_source` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作数据源',
  `pnr_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '生编类型，0假编码，1真编码',
  `check_seat` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否检查余位',
  `check_seat_error` tinyint(1) NOT NULL DEFAULT 1 COMMENT '余位检查失败操作,1生单失败2.生假编码,3.直接生编',
  `min_seat_true_pnr` tinyint(1) NOT NULL DEFAULT 0 COMMENT '余位小于等于X,生真编码。0不检查',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ibe ota转发规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_ibe_traffic
-- ----------------------------
DROP TABLE IF EXISTS `air_ibe_traffic`;
CREATE TABLE `air_ibe_traffic`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `data_source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'IBE' COMMENT '数据源渠道,IBE还是SUNSTN新港',
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '国内还是国际',
  `channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '渠道',
  `office_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `api` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '接口名',
  `record_source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '流量记录来源',
  `dis_id` int NULL DEFAULT 0 COMMENT '分销商ID',
  `month` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '月份',
  `day` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日期',
  `number` decimal(2, 1) NULL DEFAULT NULL COMMENT '流量条数',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `pnr` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作的PNR',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `create_index`(`created_at` ASC) USING BTREE,
  INDEX `day_index`(`day` ASC) USING BTREE,
  INDEX `type_index`(`type` ASC) USING BTREE,
  INDEX `channel_index`(`channel` ASC) USING BTREE,
  INDEX `api_index`(`api` ASC) USING BTREE,
  INDEX `source_index`(`record_source` ASC) USING BTREE,
  INDEX `data_source_index`(`data_source` ASC) USING BTREE,
  INDEX `pnr_index`(`pnr` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 281786 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ibe流量统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_international_price_detail
-- ----------------------------
DROP TABLE IF EXISTS `air_international_price_detail`;
CREATE TABLE `air_international_price_detail`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `task_id` int NULL DEFAULT NULL COMMENT '任务id',
  `air_company` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `depart_port` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '起飞机场',
  `arrive_port` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '目的机场',
  `sub_class` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '舱位',
  `airspace` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '飞行空域',
  `schedule_day` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '班期',
  `ahead_issue_ticket_day` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '提前出票天数',
  `price_header` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '价格头信息',
  `currency_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '货币类型',
  `price_rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运价规则',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价',
  `change_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费',
  `change_currency_type` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签货币类型',
  `refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票费',
  `refund_currency_type` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票货币类型',
  `apply_start_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '适用开始日期',
  `apply_end_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '适用结束日期',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1848 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际航线票价明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_international_price_task
-- ----------------------------
DROP TABLE IF EXISTS `air_international_price_task`;
CREATE TABLE `air_international_price_task`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `trip_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'OW' COMMENT '行程类型',
  `air_company` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `depart_port` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '起飞机场',
  `arrive_port` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目的机场',
  `task_status` tinyint(1) NOT NULL DEFAULT 6 COMMENT '1已入队、2进行中、3处理完成、4处理异常、5入队失败、6待入队',
  `command_log` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '命令日志',
  `fail_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '失败原因',
  `search_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '查询运价日期',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际航线票价任务' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_plane_model
-- ----------------------------
DROP TABLE IF EXISTS `air_plane_model`;
CREATE TABLE `air_plane_model`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `plane_model` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '机型',
  `made_firm` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生产厂家',
  `build_cost` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '机建费',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1:有效 2:无效',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 161 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '机型数据【机建费、燃油费】' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_platforms
-- ----------------------------
DROP TABLE IF EXISTS `air_platforms`;
CREATE TABLE `air_platforms`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '平台名称',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '平台编码',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `auth_nityfy_coding` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回填票号授权码',
  `config_template` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置模板',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '平台' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_platforms_data_sources
-- ----------------------------
DROP TABLE IF EXISTS `air_platforms_data_sources`;
CREATE TABLE `air_platforms_data_sources`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `platforms_id` int NOT NULL DEFAULT 0 COMMENT '销售平台id',
  `shipping_price_channel` tinyint(1) NOT NULL DEFAULT 0 COMMENT '运价渠道：1 IBE+，2 航班管家，3 易旅行',
  `main_channels` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否主要渠道：0 否，1 是',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售平台数据来源' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_position_ticket
-- ----------------------------
DROP TABLE IF EXISTS `air_position_ticket`;
CREATE TABLE `air_position_ticket`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位名称',
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位编码',
  `type` tinyint NULL DEFAULT NULL COMMENT '类型:1=定位;2=开票;3=定位+开票',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定位开票单位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_purchase_pricecomparison
-- ----------------------------
DROP TABLE IF EXISTS `air_purchase_pricecomparison`;
CREATE TABLE `air_purchase_pricecomparison`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '订单类型：1=国内,2=国际',
  `order_no` varchar(52) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `channel` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `price_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '价格列表数据',
  `ticket_rule_price` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '通过出票规则价格',
  `choose_price` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票选中价格',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `created_index`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购比价数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_purchase_sync_order
-- ----------------------------
DROP TABLE IF EXISTS `air_purchase_sync_order`;
CREATE TABLE `air_purchase_sync_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_type` tinyint(1) NOT NULL COMMENT '订单类型:1=国内订单,2=国际订单',
  `order_source` tinyint(1) NOT NULL COMMENT '来源:1=正常单,2=改签单,3=退票单',
  `sale_order_no` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售订单号',
  `out_order_no` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '外部订单号/流水号',
  `status` int NOT NULL COMMENT '状态:1=成功,2=失败',
  `params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求数据',
  `error_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '同步失败信息',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '渠道名称',
  `is_auto` tinyint(1) NULL DEFAULT NULL COMMENT '自动同步:1=是,2=否',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购同步订单记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_purchase_sync_rule
-- ----------------------------
DROP TABLE IF EXISTS `air_purchase_sync_rule`;
CREATE TABLE `air_purchase_sync_rule`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型:1=国内订单,2=国际订单',
  `order_source` tinyint(1) NULL DEFAULT NULL COMMENT '来源:1=正常单,2=改签单,3=退票单',
  `channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '渠道代码',
  `channel_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '渠道名称',
  `office_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `dictionary` json NULL COMMENT '字典',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `office_nos_json` json NULL,
  `office_nos_virtual` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS (json_unquote(`office_nos_json`)) VIRTUAL NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_office_nos`(`office_nos_virtual` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购同步规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_region
-- ----------------------------
DROP TABLE IF EXISTS `air_region`;
CREATE TABLE `air_region`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '行政区划代码',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `type` int NULL DEFAULT NULL COMMENT '类型: 1-省 直辖市   2-市  3-区县',
  `p_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '父级行政区划代码',
  `province_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '顶级代码',
  `code_city_str` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市3字码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3217 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_search_cache
-- ----------------------------
DROP TABLE IF EXISTS `air_search_cache`;
CREATE TABLE `air_search_cache`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'IBE' COMMENT '数据源渠道',
  `inter` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是国际',
  `trip_type` tinyint(1) NOT NULL COMMENT '行程类型:1=单程,2=往返,3=多程',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目的地',
  `dep_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发时间',
  `arr_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '返程时间',
  `carrier` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第一段航司',
  `flight_no` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第一段航班',
  `flight_numbers` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号集合,分割',
  `min_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '最低价格',
  `last_min_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '上次最低价格',
  `A` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'A舱余数',
  `B` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'B舱余数',
  `C` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'C舱余数',
  `D` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'D舱余数',
  `E` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'E舱余数',
  `last_e` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'E舱上次余数',
  `F` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'F舱余数',
  `G` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'G舱余数',
  `H` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'H舱余数',
  `I` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'I舱余数',
  `J` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'J舱余数',
  `K` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'K舱余数',
  `L` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'L舱余数',
  `M` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'M舱余数',
  `N` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'N舱余数',
  `O` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'O舱余数',
  `P` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'P舱余数',
  `Q` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'Q舱余数',
  `R` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'R舱余数',
  `S` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'S舱余数',
  `T` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'T舱余数',
  `U` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'U舱余数',
  `V` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'V舱余数',
  `W` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'W舱余数',
  `X` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'X舱余数',
  `Y` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'Y舱余数',
  `Z` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT 'Z舱余数',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `trip_type_index`(`trip_type` ASC) USING BTREE,
  INDEX `source_index`(`source` ASC) USING BTREE,
  INDEX `inter_index`(`inter` ASC) USING BTREE,
  INDEX `ori_index`(`ori` ASC) USING BTREE,
  INDEX `des_index`(`des` ASC) USING BTREE,
  INDEX `dep_date_index`(`dep_date` ASC) USING BTREE,
  INDEX `arr_date_index`(`arr_date` ASC) USING BTREE,
  INDEX `carrier_index`(`carrier` ASC) USING BTREE,
  INDEX `flight_no_index`(`flight_no` ASC) USING BTREE,
  INDEX `flight_numbers_index`(`flight_numbers` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1461472 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航班搜索数据缓存' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_search_cache_config
-- ----------------------------
DROP TABLE IF EXISTS `air_search_cache_config`;
CREATE TABLE `air_search_cache_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `inter` tinyint(1) NULL DEFAULT 0,
  `trip_type` tinyint(1) NULL DEFAULT NULL COMMENT '行程类型:1=单程,2=单程往返',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目的地',
  `carrier` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '指定航司',
  `dep_after` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发区间:格式3-45',
  `arr_type` tinyint(1) NULL DEFAULT 1 COMMENT '回程类型:1=去程日期累加,2=单独日期',
  `arr_after` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回程区间:格式2-7',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '查询缓存数据配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_search_price
-- ----------------------------
DROP TABLE IF EXISTS `air_search_price`;
CREATE TABLE `air_search_price`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `inter` tinyint(1) NULL DEFAULT 0,
  `trip_type` tinyint(1) NULL DEFAULT NULL COMMENT '行程类型:1=单程,2=单程往返',
  `config_id` int NULL DEFAULT NULL COMMENT '配置id',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目的地',
  `carrier` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '指定航司',
  `dep_date` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发时间',
  `flight_numbers` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号',
  `cabin` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位',
  `price` int NULL DEFAULT 0 COMMENT '舱位价格',
  `last_price` int NULL DEFAULT 0 COMMENT '舱位上次价格',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3502 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '查询缓存数据配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_search_price_config
-- ----------------------------
DROP TABLE IF EXISTS `air_search_price_config`;
CREATE TABLE `air_search_price_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `inter` tinyint(1) NULL DEFAULT 1 COMMENT '是否是国际',
  `trip_type` tinyint(1) NULL DEFAULT 1 COMMENT '行程类型:1=单程,2=单程往返',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目的地',
  `carrier` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '指定航司',
  `is_change` tinyint(1) NULL DEFAULT 0 COMMENT '是否变价',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 88 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '查询变价配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_search_price_config_date
-- ----------------------------
DROP TABLE IF EXISTS `air_search_price_config_date`;
CREATE TABLE `air_search_price_config_date`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `config_id` int NOT NULL,
  `dep_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发日期',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 508 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '查询变价配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_search_price_private
-- ----------------------------
DROP TABLE IF EXISTS `air_search_price_private`;
CREATE TABLE `air_search_price_private`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'TravelPort' COMMENT '数据源渠道',
  `inter` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否是国际',
  `trip_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '行程类型:1=单程,2=往返,3=多程',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目的地',
  `dep_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发时间',
  `arr_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '返程时间',
  `carriers` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司集合',
  `flight_numbers` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号集合,分割',
  `cabins` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位集合,分割',
  `fare_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运价类型',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '运价-票面价',
  `tour_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '团队代码',
  `pseudo_city_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '伪城市代码',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38420 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航班搜索私有运价缓存' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_shop
-- ----------------------------
DROP TABLE IF EXISTS `air_shop`;
CREATE TABLE `air_shop`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '店铺名称',
  `account_info` json NULL COMMENT '账户信息',
  `platform_id` int NULL DEFAULT NULL COMMENT '平台id',
  `scene` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1.线上店铺，2.线下店铺',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型：1.国内，2.国际',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `subject_id` int NULL DEFAULT NULL COMMENT '收支科目id',
  `is_sync_ota` tinyint(1) NULL DEFAULT 0 COMMENT '是否同步ota数据，0否，1是',
  `ota_admin_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'OTA店铺后台地址',
  `is_cheap_airline` tinyint(1) NULL DEFAULT 0 COMMENT '是否为廉航店铺：0.否，1.是',
  `shop_tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '店铺标识',
  `is_async_backfill` tinyint(1) NULL DEFAULT 0 COMMENT '是否异步回填： 0否，1是',
  `service_type` tinyint(1) NULL DEFAULT 1 COMMENT '服务费模式1=固定,2=百分比',
  `service_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '店铺服务费值',
  `open_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开放接口-密钥',
  `open_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开放接口-关键key',
  `open_url_ticketing` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开发接口-供应商出票回填地址',
  `open_url_lock` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开发接口-供应商锁单地址',
  `cheap_allow_airline` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '廉航允许航司，多个逗号分割',
  `currency_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售币种',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '店铺' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_shop_sys_department
-- ----------------------------
DROP TABLE IF EXISTS `air_shop_sys_department`;
CREATE TABLE `air_shop_sys_department`  (
  `shop_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `department_id` int NULL DEFAULT NULL COMMENT '部门id',
  INDEX ```sys_shop_id_index```(`shop_id` ASC) USING BTREE,
  INDEX ```sys_department_id_index```(`department_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '店铺-部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_sms_autograph
-- ----------------------------
DROP TABLE IF EXISTS `air_sms_autograph`;
CREATE TABLE `air_sms_autograph`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'key',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '签名名',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '短信签名' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_sms_logs
-- ----------------------------
DROP TABLE IF EXISTS `air_sms_logs`;
CREATE TABLE `air_sms_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tel` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号码',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信内容',
  `response_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信响应信息',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `raw_data` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '响应的原始数据',
  `operation_type` tinyint(1) NULL DEFAULT 0 COMMENT '操作类型：0系统，1导入，2手动',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注：操作人 或 来源',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17565 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_sms_sent_import
-- ----------------------------
DROP TABLE IF EXISTS `air_sms_sent_import`;
CREATE TABLE `air_sms_sent_import`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT ' ',
  `url_file` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件相对路径',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名',
  `admin_id` bigint NULL DEFAULT NULL COMMENT '操作人',
  `count` int NULL DEFAULT NULL COMMENT '短信条数',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '发送短信导入表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_sms_sent_record
-- ----------------------------
DROP TABLE IF EXISTS `air_sms_sent_record`;
CREATE TABLE `air_sms_sent_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT ' ',
  `sent_id` bigint NULL DEFAULT NULL COMMENT '导入ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '短信内容',
  `tel` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `states` tinyint NULL DEFAULT 0 COMMENT '状态 1：待发送 2：已发送 -1：导入失败 3：发送失败',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 573 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入发送短信 明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_sms_template
-- ----------------------------
DROP TABLE IF EXISTS `air_sms_template`;
CREATE TABLE `air_sms_template`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '模板名称',
  `tid` int NULL DEFAULT NULL COMMENT '模板类型id',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `example` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '模板示例',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  `temp_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '模板编号，全部大写字母',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '短信模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for air_sms_template_type
-- ----------------------------
DROP TABLE IF EXISTS `air_sms_template_type`;
CREATE TABLE `air_sms_template_type`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模板类型名称',
  `keywords` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '关键词',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for all_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `all_passenger_info`;
CREATE TABLE `all_passenger_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `passenger_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '年龄类型：ADU 成人，CHD 儿童，INF 婴儿',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '性别',
  `birth_date` date NULL DEFAULT NULL COMMENT '出生日期',
  `card_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件类型',
  `card_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件号码',
  `card_time_limit` datetime NULL DEFAULT NULL COMMENT '证件有效期',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号码',
  `nationality` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '国籍',
  `number_of_orders_placed` int NOT NULL DEFAULT 0 COMMENT '下单次数',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `card_no`(`card_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 142791 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '所有乘客信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for all_passenger_info_large_customer_attribution
-- ----------------------------
DROP TABLE IF EXISTS `all_passenger_info_large_customer_attribution`;
CREATE TABLE `all_passenger_info_large_customer_attribution`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `all_passenger_info_id` int NOT NULL DEFAULT 0 COMMENT '所有乘机人信息id',
  `customer_policy_id` int NOT NULL DEFAULT 0 COMMENT '大客户政策id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `all_passenger_info_id`(`all_passenger_info_id` ASC) USING BTREE,
  INDEX `customer_policy_id`(`customer_policy_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1790 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '所有乘机人信息大客户归属' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for aviation_transformation_center
-- ----------------------------
DROP TABLE IF EXISTS `aviation_transformation_center`;
CREATE TABLE `aviation_transformation_center`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `raw_id` int NOT NULL DEFAULT 0 COMMENT '原始信息id',
  `type` tinyint NOT NULL DEFAULT 1 COMMENT '类型 1:航班延误 2:航班取消 3:航班提前 4:航班变更 5:航班待定',
  `pnr` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'PNR',
  `is_protect` tinyint NOT NULL DEFAULT 1 COMMENT '1:有保护  2:无保护',
  `flight_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班类型：N.国内，I.国际',
  `source` tinyint NULL DEFAULT 2 COMMENT '来源  1:sms 2:eterm 3:email 4:ys',
  `status` tinyint NULL DEFAULT 1 COMMENT '解析状态  1:未解析 2：已解析 3：无法解析',
  `old_aviation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '原订单航司',
  `old_flight` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '原航班号',
  `old_departure_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '原起飞机场',
  `old_arrive_airport` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '原抵达机场',
  `old_departure_time` datetime NULL DEFAULT NULL COMMENT '原起飞时间',
  `old_arrive_time` datetime NULL DEFAULT NULL COMMENT '原抵达时间',
  `old_cabin` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原舱位',
  `old_dep_terminal` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原出发航站楼',
  `old_arr_terminal` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原到达航站楼',
  `new_aviation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新订单航司',
  `new_flight` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新航班号',
  `new_departure_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新起飞机场',
  `new_arrive_airport` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新抵达机场',
  `new_departure_time` datetime NULL DEFAULT NULL COMMENT '新起飞时间',
  `new_arrive_time` datetime NULL DEFAULT NULL COMMENT '新抵达时间',
  `new_cabin` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新舱位',
  `new_dep_terminal` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新出发航站楼',
  `new_arr_terminal` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新到达航站楼',
  `transformation_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '航变黑屏编码',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `sale_store_id` int NULL DEFAULT NULL COMMENT '销售店铺id',
  `ticket_nos` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号集合',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `type_index`(`type` ASC) USING BTREE,
  INDEX `pnr_index`(`pnr` ASC) USING BTREE,
  INDEX `flight_type_index`(`flight_type` ASC) USING BTREE,
  INDEX `status_index`(`status` ASC) USING BTREE,
  INDEX `sale_order_no_index`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20428 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航变中心' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for aviation_transformation_center_comments
-- ----------------------------
DROP TABLE IF EXISTS `aviation_transformation_center_comments`;
CREATE TABLE `aviation_transformation_center_comments`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `transformation_id` int NULL DEFAULT 0,
  `uid` int NULL DEFAULT 0 COMMENT 'user_id',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tid_index`(`transformation_id` ASC) USING BTREE,
  INDEX `uid_index`(`uid` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for aviation_transformation_center_log
-- ----------------------------
DROP TABLE IF EXISTS `aviation_transformation_center_log`;
CREATE TABLE `aviation_transformation_center_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `transformation_id` int NULL DEFAULT NULL COMMENT '航变id',
  `type` tinyint NULL DEFAULT 1 COMMENT '1：正常单订单 2：改签单订单 3：退票单订单',
  `is_success` tinyint NOT NULL DEFAULT 0 COMMENT '0:未通知 1：手动处理 2：通知成功 3：已忽略 4：通知中 5：通知失败',
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '异常内容',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `uid` int NULL DEFAULT 0 COMMENT '操作人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tid_index`(`transformation_id` ASC) USING BTREE,
  INDEX `success_index`(`is_success` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1916 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for aviation_transformtion_raw
-- ----------------------------
DROP TABLE IF EXISTS `aviation_transformtion_raw`;
CREATE TABLE `aviation_transformtion_raw`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `source` tinyint(1) NOT NULL DEFAULT 2 COMMENT '来源  1:sms 2:eterm 3:email',
  `pnr` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'PNR',
  `raw_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原编码md5加密，用于比对是否为重复数据',
  `raw_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '黑屏原始信息，bin2hex函数转成16进制存储',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '解析状态：0.解析失败，1.解析成功',
  `national` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国内N，国际I',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pnr_index_raw_hash_index`(`pnr` ASC, `raw_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26387 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航变解析前的原始信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for b_bill_adjustment
-- ----------------------------
DROP TABLE IF EXISTS `b_bill_adjustment`;
CREATE TABLE `b_bill_adjustment`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL DEFAULT 0 COMMENT '账单ID',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1. 补差，2.调账，3对账',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售单号',
  `ticket_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `channel_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '渠道类型：1.销售，2.采购',
  `order_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '订单类型：1.正常单，2.改签单，3.退票单',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调账金额',
  `remark` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '调整备注',
  `purchase_platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购渠道_office号',
  `office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'office_no',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `operator_id` int NOT NULL COMMENT '操作人ID',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `bill_checked_at` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作人姓名',
  `adjusted_need_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整的应收应付应退金额',
  `adjusted_paid_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整的实收实付实退金额',
  `adjusted_need_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整后的应收应付应退总金额',
  `adjusted_paid_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整后的实收实付实退总金额',
  `adjusted_diff_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整后的差异总金额',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账, 6.销账',
  `is_diff_bill` tinyint NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index`(`order_no` ASC, `ticket_no` ASC, `purchase_platform` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '账单调账/补差表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for b_bill_change_domestic_ota
-- ----------------------------
DROP TABLE IF EXISTS `b_bill_change_domestic_ota`;
CREATE TABLE `b_bill_change_domestic_ota`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `applied_at` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `old_change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签订单号',
  `change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签订单号',
  `external_sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'OTA订单号',
  `external_change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'OTA改签单号',
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-销售订单号',
  `passenger_age_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT ' 乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `sale_store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `old_take_off_time` datetime NULL DEFAULT NULL COMMENT '原-改签前起飞时间',
  `old_pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-pnr',
  `old_ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签前票号',
  `old_company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-航司二字码',
  `old_flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签前航班',
  `old_freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签前仓位',
  `old_voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签前航程',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '改签后起飞时间',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后票号',
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后仓位',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后航程',
  `sale_subject_id` int NULL DEFAULT NULL COMMENT '销售科目',
  `purchase_subject_id` int NULL DEFAULT NULL COMMENT '采购科目',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生编office号',
  `old_sale_receivable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '原—销售应收票面价',
  `sale_receivable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收票面价',
  `sale_receivable_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收税金总金额（机建+燃油）',
  `sale_price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售票税差',
  `sale_receivable_renewal_fee` decimal(10, 2) NOT NULL COMMENT '销售应收改签手续费',
  `sale_receivable_service_fee` decimal(10, 2) NOT NULL COMMENT '销售应收改签服务费',
  `sale_receivable_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收其它费用',
  `sale_receivable_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收总金额（销售票税差+销售应收改签手续费+销售应收改签服务费+销售应收其它费用）',
  `sale_collection_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实收总金额(ota平台改签实收金额)',
  `sale_collection_total_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售实收差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账，6销账',
  `sale_is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `sale_is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `sale_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '销售对账时间',
  `sale_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售下账人',
  `old_purchase_payable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '原-采购应付票面价',
  `purchase_payable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应付票面价',
  `purchase_payable_ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付税金总金额（机建+燃油）',
  `purchase_price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购票税差',
  `purchase_payable_renewal_fee` decimal(10, 2) NOT NULL COMMENT '采购应付改签手续费',
  `purchase_payable_service_fee` decimal(10, 2) NOT NULL COMMENT '采购应付改签服务费',
  `purchase_payable_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付其它费用',
  `purchase_payable_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应付金额（采购票税差+采购应付改签手续费+采购应付改签服务费+采购应付其它费用）',
  `purchase_payment_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实付金额',
  `purchase_payment_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实付差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '采购状态：1.待对账，2.已对账,6.销账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否坏账:0.不是，1.是',
  `purchase_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '采购对账时间',
  `purchase_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购下账人',
  `gross_profit_receivable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售毛利（销售应收总金额-采购应付金额）',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NOT NULL,
  `complete_time` datetime NULL DEFAULT NULL COMMENT '改签完成时间',
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `purchase_issue_bill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '交易流水号',
  `op_purchase_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'op采购账号',
  `sale_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-预算调整',
  `sale_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-收款调整',
  `purchase_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-预算调整',
  `purchase_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-付款调整',
  `operator_id` int NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务对账报表改签单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for b_bill_import_record_details
-- ----------------------------
DROP TABLE IF EXISTS `b_bill_import_record_details`;
CREATE TABLE `b_bill_import_record_details`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `record_id` int NOT NULL DEFAULT 0 COMMENT '导入记录id',
  `channel_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1.销售账单，2.采购账单',
  `order_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型：1.出票，2.改签，3.退票',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1.未匹配，2.已对账，3.异常',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '自建平台订单号',
  `issue_bill_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三放平台账单单号',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号,多个票号逗号分隔',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '总金额',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为差异订单：0:否，1.是',
  `operator_id` int NOT NULL DEFAULT -1 COMMENT '操作人：-1:系统，否者用户',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `messages` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志信息\r\n日志信息',
  `bill_checked_at` datetime NULL DEFAULT NULL COMMENT '对账时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入记录详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for b_bill_import_records
-- ----------------------------
DROP TABLE IF EXISTS `b_bill_import_records`;
CREATE TABLE `b_bill_import_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `channel_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1.销售账单，2.采购账单',
  `channel_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售/采购渠道',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件地址',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `total_number` int NOT NULL DEFAULT 0 COMMENT '统计数',
  `no_diff_number` int NOT NULL DEFAULT 0 COMMENT '对账数（无差异）',
  `diff_number` int NOT NULL DEFAULT 0 COMMENT '差异数',
  `unmatched` int NOT NULL DEFAULT 0 COMMENT '未匹配数',
  `unusual` int NOT NULL DEFAULT 0 COMMENT '状态异常',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for b_bill_normal_domestic_ota
-- ----------------------------
DROP TABLE IF EXISTS `b_bill_normal_domestic_ota`;
CREATE TABLE `b_bill_normal_domestic_ota`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售订单号',
  `external_sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ota平台出票订单单号',
  `purchase_order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购订单号',
  `external_purchase_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '第三方采购订单号',
  `purchase_issue_bill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '交易流水号',
  `op_purchase_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'op采购账号',
  `issue_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` datetime NULL DEFAULT NULL COMMENT '抵达时间',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `policy_code` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '政策代码',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_age_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT ' 乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '仓位',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `sale_store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `gross_profit_receivable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售毛利（应收-应付）',
  `sale_receivable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收票面价',
  `sale_receivable_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收税金总金额（机建+燃油）',
  `sale_receivable_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收金额',
  `sale_collection_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实收金额',
  `sale_collection_total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实收差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '销售状态：1.待对账，2.已对账, 6.销账',
  `sale_is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '销售是否差异账单：0.正常，1.差异',
  `sale_is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '销售是否坏账:0.不是，1.是',
  `sale_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '销售对账时间',
  `sale_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售下账人',
  `purchase_payable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应付票面价',
  `purchase_payable_ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付税金总金额（机建+燃油）',
  `purchase_payable_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应付金额',
  `purchase_payment_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实付金额',
  `purchase_payment_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实付差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '采购状态：1.待对账，2.已对账,6.销账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否坏账:0.不是，1.是',
  `purchase_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '采购对账时间',
  `purchase_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购下账人',
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NOT NULL COMMENT '账单创建时间',
  `updated_at` datetime NOT NULL,
  `sale_subject_id` int NULL DEFAULT NULL COMMENT '销售科目',
  `purchase_subject_id` int NULL DEFAULT NULL COMMENT '采购科目',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生编office号',
  `sale_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-预算调整',
  `sale_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-收款调整',
  `purchase_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-预算调整',
  `purchase_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-付款调整',
  `operator_id` int NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  `purchase_agent_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '代理费率',
  `purchase_agent_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理奖励金额（采购票面价*代理费率）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务对账报表正常单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for b_bill_order_log
-- ----------------------------
DROP TABLE IF EXISTS `b_bill_order_log`;
CREATE TABLE `b_bill_order_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '操作内容',
  `user_id` int NULL DEFAULT NULL COMMENT '操作人',
  `order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `order_type` tinyint NULL DEFAULT NULL COMMENT '订单类型  2：改签单  3：退票单',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单 退票单流转日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for b_bill_return_domestic_ota
-- ----------------------------
DROP TABLE IF EXISTS `b_bill_return_domestic_ota`;
CREATE TABLE `b_bill_return_domestic_ota`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `applied_at` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `first_audit_uid` int NULL DEFAULT NULL COMMENT '一审人 (账单生成时间)',
  `first_audited_at` datetime NULL DEFAULT NULL COMMENT '一审时间',
  `recheck_audit_uid` int NULL DEFAULT NULL COMMENT '复审人',
  `recheck_audited_at` datetime NULL DEFAULT NULL COMMENT '复审时间',
  `submitted_at` datetime NULL DEFAULT NULL COMMENT '已提交时间',
  `source_type` tinyint(1) NULL DEFAULT 1 COMMENT '\'退废来源  1 销售单退废 2改签单退废\'',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台销售单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `external_refund_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'OTA退票单号',
  `ota_sign_hash` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单哈希标识',
  `passenger_age_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT ' 乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `sale_store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `sale_subject_id` int NULL DEFAULT 0 COMMENT '销售科目',
  `purchase_subject_id` int NULL DEFAULT 0 COMMENT '采购科目',
  `pnr` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `ticket_no` varchar(59) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '仓位',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '起飞时间',
  `sale_refund_type` tinyint(1) NULL DEFAULT 1 COMMENT '退废类型 1退票 2废票',
  `sale_refund_idea_type` tinyint(1) NULL DEFAULT 1 COMMENT '自愿退废  1 是  2 否',
  `sale_refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票原因',
  `sale_expected_refund_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应退票面价',
  `sale_expected_refund_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应退税金金额',
  `sale_receivable_renewal_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收手续费',
  `sale_receivable_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收服务费',
  `sale_receivable_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收其它费用',
  `sale_expected_refund_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应退总金额（应退票面价+应退税金金额-销售应收手续费-销售应收服务费-销售应收其它费用）',
  `sale_actual_refund_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实退总金额',
  `sale_actual_refund_total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实退差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账，6销账',
  `sale_is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `sale_is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `sale_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '销售对账时间',
  `sale_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售下账人',
  `purchase_refund_type` tinyint(1) NULL DEFAULT 1 COMMENT '退废类型 1退票 2废票',
  `purchase_refund_idea_type` tinyint(1) NULL DEFAULT 1 COMMENT '自愿退废  1 是  2 否',
  `purchase_expected_refund_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应退票面价',
  `purchase_expected_refund_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应退税金金额',
  `purchase_payable_renewal_fee` decimal(10, 2) NOT NULL COMMENT '采购应付手续费',
  `purchase_payable_service_fee` decimal(10, 2) NOT NULL COMMENT '采购应付服务费',
  `purchase_payable_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付其它费用',
  `purchase_payable_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付代理费',
  `purchase_expected_refund_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应退总金额（应退票面价+应退税金金额-采购应收手续费-采购应收服务费-采购应收其它费用-采购应付代理费）',
  `purchase_expected_aircom_refund_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购航司应退总金额（人工提交应退价格）',
  `purchase_actual_refund_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购实退总金额',
  `purchase_actual_refund_total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购实退差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '采购状态：1.待对账，2.已对账,6.销账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否坏账:0.不是，1.是',
  `purchase_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '采购对账时间',
  `purchase_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购下账人',
  `gross_profit_receivable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售毛利（采购应退总金额-销售应退总金额）',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NOT NULL,
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `purchase_issue_bill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '交易流水号',
  `op_purchase_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'op采购账号',
  `sale_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-预算调整',
  `sale_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-收款调整',
  `purchase_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-预算调整',
  `purchase_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-付款调整',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生编office号',
  `operator_id` int NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务对账报表退废单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for b_bill_statistical_purchase_profit_voyage
-- ----------------------------
DROP TABLE IF EXISTS `b_bill_statistical_purchase_profit_voyage`;
CREATE TABLE `b_bill_statistical_purchase_profit_voyage`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `d_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '开始机场三字码',
  `a_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '结束机场三字码',
  `port_str` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程中文名',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '利润统计 航程中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_adjustment
-- ----------------------------
DROP TABLE IF EXISTS `bill_adjustment`;
CREATE TABLE `bill_adjustment`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1. 补差，2.调账',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售单号',
  `ticket_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `channel_type` tinyint(1) NULL DEFAULT NULL COMMENT '渠道类型：1.销售，2.采购',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型：1.正常单，2.改签单，3.退票单',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调账金额',
  `remark` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '调整备注',
  `sale_platform` int NULL DEFAULT NULL COMMENT '渠道id',
  `store_id` int NULL DEFAULT NULL,
  `purchase_channel` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道_office号',
  `subject_id` int NULL DEFAULT NULL COMMENT '资金科目id',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作人ID',
  `add_time` datetime NULL DEFAULT NULL COMMENT '添加时间',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index`(`order_no` ASC, `ticket_no` ASC, `purchase_channel` ASC) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `ticket_no`(`ticket_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17522 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '账单调账/补差表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_finance_operating_change
-- ----------------------------
DROP TABLE IF EXISTS `bill_finance_operating_change`;
CREATE TABLE `bill_finance_operating_change`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `apply_time` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签订单号',
  `issue_bill` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'OTA订单号',
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售订单号',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '毛利',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后票号',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后仓位',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后航程',
  `take_off_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签后起飞时间',
  `old_ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签前票号',
  `old_flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签前航班',
  `old_freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签前仓位',
  `old_voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签前航程',
  `old_take_off_time` datetime NULL DEFAULT NULL COMMENT '改签前起飞时间',
  `store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售订单应收金额',
  `sale_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `sale_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实收差异金额',
  `ota_sale_total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '实收总金额',
  `total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应收差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `bill_sale_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '下账人',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单应收金额',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金总金额',
  `purchase_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'ota平台订单实收金额',
  `purchase_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实收差异金额',
  `purchase_total_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应收差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `purchase_bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `purchase_bill_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下账人',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `complete_time` datetime NULL DEFAULT NULL COMMENT '改签完成时间',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `sale_subject_id` int NULL DEFAULT NULL COMMENT '销售单科目',
  `purchase_subject_id` int NULL DEFAULT NULL COMMENT '采购单科目',
  `office_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4502 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务盈亏报表改签单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_finance_operating_normal
-- ----------------------------
DROP TABLE IF EXISTS `bill_finance_operating_normal`;
CREATE TABLE `bill_finance_operating_normal`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `take_off_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售订单号',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `policy_code` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '政策代码',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '仓位',
  `store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '毛利',
  `arrival_time` datetime NULL DEFAULT NULL COMMENT '抵达时间',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `sale_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收票面价',
  `sale_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收税金',
  `sale_total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售应收总金额',
  `ota_sale_total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售实收总金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实收差异金额',
  `total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `bill_sale_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '下账人',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `issue_bill` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'OTA订单号',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单应收金额',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金总金额',
  `purchase_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'ota平台订单实收金额',
  `purchase_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实收差异金额',
  `purchase_total_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应收差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `purchase_bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `pubrchase_bill_sale_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下账人',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `sale_subject_id` int NULL DEFAULT NULL COMMENT '销售单科目',
  `purchase_subject_id` int NULL DEFAULT NULL COMMENT '采购单科目',
  `office_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `purchase_foreign_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购外币金额',
  `purchase_currency` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CNY' COMMENT '采购币种',
  `after_rebate_rate` float NOT NULL DEFAULT 0 COMMENT '后返费率',
  `after_rebate_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '后返金额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `sale_order_no_2`(`sale_order_no` ASC, `ticket_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 132042 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务盈亏报表正常单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_finance_operating_retrun
-- ----------------------------
DROP TABLE IF EXISTS `bill_finance_operating_retrun`;
CREATE TABLE `bill_finance_operating_retrun`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ota_rt_time` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `confirm_time` datetime NULL DEFAULT NULL COMMENT '确认时间',
  `recheck_audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `purchase_time` datetime NULL DEFAULT NULL COMMENT '采购销账时间',
  `sale_time` datetime NULL DEFAULT NULL COMMENT '销售销账时间',
  `refund_idea_type` tinyint(1) NULL DEFAULT NULL COMMENT '自愿退废  1 是  2 否',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台销售单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `ota_refund_no` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台退票单号',
  `ota_sign_hash` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单哈希标识',
  `pnr` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `policy_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '政策代码',
  `ticket_no` varchar(59) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '仓位',
  `gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实退毛利',
  `store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '所属部门',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票费',
  `sale_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `sale_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `ota_sale_total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售实收金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实收差异金额',
  `total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应收差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账 6.销账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `bill_sale_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '下账人',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `issue_bill` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'OTA订单号',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票费',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `purchase_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'ota平台订单实收金额',
  `purchase_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实收差异金额',
  `purchase_total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应收差异金额',
  `purchase_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `purchase_is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `purchase_bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `purchase_bill_sale_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下账人',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `submitted_time` datetime NULL DEFAULT NULL COMMENT '提交时间',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `total_gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总毛利',
  `airline_refund_money` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '航司应退金额',
  `sale_subject_id` int NULL DEFAULT NULL COMMENT '销售单科目',
  `purchase_subject_id` int NULL DEFAULT NULL COMMENT '采购单科目',
  `office_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20956 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务盈亏报表退废单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_import_record
-- ----------------------------
DROP TABLE IF EXISTS `bill_import_record`;
CREATE TABLE `bill_import_record`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1.销售账单，2.采购账单',
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售渠道',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件地址',
  `operator` int NULL DEFAULT NULL COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3087 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_notify_statistics
-- ----------------------------
DROP TABLE IF EXISTS `bill_notify_statistics`;
CREATE TABLE `bill_notify_statistics`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_platform` int NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `order_num` int NULL DEFAULT 0 COMMENT '订单数                     (正常单)',
  `tickets` int NULL DEFAULT 0 COMMENT '票数',
  `sequence` int NULL DEFAULT 0 COMMENT '航段数',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票面价总金额(销售)',
  `ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金总金额(销售)',
  `total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '订单应收金额(销售)',
  `ticket_price_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票面价总金额(采购)',
  `ticket_tax_price_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金总金额(采购)',
  `total_amount_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '订单应付金额(采购)',
  `estimated_profit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '预计利润',
  `order_num_change` int NULL DEFAULT 0 COMMENT '订单数              (改签单)',
  `tickets_change` int NULL DEFAULT 0 COMMENT '票数',
  `sequence_change` int NULL DEFAULT 0 COMMENT '航段数',
  `trouble_fee_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费',
  `service_fee_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `other_price_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用',
  `total_amount_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应收',
  `trouble_fee_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费',
  `service_fee_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `other_price_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费',
  `total_amount_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应付',
  `estimated_profit_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '预计利润',
  `order_num_refund` int NULL DEFAULT 0 COMMENT '订单数                (退票)',
  `refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票费',
  `service_fee_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `other_price_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费',
  `total_amount_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应退',
  `refund_fee_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票费',
  `service_fee_refund_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `other_price_refund_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费',
  `total_amount_refund_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应退',
  `estimated_profit_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '预计利润',
  `day_time` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 146 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '回填盈亏统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `bill_operate_log`;
CREATE TABLE `bill_operate_log`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` int NULL DEFAULT NULL COMMENT '账单ID',
  `channel_type` tinyint(1) NULL DEFAULT NULL COMMENT '渠道类型：1.销售，2.采购',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型：1.正常单，2.改签单，3.退票单',
  `operate_type` tinyint(1) NULL DEFAULT NULL COMMENT '操作类型：1.对账，2.差异对账，3.补差，4.调账',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '金额',
  `remark` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 256106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '账单操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_operating_change_statement
-- ----------------------------
DROP TABLE IF EXISTS `bill_operating_change_statement`;
CREATE TABLE `bill_operating_change_statement`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签单号',
  `apply_user` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '申请人',
  `sale_channel` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售渠道',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '所属部门',
  `store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `examine_user` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '审核者',
  `pnr` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'PNR',
  `company_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `old_ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原票号',
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '新票号',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人',
  `card_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `take_off_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `purchase_channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票价',
  `ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金',
  `ticket_settle_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票税总额',
  `price_differential` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票税差',
  `other_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '其他费用',
  `service_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签服务费',
  `trouble_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签费用',
  `change_total_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签总费用',
  `purchase_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购价',
  `purchase_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购税金',
  `purchase_ticket_settle_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购票税总额',
  `purchase_agent_rate` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购代理费率',
  `purchase_price_differential` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购票税差',
  `purchase_other_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购其他费用',
  `purchase_service_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购改签服务费',
  `purchase_trouble_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购改签费用',
  `purchase_change_total_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购改签总费用',
  `gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '毛利',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `purchase_platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `office_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购office号',
  `old_voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧航程',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新航程',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4465 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '运营亏盈报表改签单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_operating_normal_statement
-- ----------------------------
DROP TABLE IF EXISTS `bill_operating_normal_statement`;
CREATE TABLE `bill_operating_normal_statement`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entry_time` datetime NULL DEFAULT NULL COMMENT '进单时间',
  `ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `issue_way` tinyint(1) NULL DEFAULT 0 COMMENT '0手工出票  1自动出票',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `issue_bill` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ota平台出票订单单号',
  `sale_platform` tinyint(1) NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `pnr` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'PNR',
  `flight` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班号',
  `ticket_no` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '旅客名字',
  `age_type` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人类型',
  `sequence_type` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程类型',
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '舱位',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `voyage_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程(三字码)',
  `take_off_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售票面价',
  `sale_floor_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售底价',
  `sale_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售税费',
  `sale_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售含税结算价',
  `sale_floor_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售含税结算底价',
  `issue_bill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'OTA订单号',
  `purchase_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购票面价',
  `purchase_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购税费',
  `purchase_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购含税结算价',
  `agent_rate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '代理费率',
  `agent_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理奖励金额',
  `gross_profit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '毛利',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `purchase_platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购渠道',
  `office_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购office号',
  `customer_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大客户',
  `position_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '定位代码',
  `position_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '定位费',
  `ticket_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票代码',
  `ticket_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '开票费',
  `purchase_foreign_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购外币金额',
  `purchase_currency` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CNY' COMMENT '采购外币币种',
  `after_rebate_rate` float NOT NULL DEFAULT 0 COMMENT '后返费率',
  `after_rebate_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '后返金额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `ticket_time_index`(`ticket_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 132044 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '运营亏盈报表正常单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_operating_return_statement
-- ----------------------------
DROP TABLE IF EXISTS `bill_operating_return_statement`;
CREATE TABLE `bill_operating_return_statement`  (
  `refund_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `sale_order_no` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `store_id` int NULL DEFAULT NULL COMMENT '销售渠道id (携程国际店铺)',
  `first_audit_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '审核者',
  `first_audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `apply_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '申请人',
  `department` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '审核部门',
  `refund_idea_type` tinyint NULL DEFAULT 0 COMMENT '1：自愿退票 2：非自愿退票 3：自愿废票 4：非自愿废票',
  `pnr` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'PNR',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航司二字码',
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人',
  `card_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '证件类型',
  `take_off_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班号',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `voyage_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程(三字码)',
  `has_returned_difference_str` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '回款差异',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售票价',
  `sale_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售税费',
  `sale_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售服务费',
  `sale_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售其它费用',
  `sale_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售代理费用',
  `sale_refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售退票费',
  `sale_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应退金额',
  `purchase_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购票价',
  `purchase_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购税费',
  `purchase_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购服务费',
  `purchase_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购其它费',
  `purchase_refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购退票费',
  `purchase_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应退金额',
  `airline_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '航司应退金额',
  `diff_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '差异金额',
  `gross_profit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '毛利',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `submitted_time` datetime NULL DEFAULT NULL COMMENT '提交时间',
  `office_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购office号',
  `purchase_platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20966 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '运营亏盈报表退票单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_parse_record
-- ----------------------------
DROP TABLE IF EXISTS `bill_parse_record`;
CREATE TABLE `bill_parse_record`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `ticket_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `order_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '出票类型：1.正常单，2.改签单，3.退票单，4.废票',
  `ticket_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票价',
  `tax` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税总和',
  `agent_rate` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '代理费率',
  `agent_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理费',
  `refund_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票费',
  `actual_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实际金额',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'PNR',
  `issue_ticket_time` date NULL DEFAULT NULL COMMENT '出票时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `bill_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '账单渠道：1.国内，2.国际，3.分销',
  `issue_ticket_channel` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BSP' COMMENT 'BSP,BOP',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.未完成，2.已完成',
  `type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'C' COMMENT '拉取类型：R退票，C全部',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 147444 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'eterm账单拉取记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_purchase_change_order
-- ----------------------------
DROP TABLE IF EXISTS `bill_purchase_change_order`;
CREATE TABLE `bill_purchase_change_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签单采购单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常单销售单号',
  `change_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签单销售单号',
  `issue_bill_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'ota出票单号',
  `rebooking_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota改签单号',
  `sale_platform` int NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '销售店铺',
  `purchase_platform` tinyint NULL DEFAULT NULL COMMENT '采购渠道',
  `office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单应退金额',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票税差',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其它费用',
  `service_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `trouble_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '手续费用',
  `ota_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'ota平台订单实退金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `file_id` int NULL DEFAULT NULL COMMENT '附件文件id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `agent_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理费',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间（改签完成时间）',
  `write_off_date` timestamp NULL DEFAULT NULL,
  `old_ticket_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原始票号',
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航线',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '对账销售端 销售改签总金额',
  `check_operator_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对账操作人名称',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT NULL COMMENT '资金科目ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4500 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购单对账表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_purchase_daily_analysis
-- ----------------------------
DROP TABLE IF EXISTS `bill_purchase_daily_analysis`;
CREATE TABLE `bill_purchase_daily_analysis`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` int NULL DEFAULT NULL COMMENT '采购渠道',
  `platform_office_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '格式：BOP_WNZ201',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '账单类型：1.出票，2.改签，3.退票',
  `ota_normal_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '正常单实收金额',
  `normal_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '正常单应收金额',
  `ota_change_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签单实收金额',
  `change_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签单应收金额',
  `ota_refund_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票单实退金额',
  `refund_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票单应退金额',
  `time_date` date NULL DEFAULT NULL COMMENT '日期，按天',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7838 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购账单每日统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_purchase_daily_analysis_relation
-- ----------------------------
DROP TABLE IF EXISTS `bill_purchase_daily_analysis_relation`;
CREATE TABLE `bill_purchase_daily_analysis_relation`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `daily_analysis_id` int NULL DEFAULT NULL,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `order_id` int NULL DEFAULT NULL COMMENT '订单id',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型：1.出票，2.改签，3.退票\r\n',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '收入金额（应）',
  `ota_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '收入金额(实)',
  `order_created_at` datetime NULL DEFAULT NULL COMMENT '账单生成时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 149239 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购账单每日统计与采购账单中间表\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_purchase_import_bsp
-- ----------------------------
DROP TABLE IF EXISTS `bill_purchase_import_bsp`;
CREATE TABLE `bill_purchase_import_bsp`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `record_id` int NOT NULL DEFAULT 0 COMMENT '导入记录id',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台订单号',
  `sale_channel` tinyint(1) NOT NULL DEFAULT 0 COMMENT '销售模式分类：1国际，3国内电商，4国内分销',
  `purchase_channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `company_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司二字码',
  `mode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '国内/国际 标识',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '出票日期',
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'bop标识',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型：1.出票，2.改签，3.退票',
  `type_original` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原始类型',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1.未匹配，2.已对账，3.差异，4.坏账，5.已回款',
  `issue_bill_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单号',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号,多个票号逗号分隔',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总金额',
  `operator` int NOT NULL DEFAULT -1 COMMENT '操作人：-1:系统，否者用户',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '日志',
  `line` int UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127217 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '全局采购【bsp&bop】导入记录详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_purchase_import_logs
-- ----------------------------
DROP TABLE IF EXISTS `bill_purchase_import_logs`;
CREATE TABLE `bill_purchase_import_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `record_id` int NOT NULL DEFAULT 0 COMMENT '导入记录id',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台订单号',
  `purchase_channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型：1.出票，2.改签，3.退票',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1.未匹配，2.已对账，3.差异，4.坏账，5.已回款',
  `issue_bill_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单号',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号,多个票号逗号分隔',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总金额',
  `operator` int NOT NULL DEFAULT -1 COMMENT '操作人：-1:系统，否者用户',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '日志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122611 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入记录详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `bill_purchase_order`;
CREATE TABLE `bill_purchase_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常单采购单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常单销售单号',
  `issue_bill_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台出票订单单号',
  `sale_platform` int NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '销售店铺',
  `purchase_platform` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单应收金额',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `ota_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'ota平台订单实收金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账, 6.已销账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间（出票时间）',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `file_id` int NULL DEFAULT NULL COMMENT '附件文件id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `write_off_date` timestamp NULL DEFAULT NULL,
  `company_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航线',
  `sale_total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '对账销售端 销售改签总金额',
  `check_operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对账操作人名称',
  `age_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT ' 乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT NULL COMMENT '资金科目ID',
  `foreign_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '外币金额',
  `currency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CNY' COMMENT '币种',
  `protocol_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '协议号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `issue_bill_id`(`issue_bill_id` ASC) USING BTREE,
  INDEX `ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `sale_order_no_2`(`sale_order_no` ASC, `ticket_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131358 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购单对账表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_purchase_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `bill_purchase_refund_order`;
CREATE TABLE `bill_purchase_refund_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票单采购单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常单销售单号',
  `refund_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票单销售单号',
  `issue_bill_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'ota出票单号',
  `prid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'OTA退票单号',
  `sale_platform` int NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '销售店铺',
  `purchase_platform` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单应退金额',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `refund_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票费用',
  `service_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `agency_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '代理费',
  `other_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '其它费用',
  `ota_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'ota平台订单实退金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `file_id` int NULL DEFAULT NULL COMMENT '附件文件id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `write_off_date` timestamp NULL DEFAULT NULL,
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航线',
  `refund_type` tinyint NOT NULL DEFAULT 0 COMMENT '退废类型 1退票 2废票',
  `refund_idea_type` tinyint NULL DEFAULT 0 COMMENT '销售端 - 自愿退废  1 是  2 否',
  `aviation_refund_idea_type` tinyint NULL DEFAULT 0 COMMENT '采购端 - 自愿退废  1 是  2 否',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '对账销售端应退金额',
  `aviation_purchase_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '对账采购端航司应退金额',
  `check_operator_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对账操作人名称',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT NULL COMMENT '资金科目ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20466 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购单对账表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `bill_refund_order`;
CREATE TABLE `bill_refund_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票单销售单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常单销售单号',
  `issue_bill_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ota出票单号',
  `prid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'OTA退票单号',
  `sale_platform` tinyint NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '销售店铺',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应退金额',
  `refund_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票费',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价',
  `ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金',
  `service_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费用',
  `other_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '其他费用',
  `ota_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'ota平台订单实退金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异：0.否，1.是',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账：0.否，1.是',
  `file_id` int NULL DEFAULT NULL COMMENT '附件id',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间（退票一审时间）',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号，多个逗号分隔',
  `write_off_date` timestamp NULL DEFAULT NULL,
  `check_operator_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对账操作人名称',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT NULL COMMENT '资金科目ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `issue_bill_id`(`issue_bill_id` ASC) USING BTREE,
  INDEX `prid`(`prid` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16585 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售单对账表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_sale_change_order
-- ----------------------------
DROP TABLE IF EXISTS `bill_sale_change_order`;
CREATE TABLE `bill_sale_change_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签单销售单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常单销售单号',
  `issue_bill_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'ota出票单号',
  `rebooking_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'ota改签单号',
  `sale_platform` tinyint(1) NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '销售店铺',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签应收金额',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价金额',
  `ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金',
  `trouble_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '改签手续费',
  `price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票税差',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其它费用',
  `service_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '改签服务费',
  `ota_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'ota平台改签实收金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间（改签完成时间）',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `file_id` int NULL DEFAULT NULL COMMENT '附件id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异：0.否，1.是',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账：0.否，1.是',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `write_off_date` timestamp NULL DEFAULT NULL,
  `check_operator_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对账操作人名称',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT NULL COMMENT '资金科目ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `issue_bill_id`(`issue_bill_id` ASC) USING BTREE,
  INDEX `rebooking_id`(`rebooking_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3745 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签销售单对账表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_sale_daily_analysis
-- ----------------------------
DROP TABLE IF EXISTS `bill_sale_daily_analysis`;
CREATE TABLE `bill_sale_daily_analysis`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` int NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `ota_normal_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '正常单实收金额',
  `normal_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '正常单应收金额（正）',
  `ota_change_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签单实收金额',
  `change_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签单应收金额（正）',
  `ota_refund_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票单实退金额',
  `refund_order_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票单应退金额（负数）',
  `time_date` date NULL DEFAULT NULL COMMENT '日期，按天',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7133 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售账单每日统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_sale_daily_analysis_relation
-- ----------------------------
DROP TABLE IF EXISTS `bill_sale_daily_analysis_relation`;
CREATE TABLE `bill_sale_daily_analysis_relation`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `daily_analysis_id` int NULL DEFAULT NULL,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `order_id` int NULL DEFAULT NULL COMMENT '订单id',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型：1.出票，2.改签，3.退票\r\n',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '金额(应)',
  `ota_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '金额(实)',
  `order_created_at` datetime NULL DEFAULT NULL COMMENT '账单生成时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109913 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售账单日统计与销售账单中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_sale_import_logs
-- ----------------------------
DROP TABLE IF EXISTS `bill_sale_import_logs`;
CREATE TABLE `bill_sale_import_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `record_id` int NOT NULL DEFAULT 0 COMMENT '导入记录id',
  `platform` int NOT NULL DEFAULT 1 COMMENT '销售渠道',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型：1.出票，2.改签，3.退票',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1.未匹配，2.已对账，3.差异，4.坏账，5.已回款',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `issue_bill_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单号',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号,多个票号逗号分隔',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '总金额',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为差异订单：0:否，1.是',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为坏账订单：0:否，1.是',
  `operator` int NOT NULL DEFAULT -1 COMMENT '操作人：-1:系统，否者用户',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志信息\r\n日志信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59211 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入记录详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_sale_order
-- ----------------------------
DROP TABLE IF EXISTS `bill_sale_order`;
CREATE TABLE `bill_sale_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `issue_bill_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台出票订单单号',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间（出票时间）',
  `sale_platform` tinyint(1) NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '销售店铺',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单应收金额（录入销售含税底价）',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售底价',
  `ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `ota_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'ota平台订单实收金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `file_id` int NULL DEFAULT NULL COMMENT '附件文件id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `write_off_date` timestamp NULL DEFAULT NULL,
  `check_operator_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对账操作人名称',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT NULL COMMENT '资金科目ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `issue_bill_id`(`issue_bill_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 95600 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售单对账表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_statistical_purchase_profit
-- ----------------------------
DROP TABLE IF EXISTS `bill_statistical_purchase_profit`;
CREATE TABLE `bill_statistical_purchase_profit`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `office_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '销售渠道',
  `sale_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '售前利润',
  `changes_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签利润',
  `refund_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票利润',
  `total` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '合计利润',
  `day` datetime NULL DEFAULT NULL COMMENT '统计时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6957 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购渠道利润统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_statistical_purchase_profit_voyage
-- ----------------------------
DROP TABLE IF EXISTS `bill_statistical_purchase_profit_voyage`;
CREATE TABLE `bill_statistical_purchase_profit_voyage`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `b_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '开始机场三字码',
  `a_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '结束机场三字码',
  `port_str` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程中文名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9421 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '利润统计 航程中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_statistics
-- ----------------------------
DROP TABLE IF EXISTS `bill_statistics`;
CREATE TABLE `bill_statistics`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_platform` int NULL DEFAULT NULL COMMENT '销售渠道',
  `store_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `order_num` int NULL DEFAULT 0 COMMENT '订单数                     (正常单)',
  `tickets` int NULL DEFAULT 0 COMMENT '票数',
  `sequence` int NULL DEFAULT 0 COMMENT '航段数',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票面价总金额(销售)',
  `ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金总金额(销售)',
  `other_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用(销售)',
  `total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '订单应收金额(销售)',
  `ota_total_amount` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT 'ota平台订单实收金额(销售)',
  `ticket_price_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票面价总金额(采购)',
  `ticket_tax_price_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金总金额(采购)',
  `other_price_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用(采购)',
  `total_amount_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '订单应付金额(采购)',
  `ota_total_amount_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'ota平台订单实付金额(采购)',
  `sale_diff` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售差异金额',
  `purchase_diff` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购差异金额',
  `sale_bad` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售坏账',
  `purchase_bad` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购坏账',
  `estimated_profit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '预计利润',
  `actual_profit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实际利润',
  `order_num_change` int NULL DEFAULT 0 COMMENT '订单数              (改签单)',
  `tickets_change` int NULL DEFAULT 0 COMMENT '票数',
  `sequence_change` int NULL DEFAULT 0 COMMENT '航段数',
  `diff_amount_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票差异金额',
  `trouble_fee_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费',
  `service_fee_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `other_price_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用',
  `total_amount_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应收',
  `ota_total_amount_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实收',
  `diff_amount_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票差',
  `trouble_fee_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费',
  `service_fee_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `other_price_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费',
  `total_amount_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应付',
  `ota_total_amount_pu_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实付',
  `sale_diff_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售差异',
  `purchase_diff_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购差异',
  `sale_bad_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售坏账',
  `purchase_bad_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购坏账',
  `estimated_profit_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '预计利润',
  `actual_profit_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实际利润 ',
  `order_num_refund` int NULL DEFAULT 0 COMMENT '订单数                (退票)',
  `refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票费',
  `service_fee_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `other_price_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费',
  `total_amount_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应退',
  `ota_total_amount_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实退',
  `refund_fee_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票费',
  `service_fee_refund_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `other_price_refund_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费',
  `total_amount_refund_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应退',
  `ota_total_amount_refund_pu` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实退',
  `sale_diff_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售差异',
  `purchase_diff_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购差异',
  `sale_bad_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售坏账',
  `purchase_bad_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购坏账',
  `estimated_profit_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '预计利润',
  `actual_profit_refund` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实际利润',
  `day_time` date NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '盈亏统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_statistics_profit
-- ----------------------------
DROP TABLE IF EXISTS `bill_statistics_profit`;
CREATE TABLE `bill_statistics_profit`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `flight_way` int NOT NULL DEFAULT 1 COMMENT '1：单程 2：往返【暂时搁置】',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航线',
  `ticket_no_count` int NOT NULL DEFAULT 0 COMMENT '票号数量',
  `sale_gross_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '售前毛利',
  `sale_single_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '售前单张利润',
  `children_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '儿童利润',
  `refund_ticket_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '退票总利润',
  `refund_ticket_additional` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '退票加收',
  `delay_voyage_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '航延利润',
  `reschedule_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '改期利润',
  `refund_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '废票利润',
  `sum_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '总收益',
  `single_profit` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '单张票收益',
  `children_ticket_no_count` int NOT NULL DEFAULT 0 COMMENT '儿童票数量',
  `children_percentage` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '儿童票占比',
  `refund_ticket_count` int NOT NULL DEFAULT 0 COMMENT '退票总数量',
  `refund_ticket_probability` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票率',
  `voluntary_refund_count` int NOT NULL DEFAULT 0 COMMENT '自愿退票数量',
  `voluntary_refund_percentage` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '自愿退票占比',
  `involuntary_refund_count` int NOT NULL DEFAULT 0 COMMENT '非自愿退票数量',
  `involuntary_refund_percentage` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '非自愿退票占比',
  `delay_voyage_count` int NOT NULL DEFAULT 0 COMMENT '航延数量',
  `delay_voyage_conversion_rate` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '航延转化率',
  `delay_voyage_probability` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '航延率',
  `ticket_changes_count` int NOT NULL DEFAULT 0 COMMENT '改签数量',
  `ticket_changes_probability` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签率',
  `day` datetime NULL DEFAULT NULL COMMENT '统计时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 71920 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '各平台各航司合计利润' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_statistics_profit_log
-- ----------------------------
DROP TABLE IF EXISTS `bill_statistics_profit_log`;
CREATE TABLE `bill_statistics_profit_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `day` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '出票时间',
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `exits` tinyint NULL DEFAULT 0 COMMENT '是否第一次',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 87014 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bit_update_tax_record
-- ----------------------------
DROP TABLE IF EXISTS `bit_update_tax_record`;
CREATE TABLE `bit_update_tax_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `air_company` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `d_port` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场三字码',
  `a_port` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场三字码',
  `take_off_time` timestamp NULL DEFAULT NULL COMMENT '起飞时间',
  `state` tinyint(1) NULL DEFAULT 1 COMMENT '1待更新  2更新失败  更新成功直接删除',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '失败原因',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '更改税费记录信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_flightchange
-- ----------------------------
DROP TABLE IF EXISTS `cancel_flightchange`;
CREATE TABLE `cancel_flightchange`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0=停用,1=启用',
  `type` tinyint(1) NOT NULL COMMENT '类型:1=国内,2=国际',
  `airline_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航变id',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '取位航变规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_flightchange_rule
-- ----------------------------
DROP TABLE IF EXISTS `cancel_flightchange_rule`;
CREATE TABLE `cancel_flightchange_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `flightchange_id` int NULL DEFAULT NULL,
  `change_type` tinyint(1) NULL DEFAULT NULL COMMENT '航变类型:1:航班延误,2:航班取消,3:航班提前',
  `status_text` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '官网对应的航变文本',
  `minute` int NULL DEFAULT NULL COMMENT '航变分钟',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_gamble
-- ----------------------------
DROP TABLE IF EXISTS `cancel_gamble`;
CREATE TABLE `cancel_gamble`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态:0=停用,1=启用',
  `type` tinyint(1) NOT NULL COMMENT '类型:1=国内,2=国际',
  `airline_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `ticket_head` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '票头三字码',
  `not_used` tinyint(1) NOT NULL COMMENT '是否全程未使用',
  `pu_channel_code` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '采购渠道',
  `refund_idea_type` tinyint(1) NULL DEFAULT 1 COMMENT '是否自愿:0=全部,1=自愿,2=非自愿',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `cancel_seat_type` tinyint(1) NULL DEFAULT 2 COMMENT '取位模式:1=无需取位,2=时限取位',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '对赌规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_gamble_rule
-- ----------------------------
DROP TABLE IF EXISTS `cancel_gamble_rule`;
CREATE TABLE `cancel_gamble_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `gamble_id` int NOT NULL COMMENT '规则id',
  `match_type` tinyint(1) NOT NULL COMMENT '匹配类型:1=退票费率,2=预计亏损率',
  `refund_fee` decimal(5, 2) NOT NULL COMMENT '退票费率',
  `expected_los_rate` decimal(5, 2) NOT NULL COMMENT '预计亏损率',
  `cabin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `air_route` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航线',
  `flight_no` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号',
  `policy_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策代码',
  `dep_time_start` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '航班日期开始时间',
  `dep_time_end` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '航班日期结束时间',
  `take_off_time_start` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞开始时间',
  `take_off_time_end` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞结束时间',
  `dep_type` tinyint(1) NOT NULL COMMENT '起飞类型:1=起飞前,2=起飞后',
  `cancel_time_type` tinyint(1) NOT NULL COMMENT '取位时限类型1=天,2=时,3=分',
  `cancel_time_limit` decimal(4, 1) NOT NULL COMMENT '取位时限',
  `no_cancel_time_type` tinyint(1) NOT NULL COMMENT '无需取位时限类型1=天,2=时,3=分',
  `no_cancel_time_limit` decimal(4, 1) NULL DEFAULT NULL COMMENT '无需取位时限',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '对赌规则明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_scan
-- ----------------------------
DROP TABLE IF EXISTS `cancel_scan`;
CREATE TABLE `cancel_scan`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL COMMENT '状态:0=停用,1=启用',
  `type` tinyint(1) NOT NULL COMMENT '类型:1=国内,2=国际',
  `airline_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司',
  `cabin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `default_scan_day` tinyint(1) NOT NULL DEFAULT 1 COMMENT '默认扫描天数',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '取位航变扫描' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_scan_log
-- ----------------------------
DROP TABLE IF EXISTS `cancel_scan_log`;
CREATE TABLE `cancel_scan_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `scan_order_id` int NOT NULL COMMENT '扫描订单id',
  `flight_change_id` int NULL DEFAULT 0 COMMENT '航变id',
  `has_flightchange` tinyint(1) NULL DEFAULT 0 COMMENT '是否存在航变标准',
  `match_flightchange` tinyint(1) NULL DEFAULT 0 COMMENT '是否匹配航变标准',
  `scan_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '本次扫描时间',
  `next_time` timestamp NULL DEFAULT NULL COMMENT '下次扫描时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '扫描订单日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_scan_order
-- ----------------------------
DROP TABLE IF EXISTS `cancel_scan_order`;
CREATE TABLE `cancel_scan_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0=待处理,1=取位成功,2=取位失败,3=自动取位转对赌取位,4=取位中,5=退票单不是待自动取位,6=取位时间小于当前时间,7=重新匹配取位规则',
  `type` tinyint(1) NOT NULL COMMENT '类型:1=国内,2=国际',
  `order_source` tinyint(1) NOT NULL DEFAULT 1 COMMENT '订单来源:1=对赌取位,2=自动取位',
  `airline_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `pnr` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'PNR',
  `flight_no` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号',
  `dep` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发地',
  `arr` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达地',
  `dep_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞时间',
  `arr_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达时间',
  `sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售订单号',
  `refund_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '退票订单号',
  `next_scan_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下次扫描时间',
  `last_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最晚时限',
  `rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对赌/取位规则',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status_index`(`status` ASC) USING BTREE,
  INDEX `next_scan_time_index`(`next_scan_time` ASC) USING BTREE,
  INDEX `order_source_index`(`order_source` ASC) USING BTREE,
  INDEX `type_index`(`type` ASC) USING BTREE,
  INDEX `last_time_index`(`last_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '对赌/取位扫描订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_scan_rule
-- ----------------------------
DROP TABLE IF EXISTS `cancel_scan_rule`;
CREATE TABLE `cancel_scan_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `scan_id` int NOT NULL COMMENT '扫描id',
  `start_day` int NULL DEFAULT NULL COMMENT '开始天数',
  `end_day` int NULL DEFAULT NULL COMMENT '结束天数',
  `scan_type` tinyint(1) NULL DEFAULT NULL COMMENT '间隔类型:1=天,2=时,3=分',
  `scan_date` int NULL DEFAULT NULL COMMENT '间隔时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '取位航变扫描规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_seat
-- ----------------------------
DROP TABLE IF EXISTS `cancel_seat`;
CREATE TABLE `cancel_seat`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态:0=停用,1=启用',
  `type` tinyint(1) NOT NULL COMMENT '类型:1=国内,2=国际',
  `supplier_work_day` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '供应商工作日',
  `supplier_work_time_start` time NOT NULL COMMENT '供应商工作开始时间',
  `supplier_work_time_end` time NULL DEFAULT NULL COMMENT '供应商工作结束时间',
  `department_work_day` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '部门工作日',
  `department_work_time_start` time NULL DEFAULT NULL COMMENT '部门工作开始时间',
  `department_work_time_end` time NOT NULL COMMENT '部门工作结束时间',
  `cancel_seat_type` tinyint(1) NOT NULL COMMENT '取位模式:1=无需取位,2=时限取位',
  `pu_channel_code` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '采购渠道',
  `ticket_head` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '票号三字码',
  `airline_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `flight_type` tinyint(1) NOT NULL COMMENT '航程类型 1往返 2单程 3联程 4缺口程 5多程',
  `sale_channel` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售渠道',
  `ticket_date_start` date NOT NULL COMMENT '出票开始日期',
  `ticket_date_end` date NOT NULL COMMENT '出票结束日期',
  `travel_date_start` date NOT NULL COMMENT '旅行开始日期',
  `travel_date_end` date NOT NULL COMMENT '旅行结束日期',
  `dep` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '始发适用机场',
  `dep_exclude` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '始发排除机场',
  `arr` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达适用机场',
  `arr_exclude` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达排除机场',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `refund_idea_type` tinyint(1) NULL DEFAULT 1 COMMENT '是否自愿:0=全部,1=自愿,2=非自愿',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '取位规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_seat_order
-- ----------------------------
DROP TABLE IF EXISTS `cancel_seat_order`;
CREATE TABLE `cancel_seat_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:0=待处理,1=取位完成,2=等待航变飞后提交,3=取位失败',
  `airline` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '航司',
  `order_type` tinyint(1) NOT NULL DEFAULT 2 COMMENT '订单类型:1=国内,2=国际',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '销售订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '退票订单号',
  `refund_amount` decimal(10, 2) NOT NULL COMMENT '退票费',
  `noshow_amount` decimal(10, 2) NOT NULL COMMENT 'noshow费',
  `curr_prop` decimal(5, 2) NULL DEFAULT NULL COMMENT '当前盈亏比例',
  `noshow_prop` decimal(5, 2) NULL DEFAULT NULL COMMENT 'noshow盈亏比例',
  `noshow_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'noshow时间',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '取位订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cancel_seat_rule
-- ----------------------------
DROP TABLE IF EXISTS `cancel_seat_rule`;
CREATE TABLE `cancel_seat_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `seat_id` int NOT NULL COMMENT '规则id',
  `match_type` tinyint(1) NOT NULL COMMENT '匹配类型',
  `refund_fee` decimal(5, 2) NOT NULL COMMENT '退票费率',
  `refund_rate` decimal(5, 2) NOT NULL COMMENT '退票率',
  `cabin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `sale_diff_start` int NOT NULL COMMENT '销售差额开始',
  `sale_diff_end` int NOT NULL COMMENT '销售差额结束',
  `sale_refund_money_start` decimal(10, 2) NOT NULL COMMENT '应退金额开始',
  `sale_refund_money_end` decimal(10, 2) NOT NULL COMMENT '应退金额结束',
  `seat_type` tinyint(1) NOT NULL COMMENT '取位类型:1=直接取位,2=按时限取位',
  `dep_limit_type` tinyint(1) NOT NULL DEFAULT 2 COMMENT '起飞时限类型:1=天,2=时,3=分',
  `dep_limit_start` decimal(4, 1) NOT NULL DEFAULT 0.0 COMMENT '起飞时限开始',
  `dep_limit_end` decimal(4, 1) NOT NULL DEFAULT 0.0 COMMENT '起飞时限结束',
  `advance_type` tinyint(1) NOT NULL COMMENT '提前处理类型:1=天,2=时,3=分',
  `advance_data` decimal(4, 1) NOT NULL DEFAULT 0.0 COMMENT '提前处理时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '取位规则明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for card_opening_rules
-- ----------------------------
DROP TABLE IF EXISTS `card_opening_rules`;
CREATE TABLE `card_opening_rules`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `company_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '航司二字码 ',
  `max_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '开卡金额max',
  `min_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '开卡金额min ',
  `card_channel` tinyint(1) NULL DEFAULT 1 COMMENT '开卡渠道：1.易宝，2.空中云',
  `policy_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '政策ID（多个，逗号分割）',
  `status` tinyint(1) NULL DEFAULT -1 COMMENT '状态： -1未启用，1启用',
  `purchase_platform_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道代码',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `currency_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'USD' COMMENT '开卡币种',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cheap_downgrade
-- ----------------------------
DROP TABLE IF EXISTS `cheap_downgrade`;
CREATE TABLE `cheap_downgrade`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `pnr` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '编码',
  `is_valid` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否有效，1是，0否',
  `expired_at` datetime NOT NULL COMMENT '过期时间',
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '币种',
  `current_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '当前价格',
  `history_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '历史价格',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.降舱中，2.已出票，3.异常',
  `err_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误信息',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 483 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer_group
-- ----------------------------
DROP TABLE IF EXISTS `customer_group`;
CREATE TABLE `customer_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '集团名称',
  `airline_data` json NULL,
  `matching_data` json NULL,
  `airline_recode_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司舱位多个',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1正常  2禁用',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户集团' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer_policy
-- ----------------------------
DROP TABLE IF EXISTS `customer_policy`;
CREATE TABLE `customer_policy`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `office_code` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '归属Office号',
  `customer_code` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户代码',
  `before_command` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '前置指令',
  `notes_command` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '特殊指令',
  `after_command` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '后置指令',
  `customer_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大客戶名称',
  `airline_mode` tinyint(1) NULL DEFAULT NULL COMMENT '模式  1航司模式   2集团模式',
  `group_id` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '集团id',
  `airline_recode_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司多个',
  `sub_class` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位',
  `no_flight_range` json NULL COMMENT '不适用航班区间',
  `flight_start_date` int NULL DEFAULT NULL COMMENT '适用航班开始日期',
  `flight_end_date` int NULL DEFAULT NULL COMMENT '适用航班结束日期',
  `drawer_start_date` int NULL DEFAULT NULL COMMENT '适用出票开始日期',
  `drawer_end_date` int NULL DEFAULT NULL COMMENT '适用出票结束日期',
  `flight` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `flight_type` tinyint(1) NULL DEFAULT 2 COMMENT '适用航班  1适用  2不适用',
  `apply_d_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用航程(起飞机场)',
  `apply_a_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用航程(到达机场)',
  `no_apply_d_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '不适用航程(起飞机场)',
  `no_apply_a_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '不适用航程(到达机场)',
  `limit_ticket_age_start` int NULL DEFAULT 0 COMMENT '限制出票年龄',
  `limit_ticket_age_end` int NULL DEFAULT 120 COMMENT '限制出票年龄',
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '1国内  2国际',
  `is_transit` tinyint(1) NULL DEFAULT 2 COMMENT '是否用于中转 1是  2否',
  `transit_airport` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '中转机场/隔开',
  `ticke_total_money` decimal(12, 2) NULL DEFAULT NULL COMMENT '开票总额',
  `total_type` tinyint(1) NULL DEFAULT 1 COMMENT '1固定金额  2百分比',
  `maximum_overflow` decimal(10, 2) NULL DEFAULT NULL COMMENT '开票总额最大溢出：百分比/固定金额',
  `limit_ticke_total_money` decimal(12, 2) NULL DEFAULT NULL COMMENT '限制最大总额',
  `statistical_total_money` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '大客户已开票金额统计（开票时自动统计）',
  `third_party` tinyint(1) NULL DEFAULT 2 COMMENT '是否三方大客户  1是  2否',
  `third_party_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否三方大客户 （是：需要输入三方单位名称）',
  `whitelist` tinyint(1) NULL DEFAULT 2 COMMENT '是否未白名单大客户政策  1是  2否',
  `whitelist_rules` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '白名单匹配规则  1姓名+证件号匹配  2姓名匹配  3证件号匹配  ',
  `sales_volume` int NULL DEFAULT 0 COMMENT '销量',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1未启用  2进行中 3已完成 4已停用',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内大客户政策' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer_policy_log
-- ----------------------------
DROP TABLE IF EXISTS `customer_policy_log`;
CREATE TABLE `customer_policy_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL COMMENT '操作人',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `policy_id` int NULL DEFAULT NULL COMMENT '政策id',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '日志内容',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer_policy_matching
-- ----------------------------
DROP TABLE IF EXISTS `customer_policy_matching`;
CREATE TABLE `customer_policy_matching`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NULL DEFAULT NULL COMMENT '集团id',
  `airline` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司二字码',
  `customer_policy_id` int NULL DEFAULT NULL COMMENT '大客户政策id',
  `customer_id` int NULL DEFAULT NULL COMMENT '大客户文件id',
  `customer_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大客户代码',
  `third_party_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方名称',
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '订单类型:1=国内,2=国际',
  `sale_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `is_real_name` tinyint(1) NULL DEFAULT 0 COMMENT '是否实名',
  `passenger_name` char(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客名字',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客证件',
  `ticket_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '票价',
  `ticket_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2330 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '政策匹配数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer_policy_matching_record
-- ----------------------------
DROP TABLE IF EXISTS `customer_policy_matching_record`;
CREATE TABLE `customer_policy_matching_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `request_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求信息',
  `response_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '响应信息',
  `order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误响应信息',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6924 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户政策匹配记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer_policy_passenger
-- ----------------------------
DROP TABLE IF EXISTS `customer_policy_passenger`;
CREATE TABLE `customer_policy_passenger`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `policy_id` int NULL DEFAULT NULL,
  `passenger_name` char(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `birth_date` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52231 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内大客户政策白名单乘机人' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for customer_policy_ticket
-- ----------------------------
DROP TABLE IF EXISTS `customer_policy_ticket`;
CREATE TABLE `customer_policy_ticket`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_policy_id` int NOT NULL,
  `month` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '月份',
  `limit_count` int NULL DEFAULT 0 COMMENT '限制开票总数(非实名)',
  `limit_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '限制开票总金额(非实名)',
  `total_count` int NULL DEFAULT 0 COMMENT '已开票总数',
  `total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '已开票总金额',
  `real_name_count` int NULL DEFAULT 0 COMMENT '实名制已开票数',
  `real_name_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实名制已开票金额',
  `no_real_name_count` int NULL DEFAULT 0 COMMENT '非实名已开票数',
  `no_real_name_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '非实名已开票金额',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 839 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客户文件票量数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for deposit_aviation_record
-- ----------------------------
DROP TABLE IF EXISTS `deposit_aviation_record`;
CREATE TABLE `deposit_aviation_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '计划位ID',
  `airline_recode_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `three_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司订单号',
  `airline_serial_number` tinyint(1) NULL DEFAULT NULL COMMENT '分期付款的第几期数（表示这是第几期支付）',
  `status` tinyint NULL DEFAULT 1 COMMENT '1开启   2关闭',
  `end_time` datetime NULL DEFAULT NULL COMMENT '截至支付时间',
  `amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付金额',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1198 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '押金管理--面向航司' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for deposit_customer_record
-- ----------------------------
DROP TABLE IF EXISTS `deposit_customer_record`;
CREATE TABLE `deposit_customer_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位ID',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `group_number` int NOT NULL DEFAULT 0 COMMENT '团队人数',
  `ins_serial_number` tinyint(1) NULL DEFAULT NULL COMMENT '分期付款的第几期数（表示这是第几期支付）',
  `ins_pay_status` tinyint(1) NULL DEFAULT 1 COMMENT '1 未支付 2 已支付 ',
  `is_invalid` tinyint(1) NULL DEFAULT 2 COMMENT '1已作废 2未作废',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台业务单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台支付流水号',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
  `appoint_time` datetime NULL DEFAULT NULL COMMENT '规则约定支付时间',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '实际支付时间',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间  为null 表示未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '押金管理--面向分销商' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for difference_order
-- ----------------------------
DROP TABLE IF EXISTS `difference_order`;
CREATE TABLE `difference_order`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `business_type` tinyint NULL DEFAULT NULL COMMENT '业务类型 1销售端  2采购端',
  `created_time` datetime NULL DEFAULT NULL COMMENT '发生日期',
  `total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应收金额',
  `ota_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实收金额',
  `diff_amount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '差异金额',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售单号',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `order_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单类型  1正常单  2改签单  3退票单',
  `pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `operator` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人',
  `remark` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注信息',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `platform` int NULL DEFAULT NULL COMMENT '渠道',
  `platform_office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购需要platform与office_no拼接',
  `store_id` int NULL DEFAULT 0 COMMENT '销售端需要店铺id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 193 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '补差单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dingtalk_change_logs
-- ----------------------------
DROP TABLE IF EXISTS `dingtalk_change_logs`;
CREATE TABLE `dingtalk_change_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `table_id` int UNSIGNED NULL DEFAULT NULL COMMENT '表id',
  `table_type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '表类型：1 配置表，2 模板表',
  `type` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作类型：1 新增，2 修改，3 删除',
  `operator` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作人id',
  `data_before_update` json NULL COMMENT '更新前数据',
  `data_after_update` json NULL COMMENT '更新后数据',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '钉钉相关表修改日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dingtalk_robot_config
-- ----------------------------
DROP TABLE IF EXISTS `dingtalk_robot_config`;
CREATE TABLE `dingtalk_robot_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `robot_type` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'dingtalk' COMMENT '机器人类型:dingtalk=钉钉，weixincom=企业微信',
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '群名',
  `robot_key` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '机器人标识（唯一）',
  `robot_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '机器人名',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'token',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `唯一`(`robot_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dingtalk_robot_task
-- ----------------------------
DROP TABLE IF EXISTS `dingtalk_robot_task`;
CREATE TABLE `dingtalk_robot_task`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `config_id` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '群id',
  `template_id` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '模板ID',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `template_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '模板类型：text、link、markdown、actionCard、feedCard',
  `at_type` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '通知类型：0 不指明，1 isAtAll，2 atMobiles',
  `at_obj` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '通知对象',
  `task` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '任务内容',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0未开始，1已完成，2失败',
  `errmsg` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '失败，错误信息',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8634 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dingtalk_robot_template
-- ----------------------------
DROP TABLE IF EXISTS `dingtalk_robot_template`;
CREATE TABLE `dingtalk_robot_template`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:0禁用,1启用',
  `config_id` int NULL DEFAULT 0 COMMENT '机器人配置id',
  `template_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '模板标题',
  `template_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '模板名称,开发索引key',
  `template_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '模板类型：text、link、markdown、actionCard、feedCard',
  `at_type` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '通知类型：0 不指明，1 isAtAll，2 atMobiles',
  `at_obj` json NULL COMMENT '通知对象json: ',
  `content` json NULL COMMENT '模板内容json',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `template_name`(`template_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution
-- ----------------------------
DROP TABLE IF EXISTS `distribution`;
CREATE TABLE `distribution`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `level_id` int NULL DEFAULT NULL COMMENT '集团政策(分销商等级id)',
  `sms_template_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信模板ids( 逗号隔开)',
  `contacts_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销商名称',
  `contacts_tel` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人电话',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '登录名(分销编号)（账号）',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `frozen_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '冻结金额',
  `agreement` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对应协议',
  `bloc_id` int NULL DEFAULT 0 COMMENT '分销商所属集团id',
  `domestic_limit` int NULL DEFAULT NULL COMMENT '国内未支付乘客限制',
  `international_limit` int NULL DEFAULT NULL COMMENT '国际未支付乘客限制',
  `profit_center` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '利润中心(部门总id)',
  `profit_center_id` int NULL DEFAULT NULL COMMENT '利润中心(部门单个id)',
  `cash_customer` tinyint NULL DEFAULT NULL COMMENT '现金客户   1是  0否',
  `distribution_type` tinyint NULL DEFAULT NULL COMMENT '分销类型    1集团  2公司  3个人  ',
  `distribution_status` tinyint NULL DEFAULT 1 COMMENT '分销商状态  1正常  2冻结  -1注销   3禁止',
  `ascription_number` int NULL DEFAULT NULL COMMENT '归属工号(开户工号)',
  `landline` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '座机号码',
  `corporation_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '法人姓名',
  `corporation_tel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '法人电话',
  `business_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务负责人姓名',
  `business_tel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务负责人电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `qq` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'qq',
  `company_full_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '公司全称',
  `e_mail` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `sms_autograph` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信签名',
  `automatically_send_sms_permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1,2,3' COMMENT '自动发送短信权限：1 出票成功，2 改签成功，3 退废成功，英文逗号隔开',
  `last_ip` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最后登录ip',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `insurance` tinyint(1) NULL DEFAULT 2 COMMENT '保险是否默认勾选 1勾选  2不勾选',
  `auto_pay_of_manual_orders_for_casual_customers` tinyint(1) NULL DEFAULT 0 COMMENT '散客手工单自动支付：0 否，1 是',
  `auto_pay_for_manual_team_orders` tinyint(1) NULL DEFAULT 0 COMMENT '团队手工单自动支付：0 否，1 是',
  `auto_pay_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自动支付方式：1 余额，2 授信，多个使用英文逗号隔开',
  `salesperson` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售人',
  `business_license_picture` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '营业执照图片，多个以英文逗号隔开',
  `account_opening_date` datetime NULL DEFAULT NULL COMMENT '开户日期',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 452 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_all_order_records
-- ----------------------------
DROP TABLE IF EXISTS `distribution_all_order_records`;
CREATE TABLE `distribution_all_order_records`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `associated_order_number` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联订单号',
  `order_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '订单类型：1 正常单，2 改签单，3 退废单',
  `billing_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '下账状态：1 未下账，2 已下账',
  `pnr` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'PNR编码',
  `ticket_nos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '票号集合，多个以英文逗号隔开',
  `passenger_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '乘客姓名集合，多个以英文逗号隔开',
  `age_types` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '乘客年龄类型集合，多个以英文逗号隔开',
  `flight_type` tinyint(1) NULL DEFAULT 0 COMMENT '航程类型：1 往返，2 单程，3 联程，4 缺口程，5 多程',
  `voyage_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '航程名称集合，多个以英文逗号隔开',
  `voyage_names_cn` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '航程名称中文集合，多个以英文逗号隔开',
  `airline_recode_nos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '航司名称集合，多个以英文逗号隔开',
  `flights` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '航班号集合，多个以英文逗号隔开',
  `sub_class` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '子舱位集合，多个以英文逗号隔开',
  `sub_class_str` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '子舱位字符串集合，多个以英文逗号隔开',
  `take_off_times` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '起飞时间集合，多个以英文逗号隔开',
  `total_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总票面价',
  `total_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总机建费',
  `total_fuel_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总燃油费',
  `total_insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总保险金额',
  `total_insurance_num` int NULL DEFAULT 0 COMMENT '总购买保险份数',
  `total_service_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总服务费',
  `total_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总奖励',
  `amount_receivable` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应收金额',
  `amount_received` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实收金额（下账金额）',
  `arrears_are_overdue` tinyint(1) NULL DEFAULT 0 COMMENT '欠款逾期：1 未逾期，2 逾期',
  `arrears_time` datetime NULL DEFAULT NULL COMMENT '逾期时间',
  `total_refund_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总退票服务费',
  `total_change_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总改签服务费',
  `total_flight_missing_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总误机费',
  `total_change_flight_missing_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总改签误机费',
  `total_amount_should_refunded` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总应退金额',
  `total_actual_refund_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总实退金额',
  `total_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总其他费用',
  `ticketing_staff_id` int NOT NULL DEFAULT 0 COMMENT '出票人员id',
  `ticketing_staff_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票人员名称',
  `pay_method` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付方式：deposit 预付款支付，lines 授信额度支付，icbc 工行支付，deduction 抵扣，remittance 线下汇款，rcu 浙江农信',
  `subject_id` int NOT NULL DEFAULT 0 COMMENT '资金科目id',
  `dis_id` int NOT NULL DEFAULT 0 COMMENT '分销商id',
  `volunteer` tinyint(1) NULL DEFAULT 0 COMMENT '自愿：1 是，2 否',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `refund_initial_review_time` datetime NULL DEFAULT NULL COMMENT '退废初审时间',
  `refund_application_time` datetime NULL DEFAULT NULL COMMENT '退废申请时间',
  `refund_actual_refund_time` datetime NULL DEFAULT NULL COMMENT '退废实退时间',
  `billing_time` datetime NULL DEFAULT NULL COMMENT '下账时间',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `group_ids` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客分组集合',
  `d_ports` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场集合',
  `card_nos` varchar(1800) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号集合',
  `a_ports` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场集合',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `dis_id`(`dis_id` ASC) USING BTREE,
  INDEX `print_ticket_time`(`print_ticket_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59593 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '所有订单记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_difference
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_difference`;
CREATE TABLE `distribution_bill_difference`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `bill_id` int NULL DEFAULT NULL COMMENT '对账id',
  `bill_type` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '1 销售流水对账 2 销售改签单对账  3 销售退票对账 4 分销商充值补差',
  `diff_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '差异金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `operator_id` int UNSIGNED NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 92 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销补差单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_finance_change
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_finance_change`;
CREATE TABLE `distribution_bill_finance_change`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `apply_time` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签订单号',
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售订单号',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '毛利',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后票号',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后仓位',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后航程',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '改签后起飞时间',
  `old_ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签前票号',
  `old_flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签前航班',
  `old_freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签前仓位',
  `old_voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签前航程',
  `old_take_off_time` datetime NULL DEFAULT NULL COMMENT '改签前起飞时间',
  `dis_id` int NOT NULL DEFAULT 0 COMMENT '销售分销商',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售订单实收金额',
  `sale_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `change_fees` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售改签费',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `purchase_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单应付金额',
  `purchase_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `purchase_change_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费',
  `purchase_total_paid_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '订单实付金额',
  `purchase_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实收差异金额',
  `purchase_total_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '应收差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `purchase_bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `purchase_bill_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下账人',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `complete_time` datetime NULL DEFAULT NULL COMMENT '改签完成时间',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1029 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_finance_normal
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_finance_normal`;
CREATE TABLE `distribution_bill_finance_normal`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '起飞时间',
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售订单号',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'pnr',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `extra_ticke_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `policy_code` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '政策代码',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '仓位',
  `arrival_time` datetime NULL DEFAULT NULL COMMENT '抵达时间',
  `dis_id` int NOT NULL DEFAULT 0 COMMENT '销售分销商',
  `sale_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收票面价',
  `sale_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收税金',
  `sale_insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收保险金额',
  `sale_insurance_num` int NULL DEFAULT 0 COMMENT '销售购买保险份数',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收总金额',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `purchase_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购订单应付金额',
  `purchase_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购票面价金额',
  `purchase_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购税金总金额',
  `purchase_insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购保险总金额',
  `purchase_insurance_num` int NULL DEFAULT 0 COMMENT '采购购买保险份数',
  `purchase_total_paid_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购订单实付金额',
  `purchase_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实收差异金额',
  `purchase_total_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应收差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '毛利',
  `purchase_bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `pubrchase_bill_sale_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下账人',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `after_rebate_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '后返金额',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 125872 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_finance_refund
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_finance_refund`;
CREATE TABLE `distribution_bill_finance_refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ota_rt_time` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `recheck_audit_time` datetime NULL DEFAULT NULL COMMENT '二审时间',
  `confirm_time` datetime NULL DEFAULT NULL COMMENT '一审时间',
  `refund_idea_type` tinyint(1) NULL DEFAULT NULL COMMENT '自愿退废  1 是  2 否',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台销售单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `pnr` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `policy_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '政策代码',
  `ticket_no` varchar(59) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '仓位',
  `gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实退利润',
  `total_gross_profit` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总毛利',
  `dis_id` int NOT NULL DEFAULT 0 COMMENT '销售分销商',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应退金额',
  `sale_refund_fee` decimal(10, 0) NOT NULL DEFAULT 0 COMMENT '退票费',
  `sale_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `sale_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `purchase_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票面价总金额',
  `purchase_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税金总金额',
  `airline_refund_money` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '航司应退金额',
  `purchase_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单应退金额',
  `purchase_total_return_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单实退金额',
  `purchase_refund_fee` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `purchase_total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应收差异金额',
  `purchase_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账',
  `purchase_is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `purchase_bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `purchase_bill_sale_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下账人',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  `submitted_time` datetime NULL DEFAULT NULL COMMENT '提交时间',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'office_no号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9983 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_import_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_import_log`;
CREATE TABLE `distribution_bill_import_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `check_file_id` int NULL DEFAULT NULL COMMENT '导入文件',
  `platform` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对账渠道：icbc（工商银行）、boc（中国银行）、ccb（建设银行）、BSP、BOP、OP、MANUAL（手工）',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `pay_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '流水号',
  `ticket_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `bill_type` tinyint(1) NULL DEFAULT NULL COMMENT '对账单类型：1.出票，2.改签，3.退票',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '状态：1.待对账，2.已对账 3.差异',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `operator_id` int UNSIGNED NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 77844 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销导入记录详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_import_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_import_record`;
CREATE TABLE `distribution_bill_import_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1.销售账单，2.采购账单',
  `platform` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对账渠道 icbc(工商银行)',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件地址',
  `operator_id` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 397 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销对账导入记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_purchase_adjustment
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_purchase_adjustment`;
CREATE TABLE `distribution_bill_purchase_adjustment`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `bill_id` int UNSIGNED NULL DEFAULT NULL COMMENT '对账id',
  `bill_type` tinyint(1) NULL DEFAULT NULL COMMENT '对账单类型：1 采购正常单对账，2 采购改签单对账，3 采购退票单对账',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调账金额',
  `dis_id` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '分销商id',
  `purchase_channel` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道_office号',
  `remark` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '调整备注',
  `operate_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '操作类型：1. 补差，2.调账',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销采购对账调账/补差表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_purchase_change_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_purchase_change_order`;
CREATE TABLE `distribution_bill_purchase_change_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `purchase_order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签单采购单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销端销售单号',
  `change_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销端改签单号',
  `order_type` tinyint NULL DEFAULT 0 COMMENT '订单类型：1 计划位团，2 临时团，3 散客订单',
  `dis_id` int(10) UNSIGNED ZEROFILL NOT NULL DEFAULT 0000000000 COMMENT '分销商id',
  `purchase_platform` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `old_ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧票号',
  `ticket_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '票面价',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其它费用',
  `supplementary_discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '补收优惠金额',
  `service_fee` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `change_fee` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '改签费',
  `amount_payable` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '应付金额',
  `amount_actually_paid` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1 待对账，2 已对账, 3 已销账',
  `is_diff_bill` tinyint NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `bill_operator_id` int NULL DEFAULT NULL COMMENT '对账操作人id',
  `bill_operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对账操作人名称',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `agent_rate` float(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '代理费率',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间（改签完成时间）',
  `office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航线',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '对账销售端改签总金额',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1045 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销采购改签单对账' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_purchase_daily_analysis
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_purchase_daily_analysis`;
CREATE TABLE `distribution_bill_purchase_daily_analysis`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform_office_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道_office号格式：BOP_WNZ201',
  `normal_order_amount_payable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '正常单应付金额',
  `normal_order_amount_actually_paid` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '正常单实付金额',
  `change_order_amount_payable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签单应付金额',
  `change_order_amount_actually_paid` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签单实付金额',
  `refund_order_amount_refunded` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票单应退金额',
  `refund_order_actual_refund_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票单实退金额',
  `time_date` date NULL DEFAULT NULL COMMENT '日期，按天',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 354 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销采购账单每日统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_purchase_daily_analysis_relation
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_purchase_daily_analysis_relation`;
CREATE TABLE `distribution_bill_purchase_daily_analysis_relation`  (
  `daily_analysis_id` int NULL DEFAULT NULL,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `bill_id` int NULL DEFAULT NULL COMMENT '对账单id',
  `bill_type` tinyint(1) NULL DEFAULT NULL COMMENT '对账单类型：1 采购正常单对账，2 采购改签单对账，3 采购退票单对账',
  `target_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '目标金额（应收或应退）',
  `actual_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实际金额（实收或实退）',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销采购账单每日统计与采购账单中间表\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_purchase_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_purchase_log`;
CREATE TABLE `distribution_bill_purchase_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户能查看的日志内容',
  `develop_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '开发人员查看的日志内容',
  `bill_type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '对账单类型：1 采购正常单对账，2 采购改签单对账，3 采购退票单对账',
  `bill_id` int UNSIGNED NULL DEFAULT NULL COMMENT '对账id',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `operate_type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '操作类型：1.对账，2.差异对账，3.补差，4.调账',
  `operator_id` int UNSIGNED NULL DEFAULT NULL COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25096 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_purchase_order`;
CREATE TABLE `distribution_bill_purchase_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `purchase_order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常单采购单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销端销售单号',
  `order_type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '订单类型：1 计划位团，2 临时团，3 散客订单',
  `dis_id` int UNSIGNED NULL DEFAULT NULL COMMENT '分销商id',
  `purchase_platform` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `extra_ticke_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所有票号',
  `ticket_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '票面价',
  `ticket_tax_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '税金',
  `insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保险金额',
  `insurance_num` int NULL DEFAULT 0 COMMENT '购买保险份数',
  `amount_payable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应付金额',
  `amount_actually_paid` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1 待对账，2 已对账, 3 已销账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `bill_operator_id` int UNSIGNED NULL DEFAULT NULL COMMENT '对账操作人id',
  `bill_operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对账操作人名称',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间（出票时间）',
  `office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `company_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航线',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '对账销售端应收总金额',
  `age_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127384 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销采购正常单对账' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_purchase_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_purchase_refund_order`;
CREATE TABLE `distribution_bill_purchase_refund_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `purchase_order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票单采购单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销端销售单号',
  `change_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销端改签单号',
  `refund_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销端退票单号',
  `order_type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '订单类型：1 计划位团，2 临时团，3 散客订单',
  `dis_id` int NULL DEFAULT NULL COMMENT '销售分销商id',
  `purchase_platform` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `ticket_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '票面价',
  `ticket_tax_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '税金',
  `refund_fee` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '退票费用',
  `service_fee` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `agency_fee` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '代理费',
  `other_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '其它费用',
  `refund_service_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票服务费',
  `amount_refunded` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '订单应退金额',
  `actual_refund_amount` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '订单实退金额',
  `diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1 待对账，2 已对账, 3 已销账',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `order_created_date` datetime NULL DEFAULT NULL COMMENT '账单生成时间',
  `bill_operator_id` int UNSIGNED NULL DEFAULT NULL COMMENT '对账操作人id',
  `bill_operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对账操作人名称',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航线',
  `source_type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '退废来源  1 销售单退废 2改签单退废',
  `refund_type` tinyint NOT NULL DEFAULT 0 COMMENT '退废类型 1退票 2废票',
  `refund_idea_type` tinyint NULL DEFAULT 0 COMMENT '销售端 - 自愿退废  1 是  2 否',
  `aviation_refund_idea_type` tinyint NULL DEFAULT 0 COMMENT '采购端 - 自愿退废  1 是  2 否',
  `sale_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '对账销售端应退金额',
  `aviation_purchase_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '对账采购端航司应退金额',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注',
  `other_remark_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其他订单备注人',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备时间',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10241 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销采购退票单对账' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_sale
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_sale`;
CREATE TABLE `distribution_bill_sale`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型：1 分销商充值，2 短信余量充值，3 分销商授信销账，4 保险支付，5 分期延时费，6 正常，7 改签，8 退票，9 退款',
  `business_type` tinyint UNSIGNED NOT NULL DEFAULT 4 COMMENT '业务类型：1 计划位订单，2 团队订单，3 散客订单，4 其他',
  `pay_order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付流水号(第三方流水号)',
  `pay_type` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'deposit预付款支付 lines授信额度支付  icbc工行支付',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `bill_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应收金额',
  `real_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实收金额',
  `diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账 3.已销帐',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是（无用）',
  `check_file_id` int NULL DEFAULT NULL COMMENT '对账文件id(导入文件)',
  `differences_file_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '差异文件id（差异上传图片id）',
  `import_file_bill_id` int NULL DEFAULT NULL COMMENT '对账后关联导入流水明细id',
  `last_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间(暂时不用)',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号(暂时不用)',
  `write_off_date` timestamp NULL DEFAULT NULL COMMENT '对账时间',
  `check_operatpr_id` int NULL DEFAULT 0 COMMENT '对账操作人id',
  `check_operator_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '对账操作人名称',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5488 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售单对账表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bill_sale_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bill_sale_log`;
CREATE TABLE `distribution_bill_sale_log`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户能查看的日志内容',
  `develop_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '开发人员查看的日志内容',
  `bill_type` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '1 销售流水对账 2销售改签单对账  3 销售退票对账',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型：1 分销商充值，2 短信余量充值，3 分销商授信销账，4 保险支付，5 分期延时费，6 正常，7 改签，8 退票，9 退款',
  `pay_type` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'deposit预付款支付 lines授信额度支付  icbc工行支付',
  `bill_id` int NULL DEFAULT NULL COMMENT '对账id',
  `operator_id` int NULL DEFAULT -1 COMMENT '操作人：-1:系统，否则booking用户id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_bloc
-- ----------------------------
DROP TABLE IF EXISTS `distribution_bloc`;
CREATE TABLE `distribution_bloc`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '绑定分销商id(分销商主账号)',
  `bloc_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '集团名称',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '1显示  2不显示',
  `customer` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '指定客服',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '集团' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_change_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_change_order`;
CREATE TABLE `distribution_change_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签订单号',
  `sale_order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '上级改签单号 如果为销售单时为销售单号  改签单时则为上级改签单号',
  `original_sales_order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原销售单号',
  `initial_order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '初始正常单销售单号',
  `external_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付单号',
  `business_type` tinyint(1) NULL DEFAULT NULL COMMENT '1、计划位订单 2、团队位订单 3、散客订单',
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '1国内订单  2国际订单',
  `source_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '来源：1.销售单，2.改签单',
  `flight_way` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '1往返 2单程 3联程',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '改签单扭转状态：1.待改签，2.改签中，3.改签成功，4.改签失败,5.改签驳回，6.取消改签',
  `audit_status` tinyint(1) NULL DEFAULT 1 COMMENT '审核状态：1.待审核，2.审核通过，3.审核拒绝，',
  `reason_type` tinyint(1) NULL DEFAULT NULL COMMENT '改签原因：1.普通自愿改签，2.非自愿',
  `change_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '改签类型：1.改期，2.升仓，3.更改航程',
  `ticket_company` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票航司',
  `money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付总金额',
  `supplementary_discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '补收优惠金额',
  `pid` int NULL DEFAULT NULL COMMENT '改签单改期时，所属改签单id',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签原因',
  `a_pid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所有的父级id，逗号分隔',
  `file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件路径（非自愿）',
  `operation_id` int NULL DEFAULT NULL COMMENT '申请人id',
  `operation_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请人姓名',
  `operation_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 分销商  2员工',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `contact_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人姓名',
  `contact_mobile_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人手机号',
  `contact_email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人邮箱',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `audit_uid` int NULL DEFAULT NULL COMMENT '审核人',
  `audit_uname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核人名称',
  `audit_time` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `rejected_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `aerial_change` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1:发生航变标记  0:未发生标记',
  `pay_type` tinyint(1) NULL DEFAULT 1 COMMENT '1未支付  2已支付  3已过期',
  `expect_time` timestamp NULL DEFAULT NULL COMMENT '预定支付时间',
  `ticket_agent_id` int NULL DEFAULT 0 COMMENT '出票人id',
  `ticket_agent_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票人名称',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `ext` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '附加数据',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `change_order_no`(`change_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 840 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_change_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `distribution_change_order_relation`;
CREATE TABLE `distribution_change_order_relation`  (
  `relation_id` int NOT NULL AUTO_INCREMENT,
  `passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签订单号',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常销售单业务订单号',
  `change_status` tinyint(1) NULL DEFAULT 1 COMMENT '改签状态  1未改签 2改签中  3.已改签',
  `refund_status` tinyint(1) NULL DEFAULT 1 COMMENT '退票状态  1未退票  2退票中  3已退票',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2552 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_change_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `distribution_change_passenger_info`;
CREATE TABLE `distribution_change_passenger_info`  (
  `passenger_id` int NOT NULL AUTO_INCREMENT,
  `sole_coding` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一编码',
  `original_passenger_id` int NULL DEFAULT NULL COMMENT '出行人原表id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常销售单业务订单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签订单号',
  `ticket_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `old_ticket_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '老票号',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '售卖价(不含改签服务费、改签费)',
  `old_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '老票面价',
  `price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '舱位差价',
  `change_fees` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费',
  `change_service_fees` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签服务费',
  `tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向用户机建费',
  `fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向用户机燃油费',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用',
  `supplementary_discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '补收优惠金额',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份类型',
  `age_type` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票单号和 主体出票单主体单号一致',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `mobile` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `is_adult_ticket_for_child` tinyint(1) NULL DEFAULT NULL COMMENT '儿童订成人票标识  1 是 2否',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `change_status` tinyint(1) NULL DEFAULT 1 COMMENT '改签状态  1未改签 2改签中  3.已改签',
  `refund_status` tinyint(1) NULL DEFAULT 1 COMMENT '退票状态  1未退票  2退票中  3已退票',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`passenger_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1179 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_change_sequence
-- ----------------------------
DROP TABLE IF EXISTS `distribution_change_sequence`;
CREATE TABLE `distribution_change_sequence`  (
  `sequence_id` int NOT NULL AUTO_INCREMENT,
  `sole_coding` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一编码',
  `old_sequence_id` int NULL DEFAULT NULL COMMENT '原航程id  （老航程有原id  新航程不需要）',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1.新航程，2.旧航程',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '正常销售单业务订单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签订单号',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `a_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场航站楼',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市名称',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `a_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场名称',
  `d_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市名称',
  `d_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `d_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场名称',
  `d_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场航站楼',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用',
  `price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人舱位差价',
  `children_price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童舱位差价',
  `baby_price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿舱位差价',
  `tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人机建费',
  `fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人燃油费',
  `change_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人改签费',
  `children_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童机建费',
  `children_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费',
  `children_change_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童改签费',
  `baby_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿机建费',
  `baby_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿燃油费',
  `baby_change_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿改签费',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签服务费',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `take_off_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达时间',
  `main_sequence` int NULL DEFAULT 0 COMMENT '主航段',
  `sequence` int NULL DEFAULT 0 COMMENT '航段',
  `sub_class` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `adult_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人票面价',
  `children_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童票面价',
  `baby_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿票面价',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`sequence_id`) USING BTREE,
  INDEX `order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1844 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单航段信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_create_coding_config
-- ----------------------------
DROP TABLE IF EXISTS `distribution_create_coding_config`;
CREATE TABLE `distribution_create_coding_config`  (
  `id` int NOT NULL,
  `order_type` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'domestic国内  international国际',
  `create_coding_status` tinyint(1) NULL DEFAULT 2 COMMENT '1支付前生编    2支付后生编',
  `create_coding_type` tinyint(1) NULL DEFAULT NULL COMMENT '生编方式',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '生编配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_create_coding_type
-- ----------------------------
DROP TABLE IF EXISTS `distribution_create_coding_type`;
CREATE TABLE `distribution_create_coding_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `coding_identification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标识',
  `identification_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标识名称',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '生编方式类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_deduction_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_deduction_record`;
CREATE TABLE `distribution_deduction_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `deduction_id` int NULL DEFAULT NULL COMMENT '对应抵扣业务id',
  `deduction_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 分期订单（distribution_order_ins_record）  2、额外付款订单（distribution_order_extra_record）\r\n3、钱包  4.全额支付（distribution_order）',
  `operation_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 增加  2 减少  订单抵扣金余额增加还是减少',
  `order_no` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1处理中  2成功  3失败',
  `is_rollback` tinyint(1) NULL DEFAULT 1 COMMENT '是否回滚 1否  2已回滚',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商订单抵扣金流向记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_direct
-- ----------------------------
DROP TABLE IF EXISTS `distribution_direct`;
CREATE TABLE `distribution_direct`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `policy_type` tinyint(1) NULL DEFAULT 1 COMMENT '政策类型:1=直加政策,2=大客户政策',
  `shipping_price_channels` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '运价渠道：1 IBE+，2 航班管家，3 易旅行，多个使用英文逗号隔开',
  `platforms_ids` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '10' COMMENT '销售平台id，多个英文逗号隔开',
  `channels_for_generating_codes` tinyint(1) NOT NULL DEFAULT 1 COMMENT '生编渠道：1 IBE+，2 eterm, 3 假编',
  `product_types` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '产品类型：1 标品，2 非标品，3 旗舰店，多个以英文逗号隔开',
  `office_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'eterm生编配置',
  `min_age` tinyint(1) NOT NULL DEFAULT 0 COMMENT '最小年龄',
  `max_age` tinyint(1) NOT NULL DEFAULT 100 COMMENT '最大年龄',
  `age_types` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旅客年龄类型：ADU 成人，CHD 儿童，多个使用英文逗号隔开',
  `voyage_type` tinyint(1) NULL DEFAULT 1 COMMENT '航段类型：1 单航段，2 多航段，3 单航段+多航段',
  `policy_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策名称',
  `airline_recode_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `airlines` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '同时适用航司',
  `take_off_time` timestamp NULL DEFAULT NULL COMMENT '起飞开始时间',
  `arrival_time` timestamp NULL DEFAULT NULL COMMENT '起飞结束时间',
  `cabin_code` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用舱位',
  `flight` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '航班号',
  `flight_type` tinyint(1) NULL DEFAULT NULL COMMENT '适用航班  1适用 2 不适用',
  `apply_d_port` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '适用航程 起飞机场',
  `apply_a_port` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '适用航程 到达机场',
  `no_apply_d_port` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '不适用航程 起飞机场',
  `no_apply_a_port` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '不适用航程 到达机场',
  `sales_range_add` timestamp NULL DEFAULT NULL COMMENT '销售开始时间',
  `sales_range_end` timestamp NULL DEFAULT NULL COMMENT '销售结束时间',
  `advance_time` int NULL DEFAULT NULL COMMENT '提前时间(小时)',
  `issue_ticket_type` tinyint(1) NULL DEFAULT NULL COMMENT '是否自动出票  1是  2否',
  `issue_ticket_platform` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票渠道',
  `foreign_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对外说明',
  `internal_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对内说明',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签',
  `status` tinyint(1) NULL DEFAULT 2 COMMENT '审核  1审核  2不审核  3作废 4停用',
  `whether_to_import_from_a_table` tinyint(1) NULL DEFAULT 0 COMMENT '是否从表格导入：0 否，1 是',
  `farebasis` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运价代码',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `customer_policy_id` int NULL DEFAULT 0 COMMENT '大客户文件id',
  `highest_rebate` decimal(3, 1) NULL DEFAULT 0.0 COMMENT '最高返点',
  `no_flight_range` json NULL COMMENT '不适用日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 311 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '直加政策' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_direct_child
-- ----------------------------
DROP TABLE IF EXISTS `distribution_direct_child`;
CREATE TABLE `distribution_direct_child`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `direct_id` int NULL DEFAULT NULL COMMENT '政策id',
  `associated_id` int NULL DEFAULT NULL COMMENT '关联id(level:等级id、specific:特定分销商id、other_sales_platforms:其他销售平台id)',
  `proportion` int NULL DEFAULT NULL COMMENT '加减比例',
  `pot_symbol` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加减类型 +   -',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '加减金额',
  `mon_symbl` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加减金额类型  +  -',
  `type` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'level:等级  specific:特定分销商 other_sales_platforms:其他销售平台',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `direct_id`(`direct_id` ASC) USING BTREE,
  INDEX `associated_id`(`associated_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8070 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '直加政策加价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_direct_increase_refund_and_change_percentage
-- ----------------------------
DROP TABLE IF EXISTS `distribution_direct_increase_refund_and_change_percentage`;
CREATE TABLE `distribution_direct_increase_refund_and_change_percentage`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `distribution_direct_id` int NOT NULL DEFAULT 0 COMMENT '政策id',
  `sub_class` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `additional_percentage` tinyint NOT NULL COMMENT '客规退票和改签比例基础上追加的比例',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `distribution_policy_id`(`distribution_direct_id` ASC) USING BTREE,
  INDEX `sub_class`(`sub_class` ASC) USING BTREE,
  INDEX `distribution_policy_id&sub_class`(`distribution_direct_id` ASC, `sub_class` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3466 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '直加政策增加客规退改百分比' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_direct_logs
-- ----------------------------
DROP TABLE IF EXISTS `distribution_direct_logs`;
CREATE TABLE `distribution_direct_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `distribution_direct_id` int NOT NULL DEFAULT 0 COMMENT '直加政策id',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '操作类型：1 新增，2 修改，3 删除',
  `operator_id` int NOT NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `data_before_update` json NULL COMMENT '更新前数据',
  `data_after_update` json NULL COMMENT '更新后数据',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rule_id`(`distribution_direct_id` ASC) USING BTREE,
  INDEX `operator_id`(`operator_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 123 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '压位规则更变日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_direct_rebates
-- ----------------------------
DROP TABLE IF EXISTS `distribution_direct_rebates`;
CREATE TABLE `distribution_direct_rebates`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `direct_id` int NULL DEFAULT NULL COMMENT '直加政策id',
  `number` int NULL DEFAULT NULL COMMENT '排序',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '加价金额',
  `rebates` decimal(10, 2) NULL DEFAULT NULL COMMENT '返现金额',
  `matching_face_value_of_ticket` tinyint(1) NULL DEFAULT 0 COMMENT '与票面价相符：0 否，1 是',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `direct_id`(`direct_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 878 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '直加政策加价返额' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_freeze_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_freeze_record`;
CREATE TABLE `distribution_freeze_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销平台支付流水号',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '1、计划位订单 2、团队位订单 3、散客订单',
  `freeze_type` tinyint(1) NULL DEFAULT NULL COMMENT '1.押金   2.延期  3.尾款',
  `freeze_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '冻结金额',
  `freeze_status` tinyint(1) NULL DEFAULT 1 COMMENT '1冻结中  2已解冻',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 154 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '冻结记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_insurance_audit_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_insurance_audit_record`;
CREATE TABLE `distribution_insurance_audit_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `insurance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保险订单id （多个逗号隔开）',
  `booking_insurance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'booking保险订id（多个逗号隔开）',
  `insurance_order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保险订单号',
  `credentials_img` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '凭证(多张逗号隔开)',
  `rejected_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `rejected_at` timestamp NULL DEFAULT NULL COMMENT '驳回时间',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作人id',
  `operator_name` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `is_audit` tinyint NULL DEFAULT 1 COMMENT '1待审核   2审核成功 3驳回',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险订单撤保申请记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_insurance_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_insurance_order`;
CREATE TABLE `distribution_insurance_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_insurance_id` int NULL DEFAULT NULL COMMENT 'booking保险订单id',
  `insurance_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保险订单号',
  `insurance_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保险公共订单号',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务订单号',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '1、计划位订单 2、团队位订单 3、散客订单 4其他',
  `order_area` tinyint(1) NULL DEFAULT 1 COMMENT '1国内订单  2国际订单',
  `insurances_id` int NULL DEFAULT NULL COMMENT '险种ID',
  `quantity` int NULL DEFAULT NULL COMMENT '投保份数',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '险种名称',
  `cost` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成本(保费)',
  `denomination` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面额',
  `full_premium` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '全额保费（折前销售价）',
  `permiun` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保费(销售价)',
  `insured_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保额(单位：万元)',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '产品代码',
  `plan_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '计划代码（旅游险）',
  `is_tinerary` tinyint(1) NULL DEFAULT 0 COMMENT '是否行程单：0否，1是',
  `supplier_id` int NULL DEFAULT 0 COMMENT '供应商ID',
  `flight_no` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号',
  `flight_date` datetime NULL DEFAULT NULL COMMENT '航班起飞日期时间',
  `d_port` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发地',
  `a_port` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达地',
  `start_at` datetime NULL DEFAULT NULL COMMENT '保单开始日期时间(起飞日期)',
  `end_at` datetime NULL DEFAULT NULL COMMENT '保单结束日期时间',
  `to_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旅行目的国家',
  `sole_coding` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人唯一编码',
  `seq_sole_coding` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航段唯一标识',
  `applicant_name` char(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '投保人名称',
  `applicant_card_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 => \"身份证\",2 => \"护照\",3 => \"军官证\",4 => \"港澳台回乡证\",5 => \"港澳台身份证\",9 => \"其他\",100 => \"统一社会信用代码\",101 => \"税务登记证\",102 => \"组织机构代码证\",',
  `applicant_card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `applicant_sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '投保人性别： M:  男     F:  女',
  `applicant_birthday` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '投保人生日日期',
  `applicant_mobile` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '投保人手机号',
  `pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态：1 成功，2 失败，3 已撤保，4 已取消，5 待投保，6 撤保中',
  `insurance_discount_rate` tinyint NULL DEFAULT 100 COMMENT '保险折扣率',
  `insurance_discount_json` json NULL COMMENT '保险折扣率规则',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10053 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_insurance_order_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_insurance_order_record`;
CREATE TABLE `distribution_insurance_order_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `insurance_type` tinyint NULL DEFAULT NULL COMMENT '1.分销下单   2.pnr导入单独购买保险(没有订单)  3.黑屏解析',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '1、计划位订单 2、团队位订单 3、散客订单 4、其他',
  `query` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '查询内容（pnr编码或解析编码）',
  `pnr` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `insurance_order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保险订单号',
  `order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '订单金额',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `pay_status` tinyint(1) NULL DEFAULT 1 COMMENT '1 未支付 2已支付',
  `insurances_id` int NULL DEFAULT NULL COMMENT '保险id',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6564 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_insurance_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `distribution_insurance_passenger_info`;
CREATE TABLE `distribution_insurance_passenger_info`  (
  `passenger_id` int NOT NULL AUTO_INCREMENT,
  `sole_coding` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一标识',
  `insurance_order_no` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保险订单号',
  `passenger_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `birth_date` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `age_type` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ADU成人 CHD儿童 INF 婴儿',
  `mobile` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `ticket_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`passenger_id`) USING BTREE,
  INDEX `insurance_order_no`(`insurance_order_no` ASC) USING BTREE,
  INDEX `card_no`(`card_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9549 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'pnr导入单独购买保险出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_insurance_relation
-- ----------------------------
DROP TABLE IF EXISTS `distribution_insurance_relation`;
CREATE TABLE `distribution_insurance_relation`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `pnr` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `order_no` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `passenger_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出行人id',
  `sequence_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航段id',
  `insurance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保单id',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'pnr解析管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_insurance_sequence
-- ----------------------------
DROP TABLE IF EXISTS `distribution_insurance_sequence`;
CREATE TABLE `distribution_insurance_sequence`  (
  `sequence_id` int NOT NULL AUTO_INCREMENT,
  `sole_coding` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一标识',
  `insurance_order_no` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保险订单号',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `d_city` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市名称',
  `d_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场名称',
  `a_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `a_city` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市名称',
  `a_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场名称',
  `d_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场航站楼',
  `a_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场航站楼',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` datetime NULL DEFAULT NULL COMMENT '到达时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`sequence_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6560 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'pnr导入单独购买保险航段信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_itinerary_aduit_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_itinerary_aduit_record`;
CREATE TABLE `distribution_itinerary_aduit_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '1.国内，2.国际',
  `source` tinyint(1) NOT NULL COMMENT '1.销售单，2.改签单',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `ticket_nos` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '票号',
  `province` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省',
  `city` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '市',
  `area` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '区',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `addressee` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收件人',
  `mobile` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `courier_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '快递单号',
  `dispatch_type` tinyint(1) NULL DEFAULT NULL COMMENT '派送方式  1快递派送  2人工派送',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核备注(外部备注)',
  `internal_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核备注(内部备注)',
  `is_audit` tinyint(1) NULL DEFAULT 1 COMMENT '审核状态  1待审核  2已审核  3审核失败',
  `is_submit` tinyint(1) NULL DEFAULT 1 COMMENT '提交状态 1未提及 2已提交',
  `title_type` tinyint(1) NULL DEFAULT NULL COMMENT '发票类型1个人 2企业 3政府单位',
  `look_up` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '抬头',
  `taxpaye_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '纳税人编号',
  `rejected_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `audit_time` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作人id',
  `submit_data` json NULL COMMENT '提交返回数据',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `channel_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道代码',
  `email` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `bank_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '银行卡号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '行程单申请记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_keep_accounts_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_keep_accounts_order`;
CREATE TABLE `distribution_keep_accounts_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `arrears_ids` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '欠款记录distribution_arrears_record的id(多个，逗号隔开)',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '欠款结算业务订单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '欠款结算流水号',
  `pay_orders_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '欠款结算三方支付订单号 流水号',
  `remittance_bank` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '汇款银行',
  `money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '结算金额',
  `actual_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `pay_status` tinyint(1) NULL DEFAULT 1 COMMENT '支付状态 1 未支付 2已支付   3已过期',
  `settlement_type` tinyint(1) NULL DEFAULT NULL COMMENT '结算方式  1线上结算  2线下结算',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '欠款结算时间',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8117 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '欠款下账订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_level
-- ----------------------------
DROP TABLE IF EXISTS `distribution_level`;
CREATE TABLE `distribution_level`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `level_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '级别名称',
  `i_service_adu_fee` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '国际成人服务费',
  `i_service_chd_fee` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '国际儿童服务费',
  `i_service_inf_fee` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '国际婴儿服务费',
  `n_service_adu_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '国内成人服务费',
  `n_service_chd_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '国内儿童服务费',
  `n_service_inf_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '国内婴儿服务费',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商等级' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_login_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_login_log`;
CREATE TABLE `distribution_login_log`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `distribution_id` int NOT NULL DEFAULT 0 COMMENT '分销商id',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录用户名',
  `user_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '用户类型：1 管理员，2 员工',
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录ip',
  `platform` tinyint(1) NOT NULL DEFAULT 0 COMMENT '登录平台：1 PC，2 微信小程序',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `distribution_id`(`distribution_id` ASC) USING BTREE,
  INDEX `user_name`(`user_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5785 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商登录日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_malicious_order_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_malicious_order_record`;
CREATE TABLE `distribution_malicious_order_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `delay_minutes` int NULL DEFAULT NULL COMMENT '延期分钟数',
  `deay_at` timestamp NULL DEFAULT NULL COMMENT '延期时间',
  `number` int NULL DEFAULT NULL COMMENT '恶意下单未支付次数',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '恶意下单记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_message
-- ----------------------------
DROP TABLE IF EXISTS `distribution_message`;
CREATE TABLE `distribution_message`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_id` int NULL DEFAULT NULL COMMENT '发送者id',
  `has_alert` tinyint(1) NULL DEFAULT 2 COMMENT '是否弹出 1是   2否',
  `has_top` tinyint(1) NOT NULL DEFAULT 2 COMMENT '是否置顶 1是    2否',
  `read_flag` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '已读id和分销类型  ',
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '发送类型    1首页 2预定',
  `target_type` tinyint(1) NULL DEFAULT NULL COMMENT '目标类型  1航司  2城市',
  `air_line_code` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `message_title` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `message_text_id` int NULL DEFAULT NULL COMMENT '消息内容id',
  `air_region_id` int NULL DEFAULT 0 COMMENT '省id',
  `departure_city` int NULL DEFAULT 0 COMMENT '出港城市id(省市)',
  `entry_city` int NULL DEFAULT 0 COMMENT '入港城市id(省市)',
  `city_type` tinyint(1) NULL DEFAULT NULL COMMENT '省类型 1 省   2市  3全国',
  `expiration_time` timestamp NULL DEFAULT NULL COMMENT '过期时间',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `expiration_time-index`(`expiration_time` ASC) USING BTREE,
  INDEX `common-index`(`target_type` ASC, `city_type` ASC, `departure_city` ASC, `entry_city` ASC) USING BTREE,
  INDEX `has_top_type-index`(`has_top` ASC, `type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 198 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商公告消息通知' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_message_content
-- ----------------------------
DROP TABLE IF EXISTS `distribution_message_content`;
CREATE TABLE `distribution_message_content`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `message_title` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `author` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作者',
  `sender_id` int NULL DEFAULT NULL COMMENT '发送者id',
  `message_text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '消息正文',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 219 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商消息公告内容' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_offline_remittance_audit
-- ----------------------------
DROP TABLE IF EXISTS `distribution_offline_remittance_audit`;
CREATE TABLE `distribution_offline_remittance_audit`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `type` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '充值 top（distribution_top_up_order）     欠款 arrears（distribution_keep_accounts_order）',
  `arrears_id` int NULL DEFAULT NULL COMMENT '关联订单id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `credentials_img` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '凭证(多张逗号隔开)',
  `apply_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请备注',
  `is_audit` tinyint NULL DEFAULT 1 COMMENT '1未审核   2审核成功 3驳回',
  `rejected_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `rejected_at` timestamp NULL DEFAULT NULL COMMENT '驳回时间',
  `operator_id` int NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5586 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '线下付款记录审核' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_offline_remittance_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_offline_remittance_order`;
CREATE TABLE `distribution_offline_remittance_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `remittance_type` tinyint(1) NULL DEFAULT NULL COMMENT '线下汇款类型  1分销商充值 2短信余量充值',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `pay_orders_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '欠款结算三方支付订单号 流水号',
  `remittance_bank` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '汇款银行',
  `money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '结算金额',
  `actual_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `dis_id` int NULL DEFAULT 0 COMMENT '分销商id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '说明',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 168 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '线下汇款总表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_offline_remittance_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_offline_remittance_record`;
CREATE TABLE `distribution_offline_remittance_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '产生欠款的对应业务订单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '产生欠款的对应支付订单号(流水号)',
  `associated_external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '欠款结算订单 流水号',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '1、计划位订单 2、团队位订单 3、散客订单',
  `pay_orders_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型 1分销商充值 2短信余量充值 3分销商授信销账 4分销商购票在线支付 5保险支付 6分期延时费 7改签  8订单补差',
  `order_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单名称 根据order_type 查询',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `take_off_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `flight` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号',
  `arrears_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '欠款金额',
  `is_overdue` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否逾期 1未逾期  2 逾期',
  `is_refund` tinyint(1) NULL DEFAULT 1 COMMENT '1：未退款   2：已退款 ',
  `is_settlement` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否结算  1未结算  2已结算 3结算中',
  `settlement_type` tinyint(1) NULL DEFAULT NULL COMMENT '结算方式  1线上结算  2线下结算',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '0正在补填  1补填成功 -1 补填失败',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '欠款时间',
  `order_time` timestamp NULL DEFAULT NULL COMMENT '下单时间',
  `arrears_time` timestamp NULL DEFAULT NULL COMMENT '逾期时间',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `group_ids` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客分组集合',
  `ticket_nos` varchar(1300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客票号集合',
  `passenger_names` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客姓名集合',
  `d_ports` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场集合',
  `a_ports` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场集合',
  `card_nos` varchar(1800) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号集合',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49527 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '欠款结算记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order`;
CREATE TABLE `distribution_order`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `operation_type` tinyint(1) NOT NULL COMMENT '操作类型：1 分销商  2 员工 3 Booking手工单',
  `operation_id` int NOT NULL COMMENT '操作人id',
  `source_platform` tinyint(1) NOT NULL DEFAULT 1 COMMENT '来源平台，1pc、2小程序',
  `out_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '外部订单号',
  `agency_booking_admin_id` int NOT NULL COMMENT '代客订票booking 管理员名称',
  `business_type` tinyint NOT NULL DEFAULT 1 COMMENT '1、计划位订单 2、团队位订单 3、散客订单',
  `business_id` int NULL DEFAULT 0 COMMENT '业务id',
  `order_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1国内订单  2国际订单',
  `pay_type` tinyint(1) NULL DEFAULT 1 COMMENT '支付方式 1分期支付  2全额支付',
  `is_team` tinyint(1) NULL DEFAULT 0 COMMENT '是否是团队订单',
  `is_customer` tinyint(1) NULL DEFAULT 0 COMMENT '是否是大客户订单',
  `is_gp` tinyint(1) NULL DEFAULT 0 COMMENT '是否是gp订单',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务单号',
  `union_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联合订单号',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总价格（人数*票面价）',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '成人单人票面价(不含任何税费、包括机建燃油)\r\n计划位 ：包含加减比例单价  不包含机建、燃油费等\r\n散客：票面价   不包含机建、燃油费等\r\n临时团：票面价   不包含机建、燃油费等',
  `children_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童票面价(不含任何税费、包括机建燃油)',
  `baby_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿单人票面价(不含任何税费、包括机建燃油)',
  `plan_old_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '计划位底价',
  `person_nums` int NOT NULL DEFAULT 0 COMMENT '团队人数（确认名单后成人数量或者确认名单前人员数量）',
  `adult_number` int NULL DEFAULT 0 COMMENT '成人数量',
  `children_number` int NULL DEFAULT 0 COMMENT '儿童数量',
  `baby_nums` int NULL DEFAULT 0 COMMENT '婴儿数量（确认名单后婴儿数量）',
  `adult_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人机建费',
  `adult_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人燃油费',
  `children_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费',
  `offset_money` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '可抵充余额',
  `offset_money_freeze` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '抵充冻结',
  `order_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '主订单状态0:已过期 1:待出票 2:出票中 3:已出票  4:出票失败 5:取消订单 ',
  `pay_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '支付状态：1:未支付 2:未全额支付完毕  3:已全额支付完毕 ',
  `cancel_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '取消状态 1未操作 2:取消申请 3:booking确认取消',
  `flight_type` tinyint(1) NULL DEFAULT 0 COMMENT '1往返 2单程 3联程 4缺口程',
  `trip_tag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '去返标识:0=单程去程，1=往返去程,2=往返回程（假往返生效）',
  `is_audit` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1未审核   2已审核 3驳回',
  `ticket_company` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票航司',
  `reamrk` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对外备注',
  `our_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对内备注',
  `is_rollback` tinyint(1) NULL DEFAULT 1 COMMENT '1未回滚  2已回滚',
  `contact` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系手机',
  `tel` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系座机',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系邮箱',
  `pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'PNR',
  `old_pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧的pnr',
  `recode_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第二PNR',
  `old_recode_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧的大编码',
  `ticket_agent_id` int NULL DEFAULT 0 COMMENT '出票工作人员id',
  `ticket_agent_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票工作人员名称',
  `ticket_type` tinyint NULL DEFAULT 1 COMMENT '出票方式：1.手工出票，2.自动出票',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `department_id` int NULL DEFAULT 0 COMMENT '部门id',
  `path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '附件路径',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `op_purchase_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'op采购账号',
  `frequent_flyer_group_id` int NULL DEFAULT 0 COMMENT '常旅客分组id',
  `is_retain` tinyint NULL DEFAULT 2 COMMENT '是否留单：1.是，2.否',
  `deadline_to_hold_an_order` datetime NULL DEFAULT NULL COMMENT '留单截止时间',
  `attachment_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '附件路径，多个以英文逗号隔开',
  `ext` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '附加数据',
  `salesperson` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售人',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  `gp_type` tinyint(1) NULL DEFAULT 0 COMMENT 'gp类型，0为无,1=公务卡,2=预算单位',
  `gp_budget_unit_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预算单位名字',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `order_status`(`order_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54969 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_extra
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_extra`;
CREATE TABLE `distribution_order_extra`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务单号',
  `change` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是改签单',
  `gauge` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '退改信息',
  `baggage` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '行李额',
  `manual_attachment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '手工单附件',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 166 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单附加数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_extra_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_extra_record`;
CREATE TABLE `distribution_order_extra_record`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT 0 COMMENT '分销商id',
  `ins_id` int NULL DEFAULT 0 COMMENT '分期记录id',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `pay_status` tinyint(1) NULL DEFAULT 1 COMMENT '1 未支付 2 已支付 ',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台业务单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台支付流水号（分期罚没 没流水号）',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '金额',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1分期罚没（无需支付）  2 单收罚没 （需单独再支付） 3 延时费 4 其它费用 5税费 6婴儿费用',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间  为null 表示未删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no_and_external_no_and_type`(`order_no` ASC, `external_no` ASC, `type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 159 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商订单额外付款记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_ins_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_ins_record`;
CREATE TABLE `distribution_order_ins_record`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `ins_serial_number` tinyint(1) NULL DEFAULT NULL COMMENT '分期付款的第几期数（表示这是第几期支付）',
  `ins_pay_status` tinyint(1) NULL DEFAULT 1 COMMENT '1 未支付 2 已支付 ',
  `is_invalid` tinyint(1) NULL DEFAULT 2 COMMENT '1已作废 2未作废',
  `contract_status` tinyint(1) NULL DEFAULT 1 COMMENT '1 未违约 2 已违约 ',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台业务单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台支付流水号',
  `person_nums` int NULL DEFAULT NULL COMMENT '当期人员数量',
  `change_nums` int NULL DEFAULT 0 COMMENT '更改人员数量',
  `no_penalty_nums` int NULL DEFAULT 0 COMMENT '免罚人数',
  `change_nums_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更改状态 + -',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
  `appoint_time` timestamp NULL DEFAULT NULL COMMENT '规则约定支付时间',
  `appoint_ymd` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规定支付时间 Y-m-d',
  `is_pre_save` tinyint(1) NULL DEFAULT 1 COMMENT '1正常订单     2预改订单(先支付完成在修改数据\r\n)',
  `is_pre_save_nums` int NULL DEFAULT 0 COMMENT '预修改人数',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '实际支付时间',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间  为null 表示未删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no_and_external_no`(`order_no` ASC, `external_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 271 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分期付款记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_log`;
CREATE TABLE `distribution_order_log`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 分销商  2员工 3系统(可展示)  4booking运营人员  5内部系统(不展示给用户看的)',
  `operation_id` int NULL DEFAULT NULL COMMENT '操作人id',
  `operation_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `transaction_order_type` tinyint(1) NULL DEFAULT NULL COMMENT '日志类型：1、正常单流转日志  2、退票单日志 3、改签单日志',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作对应交易类型业务单号',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '日志内容',
  `explain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志说明',
  `log_level` int NOT NULL DEFAULT 200 COMMENT '日志级别',
  `param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '接受参数json',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104028 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商订单日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_passenger_info`;
CREATE TABLE `distribution_order_passenger_info`  (
  `passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sole_coding` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一编码',
  `pid` int NULL DEFAULT NULL COMMENT '上级id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `ticket_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '售卖价(不含机建燃油等税费)',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '奖励',
  `tax_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '面向用户机建费(审核后)',
  `fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向用户机燃油费(审核后)',
  `purchase_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向航司采购税金(出票后)',
  `purchase_agent_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向航司代理费(出票)',
  `purchase_agent_rate` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理费率',
  `purchase_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向航司采购价(出票)',
  `insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保险金额',
  `insurance_num` int NULL DEFAULT 0 COMMENT '购买保险份数',
  `ticket_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `airline_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向航司票面价(出票后的票面价)',
  `extra_ticke_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '额外票号 逗号间隔',
  `birth_date` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `age_type` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ADU成人 CHD儿童 INF 婴儿',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CN' COMMENT '国籍',
  `passenger_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'NOR' COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `mobile` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '区号+手机号',
  `email` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile_standby` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备用区号+手机号',
  `change_status` tinyint(1) NULL DEFAULT 1 COMMENT '改签状态  1未改签 2改签中  3.已改签',
  `refund_status` tinyint(1) NULL DEFAULT 1 COMMENT '退票状态  1未退票  2退票中  3已退票',
  `insurance` tinyint(1) NULL DEFAULT 0 COMMENT '0未投保   1已投保',
  `customer_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大客户编码',
  `customer_id` int NULL DEFAULT 0 COMMENT '大客户文件id',
  `is_itinerary` tinyint(1) NULL DEFAULT 0 COMMENT '是否打印行程单 1已打印 2未打印 3已作废',
  `itinerary_no` tinyint(1) NULL DEFAULT 0 COMMENT '行程单号',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `customer_policy_id` int NULL DEFAULT NULL COMMENT '大客户政策id',
  `is_gp` tinyint(1) NULL DEFAULT 0 COMMENT '是否是gp',
  `gp_type` tinyint(1) NULL DEFAULT 0 COMMENT 'gp类型，0为无,1=公务卡,2=预算单位',
  `gp_budget_unit_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gp预算单位名字',
  `gp_official_card_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gp公务卡代码',
  `gp_official_card_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gp公务卡名字',
  `gp_department` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gp部门',
  `pnr` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码',
  `recode_no` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大编码',
  PRIMARY KEY (`passenger_id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `passenger_name`(`passenger_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 142743 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位销售单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_pay
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_pay`;
CREATE TABLE `distribution_order_pay`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号（同业务单号，分期付 业务单号可能一致）',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台支付流水号（每次支付不一样，支付回调用）',
  `pay_orders_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商户支付订单号(三方支付渠道，每次支付不一样)',
  `timeout_express` timestamp NULL DEFAULT NULL COMMENT '订单有效期 单位分钟，最小 1,最大 1440,默认 30',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '支付金额',
  `pay_handling_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付手续费',
  `pay_handling_fee_ratio` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付手续费比例',
  `pay_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'deposit预付款支付 lines授信额度支付  icbc 工行支付   deduction抵扣  remittance线下汇款  rcu 农商支付',
  `orders_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型 1分销商充值 2短信余量充值 3分销商授信销账 4分销商购票在线支付 5保险支付 6分期延时费  7改签支付',
  `is_union_order` tinyint(1) NULL DEFAULT 0 COMMENT '是否是联合订单',
  `union_order_pay` tinyint(1) NULL DEFAULT 0 COMMENT '联合订单是否已支付',
  `pay_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '支付状态 1 未支付 2已支付   3已过期',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `operation_id` int NULL DEFAULT NULL COMMENT '操作人id',
  `operation_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 分销商  2 员工 3 Booking',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品描述',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `auto_pay` tinyint(1) NULL DEFAULT 0 COMMENT '自动支付：0 否，1 是',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no_and_external_no_and_dis_id`(`order_no` ASC, `external_no` ASC, `dis_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66644 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商支付表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_plan
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_plan`;
CREATE TABLE `distribution_order_plan`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `plan_rule_id` int NULL DEFAULT NULL COMMENT '计划位规则id 计划位团队人数表',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `person_nums_id` int NULL DEFAULT NULL COMMENT '团队人数id',
  `add_prcie` decimal(11, 2) NULL DEFAULT NULL COMMENT '单人加价金额',
  `add_price_proportion` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '加价比例',
  `cash_pledge` json NULL COMMENT '计划位分期比例',
  `proportion_symbl` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加减比例类型 +  -',
  `price_symbl` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加减金额类型 + -',
  `floor_price` decimal(11, 2) NULL DEFAULT NULL COMMENT '底价（计划位原价 不含加减价）',
  `baby_ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '婴儿票价（计划位原价 不含加减价）',
  `init_seat_num` int NULL DEFAULT NULL COMMENT '下单时计划位初始座位数',
  `distributor_group_ratio` int NULL DEFAULT NULL COMMENT '最低成团比(面向客户)',
  `last_group_num` int NULL DEFAULT NULL COMMENT '最低成团人数',
  `initial_person_nums` int NULL DEFAULT NULL COMMENT '初始成团人数',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位订单明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_relation`;
CREATE TABLE `distribution_order_relation`  (
  `relation_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `relation_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '关联数据状态 1正常',
  `change_status` tinyint(1) NULL DEFAULT 1 COMMENT '改签状态  1未改签 2改签中  3.已改签',
  `refund_status` tinyint(1) NULL DEFAULT 1 COMMENT '退票状态  1未退票  2退票中  3已退票',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`relation_id`) USING BTREE,
  INDEX `sale_order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 213252 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_scattered_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_scattered_record`;
CREATE TABLE `distribution_order_scattered_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `policy_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策代码（第一个数字：1 普通，2 直加）',
  `child_issue_chd_ticket` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 儿童出成人票 2儿童出儿童票',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台业务单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台支付流水号',
  `person_nums` int NULL DEFAULT 0 COMMENT '人员数量',
  `amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付金额',
  `adult_price` decimal(10, 2) NULL DEFAULT 0.00,
  `children_price` decimal(10, 2) NULL DEFAULT 0.00,
  `baby_price` decimal(10, 2) NULL DEFAULT 0.00,
  `tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人机建',
  `fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人燃油',
  `children_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童机建',
  `children_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油',
  `baby_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿机建',
  `baby_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿燃油',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人服务费',
  `children_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童服务费',
  `baby_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿服务费',
  `adult_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人奖励',
  `children_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童奖励',
  `baby_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿奖励',
  `import_pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '导入pnr',
  `pnr_import_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no_index`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54735 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '散客订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_sequence
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_sequence`;
CREATE TABLE `distribution_order_sequence`  (
  `sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `plan_id` int NULL DEFAULT 0 COMMENT '计划位id',
  `sole_coding` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一编码md5',
  `inter_segment` tinyint(1) NULL DEFAULT 0 COMMENT '是否是国际航段',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `a_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场航站楼',
  `a_city` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市名称',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `a_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场名称',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字编码',
  `arrival_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班到达时间',
  `take_off_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `d_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场航站楼',
  `d_city` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市名称',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `d_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场名称',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号',
  `tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人机建费',
  `fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人燃油费',
  `children_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童机建费',
  `children_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费',
  `baby_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿机建费',
  `baby_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿燃油费',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人服务费',
  `children_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童服务费',
  `baby_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿服务费',
  `adult_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人奖励',
  `children_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童奖励',
  `baby_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿奖励',
  `policy_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策代码',
  `transfers` tinyint(1) NULL DEFAULT 2 COMMENT '是否中转   1是   2否',
  `luggage` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '行李',
  `stopover` tinyint(1) NULL DEFAULT 2 COMMENT '是否经停  1是  2否',
  `stopover_info` json NULL COMMENT '经停信息',
  `oi` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '往返标识 O代表去  I代表返',
  `stopover_coding` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '经停城市三字码 多个 逗号隔开',
  `main_sequence` int NULL DEFAULT NULL COMMENT '主航段',
  `sequence` int NOT NULL DEFAULT 1 COMMENT '子航段航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '子舱位',
  `sub_class_str` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位字符',
  `farebasis` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'farebasis运价基础',
  `adult_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人票面价(不含税)',
  `adult_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人销售价(不含税)',
  `children_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童票面价(不含税)',
  `children_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童销售价(不含税)',
  `baby_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿票面价(不含税)',
  `baby_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿销售价(不含税)',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`sequence_id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74115 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位销售单航段 信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_team
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_team`;
CREATE TABLE `distribution_order_team`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单',
  `last_ticket_time` timestamp NULL DEFAULT NULL COMMENT '最晚出票时间',
  `last_confirm_time` timestamp NULL DEFAULT NULL COMMENT '提供人员名单时间(最晚确认出行人时间)',
  `delayed_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '延时费用',
  `delayed_time` int NULL DEFAULT NULL COMMENT '延时时间(分钟)',
  `to_airline_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '面向航司票价(需支付金额)',
  `airline_periods` int NULL DEFAULT NULL COMMENT '面向航司  分期期数',
  `distributor_periods` int NULL DEFAULT NULL COMMENT '面向客户  分期期数',
  `last_ticket_num` int NULL DEFAULT NULL COMMENT '面向客户 最低开票人数',
  `change_number` tinyint(1) NULL DEFAULT NULL COMMENT '面向客户 是否更改人数  1是   2否',
  `airline_group_ratio` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '100' COMMENT '最低成团比(面向航司)',
  `distributor_group_ratio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '100' COMMENT '最低成团比(面向客户)',
  `last_group_num` int NULL DEFAULT 0 COMMENT '最少成团人数（初始团队人数*最低成团比）向上取整',
  `init_team_number` int NULL DEFAULT 0 COMMENT '初始团队人数',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 182 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '零时团订单子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_order_union
-- ----------------------------
DROP TABLE IF EXISTS `distribution_order_union`;
CREATE TABLE `distribution_order_union`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NOT NULL COMMENT '分销商id',
  `union_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联订单号',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '订单总金额',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单联合表，用于往返等关联' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_passenger_audit
-- ----------------------------
DROP TABLE IF EXISTS `distribution_passenger_audit`;
CREATE TABLE `distribution_passenger_audit`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `nums` int NULL DEFAULT NULL COMMENT '审核人数',
  `adult_nums` int NULL DEFAULT NULL COMMENT '成人人数',
  `baby_nums` int NULL DEFAULT NULL COMMENT '婴儿人数',
  `children_nums` int NULL DEFAULT NULL COMMENT '儿童人数',
  `rejected_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `status` tinyint(1) NULL DEFAULT 2 COMMENT '1审核成功  2未审核  3驳回',
  `rejected_at` timestamp NULL DEFAULT NULL COMMENT '驳回时间',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 191 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单出行人审核' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_passenger_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_passenger_order`;
CREATE TABLE `distribution_passenger_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `ins_pay_status` tinyint(1) NULL DEFAULT 1 COMMENT '1 未支付 2 已支付 ',
  `tax` decimal(10, 2) NULL DEFAULT NULL COMMENT '税金单价',
  `tax_nums` int NULL DEFAULT 1 COMMENT '需支付税金的人数(不包括婴儿)',
  `tax_tatal_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '税金总价',
  `baby_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '婴儿单价',
  `baby_nums` int NULL DEFAULT 0 COMMENT '婴儿人数',
  `baby_tatal_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿总价',
  `total_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '支付总金额（税金*成人人数+婴儿钱*婴儿人数）',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '实际支付时间',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '税金婴儿订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_passenger_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_passenger_record`;
CREATE TABLE `distribution_passenger_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `group` int NULL DEFAULT NULL,
  `passenger_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `card_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `operation_id` int NULL DEFAULT NULL COMMENT '操作人id',
  `operation_type` tinyint NULL DEFAULT NULL COMMENT '操作人类型：1 分销商  2 员工',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `original_data` json NULL COMMENT '原始数据',
  `new_data` json NULL COMMENT '最新数据',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1新增 2修改  3删除',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 121989 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '常用出行人操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_pay_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_pay_log`;
CREATE TABLE `distribution_pay_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号 颓余 勿存数据',
  `admin_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 管理员  2 员工 3 系统 4 booking',
  `operation_id` int NULL DEFAULT NULL COMMENT '操作人',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '支付金额',
  `pay_handling_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '支付手续费',
  `pay_handling_fee_ratio` decimal(10, 2) NULL DEFAULT NULL COMMENT '支付手续费比例',
  `pay_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付类型 icbc工行   deposit预存款  lines授信  rcu浙江农信',
  `content` json NULL COMMENT '支付内容',
  `explain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付说明',
  `callback` json NULL COMMENT '支付回调',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57465 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '支付记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_pay_request_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_pay_request_record`;
CREATE TABLE `distribution_pay_request_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL,
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `pay_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '  icbc 工行支付     rcu农商支付',
  `operation_type` tinyint(1) NULL DEFAULT NULL COMMENT '1发起支付  2查询支付结果  3退款申请  4.退款结果查询',
  `orders_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型 1分销商充值 2短信余量充值 3分销商授信销账 4分销商购票在线支付 5保险支付 6分期延时费  7改签支付',
  `request_data` json NULL COMMENT '请求参数',
  `response_data` json NULL COMMENT '响应参数',
  `tx_dtTm` timestamp NULL DEFAULT NULL COMMENT '交易发起时间',
  `asynchronous_response` json NULL COMMENT '异步响应',
  `response_type` tinyint(1) NULL DEFAULT 1 COMMENT '1未响应    2已响应',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 563 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '第三方支付请求/响应相关记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_pay_type
-- ----------------------------
DROP TABLE IF EXISTS `distribution_pay_type`;
CREATE TABLE `distribution_pay_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `sign` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付标识 bank银行卡支付  余额balance',
  `pay_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付名称',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '是否开启支付 1开启  2关闭',
  `check_pay_password` tinyint(1) NOT NULL DEFAULT 2 COMMENT '支付时是否验证支付密码 1验证 2不验证',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_penal_recored
-- ----------------------------
DROP TABLE IF EXISTS `distribution_penal_recored`;
CREATE TABLE `distribution_penal_recored`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '违约金额',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付流水单号',
  `ins_pay_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '支付状态 1 未支付 2已支付',
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '违约说明',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商违约金缴纳记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_plan
-- ----------------------------
DROP TABLE IF EXISTS `distribution_plan`;
CREATE TABLE `distribution_plan`  (
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `plan_rule_id` int NULL DEFAULT NULL COMMENT '计划规则id',
  `sales_start_time` timestamp NULL DEFAULT NULL COMMENT '销售开始时间',
  `sales_end_time` timestamp NULL DEFAULT NULL COMMENT '销售结束时间',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商计划位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_pnr_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_pnr_record`;
CREATE TABLE `distribution_pnr_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成pnr',
  `content` json NULL COMMENT '请求内容',
  `callback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '回调内容',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1待处理   2创建成功 3创建失败',
  `behavior` tinyint(1) NULL DEFAULT 1 COMMENT '1自动生编(已支付未生编订单) 2主动生编（未支付未过期订单）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6001 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'pnr记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_policy
-- ----------------------------
DROP TABLE IF EXISTS `distribution_policy`;
CREATE TABLE `distribution_policy`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `shipping_price_channels` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '运价渠道：1 IBE+，2 航班管家，3 易旅行，多个使用英文逗号隔开',
  `platforms_ids` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '10' COMMENT '销售平台id，多个英文逗号隔开',
  `channels_for_generating_codes` tinyint(1) NOT NULL DEFAULT 1 COMMENT '生编渠道：1 IBE+，2 eterm, 3 假编',
  `product_price_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '产品运价类型：PUB_FARE、FD等',
  `product_types` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '产品类型：1 标品，2 非标品，3 旗舰店，多个以英文逗号隔开',
  `office_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'eterm生编配置',
  `min_age` tinyint(1) NOT NULL DEFAULT 0 COMMENT '最小年龄',
  `max_age` tinyint(1) NOT NULL DEFAULT 100 COMMENT '最大年龄',
  `age_types` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旅客年龄类型：ADU 成人，CHD 儿童，多个使用英文逗号隔开',
  `voyage_type` tinyint(1) NULL DEFAULT 1 COMMENT '航段类型：1 单航段，2 多航段，3 单航段+多航段',
  `policy_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策名称',
  `airline_recode_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `take_off_time` timestamp NULL DEFAULT NULL COMMENT '起飞开始时间',
  `arrival_time` timestamp NULL DEFAULT NULL COMMENT '起飞结束时间',
  `cabin_code` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用舱位',
  `flight` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '航班号',
  `flight_type` tinyint(1) NULL DEFAULT NULL COMMENT '适用航班  1适用  2不适用',
  `apply_d_port` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '适用航程(起飞机场)',
  `apply_a_port` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '适用航程(到达机场)',
  `no_apply_d_port` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '不适用航程(起飞机场)',
  `no_apply_a_port` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '不适用航程(到达机场)',
  `sales_range_add` timestamp NULL DEFAULT NULL COMMENT '销售开始时间',
  `sales_range_end` timestamp NULL DEFAULT NULL COMMENT '销售结束时间',
  `advance_time` int NULL DEFAULT NULL COMMENT '提前时间(小时)',
  `issue_ticket_type` tinyint(1) NULL DEFAULT 2 COMMENT '自动出票 1是  2否',
  `issue_ticket_platform` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票渠道',
  `foreign_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对外说明',
  `internal_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对内说明',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签',
  `status` tinyint(1) NULL DEFAULT 2 COMMENT '审核状态  1已审核  2未审核  3 作废 4停用',
  `whether_to_import_from_a_table` tinyint(1) NULL DEFAULT 0 COMMENT '是否从表格导入：0 否，1 是',
  `farebasis` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运价代码',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 492 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '普通政策' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_policy_child
-- ----------------------------
DROP TABLE IF EXISTS `distribution_policy_child`;
CREATE TABLE `distribution_policy_child`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `policy_id` int NULL DEFAULT NULL COMMENT '政策id',
  `associated_id` int NULL DEFAULT NULL COMMENT '关联id(level:等级id、specific:特定分销商id、other_sales_platforms:其他销售平台id)',
  `proportion` int NULL DEFAULT NULL COMMENT '返点比例',
  `pot_symbol` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加减类型 +   -',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '加减金额',
  `mon_symbl` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加减金额类型  +  -',
  `type` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'level:等级  specific:特定分销商 other_sales_platforms:其他销售平台',
  `created_at` datetime NOT NULL COMMENT '创建时候',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `policy_id`(`policy_id` ASC) USING BTREE,
  INDEX `associated_id`(`associated_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31321 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '政策加价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_policy_increase_refund_and_change_percentage
-- ----------------------------
DROP TABLE IF EXISTS `distribution_policy_increase_refund_and_change_percentage`;
CREATE TABLE `distribution_policy_increase_refund_and_change_percentage`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `distribution_policy_id` int NOT NULL DEFAULT 0 COMMENT '政策id',
  `sub_class` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `additional_percentage` tinyint NOT NULL COMMENT '客规退票和改签比例基础上追加的比例',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `distribution_policy_id`(`distribution_policy_id` ASC) USING BTREE,
  INDEX `sub_class`(`sub_class` ASC) USING BTREE,
  INDEX `distribution_policy_id&sub_class`(`distribution_policy_id` ASC, `sub_class` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2632 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '普通政策增加客规退改百分比' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_policy_inter
-- ----------------------------
DROP TABLE IF EXISTS `distribution_policy_inter`;
CREATE TABLE `distribution_policy_inter`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '政策渠道',
  `alias` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '政策别名',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策代码',
  `od_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策类型=1：单程；2：往返；3：多程,多个/分割',
  `status` tinyint NULL DEFAULT 2 COMMENT '审核状态  1已审核  2未审核  3 作废 4停用',
  `air_type` tinyint(1) NULL DEFAULT 1 COMMENT '航司类型:1=航司编码,2=SPA联运主航司',
  `air_line` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '航司编码',
  `spa_air_line` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联运航司，格式:3U-CZ|XZ/8X-CZ|XZ',
  `departure` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '始发机场代码',
  `transfer` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '中转机场代码',
  `arrive` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '到达机场代码',
  `air_line_no_apply` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '不适用航线(可使用国家和机场)，单程JP-JP/JP-CKG，往返/多程JP=JP/JP=CKG',
  `sales_range_add` timestamp NULL DEFAULT NULL COMMENT '销售开始日期',
  `sales_range_end` timestamp NULL DEFAULT NULL COMMENT '销售结束日期',
  `flight_start_force_time` timestamp NULL DEFAULT NULL COMMENT '起飞生效时间',
  `flight_end_force_time` timestamp NULL DEFAULT NULL COMMENT '起飞失效时间',
  `flight_return_start_time` timestamp NULL DEFAULT NULL COMMENT '回程有效期',
  `flight_return_end_time` timestamp NULL DEFAULT NULL COMMENT '回程失效期',
  `ticket_start_force_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票有效期开始日期',
  `ticket_end_force_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票有效期结束日期',
  `ticket_start_peacetime` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票有效期开始时间',
  `ticket_end_peacetime` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票有效期结束时间',
  `flight_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '行程类型=1：国内直飞全球；2：境外直飞国内；3：国内始发Add-On；4：国外始发Add-On；5：全球直飞全球；6：全球中转全球',
  `flight_start_apply` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '去程适用航班，CA234',
  `flight_end_apply` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '回程适用航班，CA234',
  `flight_go_noapply` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '不适用去程航班，CA234',
  `flight_back_noapply` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '不适用回程航班，CA234',
  `stop_day_max` tinyint NULL DEFAULT 0 COMMENT '最大停留天数',
  `stop_day_min` tinyint NULL DEFAULT 0 COMMENT '最小停留天数',
  `sell_day` tinyint NULL DEFAULT 0 COMMENT '提前销售天数（航班起飞前xxx小时有效）',
  `cabins_verification_spa` tinyint(1) NULL DEFAULT 0 COMMENT '是否验证联运的子舱位',
  `departure_cabins` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '始发地适用舱位，A/B',
  `transfer_cabins` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '中转地适用舱位',
  `cabins_go_contain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '去程大段必须包含舱位信息',
  `cabins_back_contain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回程大段必须包含舱位信息',
  `ticket_price_max` int NULL DEFAULT 0 COMMENT '最高票价',
  `ticket_price_min` int NULL DEFAULT 0 COMMENT '票价最小值',
  `ticket_chd_reward` tinyint NULL DEFAULT 1 COMMENT '儿童票奖励类型=1：奖励与成人一致；2：可开无奖励；3：不可开；4：指定奖励',
  `ticket_chd_reward_val` int NULL DEFAULT 0 COMMENT '儿童票指定奖励值（单位%）',
  `ticket_chd_no_cost` tinyint NULL DEFAULT 0 COMMENT '儿童票可开无代理费1：可开；0：不可开',
  `ticket_chd_on_reduce` tinyint NULL DEFAULT 0 COMMENT '儿童票不享受直减=1：不享受；0：享受',
  `ticket_chd_no_open` tinyint NULL DEFAULT 0 COMMENT '儿童不单开=1：不单开；0=单开',
  `ticket_inf_reward` tinyint NULL DEFAULT 0 COMMENT '婴儿票是否开无奖励=1：可开无奖励；0=不可开',
  `ticket_inf_cost` int NULL DEFAULT 0 COMMENT '加收手续费（单位元）',
  `is_third_party_agreement` tinyint(1) NULL DEFAULT 0 COMMENT '是否第三方协议 1：是 0：否',
  `is_special_instructions` tinyint(1) NULL DEFAULT 0 COMMENT '是否特殊指令 1：是 0：否',
  `is_private_policy` tinyint(1) NULL DEFAULT 0 COMMENT '是否私有政策 1是 0：否',
  `show_all_reward` tinyint(1) NULL DEFAULT 0 COMMENT '是否显示所有奖励=1：是；0：否',
  `is_gds` tinyint(1) NULL DEFAULT 0 COMMENT 'GDS政策=1：是；0：否',
  `gds_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'GDS政策类型1G|1S',
  `fare_basis_contain_go` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '去程运价基础中包含（二字码PR/WX）',
  `fare_basis_contain_back` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '回程程运价基础中包含（二字码PR/WX）',
  `fare_type_go` tinyint(1) NULL DEFAULT 0 COMMENT '去程运价基础类型=1：无奖励；2：无代理费；3：不可用',
  `fare_type_back` tinyint NULL DEFAULT 0 COMMENT '回程运价基础类型=1：无奖励；2：无代理费；3：不可用',
  `fare_basis_go` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '去程仅适用运价基础',
  `fare_basis_back` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '回程仅适用运价基础',
  `fare_basis_same` tinyint(1) NULL DEFAULT 0 COMMENT '运价基础是否一致=1：是；0=否',
  `air_return` tinyint NULL DEFAULT 1 COMMENT '返回机场=1：同一洲际范围内；2：政策始发机场；3：必须返回行程出发机场；4：指定返回国家或机场范围',
  `air_return_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '返回指定机场或国家代码',
  `number_apply_start` tinyint NULL DEFAULT NULL COMMENT '适用人数开始',
  `number_apply_end` tinyint NULL DEFAULT NULL COMMENT '适用人数结束',
  `number_apply_two` tinyint NULL DEFAULT 0 COMMENT '只适用双人数=1：是；0=否；',
  `number_together` tinyint NULL DEFAULT NULL COMMENT '同改同退',
  `noapply_go_week` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '不适用去程周期（1/2/3）',
  `noapply_back_week` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '不适用回程周期（1/2/3）',
  `noapply_go_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '不适用去程日期段（格式：json）',
  `noapply_back_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '不适用回程日期段（格式：json）',
  `noapply_transfer_air` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '不适用转机机场（PKE/CKG)',
  `add_on` tinyint(1) NULL DEFAULT 0 COMMENT '不适用国内中转',
  `abroad_transfer` tinyint(1) NULL DEFAULT 0 COMMENT '不适用境外中转',
  `arrive_lost_type` tinyint(1) NULL DEFAULT 3 COMMENT '目的地缺口程类型： 0：不限制 1：不适用 2：适用国家内缺口',
  `arrive_lost_type_val` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用国家内缺口指定国家例：国家码CN/JP/KH',
  `sale_explain` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对外销售说明',
  `sale_inside` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对内销售说明',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '其他备注',
  `invoice_type` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发票类型',
  `source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '政策来源',
  `policy_type` tinyint(1) NULL DEFAULT 1 COMMENT '1:普通政策 2:特殊乘客类型政策',
  `ticket_cost` int NULL DEFAULT 0 COMMENT '开票手续费用',
  `create_user_id` int NULL DEFAULT 0 COMMENT '创建人id',
  `update_user_id` int NULL DEFAULT 0 COMMENT '修改人id',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 218 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际政策表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_policy_inter_child
-- ----------------------------
DROP TABLE IF EXISTS `distribution_policy_inter_child`;
CREATE TABLE `distribution_policy_inter_child`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `policy_id` int NOT NULL COMMENT '政策id',
  `type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '\'level:等级  specific:特定分销商\'',
  `associated_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '\'关联id(level:等级id、specific:特定分销商id)\'',
  `tags` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签值',
  `policy_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '政策代码',
  `departure` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场三字码',
  `transfer` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '中转机场三字码',
  `arrive` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场三字码',
  `cabins` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '可用舱位',
  `agent` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理费，%',
  `reward_after` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '航司后返，%',
  `ticket_cost` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '开票手续费,元',
  `lapse_single_type` tinyint(1) NULL DEFAULT 1 COMMENT '单程直加直减类型:1=定额，2=百分比',
  `lapse_single` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '单程直加直减金额/百分比',
  `lapse_round_type` tinyint(1) NULL DEFAULT 1 COMMENT '往返直加直减类型:1=定额，2=百分比',
  `lapse_round` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '往返直加直减金额/百分比',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 656 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际政策加价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_policy_logs
-- ----------------------------
DROP TABLE IF EXISTS `distribution_policy_logs`;
CREATE TABLE `distribution_policy_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `distribution_policy_id` int NOT NULL DEFAULT 0 COMMENT '普通政策id',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '操作类型：1 新增，2 修改，3 删除',
  `operator_id` int NOT NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `data_before_update` json NULL COMMENT '更新前数据',
  `data_after_update` json NULL COMMENT '更新后数据',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rule_id`(`distribution_policy_id` ASC) USING BTREE,
  INDEX `operator_id`(`operator_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 332 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '压位规则更变日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_policy_tag
-- ----------------------------
DROP TABLE IF EXISTS `distribution_policy_tag`;
CREATE TABLE `distribution_policy_tag`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `label_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签名称',
  `label_color` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签颜色',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '政策标签' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_preferences
-- ----------------------------
DROP TABLE IF EXISTS `distribution_preferences`;
CREATE TABLE `distribution_preferences`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `has_show_add_policy` tinyint(1) NULL DEFAULT NULL COMMENT '1 展示 2 不展示',
  `cabin_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱等 多选 逗号隔开 ',
  `show_number` int NULL DEFAULT NULL COMMENT '运价最多显示数量',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '偏好设置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_purchase_platform
-- ----------------------------
DROP TABLE IF EXISTS `distribution_purchase_platform`;
CREATE TABLE `distribution_purchase_platform`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchase_platform` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购渠道' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_recharge_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_recharge_order`;
CREATE TABLE `distribution_recharge_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1分销商充值 2短信余量充值 3后台充值补差',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '充值金额',
  `settlement_type` tinyint(1) NULL DEFAULT NULL COMMENT '结算方式  1线上结算  2线下结算 3后台充值',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 370 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '充值订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `distribution_refund_order`;
CREATE TABLE `distribution_refund_order`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `source_type` tinyint(1) NULL DEFAULT 1 COMMENT '\'退废来源  1 销售单退废 2改签单退废\'',
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '1国内订单  2国际订单',
  `import_type` tinyint(1) NULL DEFAULT NULL COMMENT '\'导入类型  1 ota自动  2 手动 \'',
  `refund_type` tinyint(1) NULL DEFAULT NULL COMMENT '退废类型 1退票 2废票',
  `refund_idea_type` tinyint(1) NULL DEFAULT 1 COMMENT '自愿退废  1 是  2 否',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票原因',
  `purchase_platform` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `office_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台销售单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `ota_refund_no` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台退票单号',
  `ota_sign_hash` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单哈希标识',
  `refund_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '自建平台退废流转状态 1待处理 2待复审 3已驳回  4待提交 5部分提交 6提交失败 7 已提交 8已完成 9已取消  10待确认',
  `returned_status` tinyint(1) NULL DEFAULT 2 COMMENT '回款状态 1 已回款 2 未回款',
  `has_returned_difference` tinyint(1) NULL DEFAULT 1 COMMENT '回款差异  1无  2有差异',
  `ota_status` tinyint(1) NULL DEFAULT 1 COMMENT 'ota申请状态 1待审核 2已审核 3 销售端ota已退款 4已驳回 5已取消 ',
  `ota_rt_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `operation_id` int NULL DEFAULT NULL COMMENT '申请人id',
  `operation_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请人名称',
  `operation_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 分销商  2员工',
  `supplier_id` int UNSIGNED NULL DEFAULT 0 COMMENT '供应商id',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `tickets` int NULL DEFAULT NULL COMMENT '票数',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '退票类型1、计划位订单 2、团队位订单 3、散客订单',
  `audit_time` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `order_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单备注',
  `ticket_agent_id` int NULL DEFAULT NULL COMMENT 'booking操作人员',
  `refund_time` timestamp NULL DEFAULT NULL COMMENT '出票时间',
  `refund_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '退票金额',
  `tax_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '机建费(总)',
  `fuel_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '燃油费(总',
  `remarks` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `submitted_time` timestamp NULL DEFAULT NULL COMMENT '已提交时间',
  `completed_time` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` timestamp NULL DEFAULT NULL,
  `contact` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人手机号码',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人邮箱',
  `path` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '非自愿退票文件路径',
  `is_retain` tinyint NULL DEFAULT 2 COMMENT '是否留单：1.是，2.否',
  `deadline_to_hold_an_order` datetime NULL DEFAULT NULL COMMENT '留单截止时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7257 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_refund_order_audit
-- ----------------------------
DROP TABLE IF EXISTS `distribution_refund_order_audit`;
CREATE TABLE `distribution_refund_order_audit`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `audit_uid` int NULL DEFAULT NULL COMMENT '审核人',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退废单号',
  `audit_times` tinyint NULL DEFAULT NULL COMMENT '1 一审 2 复审',
  `audit_type` tinyint NULL DEFAULT NULL COMMENT '1同意 2 驳回',
  `reason` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退废单审核记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_refund_order_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_refund_order_log`;
CREATE TABLE `distribution_refund_order_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `refund_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作内容',
  `sort` int NOT NULL COMMENT '序号 1-N 操作顺序',
  `operator_id` int NOT NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Booking 散客退票单异动日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_refund_order_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_refund_order_record`;
CREATE TABLE `distribution_refund_order_record`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `source_type` tinyint(1) NULL DEFAULT NULL COMMENT '退废来源  1 销售单退废 2改签单退废',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票单号',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售单号或者改签单号',
  `refund_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '内容',
  `param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '接受参数',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7159 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_refund_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `distribution_refund_order_relation`;
CREATE TABLE `distribution_refund_order_relation`  (
  `refund_relation_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `refund_passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `refund_sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退款单号',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15582 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_refund_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `distribution_refund_passenger_info`;
CREATE TABLE `distribution_refund_passenger_info`  (
  `refund_passenger_id` bigint NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `birth_date` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `pnr` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `office_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `ticket_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `extra_ticke_no` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '额外票号',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售票价(不含税)',
  `sale_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售机建费',
  `sale_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售燃油费',
  `sale_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售服务费(下单的出行服务费)',
  `sale_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售其它费用',
  `sale_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售代理费用',
  `sale_refund_fee` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '销售退票费',
  `sale_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应退金额',
  `reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '奖励',
  `refund_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票服务费',
  `insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保险金额',
  `insurance_num` int NULL DEFAULT 0 COMMENT '保险份数',
  `insurance_ids` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保险id，多个以英文逗号隔开',
  `relation_status` tinyint(1) NULL DEFAULT 1 COMMENT '联数据状态 1正常',
  `ota_status` tinyint(1) NULL DEFAULT 1 COMMENT 'ota申请状态 1待审核 2已审核 3 销售端ota已退款 4已驳回',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_passenger_id`) USING BTREE,
  UNIQUE INDEX `refund_passenger_id`(`refund_passenger_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11644 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_refund_sequence
-- ----------------------------
DROP TABLE IF EXISTS `distribution_refund_sequence`;
CREATE TABLE `distribution_refund_sequence`  (
  `sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退票单号',
  `a_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场航站楼',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市名称',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `a_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场名称',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字编码',
  `arrival_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班到达时间',
  `take_off_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `d_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场航站楼',
  `d_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市名称',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `d_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场名称',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号',
  `refund_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票服务费',
  `tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人机建费',
  `fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人燃油费',
  `children_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童机建费',
  `children_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费',
  `baby_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿机建费',
  `baby_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿燃油费',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人服务费',
  `children_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童服务费',
  `baby_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿服务费',
  `adult_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人奖励',
  `children_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童奖励',
  `baby_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿奖励',
  `policy_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策代码',
  `luggage` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '行李',
  `stopover` tinyint(1) NULL DEFAULT NULL COMMENT '是否经停  1是  2否',
  `stopover_coding` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '经停城市三字码 多个 逗号隔开',
  `main_sequence` int NULL DEFAULT 1 COMMENT '主航段',
  `sequence` int NOT NULL DEFAULT 1 COMMENT '航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '子舱位',
  `adult_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人票面价(不含税)',
  `adult_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人销售价(不含税)',
  `children_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童票面价(不含税)',
  `children_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童销售价(不含税)',
  `baby_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿票面价(不含税)',
  `baby_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿销售价(不含税)',
  `refund_money_aud` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人航段退票金额',
  `refund_money_chd` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童航段退票金额',
  `refund_money_inf` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿航段退票金额',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`sequence_id`) USING BTREE,
  INDEX `order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9330 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位销售单航段 信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_sales_billing
-- ----------------------------
DROP TABLE IF EXISTS `distribution_sales_billing`;
CREATE TABLE `distribution_sales_billing`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型：1 分销商充值 2 短信余量充值 3 分销商授信销账 4 分销商购票在线支付 5 保险支付 6 分期延时费  7 改签 8 退票  9 退款 10 订单补差',
  `business_type` tinyint(1) NULL DEFAULT NULL COMMENT '业务类型：1 计划位订单，2 团队订单，3 散客订单，4 其他',
  `external_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '欠款结算流水号',
  `dis_id` int NOT NULL DEFAULT 0 COMMENT '分销商id',
  `subject_id` int NOT NULL DEFAULT 0 COMMENT '资金科目id',
  `pay_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付金额',
  `pay_handling_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付手续费',
  `pay_handling_fee_ratio` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付手续费比例（单位：百分比）',
  `pay_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付方式：deposit 预付款支付，lines 授信额度支付，icbc 工行支付，deduction 抵扣，remittance 线下汇款，rcu 浙江农信',
  `pay_serial_number` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付流水号',
  `remittance_bank` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '汇款银行',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `operation_id` int NULL DEFAULT 0 COMMENT '审核操作人id',
  `operation_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核操作人名称',
  `billing_status` tinyint(1) NULL DEFAULT 1 COMMENT '下账状态：1 未下账，2 已下账',
  `billing_time` datetime NULL DEFAULT NULL COMMENT '下账时间',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_type`(`order_type` ASC) USING BTREE,
  INDEX `business_type`(`business_type` ASC) USING BTREE,
  INDEX `billing_status`(`billing_status` ASC) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61749 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销销售下账' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_sales_received
-- ----------------------------
DROP TABLE IF EXISTS `distribution_sales_received`;
CREATE TABLE `distribution_sales_received`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `order_type` tinyint NOT NULL DEFAULT 0 COMMENT '订单类型：1 分销商充值 2 短信余量充值 3 分销商授信销账 4 分销商购票在线支付 5 保险支付 6 分期延时费  7 改签 8 退票  9 退款 10 订单补差',
  `business_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '业务类型：1 计划位订单，2 团队订单，3 散客订单，4 其他',
  `external_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '欠款结算流水号',
  `dis_id` int NOT NULL DEFAULT 0 COMMENT '分销商id',
  `subject_id` int NOT NULL DEFAULT 0 COMMENT '资金科目id',
  `pay_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
  `pay_handling_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付手续费',
  `pay_handling_fee_ratio` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付手续费比例（单位：百分比）',
  `pay_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '支付方式：deposit 预付款支付，lines 授信额度支付，icbc 工行支付，deduction 抵扣，remittance 线下汇款，rcu 浙江农信',
  `pay_serial_number` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付流水号',
  `remittance_bank` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '汇款银行',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5471 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销销售实收' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_scattered_cancel
-- ----------------------------
DROP TABLE IF EXISTS `distribution_scattered_cancel`;
CREATE TABLE `distribution_scattered_cancel`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` char(52) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务订单号',
  `source_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '来源：1.销售单，2.改签单  3.退票单',
  `cancel_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '取消理由',
  `operation_id` int NULL DEFAULT NULL COMMENT '申请人id',
  `operation_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请人姓名',
  `operation_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 分销商  2员工',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `audit_status` tinyint(1) NULL DEFAULT 1 COMMENT '审核状态：1.待审核，2.审核通过，3.审核拒绝，',
  `audit_id` int NULL DEFAULT 0 COMMENT '审核人id',
  `audit_uname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核人名称',
  `audit_time` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `rejected_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 432 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '散客订单取消（未出票，正常单未出票之前可取消.改签退票未审核之前可取消）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_service_money
-- ----------------------------
DROP TABLE IF EXISTS `distribution_service_money`;
CREATE TABLE `distribution_service_money`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `service_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '服务费名称',
  `distribution_type_id` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销商类型(等级id)',
  `area_range` tinyint(1) NULL DEFAULT 1 COMMENT '1 国内 2国际',
  `age_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型 ADU成人 CHD儿童 INF 婴儿',
  `airline_recode_no` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司(全国类型为-1)',
  `dis_id` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销商id',
  `money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费金额',
  `refund_service` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票服务费',
  `change_service` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签服务费',
  `insurance_discount_rate` tinyint NULL DEFAULT 100 COMMENT '保险折扣率',
  `inter_dynamic` tinyint(1) NULL DEFAULT 0 COMMENT '国际是否动态服务费',
  `inter_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '国际服务费金额',
  `inter_refund_service` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '国际退票服务费',
  `inter_change_service` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '国际改签服务费',
  `inter_insurance_discount_rate` tinyint NULL DEFAULT 100 COMMENT '国际保险折扣率',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `area_range`(`area_range` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '服务费' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_sms_log`;
CREATE TABLE `distribution_sms_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '短信订单号',
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `operation_id` int NULL DEFAULT NULL COMMENT '操作人id',
  `operation_type` tinyint(1) NULL DEFAULT NULL COMMENT '操作类型：1 分销商  2 员工 ',
  `tel` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号码',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '短信内容',
  `billing_count` tinyint(1) NULL DEFAULT 1 COMMENT '计费条数',
  `msg_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '短信单价',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '短信收费金额',
  `failure_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '失败原因',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1待发送  2发送成功  3发送失败',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销短信发送记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_sms_record
-- ----------------------------
DROP TABLE IF EXISTS `distribution_sms_record`;
CREATE TABLE `distribution_sms_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sms_log_id` int NULL DEFAULT NULL,
  `order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `external_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `dis_id` int NULL DEFAULT NULL,
  `before_sms_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '操作前短信余额',
  `after_sms_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '操作后短信余额',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '变动金额',
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '1新增短信余额   2减少短信余额',
  `reamrk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '短信使用记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_team_audit
-- ----------------------------
DROP TABLE IF EXISTS `distribution_team_audit`;
CREATE TABLE `distribution_team_audit`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT 0,
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单',
  `is_audit` tinyint(1) NULL DEFAULT 1 COMMENT '1未审核   2已审核 3驳回',
  `number` int NULL DEFAULT NULL COMMENT '团队人数',
  `audit_type` tinyint(1) NULL DEFAULT NULL COMMENT '审核状态 1临时团审核   2团队人数修改审核',
  `rejected_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `rejected_at` datetime NULL DEFAULT NULL COMMENT '驳回时间',
  `audit_id` int NULL DEFAULT 0 COMMENT '审核人id',
  `audit_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核人名称',
  `audit_at` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 180 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '临时团审核表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_team_cash_pledge
-- ----------------------------
DROP TABLE IF EXISTS `distribution_team_cash_pledge`;
CREATE TABLE `distribution_team_cash_pledge`  (
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '临时团订单号',
  `serial_number` int NULL DEFAULT NULL COMMENT '序号(第几押)',
  `proportion` int NULL DEFAULT NULL COMMENT '比例',
  `end_time` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '截至时间(第几押时间)',
  `cash_pledge_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 面向客户  2面向航司',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  INDEX `plan_id|serial_number|end_time`(`order_no` ASC, `serial_number` ASC, `end_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '临时团 分期表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_team_flight_refund
-- ----------------------------
DROP TABLE IF EXISTS `distribution_team_flight_refund`;
CREATE TABLE `distribution_team_flight_refund`  (
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `starting_at` int NULL DEFAULT NULL COMMENT '起始时间 大于或等于起始时间  小时单位',
  `termination_at` int NULL DEFAULT NULL COMMENT '终止时间 小于终止时间 ',
  `refund_rate` int NULL DEFAULT NULL COMMENT '退款比例  正整数',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退票规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_wallet
-- ----------------------------
DROP TABLE IF EXISTS `distribution_wallet`;
CREATE TABLE `distribution_wallet`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT 0 COMMENT '分销商ID',
  `freeze_money` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '未出票支付了的冻结金额',
  `storage_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '分销商预存款',
  `frozen_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '预存款冻结金额（不用）',
  `pay_password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付密码',
  `dis_consume_credit` int UNSIGNED NULL DEFAULT 0 COMMENT '已分配的授信金额',
  `temporary_lines` int NULL DEFAULT NULL COMMENT '零时授信额度',
  `temporary_lines_at` timestamp NULL DEFAULT NULL COMMENT '零时授信额度时间',
  `credit_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '授信金额(余额)删除不用',
  `consume_credit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '已消费授信',
  `is_prohibit_credit` tinyint(1) NULL DEFAULT 2 COMMENT '是否禁止使用授信消费 1:正常 2:禁止',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ibe_search` int NULL DEFAULT 1000 COMMENT '剩余IBE查询余量',
  `msg_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '短信余额',
  `msg_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '短信单价单位元',
  `credit_day` tinyint UNSIGNED NULL DEFAULT 3 COMMENT '授信订单可逾期天数 单位天',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 452 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商钱包' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for distribution_wallet_log
-- ----------------------------
DROP TABLE IF EXISTS `distribution_wallet_log`;
CREATE TABLE `distribution_wallet_log`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT 0 COMMENT '分销商id',
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '订单类型 1分销商充值 2短信余量充值 3分销商授信销账 4分销商购票在线支付 5保险支付 6分期延时费  7改签 8.退票  9退款 10其他 11补差单',
  `business_type` tinyint(1) NULL DEFAULT NULL COMMENT '业务类型：1 计划位订单，2 团队订单，3 散客订单，4 其他',
  `has_frozen_status` tinyint(1) NULL DEFAULT 2 COMMENT '是否是冻结状态 1是  2否(计划位、临时团未出票前所有支付默认冻结包括线上支付 )默认为冻结状态',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '变动金额单位元',
  `before_storage_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '操作前预存款余额',
  `after_storage_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '操作后预存款余额',
  `before_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '操作前余额',
  `after_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '操作后余额',
  `before_freeze_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '使用前冻结金额',
  `after_freeze_money` decimal(10, 2) NULL DEFAULT NULL COMMENT '使用后冻结金额',
  `admin_id` int NULL DEFAULT NULL COMMENT '后台操作人员id',
  `order_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '平台订单号',
  `external_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付订单号',
  `staff_code` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '员工号',
  `before_wallet_data` json NULL COMMENT '操作前钱包数据',
  `after_wallet_data` json NULL COMMENT '操作后钱包数据',
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作ip地址 外网/内网',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `reamrk` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `group_ids` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客分组集合',
  `ticket_nos` varchar(1300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客票号集合',
  `passenger_names` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客姓名集合',
  `d_ports` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场集合',
  `a_ports` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场集合',
  `airlines` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司集合',
  `flights` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班集合',
  `dep_times` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间集合',
  `card_nos` varchar(1800) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号集合',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `un_dis_order_pay`(`dis_id` ASC, `order_no` ASC, `amount` ASC) USING BTREE COMMENT '唯一索引、防止重复支付'
) ENGINE = InnoDB AUTO_INCREMENT = 68474 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商钱包变动日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for domestic_auto_issue_rule
-- ----------------------------
DROP TABLE IF EXISTS `domestic_auto_issue_rule`;
CREATE TABLE `domestic_auto_issue_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则名称',
  `rule_type` tinyint NOT NULL COMMENT '规则类型,5=BOP,10=BSP,20=B2B,30=OP',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.启用，2.禁用',
  `effect_start_time` datetime NULL DEFAULT NULL COMMENT '生效开始时间',
  `effect_end_time` datetime NULL DEFAULT NULL COMMENT '生效结束时间',
  `sale_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售店铺：*所有，0,1,2,3逗号分割',
  `voyage_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航程类型：*所有，逗号分割',
  `passenger_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人类型：*所有，逗号分割',
  `notify_user_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '异常通知人员',
  `allow_airline_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '允许航司的配置信息',
  `forbid_airline_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '禁止航司的配置信息',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  `weight` int NOT NULL DEFAULT 0 COMMENT '权重',
  `ticket_chd` tinyint(1) NULL DEFAULT 3 COMMENT '是否可出儿童:1=不出;2=可出;3=不效验',
  `office_no` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `change_pnr` tinyint(1) NULL DEFAULT 0 COMMENT '是否换编',
  `change_pnr_type` tinyint(1) NULL DEFAULT 0 COMMENT '换编换舱类型:1=对内备注匹配,2=指定舱位,3=原始舱位',
  `change_pnr_rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '换编换舱规则',
  `ticket_cabin_rule` tinyint(1) NULL DEFAULT 1 COMMENT '出票舱位规则:1=同舱出票;2=可升舱/降舱出票',
  `ticket_cabin_change_type` tinyint(1) NULL DEFAULT 0 COMMENT '换舱类型:1=对内备注匹配,2=指定舱位',
  `ticket_cabin_change_rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `ticket_price_contrast` tinyint(1) NULL DEFAULT 1 COMMENT '价格对比类型:1=销售价;2=票面价',
  `ticket_loss` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付最大亏损金额',
  `ticket_profit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付最大盈利金额',
  `ticket_price_reduce` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票面最大可降金额',
  `ticket_error_option` tinyint(1) NULL DEFAULT 1 COMMENT '自动出票失败操作:1=转人工;2=换其他规则;3=转渠道出票',
  `ticket_channel` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '出票渠道信息',
  `is_min_price` tinyint(1) NULL DEFAULT 1 COMMENT '是否最低价出票-bspbop需要',
  `is_ticket_price` tinyint(1) NULL DEFAULT 1 COMMENT '是否按票面出票-bspbop需要',
  `ticket_counter` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票台-bspbop需要',
  `bsp_price` decimal(8, 2) NULL DEFAULT NULL COMMENT '价格，大于等于该值走bsp，小于走BOP-bspbop需要',
  `customer_id` int NULL DEFAULT 0 COMMENT '大客户id',
  `ticket_external` tinyint(1) NULL DEFAULT 0 COMMENT '是否关联订单出票 0=不出;1=可出',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status_index`(`status` ASC) USING BTREE,
  INDEX `effect_start_time_index`(`effect_start_time` ASC) USING BTREE,
  INDEX `effect_end_time_index`(`effect_end_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内自动出票规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for domestic_bsp_auto_issue_rule
-- ----------------------------
DROP TABLE IF EXISTS `domestic_bsp_auto_issue_rule`;
CREATE TABLE `domestic_bsp_auto_issue_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则名称',
  `rule_type` tinyint NULL DEFAULT 10,
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.启用，2.禁用',
  `effect_start_time` datetime NULL DEFAULT NULL COMMENT '生效开始时间',
  `effect_end_time` datetime NULL DEFAULT NULL COMMENT '生效结束时间',
  `sale_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售店铺：*所有，0,1,2,3逗号分割',
  `voyage_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航程类型：*所有，逗号分割',
  `passenger_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人类型：*所有，逗号分割',
  `notify_user_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '异常通知人员',
  `allow_airline_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '允许航司的配置信息',
  `forbid_airline_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '禁止航司的配置信息',
  `is_min_price` tinyint(1) NULL DEFAULT 1 COMMENT '是否最低价',
  `is_ticket_price` tinyint(1) NULL DEFAULT 1 COMMENT '是否按票面',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  `ticket_counter` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票台',
  `bsp_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格，大于等于该值走bsp，小于走BOP',
  `weight` int NOT NULL DEFAULT 0 COMMENT '权重',
  `ticket_chd` tinyint(1) NULL DEFAULT 3 COMMENT '是否可出儿童:1=不出;2=可出;3=不效验',
  `office_no` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `change_pnr` tinyint(1) NULL DEFAULT 0 COMMENT '是否换编',
  `change_pnr_type` tinyint(1) NULL DEFAULT 0 COMMENT '换编换舱类型:1=对内备注匹配,2=指定舱位,3=原始舱位',
  `change_pnr_rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '换编换舱规则',
  `ticket_cabin_rule` tinyint(1) NULL DEFAULT 1 COMMENT '出票舱位规则:1=同舱出票;2=可升舱/降舱出票',
  `ticket_cabin_change_type` tinyint(1) NULL DEFAULT 0 COMMENT '换舱类型:1=对内备注匹配,2=指定舱位',
  `ticket_cabin_change_rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '换舱规则',
  `ticket_price_contrast` tinyint(1) NULL DEFAULT 1 COMMENT '价格对比类型:1=销售价;2=票面价',
  `ticket_loss` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付最大亏损金额',
  `ticket_profit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付最大盈利金额',
  `ticket_price_reduce` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票面最大可降金额',
  `ticket_error_option` tinyint(1) NULL DEFAULT 1 COMMENT '自动出票失败操作:1=转人工;2=换其他规则;3=转渠道出票',
  `ticket_channel` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '出票渠道信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内BSP/BOP自动出票规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for domestic_op_auto_issue_rule
-- ----------------------------
DROP TABLE IF EXISTS `domestic_op_auto_issue_rule`;
CREATE TABLE `domestic_op_auto_issue_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则名称',
  `rule_type` tinyint NULL DEFAULT 30,
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.启用，2.禁用',
  `effect_start_time` datetime NULL DEFAULT NULL COMMENT '生效开始时间',
  `effect_end_time` datetime NULL DEFAULT NULL COMMENT '生效结束时间',
  `sale_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售店铺：*所有，0,1,2,3逗号分割',
  `voyage_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航程类型：*所有，逗号分割',
  `passenger_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人类型：*所有，逗号分割',
  `notify_user_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '异常通知人员',
  `allow_airline_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '允许航司的配置信息',
  `forbid_airline_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '禁止航司的配置信息',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  `weight` int NOT NULL DEFAULT 0 COMMENT '权重',
  `ticket_chd` tinyint(1) NULL DEFAULT 3 COMMENT '是否可出儿童:1=不出;2=可出;3=不效验',
  `office_no` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `change_pnr` tinyint(1) NULL DEFAULT 0 COMMENT '是否换编',
  `change_pnr_type` tinyint(1) NULL DEFAULT 0 COMMENT '换编换舱类型:1=对内备注匹配,2=指定舱位,3=原始舱位',
  `change_pnr_rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '换编换舱规则',
  `ticket_cabin_rule` tinyint(1) NULL DEFAULT 1 COMMENT '出票舱位规则:1=同舱出票;2=可升舱/降舱出票',
  `ticket_cabin_change_type` tinyint(1) NULL DEFAULT 0 COMMENT '换舱类型:1=对内备注匹配,2=指定舱位',
  `ticket_cabin_change_rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `ticket_price_contrast` tinyint(1) NULL DEFAULT 1 COMMENT '价格对比类型:1=销售价;2=票面价',
  `ticket_loss` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付最大亏损金额',
  `ticket_profit` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '支付最大盈利金额',
  `ticket_price_reduce` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票面最大可降金额',
  `ticket_error_option` tinyint(1) NULL DEFAULT 1 COMMENT '自动出票失败操作:1=转人工;2=换其他规则;3=转渠道出票',
  `ticket_channel` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '出票渠道信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status_index`(`status` ASC) USING BTREE,
  INDEX `effect_start_time_index`(`effect_start_time` ASC) USING BTREE,
  INDEX `effect_end_time_index`(`effect_end_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内OP自动出票规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for downgrade_after_ticket_rules
-- ----------------------------
DROP TABLE IF EXISTS `downgrade_after_ticket_rules`;
CREATE TABLE `downgrade_after_ticket_rules`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则名称',
  `effect_start_time` datetime NULL DEFAULT NULL COMMENT '生效开始时间',
  `effect_end_time` datetime NULL DEFAULT NULL COMMENT '失效截止时间',
  `sale_channel` int UNSIGNED NULL DEFAULT NULL COMMENT '销售渠道id',
  `policy_type_platform` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '自建平台政策类型：0 全部 1公转私 2公布运价 3私有运价',
  `voyage` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '适用航程：0 全部 1 往返，2 单程，3 连程',
  `air_line_code` json NULL COMMENT '航司,格式{\"include\":[\"3U\",\"8C\",\"8L\",\"9C\"],\"exclude\":[\"9h\",\"AQ\",\"A6\"]}',
  `cabin` json NULL COMMENT '舱位,格式{\"include\":[\"U\",\"9\",\"I\",\"Y\"],\"exclude\":[\"Z\",\"P\",\"C\"]}',
  `start_place` json NULL COMMENT '始发地,格式{\"include\":[\"DGG\",\"CLO\",\"UCT\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `road_place` json NULL COMMENT '途径地,格式{\"include\":[\"DGG\",\"CLO\",\"CLO\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `end_place` json NULL COMMENT '目的地,格式{\"include\":[\"DGG\",\"CLO\",\"CLO\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `scan_start_time` time NULL DEFAULT NULL COMMENT '扫描开始时间',
  `scan_end_time` time NULL DEFAULT NULL COMMENT '扫描结束时间',
  `scan_interval_time` int UNSIGNED NULL DEFAULT NULL COMMENT '扫描间隔时间（单位：秒）',
  `auto_ticket_issuance` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否自动出票：0 否，1 是',
  `that_day_ticket_difference_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '当日出票差价',
  `not_that_day_ticket_difference_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '非当日出票差价',
  `amount_below_difference_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '低于差价X自动出票（单位：元）',
  `latest_departure_time` int UNSIGNED NULL DEFAULT NULL COMMENT '临近起飞时间前X退出扫描（单位：秒）',
  `less_than_difference_price_notice` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '扫描低于差价X通知（单位：元）',
  `sms_notification_mobiles` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '短信通知手机号，格式：13800138000,13800138001',
  `sms_notification_start_time` time NULL DEFAULT NULL COMMENT '短信通知开始时间',
  `sms_notification_end_time` time NULL DEFAULT NULL COMMENT '短信通知结束时间',
  `sms_notice` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '短信通知：0 否，1 是',
  `dingtalk_notice` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '钉钉通知：0 否，1 是',
  `sort` int UNSIGNED NULL DEFAULT 0 COMMENT '规则优先级',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态：0 禁用，1 启用',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出票后降舱规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for downgrade_after_ticket_rules_logs
-- ----------------------------
DROP TABLE IF EXISTS `downgrade_after_ticket_rules_logs`;
CREATE TABLE `downgrade_after_ticket_rules_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dtr_id` int UNSIGNED NULL DEFAULT NULL COMMENT '降舱出票规则记录id',
  `type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '操作类型：1 新增，2 修改，3 删除',
  `operator` int UNSIGNED NULL DEFAULT NULL COMMENT '操作人id',
  `data_before_update` json NULL COMMENT '更新前数据',
  `data_after_update` json NULL COMMENT '更新后数据',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出票后降舱规则更变日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for downgrade_scan_logs
-- ----------------------------
DROP TABLE IF EXISTS `downgrade_scan_logs`;
CREATE TABLE `downgrade_scan_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `type` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '扫描规则类型：1 降舱出票，2 出票后降舱',
  `ticket_type` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '出票类型：0 未出票，1 自动出票，2 通知人工出票',
  `downgrading_status` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '降舱状态:1=降舱出票扫描中,2=降舱降价,3=降舱,4=降价,5=人工出票,6=规则已禁用,7=异常（出票前）',
  `rule_id` int UNSIGNED NULL DEFAULT NULL COMMENT '扫描规则id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台内部单号',
  `order_sale_settle_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '进单价',
  `purchase_settle_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '出票价',
  `last_settle_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '本次查询价',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 78712 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '降舱出票扫描日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for downgrade_ticket_order
-- ----------------------------
DROP TABLE IF EXISTS `downgrade_ticket_order`;
CREATE TABLE `downgrade_ticket_order`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台内部单号',
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '订单类型:1=降舱出票订单,2=出票后降舱订单',
  `rule_id` int NOT NULL DEFAULT 0 COMMENT '规则id',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态:1=降舱出票扫描中,2=降舱降价,3=降舱,4=降价,5=人工出票,6=规则已禁用,7=异常（出票前）',
  `validity_time` datetime NULL DEFAULT NULL COMMENT '降舱订单有效期',
  `pnr_validity_time` datetime NULL DEFAULT NULL COMMENT 'pnr有效时间',
  `price_validity_time` datetime NULL DEFAULT NULL COMMENT '运价有效时间',
  `order_sale_ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售票面价',
  `order_sale_tax_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售税费',
  `order_sale_settle_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售结算价',
  `last_ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最新销售票面价',
  `last_tax_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最新销售税费',
  `last_settle_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最新销售结算价',
  `price_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '票价数据',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1420 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '降舱出票订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for downgrade_ticket_rules
-- ----------------------------
DROP TABLE IF EXISTS `downgrade_ticket_rules`;
CREATE TABLE `downgrade_ticket_rules`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则名称',
  `effect_start_time` datetime NULL DEFAULT NULL COMMENT '生效开始时间',
  `effect_end_time` datetime NULL DEFAULT NULL COMMENT '失效截止时间',
  `sale_channel` int UNSIGNED NULL DEFAULT NULL COMMENT '销售渠道id',
  `policy_type_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '自建平台政策类型：0 全部 1公转私 2公布运价 3私有运价，多个以英文逗号隔开',
  `voyage` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '适用航程：0 全部 1 往返，2 单程，3 连程',
  `air_line_code` json NULL COMMENT '航司,格式{\"include\":[\"3U\",\"8C\",\"8L\",\"9C\"],\"exclude\":[\"9h\",\"AQ\",\"A6\"]}',
  `cabin` json NULL COMMENT '舱位,格式{\"include\":[\"U\",\"9\",\"I\",\"Y\"],\"exclude\":[\"Z\",\"P\",\"C\"]}',
  `start_place` json NULL COMMENT '始发地,格式{\"include\":[\"DGG\",\"CLO\",\"UCT\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `road_place` json NULL COMMENT '途径地,格式{\"include\":[\"DGG\",\"CLO\",\"CLO\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `end_place` json NULL COMMENT '目的地,格式{\"include\":[\"DGG\",\"CLO\",\"CLO\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `scan_start_time` time NULL DEFAULT NULL COMMENT '扫描开始时间',
  `scan_end_time` time NULL DEFAULT NULL COMMENT '扫描结束时间',
  `scan_interval_time` int UNSIGNED NULL DEFAULT NULL COMMENT '扫描间隔时间（单位：秒）',
  `auto_ticket_issuance` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否自动出票：0 否，1 是',
  `amount_below_purchase_price` decimal(10, 2) UNSIGNED NULL DEFAULT NULL COMMENT '低于进单采购价X自动出票（单位：元）',
  `latest_ticket_issuance_time` int UNSIGNED NULL DEFAULT NULL COMMENT '临近最晚出票时限前X自动出票（单位：秒）',
  `notification_maximum_amount` decimal(10, 2) UNSIGNED NULL DEFAULT NULL COMMENT '扫描低于进单采购价X通知（单位：元）',
  `sms_notification_mobiles` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '短信通知手机号，格式：13800138000,13800138001',
  `sms_notification_start_time` time NULL DEFAULT NULL COMMENT '短信通知开始时间',
  `sms_notification_end_time` time NULL DEFAULT NULL COMMENT '短信通知结束时间',
  `sms_notice` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '短信通知：0 否，1 是',
  `dingtalk_notice` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '钉钉通知：0 否，1 是',
  `occupied_or_not` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '占位是否占编：0 否，1 是',
  `sort` int UNSIGNED NULL DEFAULT 0 COMMENT '规则优先级',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态：0 禁用，1 启用',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `delay_times` tinyint NULL DEFAULT -1 COMMENT '-1为不限制，其他为PNR延时次数',
  `office_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `time_limit_type` tinyint(1) NULL DEFAULT 1 COMMENT '时限类型',
  `ota_time_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota扫描规则',
  `dep_day_start` int NULL DEFAULT 0 COMMENT '起飞天数开始',
  `dep_day_end` int NULL DEFAULT 0 COMMENT '起飞天数结束',
  `exclude_date` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '排除日期',
  `cabin_match_type` tinyint(1) NULL DEFAULT 1 COMMENT '舱位匹配模式,1=全部,2=仅国际大段',
  `work_time_start` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '00:00' COMMENT '工作开始时间',
  `work_time_end` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '23:59' COMMENT '工作结束时间',
  `change_cabin_type` tinyint(1) NULL DEFAULT 1 COMMENT '换舱方式',
  `downgrade_match_type` tinyint(1) NULL DEFAULT 1 COMMENT '调出方式',
  `scan_time_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时间区间扫描规则',
  `notification_maximum_minute` int NULL DEFAULT 45 COMMENT '扫描低于进单采购价X分钟通知（单位：分钟）',
  `down_price` int NULL DEFAULT 20 COMMENT '降价标准',
  `tomorrow_gt_price_amount` int NULL DEFAULT 0 COMMENT '明日价格大于票面价X元',
  `tomorrow_gt_price_time` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '23:30' COMMENT '大于x元在xx:xx调出',
  `tomorrow_gt_down_price_amount` int NULL DEFAULT NULL COMMENT '降价价格大于次日价格X元',
  `tomorrow_gt_down_price_time` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '23:30' COMMENT '大于x元在xx:xx调出',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '降舱出票规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for downgrade_ticket_rules_logs
-- ----------------------------
DROP TABLE IF EXISTS `downgrade_ticket_rules_logs`;
CREATE TABLE `downgrade_ticket_rules_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dtr_id` int UNSIGNED NULL DEFAULT NULL COMMENT '降舱出票规则记录id',
  `type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '操作类型：1 新增，2 修改，3 删除',
  `operator` int UNSIGNED NULL DEFAULT NULL COMMENT '操作人id',
  `data_before_update` json NULL COMMENT '更新前数据',
  `data_after_update` json NULL COMMENT '更新后数据',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '降舱出票规则更变日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for download
-- ----------------------------
DROP TABLE IF EXISTS `download`;
CREATE TABLE `download`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下载类型(数据来源)',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下载地址',
  `param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '参数',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态 0正在导出  1导出完成  -1导出失败  2下载完成  ',
  `reason` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '导出失败原因',
  `operator` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `task` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务id',
  `cur` int NULL DEFAULT 0 COMMENT '当前数据生成条数',
  `count` int NULL DEFAULT 0 COMMENT '总数据条数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13117 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_bill_adjustment
-- ----------------------------
DROP TABLE IF EXISTS `dp_bill_adjustment`;
CREATE TABLE `dp_bill_adjustment`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL DEFAULT 0 COMMENT '账单ID',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1. 补差，2.调账，3对账',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售单号',
  `ticket_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `channel_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '渠道类型：1.销售，2.采购',
  `order_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '订单类型：1.正常单，2.改签单，3.退票单',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调账金额',
  `remark` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '调整备注',
  `purchase_platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购渠道_office号',
  `office_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'office_no',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `operator_id` int NOT NULL COMMENT '操作人ID',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `bill_checked_at` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作人姓名',
  `adjusted_need_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整的应收应付应退金额',
  `adjusted_paid_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整的实收实付实退金额',
  `adjusted_need_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整后的应收应付应退总金额',
  `adjusted_paid_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整后的实收实付实退总金额',
  `adjusted_diff_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调整后的差异总金额',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账, 6.销账',
  `is_diff_bill` tinyint NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `is_bad_bill` tinyint NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index`(`order_no` ASC, `ticket_no` ASC, `purchase_platform` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14256 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '账单调账/补差表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_bill_change_domestic_ota
-- ----------------------------
DROP TABLE IF EXISTS `dp_bill_change_domestic_ota`;
CREATE TABLE `dp_bill_change_domestic_ota`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `applied_at` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `old_change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签订单号',
  `change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签订单号',
  `external_sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'OTA订单号',
  `external_change_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'OTA改签单号',
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-销售订单号',
  `passenger_age_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT ' 乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `sale_store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `old_take_off_time` datetime NULL DEFAULT NULL COMMENT '原-改签前起飞时间',
  `old_pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-pnr',
  `old_ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签前票号',
  `old_company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-航司二字码',
  `old_flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签前航班',
  `old_freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签前仓位',
  `old_voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原-改签前航程',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '改签后起飞时间',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后票号',
  `company_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后仓位',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签后航程',
  `sale_subject_id` int NULL DEFAULT NULL COMMENT '销售科目',
  `purchase_subject_id` int NULL DEFAULT NULL COMMENT '采购科目',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生编office号',
  `old_sale_receivable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '原—销售应收票面价',
  `sale_receivable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收票面价',
  `sale_receivable_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收税金总金额（机建+燃油）',
  `sale_price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售票税差',
  `sale_receivable_renewal_fee` decimal(10, 2) NOT NULL COMMENT '销售应收改签手续费',
  `sale_receivable_service_fee` decimal(10, 2) NOT NULL COMMENT '销售应收改签服务费',
  `sale_receivable_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收其它费用',
  `sale_receivable_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收总金额（销售票税差+销售应收改签手续费+销售应收改签服务费+销售应收其它费用）',
  `sale_collection_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实收总金额(ota平台改签实收金额)',
  `sale_collection_total_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售实收差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账，6销账',
  `sale_is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `sale_is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `sale_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '销售对账时间',
  `sale_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售下账人',
  `old_purchase_payable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '原-采购应付票面价',
  `purchase_payable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应付票面价',
  `purchase_payable_ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付税金总金额（机建+燃油）',
  `purchase_price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购票税差',
  `purchase_payable_renewal_fee` decimal(10, 2) NOT NULL COMMENT '采购应付改签手续费',
  `purchase_payable_service_fee` decimal(10, 2) NOT NULL COMMENT '采购应付改签服务费',
  `purchase_payable_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付其它费用',
  `purchase_payable_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应付金额（采购票税差+采购应付改签手续费+采购应付改签服务费+采购应付其它费用）',
  `purchase_payment_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实付金额',
  `purchase_payment_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实付差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '采购状态：1.待对账，2.已对账,6.销账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否坏账:0.不是，1.是',
  `purchase_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '采购对账时间',
  `purchase_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购下账人',
  `gross_profit_receivable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售毛利（销售应收总金额-采购应付金额）',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NOT NULL,
  `complete_time` datetime NULL DEFAULT NULL COMMENT '改签完成时间',
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `purchase_issue_bill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '交易流水号',
  `op_purchase_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'op采购账号',
  `sale_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-预算调整',
  `sale_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-收款调整',
  `purchase_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-预算调整',
  `purchase_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-付款调整',
  `operator_id` int NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 513 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务对账报表改签单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_bill_import_record_details
-- ----------------------------
DROP TABLE IF EXISTS `dp_bill_import_record_details`;
CREATE TABLE `dp_bill_import_record_details`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `record_id` int NOT NULL DEFAULT 0 COMMENT '导入记录id',
  `channel_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1.销售账单，2.采购账单',
  `order_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型：1.出票，2.改签，3.退票',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1.未匹配，2.已对账，3.异常',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '自建平台订单号',
  `issue_bill_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三放平台账单单号',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号,多个票号逗号分隔',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '总金额',
  `is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为差异订单：0:否，1.是',
  `operator_id` int NOT NULL DEFAULT -1 COMMENT '操作人：-1:系统，否者用户',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `messages` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志信息\r\n日志信息',
  `bill_checked_at` datetime NULL DEFAULT NULL COMMENT '对账时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40610 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入记录详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_bill_import_records
-- ----------------------------
DROP TABLE IF EXISTS `dp_bill_import_records`;
CREATE TABLE `dp_bill_import_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `channel_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1.销售账单，2.采购账单',
  `channel_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售/采购渠道',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件地址',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `total_number` int NOT NULL DEFAULT 0 COMMENT '统计数',
  `no_diff_number` int NOT NULL DEFAULT 0 COMMENT '对账数（无差异）',
  `diff_number` int NOT NULL DEFAULT 0 COMMENT '差异数',
  `unmatched` int NOT NULL DEFAULT 0 COMMENT '未匹配数',
  `unusual` int NOT NULL DEFAULT 0 COMMENT '状态异常',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 468 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_bill_normal_domestic_ota
-- ----------------------------
DROP TABLE IF EXISTS `dp_bill_normal_domestic_ota`;
CREATE TABLE `dp_bill_normal_domestic_ota`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sale_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售订单号',
  `external_sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ota平台出票订单单号',
  `dp_purchase_order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购订单号',
  `external_purchase_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '第三方采购订单号',
  `purchase_issue_bill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '交易流水号',
  `op_purchase_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'op采购账号',
  `issue_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` datetime NULL DEFAULT NULL COMMENT '抵达时间',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `policy_code` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '政策代码',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_age_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT ' 乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '仓位',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `sale_store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `gross_profit_receivable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售毛利（应收-应付）',
  `sale_receivable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收票面价',
  `sale_receivable_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收税金总金额（机建+燃油）',
  `sale_receivable_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应收金额',
  `sale_collection_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实收金额',
  `sale_collection_total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实收差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '销售状态：1.待对账，2.已对账, 6.销账',
  `sale_is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '销售是否差异账单：0.正常，1.差异',
  `sale_is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '销售是否坏账:0.不是，1.是',
  `sale_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '销售对账时间',
  `sale_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售下账人',
  `purchase_payable_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应付票面价',
  `purchase_payable_ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付税金总金额（机建+燃油）',
  `purchase_payable_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应付金额',
  `purchase_payment_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实付金额',
  `purchase_payment_diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购实付差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '采购状态：1.待对账，2.已对账,6.销账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否坏账:0.不是，1.是',
  `purchase_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '采购对账时间',
  `purchase_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购下账人',
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime NOT NULL COMMENT '账单创建时间',
  `updated_at` datetime NOT NULL,
  `sale_subject_id` int NULL DEFAULT NULL COMMENT '销售科目',
  `purchase_subject_id` int NULL DEFAULT NULL COMMENT '采购科目',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生编office号',
  `sale_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-预算调整',
  `sale_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-收款调整',
  `purchase_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-预算调整',
  `purchase_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-付款调整',
  `operator_id` int NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  `after_rebate_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '后返金额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_order_no_index`(`sale_order_no` ASC) USING BTREE,
  INDEX `purchase_status_index`(`purchase_status` ASC) USING BTREE,
  INDEX `ticket_no_index`(`ticket_no` ASC) USING BTREE,
  INDEX `external_sale_order_no_index`(`external_sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24847 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务对账报表正常单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_bill_order_log
-- ----------------------------
DROP TABLE IF EXISTS `dp_bill_order_log`;
CREATE TABLE `dp_bill_order_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '操作内容',
  `user_id` int NULL DEFAULT NULL COMMENT '操作人',
  `order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `order_type` tinyint NULL DEFAULT NULL COMMENT '订单类型  2：改签单  3：退票单',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 125728 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单 退票单流转日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_bill_return_domestic_ota
-- ----------------------------
DROP TABLE IF EXISTS `dp_bill_return_domestic_ota`;
CREATE TABLE `dp_bill_return_domestic_ota`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `applied_at` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `first_audit_uid` int NULL DEFAULT NULL COMMENT '一审人 (账单生成时间)',
  `first_audited_at` datetime NULL DEFAULT NULL COMMENT '一审时间',
  `recheck_audit_uid` int NULL DEFAULT NULL COMMENT '复审人',
  `recheck_audited_at` datetime NULL DEFAULT NULL COMMENT '复审时间',
  `submitted_at` datetime NULL DEFAULT NULL COMMENT '已提交时间',
  `source_type` tinyint(1) NULL DEFAULT 1 COMMENT '\'退废来源  1 销售单退废 2改签单退废\'',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台销售单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `external_refund_order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'OTA退票单号',
  `ota_sign_hash` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单哈希标识',
  `passenger_age_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT ' 乘机人类型  ADU:成人 CHD:儿童 INF:婴儿 STU: 学生',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `sale_store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道',
  `sale_subject_id` int NULL DEFAULT 0 COMMENT '销售科目',
  `purchase_subject_id` int NULL DEFAULT 0 COMMENT '采购科目',
  `pnr` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'pnr',
  `ticket_no` varchar(59) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程',
  `flight` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `freight_space` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '仓位',
  `take_off_time` datetime NULL DEFAULT NULL COMMENT '起飞时间',
  `sale_refund_type` tinyint(1) NULL DEFAULT 1 COMMENT '退废类型 1退票 2废票',
  `sale_refund_idea_type` tinyint(1) NULL DEFAULT 1 COMMENT '自愿退废  1 是  2 否',
  `sale_refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票原因',
  `sale_expected_refund_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应退票面价',
  `sale_expected_refund_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应退税金金额',
  `sale_receivable_renewal_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收手续费',
  `sale_receivable_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收服务费',
  `sale_receivable_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应收其它费用',
  `sale_expected_refund_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售应退总金额（应退票面价+应退税金金额-销售应收手续费-销售应收服务费-销售应收其它费用）',
  `sale_actual_refund_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实退总金额',
  `sale_actual_refund_total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售实退差异金额',
  `sale_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1.待对账，2.已对账，6销账',
  `sale_is_diff_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否差异账单：0.正常，1.差异',
  `sale_is_bad_bill` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否坏账:0.不是，1.是',
  `sale_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '销售对账时间',
  `sale_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售下账人',
  `purchase_refund_type` tinyint(1) NULL DEFAULT 1 COMMENT '退废类型 1退票 2废票',
  `purchase_refund_idea_type` tinyint(1) NULL DEFAULT 1 COMMENT '自愿退废  1 是  2 否',
  `purchase_expected_refund_ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应退票面价',
  `purchase_expected_refund_ticket_tax_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应退税金金额',
  `purchase_payable_renewal_fee` decimal(10, 2) NOT NULL COMMENT '采购应付手续费',
  `purchase_payable_service_fee` decimal(10, 2) NOT NULL COMMENT '采购应付服务费',
  `purchase_payable_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付其它费用',
  `purchase_payable_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应付代理费',
  `purchase_expected_refund_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购应退总金额（应退票面价+应退税金金额-采购应收手续费-采购应收服务费-采购应收其它费用-采购应付代理费）',
  `purchase_expected_aircom_refund_total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购航司应退总金额（人工提交应退价格）',
  `purchase_actual_refund_total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购实退总金额',
  `purchase_actual_refund_total_diff_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购实退差异金额',
  `purchase_status` tinyint(1) NULL DEFAULT 1 COMMENT '采购状态：1.待对账，2.已对账,6.销账',
  `purchase_is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否差异账单：0.正常，1.差异',
  `purchase_is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '采购是否坏账:0.不是，1.是',
  `purchase_bill_checked_at` datetime NULL DEFAULT NULL COMMENT '采购对账时间',
  `purchase_bill_check_operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购下账人',
  `gross_profit_receivable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售毛利（采购应退总金额-销售应退总金额）',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NOT NULL,
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `purchase_issue_bill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '交易流水号',
  `op_purchase_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'op采购账号',
  `sale_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-预算调整',
  `sale_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售-收款调整',
  `purchase_budget_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-预算调整',
  `purchase_account_receipt_adjustment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购-付款调整',
  `purchase_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '生编office号',
  `operator_id` int NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3449 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务对账报表退废单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_bill_statistical_purchase_profit_voyage
-- ----------------------------
DROP TABLE IF EXISTS `dp_bill_statistical_purchase_profit_voyage`;
CREATE TABLE `dp_bill_statistical_purchase_profit_voyage`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `d_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '开始机场三字码',
  `a_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '结束机场三字码',
  `port_str` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航程中文名',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 977 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '利润统计 航程中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_cost
-- ----------------------------
DROP TABLE IF EXISTS `dp_cost`;
CREATE TABLE `dp_cost`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_id` int NOT NULL DEFAULT 0 COMMENT '计划位id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '标题',
  `aviation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航司二字码',
  `voyage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航程',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总金额',
  `aviation_refund` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '航司应退金额',
  `frozen_gold` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '冻结金',
  `ticket_money` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票款',
  `is_issue_ticket` tinyint(1) NOT NULL DEFAULT 2 COMMENT '是否出票 2:未出票 1:已出票',
  `is_transfer_ticket_money` tinyint(1) NULL DEFAULT 2 COMMENT '是否转票款  2：否 1：是',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '成本管理主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_cost_detailed
-- ----------------------------
DROP TABLE IF EXISTS `dp_cost_detailed`;
CREATE TABLE `dp_cost_detailed`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT ' ',
  `cost_id` int NOT NULL DEFAULT 0 COMMENT '成本管理id',
  `type` tinyint NOT NULL DEFAULT 1 COMMENT '类型 1：押金 2：罚金 3：其他',
  `project` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '类型具体项目名',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '流水号',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '金额',
  `remark` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `subject_id` int NULL DEFAULT 0 COMMENT '支付科目',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '成本管理明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_cost_log
-- ----------------------------
DROP TABLE IF EXISTS `dp_cost_log`;
CREATE TABLE `dp_cost_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cost_id` int NULL DEFAULT NULL COMMENT '成本管理ID',
  `plan_id` int NOT NULL DEFAULT 0 COMMENT '计划位ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '异动内容',
  `type` tinyint NULL DEFAULT NULL COMMENT '1：常规日志 2：异常日志',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作人',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_difference_order
-- ----------------------------
DROP TABLE IF EXISTS `dp_difference_order`;
CREATE TABLE `dp_difference_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL COMMENT '补差类型：1.ADM，2.补退，3.奖励',
  `pay_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '支付类型：1.补收，2补退',
  `is_pay` tinyint(1) NOT NULL COMMENT '是否支付：1待支付，2已支付，3支付失败',
  `pay_external_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付流水号',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '补差金额：+收客户钱，-补客户钱',
  `dis_id` int NOT NULL COMMENT '分销商ID',
  `order_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `is_audit` tinyint(1) NULL DEFAULT 1 COMMENT '审核状态：1已审核  2未审核  3审核失败',
  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销补差订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_change_order
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_change_order`;
CREATE TABLE `dp_distribution_change_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '1国内订单  2国际订单',
  `dp_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台改签单号',
  `change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端/OTA改签单号',
  `last_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销端上次改签单号',
  `sale_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售单号',
  `external_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'OTA订单号',
  `source_type` tinyint(1) NOT NULL COMMENT '来源：1.销售单，2.改签单',
  `flight_way` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '1往返 2单程 3联程 4缺口程 5多程',
  `status` tinyint(1) NOT NULL COMMENT '改签单扭转状态：1 待审核，2 改签中，3 改签成功, 5 改签驳回，6 取消改签，7 取消改签待审核',
  `reason_type` tinyint(1) NOT NULL COMMENT '改签原因：1.普通自愿改签，2.非自愿',
  `change_type` tinyint(1) NOT NULL COMMENT '改签类型：1.改期，2.升舱，3.更改航程，4.其它',
  `cancel_type` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '取消改签类型：1 自建平台主动取消，2 分销端取消',
  `pid` int NULL DEFAULT NULL COMMENT '改签单改期时，所属改签单id',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签原因',
  `a_pid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所有的父级id，逗号分隔',
  `file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '非自愿改签文件路径',
  `operation_id` int NULL DEFAULT NULL COMMENT '申请人id',
  `operation_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请人姓名',
  `operation_type` tinyint(1) NULL DEFAULT NULL COMMENT '1 分销商  2员工',
  `dis_id` int NULL DEFAULT 0 COMMENT '分销商id',
  `pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `contact_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人姓名',
  `contact_mobile_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人手机号',
  `contact_email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人邮箱',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `audit_uid` int NULL DEFAULT NULL COMMENT '审核人',
  `audit_uname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核人名称',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `aerial_change` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1:发生航变标记  0:未发生标记',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '改签完成时间',
  `ticket_agent_id` int NULL DEFAULT 0 COMMENT '出票人id',
  `ticket_agent_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票人名称',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `sale_platform` tinyint NULL DEFAULT 0 COMMENT '销售渠道ID',
  `sale_store_id` tinyint NULL DEFAULT 0 COMMENT '销售店铺ID',
  `is_retain` tinyint NULL DEFAULT 2 COMMENT '是否留单：1.是，2.否',
  `deadline_to_hold_an_order` datetime NULL DEFAULT NULL COMMENT '留单截止时间',
  `supplementary_discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '补收优惠金额',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `refund_method` tinyint(1) NULL DEFAULT 1 COMMENT '退费方法,1=原路退;2=银行卡;3=原路退+银行卡',
  `is_split` tinyint(1) NULL DEFAULT 0 COMMENT '拆单 0 否 1 是',
  `parent_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拆单父改签单号',
  `ota_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota拉单时状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `dp_change_order_no_index`(`dp_change_order_no` ASC) USING BTREE,
  INDEX `external_order_no_index`(`external_order_no` ASC) USING BTREE,
  INDEX `status_index`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1868 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_change_order_logs
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_change_order_logs`;
CREATE TABLE `dp_distribution_change_order_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dp_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端改签单号',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '改签单扭转状态：1 待审核，2 改签中，3 改签成功, 5 改签驳回，6 取消改签，7 取消改签待审核',
  `audit_status` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '审核状态：1.审核通过，2.审核拒绝',
  `denial_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `operator` int NOT NULL COMMENT '操作人id',
  `operator_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4960 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_change_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_change_order_relation`;
CREATE TABLE `dp_distribution_change_order_relation`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `ddc_passenger_id` int NOT NULL COMMENT '出行人id',
  `ddc_sequence_id` int NOT NULL COMMENT '航段id',
  `dp_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台改签单号',
  `change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端改签单号',
  `sale_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端正常销售单业务订单号',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2099 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_change_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_change_passenger_info`;
CREATE TABLE `dp_distribution_change_passenger_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dp_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台采购单号',
  `change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端改签单号',
  `sale_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端正常销售单业务订单号',
  `ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `old_ticket_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧票号',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '售卖价(不含改签服务费、改签费)',
  `old_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '旧票价',
  `change_fees` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费',
  `change_service_fees` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签服务费',
  `tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向用户机建费',
  `fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向用户机燃油费',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用',
  `supplementary_discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '补收优惠金额',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票单号和 主体出票单主体单号一致',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '乘机人姓名',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ADU成人 CHD儿童 INF 婴儿',
  `is_adult_ticket_for_child` tinyint(1) NULL DEFAULT NULL COMMENT '儿童订成人票标识  1 是 2否',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `ticket_diff_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '票差',
  `change_total_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '改签总费',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `ota_sale_data` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'OTA销售数据',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `dp_change_order_no_index`(`dp_change_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2273 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_change_sequence
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_change_sequence`;
CREATE TABLE `dp_distribution_change_sequence`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dp_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台改签单号',
  `change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端改签单号',
  `sale_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端销售业务订单号',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班',
  `a_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场航站楼',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达城市代码',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场代码',
  `a_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场名称',
  `d_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞城市名称',
  `d_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场代码',
  `d_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场名称',
  `d_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场航站楼',
  `other_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '其他费用',
  `price_differential` decimal(10, 2) NULL DEFAULT NULL COMMENT '舱位差价',
  `change_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '改签费用',
  `change_service_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '改签服务费',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司二字码',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `take_off_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞时间',
  `arrival_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达时间',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `class` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大舱位',
  `sub_class` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `adult_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '成人票面价',
  `adult_sale_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '成人销售价',
  `children_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '儿童票面价',
  `children_sale_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '儿童销售价',
  `baby_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '婴儿票面价',
  `baby_sale_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '婴儿销售价',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `type` tinyint NULL DEFAULT 1 COMMENT '类型：1新航段，2旧航段',
  `old_sequence_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '旧航段信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `dp_change_order_no_index`(`dp_change_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1521 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单航段信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_order
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_order`;
CREATE TABLE `dp_distribution_order`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '订单来源 1国内订单  2国际订单',
  `dis_id` int NULL DEFAULT 0 COMMENT '分销商id',
  `operation_type` int NULL DEFAULT 0 COMMENT '操作类型：1 分销商  2 员工 3 Booking手工单 4 OTA订单',
  `is_team` tinyint(1) NULL DEFAULT 0 COMMENT '是否是团队订单',
  `is_customer` tinyint(1) NULL DEFAULT 0 COMMENT '是否是大客户订单',
  `is_gp` tinyint(1) NULL DEFAULT 0 COMMENT '是否是gp订单',
  `operation_id` int NULL DEFAULT 0 COMMENT '操作人id',
  `source_platform` tinyint(1) NOT NULL DEFAULT 1 COMMENT '来源平台，1pc、2小程序',
  `business_type` tinyint NULL DEFAULT 3 COMMENT '1、计划位订单 2、团队位订单 3、散客订单',
  `external_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '外部订单号',
  `external_related_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '外部订单号的关联订单号',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务单号',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总价格（人数*票面价+基建+燃油）',
  `ticket_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '成人单人票面价(不含任何税费、包括机建燃油)\r\n计划位 ：包含加减比例单价  不包含机建、燃油费等\r\n散客：票面价   不包含机建、燃油费等\r\n临时团：票面价   不包含机建、燃油费等',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'OTA 成人单人销售票面价',
  `children_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童票面价(不含任何税费、包括机建燃油)',
  `sale_children_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'OTA 儿童单人销售票面价',
  `baby_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿单人票面价(不含任何税费、包括机建燃油)',
  `sale_baby_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'OTA 婴儿单人销售票面价',
  `person_nums` int NOT NULL DEFAULT 0 COMMENT '团队人数（确认名单后成人数量或者确认名单前人员数量）',
  `adult_number` int NULL DEFAULT 0 COMMENT '成人数量',
  `children_number` int NULL DEFAULT 0 COMMENT '儿童数量',
  `baby_nums` int NULL DEFAULT 0 COMMENT '婴儿数量（确认名单后婴儿数量）',
  `adult_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人机建费',
  `adult_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人燃油费',
  `children_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费',
  `order_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '主订单状态1:待出票 2:出票中 3:待回填 4：已回填 5:回填失败 6:出票失败 7:取消订单 8:取消订单待审核',
  `auto_ticket_error` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自动出票错入信息',
  `flight_type` tinyint(1) NULL DEFAULT 2 COMMENT '1往返 2单程 3联程 4缺口程 5多程',
  `reamrk` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对外备注',
  `our_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对内备注',
  `contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系手机',
  `tel` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系座机',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系邮箱',
  `ticket_type` tinyint(1) NULL DEFAULT 1 COMMENT '出票方式：1.手工出票，2.自动出票',
  `ticket_agent_id` int NULL DEFAULT 0 COMMENT '出票工作人员',
  `pnr` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'PNR',
  `old_pnr` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧PNR',
  `recode_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `old_recode_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧航司大编码',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `child_issue_chd_ticket` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 儿童出成人票 2儿童出儿童票\',',
  `order_time` datetime NULL DEFAULT NULL COMMENT '下单时间',
  `payment_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `payment_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
  `department_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '部门id',
  `sale_platform` int NOT NULL DEFAULT 0 COMMENT '销售渠道ID',
  `sale_store_id` int NOT NULL DEFAULT 0 COMMENT '销售店铺ID',
  `policy_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '政策ID',
  `policy_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '政策类型',
  `policy_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '政策代码',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `op_purchase_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'op采购账号',
  `frequent_flyer_group_id` int NULL DEFAULT 0 COMMENT '常旅客分组id',
  `is_retain` tinyint NULL DEFAULT 2 COMMENT '是否留单：1.是，2.否',
  `deadline_to_hold_an_order` datetime NULL DEFAULT NULL COMMENT '留单截止时间',
  `salesperson` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售人',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间',
  `is_split` tinyint(1) NULL DEFAULT 0 COMMENT '是否是拆单',
  `gp_type` tinyint(1) NULL DEFAULT 0 COMMENT 'gp类型，0为无,1=公务卡,2=预算单位',
  `gp_budget_unit_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预算单位名字',
  `is_repeat` tinyint(1) NULL DEFAULT 0 COMMENT '是否重复订单',
  `repeat_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '重复的订单号',
  `parent_order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联的父订单号',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `is_cancel` tinyint(1) NULL DEFAULT 2 COMMENT '是否作废1.是，2.否',
  `order_type_remark` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单类型备注 商旅订单',
  `standby_seat_math_rules_status` tinyint(1) NULL DEFAULT NULL COMMENT '追位规则匹配1成功 2失败',
  `standby_seat_rule_id` int NULL DEFAULT NULL COMMENT '匹配追位规则id',
  `standby_seat_status` tinyint(1) NULL DEFAULT NULL COMMENT '追位状态 1扫描中 2已调出',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `created_at_index`(`created_at` ASC) USING BTREE,
  INDEX `order_status_index`(`order_status` ASC) USING BTREE,
  INDEX `print_ticket_time_index`(`print_ticket_time` ASC) USING BTREE,
  INDEX `is_retain_index`(`is_retain` ASC) USING BTREE,
  INDEX `ticket_agent_id_index`(`ticket_agent_id` ASC) USING BTREE,
  INDEX `dis_id_index`(`dis_id` ASC) USING BTREE,
  INDEX `external_order_no_index`(`external_order_no` ASC) USING BTREE,
  INDEX `parent_order_no_index`(`parent_order_no` ASC) USING BTREE,
  INDEX `department_id_index`(`department_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66488 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'booking分销商正常单订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_order_endorsement
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_order_endorsement`;
CREATE TABLE `dp_distribution_order_endorsement`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sale_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作内容',
  `operator` int NULL DEFAULT 0 COMMENT '操作人',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_order_no_index`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10751 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'booking 分销正常单签注' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_order_log
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_order_log`;
CREATE TABLE `dp_distribution_order_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sale_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '操作内容',
  `extra` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '额外的内容',
  `sort` int NOT NULL COMMENT '序号 1-N 操作顺序',
  `operator` int NULL DEFAULT 0 COMMENT '操作人',
  `operator_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_order_no_index`(`sale_order_no` ASC) USING BTREE,
  INDEX `sort_index`(`sort` ASC) USING BTREE,
  INDEX `created_index`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 502902 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'booking 分销正常单异动日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_order_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_order_passenger_info`;
CREATE TABLE `dp_distribution_order_passenger_info`  (
  `passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台订单号',
  `ticket_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '售卖价(不含机建燃油等税费)',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'ota票面价',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '服务费',
  `reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '奖励',
  `tax_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '面向用户机建费(审核后)',
  `fuel_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '面向用户机燃油费(审核后)',
  `insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保险金额',
  `insurance_num` int NULL DEFAULT 0 COMMENT '购买保险份数',
  `ticket_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `extra_ticke_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '额外票号 逗号间隔',
  `birth_date` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '乘机人出生日期',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ADU成人 CHD儿童 INF 婴儿',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件号',
  `card_time_limit` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件类型证件类型 PP- 护照 JG- 军官证 GA- 港澳通行证 TW- 台湾通行证 TB- 台胞证 HX- 回乡证 HY- 海员证 QT- 其他 XS- 学生 GJ-港澳居住证 TJ-台湾居住证',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '乘机人姓名',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `mobile` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '区号+手机号',
  `email` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile_standby` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备用区号+手机号',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NOT NULL,
  `customer_policy_id` int NULL DEFAULT NULL COMMENT '大客户政策id',
  `external_passenger_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '外部平台乘机人唯一标识',
  `customer_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '大客户编码',
  `customer_id` int NULL DEFAULT 0 COMMENT '大客户文件id',
  `is_ticket` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否出票，0否，1.是',
  `is_itinerary` tinyint(1) NULL DEFAULT 0 COMMENT '是否打印行程单 1已打印 2未打印 3已作废',
  `itinerary_no` tinyint(1) NULL DEFAULT 0 COMMENT '行程单号',
  `is_gp` tinyint(1) NULL DEFAULT 0 COMMENT '是否是gp',
  `gp_type` tinyint(1) NULL DEFAULT 0 COMMENT 'gp类型，0为无,1=公务卡,2=预算单位',
  `gp_budget_unit_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gp预算单位名字',
  `gp_official_card_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gp公务卡代码',
  `gp_official_card_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gp公务卡名字',
  `gp_department` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gp部门',
  `pnr` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码',
  `recode_no` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大编码',
  PRIMARY KEY (`passenger_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `card_no`(`card_no` ASC) USING BTREE,
  INDEX `ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `card_type_index`(`card_type` ASC) USING BTREE,
  INDEX `name_index`(`passenger_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 149543 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'booking分销正常单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_order_relation`;
CREATE TABLE `dp_distribution_order_relation`  (
  `relation_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `passenger_id` int NOT NULL COMMENT '出行人id',
  `sequence_id` int NOT NULL COMMENT '航段id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务订单号',
  `relation_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '关联数据状态 1正常',
  `ticket_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `passenger_id_index`(`passenger_id` ASC) USING BTREE,
  INDEX `sequence_id_index`(`sequence_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 201363 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'booking分销正常单出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_order_sequence
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_order_sequence`;
CREATE TABLE `dp_distribution_order_sequence`  (
  `sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台订单号',
  `a_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场航站楼',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市名称',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `a_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场名称',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字编码',
  `arrival_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班到达时间',
  `take_off_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞时间',
  `d_terminal` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场航站楼',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞城市名称',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场代码',
  `d_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场名称',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号',
  `tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人机建费',
  `fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人燃油费',
  `children_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童机建费',
  `children_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费',
  `baby_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿机建费',
  `baby_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿燃油费',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人服务费',
  `children_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童服务费',
  `baby_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿服务费',
  `adult_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人奖励',
  `children_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童奖励',
  `baby_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿奖励',
  `policy_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策代码',
  `stopover` tinyint(1) NULL DEFAULT NULL COMMENT '是否经停  1是  2否',
  `stopover_info` json NULL COMMENT '经停信息',
  `stopover_coding` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '经停城市三字码 多个 逗号隔开',
  `sequence` int NOT NULL DEFAULT 1 COMMENT '航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '子舱位',
  `sub_class_str` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位字符',
  `chd_sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '儿童舱位',
  `inf_sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '婴儿舱位',
  `adult_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人票面价(不含税)',
  `adult_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成人销售价(不含税)',
  `children_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童票面价(不含税)',
  `children_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童销售价(不含税)',
  `baby_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿票面价(不含税)',
  `baby_sale_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿销售价(不含税)',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `luggage` int NULL DEFAULT NULL COMMENT '托运行李额，单位KG',
  `luggage_nums` int NULL DEFAULT NULL COMMENT '托运行李数量',
  `hand_luggage` int NULL DEFAULT NULL COMMENT '手提行李额，单位KG',
  `hand_luggage_nums` int NULL DEFAULT NULL COMMENT '手提行李数量',
  `sequence_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航段序号',
  `ota_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota舱位',
  PRIMARY KEY (`sequence_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `airline_recode_no_index`(`airline_recode_no` ASC) USING BTREE,
  INDEX `sub_class_index`(`sub_class` ASC) USING BTREE,
  INDEX `d_port_index`(`d_port` ASC) USING BTREE,
  INDEX `a_port_index`(`a_port` ASC) USING BTREE,
  INDEX `flight_index`(`flight` ASC) USING BTREE,
  INDEX `sequence_index`(`sequence` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74636 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'booking分销正常单航段 信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_recharge_record
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_recharge_record`;
CREATE TABLE `dp_distribution_recharge_record`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `dis_id` int NOT NULL COMMENT '分销商id',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '充值金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '备注',
  `operator_id` int NOT NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 99 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分销商充值补差记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_record
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_record`;
CREATE TABLE `dp_distribution_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '销售单号',
  `change_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '改签单号',
  `refund_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '退票单号',
  `type` tinyint NOT NULL COMMENT '1:改签单 2：退票单',
  `passenger_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '乘机人名',
  `card_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人证件号',
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `d_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '起飞机场代码',
  `a_port` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '到达机场代码',
  `take_off_time` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '起飞时间',
  `arrival_time` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班到达时间',
  `flight` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15246 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '散客分销商改签退票记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_refund_order`;
CREATE TABLE `dp_distribution_refund_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) NULL DEFAULT 1 COMMENT '订单来源  1国内订单  2国际订单',
  `purchase_platform` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购渠道ID',
  `office_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'office号',
  `source_type` tinyint(1) NULL DEFAULT 1 COMMENT '\'退废来源  1 销售单退废 2改签单退废\'',
  `refund_type` tinyint(1) NULL DEFAULT NULL COMMENT '退废类型 1退票 2废票',
  `refund_idea_type` tinyint(1) NULL DEFAULT 1 COMMENT '自愿退废  1 是  2 否',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票原因',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台销售单号',
  `dp_purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `ota_refund_no` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台退票单号',
  `ota_sign_hash` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单哈希标识',
  `refund_status` tinyint(1) NULL DEFAULT 1 COMMENT '自建平台退废流转状态 1待处理 2待复审/待人工取位 3已驳回  4待提交 5部分提交 6提交失败 7 已提交 8已完成 9已取消 10待确认 11取消待审核 12待自动取位 13待自动提交',
  `returned_status` tinyint(1) NULL DEFAULT 2 COMMENT '回款状态 1 已回款 2 未回款',
  `submit_status` tinyint(1) NULL DEFAULT 1 COMMENT '提交状态  1未提交  2 部分提交 3 全部提交',
  `confirm_status` tinyint(1) NULL DEFAULT 1 COMMENT 'ota退票确认状态 1待确认 2已确认 3确认失败',
  `has_returned_difference` tinyint(1) NULL DEFAULT NULL COMMENT '回款差异  1无  2有差异',
  `ota_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'ota申请状态 1待审核 2已审核 3 销售端ota已退款 4已驳回',
  `ota_rt_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `apply_uid` int NULL DEFAULT NULL COMMENT '申请人',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `tickets` int NULL DEFAULT NULL COMMENT '票数',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '退票类型1、计划位订单 2、团队位订单 3、散客订单 4、ota订单 ',
  `plan_id` int NULL DEFAULT 0 COMMENT '计划位id',
  `path` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '非自愿退废文件路径',
  `order_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单备注',
  `ticket_agent_id` int NULL DEFAULT 0 COMMENT 'booking操作人员',
  `contact_name` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_mobile_phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人手机号',
  `contact_tel_phone` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人电话',
  `contact_email` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人邮箱',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总销售票价',
  `sale_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总销售基建',
  `sale_fuel` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总销售燃油费',
  `sale_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总销售服务费',
  `sale_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总销售其它费用',
  `sale_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总销售代理费用',
  `sale_refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总销售退票费',
  `sale_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总销售应退金额',
  `audit_time` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `audit_status` tinyint(1) NULL DEFAULT NULL COMMENT '审核状态',
  `submitted_time` timestamp NULL DEFAULT NULL COMMENT '已提交时间',
  `completed_time` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `supplier_id` int NULL DEFAULT NULL COMMENT '供应商ID',
  `sale_platform` tinyint NULL DEFAULT 0 COMMENT '销售渠道ID',
  `sale_store_id` tinyint NULL DEFAULT 0 COMMENT '销售店铺ID',
  `urgency` tinyint NULL DEFAULT 0 COMMENT '紧急度 0无色，一般 1蓝色，起飞前4小时 2橙色，当日航班 3紫色，已起飞',
  `is_retain` tinyint(1) NULL DEFAULT 2 COMMENT '是否留单：1.是，2.否',
  `deadline_to_hold_an_order` datetime NULL DEFAULT NULL COMMENT '留单截止时间',
  `first_audit_uid` int NULL DEFAULT NULL COMMENT '一审人',
  `first_audit_time` datetime NULL DEFAULT NULL COMMENT '一审时间',
  `recheck_audit_uid` int NULL DEFAULT NULL COMMENT '复审人',
  `recheck_audit_time` datetime NULL DEFAULT NULL COMMENT '复审时间',
  `noshow` tinyint(1) NULL DEFAULT 0 COMMENT '是否noshow对赌标记',
  `noshow_status` tinyint(1) NULL DEFAULT 0 COMMENT 'noshow状态:0=待对赌,1=对赌成功,2=对赌失败',
  `first_take_off_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '首段起飞时间',
  `cancel_last_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '取位最晚时限',
  `flight_change` tinyint(1) NULL DEFAULT 0 COMMENT '是否有航变',
  `remind_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '提醒备注',
  `parent_refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '父退票订单号',
  `is_split` tinyint(1) NULL DEFAULT 0 COMMENT '拆单 0 否 1是',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE,
  INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE,
  INDEX `refund_status_index`(`refund_status` ASC) USING BTREE,
  INDEX `created_at_index`(`created_at` ASC) USING BTREE,
  INDEX `audit_time_index`(`audit_time` ASC) USING BTREE,
  INDEX `submitted_time_index`(`completed_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10718 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_refund_order_audit
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_refund_order_audit`;
CREATE TABLE `dp_distribution_refund_order_audit`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `audit_uid` int NOT NULL COMMENT '审核人',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '退废单号',
  `audit_times` tinyint NOT NULL COMMENT '1 一审 2 复审',
  `audit_type` tinyint NOT NULL COMMENT '1同意 2 驳回',
  `reason` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20916 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退废单审核记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_refund_order_log
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_refund_order_log`;
CREATE TABLE `dp_distribution_refund_order_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `refund_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `content` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作内容',
  `extra_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '扩展字段',
  `sort` int NOT NULL COMMENT '序号 1-N 操作顺序',
  `operator` int NULL DEFAULT 0 COMMENT '操作人',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45001 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Booking 散客退票单异动日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_refund_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_refund_order_relation`;
CREATE TABLE `dp_distribution_refund_order_relation`  (
  `refund_relation_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `refund_passenger_id` int NOT NULL COMMENT '出行人id',
  `refund_sequence_id` int NOT NULL COMMENT '航段id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '退款单号',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19630 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Booking散客退票 出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_refund_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_refund_passenger_info`;
CREATE TABLE `dp_distribution_refund_passenger_info`  (
  `refund_passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台订单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台采购单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `birth_date` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '乘机人姓名',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `purchase_platform` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道',
  `office_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购office号',
  `ticket_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `ticket_no_extra` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '额外票号',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售票价',
  `sale_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售基建费',
  `sale_fuel` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售燃油费',
  `sale_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售出行服务费',
  `sale_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售其它费用',
  `sale_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售代理费用',
  `sale_refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售退票费',
  `refund_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售退票服务费',
  `reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '奖励',
  `insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保险金额',
  `insurance_num` int NULL DEFAULT 0 COMMENT '保险份数',
  `sale_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应退金额',
  `relation_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '关联数据状态 1正常',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_passenger_id`) USING BTREE,
  INDEX `refund_order_no_index`(`refund_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16693 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Booking散客 退款单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_distribution_refund_sequence
-- ----------------------------
DROP TABLE IF EXISTS `dp_distribution_refund_sequence`;
CREATE TABLE `dp_distribution_refund_sequence`  (
  `refund_sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台退票单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达城市代码',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场代码',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `arrival_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班到达时间',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞城市代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场代码',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班',
  `sequence` int NOT NULL COMMENT '航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `take_off_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞时间',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `ota_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota舱位',
  PRIMARY KEY (`refund_sequence_id`) USING BTREE,
  INDEX `refund_order_no_index`(`refund_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13009 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Booking 散客退款单航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_change_order
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_change_order`;
CREATE TABLE `dp_purchase_change_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) NULL DEFAULT 0 COMMENT '订单类型，1.计划位团 2.临时团 3.散客订单',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1:同舱改签 2:升舱改签',
  `dp_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台改签销售单号',
  `purchase_change_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台改签采购单号',
  `change_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分销端/OTA改签单号',
  `sale_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分销端销售单号',
  `external_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单号',
  `purchase_platform` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '采购平台',
  `state` tinyint NULL DEFAULT 1 COMMENT '1:待处理 2：完成改签 3：驳回',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'office号',
  `flight_way` tinyint NULL DEFAULT 2 COMMENT '航程类型 1往返 2单程 3联程',
  `airline_recode_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '改签大编码',
  `source_type` tinyint NOT NULL DEFAULT 0 COMMENT '来源：1.销售单，2.改签单',
  `p_id` int NULL DEFAULT 0 COMMENT '改签又改签的上次改签id',
  `pnr` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '改签PNR',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价',
  `ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金',
  `ticket_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价+税金-票价*代理费率-基建-燃油费用',
  `fuel_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '基建总费用',
  `inf_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '燃油总费用',
  `agent_rate` float(10, 2) NULL DEFAULT 0.00 COMMENT '代理费率',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其它费用',
  `supplementary_discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '补收优惠金额',
  `change_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签服务费',
  `change_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费用',
  `change_total_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签总费用',
  `contact_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '联系人姓名',
  `contact_mobile_phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '联系人手机号码',
  `contact_email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人邮箱',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `out_trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方采购单号',
  `trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方支付流水号',
  `op_purchase_account` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'OP采购账号',
  `subject_id` int NULL DEFAULT NULL COMMENT '支付科目',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1354 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购改签订单主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_change_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_change_order_relation`;
CREATE TABLE `dp_purchase_change_order_relation`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dp_purchase_change_passenger_id` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '出行人id',
  `dp_purchase_change_sequence_id` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航段id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1835 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购改签中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_change_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_change_passenger_info`;
CREATE TABLE `dp_purchase_change_passenger_info`  (
  `passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dp_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台改签单号',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端订单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销端改签单号',
  `purchase_change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签采购单号',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人类型 ADU:成人 CHD:儿童 INF:婴儿 STU:学生',
  `passenger_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '乘机人姓名',
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `old_ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧票号',
  `extra_ticket_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '扩展票号',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价',
  `old_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '旧票价',
  `ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '机建费',
  `ticket_fuel_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '燃油费',
  `ticket_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价+税金-票价*代理费率-基建-燃油费用',
  `fuel_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '旧基建总费用',
  `tax_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '旧燃油总费用',
  `agent_rate` float(10, 2) NULL DEFAULT 0.00 COMMENT '代理费率',
  `agent_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理费',
  `price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票税差',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其它费用',
  `supplementary_discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '补收优惠金额',
  `change_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签服务费',
  `change_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费用',
  `change_total_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签总费用',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`passenger_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1774 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购改签乘机人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_change_sequence
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_change_sequence`;
CREATE TABLE `dp_purchase_change_sequence`  (
  `dp_purchase_sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `dp_change_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台改签单号',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分销端订单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分销端改签单号',
  `purchase_change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签采购单号',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '到达机场代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '起飞机场代码',
  `arrival_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班到达时间',
  `take_off_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞时间',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `flight_code` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航司二字码',
  `sequence` int NULL DEFAULT NULL COMMENT '航段顺序',
  `position` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '舱位',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`dp_purchase_sequence_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1325 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购改签航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_order`;
CREATE TABLE `dp_purchase_order`  (
  `dp_purchase_order_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '订单类型，1.计划位团 2.临时团 3.散客订单  4.OTA订单',
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位ID',
  `sale_order_no_info` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分销平台销售单单号，多个逗号分隔',
  `dp_purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台采购单号',
  `ticket_counter` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '票台：bsp 出票 选择的票台',
  `purchase_platform` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '采购平台 BSP,B2B,BOP,OP',
  `office_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `count_people` int NOT NULL DEFAULT 0 COMMENT '订单人数',
  `purchase_ticket_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '采购总票面价',
  `purchase_tax_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '采购机建费',
  `purchase_fuel_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '采购燃油费',
  `purchase_insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购保险金额',
  `purchase_insurance_num` int NULL DEFAULT 0 COMMENT '采购购买保险份数',
  `purchase_agent_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购总代理费',
  `purchase_reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购奖励红包',
  `purchase_settle_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '采购总价',
  `flight_way` tinyint(1) NULL DEFAULT 2 COMMENT '1往返 2单程 3联程',
  `flight_class` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N' COMMENT '订单类型 I:国际  N:国内',
  `order_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1. 出票成功， 2.出票失败',
  `issue_way` tinyint(1) NOT NULL DEFAULT 2 COMMENT '出票方式 1:自动出票 2:手工出票',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `order_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预订时间',
  `recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小记录编号 订位 RecordNo  订位PNR',
  `big_recode_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `parse_recode_no` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '解析的编码',
  `created_at` datetime NOT NULL COMMENT '录入时间',
  `updated_at` datetime NOT NULL,
  `subject_id` int NOT NULL DEFAULT 7 COMMENT '收支科目ID',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购信息备注',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作的用户名',
  `contact` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系手机',
  `tel` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系座机',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系邮箱',
  `out_trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方采购平台单号',
  `trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '交易流水号',
  `op_purchase_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'op采购账号',
  `purchase_data` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购数据',
  `together_order_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '一起出票订单号',
  PRIMARY KEY (`dp_purchase_order_id`) USING BTREE,
  INDEX `sale_order_no_index`(`sale_order_no_info` ASC) USING BTREE,
  INDEX `purchase_platform_index`(`purchase_platform` ASC) USING BTREE,
  INDEX `subject_id_index`(`subject_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66216 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购单主订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_order_installment_pay_record
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_order_installment_pay_record`;
CREATE TABLE `dp_purchase_order_installment_pay_record`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dp_purchase_order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台采购单号',
  `business_type` tinyint(1) NOT NULL COMMENT '业务类型：1 计划位，2 临时团',
  `business_id` int NOT NULL DEFAULT 0 COMMENT '业务id',
  `number_of_people` int NOT NULL DEFAULT 0 COMMENT '人数',
  `pay_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
  `pay_time` datetime NOT NULL COMMENT '支付时间',
  `subject_id` int NOT NULL DEFAULT 0 COMMENT '资金科目id',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购订单分期支付记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_order_log
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_order_log`;
CREATE TABLE `dp_purchase_order_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dp_purchase_sequence_id` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台订单号',
  `status` tinyint NULL DEFAULT 3 COMMENT '1 成功 2 失败 3处理中',
  `fail_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '失败原因',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购回填记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_order_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_order_passenger_info`;
CREATE TABLE `dp_purchase_order_passenger_info`  (
  `dp_purchase_passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分销平台订单号',
  `dp_purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台采购单号',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '乘机人姓名',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件号',
  `card_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `purchase_ticket_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '采购票面价',
  `purchase_tax_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '采购机建费',
  `purchase_fuel_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '采购燃油费',
  `purchase_insurance_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购保险金额',
  `purchase_insurance_num` int NULL DEFAULT 0 COMMENT '采购购买保险份数',
  `purchase_settle_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '采购含税结算价',
  `position` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '仓位',
  `agent_rate` float NULL DEFAULT 0 COMMENT '代理费率',
  `agent_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理奖励金额（采购票面价*代理费率）',
  `ticket_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购票号',
  `extra_ticke_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '扩展票号',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `customer_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大客户代码',
  `customer_id` int NULL DEFAULT 0 COMMENT '大客户文件id',
  `after_rebate_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '后返金额',
  `reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '奖励金额',
  PRIMARY KEY (`dp_purchase_passenger_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `passenger_name`(`passenger_name` ASC) USING BTREE,
  INDEX `card_type_index`(`card_type` ASC) USING BTREE,
  INDEX `card_no_index`(`card_no` ASC) USING BTREE,
  INDEX `created_index`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 151046 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购乘机人信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_order_relation`;
CREATE TABLE `dp_purchase_order_relation`  (
  `dp_purchase_passenger_id` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '出行人id',
  `dp_purchase_sequence_id` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航段id',
  `ticket_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  INDEX `dp_purchase_passenger_id_index`(`dp_purchase_passenger_id` ASC) USING BTREE,
  INDEX `dp_purchase_sequence_id_index`(`dp_purchase_sequence_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购出票价格中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_order_sequence
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_order_sequence`;
CREATE TABLE `dp_purchase_order_sequence`  (
  `dp_purchase_sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分销平台订单号',
  `dp_purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台采购单号',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '到达机场代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '起飞机场代码',
  `arrival_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班到达时间',
  `take_off_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞时间',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `flight_code` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `sequence` int NULL DEFAULT NULL COMMENT '航段顺序',
  `position` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '舱位',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`dp_purchase_sequence_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74256 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_refund_order`;
CREATE TABLE `dp_purchase_refund_order`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchase_platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购平台',
  `source_type` tinyint(1) NULL DEFAULT 1 COMMENT '退废来源  1 销售单退废 2改签单退废',
  `refund_type` tinyint(1) NULL DEFAULT NULL COMMENT '退废类型 1退票 2废票',
  `refund_idea_type` tinyint(1) NULL DEFAULT NULL COMMENT '自愿退废  1 是  2 否',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票原因',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销平台销售单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国内采购正常单单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销平台改签单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分销平台退款单号',
  `refund_purchase_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自己平台退款采购单号',
  `returned_status` tinyint(1) NULL DEFAULT 2 COMMENT '回款状态 1 已回款 2 未回款',
  `has_returned_difference` tinyint(1) NULL DEFAULT 1 COMMENT '回款差异  1无  2有差异',
  `ota_status` tinyint(1) NULL DEFAULT 1 COMMENT 'ota申请状态 1待审核 2已审核 3 销售端ota已退款 4已驳回',
  `ota_rt_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `airline_recode_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '大编',
  `office_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `tickets` tinyint(1) NOT NULL DEFAULT 1 COMMENT '票数',
  `refund_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退款描述',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '取消原因',
  `order_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单备注',
  `purchase_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购票价',
  `purchase_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购机建',
  `purchase_fuel` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购燃油费',
  `purchase_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购出行服务费',
  `purchase_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购其它费',
  `purchase_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购代理费',
  `purchase_refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购退票费',
  `purchase_refund_service_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '采购退票服务费',
  `purchase_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应退金额',
  `airline_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '航司应退金额',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `contact` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系手机',
  `tel` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系座机',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系邮箱',
  `subject_id` int NOT NULL DEFAULT 0 COMMENT '收支科目ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE,
  UNIQUE INDEX `refund_purchase_order_no`(`refund_purchase_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10573 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内退款订单采购表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_refund_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_refund_order_relation`;
CREATE TABLE `dp_purchase_refund_order_relation`  (
  `dp_refund_passenger_id` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '出行人id',
  `dp_refund_sequence_id` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航段id'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购改签中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_refund_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_refund_passenger_info`;
CREATE TABLE `dp_purchase_refund_passenger_info`  (
  `refund_passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台订单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台采购单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `refund_purchase_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自己平台退款采购单号',
  `submit_status` tinyint(1) NOT NULL DEFAULT 2 COMMENT '1 已提交 2 未提交',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '乘机人姓名',
  `purchase_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购票价',
  `purchase_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购机建',
  `purchase_fuel` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购燃油费',
  `purchase_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购出行服务费',
  `purchase_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购其它费',
  `purchase_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购代理费',
  `purchase_refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购退票费',
  `purchase_refund_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购退票服务费',
  `purchase_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应退金额',
  `reward` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '奖励',
  `airline_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '航司应退金额',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NOT NULL,
  `voluntarily` tinyint NULL DEFAULT 0 COMMENT '提交航司退票类型：1自愿，2非自愿',
  PRIMARY KEY (`refund_passenger_id`) USING BTREE,
  INDEX `refund_purchase_order_no`(`refund_purchase_order_no` ASC) USING BTREE,
  INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE,
  INDEX `passenger_name`(`passenger_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15624 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内退款采购单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_refund_sequence
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_refund_sequence`;
CREATE TABLE `dp_purchase_refund_sequence`  (
  `refund_sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台采购单号',
  `refund_purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自己平台退款采购单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达城市代码',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场代码',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `arrival_time` datetime NOT NULL COMMENT '航班到达时间',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞城市代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场代码',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `take_off_time` datetime NOT NULL COMMENT '起飞时间',
  `air_line_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司编号',
  `created_at` datetime NOT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_sequence_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12870 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内退款采购航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dp_purchase_sequence
-- ----------------------------
DROP TABLE IF EXISTS `dp_purchase_sequence`;
CREATE TABLE `dp_purchase_sequence`  (
  `dp_purchase_sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分销平台订单号',
  `dp_purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台采购单号',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '到达机场代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '起飞机场代码',
  `arrival_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班到达时间',
  `take_off_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞时间',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航班',
  `flight_code` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `sequence` int NULL DEFAULT NULL COMMENT '航段顺序',
  `position` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '舱位',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`dp_purchase_sequence_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国内采购航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_create_coding_log
-- ----------------------------
DROP TABLE IF EXISTS `freight_create_coding_log`;
CREATE TABLE `freight_create_coding_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源渠道  分销  觅优',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1黑屏生编  2ibe+',
  `inter` tinyint(1) NULL DEFAULT 1 COMMENT '1国内  2国际',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目的地',
  `dep_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发日期',
  `dep_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发时间',
  `trip_type` tinyint(1) NULL DEFAULT 1 COMMENT '行程类型:1=单程,2=往返,3=多程',
  `request_orig_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求原数据json',
  `request_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求组装数据json',
  `response_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '响应json',
  `pnr` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '外部订单号',
  `source_error` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '异常信息',
  `policy_code` json NULL,
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '1生编成功  2生编异常',
  `group_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 430 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '觅优生编日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_config
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_config`;
CREATE TABLE `freight_fare_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `group` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置分组',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置名',
  `key` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `val` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置值',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '运价库配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_log_checkprice
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_log_checkprice`;
CREATE TABLE `freight_fare_log_checkprice`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `request_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求id',
  `channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源渠道',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据源',
  `inter` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是国际',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目的地',
  `dep_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发时间',
  `trip_type` tinyint(1) NOT NULL COMMENT '行程类型:1=单程,2=往返,3=多程',
  `request_json` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求详情json',
  `request_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '请求时间',
  `response_total_time` int NULL DEFAULT NULL COMMENT '响应总耗时，单位毫秒',
  `source_time` int NULL DEFAULT NULL COMMENT '数据源耗时，单位毫秒',
  `source_status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '数据源状态码',
  `source_error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '数据源错误消息',
  `input_mod_time` int NULL DEFAULT NULL COMMENT '输入模型耗时',
  `policy_time` int NULL DEFAULT NULL COMMENT '政策匹配耗时',
  `output_mod_time` int NULL DEFAULT NULL COMMENT '输出模型耗时',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ori_index`(`ori` ASC) USING BTREE,
  INDEX `des_index`(`des` ASC) USING BTREE,
  INDEX `dep_date_index`(`dep_date` ASC) USING BTREE,
  INDEX `request_id_index`(`request_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9986 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '验价日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_log_createpnr
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_log_createpnr`;
CREATE TABLE `freight_fare_log_createpnr`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `request_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求id',
  `channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源渠道',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据源',
  `inter` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是国际',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目的地',
  `dep_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发时间',
  `trip_type` tinyint(1) NOT NULL COMMENT '行程类型:1=单程,2=往返,3=多程',
  `request_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求详情json',
  `request_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '请求时间',
  `response_total_time` int NULL DEFAULT NULL COMMENT '响应总耗时，单位毫秒',
  `source_time` int NULL DEFAULT NULL COMMENT '数据源耗时，单位毫秒',
  `source_status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '数据源状态码',
  `source_error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '数据源错误消息',
  `input_mod_time` int NULL DEFAULT NULL COMMENT '输入模型耗时',
  `output_mod_time` int NULL DEFAULT NULL COMMENT '输出模型耗时',
  `order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '外部订单号',
  `pay_order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '外部支付订单',
  `pnrs` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  `order_detail` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单详情',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ori_index`(`ori` ASC) USING BTREE,
  INDEX `des_index`(`des` ASC) USING BTREE,
  INDEX `dep_date_index`(`dep_date` ASC) USING BTREE,
  INDEX `request_id_index`(`request_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7973 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '生单日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_log_policy
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_log_policy`;
CREATE TABLE `freight_fare_log_policy`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `inter` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否是国际',
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '请求类型:1=查询,2=验价',
  `request_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求id',
  `flight_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号集合逗号分割',
  `cabins` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位集合',
  `policy_id` int NULL DEFAULT NULL COMMENT '政策id',
  `policy_child_id` int NULL DEFAULT 0 COMMENT '政策奖励id',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态:1=成功,0=失败',
  `message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '错误消息',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `request_id_index`(`request_id` ASC) USING BTREE,
  INDEX `policy_id_index`(`policy_id` ASC) USING BTREE,
  INDEX `policy_child_id_index`(`policy_child_id` ASC) USING BTREE,
  INDEX `type_index`(`type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '政策匹配日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_log_search
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_log_search`;
CREATE TABLE `freight_fare_log_search`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `request_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求id',
  `channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源渠道',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据源',
  `inter` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是国际',
  `ori` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发地',
  `des` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目的地',
  `dep_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发时间',
  `trip_type` tinyint(1) NOT NULL COMMENT '行程类型:1=单程,2=往返,3=多程',
  `request_json` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求详情json',
  `request_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '请求时间',
  `cache` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否命中缓存',
  `cache_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '缓存key',
  `cache_time` int NULL DEFAULT NULL COMMENT '缓存时间,单位分钟',
  `response_total_time` int NULL DEFAULT NULL COMMENT '响应总耗时，单位毫秒',
  `source_time` bigint NULL DEFAULT NULL COMMENT '数据源耗时，单位毫秒',
  `source_status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '数据源状态码',
  `source_error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '数据源错误消息',
  `input_mod_time` int NULL DEFAULT NULL COMMENT '输入模型耗时',
  `policy_time` int NULL DEFAULT NULL COMMENT '政策匹配耗时',
  `output_mod_time` int NULL DEFAULT NULL COMMENT '输出模型耗时',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ori_index`(`ori` ASC) USING BTREE,
  INDEX `des_index`(`des` ASC) USING BTREE,
  INDEX `dep_date_index`(`dep_date` ASC) USING BTREE,
  INDEX `request_id_index`(`request_id` ASC) USING BTREE,
  INDEX `channel_index`(`channel` ASC) USING BTREE,
  INDEX `source_index`(`source` ASC) USING BTREE,
  INDEX `cache_index`(`cache` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 827824 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '运价查询日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_order
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_order`;
CREATE TABLE `freight_fare_order`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `stock_id` int NULL DEFAULT 0 COMMENT '库存id',
  `stock_index_id` int NULL DEFAULT 0 COMMENT '索引id',
  `stock_list_id` int NULL DEFAULT 0 COMMENT '列表id',
  `order_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态:态：0:未支付 1:已经支付 2:已经取消',
  `order_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内部订单号',
  `out_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '外部订单号',
  `adt_pnr` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '成人pnr',
  `chd_pnr` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '儿童pnr',
  `passenger_number` int NOT NULL DEFAULT 0 COMMENT '乘客数量',
  `adt_number` int NULL DEFAULT 0 COMMENT '成人数量',
  `chd_number` int NULL DEFAULT 0 COMMENT '儿童数量',
  `inf_number` int NULL DEFAULT 0 COMMENT '婴儿数量',
  `ext` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '附加数据',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '运价直连订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_source_account
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_source_account`;
CREATE TABLE `freight_fare_source_account`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态,1=正常,0=禁用',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '数据源标识',
  `channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '来源渠道',
  `account_json` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账号配置',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '渠道账号配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_stock
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_stock`;
CREATE TABLE `freight_fare_stock`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '库存名字，唯一',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态:0=禁用,1=使用',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型，1国内，2国际',
  `airline` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `age_min` int NOT NULL DEFAULT 0 COMMENT '最小年龄限制',
  `age_max` int NULL DEFAULT 0 COMMENT '最大年龄限制',
  `sale_start_date` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售开始日期',
  `sale_end_date` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售结束日期',
  `except_date` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '除外的生效日期',
  `chd_by_adt` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否允许儿童卖成人，0否，1是',
  `sell_chd` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否允许儿童，0否，1是',
  `sell_inf` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否允许婴儿，0否，1是',
  `card_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '支持证件类型；0：支持所有证件类型(默认)，1：只支持身份证购买',
  `special_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '特殊票务说明',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司库存' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_stock_index
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_stock_index`;
CREATE TABLE `freight_fare_stock_index`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `freight_fare_stock_id` int NOT NULL COMMENT '库存主表ID',
  `flight_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '行程类型：1=机场对机场，2=城市对城市',
  `airline` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司',
  `flight_no` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号',
  `plating_carrier` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票航司',
  `operating_carrier` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '实际承运航司',
  `operating_flight` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '实际承运航班号',
  `start_date` date NOT NULL COMMENT '生效日期',
  `end_date` date NOT NULL COMMENT '失效日期',
  `flight_except_date` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞除外日期',
  `flight_week` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞周期',
  `dep` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发地',
  `dep_terminal` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发航站楼',
  `dep_time` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0000' COMMENT '起飞时间',
  `arr` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目的地',
  `arr_terminal` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达航站楼',
  `arr_time` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '2359' COMMENT '到达时间',
  `cabin_cn` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱等中文',
  `cabin_level` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位等级代码',
  `cabin` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `chd_cabin` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '儿童舱位',
  `inf_cabin` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '婴儿舱位',
  `meal` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '餐食',
  `plane_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '机型',
  `stops` int NOT NULL DEFAULT 0 COMMENT '经停次数',
  `share` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否共享',
  `farebasis` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运价代码',
  `ticket_price` decimal(10, 2) NOT NULL COMMENT '成人票面价',
  `ticket_price_chd` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '儿童票面价',
  `ticket_price_inf` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '婴儿票面价',
  `c_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'C舱成人票面价',
  `c_ticket_price_chd` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'C舱儿童票面价',
  `c_ticket_price_inf` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'C舱婴儿票面价',
  `f_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'F舱成人票面价',
  `f_ticket_price_chd` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'F舱儿童票面价',
  `f_ticket_price_inf` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'F舱婴儿票面价',
  `build` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '基建',
  `chd_build` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童基建',
  `inf_build` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿基建',
  `tax` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '燃油税费',
  `chd_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油税费',
  `inf_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '婴儿燃油税费',
  `stock` int NOT NULL COMMENT '库存',
  `duration` int NULL DEFAULT 0 COMMENT '行程耗时分钟',
  `distance` int NULL DEFAULT 0 COMMENT '飞行距离',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司库存索引表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for freight_fare_stock_list
-- ----------------------------
DROP TABLE IF EXISTS `freight_fare_stock_list`;
CREATE TABLE `freight_fare_stock_list`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `freight_fare_stock_id` int NULL DEFAULT NULL COMMENT '库存表id',
  `freight_fare_stock_index_id` int NULL DEFAULT NULL COMMENT '索引表id',
  `date` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '班期',
  `dep_time` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0000' COMMENT '起飞时间',
  `arr_time` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '2359' COMMENT '到达时间',
  `ticket_price` decimal(10, 2) NOT NULL COMMENT '成人票面价',
  `ticket_price_chd` decimal(10, 2) NULL DEFAULT NULL COMMENT '儿童票面价',
  `ticket_price_inf` decimal(10, 2) NULL DEFAULT NULL COMMENT '婴儿票面价',
  `build` decimal(10, 2) NOT NULL COMMENT '基建',
  `tax` decimal(10, 2) NOT NULL COMMENT '燃油',
  `stock` int NOT NULL COMMENT '库存',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司库存列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gp_budget_unit
-- ----------------------------
DROP TABLE IF EXISTS `gp_budget_unit`;
CREATE TABLE `gp_budget_unit`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NULL DEFAULT NULL COMMENT '分销商id',
  `name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位名字',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1正常  0禁用',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'GP预算单位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gp_official_card
-- ----------------------------
DROP TABLE IF EXISTS `gp_official_card`;
CREATE TABLE `gp_official_card`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '银行名字',
  `code` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '银行代码',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1正常  0禁用',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 116 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'GP公务卡' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gp_official_card_auth
-- ----------------------------
DROP TABLE IF EXISTS `gp_official_card_auth`;
CREATE TABLE `gp_official_card_auth`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dis_id` int NOT NULL COMMENT '分销商id',
  `official_card_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公务卡id',
  `name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `gender` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别 M男 S女',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件类型',
  `card_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件号',
  `mobile` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `birth_date` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出生日期',
  `card_time_limit` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `department` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '部门',
  `post_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮寄地址',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1正常  0禁用',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'GP公务卡认证' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurance_cancel_order_purchase_bill
-- ----------------------------
DROP TABLE IF EXISTS `insurance_cancel_order_purchase_bill`;
CREATE TABLE `insurance_cancel_order_purchase_bill`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `serial_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '我方销售单号-交易流水号',
  `order_type` tinyint NOT NULL DEFAULT 1 COMMENT '订单类型：1 计划位订单，2 团队位订单，3 散客订单，4 其他（第三方销售）',
  `order_area` tinyint NOT NULL DEFAULT 1 COMMENT '订单区域：1 国内订单，2 国际订单',
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售订单单号',
  `apply_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商订单号',
  `policy_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '保险公司保单号',
  `insurances_id` int NOT NULL DEFAULT 0 COMMENT '险种ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '险种名称',
  `amount_refunded` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应退金额',
  `actual_refund_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实退金额',
  `diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '投保状态：0待投保，1成功，2失败,3已撤保, 4未投保已取消, 5撤保待审',
  `bill_status` tinyint(1) NULL DEFAULT 1 COMMENT '对账状态：1 待对账，2 已对账, 3 已销账',
  `is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否差异账单：0 正常，1 差异',
  `is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否坏账：0 否，1 是',
  `bill_operator_id` int NULL DEFAULT 0 COMMENT '对账操作人id',
  `bill_operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对账操作人名称',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其他订单备注',
  `other_remark_by_id` int NULL DEFAULT 0 COMMENT '其他订单备注人id',
  `other_remark_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其他订单备注人名称',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备注时间',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `cost` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '成本(保费)',
  `costs` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总成本(保费)',
  `is_tinerary` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否行程单：0否，1是',
  `supplier_id` int NULL DEFAULT 0 COMMENT '供应商ID',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '产品代码',
  `plan_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '计划代码（旅游险）',
  `denomination` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '面额',
  `denominations` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总面额',
  `permiun` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '保费(销售价)',
  `permiuns` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总保费(销售价)',
  `insured_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '保额(单位：万元)',
  `insured_amounts` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总保额(单位：万元)',
  `quantity` tinyint NOT NULL DEFAULT 1 COMMENT '份数',
  `start_at` datetime NOT NULL COMMENT '保单开始日期时间',
  `end_at` datetime NOT NULL COMMENT '保单结束日期时间',
  `validity_date` tinyint NOT NULL DEFAULT 1 COMMENT '保险期限（天数或次数）',
  `flight_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航变号',
  `flight_date` datetime NULL DEFAULT NULL COMMENT '航班日期',
  `to_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '旅行目的国家',
  `applicant_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '投保人名称',
  `applicant_card_type` tinyint NOT NULL DEFAULT 1 COMMENT '        1 => \"身份证\",\r\n        2 => \"护照\",\r\n        3 => \"军官证\",\r\n        4 => \"港澳台回乡证\",\r\n        5 => \"港澳台身份证\",\r\n        9 => \"其他\",\r\n        100 => \"统一社会信用代码\",\r\n        101 => \"税务登记证\",\r\n        102 => \"组织机构代码证\",',
  `applicant_card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '投保人证件号',
  `applicant_sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '投保人性别： M:  男     F:  女',
  `applicant_birthday` date NULL DEFAULT NULL COMMENT '投保人生日日期',
  `applicant_mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '投保人手机号',
  `pnr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'PNR',
  `down_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '保险公司电子保单下载地址',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险撤销单采购对账' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurance_normal_order_purchase_bill
-- ----------------------------
DROP TABLE IF EXISTS `insurance_normal_order_purchase_bill`;
CREATE TABLE `insurance_normal_order_purchase_bill`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `serial_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '我方销售单号-交易流水号',
  `order_type` tinyint NOT NULL DEFAULT 1 COMMENT '订单类型：1 计划位订单，2 团队位订单，3 散客订单，4 其他（第三方销售）',
  `order_area` tinyint NOT NULL DEFAULT 1 COMMENT '订单区域：1 国内订单，2 国际订单',
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售订单单号',
  `apply_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商订单号',
  `policy_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '保险公司保单号',
  `insurances_id` int NOT NULL DEFAULT 0 COMMENT '险种ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '险种名称',
  `amount_payable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应付金额',
  `amount_actually_paid` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `diff_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '差异金额',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '投保状态：0待投保，1成功，2失败,3已撤保, 4未投保已取消, 5撤保待审',
  `bill_status` tinyint(1) NULL DEFAULT 1 COMMENT '对账状态：1 待对账，2 已对账, 3 已销账',
  `is_diff_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否差异账单：0 正常，1 差异',
  `is_bad_bill` tinyint(1) NULL DEFAULT 0 COMMENT '是否坏账：0 否，1 是',
  `bill_operator_id` int NULL DEFAULT 0 COMMENT '对账操作人id',
  `bill_operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对账操作人名称',
  `bill_date` datetime NULL DEFAULT NULL COMMENT '对账时间',
  `other_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其他订单备注',
  `other_remark_by_id` int NULL DEFAULT 0 COMMENT '其他订单备注人id',
  `other_remark_by` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其他订单备注人名称',
  `other_remark_at` datetime NULL DEFAULT NULL COMMENT '其他订单备注时间',
  `subject_id` int NULL DEFAULT 0 COMMENT '资金科目id',
  `cost` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '成本(保费)',
  `costs` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总成本(保费)',
  `is_tinerary` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否行程单：0否，1是',
  `supplier_id` int NULL DEFAULT 0 COMMENT '供应商ID',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '产品代码',
  `plan_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '计划代码（旅游险）',
  `denomination` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '面额',
  `denominations` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总面额',
  `permiun` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '保费(销售价)',
  `permiuns` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总保费(销售价)',
  `insured_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '保额(单位：万元)',
  `insured_amounts` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '总保额(单位：万元)',
  `quantity` tinyint NOT NULL DEFAULT 1 COMMENT '份数',
  `start_at` datetime NOT NULL COMMENT '保单开始日期时间',
  `end_at` datetime NOT NULL COMMENT '保单结束日期时间',
  `validity_date` tinyint NOT NULL DEFAULT 1 COMMENT '保险期限（天数或次数）',
  `flight_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航变号',
  `flight_date` datetime NULL DEFAULT NULL COMMENT '航班日期',
  `to_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '旅行目的国家',
  `applicant_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '投保人名称',
  `applicant_card_type` tinyint NOT NULL DEFAULT 1 COMMENT '        1 => \"身份证\",\r\n        2 => \"护照\",\r\n        3 => \"军官证\",\r\n        4 => \"港澳台回乡证\",\r\n        5 => \"港澳台身份证\",\r\n        9 => \"其他\",\r\n        100 => \"统一社会信用代码\",\r\n        101 => \"税务登记证\",\r\n        102 => \"组织机构代码证\",',
  `applicant_card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '投保人证件号',
  `applicant_sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '投保人性别： M:  男     F:  女',
  `applicant_birthday` date NULL DEFAULT NULL COMMENT '投保人生日日期',
  `applicant_mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '投保人手机号',
  `pnr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'PNR',
  `down_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '保险公司电子保单下载地址',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7078 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险正常单采购对账' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurance_order_purchase_bill_adjustment
-- ----------------------------
DROP TABLE IF EXISTS `insurance_order_purchase_bill_adjustment`;
CREATE TABLE `insurance_order_purchase_bill_adjustment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `bill_id` int UNSIGNED NOT NULL COMMENT '对账单id',
  `bill_type` tinyint(1) NOT NULL COMMENT '对账单类型：1 正常单，2 撤销单',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '调账金额',
  `supplier_id` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '供应商id',
  `remark` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '调整备注',
  `operate_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '操作类型：1. 补差，2.调账',
  `operator_id` int NOT NULL COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险订单采购对账调账或补差' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurance_order_purchase_bill_log
-- ----------------------------
DROP TABLE IF EXISTS `insurance_order_purchase_bill_log`;
CREATE TABLE `insurance_order_purchase_bill_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户能查看的日志内容',
  `develop_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '开发人员查看的日志内容',
  `bill_type` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '对账单类型：1 正常单，2 撤销单',
  `bill_id` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '对账id',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  `operate_type` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作类型：1.对账，2.差异对账，3.补差，4.调账',
  `operator_id` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险订单采购对账日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurance_order_purchase_day_statement
-- ----------------------------
DROP TABLE IF EXISTS `insurance_order_purchase_day_statement`;
CREATE TABLE `insurance_order_purchase_day_statement`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `supplier_id` int NOT NULL DEFAULT 0 COMMENT '供应商id',
  `normal_order_amount_payable` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '正常单应付金额',
  `normal_order_amount_actually_paid` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '正常单实付金额',
  `refund_order_amount_refunded` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '撤销单应退金额',
  `refund_order_actual_refund_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '撤销单实退金额',
  `time_date` date NOT NULL COMMENT '日期，按天',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `supplier_id`(`supplier_id` ASC) USING BTREE,
  INDEX `time_date`(`time_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险订单采购日结单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurance_order_purchase_day_statement_record
-- ----------------------------
DROP TABLE IF EXISTS `insurance_order_purchase_day_statement_record`;
CREATE TABLE `insurance_order_purchase_day_statement_record`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `insurance_order_purchase_day_statement_id` int NOT NULL COMMENT '保险订单采购日结单id',
  `order_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `bill_id` int NOT NULL COMMENT '对账单id',
  `bill_type` tinyint(1) NOT NULL COMMENT '对账单类型：1 正常单，2 撤销单',
  `target_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '目标金额（应收或应退）',
  `actual_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实际金额（实收或实退）',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `insurance_order_purchase_day_statement_id`(`insurance_order_purchase_day_statement_id` ASC) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `bill_id`(`bill_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险订单采购日结单记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurance_suppliers
-- ----------------------------
DROP TABLE IF EXISTS `insurance_suppliers`;
CREATE TABLE `insurance_suppliers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商标识',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '供应商外链地址',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurances
-- ----------------------------
DROP TABLE IF EXISTS `insurances`;
CREATE TABLE `insurances`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '险种名称',
  `cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '成本(保费)',
  `is_tinerary` tinyint(1) NULL DEFAULT 0 COMMENT '是否行程单：0否，1是',
  `supplier_id` int NULL DEFAULT 0 COMMENT '供应商ID',
  `validity_date` int NULL DEFAULT 0 COMMENT '保险期限（天数/0单次）',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '产品代码',
  `plan_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '计划代码',
  `denomination` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面额',
  `permiun` decimal(10, 2) NULL DEFAULT NULL COMMENT '保费(销售价)',
  `insured_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '保额(单位：万元)',
  `sales_quota` tinyint NULL DEFAULT 0 COMMENT '限额份数',
  `jump_to_external_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跳转外部url',
  `rights_and_interests_images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权益图片',
  `invoice_template_images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发票模板图片',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：0 禁用，1 启用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurances_order_insureds
-- ----------------------------
DROP TABLE IF EXISTS `insurances_order_insureds`;
CREATE TABLE `insurances_order_insureds`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `policy_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '保单号',
  `serial_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '我方销售单号-交易流水号',
  `insured_seq_no` int NOT NULL DEFAULT 0 COMMENT '保单序列号，从0开始',
  `insured_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '被保人姓名',
  `insured_card_type` tinyint NULL DEFAULT 1 COMMENT '1 => \"身份证\",\r\n        2 => \"护照\",\r\n        3 => \"军官证\",\r\n        4 => \"港澳台回乡证\",\r\n        5 => \"港澳台身份证\",\r\n        9 => \"其他\",\r\n        100 => \"统一社会信用代码\",\r\n        101 => \"税务登记证\",\r\n        102 => \"组织机构代码证\",',
  `insured_card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '被保人证件号',
  `insured_sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '被保人性别: M:  男     F:  女',
  `insured_identity` tinyint NULL DEFAULT 0 COMMENT '投保人与被保人关系代码\r\n0 => \"本人\",\r\n        1 => \"配偶\",\r\n        2 => \"子女\",\r\n        3 => \"父母\",\r\n        4 => \"其他\",',
  `insured_birthday` date NULL DEFAULT NULL COMMENT '被保人出生日期',
  `insured_mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '被保人手机号码',
  `insured_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '被保人邮箱号码',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '票号',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8309 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurances_order_records
-- ----------------------------
DROP TABLE IF EXISTS `insurances_order_records`;
CREATE TABLE `insurances_order_records`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `policy_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '保险单号',
  `serial_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '我方 销售单号 交易流水号',
  `supplier_id` int NULL DEFAULT NULL COMMENT '供应商ID',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求方法',
  `request` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求参数日志记录',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求响应日志记录',
  `result_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '响应错误码',
  `created_at` datetime NULL DEFAULT NULL,
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注（操作）',
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8316 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for insurances_orders
-- ----------------------------
DROP TABLE IF EXISTS `insurances_orders`;
CREATE TABLE `insurances_orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `serial_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '我方销售单号-交易流水号',
  `order_type` tinyint NULL DEFAULT 1 COMMENT '1、计划位订单 2、团队位订单 3、散客订单， 4其他（第三方销售）',
  `order_area` tinyint NULL DEFAULT 1 COMMENT '1国内订单  2国际订单',
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '销售订单单号',
  `apply_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商订单号',
  `policy_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '保险公司保单号',
  `insurances_id` int NULL DEFAULT 0 COMMENT '险种ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '险种名称',
  `cost` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成本(保费)',
  `costs` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总成本(保费)',
  `is_tinerary` tinyint(1) NULL DEFAULT 0 COMMENT '是否行程单：0否，1是',
  `supplier_id` int NULL DEFAULT 0 COMMENT '供应商ID',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '产品代码',
  `plan_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '计划代码（旅游险）',
  `denomination` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面额',
  `denominations` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总面额',
  `full_premium` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '全额保费（折前销售价）',
  `full_premiums` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总全额保费（折前销售价）',
  `permiun` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保费(销售价)',
  `permiuns` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总保费(销售价)',
  `insured_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '保额(单位：万元)',
  `insured_amounts` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总保额(单位：万元)',
  `quantity` tinyint NULL DEFAULT 1 COMMENT '份数',
  `start_at` datetime NULL DEFAULT NULL COMMENT '保单开始日期时间',
  `end_at` datetime NULL DEFAULT NULL COMMENT '保单结束日期时间',
  `validity_date` tinyint NULL DEFAULT 1 COMMENT '保险期限（天数或次数）',
  `flight_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航变号',
  `flight_date` datetime NULL DEFAULT NULL COMMENT '航班日期',
  `d_port` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发地',
  `a_port` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达地',
  `to_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '旅行目的国家',
  `applicant_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '投保人名称',
  `applicant_card_type` tinyint NULL DEFAULT 1 COMMENT '        1 => \"身份证\",\r\n        2 => \"护照\",\r\n        3 => \"军官证\",\r\n        4 => \"港澳台回乡证\",\r\n        5 => \"港澳台身份证\",\r\n        9 => \"其他\",\r\n        100 => \"统一社会信用代码\",\r\n        101 => \"税务登记证\",\r\n        102 => \"组织机构代码证\",',
  `applicant_card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '投保人证件号',
  `applicant_sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '投保人性别： M:  男     F:  女',
  `applicant_birthday` date NULL DEFAULT NULL COMMENT '投保人生日日期',
  `applicant_mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '投保人手机号',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0待投保，1成功，2失败,3已撤保, 4未投保已取消',
  `pnr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'PNR',
  `down_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '保险公司电子保单下载地址',
  `insurance_discount_rate` tinyint NULL DEFAULT 100 COMMENT '保险折扣率',
  `insurance_discount_json` json NULL COMMENT '保险折扣率规则',
  `dis_id` int NULL DEFAULT 0 COMMENT '分销商id',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8306 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_blacklist
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_blacklist`;
CREATE TABLE `international_airlines_blacklist`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `airline_recode_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司名称',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司二字编码',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号',
  `take_off_time` timestamp NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` timestamp NULL DEFAULT NULL COMMENT '到达时间',
  `a_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `a_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场名称',
  `d_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市',
  `d_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `d_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场名称',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际联航黑名单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_cache_config
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_cache_config`;
CREATE TABLE `international_airlines_cache_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cds_id` int NULL DEFAULT NULL,
  `min_minutes_number` int NULL DEFAULT NULL COMMENT '最小天数',
  `max_minutes_number` int NULL DEFAULT NULL COMMENT '最大天数',
  `cache_length` int NULL DEFAULT NULL COMMENT '数据缓存时长(分钟)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'cds数据缓存配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_cds
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_cds`;
CREATE TABLE `international_airlines_cds`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sales_channel_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售渠道',
  `airline_recode_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司',
  `platform` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运价渠道',
  `refund_rules` tinyint(1) NULL DEFAULT NULL COMMENT '是否替换退改规则  1替换   2不替换',
  `inquiry_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '询价地址',
  `order_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '生单地址',
  `price_check_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '验价地址',
  `sales_scope_add` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '售卖开始时间  几点到几点 24小时时间范围选择',
  `sales_scope_end` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '售卖结束时间  几点到几点 24小时时间范围选择',
  `downgrade` tinyint(1) NULL DEFAULT 2 COMMENT '是否降舱  1是  2否',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '售卖航司cds' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_cds_luggage
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_cds_luggage`;
CREATE TABLE `international_airlines_cds_luggage`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `airline_recode_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司',
  `luggage` int NULL DEFAULT NULL COMMENT '行李 单位kg',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司行李额' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_cds_luggage_rules
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_cds_luggage_rules`;
CREATE TABLE `international_airlines_cds_luggage_rules`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sort` int NULL DEFAULT 1 COMMENT '排序',
  `luggage_id` int NULL DEFAULT NULL COMMENT '行李id',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '售价',
  `mileage_interval_start` int NULL DEFAULT NULL COMMENT '里程开始区间',
  `mileage_interval_end` int NULL DEFAULT NULL COMMENT '里程结束区间',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司行李售价区间' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_cds_routes
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_cds_routes`;
CREATE TABLE `international_airlines_cds_routes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cds_id` int NOT NULL,
  `warm_up` tinyint(1) NULL DEFAULT 2 COMMENT '数据预热开关   1开启  2关闭',
  `cycle_start_day` int NULL DEFAULT NULL COMMENT '周期开始天数',
  `cycle_end_day` int NULL DEFAULT NULL COMMENT '周期结束天数',
  `schedule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班期',
  `a_city` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市',
  `a_city_code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市三字码',
  `d_city` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发城市',
  `d_city_code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发城市三字码',
  `a_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场名称',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场代码',
  `d_port_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场名称',
  `d_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场代码',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '航司cds航线管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_channel
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_channel`;
CREATE TABLE `international_airlines_channel`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `child_channel` int NULL DEFAULT NULL COMMENT '子渠道',
  `channel_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '渠道名称',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '渠道' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_policy
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_policy`;
CREATE TABLE `international_airlines_policy`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `platform` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '运价渠道',
  `sales_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '售卖类型 1：裸票  2：行李',
  `apply_many_sequence` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否适用多程 1适用 2不适用',
  `policy_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '政策名称',
  `policy_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1整单   2分单',
  `model` tinyint(1) NULL DEFAULT 1 COMMENT '1舱位模式  2价格模式',
  `airline_recode_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型',
  `sales_start_day` int NULL DEFAULT NULL COMMENT '售卖开始区间天数',
  `sales_end_day` int NULL DEFAULT NULL COMMENT '售卖结束区间天数',
  `cabin_code` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用仓位',
  `flight` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `flight_type` tinyint(1) NULL DEFAULT 2 COMMENT '适用航班  1适用  2不适用',
  `apply_d_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用航程(起飞机场)',
  `apply_a_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适用航程(到达机场)',
  `no_apply_d_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '不适用航程(起飞机场)',
  `no_apply_a_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '不适用航程(到达机场)',
  `sales_time_add` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售开始时间',
  `sales_time_end` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售结束时间',
  `sales_range_add` timestamp NULL DEFAULT NULL COMMENT '销售开始日期',
  `sales_range_end` timestamp NULL DEFAULT NULL COMMENT '销售结束日期',
  `advance_time` int NULL DEFAULT NULL COMMENT '提前时间(小时)',
  `foreign_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对外说明(无用)',
  `internal_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '对内说明',
  `status` tinyint(1) NULL DEFAULT 2 COMMENT '审核状态  1已审核  2未审核  3 作废 4停用',
  `sales_number` int NULL DEFAULT 0 COMMENT '售卖最大人数',
  `difference_down_values` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '验价差异下区间值',
  `difference_up_values` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '验价差异上区间值',
  `inventory` int NULL DEFAULT 0 COMMENT '库存数',
  `sub_class` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'OTA对外展示舱位',
  `press_position` tinyint(1) NULL DEFAULT 2 COMMENT '压位模式  1开启  2关闭',
  `except_routes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '除外航线',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30153 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际联航销售政策' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_policy_rules
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_policy_rules`;
CREATE TABLE `international_airlines_policy_rules`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sort` int NULL DEFAULT 1,
  `policy_id` int NOT NULL COMMENT '政策id',
  `price_start_interval` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格开始区间',
  `price_end_interval` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格结束区间',
  `proportion` decimal(10, 2) NULL DEFAULT NULL COMMENT '返点比例',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '加减金额',
  `difference_down_values` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '验价亏损值',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 185677 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际联航销售政策规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_record
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_record`;
CREATE TABLE `international_airlines_record`  (
  `record_id` int NOT NULL AUTO_INCREMENT,
  `id` int NULL DEFAULT NULL COMMENT '导入或更新id',
  `error_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '失败理由',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1政策导入  2.cds导入  3.一键更新政策  4.一键更新cds',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际廉航政策导入更新日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_airlines_system
-- ----------------------------
DROP TABLE IF EXISTS `international_airlines_system`;
CREATE TABLE `international_airlines_system`  (
  `id` int NOT NULL,
  `threshold` decimal(10, 2) NULL DEFAULT NULL COMMENT '亏损阀值',
  `shop_switch` tinyint(1) NULL DEFAULT 2 COMMENT '1已开启  2未开启',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际联航系统设置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for international_budget_airline_search
-- ----------------------------
DROP TABLE IF EXISTS `international_budget_airline_search`;
CREATE TABLE `international_budget_airline_search`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `unique_sign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一标识符MD5值',
  `from_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发地城市 IATA 三字码代码',
  `to_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目的地城市 IATA 三字码代码',
  `from_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发日期，格式为 2006-01-02',
  `ret_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回程日期，格式为 2006-01-02',
  `search_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '搜索日期',
  `nums` int NULL DEFAULT 0 COMMENT '查询次数',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '创建日期',
  `update_at` timestamp NULL DEFAULT NULL COMMENT '更新日期',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_sign`(`unique_sign` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2413234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际廉航请求统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for large_custtomer_service_rule
-- ----------------------------
DROP TABLE IF EXISTS `large_custtomer_service_rule`;
CREATE TABLE `large_custtomer_service_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `airline_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `national` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '国内：N，国际：I',
  `issue_ticket_channel` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '出票渠道',
  `office_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票office号',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大客服出票规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for market_data_import_records
-- ----------------------------
DROP TABLE IF EXISTS `market_data_import_records`;
CREATE TABLE `market_data_import_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件地址',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `total_number` int NOT NULL DEFAULT 0 COMMENT '统计数',
  `completed_number` int NOT NULL DEFAULT 0 COMMENT '已执行数',
  `filesize` bigint NOT NULL DEFAULT 0 COMMENT '文件大小',
  `hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '加密字符',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'MD5',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态：0等待，1上传中，2成功，3失败',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '导入类型',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注内容',
  `file_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件类型',
  `order_no` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `operator_name`(`operator_name` ASC) USING BTREE,
  INDEX `hash`(`hash` ASC) USING BTREE,
  INDEX `md5`(`md5` ASC) USING BTREE,
  INDEX `type_index`(`type` ASC) USING BTREE,
  INDEX `order_no_index`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '导入记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for market_data_international_202209
-- ----------------------------
DROP TABLE IF EXISTS `market_data_international_202209`;
CREATE TABLE `market_data_international_202209`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `carrier_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `airport_line` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '机场三字码',
  `transaction_date` datetime NULL DEFAULT NULL COMMENT '交易日期',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建日期',
  `creator` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `agency_user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_carrier_code`(`carrier_code` ASC) USING BTREE,
  INDEX `index_airport_line`(`airport_line` ASC) USING BTREE,
  INDEX `index_code_line`(`carrier_code` ASC, `airport_line` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 245853 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for market_data_international_202210
-- ----------------------------
DROP TABLE IF EXISTS `market_data_international_202210`;
CREATE TABLE `market_data_international_202210`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `carrier_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `airport_line` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '机场三字码',
  `transaction_date` datetime NULL DEFAULT NULL COMMENT '交易日期',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建日期',
  `creator` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `agency_user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_carrier_code`(`carrier_code` ASC) USING BTREE,
  INDEX `index_airport_line`(`airport_line` ASC) USING BTREE,
  INDEX `index_code_line`(`carrier_code` ASC, `airport_line` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1754556 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `batch` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notices
-- ----------------------------
DROP TABLE IF EXISTS `notices`;
CREATE TABLE `notices`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '类容',
  `is_popup` tinyint NULL DEFAULT 2 COMMENT '是否弹窗：1是，2否',
  `is_top` tinyint NULL DEFAULT 2 COMMENT '是否置顶：1是，2否',
  `release_level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '发布等级',
  `user_id` int NULL DEFAULT 0 COMMENT '用户ID',
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '作者',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for open_app
-- ----------------------------
DROP TABLE IF EXISTS `open_app`;
CREATE TABLE `open_app`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名字',
  `key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密钥',
  `notify` tinyint(1) NULL DEFAULT 0 COMMENT '是否通知',
  `notify_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '通知地址',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '开放应用' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for open_order_record
-- ----------------------------
DROP TABLE IF EXISTS `open_order_record`;
CREATE TABLE `open_order_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_id` int NOT NULL COMMENT '应用id',
  `order_platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单平台:asms=胜意',
  `order_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '订单类型:1=国内订单,2=国际订单',
  `order_source` tinyint(1) NOT NULL DEFAULT 1 COMMENT '订单来源:1=正常单出票,2=改签单审核,3=改签单支付,4=退票单审核,5=退票单处理',
  `out_order_no` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '外部订单号',
  `pnr` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'PNR',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:1：待处理 2：已处理',
  `notify_count` tinyint(1) NULL DEFAULT 0 COMMENT '通知次数',
  `notify_status` tinyint(1) NULL DEFAULT 0 COMMENT '推送状态,0=待推送,1=推送成功,2=推送失败',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_auto_rules
-- ----------------------------
DROP TABLE IF EXISTS `order_auto_rules`;
CREATE TABLE `order_auto_rules`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `sort` int NOT NULL DEFAULT 10 COMMENT '规则优先级：越大优先级越高',
  `effect_start_time` datetime NULL DEFAULT NULL COMMENT '生效开始时间',
  `effect_end_time` datetime NULL DEFAULT NULL COMMENT '生效截至时间',
  `sale_channel` int NOT NULL DEFAULT 0 COMMENT '销售渠道ID',
  `voyage` tinyint NOT NULL DEFAULT 2 COMMENT '适用航程：1 往返  2 单程  3 连程',
  `accept_company` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '承运航司 航司2字码',
  `start_place` json NULL COMMENT '始发地,格式{\"include\":\"1,2,3,4\",\"exclude\":\"21,456,234\"}',
  `road_place` json NULL COMMENT '途径地{\"include\":\"1,2,3,4\",\"exclude\":\"21,456,234\"}',
  `end_place` json NULL COMMENT '目的地{\"include\":\"1,2,3,4\",\"exclude\":\"21,456,234\"}',
  `product_sign` json NULL COMMENT '产品标识{\"include\":\"1,2,3,4\",\"exclude\":\"21,456,234\"}',
  `policy_id` json NULL COMMENT '政策ID{\"include\":\"1,2,3,4\",\"exclude\":\"21,456,234\"}',
  `office_no` json NULL COMMENT 'office号{\"include\":\"1,2,3,4\",\"exclude\":\"21,456,234\"}',
  `passenger_number` json NULL COMMENT '乘机人数量{“min”:1,\"max\":4}',
  `travel_time` json NULL COMMENT '旅行时间{\"min\":\"2021-06-30 10:23\",\"max\":\"2022-06-30 10:00\"}',
  `cabin` json NULL COMMENT '舱位{\"include\":\"1,2,3,4\",\"exclude\":\"21,456,234\"}',
  `policy_type` json NULL COMMENT '政策类型{\"include\":\"1,2,3\",\"exclude\":\"\"}1.公转私2.公布运价3.私有运价',
  `is_auth_ticket` tinyint(1) NULL DEFAULT 0 COMMENT '是否授权票号',
  `auth_ticket_office` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '授权票号office',
  `is_auth_pnr` tinyint(1) NULL DEFAULT 0 COMMENT '是否授权编码',
  `auth_pnr_office` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '授权编码office',
  `is_aduchd` tinyint(1) NULL DEFAULT 0 COMMENT '是否能出成人儿童',
  `chd_ticket_price` tinyint(1) NULL DEFAULT 0 COMMENT '儿童出票限制',
  `change_pnr_err` tinyint(1) NULL DEFAULT 1 COMMENT '换编失败操作',
  `check_qtb` tinyint(1) NULL DEFAULT 0 COMMENT '是否检查qtb运价',
  `qtb_cmd` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票价高于qtb执行指令',
  `ticket_price_min` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价最低',
  `ticket_price_max` decimal(10, 2) NULL DEFAULT 10000.00 COMMENT '票价最高',
  `ticket_price_type` tinyint(1) NULL DEFAULT 1 COMMENT '票价范围类型,1固定金额,2比例',
  `min_age` int NULL DEFAULT 0 COMMENT '最小年龄',
  `max_age` int NULL DEFAULT 99 COMMENT '最大年龄',
  `check_baggage` tinyint(1) NULL DEFAULT 0 COMMENT '检查行李',
  `check_cabin` tinyint(1) NULL DEFAULT 0 COMMENT '检查舱位',
  `update_email` tinyint(1) NULL DEFAULT 0 COMMENT '更新邮箱',
  `delete_line` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '删除行',
  `sale_farebasic` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售运价代码',
  `brand_name` varbinary(200) NULL DEFAULT NULL COMMENT '品牌运价',
  `passenger_type` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人类型',
  `is_cnn` tinyint(1) NULL DEFAULT 0 COMMENT '是否能出儿童票：0否，1是',
  `platform` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票平台',
  `issue_ticket_channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票渠道',
  `split_order` tinyint(1) NULL DEFAULT 0 COMMENT '分离订单是否出票：0否，1是',
  `issue_ticket_office` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票office号',
  `use_office_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_retry` tinyint(1) NULL DEFAULT 1 COMMENT '是否重试出票：1是，0否',
  `price_number_limit` int NULL DEFAULT NULL COMMENT 'QTEQ至少多少个价格出票',
  `issue_ticket_price_type` tinyint(1) NULL DEFAULT 1 COMMENT '出票价格类型：1.最低价格出票，2.指定价格出票',
  `price_range` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '价格区间',
  `ticket_counter` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票台',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `deleted_at` datetime NULL DEFAULT NULL,
  `creator` int NULL DEFAULT NULL COMMENT '创建者',
  `editor` int NULL DEFAULT NULL COMMENT '修改者',
  `is_change_pnr` tinyint(1) NULL DEFAULT 0 COMMENT '是否更换编码，0.否，1是',
  `change_pnr_office` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '换编OFFICE号',
  `manual_agent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手输代理费',
  `ticket_add_cmd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票额外指令',
  `issue_ticket_start_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票开始时间 时分',
  `issue_ticket_end_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票结束时间 时分',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '自动出票规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_log
-- ----------------------------
DROP TABLE IF EXISTS `order_log`;
CREATE TABLE `order_log`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `operator` int NULL DEFAULT NULL COMMENT '操作人',
  `operator_type` smallint NULL DEFAULT NULL COMMENT '操作类型',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '日志内容',
  `extra_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '额外内容 开发人员查看',
  `log_level` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志级别',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `operator`(`operator` ASC) USING BTREE,
  INDEX `created_index`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1015529 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单异动日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_change_order
-- ----------------------------
DROP TABLE IF EXISTS `ota_change_order`;
CREATE TABLE `ota_change_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台销售单订单号',
  `ota_platform` int NULL DEFAULT NULL COMMENT '所属ota销售平台',
  `purchase_platform` tinyint NULL DEFAULT NULL COMMENT '采购平台',
  `office_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `store_id` int NULL DEFAULT NULL COMMENT '所属店铺',
  `import_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '导单类型：1.系统导入，2.手工录入',
  `source_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '来源：1.销售单，2.改签单',
  `flight_way` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '1往返 2单程 3联程',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '改签单扭转状态：1.待审核，2.改签中，3.改签成功，4.改签失败,5.改签驳回，6.取消改签，7.待支付',
  `audit_status` tinyint NULL DEFAULT NULL COMMENT '审核状态：1.待审核，2.一审通过，3.一审拒绝，4.二审通过，5.二审拒绝',
  `issue_bill_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'ota平台订单号',
  `rebooking_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台改签单ID',
  `reason_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'ota改签原因：0.普通自愿改签，1.航变改签',
  `change_type` tinyint NOT NULL DEFAULT 1 COMMENT '改签类型：1.改期，2.升仓，3.更改航程',
  `pid` int NULL DEFAULT NULL COMMENT '改签单改期时，所属改签单id',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签原因',
  `a_pid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所有的父级id，逗号分隔',
  `order_date` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota申请时间戳',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `apply_uid` int NULL DEFAULT 0 COMMENT '申请人',
  `recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台PNR',
  `contact_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人姓名',
  `contact_mobile_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人手机号',
  `contact_tel_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人号码',
  `contact_email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人邮箱',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '订单备注',
  `audit_uid` int NULL DEFAULT NULL COMMENT '审核人',
  `complete_uid` int NULL DEFAULT 0 COMMENT '二审，完成人',
  `complete_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '二审，完成人',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `deadline_time` datetime NULL DEFAULT NULL COMMENT 'ota平台最晚处理时间',
  `time_zone` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时区',
  `aerial_change` tinyint NOT NULL DEFAULT 0 COMMENT '1:发生航变标记  0:未发生标记',
  `passenger_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旅客分组',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19706 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_change_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `ota_change_order_relation`;
CREATE TABLE `ota_change_order_relation`  (
  `relation_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '1.新航程，2.旧航程',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `old_ticket_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧票号',
  `ticket_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价',
  `ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金',
  `ticket_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票税总额=票价+税金',
  `price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票税差',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其他费用',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签服务费',
  `trouble_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费用',
  `change_total_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签总费用 = 票税差+其它费用+服务费+改签费+其它费用',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16893 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_change_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `ota_change_passenger_info`;
CREATE TABLE `ota_change_passenger_info`  (
  `passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` int NULL DEFAULT NULL COMMENT '改签单ID',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建改签单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `agency_office_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票office号',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `data_change_last_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 创建时间',
  `date_change_create_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 最后修改时间',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票单号和 主体出票单主体单号一致',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `is_adult_ticket_for_child` tinyint(1) NULL DEFAULT NULL COMMENT '儿童订成人票标识  1 是 2否',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `old_passenger_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`passenger_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_change_refund_record
-- ----------------------------
DROP TABLE IF EXISTS `ota_change_refund_record`;
CREATE TABLE `ota_change_refund_record`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `source` tinyint NULL DEFAULT NULL COMMENT '1正常单，2改签单',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '1改签，2退票',
  `passenger_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `card_no` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人证件号',
  `sequence` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航段起达机场三字码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13919 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单改签，退票记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_change_sequence
-- ----------------------------
DROP TABLE IF EXISTS `ota_change_sequence`;
CREATE TABLE `ota_change_sequence`  (
  `sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '1.新航程，2.旧航程',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市名称',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市名称',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `agency_office_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 票台回填 OfficeNo',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `take_off_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班到达时间',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大舱位',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`sequence_id`) USING BTREE,
  INDEX `order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14934 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单航段信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_order_clock_counts
-- ----------------------------
DROP TABLE IF EXISTS `ota_order_clock_counts`;
CREATE TABLE `ota_order_clock_counts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `air_company_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航司二字码',
  `platform_id` int NULL DEFAULT 0 COMMENT '采购渠道id',
  `date` date NULL DEFAULT NULL COMMENT '日期',
  `clock_0` tinyint NULL DEFAULT 0 COMMENT '0点',
  `clock_1` tinyint NULL DEFAULT 0 COMMENT '1点',
  `clock_2` tinyint NULL DEFAULT 0 COMMENT '2点',
  `clock_3` tinyint NULL DEFAULT 0 COMMENT '3点',
  `clock_4` tinyint NULL DEFAULT 0 COMMENT '4点',
  `clock_5` tinyint NULL DEFAULT 0 COMMENT '5点',
  `clock_6` tinyint NULL DEFAULT 0 COMMENT '6点',
  `clock_7` tinyint NULL DEFAULT 0 COMMENT '7点',
  `clock_8` tinyint NULL DEFAULT 0 COMMENT '8点',
  `clock_9` tinyint NULL DEFAULT 0 COMMENT '9点',
  `clock_10` tinyint NULL DEFAULT 0 COMMENT '10点',
  `clock_11` tinyint NULL DEFAULT 0 COMMENT '11点',
  `clock_12` tinyint NULL DEFAULT 0 COMMENT '12点',
  `clock_13` tinyint NULL DEFAULT 0 COMMENT '13点',
  `clock_14` tinyint NULL DEFAULT 0 COMMENT '14点',
  `clock_15` tinyint NULL DEFAULT 0 COMMENT '15点',
  `clock_16` tinyint NULL DEFAULT 0 COMMENT '16点',
  `clock_17` tinyint NULL DEFAULT 0 COMMENT '17点',
  `clock_18` tinyint NULL DEFAULT 0 COMMENT '18点',
  `clock_19` tinyint NULL DEFAULT 0 COMMENT '19点',
  `clock_20` tinyint NULL DEFAULT 0 COMMENT '20点',
  `clock_21` tinyint NULL DEFAULT 0 COMMENT '21点',
  `clock_22` tinyint NULL DEFAULT 0 COMMENT '22点',
  `clock_23` tinyint NULL DEFAULT 0 COMMENT '23点',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `air_company_code`(`air_company_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7154 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出票业绩统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_order_log
-- ----------------------------
DROP TABLE IF EXISTS `ota_order_log`;
CREATE TABLE `ota_order_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作内容',
  `user_id` int NULL DEFAULT NULL COMMENT '操作人',
  `order_no` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `order_type` tinyint NULL DEFAULT NULL COMMENT '订单类型  2：改签单  3：退票单',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 182491 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单 退票单流转日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_refund_audit
-- ----------------------------
DROP TABLE IF EXISTS `ota_refund_audit`;
CREATE TABLE `ota_refund_audit`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `audit_uid` int NULL DEFAULT NULL COMMENT '审核人',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退废单号',
  `audit_times` tinyint NULL DEFAULT NULL COMMENT '1 一审 2 复审',
  `audit_type` tinyint NULL DEFAULT NULL COMMENT '1同意 2 驳回',
  `reason` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33315 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退废单审核记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `ota_refund_order`;
CREATE TABLE `ota_refund_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ota_platform` tinyint(1) NOT NULL DEFAULT 1 COMMENT '来源平台',
  `purchase_platform` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '采购平台',
  `source_type` tinyint(1) NULL DEFAULT 1 COMMENT '退废来源  1 销售单退废 2改签单退废',
  `import_type` tinyint(1) NULL DEFAULT NULL COMMENT '导入类型  1 ota自动  2 手动 ',
  `refund_type` tinyint(1) NULL DEFAULT NULL COMMENT '退废类型 1退票 2废票',
  `refund_idea_type` tinyint(1) NULL DEFAULT NULL COMMENT '自愿退废  1 是  2 否',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票原因',
  `store_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台销售单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `ota_refund_no` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台退票单号',
  `ota_sign_hash` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单哈希标识',
  `refund_status` tinyint(1) NULL DEFAULT 1 COMMENT '自建平台退废流转状态 1待处理 2待复审 3已驳回  4待提交\r\n 6提交失败 7 已提交 8已完成 9已取消',
  `returned_status` tinyint(1) NULL DEFAULT 2 COMMENT '回款状态 1 已回款 2 未回款',
  `submit_status` tinyint(1) NULL DEFAULT 1 COMMENT '提交状态  1未提交  2 部分提交 3 全部提交',
  `has_returned_difference` tinyint(1) NULL DEFAULT 1 COMMENT '回款差异  1无  2有差异',
  `ota_status` tinyint(1) NULL DEFAULT 1 COMMENT 'ota申请状态 1待审核 2已审核 3 销售端ota已退款 4已驳回',
  `ota_rt_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `apply_uid` int NULL DEFAULT NULL COMMENT '申请人',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `office_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `tickets` tinyint(1) NOT NULL DEFAULT 1 COMMENT '票数',
  `refund_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退款描述',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '取消原因',
  `urgency` tinyint(1) NOT NULL DEFAULT 0 COMMENT '紧急度 0无色，一般 1蓝色，起飞前4小时 2橙色，当日航班 3紫色，已起飞',
  `take_off_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `first_audit_uid` int NULL DEFAULT NULL COMMENT '一审人',
  `first_audit_time` timestamp NULL DEFAULT NULL COMMENT '一审时间',
  `recheck_audit_uid` int NULL DEFAULT NULL COMMENT '复审人',
  `recheck_audit_time` timestamp NULL DEFAULT NULL COMMENT '复审时间',
  `order_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单备注',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_mobile_phone` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人手机号',
  `contact_tel_phone` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人电话',
  `contact_email` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人email',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `submitted_time` timestamp NULL DEFAULT NULL COMMENT '已提交时间',
  `completed_time` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `aerial_change` tinyint NOT NULL DEFAULT 0 COMMENT '1:发生航变标记  0:未发生标记',
  `is_retain` tinyint(1) NULL DEFAULT 2 COMMENT '是否留单：1.是，2.否',
  `deadline_to_hold_an_order` datetime NULL DEFAULT NULL COMMENT '留单截止时间',
  `operator_id` int NULL DEFAULT 0 COMMENT '完成人',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '完成人',
  `passenger_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旅客分组',
  `cancel_seat_time` timestamp NULL DEFAULT NULL COMMENT '取位时间',
  `noshow` tinyint(1) NULL DEFAULT 0 COMMENT '是否noshow对赌标记',
  `noshow_status` tinyint(1) NULL DEFAULT 0 COMMENT '状态:0=待对赌,1=对赌成功,2=对赌失败',
  `noshow_time` timestamp NULL DEFAULT NULL COMMENT 'NoShow时间',
  `noshow_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT 'nowshow金额',
  `cancel_last_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '取位最晚时限',
  `flight_change` tinyint(1) NULL DEFAULT 0 COMMENT '是否有航变',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id` ASC) USING BTREE,
  UNIQUE INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE,
  INDEX `ota_sign_hash`(`ota_sign_hash` ASC) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 145594 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ota  退款订单申请' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_refund_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `ota_refund_order_relation`;
CREATE TABLE `ota_refund_order_relation`  (
  `refund_relation_id` bigint NOT NULL AUTO_INCREMENT,
  `refund_passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `refund_sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退款单号',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `office_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `ticket_no` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '票号',
  `ticket_no_extra` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '额外票号',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售票价',
  `sale_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售税费',
  `sale_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售服务费',
  `sale_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售其它费用',
  `sale_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售代理费用',
  `sale_refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售退票费',
  `sale_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售应退金额',
  `relation_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '关联数据状态 1正常',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 205317 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_refund_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `ota_refund_passenger_info`;
CREATE TABLE `ota_refund_passenger_info`  (
  `refund_passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_passenger_id`) USING BTREE,
  INDEX `refund_order_no_index`(`refund_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 182495 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_refund_sequence
-- ----------------------------
DROP TABLE IF EXISTS `ota_refund_sequence`;
CREATE TABLE `ota_refund_sequence`  (
  `refund_sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市代码',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `arrival_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班到达时间',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `take_off_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_sequence_id`) USING BTREE,
  INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 161858 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款单航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_sale_baggage
-- ----------------------------
DROP TABLE IF EXISTS `ota_sale_baggage`;
CREATE TABLE `ota_sale_baggage`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售单号',
  `segment_no` tinyint(1) NOT NULL COMMENT '航段序号',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '行李额类型：0.托运行李，1.手提行李，2.餐食，3.行李+餐食',
  `weight` int NULL DEFAULT 0 COMMENT '行李重量',
  `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '行李额说明',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `passenger_id` int NULL DEFAULT 0 COMMENT '乘客id',
  `price` decimal(6, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `piece` int NULL DEFAULT 1 COMMENT '件数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 93252 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际销售单行李额表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_sale_label
-- ----------------------------
DROP TABLE IF EXISTS `ota_sale_label`;
CREATE TABLE `ota_sale_label`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sale_order_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `label` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `desc` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否显示：1.是，2.否',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 639 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '国际销售单标签' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_sale_order
-- ----------------------------
DROP TABLE IF EXISTS `ota_sale_order`;
CREATE TABLE `ota_sale_order`  (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台内部单号',
  `ota_platform` tinyint(1) NOT NULL DEFAULT 1 COMMENT '销售平台 1携程 2去哪儿',
  `flight_way` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '1往返 2单程 3联程',
  `adtk` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT ' PNR 最晚保留时间ADTK 时间  毫秒级',
  `validity_time` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单有效时间,pnr-最晚出票-运价有效取最低',
  `price_effective_time` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '运价有效时间',
  `time_zone` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT ' 时区',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售票面价',
  `sale_floor_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售底价',
  `sale_tax_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售税费',
  `sale_service_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售服务费',
  `sale_settle_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售含税结算价',
  `sale_floor_settle_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售含税结算底价',
  `airline_recode_no` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码 大记录编号',
  `cancel_issue_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT ' 取消出票单状态,0:非取消1:取消申请2:供应商确认取消',
  `data_change_create_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方创建时间',
  `data_change_last_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '第三方最后修改时间',
  `ei_remark` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '冗余字段 出票 EI 项(退改签政策等)',
  `ext_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '冗余字段 B2C 网站入库号',
  `flight_class` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单类型 I:国际  N:国内',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台出票订单单号',
  `intl_rebook_order` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '冗余字段  国际改签单表示,该字段国际专用。T:国际改签单F:非国际改签单   ',
  `is_vip` tinyint(1) NULL DEFAULT NULL COMMENT '冗余字段 1 表示fase 2表示true',
  `issue_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT ' 出票备注（含商旅三方协议内容等）\r',
  `issue_status` tinyint NOT NULL DEFAULT 1 COMMENT '1:待出票 2:出票失败（自动出票：出票失败） 3:出票中 4 待交票 5已出票',
  `order_status` tinyint NOT NULL DEFAULT 1 COMMENT '1:待出票  5:出票失败 10:出票中（在航司创建订单中）15、待支付 20、支付失败 25、待交票 30、已出票   40、待回填  45、已回填 50、回填失败 55、取消订单',
  `pay_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1、待支付 2、已支付 3支付失败',
  `ticket_notify_status` tinyint(1) NULL DEFAULT 1 COMMENT '1、未回填 2、已回填 3、回填失败',
  `issue_way` tinyint(1) NULL DEFAULT 3 COMMENT '出票方式 1:自动出票 2:手工出票 3：未操作',
  `last_print_ticket_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT ' 最晚出票时间',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `office_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT ' 出票配置',
  `order_date` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预订时间',
  `policy_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策 Code',
  `policy_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '政策描述',
  `policy_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策 ID',
  `policy_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '政策类型',
  `policy_type_platform` tinyint(1) NULL DEFAULT 0 COMMENT '自建平台政策类型 1公转私 2公布运价 3私有运价 4其他 5CSD私有',
  `recode_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小记录编号 订位 RecordNo  订位PNR（新）',
  `old_recode_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧pnr',
  `sale_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售种类 \r\n国内：\r\nAirLineMarketing:航司直销\r\nPriorityPackage:优选套餐\r\nBusinessPriority:商务优选\r\nTravelPackage:旅行套餐\r\n国际：\r\nPrioritizing:商务优选\r\nExclusive:旅行套餐',
  `ticket_type` tinyint(1) NULL DEFAULT NULL COMMENT ' 票种1:BSP\r\n2:B2B\r\n3:B2C\r\n4:P2P',
  `urge_times` int NULL DEFAULT 0 COMMENT '催出票次数',
  `urgency` tinyint(1) NULL DEFAULT 0 COMMENT '出票紧急度\r\n1:临近转出时间 （距离转出小于\r\n30 分钟）\r\n2:催出票 （urgencyTimes>0）\r\n3:AV 舱位不足 5 个\r\n4:临近 PNR ADTK （距离 ADTK\r\n大于 3 小时）\r\n5:出票超时长规范（进入超过 1 小\r\n时）\r\n6:普通',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台录入时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `ota_order_no_info` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota订单号信息',
  `old_airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧大编码',
  `is_change_pnr_issue_ticket` tinyint(1) NULL DEFAULT 0 COMMENT '是否换编出票，0否，1是',
  `downgrade_ticket_math_rules_status` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '降舱出票规则匹配状态：0 未开始匹配，1 匹配成功，2 匹配失败（出票前）',
  `downgrade_ticket_rule_id` int UNSIGNED NULL DEFAULT 0 COMMENT '降舱出票规则id（出票前）',
  `downgrade_ticket_status` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '降舱出票状态:1=降舱出票扫描中,2=降舱降价,3=降舱,4=降价,5=人工出票,6=规则已禁用,7=异常（出票前）',
  `downgrade_after_ticket_math_rules_status` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '出票后降舱规则匹配状态：0 未开始匹配，1 匹配成功，2 匹配失败（出票后）',
  `downgrade_after_ticket_rule_id` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '出票后降舱规则id（出票后）',
  `downgrade_after_ticket_status` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '出票后降舱状态:1=降舱出票扫描中,2=降舱降价,3=降舱,4=降价,5=人工出票,6=规则已禁用,7=异常（出票前）',
  `aerial_change` tinyint NOT NULL DEFAULT 0 COMMENT '1:发生航变标记  0:未发生标记',
  `addit_type` tinyint(1) NULL DEFAULT 0 COMMENT '附加类型：0正常，1.改签退，2.OPEN，3.对赌',
  `remark` varchar(1023) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `customer_ownership` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '客户归属',
  `salesperson` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '销售人员',
  `drawer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '出票人员',
  `ticket_out_id` int NULL DEFAULT 0 COMMENT '后台出票人ID',
  `ticket_out_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '后台出票人姓名',
  `other_platform_tag` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '其它平台订单的标识',
  `is_customer_ticket` tinyint(1) NULL DEFAULT 0 COMMENT '是否大客户出票：0否，1是',
  `passenger_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旅客分组',
  `contact_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人姓名',
  `contact_tel` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人电话',
  `ota_sync_status` tinyint(1) NULL DEFAULT 0 COMMENT 'ota平台同步状态,0=待同步,1=同步成功,2=同步失败,3=不满足条件不同步',
  `new_price_type` tinyint(1) NULL DEFAULT 0 COMMENT '最新价格类型:0=一致,1=高,2=低',
  `new_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '最新价格',
  `auto_ticket_error` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自动出票错误消息',
  `is_downgrade` tinyint(1) NULL DEFAULT 0 COMMENT '是否降舱订单',
  `currency_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '销售货币代码',
  `brand_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '品牌名',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `order_id`(`order_id` ASC) USING BTREE,
  UNIQUE INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `issue_bill_id`(`issue_bill_id` ASC) USING BTREE,
  INDEX `issue_status`(`issue_status` ASC) USING BTREE,
  INDEX `order_status`(`order_status` ASC) USING BTREE,
  INDEX `ota_platform`(`ota_platform` ASC) USING BTREE,
  INDEX `ota_sync_status`(`ota_sync_status` ASC) USING BTREE,
  INDEX `store_id`(`store_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102053 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售单主订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_sale_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `ota_sale_order_relation`;
CREATE TABLE `ota_sale_order_relation`  (
  `relation_id` bigint NOT NULL AUTO_INCREMENT,
  `passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售票面价',
  `sale_floor_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售底价',
  `sale_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售税费',
  `sale_service_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售服务费',
  `sale_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售含税结算价',
  `sale_floor_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售含税结算底价',
  `ticket_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '票号',
  `relation_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '关联数据状态 1正常',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `currency_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '销售货币代码',
  PRIMARY KEY (`relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 195326 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_sale_order_remark
-- ----------------------------
DROP TABLE IF EXISTS `ota_sale_order_remark`;
CREATE TABLE `ota_sale_order_remark`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `operator` int NOT NULL DEFAULT 0 COMMENT '操作人id',
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '订单来源：1正常单，2改签单，3退票单',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 151458 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售单签注表\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_sale_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `ota_sale_passenger_info`;
CREATE TABLE `ota_sale_passenger_info`  (
  `passenger_id` bigint NOT NULL AUTO_INCREMENT,
  `ota_passenger_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台乘机人ID',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `agency_office_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票office号',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `agency_airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大编码PNR,供应商回填小编码,供应商订位',
  `old_agency_recode_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧pnr',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `data_change_last_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 创建时间',
  `date_change_create_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 最后修改时间',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票单号和 主体出票单主体单号一致',
  `nationality` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '乘机人姓名',
  `is_adult_ticket_for_child` tinyint(1) NOT NULL DEFAULT 2 COMMENT '儿童订成人票标识  1 是 2否',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `old_passenger_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '旧乘机人信息',
  `check_ticket_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '验票状态：1.待验票，2.验票成功，3.验票失败',
  `check_ticket_resp` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '验票结果',
  `cds_context` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '支付时，CDS系统返回值',
  `customer_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '大客户编码',
  `is_ticket` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否出票，0否，1.是',
  `is_false_ticket_no` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否假票号：0否，1是',
  `email` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY (`passenger_id`) USING BTREE,
  UNIQUE INDEX `passenger_id`(`passenger_id` ASC) USING BTREE,
  INDEX `passenger_name`(`passenger_name` ASC) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `pnr_index`(`agency_recode_no` ASC) USING BTREE,
  INDEX `big_png_index`(`agency_airline_recode_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 135697 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ota_sale_sequence
-- ----------------------------
DROP TABLE IF EXISTS `ota_sale_sequence`;
CREATE TABLE `ota_sale_sequence`  (
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `ota_sequence_id` bigint NULL DEFAULT NULL COMMENT 'ota平台航段索引',
  `order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '第三方 时区',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市代码',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航司大编码',
  `old_airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧大编码',
  `agency_office_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '三方 票台回填 OfficeNo',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `old_agency_recode_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '旧编码',
  `arrival_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班到达时间',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `foreign_cost` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '底价（外币）',
  `data_change_last_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '三方 创建时间',
  `foreign_print_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票面价（外币）',
  `foreign_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '机建费（外币）',
  `foreign_oil_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '燃油费(外币)',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票单号和 主体出票单号一致',
  `oil_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '燃油费',
  `print_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '票面价',
  `sequence` int NULL DEFAULT 1 COMMENT '航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '子舱位',
  `take_off_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税费',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `ticket_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回填的票号',
  `air_line_code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回填的航司开票三字码',
  `updated_at` timestamp NULL DEFAULT NULL,
  `air_company_code` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '航司二字码',
  `beijing_time_dep` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞北京时间',
  `beijing_time_arr` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达北京时间',
  PRIMARY KEY (`sequence_id`) USING BTREE,
  UNIQUE INDEX `sequence_id`(`sequence_id` ASC) USING BTREE,
  INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `take_off_time`(`take_off_time` ASC) USING BTREE,
  INDEX `flight`(`flight` ASC) USING BTREE,
  INDEX `air_company_code`(`air_company_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 137884 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '销售单航段 信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_bit
-- ----------------------------
DROP TABLE IF EXISTS `plan_bit`;
CREATE TABLE `plan_bit`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `plan_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '计划位名称',
  `airline_recode_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司',
  `three_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司订单号',
  `floor_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '底价',
  `to_airline_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '面向航司票价(需支付金额)',
  `seat_num` int NULL DEFAULT 0 COMMENT '可售座位数',
  `init_seat_num` int NOT NULL DEFAULT 0 COMMENT '总库存',
  `airline_periods` int NULL DEFAULT NULL COMMENT '面向航司期数',
  `last_ticket_time` datetime NULL DEFAULT NULL COMMENT '最晚出票时间',
  `freeze_seat_num` int NULL DEFAULT NULL COMMENT '冻结座位数',
  `last_confirm_time` datetime NULL DEFAULT NULL COMMENT '最晚确认出行人时间',
  `airline_group_ratio` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最低成团比(面向航司)',
  `distributor_group_ratio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最低成团比(面向客户)',
  `last_group_num` int NULL DEFAULT NULL COMMENT '最少成团人数',
  `last_ticket_num` int NULL DEFAULT 0 COMMENT '最低开票人数(面向客户)',
  `group_status` tinyint NULL DEFAULT 2 COMMENT '成团状态  1已成团   2未成团',
  `sale_status` tinyint NULL DEFAULT 1 COMMENT '销售状态   1已开售   2未开售 ',
  `status` tinyint NULL DEFAULT 1 COMMENT '1开启   2关闭',
  `thaw_time` datetime NULL DEFAULT NULL COMMENT '默认解冻时间',
  `baby_ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '婴儿票价',
  `delayed_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '延时费用',
  `delayed_time` int NULL DEFAULT 0 COMMENT '延时时间(分钟)',
  `purchase_platform` int NULL DEFAULT NULL COMMENT '采购渠道',
  `flight_type` tinyint(1) NULL DEFAULT 1 COMMENT '1往返  2单程  3联程   4缺口程',
  `plan_type` tinyint(1) NULL DEFAULT 1 COMMENT '1国内订单   2国际订单',
  `airline_automatic_ticket` tinyint(1) NULL DEFAULT 2 COMMENT '面向航司是否自动转票款  1是 2否',
  `ticket_status` tinyint(1) NULL DEFAULT 2 COMMENT '是否出票  1是   2否',
  `airline_freeze_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '面向航司冻结金',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `seat_num`(`seat_num` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1066 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_bit_index
-- ----------------------------
DROP TABLE IF EXISTS `plan_bit_index`;
CREATE TABLE `plan_bit_index`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `image_path` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '首页展示图片',
  `city_code` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市三字码',
  `city_name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `weight` int NULL DEFAULT NULL COMMENT '权重',
  `start_time` datetime NULL DEFAULT NULL COMMENT '有效开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '有效结束时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `common_index`(`city_code` ASC, `start_time` ASC, `end_time` ASC, `deleted_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位首页推荐列表图片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_bit_rules
-- ----------------------------
DROP TABLE IF EXISTS `plan_bit_rules`;
CREATE TABLE `plan_bit_rules`  (
  `rules_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `sales_range_add` datetime NULL DEFAULT NULL COMMENT '销售日期区间开始时间',
  `sales_range_end` datetime NULL DEFAULT NULL COMMENT '销售日期区间结束时间',
  `is_insurance` tinyint(1) NULL DEFAULT 2 COMMENT '是否强制搭售保险 1是  2 否',
  `is_spell` tinyint(1) NOT NULL DEFAULT 2 COMMENT '是否已成团接受散拼 1是 2否',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '1开启   2关闭',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`rules_id`) USING BTREE,
  INDEX `plan_id_and_status`(`plan_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1059 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '售卖规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_bit_rules_child
-- ----------------------------
DROP TABLE IF EXISTS `plan_bit_rules_child`;
CREATE TABLE `plan_bit_rules_child`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `rules_id` int NULL DEFAULT NULL COMMENT '售卖规则id',
  `associated_id` int NULL DEFAULT NULL COMMENT '关联id(level:等级id、specific:特定分销商id)',
  `proportion` decimal(11, 2) NULL DEFAULT NULL COMMENT '加减比例',
  `pot_symbol` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加减比例类型 +  -',
  `money` decimal(11, 2) NULL DEFAULT NULL COMMENT '加减金额',
  `mon_symbl` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加减金额类型 + -',
  `type` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'level:等级  specific:特定分销商',
  `deleted_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ass_id_and_type`(`associated_id` ASC, `type` ASC) USING BTREE,
  INDEX `rules_id`(`rules_id` ASC, `type` ASC, `associated_id` ASC, `deleted_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29925 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '售卖规则加价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_bit_sequence
-- ----------------------------
DROP TABLE IF EXISTS `plan_bit_sequence`;
CREATE TABLE `plan_bit_sequence`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场',
  `a_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场',
  `flight` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班号',
  `take_off_time` timestamp NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` timestamp NULL DEFAULT NULL COMMENT '到达时间',
  `sequence` int NOT NULL DEFAULT 1 COMMENT '航段',
  `tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '每个航段机建费',
  `fuel_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '燃油费',
  `stopover` tinyint NULL DEFAULT 2 COMMENT '经停  1是  2否',
  `stopover_info` json NULL COMMENT '经停信息',
  `chd_fuel_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '儿童燃油费',
  `mileage` int NULL DEFAULT NULL COMMENT '里程(公里数)',
  `luggage` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '行李',
  `d_port_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场',
  `a_port_name` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `plan_id_index`(`plan_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1881 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_cash_pledge
-- ----------------------------
DROP TABLE IF EXISTS `plan_cash_pledge`;
CREATE TABLE `plan_cash_pledge`  (
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `person_nums_id` int NULL DEFAULT 0 COMMENT '团队人数id',
  `serial_number` int NULL DEFAULT NULL COMMENT '序号(第几押)',
  `proportion` int NULL DEFAULT NULL COMMENT '比例',
  `end_time` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '截至时间(第几押时间)',
  `cash_pledge_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 面向客户  2面向航司',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  INDEX `plan_id|serial_number|end_time`(`plan_id` ASC, `serial_number` ASC, `end_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位 分期表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_flight_refund
-- ----------------------------
DROP TABLE IF EXISTS `plan_flight_refund`;
CREATE TABLE `plan_flight_refund`  (
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `starting_at` int NULL DEFAULT NULL COMMENT '起始时间 大于或等于起始时间  小时单位',
  `termination_at` int NULL DEFAULT NULL COMMENT '终止时间 小于终止时间 ',
  `refund_rate` int NULL DEFAULT NULL COMMENT '退款比例  正整数',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退票规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_freeze_record
-- ----------------------------
DROP TABLE IF EXISTS `plan_freeze_record`;
CREATE TABLE `plan_freeze_record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_id` int NOT NULL DEFAULT 0 COMMENT '计划id',
  `freeze_seat_num` int NOT NULL DEFAULT 0 COMMENT '冻结座位数',
  `thaw_time` timestamp NULL DEFAULT NULL COMMENT '解冻时间',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1冻结中   2已解冻',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '冻结座位记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plan_person_nums
-- ----------------------------
DROP TABLE IF EXISTS `plan_person_nums`;
CREATE TABLE `plan_person_nums`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `plan_id` int NULL DEFAULT NULL COMMENT '计划位id',
  `lowest` int NULL DEFAULT NULL COMMENT '最低人数',
  `highest` int NULL DEFAULT NULL COMMENT '最高人数',
  `distributor_periods` int NULL DEFAULT NULL COMMENT '面向客户  分期期数',
  `distributor_group_ratio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '面向客户 最低成团比',
  `change_number` tinyint(1) NULL DEFAULT NULL COMMENT '是否更改人数  1是     2否',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `plan_id`(`plan_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2265 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计划位团队人数表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for policy_purchase_channel
-- ----------------------------
DROP TABLE IF EXISTS `policy_purchase_channel`;
CREATE TABLE `policy_purchase_channel`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `policy_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '政策ID',
  `purchase_channel_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '采购渠道编码',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '配置政策ID的采购渠道' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for policy_tickets_analysis
-- ----------------------------
DROP TABLE IF EXISTS `policy_tickets_analysis`;
CREATE TABLE `policy_tickets_analysis`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `airline_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `policy_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '政策类型',
  `store_id` int NOT NULL COMMENT '店铺ID',
  `issue_tickets` int NOT NULL DEFAULT 0 COMMENT '出票数量',
  `refund_tickets` int NOT NULL DEFAULT 0 COMMENT '退票数量',
  `print_ticket_date` date NOT NULL COMMENT '出票日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `airline_code_index`(`airline_code` ASC) USING BTREE,
  INDEX `policy_type_index`(`policy_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20717 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '政策类型票量/退票率统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for policy_tickets_analysis_item
-- ----------------------------
DROP TABLE IF EXISTS `policy_tickets_analysis_item`;
CREATE TABLE `policy_tickets_analysis_item`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `pid` int NOT NULL COMMENT '主表ID',
  `policy_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '政策类型',
  `store_id` int NOT NULL COMMENT '店铺ID',
  `airline_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售单号',
  `issue_tickets` int NOT NULL DEFAULT 0 COMMENT '出票数量',
  `refund_tickets` int NOT NULL DEFAULT 0 COMMENT '退票数量',
  `print_ticket_time` datetime NOT NULL COMMENT '出票日期',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `refund_order_nos` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '退票单号，多个逗号分割',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 94679 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '政策类型票量统计子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for press_in_position_logs
-- ----------------------------
DROP TABLE IF EXISTS `press_in_position_logs`;
CREATE TABLE `press_in_position_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `rule_id` int NOT NULL DEFAULT 0 COMMENT '规则id',
  `rule_type` tinyint NOT NULL DEFAULT 0 COMMENT '规则类型：1 压位，2 余位扫描',
  `record_id` int NOT NULL DEFAULT 0 COMMENT '压位记录id',
  `airline_recode_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `d_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场',
  `a_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场',
  `take_off_time` datetime NOT NULL COMMENT '起飞时间（格式：年-月-日）',
  `flight` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号',
  `sub_class` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志内容',
  `data` json NOT NULL COMMENT '要记录的数据',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '类型：1 正常，2 异常',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rule_id`(`rule_id` ASC) USING BTREE,
  INDEX `record_id`(`record_id` ASC) USING BTREE,
  INDEX `rule_type`(`rule_type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '压位日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for press_in_position_record
-- ----------------------------
DROP TABLE IF EXISTS `press_in_position_record`;
CREATE TABLE `press_in_position_record`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `airline_recode_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `d_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场',
  `a_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场',
  `take_off_time` datetime NOT NULL COMMENT '起飞时间（格式：年-月-日）',
  `flight` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号',
  `sub_class` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `pnr` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'pnr编码',
  `expiration_time` datetime NOT NULL COMMENT '失效时间',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pnr`(`pnr` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '压位记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for press_in_position_rule
-- ----------------------------
DROP TABLE IF EXISTS `press_in_position_rule`;
CREATE TABLE `press_in_position_rule`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则名称',
  `airline_recode_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `d_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场',
  `a_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场',
  `take_off_time` datetime NOT NULL COMMENT '起飞时间（格式：年-月-日）',
  `flights` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号，多个用英文逗号隔开',
  `sub_class` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `auto_cycle_interval_time` int NOT NULL DEFAULT 0 COMMENT '自动循环间隔时间（单位：秒）',
  `release_position_start_time` time NOT NULL COMMENT '释放位置开始时间（格式：时 : 分）',
  `release_position_end_time` time NOT NULL COMMENT '释放位置结束时间（格式：时 : 分）',
  `effective_start_time` datetime NOT NULL COMMENT '生效开始时间',
  `effective_end_time` datetime NOT NULL COMMENT '生效结束时间',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态：0 禁用，1 启用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '压位规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for press_in_position_rule_logs
-- ----------------------------
DROP TABLE IF EXISTS `press_in_position_rule_logs`;
CREATE TABLE `press_in_position_rule_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `rule_id` int NOT NULL DEFAULT 0 COMMENT '规则id',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '操作类型：1 新增，2 修改，3 删除',
  `operator_id` int NOT NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `data_before_update` json NULL COMMENT '更新前数据',
  `data_after_update` json NULL COMMENT '更新后数据',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rule_id`(`rule_id` ASC) USING BTREE,
  INDEX `operator_id`(`operator_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '压位规则更变日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_banks
-- ----------------------------
DROP TABLE IF EXISTS `purchase_banks`;
CREATE TABLE `purchase_banks`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `ota_platform` tinyint(1) NULL DEFAULT NULL COMMENT '平台',
  `relation_id` int NULL DEFAULT NULL COMMENT '中间表id',
  `purchase_passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `purchase_sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `ticket_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `a_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市代码',
  `a_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `take_off_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达时间',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `print_ticket_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票时间',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `status` tinyint(1) NULL DEFAULT 15 COMMENT '0:OPEN FOR USE(客票有效),\n1:REFUND(已退票),\n2:EXCHANGED (机票换开),\n3:VOID(已作废),\n4:USED/FLOWN(客票已使用),\n5:CHECK IN(已经办理登机),\n6:SUSPENDED(挂起状态，客票不能使用),\n7:PRINT/EXCH(已打印登机牌，还未上机),\n8:LFET/ABOARD(正在飞行),\n9:AIRP CNTL/YY(机场控制),\n10:CPN NOTE(航段有提示)\n11、FIM EXCH 被换开中断仓单\n12、CHANGE 客票已经换开。\n13、PAPER TICKET 此票为用电子客票换开的纸票(用纸票票号提出显示)\n14：未知  15：未扫描  16异常',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '异常信息',
  `query_results` json NULL COMMENT '查询结果',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 105742 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购信息票号扫描' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_change_order
-- ----------------------------
DROP TABLE IF EXISTS `purchase_change_order`;
CREATE TABLE `purchase_change_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `sale_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台销售单订单号',
  `purchase_change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签采购单号',
  `ota_platform` int NULL DEFAULT NULL COMMENT '所属ota销售平台',
  `purchase_platform` tinyint NULL DEFAULT NULL COMMENT '采购平台',
  `office_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `store_id` int NULL DEFAULT NULL COMMENT '所属店铺',
  `import_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '导单类型：1.系统导入，2.手工录入',
  `source_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '来源：1.销售单，2.改签单',
  `flight_way` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '1往返 2单程 3联程',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `issue_bill_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单号',
  `rebooking_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台改签单号',
  `pnr` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4056 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_change_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `purchase_change_order_relation`;
CREATE TABLE `purchase_change_order_relation`  (
  `relation_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `purchase_change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签采购单号',
  `ticket_no` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价',
  `ticket_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '税金',
  `ticket_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价+税金-票价*代理费率',
  `agent_rate` float(10, 2) NULL DEFAULT 0.00 COMMENT '代理费率',
  `price_differential` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票税差',
  `other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '其它费用',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签服务费',
  `trouble_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签费用',
  `change_total_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签总费用',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_new_ticket_no` tinyint(1) NULL DEFAULT 1 COMMENT '是否为新票号回填',
  `foreign_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '外币金额',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '外币类型',
  `currency_rate` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '汇率',
  PRIMARY KEY (`relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6354 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_change_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `purchase_change_passenger_info`;
CREATE TABLE `purchase_change_passenger_info`  (
  `passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` int NULL DEFAULT NULL COMMENT '改签单ID',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建改签单号',
  `purchase_change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '改签采购单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `agency_office_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票office号',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `data_change_last_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 创建时间',
  `date_change_create_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 最后修改时间',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票单号和 主体出票单主体单号一致',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `is_adult_ticket_for_child` tinyint(1) NULL DEFAULT NULL COMMENT '儿童订成人票标识  1 是 2否',
  `passenger_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`passenger_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4835 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_change_sequence
-- ----------------------------
DROP TABLE IF EXISTS `purchase_change_sequence`;
CREATE TABLE `purchase_change_sequence`  (
  `sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签销售单号',
  `purchase_change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签采购单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市名称',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市名称',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `agency_office_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 票台回填 OfficeNo',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `take_off_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `arrival_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班到达时间',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大舱位',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`sequence_id`) USING BTREE,
  INDEX `order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5249 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签单航段信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `purchase_order`;
CREATE TABLE `purchase_order`  (
  `purchase_order_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台内部销售单单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `purchase_platform` int NOT NULL DEFAULT 1 COMMENT '采购平台 1 BSP 2:B2B 3BOP 4:OP',
  `office_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `purchase_ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '采购总票面价',
  `purchase_tax_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '采购总税金',
  `purchase_baggage_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购行李额',
  `purchase_settle_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '采购总价',
  `flight_way` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '1往返 2单程 3联程',
  `adtk` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT ' PNR 最晚保留时间ADTK 时间  毫秒级',
  `time_zone` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT ' 时区',
  `airline_recode_no` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码 大记录编号',
  `cancel_issue_status` tinyint(1) NULL DEFAULT 0 COMMENT ' 取消出票单状态,0:非取消1:取消申请2:供应商确认取消',
  `data_change_create_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方创建时间',
  `data_change_last_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方最后修改时间',
  `ei_remark` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票 EI 项(退改签政策等)',
  `ext_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'B2C 网站入库号',
  `flight_class` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单类型 I:国际  N:国内',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台出票订单单号',
  `intl_rebook_order` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国际改签单表示,该字段国际专用。T:国际改签单F:非国际改签单',
  `issue_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT ' 出票备注（含商旅三方协议内容等）\r',
  `order_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1:待出票 2:出票失败（自动出票：出票失败） 3:出票中 4、支付失败\r\n5、支付成功\r\n6 待交票\r\n7、 已出票  8、待回填 9、已回填 10、回填失败',
  `issue_way` tinyint(1) NULL DEFAULT NULL COMMENT '出票方式 1:自动出票 2:手工出票',
  `last_print_ticket_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT ' 最晚出票时间',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `order_date` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预订时间',
  `policy_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策 Code',
  `policy_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策 ID',
  `policy_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策类型',
  `recode_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小记录编号 订位 RecordNo  订位PNR',
  `sale_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售种类 \r\n国内：\r\nAirLineMarketing:航司直销\r\nPriorityPackage:优选套餐\r\nBusinessPriority:商务优选\r\nTravelPackage:旅行套餐\r\n国际：\r\nPrioritizing:商务优选\r\nExclusive:旅行套餐',
  `ticket_type` tinyint(1) NULL DEFAULT NULL COMMENT ' 票种1:BSP\r\n2:B2B\r\n3:B2C\r\n4:P2P',
  `urge_times` int NULL DEFAULT NULL COMMENT '催出票次数',
  `urgency` tinyint(1) NULL DEFAULT NULL COMMENT '出票紧急度\r\n1:临近转出时间 （距离转出小于\r\n30 分钟）\r\n2:催出票 （urgencyTimes>0）\r\n3:AV 舱位不足 5 个\r\n4:临近 PNR ADTK （距离 ADTK\r\n大于 3 小时）\r\n5:出票超时长规范（进入超过 1 小\r\n时）\r\n6:普通',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '录入时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `subject_id` int NOT NULL DEFAULT 7 COMMENT '收支科目ID',
  `serial_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付流水号',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购信息备注',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作的用户名',
  `contacts` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `tel` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `e_mail` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `contacts_remarks` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人备注信息',
  `delivery_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配送信息',
  `ota_order_no_info` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台订单号信息',
  `protocol_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '协议号',
  `position_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '定位代码',
  `position_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '定位费',
  `ticket_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开票代码',
  `ticket_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '开票费',
  PRIMARY KEY (`purchase_order_id`) USING BTREE,
  INDEX `purchase_order_no`(`purchase_order_no` ASC) USING BTREE,
  INDEX `flight_class`(`flight_class` ASC) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `order_status`(`order_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 96871 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购单主订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_order_notify
-- ----------------------------
DROP TABLE IF EXISTS `purchase_order_notify`;
CREATE TABLE `purchase_order_notify`  (
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购单号',
  `notify_status` tinyint(1) NULL DEFAULT NULL COMMENT '1 成功 2 失败 3处理中',
  `fail_reason` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '失败原因',
  `retry_times` int NULL DEFAULT NULL COMMENT '重试次数',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`sale_order_no`) USING BTREE,
  UNIQUE INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  UNIQUE INDEX `purchase_order_no`(`purchase_order_no` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '回填记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `purchase_order_relation`;
CREATE TABLE `purchase_order_relation`  (
  `relation_id` bigint NOT NULL AUTO_INCREMENT,
  `purchase_passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `purchase_sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购订单号',
  `purchase_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购票面价（包含行李额）',
  `purchase_tax_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购税费',
  `purchase_settle_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购含税结算价',
  `agent_rate` float NULL DEFAULT 0 COMMENT '代理费率',
  `agent_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '代理奖励金额（采购票面价*代理费率）',
  `ticket_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购票号',
  `ticket_no_extra` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第二个票号',
  `relation_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '关联数据状态 1正常',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `baggage_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '行李额',
  `foreign_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '外币金额',
  `currency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CNY' COMMENT '币种',
  `after_rebate_rate` float NOT NULL DEFAULT 0 COMMENT '后返费率',
  `after_rebate_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '后返金额',
  `currency_rate` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '币种汇率',
  PRIMARY KEY (`relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `ticket_no`(`ticket_no` ASC) USING BTREE,
  INDEX `purchase_passenger_id`(`purchase_passenger_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 189213 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `purchase_passenger_info`;
CREATE TABLE `purchase_passenger_info`  (
  `purchase_passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `agency_office_no` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票office号',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `agency_airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大编码PNR,供应商回填小编码,供应商订位',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `email` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `data_change_last_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 创建时间',
  `date_change_create_time` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 最后修改时间',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票单号和 主体出票单主体单号一致',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `is_adult_ticket_for_child` tinyint(1) NULL DEFAULT 2 COMMENT '儿童订成人票标识  1 是 2否',
  `passenger_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `ota_passenger_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台乘机人id',
  `customer_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '大客户代码',
  PRIMARY KEY (`purchase_passenger_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `pnr_index`(`agency_recode_no` ASC) USING BTREE,
  INDEX `big_png_index`(`agency_airline_recode_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 133094 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_price
-- ----------------------------
DROP TABLE IF EXISTS `purchase_price`;
CREATE TABLE `purchase_price`  (
  `purchase_price_id` int NOT NULL AUTO_INCREMENT,
  `purchase_order_id` int NULL DEFAULT NULL COMMENT '订单id',
  `relation_id_ids` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出行人和航段关联中间表 id 集合',
  `purchase_platform` int NULL DEFAULT NULL COMMENT '采购渠道 1BSP',
  `pnr` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'pnr信息',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售平台单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `ticket_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `ticket_price` int NULL DEFAULT NULL COMMENT '采购票面价',
  `tax_price` int NULL DEFAULT NULL COMMENT '采购税费',
  `build_price` int NULL DEFAULT NULL COMMENT '采购机建费',
  `settle_price` int NULL DEFAULT NULL COMMENT '采购结算价',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`purchase_price_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127908 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购单票号及采购价格表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for purchase_sequence
-- ----------------------------
DROP TABLE IF EXISTS `purchase_sequence`;
CREATE TABLE `purchase_sequence`  (
  `purchase_sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市代码',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `agency_office_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 票台回填 OfficeNo',
  `agency_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小编码PNR,供应商回填小编码,供应商订位 RecordNo',
  `arrival_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班到达时间',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `data_change_last_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '三方 创建时间',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `issue_bill_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票单号和 主体出票单号一致',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `take_off_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `ota_sequence_id` bigint NULL DEFAULT NULL COMMENT 'ota平台航段ID',
  PRIMARY KEY (`purchase_sequence_id`) USING BTREE,
  INDEX `purchase_order_no`(`purchase_order_no` ASC) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `sequence`(`sequence` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 135011 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购单航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for refund_purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `refund_purchase_order`;
CREATE TABLE `refund_purchase_order`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `ota_platform` tinyint(1) NOT NULL DEFAULT 1 COMMENT '来源平台',
  `purchase_platform` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购平台',
  `source_type` tinyint(1) NULL DEFAULT 1 COMMENT '退废来源  1 销售单退废 2改签单退废',
  `import_type` tinyint(1) NULL DEFAULT NULL COMMENT '导入类型  1 ota自动  2 手动 ',
  `refund_type` tinyint(1) NULL DEFAULT NULL COMMENT '退废类型 1退票 2废票',
  `refund_idea_type` tinyint(1) NULL DEFAULT NULL COMMENT '自愿退废  1 是  2 否',
  `refund_idea_desc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '非自愿退票说明',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票原因',
  `store_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台销售单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `change_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台改签单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `refund_purchase_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自己平台退款采购单号',
  `ota_refund_no` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台退票单号',
  `returned_status` tinyint(1) NULL DEFAULT 2 COMMENT '回款状态 1 已回款 2 未回款',
  `has_returned_difference` tinyint(1) NULL DEFAULT 1 COMMENT '回款差异  1无  2有差异',
  `ota_status` tinyint(1) NULL DEFAULT 1 COMMENT 'ota申请状态 1待审核 2已审核 3 销售端ota已退款 4已驳回',
  `ota_rt_time` timestamp NULL DEFAULT NULL COMMENT '申请时间',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `office_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `tickets` tinyint(1) NOT NULL DEFAULT 1 COMMENT '票数',
  `refund_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退款描述',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '取消原因',
  `urgency` tinyint(1) NOT NULL DEFAULT 0 COMMENT '紧急度 0无色，一般 1蓝色，起飞前4小时 2橙色，当日航班 3紫色，已起飞',
  `take_off_time` char(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `order_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `noshow_time` timestamp NULL DEFAULT NULL COMMENT 'NoShow时间',
  `noshow_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT 'noshow金额',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE,
  UNIQUE INDEX `refund_purchase_order_no`(`refund_purchase_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 141503 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款订单采购表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for refund_purchase_order_relation
-- ----------------------------
DROP TABLE IF EXISTS `refund_purchase_order_relation`;
CREATE TABLE `refund_purchase_order_relation`  (
  `refund_relation_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `refund_passenger_id` int NULL DEFAULT NULL COMMENT '出行人id',
  `refund_sequence_id` int NULL DEFAULT NULL COMMENT '航段id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退款单号',
  `refund_purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自己平台退款采购单号',
  `pnr` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `office_no` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生编office号',
  `ticket_no` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '票号',
  `ticket_no_extra` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '额外票号',
  `purchase_ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购票价',
  `purchase_tax` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购税费',
  `purchase_service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购服务费',
  `purchase_other_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购其它费',
  `purchase_agency_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购代理费',
  `purchase_refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购退票费',
  `purchase_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '采购应退金额',
  `airline_refund_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '航司应退金额',
  `diff_money` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '差异金额',
  `relation_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '关联数据状态 1正常',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `voluntarily` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0',
  PRIMARY KEY (`refund_relation_id`) USING BTREE,
  INDEX `sale_order_no`(`sale_order_no` ASC) USING BTREE,
  INDEX `refund_order_no`(`refund_order_no` ASC) USING BTREE,
  INDEX `refund_purchase_order_no`(`refund_purchase_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 203434 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '出行人和航段中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for refund_purchase_passenger_info
-- ----------------------------
DROP TABLE IF EXISTS `refund_purchase_passenger_info`;
CREATE TABLE `refund_purchase_passenger_info`  (
  `refund_passenger_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台退款单号',
  `refund_purchase_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自己平台退款采购单号',
  `submit_status` tinyint(1) NOT NULL DEFAULT 2 COMMENT '1 已提交 2 未提交',
  `age_type` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄类型 ADU:成人 CHD:儿童 INF:婴儿',
  `birth_date` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人出生日期',
  `card_no` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号',
  `card_time_limit` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件有效期',
  `card_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件类型',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别  M男  S女',
  `nationality` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国籍',
  `passenger_name` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘机人姓名',
  `passenger_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '乘客类型\r\nLAB:劳务人员\r\nSEA:海员\r\nMBR:会员\r\nTAI:台商\r\nSTU:学生\r\nYOU:青年\r\nNEW:新移民\r\nEMI:移民\r\nNOR:普通\r\nADU:成人\r\nCHD(CHI):儿童\r\nBAB(INF):婴儿\r',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  `voluntarily` tinyint NULL DEFAULT 0 COMMENT '提交航司退票类型：1自愿，2非自愿',
  PRIMARY KEY (`refund_passenger_id`) USING BTREE,
  INDEX `refund_purchase_order_no`(`refund_purchase_order_no` ASC) USING BTREE,
  INDEX `purchase_order_no_index`(`purchase_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 180282 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款采购单出行人信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for refund_purchase_sequence
-- ----------------------------
DROP TABLE IF EXISTS `refund_purchase_sequence`;
CREATE TABLE `refund_purchase_sequence`  (
  `refund_sequence_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台订单号',
  `refund_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自建平台采购单号',
  `refund_purchase_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自己平台退款采购单号',
  `time_zone` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方 时区',
  `a_city` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达城市代码',
  `a_port` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '到达机场代码',
  `airline_recode_no` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司大编码',
  `arrival_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班到达时间',
  `d_city` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞城市代码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞机场代码',
  `flight` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航班',
  `sequence` int NULL DEFAULT NULL COMMENT '航段',
  `sub_class` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子舱位',
  `take_off_time` char(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间',
  `air_line_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司编号',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`refund_sequence_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 203436 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款采购单航段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for remaining_seats_scan_logs
-- ----------------------------
DROP TABLE IF EXISTS `remaining_seats_scan_logs`;
CREATE TABLE `remaining_seats_scan_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `rule_id` int NOT NULL DEFAULT 0 COMMENT '规则id',
  `airline_recode_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `d_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场',
  `a_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场',
  `take_off_time` datetime NOT NULL COMMENT '起飞时间（格式：年-月-日）',
  `flight` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号',
  `message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志内容',
  `data` json NOT NULL COMMENT '要记录的数据',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '类型：1 正常，2 异常',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rule_id`(`rule_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '余位扫描日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for remaining_seats_scan_record
-- ----------------------------
DROP TABLE IF EXISTS `remaining_seats_scan_record`;
CREATE TABLE `remaining_seats_scan_record`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `airline_recode_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `d_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场',
  `a_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场',
  `take_off_time` datetime NOT NULL COMMENT '起飞时间（格式：年-月-日）',
  `flight` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号',
  `sub_class` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '舱位',
  `number_of_seats_remaining` int NOT NULL DEFAULT 0 COMMENT '剩余座位数',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '余位扫描记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for remaining_seats_scan_rules
-- ----------------------------
DROP TABLE IF EXISTS `remaining_seats_scan_rules`;
CREATE TABLE `remaining_seats_scan_rules`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '规则名称',
  `airline_recode_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `d_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '起飞机场',
  `a_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达机场',
  `flights` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航班号，多个用英文逗号隔开',
  `next_few_days` tinyint NOT NULL DEFAULT 0 COMMENT '未来几天（单位：天，如7天，则扫描今天后7天的数据）',
  `scan_interval_time` int NOT NULL DEFAULT 0 COMMENT '扫描间隔时间（单位：秒）',
  `release_position_start_time` time NOT NULL COMMENT '释放位置开始时间（格式：时 : 分）',
  `release_position_end_time` time NOT NULL COMMENT '释放位置结束时间（格式：时 : 分）',
  `lower_than_how_many` tinyint NOT NULL DEFAULT 0 COMMENT '低于多少个自动压位',
  `effective_start_time` datetime NOT NULL COMMENT '生效开始时间',
  `effective_end_time` datetime NOT NULL COMMENT '生效结束时间',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态：0 禁用，1 启用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '余位扫描规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for remaining_seats_scan_rules_logs
-- ----------------------------
DROP TABLE IF EXISTS `remaining_seats_scan_rules_logs`;
CREATE TABLE `remaining_seats_scan_rules_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `rule_id` int NOT NULL DEFAULT 0 COMMENT '规则id',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '操作类型：1 新增，2 修改，3 删除',
  `operator_id` int NOT NULL DEFAULT 0 COMMENT '操作人id',
  `operator_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `data_before_update` json NULL COMMENT '更新前数据',
  `data_after_update` json NULL COMMENT '更新后数据',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rule_id`(`rule_id` ASC) USING BTREE,
  INDEX `operator_id`(`operator_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '余位扫描规则更变日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sale_performance_statistics
-- ----------------------------
DROP TABLE IF EXISTS `sale_performance_statistics`;
CREATE TABLE `sale_performance_statistics`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `air_company_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航司二字码',
  `flight_segment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '航段',
  `order_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单类型',
  `sale_platform` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售平台',
  `sale_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售渠道',
  `salesperson` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销售员',
  `purchase_platform` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购平台',
  `purchase_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道',
  `drawer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '出票人',
  `sale_order_no` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '票号',
  `sale_settle_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '销售含税结算价',
  `purchase_settle_price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '采购含税结算价',
  `profit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '利润',
  `after_rebate_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '后返',
  `print_ticket_time` datetime NULL DEFAULT NULL COMMENT '出票时间',
  `today_at` date NULL DEFAULT NULL COMMENT '创建日期',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `_today_ticket_no_index`(`air_company_code` ASC, `flight_segment` ASC, `ticket_no` ASC, `today_at` ASC) USING BTREE,
  INDEX `print_ticket_time_index`(`print_ticket_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 172486 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sales_quotas
-- ----------------------------
DROP TABLE IF EXISTS `sales_quotas`;
CREATE TABLE `sales_quotas`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `office_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购office_no',
  `sales_tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '销售标识',
  `max_quota` decimal(10, 2) NULL DEFAULT NULL COMMENT '最大配额,单位（万）',
  `current_date` date NULL DEFAULT NULL COMMENT '当前日期',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `used_quotas` decimal(10, 2) NULL DEFAULT NULL COMMENT '已使用配额',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_date`(`office_no` ASC, `sales_tag` ASC, `current_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sales_quotas_records
-- ----------------------------
DROP TABLE IF EXISTS `sales_quotas_records`;
CREATE TABLE `sales_quotas_records`  (
  `id` int NOT NULL,
  `sales_quotas_id` int NULL DEFAULT NULL,
  `current_date` date NULL DEFAULT NULL COMMENT '当前日期',
  `record` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '记录',
  `operator_id` int NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sales_quotas_settings
-- ----------------------------
DROP TABLE IF EXISTS `sales_quotas_settings`;
CREATE TABLE `sales_quotas_settings`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '',
  `office_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '采购office_no',
  `sales_tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '销售标识',
  `max_quota` decimal(10, 2) NULL DEFAULT NULL COMMENT '限制额,单位（万）',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_date`(`office_no` ASC, `sales_tag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for split_order_rules
-- ----------------------------
DROP TABLE IF EXISTS `split_order_rules`;
CREATE TABLE `split_order_rules`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则名称',
  `sale_channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销售渠道id',
  `air_line_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码,格式CA,CZ,HU',
  `policy_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '政策代码航司,格式{\"include\":[\"DU-DZ-华为-300\",\"DU-GS华为-2P-300\"],\"exclude\":[\"DU-GJB-3P-300\"]}',
  `policy_code_suffix` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策代码后缀，格式500,300',
  `policy_code_prefix` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政策代码前缀，格式500,300',
  `capacity_limit` int NULL DEFAULT NULL COMMENT '人数限制',
  `cabin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '舱位，格式C,D,E',
  `split_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拆分类型 1:按照订单人数拆分 2:按照乘客年龄段拆分3:按照成人+儿童订单类型拆分',
  `split_num` int NULL DEFAULT NULL COMMENT '按照订单人数拆分人数',
  `split_age` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '按照乘客年龄段拆分 格式:18-24/55-99',
  `split_passenger_type` tinyint(1) NULL DEFAULT NULL COMMENT '按照成人+儿童订单类型拆分 1:只拆儿童 2:成人儿童指定人数拆',
  `split_passenger_num` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '成人儿童指定人数拆人数 格式:儿童人数/成人人数 1/1',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1启用 0禁用',
  `sort` int NULL DEFAULT NULL COMMENT '权重',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退废单审核记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for standby_seat_order
-- ----------------------------
DROP TABLE IF EXISTS `standby_seat_order`;
CREATE TABLE `standby_seat_order`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '自建平台内部单号',
  `rule_id` int NOT NULL DEFAULT 0 COMMENT '规则id',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态:1=扫描中,2=已调出,3=异常,4=取消',
  `validity_time` datetime NULL DEFAULT NULL COMMENT '最晚调出时间',
  `sale_ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售票面价',
  `sale_tax_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售税费',
  `sale_settle_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售结算价',
  `last_ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最新销售票面价',
  `last_tax_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最新销售税费',
  `last_settle_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最新销售结算价',
  `price_data` json NULL COMMENT '票价数据',
  `last_cabin` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最新舱位',
  `last_yuwei` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最新余位',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '降舱出票订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for standby_seat_rules
-- ----------------------------
DROP TABLE IF EXISTS `standby_seat_rules`;
CREATE TABLE `standby_seat_rules`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则名称',
  `effect_start_time` datetime NULL DEFAULT NULL COMMENT '生效开始时间',
  `effect_end_time` datetime NULL DEFAULT NULL COMMENT '失效截止时间',
  `sale_channel` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售渠道id',
  `policy_codes` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '自建平台政策编码',
  `voyage` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '适用航程：1往返 2单程 3联程 4缺口程 5多程',
  `office_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'OFFICE号 有就是生编',
  `scan_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '扫描渠道：1ibe+ 2OTA外采 3运价直连，可多选',
  `ota_channel` json NULL COMMENT 'OTA渠道code 多选',
  `air_line_code` json NULL COMMENT '航司,格式{\"include\":[\"3U\",\"8C\",\"8L\",\"9C\"],\"exclude\":[\"9h\",\"AQ\",\"A6\"]}',
  `cabin` json NULL COMMENT '舱位,格式{\"include\":[\"U\",\"9\",\"I\",\"Y\"],\"exclude\":[\"Z\",\"P\",\"C\"]}',
  `start_place` json NULL COMMENT '始发地,格式{\"include\":[\"DGG\",\"CLO\",\"UCT\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `road_place` json NULL COMMENT '途径地,格式{\"include\":[\"DGG\",\"CLO\",\"CLO\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `end_place` json NULL COMMENT '目的地,格式{\"include\":[\"DGG\",\"CLO\",\"CLO\",\"AAL\"],\"exclude\":[\"AAQ\",\"AAR\",\"JEG\"]}',
  `auto_ticket_issuance` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '是否自动出票：0 否，1 是',
  `amount_below_purchase_price` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '低于进单采购价X调出（单位：元）',
  `latest_ticket_issuance_time` int NULL DEFAULT NULL COMMENT '临近最晚出票时限前X调出（单位：秒）',
  `sort` int UNSIGNED NULL DEFAULT 0 COMMENT '规则优先级',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态：0 禁用，1 启用',
  `ota_time_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '起飞时间扫描规则',
  `exclude_date` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '排除日期',
  `downgrade_same_cabin_yuwei` int NULL DEFAULT 1 COMMENT '同舱余位小于调出',
  `downgrade_no_same_cabin_yuwei` int NULL DEFAULT NULL COMMENT '非同舱余位小于调出',
  `price_diff_same_cabin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '超出同舱差价范围通知',
  `price_diff_up_cabin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '超出升舱价差范围通知',
  `price_diff_down_cabin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '超出降舱价差范围通知',
  `scan_time_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时间区间扫描规则',
  `down_price` int NULL DEFAULT 20 COMMENT '降价标准',
  `work_time_start` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '工作开始时间',
  `work_time_end` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '工作结束时间',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '追位规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for standby_seat_rules_logs
-- ----------------------------
DROP TABLE IF EXISTS `standby_seat_rules_logs`;
CREATE TABLE `standby_seat_rules_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `dtr_id` int UNSIGNED NULL DEFAULT NULL COMMENT '降舱出票规则记录id',
  `type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '操作类型：1 新增，2 修改，3 删除',
  `operator` int UNSIGNED NULL DEFAULT NULL COMMENT '操作人id',
  `data_before_update` json NULL COMMENT '更新前数据',
  `data_after_update` json NULL COMMENT '更新后数据',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '追位规则更变日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for standby_seat_scan_logs
-- ----------------------------
DROP TABLE IF EXISTS `standby_seat_scan_logs`;
CREATE TABLE `standby_seat_scan_logs`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `status` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '追位状态:1=追位扫描中,2=追位成功,3=追位失败',
  `rule_id` int UNSIGNED NULL DEFAULT NULL COMMENT '扫描规则id',
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台内部单号',
  `order_sale_settle_price` decimal(10, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '进单价',
  `last_settle_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '本次查询价',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_no`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '追位扫描日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_apis
-- ----------------------------
DROP TABLE IF EXISTS `sys_apis`;
CREATE TABLE `sys_apis`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '查询：read，添加：create，更新：update，删除：delete',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称（查询、添加、更新、删除）',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'api路径',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'api中文描述',
  `api_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'api组',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'POST' COMMENT '请求方式',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间 null未删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sys_apis_path_index`(`path` ASC) USING BTREE,
  INDEX `sys_apis_api_group_index`(`api_group` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1395 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—请求接口表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_b2b_airline
-- ----------------------------
DROP TABLE IF EXISTS `sys_b2b_airline`;
CREATE TABLE `sys_b2b_airline`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NULL DEFAULT 0 COMMENT '类型，0全部,1国内,2国际',
  `airline_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司二字码',
  `aircode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司编码',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '航司名称',
  `is_refund` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否支持退票，0不支持，1支持',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_b2b_bank
-- ----------------------------
DROP TABLE IF EXISTS `sys_b2b_bank`;
CREATE TABLE `sys_b2b_bank`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `realname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账户姓名',
  `id_card_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号码',
  `bank_card_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '银行卡号',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号码',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '银行卡管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_capital_subject
-- ----------------------------
DROP TABLE IF EXISTS `sys_capital_subject`;
CREATE TABLE `sys_capital_subject`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科目名称',
  `pay_company` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付公司',
  `pay_company_type` tinyint(1) NULL DEFAULT NULL COMMENT '支付公司类型：1.第三方公司，2.银行，3.虚拟币',
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收款账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科目类型：1.收入，2.支出',
  `ext_type` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '附加参数类型',
  `ext` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '附加参数',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 96 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资金科目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'key值',
  `value` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'value值',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '组',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_operation_records_key_unique`(`key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_custom_export
-- ----------------------------
DROP TABLE IF EXISTS `sys_custom_export`;
CREATE TABLE `sys_custom_export`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '导出字段',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模板名',
  `type` tinyint NULL DEFAULT NULL COMMENT '1:正常单 2：改签单 3:退票单',
  `type_model` tinyint NULL DEFAULT NULL COMMENT '1:运营管理导出  2:财务管理导出',
  `created_at` datetime NULL DEFAULT NULL COMMENT '自建平台 创建时间',
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '自定义模板导出-运营-财务' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_department_menus
-- ----------------------------
DROP TABLE IF EXISTS `sys_department_menus`;
CREATE TABLE `sys_department_menus`  (
  `department_id` bigint NOT NULL DEFAULT 0 COMMENT '部门ID',
  `menu_id` bigint NOT NULL DEFAULT 0 COMMENT '菜单ID',
  `ability` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '权限：序列化[\"READ\",\"WRITE\",\"UPDATE\",\"DELETE\",\"IMPORT\",\"EXPRORT\"]',
  INDEX `sys_role_menus_role_id_index`(`department_id` ASC) USING BTREE,
  INDEX `sys_role_menus_menu_id_index`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—部门菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_departments
-- ----------------------------
DROP TABLE IF EXISTS `sys_departments`;
CREATE TABLE `sys_departments`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NULL DEFAULT 0 COMMENT '部门类型:0=不限,1=国内,2=国际',
  `department_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '部门名称',
  `parent_id` int NOT NULL DEFAULT 0 COMMENT '父级部门ID(不继承角色权限)',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `role_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '部门拥有的角色权限ID【逗号分隔】,部门公共角色权限',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `all_parent_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所有上级id',
  `agreement` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对应协议，公司主体',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sys_departments_department_name_index`(`department_name` ASC) USING BTREE,
  INDEX `sys_departments_parent_id_index`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_file
-- ----------------------------
DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件路径',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 286 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文件上传表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_menu_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_api`;
CREATE TABLE `sys_menu_api`  (
  `menu_id` int NULL DEFAULT NULL,
  `api_id` int NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单与API的中间表\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_menu_apis
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_apis`;
CREATE TABLE `sys_menu_apis`  (
  `menu_id` bigint NOT NULL DEFAULT 0 COMMENT '菜单ID',
  `api_id` bigint NOT NULL DEFAULT 0 COMMENT '请求接口ID',
  `ability_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'read,create,update',
  `ability_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '查询，添加，更新',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '接口路由',
  INDEX `sys_role_apis_role_id_index`(`menu_id` ASC) USING BTREE,
  INDEX `sys_role_apis_api_id_index`(`api_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—角色请求接口关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_menus
-- ----------------------------
DROP TABLE IF EXISTS `sys_menus`;
CREATE TABLE `sys_menus`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '路由name',
  `menu_level` int NOT NULL DEFAULT 0 COMMENT '菜单等级，0表示顶级菜单',
  `parent_id` bigint NOT NULL DEFAULT 0 COMMENT '父菜单ID',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '路由path',
  `hidden` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否显示在菜单中显示路由（默认值：false）',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对应前端文件路径',
  `sort` int NOT NULL DEFAULT 99 COMMENT '排序标记',
  `keep_alive` tinyint(1) NOT NULL DEFAULT 1 COMMENT '附加属性:当前路由是否缓存（默认值：true）',
  `default_menu` tinyint(1) NOT NULL DEFAULT 0 COMMENT '附加属性:',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '附加属性:标题',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '附加属性:菜单描述',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '附加属性:icon',
  `close_tab` tinyint(1) NOT NULL DEFAULT 0 COMMENT '附加属性:是否隐藏关闭按钮',
  `hidden_tab` tinyint(1) NOT NULL DEFAULT 0 COMMENT '附加属性:是否不显示多标签页',
  `role_mode` tinyint NOT NULL DEFAULT 1 COMMENT '附加属性: 1[oneOf] 数组内拥有任一角色，返回True(等价第1种数据);2[allOf] 数组内所有角色都拥有，返回True; 3[except] 不拥有数组内任一角色，返回True(取反)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间 null未删除',
  `redirect` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跳转路径',
  `disable` tinyint(1) NULL DEFAULT 0 COMMENT '是否禁用，0：否，1：是',
  `all_parent_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所有父级id',
  `always_show` tinyint(1) NULL DEFAULT 1 COMMENT '当只有一级子路由时是否显示父路由是否显示在菜单中显示路由（默认值：1），必填项',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sys_menus_parent_id_index`(`parent_id` ASC) USING BTREE,
  INDEX `sys_menus_path_index`(`path` ASC) USING BTREE,
  INDEX `sys_menus_name_index`(`name` ASC) USING BTREE,
  INDEX `sys_menus_title_index`(`title` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 416 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_message`;
CREATE TABLE `sys_message`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '消息内容',
  `channel` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '渠道：booking后台:booking，销售渠道:sale',
  `to` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '发送的用户uid',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `channel_index`(`channel` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 99639 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '后台消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_message_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_message_item`;
CREATE TABLE `sys_message_item`  (
  `uid` int NULL DEFAULT NULL COMMENT '用户id',
  `mid` int NULL DEFAULT NULL COMMENT '消息id',
  `read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否阅读，0.否，1.是',
  `read_time` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除',
  INDEX `uid_index`(`uid` ASC) USING BTREE,
  INDEX `mid_index`(`mid` ASC) USING BTREE,
  INDEX `read_index`(`read` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '消息明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_operation_records
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_records`;
CREATE TABLE `sys_operation_records`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求ip',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求方法',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求路径',
  `status` int NOT NULL DEFAULT 0 COMMENT '请求状态',
  `latency` int NOT NULL DEFAULT 0 COMMENT '延迟',
  `agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '代理',
  `error_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误信息',
  `request_body` json NULL COMMENT '请求Body',
  `response_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '响应Body',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户ID',
  `level` tinyint(1) NULL DEFAULT NULL COMMENT '1:增删改查，2：增删改，3：删改',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间 null未删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sys_operation_records_ip_index`(`ip` ASC) USING BTREE,
  INDEX `sys_operation_records_path_index`(`path` ASC) USING BTREE,
  INDEX `sys_operation_records_status_index`(`status` ASC) USING BTREE,
  INDEX `sys_operation_records_user_id_index`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 81405 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—运行记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_purchase_platform
-- ----------------------------
DROP TABLE IF EXISTS `sys_purchase_platform`;
CREATE TABLE `sys_purchase_platform`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道名',
  `office_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'office号',
  `pu_channel_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '采购渠道编码',
  `subject_id` int NOT NULL DEFAULT 0 COMMENT '资金科目名称',
  `pay_method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付方式',
  `channel_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '采购渠道代码',
  `origin_office` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原始office',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  `platform_option` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '平台设置',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 170 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '采购渠道' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_purchase_product
-- ----------------------------
DROP TABLE IF EXISTS `sys_purchase_product`;
CREATE TABLE `sys_purchase_product`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `price_type` tinyint(1) NULL DEFAULT 1 COMMENT '运价类型1:国内，2:国际',
  `channel` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '采购渠道代码',
  `allow` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '允许产品',
  `not_allowed` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '不允许产品',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role_menus
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menus`;
CREATE TABLE `sys_role_menus`  (
  `role_id` bigint NOT NULL DEFAULT 0 COMMENT '角色ID',
  `menu_id` bigint NOT NULL DEFAULT 0 COMMENT '菜单ID',
  `ability` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '权限：序列化[\"READ\",\"WRITE\",\"UPDATE\",\"DELETE\",\"IMPORT\",\"EXPRORT\"]',
  INDEX `sys_role_menus_role_id_index`(`role_id` ASC) USING BTREE,
  INDEX `sys_role_menus_menu_id_index`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—角色菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_roles
-- ----------------------------
DROP TABLE IF EXISTS `sys_roles`;
CREATE TABLE `sys_roles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '角色名',
  `parent_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '父角色ID（父级包含子级角色权限）',
  `default_router` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'dashboard' COMMENT '默认菜单',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `all_parent_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所有上级id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sys_roles_role_name_index`(`role_name` ASC) USING BTREE,
  INDEX `sys_roles_parent_id_index`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_departments
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_departments`;
CREATE TABLE `sys_user_departments`  (
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户ID',
  `department_id` bigint NOT NULL DEFAULT 0 COMMENT '部门ID',
  INDEX `sys_user_departments_user_id_index`(`user_id` ASC) USING BTREE,
  INDEX `sys_user_departments_department_id_index`(`department_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—用户部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_roles
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_roles`;
CREATE TABLE `sys_user_roles`  (
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户ID',
  `role_id` bigint NOT NULL DEFAULT 0 COMMENT '角色ID',
  INDEX `sys_user_roles_user_id_index`(`user_id` ASC) USING BTREE,
  INDEX `sys_user_roles_role_id_index`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_users
-- ----------------------------
DROP TABLE IF EXISTS `sys_users`;
CREATE TABLE `sys_users`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户UUID',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `email_verified_at` timestamp NULL DEFAULT NULL COMMENT '邮箱验证时间',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户登录名',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '昵称',
  `realname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '实名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '头像',
  `last_login_at` timestamp NULL DEFAULT NULL COMMENT '最后登录日期',
  `last_token` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最新登录token',
  `last_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态: 1=启用 0=禁用',
  `department_id` int NULL DEFAULT NULL COMMENT '部门ID',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间 null未删除',
  `position` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '岗位',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_users_uuid_unique`(`uuid` ASC) USING BTREE,
  UNIQUE INDEX `sys_users_phone_unique`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `sys_users_email_unique`(`email` ASC) USING BTREE,
  INDEX `sys_users_uuid_index`(`uuid` ASC) USING BTREE,
  INDEX `sys_users_email_index`(`email` ASC) USING BTREE,
  INDEX `sys_users_username_index`(`username` ASC) USING BTREE,
  INDEX `sys_users_nickname_index`(`nickname` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统—用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for task
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) NULL DEFAULT 2 COMMENT '订单类型,1=国内,2国际',
  `sale_order_no` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名',
  `index` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一索引id',
  `dependency_task_id` int NOT NULL DEFAULT 0 COMMENT '依赖任务ID',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型1：rpc,2:curl,3:shell,4:类方法',
  `command` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'url或shell命令',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `validity_time` datetime NULL DEFAULT NULL COMMENT '有效时间，这个时间停止',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态0：停止，1启用',
  `last_time` datetime NULL DEFAULT NULL COMMENT '上次执行时间',
  `runing` tinyint(1) NOT NULL DEFAULT 0 COMMENT '执行状态：0空闲，1执行中',
  `timeout` int NOT NULL DEFAULT 0 COMMENT '超时重试(分钟)',
  `retry_times` tinyint NOT NULL DEFAULT 0 COMMENT '重试次数0：从不',
  `spec` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规则 * * * * *',
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标签',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `business_id` int UNSIGNED NULL DEFAULT 0 COMMENT '业务ID',
  `business_type` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '业务类型：1 降舱出票扫描，2 出票后降舱扫描，3 余位扫描',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `deleted_at` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `business_index`(`business_id` ASC) USING BTREE,
  INDEX `business_type_idnex`(`business_type` ASC) USING BTREE,
  INDEX `index`(`index` ASC) USING BTREE,
  INDEX `order_type_index`(`order_type` ASC) USING BTREE,
  INDEX `sale_order_no_index`(`sale_order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for task_log
-- ----------------------------
DROP TABLE IF EXISTS `task_log`;
CREATE TABLE `task_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` int NOT NULL DEFAULT 0,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务名',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则 * * * * *',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '类型1：rpc,2:curl,3:shell',
  `command` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'url或shell命令',
  `timeout` mediumint NOT NULL DEFAULT 0 COMMENT '超时重试(分钟)',
  `retry_times` tinyint NOT NULL DEFAULT 0 COMMENT '重试时间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间\r\n',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态0：失败，1成功',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_task_log_task_id`(`task_id` ASC) USING BTREE,
  INDEX `IDX_task_log_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25419 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务日志表\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for test111
-- ----------------------------
DROP TABLE IF EXISTS `test111`;
CREATE TABLE `test111`  (
  `sale_order_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售单号',
  `business_no` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务单号',
  `order_type` tinyint(1) NULL DEFAULT NULL COMMENT '1.销售单，2.改签单',
  `passenger_name` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出行人姓名',
  `card_no` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '证件号码',
  `d_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出发机场',
  `a_port` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目的机场'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ticket_refund_order
-- ----------------------------
DROP TABLE IF EXISTS `ticket_refund_order`;
CREATE TABLE `ticket_refund_order`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `ota_refund_no` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'ota平台退票单号',
  `currency` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '币种',
  `refund_server_fee` decimal(11, 2) NULL DEFAULT NULL COMMENT '退票服务费',
  `conversion_rate` decimal(15, 9) NOT NULL DEFAULT 0.000000000 COMMENT '汇率',
  `is_confirm` tinyint(1) NOT NULL DEFAULT 0 COMMENT '/退票费状态 0,待确认退票 1已确认退票 2待结算',
  `rt_oper` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作者',
  `rt_time` timestamp NULL DEFAULT NULL COMMENT '操作时间',
  `tickets` tinyint(1) NOT NULL DEFAULT 1 COMMENT '票数',
  `refund_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退款描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for urge_order_ticket_conf
-- ----------------------------
DROP TABLE IF EXISTS `urge_order_ticket_conf`;
CREATE TABLE `urge_order_ticket_conf`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `airline_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '航司二字码',
  `national` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '国内/国际：I国际，N国内',
  `start_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '开始时间,时分10:30',
  `end_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '结束时间,时分10:30',
  `is_notice` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否发送通知：0否，1是',
  `out_of_time_is_notice` tinyint(1) NOT NULL DEFAULT 1 COMMENT '时间外是否通知：0否，1是',
  `purchase_channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出票渠道：BSP，VJ...',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用：0否，1是',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '催单出票配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for yibao_vcc_card
-- ----------------------------
DROP TABLE IF EXISTS `yibao_vcc_card`;
CREATE TABLE `yibao_vcc_card`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel` tinyint(1) NOT NULL DEFAULT 1 COMMENT '开卡渠道：1.易宝，2.空中云汇',
  `open_card_request_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '开卡请求号',
  `cancel_card_request_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '销卡请求号',
  `sale_order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '自建平台销售单号',
  `card_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '卡号',
  `expired_time` datetime NULL DEFAULT NULL COMMENT '卡过期时间',
  `quota_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '开卡金额',
  `card_organization` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CNYVCC' COMMENT '卡组织: MASTER_CARD:万事达,  VISA : 维萨, CNYVCC：人民币',
  `card_use_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SINGLE' COMMENT '卡使用类型: SINGLE单次, MULTIPLE:多次',
  `max_use` int NOT NULL DEFAULT 0 COMMENT '最大交易次数',
  `quota_add_rate` float NOT NULL DEFAULT 0 COMMENT '加成比例: 人民币卡加成比例应为 0',
  `card_ableuse_time` int NOT NULL DEFAULT 60 COMMENT '卡有效时间: 单位分钟',
  `request_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '刷卡金额',
  `open_card_time` datetime NULL DEFAULT NULL COMMENT '开卡时间',
  `status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '申卡状态: ACTIVE:激活，CANCEL:取消，SYSTEM_CANCEL:卡不可用，UNACTIVE:未激活',
  `usd_cny_rate` float NOT NULL DEFAULT 1 COMMENT '本币汇率：美元兑人民币汇率  人民币卡为 1',
  `account_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '开卡人民币金额: ',
  `service_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '开卡预收服务费：人民币卡在开卡时预收服务费金额，其他卡不适用',
  `open_card_trx_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '开卡交易金额：人民币卡在开卡金额基础上加 了服务费的交易金额，其他卡不适用',
  `cancel_card_time` datetime NULL DEFAULT NULL COMMENT '取消卡的的时间',
  `open_card_uid` int NULL DEFAULT NULL COMMENT '开卡操作人',
  `cancel_card_uid` int NULL DEFAULT NULL COMMENT '取消卡操作人',
  `cancel_status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '取消状态：INIT: 初始化 PROCESS: 处理中 ACCEPT_SUCCESS: 受理成功 SUCCESS: 成功 FAIL: 失败',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `currency_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申卡币种',
  `validity_date` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '有效期',
  `cvv` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'cvv编码',
  `balance` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '卡内余额',
  `pnr` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出票PNR编码',
  `ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号,多个逗号分割',
  `is_refund` tinyint(1) NULL DEFAULT 0 COMMENT '是否退票，0.否，1.是',
  `transaction_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '交易号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15805 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '易宝VCC卡' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for yibao_vcc_purchase
-- ----------------------------
DROP TABLE IF EXISTS `yibao_vcc_purchase`;
CREATE TABLE `yibao_vcc_purchase`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `channel` tinyint NOT NULL COMMENT 'vcc卡标识',
  `purchase_platform_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '采购渠道代码',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'vcc开卡采购渠道配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for z_ticket_check
-- ----------------------------
DROP TABLE IF EXISTS `z_ticket_check`;
CREATE TABLE `z_ticket_check`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `ORDER_NO` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `FIRST_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `LAST_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `FROM` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `LAYOVER` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `TO` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `FLIGHT_NO` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `PNR` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `RESPONSE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
