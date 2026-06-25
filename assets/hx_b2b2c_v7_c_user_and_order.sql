/*
 * ============================================================
 * 华夏航旅 B2B2C — C端用户体系 & 订单体系 表结构
 * ============================================================
 * 数据库 : hx_b2b2c (MySQL 8.0.35, utf8mb4_unicode_ci)
 * 版本   : v7.0
 * 日期   : 2025-07
 * 说明   : 本文件为新增表, 不修改已有 v6 表结构
 * ============================================================
 *
 * 新增表清单 (17 张):
 *
 * ── C端用户体系 (8 张) ──────────────────────────────
 *   c_user                     平台自然人(全局唯一)
 *   c_member                   商户会员(商户维度隔离)
 *   c_member_address           会员收货地址
 *   c_passenger                常用旅客(商户会员维度)
 *   corporate_group            大客户集团配置(平台级)
 *   corporate_policy           大客户自动申报政策
 *   c_member_corporate         大客户成员身份(平台级唯一校验)
 *   c_member_corporate_apply   大客户成员申报记录(全量审计)
 *
 * ── 订单体系 (9 张) ──────────────────────────────
 *   `order`                    主订单(大订单,C端一次下单行为)
 *   order_sales                销售业务订单(按业务类型拆分,绑销售员)
 *   order_procurement          采购业务订单(按渠道拆分,绑采购员)
 *   order_item_flight          机票子订单(人×程=最小操作单元,含机票字段)
 *   order_item_train           火车票子订单(含火车票字段)
 *   order_item_hotel           酒店子订单(含酒店字段)
 *   order_item_mall            商城子订单(含商城字段)
 *   order_procure_item         采购子订单(关联销售item,按渠道出票)
 *   order_change               订单变更记录(退/改/签)
 *
 * ============================================================
 * 核心设计约定:
 *   1. C端用户三层隔离: c_user(平台自然人) → c_member(商户会员) → c_passenger(常用旅客)
 *   2. 大客户身份平台级唯一: 同一自然人在同一航司只能有一个有效大客户身份
 *   3. 订单三层结构: order(主订单) → order_sales/order_procurement(业务订单) → order_item_*(子订单)
 *   4. 销售与采购分轨: 销售单面向客户,采购单面向供应商,通过 order_procure_item 关联
 *   5. 子订单按业务类型分表: 各业务字段内聚,避免大量 NULL 列
 *   6. 全库零外键: 表关联由应用层 ORM 维护,便于分库分表
 *   7. 敏感字段三件套: phone/email 使用 明文(脱敏) + 密文(AES) + 哈希(HMAC)
 * ============================================================
 */

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- ================================================================
-- 第一部分: C端用户体系
-- ================================================================


