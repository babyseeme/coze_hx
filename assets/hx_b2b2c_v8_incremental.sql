-- ===========================================================================
-- 华夏航旅 B2B2C v8 增量迁移 SQL
-- 基于z-trip项目架构分析, 新增酒店基础/火车基础/保险/用车/任务/财务结算体系
-- 配合现有v8数据库(84张表)执行, 使用 CREATE TABLE IF NOT EXISTS
-- ===========================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===========================================================================
-- 第一部分: 酒店基础数据体系 (3张表)
-- z-trip借鉴: hotel_order中的城市/房型/早餐等维度需基础数据支撑
-- ===========================================================================

-- 1. 酒店品牌
CREATE TABLE IF NOT EXISTS `hotel_brand` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLate = utf8mb4_unicode_ci COMMENT = '酒店品牌' ROW_FORMAT = Dynamic;

-- 2. 酒店信息
CREATE TABLE IF NOT EXISTS `hotel_info` (
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
  `facilities` json NULL COMMENT '设施标签(如: ["WiFi","停车场","健身房","游泳池"])',
  `images` json NULL COMMENT '酒店图片列表(如: [{"url":"...","type":"exterior","sort":1}])',
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '酒店信息' ROW_FORMAT = Dynamic;

-- 3. 酒店房型
CREATE TABLE IF NOT EXISTS `hotel_room_type` (
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
  `facilities` json NULL COMMENT '房型设施标签(如: ["浴缸","迷你吧","保险箱"])',
  `images` json NULL COMMENT '房型图片',
  `supplier_room_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商侧房型ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hotel`(`hotel_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_supplier`(`supplier_room_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '酒店房型' ROW_FORMAT = Dynamic;


-- ===========================================================================
-- 第二部分: 火车基础数据体系 (3张表)
-- z-trip借鉴: train_order中的列车类型/站点/座席体系需基础数据支撑
-- ===========================================================================

-- 4. 火车站点
CREATE TABLE IF NOT EXISTS `train_station` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '火车站点' ROW_FORMAT = Dynamic;

-- 5. 列车类型
CREATE TABLE IF NOT EXISTS `train_type` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '列车类型' ROW_FORMAT = Dynamic;

-- 6. 座席类型
CREATE TABLE IF NOT EXISTS `train_seat_type` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '火车座席类型' ROW_FORMAT = Dynamic;


-- ===========================================================================
-- 第三部分: 保险体系 (2张表)
-- z-trip借鉴: insurance_order中的保险产品需独立管理
-- ===========================================================================

-- 7. 保险产品
CREATE TABLE IF NOT EXISTS `insurance_product` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险产品' ROW_FORMAT = Dynamic;

-- 8. 保险订单子表
CREATE TABLE IF NOT EXISTS `order_item_insurance` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '保险子订单(按被保人+产品=最小操作单元)' ROW_FORMAT = Dynamic;


-- ===========================================================================
-- 第四部分: 用车体系 (1张表)
-- z-trip借鉴: z-trip有用车任务但无独立用车产品,当前先建子订单骨架
-- ===========================================================================

-- 9. 用车订单子表
CREATE TABLE IF NOT EXISTS `order_item_car` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用车子订单(单次行程=最小操作单元)' ROW_FORMAT = Dynamic;


-- ===========================================================================
-- 第五部分: TMC任务体系 (3张表)
-- z-trip借鉴: 核心TMC服务台, 12种任务类型 + 13种状态 + 工单流转
-- ===========================================================================

-- 10. 服务任务主表
CREATE TABLE IF NOT EXISTS `service_task` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '服务任务(TMC工单)' ROW_FORMAT = Dynamic;

-- 11. 任务操作日志
CREATE TABLE IF NOT EXISTS `service_task_log` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务操作日志' ROW_FORMAT = Dynamic;

-- 12. 任务分配规则
CREATE TABLE IF NOT EXISTS `service_task_assign_rule` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `task_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务类型',
  `rule_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'round_robin' COMMENT '分配策略: round_robin=轮询/least_load=最少任务/skill=技能匹配/manual=手工分配',
  `target_user_ids` json NULL COMMENT '目标用户ID列表(轮询/技能匹配时用)',
  `skill_tags` json NULL COMMENT '技能标签(skill策略时用, 如: ["国际机票","退改签"])',
  `priority` smallint NULL DEFAULT 0 COMMENT '规则优先级(数值越大越优先)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_type`(`tenant_id` ASC, `task_type` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务分配规则' ROW_FORMAT = Dynamic;


-- ===========================================================================
-- 第六部分: 财务结算体系 (9张表)
-- z-trip借鉴: 企业结算(账户/账单/来款) + 供应商结算(账户/账单/付款) + 退款 + 发票
-- ===========================================================================

-- 13. 企业结算账户
CREATE TABLE IF NOT EXISTS `finance_company_account` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业结算账户' ROW_FORMAT = Dynamic;

-- 14. 企业账户流水
CREATE TABLE IF NOT EXISTS `finance_company_account_log` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业账户流水' ROW_FORMAT = Dynamic;

-- 15. 企业账单
CREATE TABLE IF NOT EXISTS `finance_company_bill` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业账单(销售侧)' ROW_FORMAT = Dynamic;

-- 16. 企业账单明细
CREATE TABLE IF NOT EXISTS `finance_company_bill_item` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业账单明细' ROW_FORMAT = Dynamic;

-- 17. 企业来款
CREATE TABLE IF NOT EXISTS `finance_company_payment` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业来款(客户付款记录)' ROW_FORMAT = Dynamic;

-- 18. 供应商账户
CREATE TABLE IF NOT EXISTS `finance_supplier_account` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '供应商账户(采购侧)' ROW_FORMAT = Dynamic;

-- 19. 供应商账单
CREATE TABLE IF NOT EXISTS `finance_supplier_bill` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '供应商账单(采购侧)' ROW_FORMAT = Dynamic;

-- 20. 供应商付款
CREATE TABLE IF NOT EXISTS `finance_supplier_payment` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '供应商付款(采购侧)' ROW_FORMAT = Dynamic;

-- 21. 退款单
CREATE TABLE IF NOT EXISTS `finance_refund` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款单(全业务线通用)' ROW_FORMAT = Dynamic;

-- 22. 发票
CREATE TABLE IF NOT EXISTS `finance_invoice` (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '发票' ROW_FORMAT = Dynamic;


-- ===========================================================================
-- 第七部分: 现有表字段增强
-- ===========================================================================

-- 增强 order_item_hotel: 补充z-trip酒店订单中的关键字段
ALTER TABLE `order_item_hotel`
  ADD COLUMN `special_request` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '特殊要求(如: 无烟房/高楼层/加床)' AFTER `guest_phone`,
  ADD COLUMN `guest_id_type` tinyint NULL DEFAULT NULL COMMENT '入住人证件类型(快照): 1=身份证,2=护照...' AFTER `guest_phone`,
  ADD COLUMN `guest_id_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '入住人证件号(快照脱敏)' AFTER `guest_id_type`,
  ADD COLUMN `supplier_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商类型: ota_ctrip/ota_meituan/ota_fligy/hotel_direct' AFTER `cancel_policy`,
  ADD COLUMN `supplier_hotel_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商侧酒店ID' AFTER `supplier_type`,
  ADD COLUMN `supplier_room_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商侧房型ID' AFTER `supplier_hotel_id`,
  ADD COLUMN `supplier_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商订单号(确认后回填)' AFTER `supplier_room_id`,
  ADD COLUMN `insurance_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '保险费' AFTER `service_fee`,
  ADD COLUMN `cost_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '采购成本单价' AFTER `insurance_fee`;

-- 增强 order_item_train: 补充z-trip火车票订单中的关键字段
ALTER TABLE `order_item_train`
  ADD COLUMN `train_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '列车类型(如: G/D/C/Z/T/K)' AFTER `train_no`,
  ADD COLUMN `is_student` tinyint NULL DEFAULT 2 COMMENT '1=学生票,2=成人票' AFTER `seat_no`,
  ADD COLUMN `supplier_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '供应商订单号(12306出票后回填)' AFTER `is_student`,
  ADD COLUMN `insurance_fee` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '保险费' AFTER `service_fee`,
  ADD COLUMN `cost_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '采购成本单价' AFTER `insurance_fee`,
  ADD COLUMN `cancel_rule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '退改规则摘要(快照)' AFTER `cost_price`;

-- 增强 order 主表: 补充保险/用车业务类型 + 任务关联
ALTER TABLE `order`
  ADD COLUMN `task_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '关联任务ID service_task.id(代客下单时关联)' AFTER `internal_remark`;

-- 增强 order_sales: 补充保险/用车业务类型范围
-- biz_type 已有 flight/train/hotel/mall, 需确认 insurance/car 是否已支持(当前为varchar(20),无需DDL修改,仅应用层扩展)

SET FOREIGN_KEY_CHECKS = 1;
