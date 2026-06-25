-- ============================================================
-- 华夏航旅 B2B2C — 增量迁移脚本 (v6 -> v7)
-- ============================================================
-- 源库   : hx_b2b2c (v6, 48张基础设施表)
-- 目标   : 在v6基础上新增36张业务表
-- 数据库 : MySQL 8.0.35, utf8mb4_unicode_ci
-- 日期   : 2025-07
-- ============================================================
--
-- 变更说明:
--   本脚本仅包含 CREATE TABLE 语句, 不修改v6任何已有表
--   v6的48张表(attachment/rules/tenant/pmc_xxx/tmc_xxx/mmc_xxx等)不受影响
--
-- 新增表分组:
--   [C端用户体系 9张]
--     c_user / c_member / c_member_address / c_passenger
--     corporate_group / corporate_contract / corporate_policy
--     c_member_corporate / c_member_corporate_apply
--
--   [大客户白名单体系 3张]
--     corporate_whitelist_template / corporate_whitelist_batch / corporate_whitelist_member
--
--   [订单体系 9张]
--     `order` / order_sales / order_procurement
--     order_item_flight / order_item_train / order_item_hotel / order_item_mall
--     order_procure_item / order_change
--
--   [航空基础数据 13张]
--     air_airline / air_airport / air_region / air_plane_model
--     air_cabin_level / air_cabin / air_fuel / air_fuel_detail
--     air_gauge_type / air_gauge / air_airline_accounts / air_platform
--     air_airline_notice
--
--   [大客户政策匹配 2张]
--     corporate_policy_rule / corporate_policy_match_log
--
-- 执行方式:
--   mysql -u root -p hx_b2b2c < hx_b2b2c_v6_to_v7_migration.sql
--
-- 回滚方式:
--   见文件末尾 DROP TABLE 语句(注释状态)
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE IF NOT EXISTS `c_user` (
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

CREATE TABLE IF NOT EXISTS `c_member` (
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

CREATE TABLE IF NOT EXISTS `c_member_address` (
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

CREATE TABLE IF NOT EXISTS `c_passenger` (
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

CREATE TABLE IF NOT EXISTS `corporate_group` (
  `id`              bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_name`      varchar(100) NOT NULL COMMENT '大客户集团名称(如: 华为技术有限公司)',
  `group_code`      varchar(50)  NOT NULL COMMENT '集团编码(唯一标识,如: HUAWEI)',
  `unified_social_credit` varchar(20) DEFAULT '' COMMENT '统一社会信用代码(企业唯一标识)',
  `contact_name`    varchar(30)  DEFAULT '' COMMENT '集团联系人',
  `contact_phone`   varchar(20)  DEFAULT '' COMMENT '集团联系电话',
  `address`         varchar(300) DEFAULT '' COMMENT '集团地址',
  `industry`        varchar(30)  DEFAULT '' COMMENT '行业分类(如: 通信/互联网/金融)',
  `scale`           varchar(20)  DEFAULT '' COMMENT '企业规模(如: 万人以上/千人/百人)',
  `remark`          varchar(500) DEFAULT '' COMMENT '备注',
  `status`          tinyint      DEFAULT 1 COMMENT '1=有效,2=停用',
  `created_by`      bigint       DEFAULT 0,
  `updated_by`      bigint       DEFAULT 0,
  `created_at`      datetime     DEFAULT NULL,
  `updated_at`      datetime     DEFAULT NULL,
  `deleted_at`      timestamp    DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_code` (`group_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户集团主体(平台级,一个集团可跨航司签约)';

CREATE TABLE IF NOT EXISTS `corporate_contract` (
  `id`                bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id`          bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id',
  `airline_code`      varchar(10)  NOT NULL COMMENT '签约航司二字码(如: CA)',
  `contract_no`       varchar(50)  DEFAULT '' COMMENT '大客户协议编号',
  `corp_type`         varchar(20)  DEFAULT 'enterprise' COMMENT 'enterprise=企业大客户/gp=公务员',

  -- ====== 实名/非实名 & 成员约束 ======
  `is_realname`       tinyint      NOT NULL DEFAULT 1 COMMENT '1=实名制(需白名单),0=非实名(年龄范围内即可)',
  `age_min`           tinyint      DEFAULT 0 COMMENT '非实名最小年龄(0=不限, 如: 20)',
  `age_max`           tinyint      DEFAULT 0 COMMENT '非实名最大年龄(0=不限, 如: 65)',
  `multi_idcard`      tinyint      DEFAULT 0 COMMENT '1=支持多证件上报(如CZ多证件模板),0=单证件',

  -- ====== 出票前置指令(写入PNR) ======
  `pre_cmd_domestic`  varchar(200) DEFAULT '' COMMENT '国内出票前置指令(如: RMK IC CZ/2602342)',
  `pre_cmd_intl`      varchar(200) DEFAULT '' COMMENT '国际出票前置指令(如: SSR CKIN CA HK1 VICO0WN10FTG)',

  -- ====== 运价指令(写入PAT/QTE行) ======
  `price_cmd_domestic` varchar(200) DEFAULT '' COMMENT '国内运价指令(如: PAT:A#CDK2602342)',
  `price_cmd_intl`    varchar(200) DEFAULT '' COMMENT '国际运价指令(如: QTE:/CZ///#CV2602342)',

  -- ====== 业务范围 ======
  `biz_scope`         varchar(20)  DEFAULT 'both' COMMENT 'domestic=仅国内/intl=仅国际/both=国内+国际',
  `discount_info`     varchar(200) DEFAULT '' COMMENT '优惠信息摘要(如: 经济舱95折/公务舱9折/无优惠送里程)',
  `travel_target`     varchar(100) DEFAULT '' COMMENT '差旅指标(如: 20万/年)',

  -- ====== 不适用日期/时段 ======
  `exclude_dates`     json         DEFAULT NULL COMMENT '不适用日期规则(JSON数组)',
  -- 示例: [{"type":"fixed","start":"2025-04-20","end":"2025-05-06","name":"五一节"},
  --        {"type":"lunar","start":"正月初一前9天","end":"正月初一后8天","name":"春节"},
  --        {"type":"yearly","start_month":9,"start_day":20,"end_month":10,"end_day":9,"name":"国庆+中秋"}]

  -- ====== 申报方式配置 ======
  `submit_methods`    varchar(50)  NOT NULL COMMENT '支持的申报方式: api/file/api+file',
  `api_config`        json         DEFAULT NULL COMMENT 'API申报配置(接口地址/认证方式/报文格式)',
  `whitelist_tpl_id`  bigint UNSIGNED DEFAULT 0 COMMENT '白名单模板ID(corporate_whitelist_template.id)',
  `submit_cycle`      varchar(20)  DEFAULT 'realtime' COMMENT '申报周期: realtime/daily/weekly/monthly',
  `review_days`       smallint     DEFAULT 0 COMMENT '预估审核天数(0=实时)',

  -- ====== 协议有效期 ======
  `protocol_start`    date         DEFAULT NULL COMMENT '协议开始日期(如: 2023-10-10)',
  `protocol_end`      date         DEFAULT NULL COMMENT '协议结束日期(如: 2026-12-31)',
  `current_start`     date         DEFAULT NULL COMMENT '当前有效期开始(如: 2023-10-10,每年续签会更新)',
  `current_end`       date         DEFAULT NULL COMMENT '当前有效期结束(如: 2024-10-10)',
  `corp_code_rule`    varchar(100) DEFAULT '' COMMENT '大客户员工编号生成规则(如: {airline}-{group}-{seq})',

  -- ====== 通用字段 ======
  `status`            tinyint      DEFAULT 1 COMMENT '1=有效,2=暂停,3=已过期',
  `remark`            varchar(500) DEFAULT '',
  `created_by`        bigint       DEFAULT 0,
  `updated_by`        bigint       DEFAULT 0,
  `created_at`        datetime     DEFAULT NULL,
  `updated_at`        datetime     DEFAULT NULL,
  `deleted_at`        timestamp    DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_airline` (`group_id`, `airline_code`),
  KEY `idx_airline_status` (`airline_code`, `status`),
  KEY `idx_corp_type` (`corp_type`, `status`),
  KEY `idx_realname` (`is_realname`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户签约关系(集团×航司,航司特定配置)';

CREATE TABLE IF NOT EXISTS `corporate_policy` (
  `id`              bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `policy_name`     varchar(100) NOT NULL COMMENT '政策名称(如: CA航司华北散客自动申报华为)',
  `policy_code`     varchar(50)  NOT NULL COMMENT '政策编码(唯一)',
  `airline_code`    varchar(10)  NOT NULL COMMENT '适用航司',
  `group_id`        bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id(目标集团)',
  `contract_id`     bigint UNSIGNED NOT NULL COMMENT 'corporate_contract.id(目标签约关系)',
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
  KEY `idx_contract` (`contract_id`, `status`),
  KEY `idx_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户自动申报政策';

CREATE TABLE IF NOT EXISTS `c_member_corporate` (
  `id`              bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`         bigint UNSIGNED NOT NULL COMMENT 'c_user.id(平台级自然人)',
  `tenant_id`       bigint UNSIGNED NOT NULL COMMENT '申报商户ID(哪个商户提交的申报)',
  `member_id`       bigint UNSIGNED NOT NULL COMMENT 'c_member.id(冗余,商户维度查询)',
  `airline_code`    varchar(10)  NOT NULL COMMENT '航司二字码',
  `group_id`        bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id(所属集团)',
  `contract_id`     bigint UNSIGNED NOT NULL COMMENT 'corporate_contract.id(所属签约关系)',
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
  KEY `idx_contract` (`contract_id`, `status`),
  KEY `idx_group` (`group_id`, `status`),
  KEY `idx_user_airline` (`user_id`, `airline_code`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户成员身份(平台级,同航司唯一)';

CREATE TABLE IF NOT EXISTS `c_member_corporate_apply` (
  `id`                bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `apply_no`          varchar(40)  NOT NULL COMMENT '申报单号',
  `user_id`           bigint UNSIGNED NOT NULL COMMENT 'c_user.id',
  `tenant_id`         bigint UNSIGNED NOT NULL COMMENT '申报商户ID',
  `member_id`         bigint UNSIGNED NOT NULL COMMENT 'c_member.id',
  `airline_code`      varchar(10)  NOT NULL COMMENT '航司二字码',
  `group_id`          bigint UNSIGNED NOT NULL COMMENT 'corporate_group.id(目标集团)',
  `contract_id`       bigint UNSIGNED NOT NULL COMMENT 'corporate_contract.id(目标签约关系)',
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
  KEY `idx_contract` (`contract_id`, `submit_status`),
  KEY `idx_group` (`group_id`),
  KEY `idx_batch` (`batch_no`),
  KEY `idx_status_retry` (`submit_status`, `next_retry_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户成员申报记录(全量审计)';

CREATE TABLE IF NOT EXISTS `corporate_whitelist_template` (
  `id`                bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code`      char(2)      NOT NULL COMMENT '航司二字码',
  `template_name`     varchar(100) NOT NULL COMMENT '模板名称(如: CZ单证件白名单/CZ多证件白名单/3U白名单)',
  `template_code`     varchar(50)  NOT NULL COMMENT '模板编码(如: CZ_SINGLE_ID/CZ_MULTI_ID/3U_STANDARD)',
  `field_config`      json         NOT NULL COMMENT '字段配置(JSON,定义每个字段的名称/类型/必填/校验规则)',
  `sample_row`        json         DEFAULT NULL COMMENT '示例行数据(供前端展示/下载模板)',
  `max_rows_per_batch` int         DEFAULT 5000 COMMENT '单次最大导入行数',
  `supported_actions`  varchar(50) DEFAULT 'A,D' COMMENT '支持的操作类型: A=新增,D=删除,U=更新',
  `encoding`          varchar(20)  DEFAULT 'UTF-8' COMMENT '文件编码要求',
  `file_format`       varchar(10)  DEFAULT 'xlsx' COMMENT '文件格式: xlsx/csv/txt',
  `submit_method`     varchar(30)  NOT NULL DEFAULT 'file' COMMENT '提交方式: api/file/both',
  `api_endpoint`      varchar(500) DEFAULT '' COMMENT 'API提交地址(如航司提供)',
  `api_config`        json         DEFAULT NULL COMMENT 'API鉴权/请求格式配置',
  `remark`            varchar(500) DEFAULT '' COMMENT '模板说明/注意事项',
  `is_active`         tinyint      NOT NULL DEFAULT 1 COMMENT '1=启用,0=停用',
  `created_at`        datetime     DEFAULT NULL,
  `updated_at`        datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_template_code` (`template_code`),
  KEY `idx_airline` (`airline_code`, `is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='航司白名单导入模板(各航司格式不同)';

CREATE TABLE IF NOT EXISTS `corporate_whitelist_batch` (
  `id`                bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `batch_no`          varchar(40)  NOT NULL COMMENT '批次号(如: WL20250701123456)',
  `contract_id`       bigint UNSIGNED NOT NULL COMMENT '签约关系ID(corporate_contract.id)',
  `group_id`          bigint UNSIGNED NOT NULL COMMENT '集团ID(corporate_group.id)',
  `airline_code`      char(2)      NOT NULL COMMENT '航司二字码(冗余)',
  `template_id`       bigint UNSIGNED DEFAULT 0 COMMENT '使用的模板ID(corporate_whitelist_template.id)',
  `submit_method`     varchar(20)  NOT NULL COMMENT 'api/file',
  `action_type`       char(1)      DEFAULT 'A' COMMENT 'A=新增,D=删除,U=更新',
  `total_count`       int          NOT NULL DEFAULT 0 COMMENT '总条数',
  `success_count`     int          NOT NULL DEFAULT 0 COMMENT '成功条数',
  `fail_count`        int          NOT NULL DEFAULT 0 COMMENT '失败条数',
  `status`            tinyint      NOT NULL DEFAULT 1 COMMENT '1=待提交,2=提交中,3=部分成功,4=全部成功,5=全部失败,6=已撤回',
  `file_id`           bigint UNSIGNED DEFAULT 0 COMMENT '上传文件ID(file方式,attachment.id)',
  `file_original_name` varchar(255) DEFAULT '' COMMENT '原始文件名',
  `api_request`       json         DEFAULT NULL COMMENT 'API请求报文快照',
  `api_response`      json         DEFAULT NULL COMMENT 'API响应报文快照',
  `submit_at`         datetime     DEFAULT NULL COMMENT '提交时间',
  `finished_at`       datetime     DEFAULT NULL COMMENT '处理完成时间',
  `review_note`       varchar(500) DEFAULT '' COMMENT '审核/处理备注',
  `operator_id`       bigint UNSIGNED DEFAULT 0 COMMENT '操作人ID',
  `operator_name`     varchar(50)  DEFAULT '' COMMENT '操作人姓名(冗余)',
  `remark`            varchar(500) DEFAULT '',
  `created_at`        datetime     DEFAULT NULL,
  `updated_at`        datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_batch_no` (`batch_no`),
  KEY `idx_contract` (`contract_id`, `status`),
  KEY `idx_airline_status` (`airline_code`, `status`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='白名单提交批次(一次提交=一个批次)';

CREATE TABLE IF NOT EXISTS `corporate_whitelist_member` (
  `id`                bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `batch_id`          bigint UNSIGNED NOT NULL COMMENT '批次ID(corporate_whitelist_batch.id)',
  `contract_id`       bigint UNSIGNED NOT NULL COMMENT '签约关系ID(冗余)',
  `airline_code`      char(2)      NOT NULL COMMENT '航司二字码(冗余)',
  `line_no`           int          NOT NULL DEFAULT 0 COMMENT '原始行号(文件导入时)',
  `action`            char(1)      DEFAULT 'A' COMMENT 'A=新增,D=删除',
  -- === 航司要求的标准字段(全量存储,不同航司不同模板时部分字段为空) ===
  `name_cn`           varchar(50)  DEFAULT '' COMMENT '中文姓名',
  `name_en`           varchar(80)  DEFAULT '' COMMENT '英文姓名(姓/名拼接后)',
  `last_name_en`      varchar(40)  DEFAULT '' COMMENT '英文姓',
  `first_name_en`     varchar(40)  DEFAULT '' COMMENT '英文名',
  `id_type`           varchar(10)  DEFAULT '' COMMENT '证件类型(NI=身份证/PP=护照/HX=回乡证/HY=海员证/TW=台胞证/OTHER=其他)',
  `id_number`         varchar(50)  DEFAULT '' COMMENT '证件号码',
  `id_number_2_type`  varchar(10)  DEFAULT '' COMMENT '第二证件类型',
  `id_number_2`       varchar(50)  DEFAULT '' COMMENT '第二证件号码(如CZ多证件模式)',
  `id_number_3_type`  varchar(10)  DEFAULT '' COMMENT '第三证件类型',
  `id_number_3`       varchar(50)  DEFAULT '' COMMENT '第三证件号码',
  `birthday`          date         DEFAULT NULL COMMENT '出生日期',
  `gender`            char(1)      DEFAULT '' COMMENT 'M=男/F=女',
  `mobile`            varchar(20)  DEFAULT '' COMMENT '手机号码(CA国航要求)',
  `corp_member_code`  varchar(50)  DEFAULT '' COMMENT '大客户成员编码(3U川航/企业卡号等)',
  `employee_type`     varchar(20)  DEFAULT '' COMMENT '员工类型(CA国航: 普通管理员/管理员/领导)',
  `expiry_date`       date         DEFAULT NULL COMMENT '协议截止日期(3U川航要求)',
  `extra_fields`      json         DEFAULT NULL COMMENT '模板扩展字段(航司特有字段)',
  -- === 关联与状态 ===
  `user_id`           bigint UNSIGNED DEFAULT 0 COMMENT '关联c_user.id(匹配后回填)',
  `member_id`         bigint UNSIGNED DEFAULT 0 COMMENT '关联c_member.id(匹配后回填)',
  `passenger_id`      bigint UNSIGNED DEFAULT 0 COMMENT '关联c_passenger.id(匹配后回填)',
  `match_status`      tinyint      DEFAULT 0 COMMENT '0=未匹配,1=已匹配,2=多人匹配需人工,3=匹配失败',
  `match_log`         varchar(500) DEFAULT '' COMMENT '匹配日志',
  `submit_status`     tinyint      DEFAULT 1 COMMENT '1=待提交,2=已提交,3=已通过,4=已拒绝,5=提交失败',
  `submit_error`      varchar(500) DEFAULT '' COMMENT '提交/审核失败原因',
  `corporate_member_id` bigint UNSIGNED DEFAULT 0 COMMENT '审核通过后写入 c_member_corporate.id',
  `remark`            varchar(500) DEFAULT '',
  `created_at`        datetime     DEFAULT NULL,
  `updated_at`        datetime     DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_batch` (`batch_id`, `submit_status`),
  KEY `idx_contract` (`contract_id`, `action`),
  KEY `idx_id_number` (`id_type`, `id_number`),
  KEY `idx_user` (`user_id`, `airline_code`),
  KEY `idx_match` (`match_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='白名单成员明细(航司视角名单数据)';

CREATE TABLE IF NOT EXISTS `order` (
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
  `contract_id`      bigint UNSIGNED DEFAULT 0 COMMENT '大客户签约ID(大客户订单关联 corporate_contract.id)',
  `group_id`         bigint UNSIGNED DEFAULT 0 COMMENT '大客户集团ID(冗余, corporate_group.id)',
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
  KEY `idx_contract` (`contract_id`),
  KEY `idx_group` (`group_id`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='主订单(大订单)';

CREATE TABLE IF NOT EXISTS `order_sales` (
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
  `contract_id`      bigint UNSIGNED DEFAULT 0 COMMENT '大客户签约ID(corporate_contract.id)',
  `group_id`         bigint UNSIGNED DEFAULT 0 COMMENT '大客户集团ID(冗余)',
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
  KEY `idx_contract` (`contract_id`),
  KEY `idx_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售业务订单(按业务类型拆分,绑销售员)';

CREATE TABLE IF NOT EXISTS `order_procurement` (
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

CREATE TABLE IF NOT EXISTS `order_item_flight` (
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

CREATE TABLE IF NOT EXISTS `order_item_train` (
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

CREATE TABLE IF NOT EXISTS `order_item_hotel` (
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

CREATE TABLE IF NOT EXISTS `order_item_mall` (
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

CREATE TABLE IF NOT EXISTS `order_procure_item` (
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

CREATE TABLE IF NOT EXISTS `order_change` (
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

CREATE TABLE IF NOT EXISTS `air_airline` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` char(2) NOT NULL COMMENT '航司2字码(IATA)',
  `name` varchar(100) NOT NULL COMMENT '航司简称',
  `full_name` varchar(200) NULL DEFAULT NULL COMMENT '航司全称',
  `ticket_code` char(3) NULL DEFAULT NULL COMMENT '开票3字码(IATA)',
  `area` enum('N','I') NULL DEFAULT 'N' COMMENT 'N=国内 I=国际',
  `logo` varchar(255) NULL DEFAULT NULL COMMENT 'logo URL',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='航司主数据';

CREATE TABLE IF NOT EXISTS `air_airport` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` char(3) NOT NULL COMMENT '机场3字码(IATA)',
  `name` varchar(80) NOT NULL COMMENT '机场中文名',
  `name_en` varchar(100) NULL DEFAULT NULL COMMENT '机场英文名',
  `city_code` char(3) NULL DEFAULT NULL COMMENT '城市3字码',
  `city_name` varchar(50) NULL DEFAULT NULL COMMENT '城市中文名',
  `city_name_en` varchar(50) NULL DEFAULT NULL COMMENT '城市英文名',
  `province` varchar(30) NULL DEFAULT NULL COMMENT '省/州',
  `country_code` char(2) NULL DEFAULT NULL COMMENT '国家代码(ISO 3166-1 alpha-2)',
  `country_name` varchar(30) NULL DEFAULT NULL COMMENT '国家中文名',
  `continent` varchar(20) NULL DEFAULT NULL COMMENT '洲',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`,`deleted_at`),
  KEY `idx_city_code` (`city_code`),
  KEY `idx_country_code` (`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='机场主数据';

CREATE TABLE IF NOT EXISTS `air_region` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(12) NOT NULL COMMENT '行政区划代码',
  `name` varchar(32) NOT NULL COMMENT '名称',
  `level` tinyint UNSIGNED NOT NULL COMMENT '层级: 1=省/直辖市 2=市 3=区县',
  `parent_code` varchar(12) NULL DEFAULT NULL COMMENT '父级行政区划代码',
  `province_code` varchar(12) NULL DEFAULT NULL COMMENT '顶级(省)行政区划代码',
  `city_iata_code` char(3) NULL DEFAULT NULL COMMENT '城市3字码(关联air_airport.city_code)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_parent_code` (`parent_code`),
  KEY `idx_province_code` (`province_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='行政区划(省/市/区三级)';

CREATE TABLE IF NOT EXISTS `air_plane_model` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` char(10) NOT NULL COMMENT '机型代码(如738/A320)',
  `manufacturer` varchar(30) NULL DEFAULT NULL COMMENT '生产厂家(Boeing/Airbus/COMAC等)',
  `build_fee` decimal(10,2) NULL DEFAULT 0.00 COMMENT '机建费(元)',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='机型数据(含机建费)';

CREATE TABLE IF NOT EXISTS `air_cabin_level` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) NOT NULL COMMENT '航司2字码',
  `name` varchar(50) NOT NULL COMMENT '舱位等级名称(经济舱/公务舱/头等舱等)',
  `standard_cabin_code` char(1) NOT NULL COMMENT '标准舱位代码(Y/C/F)',
  `child_discount` decimal(5,2) NULL DEFAULT NULL COMMENT '儿童折扣(如67.00=6.7折)',
  `infant_discount` decimal(5,2) NULL DEFAULT NULL COMMENT '婴儿折扣(如10.00=1折)',
  `baggage` varchar(255) NULL DEFAULT NULL COMMENT '标准行李额(如"20KG")',
  `sort` int NOT NULL DEFAULT 100 COMMENT '权重: 越大越靠前',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_airline_std_cabin` (`airline_code`,`standard_cabin_code`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='航司舱位等级';

CREATE TABLE IF NOT EXISTS `air_cabin` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `cabin_level_id` int UNSIGNED NOT NULL COMMENT '舱位等级ID',
  `airline_code` char(2) NOT NULL COMMENT '航司2字码(冗余,便于查询)',
  `cabin_code` char(1) NOT NULL COMMENT '舱位编号(如Y/B/M/K等)',
  `discount` char(5) NULL DEFAULT NULL COMMENT '成人折扣(如"45"=4.5折)',
  `is_sellable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=可销售舱位 0=不可销售',
  `is_published` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=公布运价舱位 0=不公布',
  `baggage_override` varchar(255) NULL DEFAULT NULL COMMENT '行李额覆盖(为空则继承等级标准)',
  `base_agency_fee` decimal(8,2) NULL DEFAULT 0.00 COMMENT '基础代理费',
  `sort` int NOT NULL DEFAULT 10 COMMENT '权重: 越大越靠前',
  `effect_start` varchar(30) NULL DEFAULT NULL COMMENT '生效时间',
  `effect_end` varchar(30) NULL DEFAULT NULL COMMENT '失效时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_airline_cabin` (`airline_code`,`cabin_code`,`deleted_at`),
  KEY `idx_cabin_level_id` (`cabin_level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='舱位明细(等级下具体舱位)';

CREATE TABLE IF NOT EXISTS `air_fuel` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) NOT NULL COMMENT '航司2字码',
  `adult_fuel` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '成人燃油费(元)',
  `child_fuel` decimal(10,2) NULL DEFAULT 0.00 COMMENT '儿童燃油费(元)',
  `infant_fuel` decimal(10,2) NULL DEFAULT 0.00 COMMENT '婴儿燃油费(元)',
  `mileage_threshold` int NOT NULL DEFAULT 800 COMMENT '里程阈值(KM): 超过此值用另一档',
  `adult_fuel_long` decimal(10,2) NULL DEFAULT 0.00 COMMENT '成人燃油费-长航线(元)',
  `child_fuel_long` decimal(10,2) NULL DEFAULT 0.00 COMMENT '儿童燃油费-长航线(元)',
  `infant_fuel_long` decimal(10,2) NULL DEFAULT 0.00 COMMENT '婴儿燃油费-长航线(元)',
  `effect_start` date NULL DEFAULT NULL COMMENT '生效日期',
  `effect_end` date NULL DEFAULT NULL COMMENT '失效日期',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_airline_effect` (`airline_code`,`effect_start`,`effect_end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='航司燃油费(按里程分档)';

CREATE TABLE IF NOT EXISTS `air_fuel_detail` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) NOT NULL COMMENT '航司2字码',
  `dep_code` char(3) NOT NULL COMMENT '出发机场3字码',
  `arr_code` char(3) NOT NULL COMMENT '到达机场3字码',
  `mileage` int NOT NULL DEFAULT 0 COMMENT '里程(KM)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route` (`airline_code`,`dep_code`,`arr_code`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='航程里程(航司×出发×到达)';

CREATE TABLE IF NOT EXISTS `air_gauge_type` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) NOT NULL COMMENT '航司2字码',
  `change_type` tinyint UNSIGNED NOT NULL COMMENT '1=退票 2=改签',
  `hours_before` int UNSIGNED NULL DEFAULT NULL COMMENT '航班离站前N小时',
  `hours_before_inclusive` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'hours_before是否包含(0=不包含 1=包含)',
  `hours_after` int NULL DEFAULT NULL COMMENT '航班离站后N小时',
  `hours_after_inclusive` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'hours_after是否包含(0=不包含 1=包含)',
  `sort` int NOT NULL DEFAULT 10 COMMENT '排序: 越小越优先匹配',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_airline_type` (`airline_code`,`change_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客规时间段类型(退/改的时段定义)';

CREATE TABLE IF NOT EXISTS `air_gauge` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) NOT NULL COMMENT '航司2字码',
  `cabin_codes` varchar(255) NULL DEFAULT NULL COMMENT '适用舱位编号集合(逗号分隔, 空=全部)',
  `gauge_type_id` int UNSIGNED NOT NULL COMMENT '客规时间段类型ID',
  `effect_start` datetime NULL DEFAULT NULL COMMENT '生效时间',
  `effect_end` datetime NULL DEFAULT NULL COMMENT '失效时间',
  `discount_scope` varchar(100) NULL DEFAULT NULL COMMENT '折扣范围(如"1-3折/4折以上")',
  `fee_rate` json NULL COMMENT '退改费率集合({refund_rate,change_rate,format})',
  `refund_desc` varchar(1024) NULL DEFAULT NULL COMMENT '退票说明',
  `change_desc` varchar(255) NULL DEFAULT NULL COMMENT '签转规定',
  `is_noshow` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为noshow规则',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_airline_cabin` (`airline_code`,`gauge_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客规(退改签规则)';

CREATE TABLE IF NOT EXISTS `air_airline_accounts` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_type` tinyint NOT NULL COMMENT '1=航司 2=OTA',
  `airline_id` int UNSIGNED NULL DEFAULT NULL COMMENT '航司ID(air_airline.id)',
  `airline_code` char(2) NULL DEFAULT NULL COMMENT '航司2字码(冗余)',
  `platform_id` int UNSIGNED NULL DEFAULT NULL COMMENT 'OTA平台ID(air_platform.id)',
  `account_name` varchar(255) NOT NULL COMMENT '账号名/用户名',
  `account_password` varchar(255) NULL DEFAULT NULL COMMENT '账号密码(AES加密存储)',
  `is_domestic` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支持国内: 0=否 1=是',
  `is_international` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支持国际: 0=否 1=是',
  `purchase_channel` varchar(50) NULL DEFAULT NULL COMMENT '支持采购渠道(如BSP/B2B/BOP/OP)',
  `office_no` varchar(20) NULL DEFAULT NULL COMMENT 'Office号(生编用)',
  `backend_url` varchar(1024) NULL DEFAULT NULL COMMENT '后台地址',
  `remark` varchar(1000) NULL DEFAULT NULL COMMENT '备注',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `tenant_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '所属租户ID(为空=平台级)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_airline_code` (`airline_code`),
  KEY `idx_airline_id` (`airline_id`),
  KEY `idx_account_name` (`account_name`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='航司/OTA采购账号(B2B接口凭证)';

CREATE TABLE IF NOT EXISTS `air_platform` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL COMMENT '平台名称(如IBE+/航班管家/TravelPort)',
  `code` varchar(64) NOT NULL COMMENT '平台编码',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `auth_code` varchar(20) NULL DEFAULT NULL COMMENT '回填票号授权码',
  `config_template` varchar(200) NULL DEFAULT NULL COMMENT '配置模板(JSON)',
  `data_source` varchar(20) NULL DEFAULT NULL COMMENT '数据源标识(IBE/SNSTN等)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购平台(上游数据源配置)';

CREATE TABLE IF NOT EXISTS `air_airline_notice` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `airline_code` char(2) NOT NULL COMMENT '航司2字码',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `content` text NULL COMMENT '内容(富文本/HTML)',
  `external_url` varchar(1024) NULL DEFAULT NULL COMMENT '外部链接(航司官方)',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_airline_code` (`airline_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='航司预定须知/注意事项';

CREATE TABLE IF NOT EXISTS `corporate_policy_rule` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` int UNSIGNED NOT NULL COMMENT '大客户签约ID(corporate_contract.id)',
  `group_id` int UNSIGNED NOT NULL COMMENT '大客户集团ID(corporate_group.id, 冗余便于查询)',
  `airline_code` char(2) NULL DEFAULT NULL COMMENT '航司2字码(空=全部航司)',
  `dep_code` char(3) NULL DEFAULT NULL COMMENT '出发机场(空=全部)',
  `arr_code` char(3) NULL DEFAULT NULL COMMENT '到达机场(空=全部)',
  `cabin_level` varchar(20) NULL DEFAULT NULL COMMENT '舱位等级(如Y/C/F, 空=全部)',
  `discount_min` decimal(5,2) NULL DEFAULT NULL COMMENT '折扣下限(如30.00=3折起)',
  `discount_max` decimal(5,2) NULL DEFAULT NULL COMMENT '折扣上限(如100.00=全价)',
  `trip_type` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '行程类型: 1=单程 2=往返 3=多程(空=全部)',
  `is_domestic` tinyint(1) NULL DEFAULT NULL COMMENT '1=国内 0=国际 NULL=全部',
  `priority` int NOT NULL DEFAULT 100 COMMENT '优先级: 数值越小越优先',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_contract_id` (`contract_id`),
  KEY `idx_airline_route` (`airline_code`,`dep_code`,`arr_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户政策匹配规则(航线/舱位/折扣匹配)';

CREATE TABLE IF NOT EXISTS `corporate_policy_match_log` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` int UNSIGNED NOT NULL COMMENT '签约ID',
  `group_id` int UNSIGNED NOT NULL COMMENT '集团ID',
  `rule_id` int UNSIGNED NULL DEFAULT NULL COMMENT '匹配到的规则ID(未匹配=NULL)',
  `match_type` tinyint UNSIGNED NOT NULL COMMENT '匹配类型: 1=自动下单匹配 2=批量散客匹配',
  `c_user_id` bigint UNSIGNED NOT NULL COMMENT 'C端用户ID',
  `airline_code` char(2) NOT NULL COMMENT '航司2字码',
  `dep_code` char(3) NULL DEFAULT NULL COMMENT '出发机场',
  `arr_code` char(3) NULL DEFAULT NULL COMMENT '到达机场',
  `cabin_code` char(1) NULL DEFAULT NULL COMMENT '舱位代码',
  `discount` decimal(5,2) NULL DEFAULT NULL COMMENT '当前折扣',
  `match_result` enum('matched','not_matched','conflict') NOT NULL COMMENT '匹配结果',
  `match_snapshot` json NULL COMMENT '匹配快照(输入条件+匹配到的规则详情)',
  `order_no` varchar(40) NULL DEFAULT NULL COMMENT '关联订单号(下单匹配时)',
  `apply_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联申报ID(c_member_corporate_apply.id)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_contract_id` (`contract_id`),
  KEY `idx_c_user_id` (`c_user_id`,`airline_code`),
  KEY `idx_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='大客户政策匹配记录(自动匹配+批量匹配日志)';


-- ================================================================
-- 回滚脚本 (如需回滚,取消以下 DROP 语句的注释执行)
-- ================================================================
-- DROP TABLE IF EXISTS c_user;
-- DROP TABLE IF EXISTS c_member;
-- DROP TABLE IF EXISTS c_member_address;
-- DROP TABLE IF EXISTS c_passenger;
-- DROP TABLE IF EXISTS corporate_group;
-- DROP TABLE IF EXISTS corporate_contract;
-- DROP TABLE IF EXISTS corporate_policy;
-- DROP TABLE IF EXISTS c_member_corporate;
-- DROP TABLE IF EXISTS c_member_corporate_apply;
-- DROP TABLE IF EXISTS corporate_whitelist_template;
-- DROP TABLE IF EXISTS corporate_whitelist_batch;
-- DROP TABLE IF EXISTS corporate_whitelist_member;
-- DROP TABLE IF EXISTS `order`;
-- DROP TABLE IF EXISTS `order_sales`;
-- DROP TABLE IF EXISTS `order_procurement`;
-- DROP TABLE IF EXISTS `order_item_flight`;
-- DROP TABLE IF EXISTS `order_item_train`;
-- DROP TABLE IF EXISTS `order_item_hotel`;
-- DROP TABLE IF EXISTS `order_item_mall`;
-- DROP TABLE IF EXISTS `order_procure_item`;
-- DROP TABLE IF EXISTS `order_change`;
-- DROP TABLE IF EXISTS air_airline;
-- DROP TABLE IF EXISTS air_airport;
-- DROP TABLE IF EXISTS air_region;
-- DROP TABLE IF EXISTS air_plane_model;
-- DROP TABLE IF EXISTS air_cabin_level;
-- DROP TABLE IF EXISTS air_cabin;
-- DROP TABLE IF EXISTS air_fuel;
-- DROP TABLE IF EXISTS air_fuel_detail;
-- DROP TABLE IF EXISTS air_gauge_type;
-- DROP TABLE IF EXISTS air_gauge;
-- DROP TABLE IF EXISTS air_airline_accounts;
-- DROP TABLE IF EXISTS air_platform;
-- DROP TABLE IF EXISTS air_airline_notice;
-- DROP TABLE IF EXISTS corporate_policy_rule;
-- DROP TABLE IF EXISTS corporate_policy_match_log;


SET FOREIGN_KEY_CHECKS = 1;