-- ----------------------------------------------------------------
-- 1. c_user — 平台自然人
--    全平台唯一,手机号必填,跨商户关联同一自然人的锚点
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `c_user`;
CREATE TABLE `c_user` (
  `id`                  bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自然人ID',
  `phone`               varchar(20)  NOT NULL COMMENT '手机号(脱敏: 138****8888)',
  `phone_encrypted`     varbinary(255) NOT NULL COMMENT '手机号密文(AES-256-GCM)',
  `phone_hash`          char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '手机号HMAC-SHA256(精确查找+唯一)',
  `real_name`           varchar(30)  DEFAULT NULL COMMENT '真实姓名(脱敏: 张*明)',
  `real_name_encrypted` varbinary(255) DEFAULT NULL COMMENT '真实姓名密文',
  `real_name_hash`      char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL COMMENT '真实姓名HMAC',
  `id_type`             tinyint      DEFAULT NULL COMMENT '证件类型: 1=身份证,2=护照,3=港澳通行证,4=台胞证,5=其他',
  `id_number`           varchar(30)  DEFAULT NULL COMMENT '证件号(脱敏: 310***********1234)',
  `id_number_encrypted` varbinary(255) DEFAULT NULL COMMENT '证件号密文',
  `id_number_hash`      char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL COMMENT '证件号HMAC(跨商户唯一校验)',
  `union_id`            varchar(100) DEFAULT '' COMMENT '微信UnionID(跨小程序关联同一自然人)',
  `avatar`              varchar(500) DEFAULT '' COMMENT '默认头像',
  `gender`              tinyint      DEFAULT 0 COMMENT '0=未知,1=男,2=女',
  `birthday`            date         DEFAULT NULL COMMENT '出生日期',
  `status`              tinyint      DEFAULT 1 COMMENT '1=正常,2=冻结,3=注销',
  `last_login_at`       datetime     DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip`       varchar(45)  DEFAULT '' COMMENT '最后登录IP',
  `created_at`          datetime     DEFAULT NULL,
  `updated_at`          datetime     DEFAULT NULL,
  `deleted_at`          timestamp    DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_phone_hash` (`phone_hash`),
  UNIQUE KEY `uk_id_type_hash` (`id_type`, `id_number_hash`),
  KEY `idx_union_id` (`union_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='C端自然人(平台级,全局唯一)';


-- ----------------------------------------------------------------
-- 2. c_member — 商户会员
--    一个 c_user 可在多个商户注册,积分/钱包/等级商户维度隔离
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `c_member`;
CREATE TABLE `c_member` (
  `id`                  bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id`           bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `user_id`             bigint UNSIGNED NOT NULL COMMENT 'c_user.id',
  `member_no`           varchar(20)  NOT NULL COMMENT '会员号(商户内唯一)',
  `nickname`            varchar(50)  DEFAULT '' COMMENT '会员昵称',
  `avatar`              varchar(500) DEFAULT '' COMMENT '会员头像(可不同于c_user默认)',
  `level`               smallint     DEFAULT 1 COMMENT '会员等级: 1=普通,2=银卡,3=金卡,4=钻石',
  `points_balance`      int          DEFAULT 0 COMMENT '积分余额',
  `wallet_balance`      decimal(12,2) DEFAULT 0.00 COMMENT '钱包余额',
  `total_spent`         decimal(12,2) DEFAULT 0.00 COMMENT '累计消费金额(升级依据)',
  `order_count`         int          DEFAULT 0 COMMENT '累计订单数',
  `sign_count`          int          DEFAULT 0 COMMENT '连续签到天数',
  `last_sign_date`      date         DEFAULT NULL COMMENT '最后签到日期',
  `source`              varchar(20)  DEFAULT 'mini' COMMENT '注册来源: mini/web/h5/app/ota',
  `status`              tinyint      DEFAULT 1 COMMENT '1=正常,2=冻结,3=注销',
  `remark`              varchar(255) DEFAULT '',
  `created_at`          datetime     DEFAULT NULL,
  `updated_at`          datetime     DEFAULT NULL,
  `deleted_at`          timestamp    DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_member_no` (`tenant_id`, `member_no`),
  KEY `idx_tenant_user` (`tenant_id`, `user_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_tenant_level` (`tenant_id`, `level`),
  KEY `idx_tenant_status` (`tenant_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='C端会员(商户维度隔离)';


-- ----------------------------------------------------------------
-- 3. c_member_address — 会员收货地址
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `c_member_address`;
CREATE TABLE `c_member_address` (
  `id`             bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id`      bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id`      bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `receiver_name`  varchar(30)  NOT NULL COMMENT '收件人姓名',
  `receiver_phone` varchar(20)  NOT NULL COMMENT '收件人手机',
  `province`       varchar(20)  NOT NULL COMMENT '省',
  `city`           varchar(20)  NOT NULL COMMENT '市',
  `district`       varchar(20)  NOT NULL COMMENT '区/县',
  `address`        varchar(200) NOT NULL COMMENT '详细地址',
  `is_default`     tinyint      DEFAULT 2 COMMENT '1=默认,2=非默认',
  `created_at`     datetime     DEFAULT NULL,
  `updated_at`     datetime     DEFAULT NULL,
  `deleted_at`     timestamp    DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tenant_member` (`tenant_id`, `member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员收货地址';


-- ----------------------------------------------------------------
-- 4. c_passenger — 常用旅客
--    挂在会员下,商户维度隔离;同一旅客信息可多次保存(不同商户)
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `c_passenger`;
CREATE TABLE `c_passenger` (
  `id`                  bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id`           bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id`           bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `name`                varchar(30)  DEFAULT NULL COMMENT '姓名(脱敏)',
  `name_encrypted`      varbinary(255) DEFAULT NULL COMMENT '姓名密文',
  `name_hash`           char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL COMMENT '姓名HMAC',
  `id_type`             tinyint      NOT NULL COMMENT '证件类型: 1=身份证,2=护照,3=港澳通行证,4=台胞证,5=其他',
  `id_number`           varchar(30)  DEFAULT NULL COMMENT '证件号(脱敏)',
  `id_number_encrypted` varbinary(255) DEFAULT NULL COMMENT '证件号密文',
  `id_number_hash`      char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL COMMENT '证件号HMAC',
  `phone`               varchar(20)  DEFAULT NULL COMMENT '手机号(脱敏)',
  `phone_encrypted`     varbinary(255) DEFAULT NULL COMMENT '手机号密文',
  `phone_hash`          char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL COMMENT '手机号HMAC',
  `nationality`         varchar(20)  DEFAULT 'CN' COMMENT '国籍/地区码',
  `birthday`            date         DEFAULT NULL COMMENT '出生日期',
  `gender`              tinyint      DEFAULT 0 COMMENT '0=未知,1=男,2=女',
  `is_self`             tinyint      DEFAULT 2 COMMENT '1=本人,2=他人',
  `is_default`          tinyint      DEFAULT 2 COMMENT '1=默认,2=非默认',
  `flight_count`        int          DEFAULT 0 COMMENT '乘机次数(排序依据)',
  `train_count`         int          DEFAULT 0 COMMENT '乘车次数',
  `created_at`          datetime     DEFAULT NULL,
  `updated_at`          datetime     DEFAULT NULL,
  `deleted_at`          timestamp    DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_member_id_hash` (`tenant_id`, `member_id`, `id_type`, `id_number_hash`),
  KEY `idx_tenant_member` (`tenant_id`, `member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='常用旅客(商户会员维度)';


-- ----------------------------------------------------------------
-- 5. corporate_group — 大客户集团配置
--    航司与集团签约的大客户关系,平台级,无 tenant_id
--    一个集团只与一个航司签约(一对一);跨航司需建多条记录
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `corporate_group`;
CREATE TABLE `corporate_group` (
  `id`              bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_name`      varchar(100) NOT NULL COMMENT '大客户集团名称(如: 华为技术有限公司)',
  `group_code`      varchar(50)  NOT NULL COMMENT '集团编码(唯一标识,如: HUAWEI-CA)',
  `airline_code`    varchar(10)  NOT NULL COMMENT '签约航司二字码(如: CA)',
  `contract_no`     varchar(50)  DEFAULT '' COMMENT '大客户协议编号',
  `corp_type`       varchar(20)  DEFAULT 'enterprise' COMMENT 'enterprise=企业大客户/gp=公务员',
  `submit_methods`  varchar(50)  NOT NULL COMMENT '支持的申报方式: api/file/api+file',
  `api_config`      json         DEFAULT NULL COMMENT 'API申报配置(接口地址/认证方式/报文格式)',
  `file_template_id` bigint UNSIGNED DEFAULT 0 COMMENT '文件申报模板ID(attachment.id)',
  `submit_cycle`    varchar(20)  DEFAULT 'realtime' COMMENT '申报周期: realtime/daily/weekly/monthly',
  `review_days`     smallint     DEFAULT 0 COMMENT '预估审核天数(0=实时)',
  `corp_code_rule`  varchar(100) DEFAULT '' COMMENT '大客户员工编号生成规则(如: {airline}-{group}-{seq})',
  `discount_info`   varchar(200) DEFAULT '' COMMENT '优惠信息摘要(如: 经济舱95折/公务舱9折)',
  `status`          tinyint      DEFAULT 1 COMMENT '1=有效,2=暂停,3=已过期',
  `expire_at`       datetime     DEFAULT NULL COMMENT '协议到期时间',
  `created_by`      bigint       DEFAULT 0,
  `updated_by`      bigint       DEFAULT 0,
  `created_at`      datetime     DEFAULT NULL,
  `updated_at`      datetime     DEFAULT NULL,
  `deleted_at`      timestamp    DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_code` (`group_code`),
  KEY `idx_airline_status` (`airline_code`, `status`),
  KEY `idx_corp_type` (`corp_type`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户集团配置(平台级,航司×集团一对一)';


-- ----------------------------------------------------------------
-- 6. corporate_policy — 大客户自动申报政策
--    平台方配置: 满足什么条件的散客自动申报为某大客户集团成员
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `corporate_policy`;
CREATE TABLE `corporate_policy` (
  `id`              bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `policy_name`     varchar(100) NOT NULL COMMENT '政策名称(如: CA航司华北散客自动申报)',
  `policy_code`     varchar(50)  NOT NULL COMMENT '政策编码(唯一)',
  `airline_code`    varchar(10)  NOT NULL COMMENT '适用航司',
  `corporate_id`    bigint UNSIGNED NOT NULL COMMENT '自动申报到此大客户集团 corporate_group.id',
  `conditions`      json         NOT NULL COMMENT '申报条件(航线/舱位/消费金额/航班次数等)',
  `priority`        smallint     DEFAULT 0 COMMENT '优先级(数值越大越高,同航司多政策时取最高)',
  `auto_submit`     tinyint      DEFAULT 1 COMMENT '1=匹配后自动提交申报,2=仅提示需人工确认',
  `status`          tinyint      DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_by`      bigint       DEFAULT 0,
  `updated_by`      bigint       DEFAULT 0,
  `created_at`      datetime     DEFAULT NULL,
  `updated_at`      datetime     DEFAULT NULL,
  `deleted_at`      timestamp    DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_policy_code` (`policy_code`),
  KEY `idx_airline_status` (`airline_code`, `status`),
  KEY `idx_corporate` (`corporate_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户自动申报政策';

-- conditions JSON 示例:
-- {
--   "routes": ["PEK-SHA", "PEK-CAN"],         // 适用航线(空=不限)
--   "cabin_classes": ["Y"],                    // 适用舱位(空=不限)
--   "min_flights": 3,                          // 最少乘机次数
--   "min_amount": 5000.00,                     // 最少消费金额
--   "time_window_months": 6,                   // 统计时间窗口(月)
--   "exclude_existing_corporate": true          // 排除已有大客户身份的用户
-- }


-- ----------------------------------------------------------------
-- 7. c_member_corporate — 大客户成员身份
--    平台级,同一自然人在同一航司只能有一个有效身份(status=1)
--    使用 STORED 生成列 + UNIQUE 实现部分唯一约束(MySQL 8.0)
--    全量历史(含退出/过期/冻结)保留在本表,申报细节在 apply 表
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `c_member_corporate`;
CREATE TABLE `c_member_corporate` (
  `id`              bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`         bigint UNSIGNED NOT NULL COMMENT 'c_user.id(平台级自然人)',
  `tenant_id`       bigint UNSIGNED NOT NULL COMMENT '申报商户ID(哪个商户提交的申报)',
  `member_id`       bigint UNSIGNED NOT NULL COMMENT 'c_member.id(冗余,商户维度查询)',
  `airline_code`    varchar(10)  NOT NULL COMMENT '航司二字码',
  `corporate_id`    bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id',
  `corp_member_no`  varchar(50)  DEFAULT '' COMMENT '大客户成员编号(航司分配或按规则生成)',
  `corp_type`       varchar(20)  DEFAULT 'enterprise' COMMENT 'enterprise/gp',
  `status`          tinyint      NOT NULL DEFAULT 1 COMMENT '1=有效,2=已退出,3=已过期,4=处罚冻结',
  `source`          varchar(20)  DEFAULT 'auto' COMMENT 'auto=平台自动申报,manual=人工申报',
  `policy_id`       bigint UNSIGNED DEFAULT 0 COMMENT '触发自动申报的政策ID',
  `apply_id`        bigint UNSIGNED DEFAULT 0 COMMENT '最近一次生效的申报记录ID',
  `activated_at`    datetime     DEFAULT NULL COMMENT '身份生效时间',
  `expire_at`       datetime     DEFAULT NULL COMMENT '身份过期时间(协议到期/资格到期)',
  `exited_at`       datetime     DEFAULT NULL COMMENT '退出时间',
  `exit_reason`     varchar(200) DEFAULT '' COMMENT '退出原因',
  `penalty_note`    varchar(500) DEFAULT '' COMMENT '处罚备注(如: 同一航司重复申报被航司处罚)',
  -- 生成列: 仅 status=1 时有值,保证同一自然人在同一航司最多1条有效身份
  `uk_guard`        varchar(60)  GENERATED ALWAYS AS
                      (IF(`status` = 1, CONCAT(`user_id`, '-', `airline_code`), NULL)) STORED
                      COMMENT '部分唯一约束守卫列(仅status=1时参与唯一校验)',
  `created_at`      datetime     DEFAULT NULL,
  `updated_at`      datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_airline_active` (`uk_guard`),
  KEY `idx_tenant_member` (`tenant_id`, `member_id`),
  KEY `idx_corporate` (`corporate_id`, `status`),
  KEY `idx_user_airline` (`user_id`, `airline_code`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户成员身份(平台级,同航司唯一)';


-- ----------------------------------------------------------------
-- 8. c_member_corporate_apply — 大客户成员申报记录
--    全量审计,记录每一次申报(含自动/人工/API/文件)
--    使用 STORED 生成列防止同一人同一航司重复提交待审核申报
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `c_member_corporate_apply`;
CREATE TABLE `c_member_corporate_apply` (
  `id`                bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `apply_no`          varchar(40)  NOT NULL COMMENT '申报单号',
  `user_id`           bigint UNSIGNED NOT NULL COMMENT 'c_user.id',
  `tenant_id`         bigint UNSIGNED NOT NULL COMMENT '申报商户ID',
  `member_id`         bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `airline_code`      varchar(10)  NOT NULL COMMENT '航司二字码',
  `corporate_id`      bigint UNSIGNED NOT NULL COMMENT '目标大客户集团 corporate_group.id',
  `corp_member_no`    varchar(50)  DEFAULT '' COMMENT '生成的大客户成员编号',
  `submit_method`     varchar(20)  NOT NULL COMMENT 'api/file',
  `submit_status`     tinyint      NOT NULL DEFAULT 1 COMMENT '1=待提交,2=已提交,3=审核中,4=已通过,5=已拒绝,6=已撤回,7=提交失败',
  `submit_at`         datetime     DEFAULT NULL COMMENT '提交时间(向航司/供应商提交)',
  `batch_no`          varchar(40)  DEFAULT '' COMMENT '批量提交批次号(file方式用)',
  `file_id`           bigint UNSIGNED DEFAULT 0 COMMENT '上传文件ID(file方式,attachment.id)',
  `api_request`       json         DEFAULT NULL COMMENT 'API请求报文快照',
  `api_response`      json         DEFAULT NULL COMMENT 'API响应报文快照',
  `review_note`       varchar(500) DEFAULT '' COMMENT '审核备注/拒绝原因',
  `reviewed_at`       datetime     DEFAULT NULL COMMENT '审核时间',
  `corporate_id_result` bigint UNSIGNED DEFAULT 0 COMMENT '审核通过后写入 c_member_corporate.id',
  `apply_source`      varchar(20)  DEFAULT 'auto' COMMENT 'auto=平台自动/manual=人工',
  `policy_id`         bigint UNSIGNED DEFAULT 0 COMMENT '触发的自动申报政策ID',
  `conflict_check`    json         DEFAULT NULL COMMENT '申报前冲突检测结果快照',
  `fail_reason`       varchar(500) DEFAULT '' COMMENT '提交/审核失败原因',
  `retry_count`       tinyint      DEFAULT 0 COMMENT '重试次数',
  `next_retry_at`     datetime     DEFAULT NULL COMMENT '下次重试时间',
  `remark`            varchar(500) DEFAULT '',
  -- 生成列: 防止同一人同一航司存在重复的待审核申报(submit_status IN 1,2,3)
  `uk_guard`          varchar(60)  GENERATED ALWAYS AS
                        (IF(`submit_status` IN (1, 2, 3), CONCAT(`user_id`, '-', `airline_code`), NULL)) STORED
                        COMMENT '部分唯一约束守卫列(防止重复提交待审核申报)',
  `created_at`        datetime     DEFAULT NULL,
  `updated_at`        datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_apply_no` (`apply_no`),
  UNIQUE KEY `uk_user_airline_pending` (`uk_guard`),
  KEY `idx_user_airline` (`user_id`, `airline_code`, `submit_status`),
  KEY `idx_tenant_member` (`tenant_id`, `member_id`),
  KEY `idx_corporate` (`corporate_id`, `submit_status`),
  KEY `idx_batch` (`batch_no`),
  KEY `idx_status_retry` (`submit_status`, `next_retry_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户成员申报记录(全量审计)';

-- conflict_check JSON 示例:
-- {
--   "checked_at": "2025-07-01 10:30:00",
--   "active_corporate": null,                            // 当前有效身份(无则null)
--   "pending_apply": null,                               // 待审核申报(无则null)
--   "history_corporates": [                              // 历史身份
--     { "corporate_id": 5, "group_name": "华为", "status": 2, "exited_at": "2024-12-01" }
--   ],
--   "warning": "该用户曾有CA航司大客户身份(华为,已退出)",
--   "operator_confirmed": true,                          // 人工确认(有历史身份时)
--   "operator_id": 123,
--   "confirmed_at": "2025-07-01 10:31:00"
-- }


-- ================================================================
-- 第二部分: 订单体系
-- ================================================================


-- ----------------------------------------------------------------
-- 9. `order` — 主订单(大订单)
--    C端用户一次下单行为生成一个主订单
--    拆单场景: 子订单的 order_id 指向新主订单, parent_order_id 指向原主订单
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id`               bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no`         varchar(32)  NOT NULL COMMENT '订单号(如: HX20250701123456)',
  `tenant_id`        bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id`        bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `user_id`          bigint UNSIGNED NOT NULL COMMENT 'c_user.id(冗余,跨商户查询)',
  `business_types`   varchar(100) DEFAULT '' COMMENT '涉及业务类型(逗号分隔): flight,train,hotel,mall',
  `order_type`       varchar(20)  DEFAULT 'normal' COMMENT 'normal=普通/group=团购/corporate=大客户/gp=公务员',
  `parent_order_id`  bigint UNSIGNED DEFAULT 0 COMMENT '父订单ID(拆单溯源,0=原始订单)',
  `split_from_item_ids` json DEFAULT NULL COMMENT '拆单来源item IDs(从原订单拆出的item)',
  `split_version`    smallint     DEFAULT 1 COMMENT '拆单版本(1=原始,>1=被拆过)',
  `status`           tinyint      NOT NULL DEFAULT 1 COMMENT '1=待支付,2=已支付/处理中,3=部分完成,4=全部完成,5=已取消,6=部分退改,7=已关闭',
  `sales_count`      smallint     DEFAULT 0 COMMENT '销售业务订单数',
  `item_count`       smallint     DEFAULT 0 COMMENT '子订单总数',
  `passenger_count`  smallint     DEFAULT 0 COMMENT '旅客人数',
  `total_amount`     decimal(12,2) DEFAULT 0.00 COMMENT '订单总金额',
  `paid_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '累计退款金额',
  `change_diff`      decimal(12,2) DEFAULT 0.00 COMMENT '累计改签差价(正=补价,负=退差)',
  `service_fee`      decimal(12,2) DEFAULT 0.00 COMMENT '服务费合计',
  `insurance_fee`    decimal(12,2) DEFAULT 0.00 COMMENT '保险费合计',
  `currency`         varchar(3)   DEFAULT 'CNY' COMMENT '币种',
  `contact_name`     varchar(30)  DEFAULT '' COMMENT '联系人姓名',
  `contact_phone`    varchar(20)  DEFAULT '' COMMENT '联系人手机',
  `payment_method`   varchar(20)  DEFAULT '' COMMENT '支付方式: wechat/alipay/balance/credit/mixed',
  `payment_time`     datetime     DEFAULT NULL COMMENT '支付时间',
  `payment_no`       varchar(64)  DEFAULT '' COMMENT '支付流水号',
  `source`           varchar(20)  DEFAULT 'mini' COMMENT '下单来源: mini/web/h5/app/ota/api',
  `channel_id`       bigint UNSIGNED DEFAULT 0 COMMENT '分销渠道ID(分销商场景)',
  `corporate_id`     bigint UNSIGNED DEFAULT 0 COMMENT '大客户ID(大客户订单关联 corporate_group.id)',
  `remark`           varchar(500) DEFAULT '' COMMENT '客户备注',
  `internal_remark`  varchar(500) DEFAULT '' COMMENT '内部备注(仅B端可见)',
  `ip`               varchar(45)  DEFAULT '' COMMENT '下单IP',
  `created_at`       datetime     DEFAULT NULL,
  `updated_at`       datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_tenant_member` (`tenant_id`, `member_id`, `status`),
  KEY `idx_tenant_status` (`tenant_id`, `status`, `created_at`),
  KEY `idx_user` (`user_id`),
  KEY `idx_parent` (`parent_order_id`),
  KEY `idx_corporate` (`corporate_id`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='主订单(大订单)';


-- ----------------------------------------------------------------
-- 10. order_sales — 销售业务订单
--     按业务类型拆分,每个销售单只属于一种业务类型
--     绑定销售员,管理销售侧状态流转
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order_sales`;
CREATE TABLE `order_sales` (
  `id`               bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `sales_no`         varchar(40)  NOT NULL COMMENT '销售单号(如: HX20250701123456-S-F001)',
  `order_id`         bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `tenant_id`        bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `biz_type`         varchar(20)  NOT NULL COMMENT '业务类型: flight/train/hotel/mall',
  `status`           tinyint      NOT NULL DEFAULT 1 COMMENT '1=待处理,2=处理中,3=部分出票,4=全部完成,5=已取消,6=部分退改,7=出票失败待重采',
  `staff_id`         bigint UNSIGNED DEFAULT 0 COMMENT '销售员ID(指向 mmc_user.id)',
  `staff_name`       varchar(30)  DEFAULT '' COMMENT '销售员姓名(冗余)',
  `item_count`       smallint     DEFAULT 0 COMMENT '子订单数',
  `passenger_count`  smallint     DEFAULT 0 COMMENT '旅客人数',
  `sales_amount`     decimal(12,2) DEFAULT 0.00 COMMENT '销售金额(售价合计)',
  `settle_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '已结算金额',
  `refund_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '退款金额',
  `service_fee`      decimal(12,2) DEFAULT 0.00 COMMENT '服务费合计',
  `insurance_fee`    decimal(12,2) DEFAULT 0.00 COMMENT '保险费合计',
  `source`           varchar(20)  DEFAULT 'mini' COMMENT '来源: mini/web/h5/app/ota/api',
  `channel_id`       bigint UNSIGNED DEFAULT 0 COMMENT '分销渠道ID',
  `corporate_id`     bigint UNSIGNED DEFAULT 0 COMMENT '大客户ID(大客户订单)',
  `contact_name`     varchar(30)  DEFAULT '' COMMENT '联系人',
  `contact_phone`    varchar(20)  DEFAULT '' COMMENT '联系电话',
  `remark`           varchar(500) DEFAULT '' COMMENT '客户备注',
  `internal_remark`  varchar(500) DEFAULT '' COMMENT '内部备注',
  `created_at`       datetime     DEFAULT NULL,
  `updated_at`       datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sales_no` (`sales_no`),
  KEY `idx_order` (`order_id`),
  KEY `idx_tenant_biz_status` (`tenant_id`, `biz_type`, `status`),
  KEY `idx_tenant_staff` (`tenant_id`, `staff_id`),
  KEY `idx_corporate` (`corporate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售业务订单(按业务类型拆分,绑销售员)';


-- ----------------------------------------------------------------
-- 11. order_procurement — 采购业务订单
--     按供应商渠道拆分,每个采购单指向一个供应商
--     绑定采购员,管理采购侧状态流转(出票/确认/失败重采)
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order_procurement`;
CREATE TABLE `order_procurement` (
  `id`               bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `procurement_no`   varchar(40)  NOT NULL COMMENT '采购单号(如: HX20250701123456-P-CA01)',
  `order_id`         bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id`         bigint UNSIGNED NOT NULL COMMENT '来源销售业务订单ID',
  `tenant_id`        bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `biz_type`         varchar(20)  NOT NULL COMMENT '业务类型: flight/train/hotel/mall',
  `status`           tinyint      NOT NULL DEFAULT 1 COMMENT '1=待采购,2=采购中,3=已出票/已确认,4=部分出票,5=采购失败,6=已取消',
  `staff_id`         bigint UNSIGNED DEFAULT 0 COMMENT '采购员ID(指向 mmc_user.id)',
  `staff_name`       varchar(30)  DEFAULT '' COMMENT '采购员姓名(冗余)',
  `item_count`       smallint     DEFAULT 0 COMMENT '采购子订单数',
  `cost_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '采购成本金额',
  `settle_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '已结算金额',
  `supplier_type`    varchar(30)  NOT NULL COMMENT '供应商类型: airline_b2b/airline_b2t/ota_ctrip/ota_qunar/ota_meituan/ota_fligy/railway_12306/hotel_supplier/mall_supplier',
  `supplier_id`      bigint UNSIGNED DEFAULT 0 COMMENT '供应商ID',
  `supplier_name`    varchar(50)  DEFAULT '' COMMENT '供应商名称',
  `supplier_account` varchar(50)  DEFAULT '' COMMENT '供应商账号(如航司B2B账号/携程代理账号)',
  `supplier_order_no` varchar(64) DEFAULT '' COMMENT '供应商订单号(出票后回填)',
  `procure_at`       datetime     DEFAULT NULL COMMENT '采购提交时间',
  `ticket_at`        datetime     DEFAULT NULL COMMENT '出票/确认时间',
  `fail_reason`      varchar(500) DEFAULT '' COMMENT '失败原因',
  `retry_count`      tinyint      DEFAULT 0 COMMENT '重试次数',
  `next_retry_at`    datetime     DEFAULT NULL COMMENT '下次重试时间',
  `remark`           varchar(500) DEFAULT '',
  `created_at`       datetime     DEFAULT NULL,
  `updated_at`       datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_procurement_no` (`procurement_no`),
  KEY `idx_order` (`order_id`),
  KEY `idx_sales` (`sales_id`),
  KEY `idx_tenant_biz_status` (`tenant_id`, `biz_type`, `status`),
  KEY `idx_tenant_staff` (`tenant_id`, `staff_id`),
  KEY `idx_supplier` (`supplier_type`, `supplier_order_no`),
  KEY `idx_status_retry` (`status`, `next_retry_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购业务订单(按渠道拆分,绑采购员)';


-- ----------------------------------------------------------------
-- 12. order_item_flight — 机票子订单
--     人×程 = 最小操作单元, 3人往返 = 6个item
--     包含通用字段 + 机票业务字段(合并,无需额外JOIN)
--     多程联程: 同一次行程的多个item共享 journey_id
--     改签: 新item通过 parent_item_id 指向原item
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order_item_flight`;
CREATE TABLE `order_item_flight` (
  -- ========== 通用字段 ==========
  `id`               bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no`          varchar(40)  NOT NULL COMMENT '子订单号(如: HX20250701123456-001)',
  `order_id`         bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id`         bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id`        bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status`           tinyint      NOT NULL DEFAULT 1 COMMENT '1=待处理,2=处理中,3=已出票,4=已使用,5=退票中,6=已退票,7=改签中,8=已改签,9=已取消,10=出票失败',
  `parent_item_id`   bigint UNSIGNED DEFAULT 0 COMMENT '改签关联: 改签后新item指向原item,0=原始item',
  `change_id`        bigint UNSIGNED DEFAULT 0 COMMENT '变更单ID(退/改/签)',
  `member_id`        bigint UNSIGNED DEFAULT 0 COMMENT '会员ID c_member.id',
  `passenger_id`     bigint UNSIGNED DEFAULT 0 COMMENT '旅客ID c_passenger.id',
  `passenger_name`   varchar(30)  DEFAULT '' COMMENT '旅客姓名(下单快照)',
  `passenger_id_type` tinyint     DEFAULT NULL COMMENT '旅客证件类型(快照): 1=身份证,2=护照...',
  `passenger_id_no`  varchar(30)  DEFAULT '' COMMENT '旅客证件号(快照脱敏)',
  `product_id`       bigint UNSIGNED DEFAULT 0 COMMENT '产品ID',
  `product_snapshot` json         DEFAULT NULL COMMENT '产品快照(下单时票价/舱位/规则等)',
  `unit_price`       decimal(12,2) DEFAULT 0.00 COMMENT '票价',
  `item_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '子订单金额(票价+机建+燃油)',
  `paid_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '退款金额',
  `change_fee`       decimal(12,2) DEFAULT 0.00 COMMENT '改签手续费',
  `service_fee`      decimal(12,2) DEFAULT 0.00 COMMENT '服务费',
  `insurance_fee`    decimal(12,2) DEFAULT 0.00 COMMENT '保险费',
  -- ========== 机票业务字段 ==========
  `journey_id`       bigint UNSIGNED DEFAULT 0 COMMENT '行程ID(同一次行程的多程item共享,0=无关联)',
  `journey_index`    smallint     DEFAULT 0 COMMENT '行程序号(第几程,0=无关联,1=第一段,2=第二段...)',
  `flight_type`      varchar(10)  NOT NULL COMMENT '航程类型: departure=去程/return=回程/oneway=单程/transit=中转',
  `ticket_no`        varchar(50)  DEFAULT '' COMMENT '票号(出票后回填,如: 999-1234567890)',
  `carrier_code`     varchar(5)   NOT NULL COMMENT '承运航司二字码(如: CA)',
  `flight_no`        varchar(10)  NOT NULL COMMENT '航班号(如: CA1234)',
  `share_flight_no`  varchar(10)  DEFAULT '' COMMENT '共享航班号(如有)',
  `departure_code`   varchar(5)   NOT NULL COMMENT '出发机场三字码(如: PEK)',
  `departure_name`   varchar(30)  DEFAULT '' COMMENT '出发城市/机场名',
  `arrival_code`     varchar(5)   NOT NULL COMMENT '到达机场三字码(如: SHA)',
  `arrival_name`     varchar(30)  DEFAULT '' COMMENT '到达城市/机场名',
  `departure_time`   datetime     NOT NULL COMMENT '起飞时间',
  `arrival_time`     datetime     NOT NULL COMMENT '降落时间',
  `cabin_class`      varchar(5)   NOT NULL COMMENT '舱位等级: Y=经济/C=公务/F=头等',
  `cabin_code`       varchar(10)  DEFAULT '' COMMENT '子舱位编码(如: Y/B/M/K)',
  `cabin_name`       varchar(20)  DEFAULT '' COMMENT '舱位中文名(如: 经济舱)',
  `aircraft_type`    varchar(20)  DEFAULT '' COMMENT '机型(如: 737-800)',
  `meal`             varchar(10)  DEFAULT '' COMMENT '餐食: M=餐/B=轻食/N=无',
  `stop_count`       tinyint      DEFAULT 0 COMMENT '经停次数',
  `free_baggage`     varchar(20)  DEFAULT '' COMMENT '免费行李额(如: 20KG)',
  `refund_rule`      varchar(200) DEFAULT '' COMMENT '退票规则摘要(快照)',
  `change_rule`      varchar(200) DEFAULT '' COMMENT '改签规则摘要(快照)',
  -- ========== 时间字段 ==========
  `effective_at`     datetime     DEFAULT NULL COMMENT '生效时间(起飞时间)',
  `expire_at`        datetime     DEFAULT NULL COMMENT '失效时间(降落时间)',
  `cancel_deadline`  datetime     DEFAULT NULL COMMENT '免费取消截止时间',
  `created_at`       datetime     DEFAULT NULL,
  `updated_at`       datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_item_no` (`item_no`),
  KEY `idx_order` (`order_id`, `status`),
  KEY `idx_sales` (`sales_id`, `status`),
  KEY `idx_journey` (`journey_id`, `journey_index`),
  KEY `idx_tenant_status` (`tenant_id`, `status`, `created_at`),
  KEY `idx_passenger` (`passenger_id`),
  KEY `idx_parent_item` (`parent_item_id`),
  KEY `idx_ticket_no` (`ticket_no`),
  KEY `idx_carrier_flight` (`carrier_code`, `flight_no`, `departure_time`),
  KEY `idx_route` (`departure_code`, `arrival_code`, `departure_time`),
  KEY `idx_effective` (`effective_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='机票子订单(人×程=最小操作单元)';


-- ----------------------------------------------------------------
-- 13. order_item_train — 火车票子订单
--     包含通用字段 + 火车票业务字段
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order_item_train`;
CREATE TABLE `order_item_train` (
  -- ========== 通用字段 ==========
  `id`               bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no`          varchar(40)  NOT NULL COMMENT '子订单号',
  `order_id`         bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id`         bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id`        bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status`           tinyint      NOT NULL DEFAULT 1 COMMENT '1=待处理,2=处理中,3=已出票,4=已使用,5=退票中,6=已退票,7=改签中,8=已改签,9=已取消,10=出票失败',
  `parent_item_id`   bigint UNSIGNED DEFAULT 0 COMMENT '改签关联: 改签后新item指向原item,0=原始item',
  `change_id`        bigint UNSIGNED DEFAULT 0 COMMENT '变更单ID',
  `member_id`        bigint UNSIGNED DEFAULT 0 COMMENT '会员ID c_member.id',
  `passenger_id`     bigint UNSIGNED DEFAULT 0 COMMENT '旅客ID c_passenger.id',
  `passenger_name`   varchar(30)  DEFAULT '' COMMENT '旅客姓名(快照)',
  `passenger_id_type` tinyint     DEFAULT NULL COMMENT '旅客证件类型(快照)',
  `passenger_id_no`  varchar(30)  DEFAULT '' COMMENT '旅客证件号(快照脱敏)',
  `product_id`       bigint UNSIGNED DEFAULT 0 COMMENT '产品ID',
  `product_snapshot` json         DEFAULT NULL COMMENT '产品快照',
  `unit_price`       decimal(12,2) DEFAULT 0.00 COMMENT '票价',
  `item_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '子订单金额',
  `paid_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '退款金额',
  `change_fee`       decimal(12,2) DEFAULT 0.00 COMMENT '改签手续费',
  `service_fee`      decimal(12,2) DEFAULT 0.00 COMMENT '服务费',
  `insurance_fee`    decimal(12,2) DEFAULT 0.00 COMMENT '保险费',
  -- ========== 火车票业务字段 ==========
  `ticket_no`        varchar(50)  DEFAULT '' COMMENT '火车票号(出票后回填)',
  `train_no`         varchar(20)  NOT NULL COMMENT '车次(如: G101)',
  `departure_code`   varchar(20)  NOT NULL COMMENT '出发站编码',
  `departure_name`   varchar(30)  DEFAULT '' COMMENT '出发站名',
  `arrival_code`     varchar(20)  NOT NULL COMMENT '到达站编码',
  `arrival_name`     varchar(30)  DEFAULT '' COMMENT '到达站名',
  `departure_time`   datetime     NOT NULL COMMENT '出发时间',
  `arrival_time`     datetime     NOT NULL COMMENT '到达时间',
  `duration`         int          DEFAULT 0 COMMENT '行程时长(分钟)',
  `seat_type`        varchar(20)  NOT NULL COMMENT '座位类型(如: 二等座/一等座/商务座/硬卧/软卧)',
  `seat_code`        varchar(10)  DEFAULT '' COMMENT '座位编码',
  `carriage_no`      varchar(10)  DEFAULT '' COMMENT '车厢号(出票后)',
  `seat_no`          varchar(10)  DEFAULT '' COMMENT '座位号(出票后)',
  `is_student`       tinyint      DEFAULT 2 COMMENT '1=学生票,2=成人票',
  -- ========== 时间字段 ==========
  `effective_at`     datetime     DEFAULT NULL COMMENT '生效时间(出发时间)',
  `expire_at`        datetime     DEFAULT NULL COMMENT '失效时间(到达时间)',
  `cancel_deadline`  datetime     DEFAULT NULL COMMENT '免费取消截止时间',
  `created_at`       datetime     DEFAULT NULL,
  `updated_at`       datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_item_no` (`item_no`),
  KEY `idx_order` (`order_id`, `status`),
  KEY `idx_sales` (`sales_id`, `status`),
  KEY `idx_tenant_status` (`tenant_id`, `status`, `created_at`),
  KEY `idx_passenger` (`passenger_id`),
  KEY `idx_parent_item` (`parent_item_id`),
  KEY `idx_ticket_no` (`ticket_no`),
  KEY `idx_train_date` (`train_no`, `departure_time`),
  KEY `idx_effective` (`effective_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='火车票子订单(人×程=最小操作单元)';


-- ----------------------------------------------------------------
-- 14. order_item_hotel — 酒店子订单
--     包含通用字段 + 酒店业务字段
--     酒店改取消/修改走 order_change,无"改签"概念,故无 parent_item_id
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order_item_hotel`;
CREATE TABLE `order_item_hotel` (
  -- ========== 通用字段 ==========
  `id`               bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no`          varchar(40)  NOT NULL COMMENT '子订单号',
  `order_id`         bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id`         bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id`        bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status`           tinyint      NOT NULL DEFAULT 1 COMMENT '1=待确认,2=处理中,3=已确认,4=已入住,5=取消中,6=已取消,7=已退房,8=预订失败',
  `change_id`        bigint UNSIGNED DEFAULT 0 COMMENT '变更单ID(取消/修改)',
  `member_id`        bigint UNSIGNED DEFAULT 0 COMMENT '会员ID c_member.id',
  `product_id`       bigint UNSIGNED DEFAULT 0 COMMENT '产品ID',
  `product_snapshot` json         DEFAULT NULL COMMENT '产品快照',
  `unit_price`       decimal(12,2) DEFAULT 0.00 COMMENT '每晚房价',
  `item_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '子订单金额(房价×晚数×间数)',
  `paid_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '退款金额',
  `service_fee`      decimal(12,2) DEFAULT 0.00 COMMENT '服务费',
  -- ========== 酒店业务字段 ==========
  `confirmation_no`  varchar(50)  DEFAULT '' COMMENT '酒店确认号(确认后回填)',
  `hotel_id`         bigint UNSIGNED DEFAULT 0 COMMENT '酒店ID',
  `hotel_name`       varchar(100) DEFAULT '' COMMENT '酒店名称',
  `room_type_id`     bigint UNSIGNED DEFAULT 0 COMMENT '房型ID',
  `room_type_name`   varchar(50)  DEFAULT '' COMMENT '房型名称(如: 高级大床房)',
  `city_code`        varchar(20)  DEFAULT '' COMMENT '城市编码',
  `city_name`        varchar(30)  DEFAULT '' COMMENT '城市名',
  `address`          varchar(300) DEFAULT '' COMMENT '酒店地址',
  `star_rate`        tinyint      DEFAULT 0 COMMENT '星级(1-5)',
  `check_in_date`    date         NOT NULL COMMENT '入住日期',
  `check_out_date`   date         NOT NULL COMMENT '离店日期',
  `nights`           smallint     DEFAULT 1 COMMENT '晚数',
  `room_count`       smallint     DEFAULT 1 COMMENT '房间数',
  `breakfast`        varchar(20)  DEFAULT '' COMMENT '早餐: 无/单早/双早',
  `bed_type`         varchar(20)  DEFAULT '' COMMENT '床型: 大床/双床/大/双',
  `cancel_policy`    varchar(200) DEFAULT '' COMMENT '取消政策摘要(快照)',
  `guest_name`       varchar(30)  DEFAULT '' COMMENT '入住人姓名(快照)',
  `guest_phone`      varchar(20)  DEFAULT '' COMMENT '入住人手机(快照)',
  -- ========== 时间字段 ==========
  `effective_at`     datetime     DEFAULT NULL COMMENT '生效时间(入住日)',
  `expire_at`        datetime     DEFAULT NULL COMMENT '失效时间(离店日)',
  `cancel_deadline`  datetime     DEFAULT NULL COMMENT '免费取消截止时间',
  `created_at`       datetime     DEFAULT NULL,
  `updated_at`       datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_item_no` (`item_no`),
  KEY `idx_order` (`order_id`, `status`),
  KEY `idx_sales` (`sales_id`, `status`),
  KEY `idx_tenant_status` (`tenant_id`, `status`, `created_at`),
  KEY `idx_hotel_date` (`hotel_id`, `check_in_date`),
  KEY `idx_effective` (`effective_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='酒店子订单(人×晚×间=最小操作单元)';


-- ----------------------------------------------------------------
-- 15. order_item_mall — 商城子订单
--     包含通用字段 + 商城业务字段
--     无"改签"概念,无出行时间;有物流和积分逻辑
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order_item_mall`;
CREATE TABLE `order_item_mall` (
  -- ========== 通用字段 ==========
  `id`               bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_no`          varchar(40)  NOT NULL COMMENT '子订单号',
  `order_id`         bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id`         bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id`        bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `status`           tinyint      NOT NULL DEFAULT 1 COMMENT '1=待发货,2=已发货,3=已收货,4=退货中,5=已退货,6=已取消',
  `member_id`        bigint UNSIGNED DEFAULT 0 COMMENT '会员ID c_member.id',
  `product_id`       bigint UNSIGNED DEFAULT 0 COMMENT '商品ID(goods_id)',
  `product_snapshot` json         DEFAULT NULL COMMENT '商品快照(名称/图片/规格等)',
  `unit_price`       decimal(12,2) DEFAULT 0.00 COMMENT '单价',
  `quantity`         smallint     DEFAULT 1 COMMENT '数量',
  `item_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '子订单金额',
  `paid_amount`      decimal(12,2) DEFAULT 0.00 COMMENT '实付金额',
  `refund_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '退款金额',
  `service_fee`      decimal(12,2) DEFAULT 0.00 COMMENT '服务费',
  -- ========== 商城业务字段 ==========
  `goods_id`         bigint UNSIGNED DEFAULT 0 COMMENT '商品ID',
  `goods_name`       varchar(200) DEFAULT '' COMMENT '商品名称(快照)',
  `sku_id`           bigint UNSIGNED DEFAULT 0 COMMENT 'SKU ID',
  `sku_attrs`        varchar(200) DEFAULT '' COMMENT 'SKU属性(如: 颜色:红;尺码:XL)',
  `points_used`      int          DEFAULT 0 COMMENT '使用积分数',
  `points_amount`    decimal(12,2) DEFAULT 0.00 COMMENT '积分抵扣金额',
  `address_id`       bigint UNSIGNED DEFAULT 0 COMMENT '收货地址ID c_member_address.id',
  `logistics_no`     varchar(50)  DEFAULT '' COMMENT '物流单号',
  `logistics_company` varchar(30) DEFAULT '' COMMENT '物流公司',
  `shipped_at`       datetime     DEFAULT NULL COMMENT '发货时间',
  `received_at`      datetime     DEFAULT NULL COMMENT '收货时间',
  `created_at`       datetime     DEFAULT NULL,
  `updated_at`       datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_item_no` (`item_no`),
  KEY `idx_order` (`order_id`, `status`),
  KEY `idx_sales` (`sales_id`, `status`),
  KEY `idx_tenant_status` (`tenant_id`, `status`, `created_at`),
  KEY `idx_goods` (`goods_id`),
  KEY `idx_address` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商城子订单(商品件=最小操作单元)';


-- ----------------------------------------------------------------
-- 16. order_procure_item — 采购子订单
--     采购侧的最小操作单元,关联销售item
--     通过 biz_type + sales_item_id 关联到对应的销售item表:
--       flight → order_item_flight.id
--       train  → order_item_train.id
--       hotel  → order_item_hotel.id
--       mall   → order_item_mall.id
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order_procure_item`;
CREATE TABLE `order_procure_item` (
  `id`                bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `procurement_id`    bigint UNSIGNED NOT NULL COMMENT '采购业务订单ID',
  `order_id`          bigint UNSIGNED NOT NULL COMMENT '主订单ID(冗余)',
  `tenant_id`         bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `biz_type`          varchar(20)  NOT NULL COMMENT '业务类型: flight/train/hotel/mall',
  `sales_item_id`     bigint UNSIGNED NOT NULL COMMENT '关联销售子订单ID(按biz_type指向对应表)',
  `status`            tinyint      NOT NULL DEFAULT 1 COMMENT '1=待采购,2=采购中,3=已出票/已确认,4=采购失败,5=已取消',
  `cost_price`        decimal(12,2) DEFAULT 0.00 COMMENT '采购成本单价',
  `cost_amount`       decimal(12,2) DEFAULT 0.00 COMMENT '采购总金额',
  `settle_amount`     decimal(12,2) DEFAULT 0.00 COMMENT '已结算金额',
  `supplier_ticket_no` varchar(50) DEFAULT '' COMMENT '供应商票号/确认号(出票后回填)',
  `supplier_pnr`      varchar(30)  DEFAULT '' COMMENT '航司PNR(机票采购)',
  `fail_reason`       varchar(500) DEFAULT '' COMMENT '失败原因',
  `retry_count`       tinyint      DEFAULT 0 COMMENT '重试次数',
  `next_retry_at`     datetime     DEFAULT NULL COMMENT '下次重试时间',
  `remark`            varchar(500) DEFAULT '',
  `created_at`        datetime     DEFAULT NULL,
  `updated_at`        datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_procurement` (`procurement_id`, `status`),
  KEY `idx_sales_item` (`biz_type`, `sales_item_id`),
  KEY `idx_order` (`order_id`),
  KEY `idx_tenant` (`tenant_id`, `status`),
  KEY `idx_status_retry` (`status`, `next_retry_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购子订单(关联销售item,按渠道出票)';


-- ----------------------------------------------------------------
-- 17. order_change — 订单变更记录(退/改/签)
--     主要服务于机票/火车票的退改签场景
--     酒店取消/修改也走此表
--     通过 origin_item_ids / new_item_ids 关联具体item
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS `order_change`;
CREATE TABLE `order_change` (
  `id`              bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `change_no`       varchar(40)  NOT NULL COMMENT '变更单号(如: HX20250701123456-C001)',
  `order_id`        bigint UNSIGNED NOT NULL COMMENT '主订单ID',
  `sales_id`        bigint UNSIGNED NOT NULL COMMENT '销售业务订单ID',
  `tenant_id`       bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `member_id`       bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `change_type`     varchar(20)  NOT NULL COMMENT 'refund=退票/change=改签/endorse=签转/cancel=取消(酒店)',
  `biz_type`        varchar(20)  NOT NULL COMMENT 'flight/train/hotel',
  `status`          tinyint      NOT NULL DEFAULT 1 COMMENT '1=待审核,2=处理中,3=已完成,4=已拒绝,5=已取消',
  `origin_item_ids` json         NOT NULL COMMENT '原item ID列表(按biz_type对应不同表)',
  `new_item_ids`    json         DEFAULT NULL COMMENT '新item ID列表(仅改签产生新item)',
  `change_reason`   varchar(20)  DEFAULT '' COMMENT '变更原因: voluntary=自愿/force=航司取消/weather=天气/schedule_change=航班变动',
  `refund_amount`   decimal(12,2) DEFAULT 0.00 COMMENT '退款金额',
  `change_fee`      decimal(12,2) DEFAULT 0.00 COMMENT '变更手续费',
  `change_diff`     decimal(12,2) DEFAULT 0.00 COMMENT '改签差价(正=补价,负=退差)',
  `refund_to`       varchar(20)  DEFAULT 'original' COMMENT '退款去向: original=原路退回/balance=退到钱包',
  `apply_at`        datetime     DEFAULT NULL COMMENT '申请时间',
  `confirm_at`      datetime     DEFAULT NULL COMMENT '确认时间',
  `complete_at`     datetime     DEFAULT NULL COMMENT '完成时间',
  `operator_type`   varchar(20)  DEFAULT 'member' COMMENT 'member=用户申请/admin=后台操作/system=系统自动',
  `operator_id`     bigint UNSIGNED DEFAULT 0 COMMENT '操作人ID',
  `remark`          varchar(500) DEFAULT '',
  `internal_remark` varchar(500) DEFAULT '' COMMENT '内部备注(仅B端)',
  `created_at`      datetime     DEFAULT NULL,
  `updated_at`      datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_change_no` (`change_no`),
  KEY `idx_order` (`order_id`, `change_type`),
  KEY `idx_sales` (`sales_id`),
  KEY `idx_tenant_status` (`tenant_id`, `status`, `created_at`),
  KEY `idx_member` (`member_id`, `created_at`),
  KEY `idx_type_status` (`biz_type`, `change_type`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单变更记录(退/改/签)';


SET FOREIGN_KEY_CHECKS = 1;

/*
 * ============================================================
 * 表关系速查
 * ============================================================
 *
 * ── C端用户体系 ──────────────────────────────────────
 *
 *   c_user (平台自然人)
 *     │  1:N
 *     ├── c_member (商户会员, tenant_id 隔离)
 *     │     ├── 1:N → c_member_address
 *     │     ├── 1:N → c_passenger
 *     │     └── 1:N → c_member_corporate (uk_guard 保证同航司唯一)
 *     │
 *     └── c_member_corporate_apply (申报全量审计)
 *           ↑
 *     corporate_group ──┘  (大客户集团配置)
 *     corporate_policy     (自动申报政策)
 *
 * ── 订单体系 ──────────────────────────────────────
 *
 *   `order` (主订单)
 *     │
 *     ├── 1:N → order_sales (销售业务订单, 按biz_type拆分)
 *     │           │
 *     │           ├── 1:N → order_item_flight  ──┐
 *     │           ├── 1:N → order_item_train   ──┤ sales_item_id
 *     │           ├── 1:N → order_item_hotel   ──┤
 *     │           └── 1:N → order_item_mall    ──┘
 *     │                                           │
 *     ├── 1:N → order_procurement (采购业务订单)    │
 *     │           │                              │
 *     │           └── 1:N → order_procure_item ──┘
 *     │                        (biz_type + sales_item_id 关联回销售item)
 *     │
 *     └── 1:N → order_change (变更记录)
 *                 (origin_item_ids / new_item_ids 引用对应item表)
 *
 * ── 拆单场景 ──────────────────────────────────────
 *
 *   C端拆单: 新 `order`(parent_order_id=原订单) + item 的 order_id 指向新订单
 *   B端拆采: 同一 sales 下拆多个 procurement, 各自包含不同 procure_item
 *   改签: 新 item(parent_item_id=原item) + order_change 记录
 *
 * ── 大客户身份校验流程 ──────────────────────────────
 *
 *   1. 查 c_member_corporate WHERE user_id=? AND airline_code=? AND status=1
 *      → 存在 → 阻止: "已有该航司大客户身份"
 *   2. 查 c_member_corporate_apply WHERE user_id=? AND airline_code=? AND submit_status IN (1,2,3)
 *      → 存在 → 阻止: "已有该航司申报在处理中"
 *   3. 查 c_member_corporate WHERE user_id=? AND airline_code=? AND status IN (2,3,4)
 *      → 存在 → 警告: "曾有该航司大客户身份", 需人工确认
 *   4. 写入 conflict_check 快照 → 创建申报
 *   5. 审核通过 → 写入 c_member_corporate (uk_guard 保证唯一)
 *
 * ============================================================
 */
