-- ============================================================
-- 温州华夏航服B2B2C平台 - 基础表结构 (MySQL→PostgreSQL转换)
-- 转换日期: 2026-06-27
-- ============================================================

CREATE TABLE IF NOT EXISTS "air_airline" (

    id BIGSERIAL,
    code CHAR(2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    full_name VARCHAR(200) DEFAULT NULL,
    ticket_code CHAR(3) DEFAULT NULL,
    area VARCHAR(32) NULL DEFAULT 'N',
    logo VARCHAR(255) DEFAULT NULL,
    is_active SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_airline" IS '航司主数据';
COMMENT ON COLUMN "air_airline"."code" IS '航司2字码(IATA)';
COMMENT ON COLUMN "air_airline"."name" IS '航司简称';
COMMENT ON COLUMN "air_airline"."full_name" IS '航司全称';
COMMENT ON COLUMN "air_airline"."ticket_code" IS '开票3字码(IATA)';
COMMENT ON COLUMN "air_airline"."area" IS 'N=国内 I=国际';
COMMENT ON COLUMN "air_airline"."logo" IS 'logo URL';
COMMENT ON COLUMN "air_airline"."is_active" IS '1=启用 0=停用';

CREATE TABLE IF NOT EXISTS "air_airline_accounts" (

    id BIGSERIAL,
    account_type SMALLINT NOT NULL,
    airline_id INTEGER DEFAULT NULL,
    airline_code CHAR(2) DEFAULT NULL,
    platform_id INTEGER DEFAULT NULL,
    account_name VARCHAR(255) NOT NULL,
    account_password VARCHAR(255) DEFAULT NULL,
    is_domestic SMALLINT NOT NULL DEFAULT 0,
    is_international SMALLINT NOT NULL DEFAULT 0,
    purchase_channel VARCHAR(50) DEFAULT NULL,
    office_no VARCHAR(20) DEFAULT NULL,
    backend_url VARCHAR(1024) DEFAULT NULL,
    remark VARCHAR(1000) DEFAULT NULL,
    is_active SMALLINT NOT NULL DEFAULT 1,
    tenant_id BIGINT DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_airline_accounts" IS '航司/OTA采购账号(B2B接口凭证)';
COMMENT ON COLUMN "air_airline_accounts"."account_type" IS '1=航司 2=OTA';
COMMENT ON COLUMN "air_airline_accounts"."airline_id" IS '航司ID(air_airline.id)';
COMMENT ON COLUMN "air_airline_accounts"."airline_code" IS '航司2字码(冗余)';
COMMENT ON COLUMN "air_airline_accounts"."platform_id" IS 'OTA平台ID(air_platform.id)';
COMMENT ON COLUMN "air_airline_accounts"."account_name" IS '账号名/用户名';
COMMENT ON COLUMN "air_airline_accounts"."account_password" IS '账号密码(AES加密存储)';
COMMENT ON COLUMN "air_airline_accounts"."is_domestic" IS '是否支持国内: 0=否 1=是';
COMMENT ON COLUMN "air_airline_accounts"."is_international" IS '是否支持国际: 0=否 1=是';
COMMENT ON COLUMN "air_airline_accounts"."purchase_channel" IS '支持采购渠道(如BSP/B2B/BOP/OP)';
COMMENT ON COLUMN "air_airline_accounts"."office_no" IS 'Office号(生编用)';
COMMENT ON COLUMN "air_airline_accounts"."backend_url" IS '后台地址';
COMMENT ON COLUMN "air_airline_accounts"."remark" IS '备注';
COMMENT ON COLUMN "air_airline_accounts"."is_active" IS '1=启用 0=停用';
COMMENT ON COLUMN "air_airline_accounts"."tenant_id" IS '所属租户ID(为空=平台级)';
CREATE INDEX IF NOT EXISTS "idx_airline_code" ON "air_airline_accounts" (airline_code ASC);
CREATE INDEX IF NOT EXISTS "idx_airline_id" ON "air_airline_accounts" (airline_id ASC);
CREATE INDEX IF NOT EXISTS "idx_account_name" ON "air_airline_accounts" (account_name ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_id" ON "air_airline_accounts" (tenant_id ASC);

CREATE TABLE IF NOT EXISTS "air_airline_notice" (

    id BIGSERIAL,
    airline_code CHAR(2) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NULL,
    external_url VARCHAR(1024) DEFAULT NULL,
    is_active SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_airline_notice" IS '航司预定须知/注意事项';
COMMENT ON COLUMN "air_airline_notice"."airline_code" IS '航司2字码';
COMMENT ON COLUMN "air_airline_notice"."title" IS '标题';
COMMENT ON COLUMN "air_airline_notice"."content" IS '内容(富文本/HTML)';
COMMENT ON COLUMN "air_airline_notice"."external_url" IS '外部链接(航司官方)';
COMMENT ON COLUMN "air_airline_notice"."is_active" IS '1=启用 0=停用';
CREATE INDEX IF NOT EXISTS "idx_airline_code" ON "air_airline_notice" (airline_code ASC);

CREATE TABLE IF NOT EXISTS "air_airport" (

    id BIGSERIAL,
    code CHAR(3) NOT NULL,
    name VARCHAR(80) NOT NULL,
    name_en VARCHAR(100) DEFAULT NULL,
    city_code CHAR(3) DEFAULT NULL,
    city_name VARCHAR(50) DEFAULT NULL,
    city_name_en VARCHAR(50) DEFAULT NULL,
    province VARCHAR(30) DEFAULT NULL,
    country_code CHAR(2) DEFAULT NULL,
    country_name VARCHAR(30) DEFAULT NULL,
    continent VARCHAR(20) DEFAULT NULL,
    is_active SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_airport" IS '机场主数据';
COMMENT ON COLUMN "air_airport"."code" IS '机场3字码(IATA)';
COMMENT ON COLUMN "air_airport"."name" IS '机场中文名';
COMMENT ON COLUMN "air_airport"."name_en" IS '机场英文名';
COMMENT ON COLUMN "air_airport"."city_code" IS '城市3字码';
COMMENT ON COLUMN "air_airport"."city_name" IS '城市中文名';
COMMENT ON COLUMN "air_airport"."city_name_en" IS '城市英文名';
COMMENT ON COLUMN "air_airport"."province" IS '省/州';
COMMENT ON COLUMN "air_airport"."country_code" IS '国家代码(ISO 3166-1 alpha-2)';
COMMENT ON COLUMN "air_airport"."country_name" IS '国家中文名';
COMMENT ON COLUMN "air_airport"."continent" IS '洲';
COMMENT ON COLUMN "air_airport"."is_active" IS '1=启用 0=停用';
CREATE INDEX IF NOT EXISTS "idx_city_code" ON "air_airport" (city_code ASC);
CREATE INDEX IF NOT EXISTS "idx_country_code" ON "air_airport" (country_code ASC);

CREATE TABLE IF NOT EXISTS "air_cabin" (

    id BIGSERIAL,
    cabin_level_id INTEGER NOT NULL,
    airline_code CHAR(2) NOT NULL,
    cabin_code CHAR(1) NOT NULL,
    discount CHAR(5) DEFAULT NULL,
    is_sellable SMALLINT NOT NULL DEFAULT 1,
    is_published SMALLINT NOT NULL DEFAULT 1,
    baggage_override VARCHAR(255) DEFAULT NULL,
    base_agency_fee decimal(8, 2) NULL DEFAULT 0.00,
    sort INTEGER NOT NULL DEFAULT 10,
    effect_start date DEFAULT NULL,
    effect_end date DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_cabin" IS '舱位明细(等级下具体舱位)';
COMMENT ON COLUMN "air_cabin"."cabin_level_id" IS '舱位等级ID';
COMMENT ON COLUMN "air_cabin"."airline_code" IS '航司2字码(冗余,便于查询)';
COMMENT ON COLUMN "air_cabin"."cabin_code" IS '舱位编号(如Y/B/M/K等)';
COMMENT ON COLUMN "air_cabin"."discount" IS '成人折扣(如\"45\"=4.5折)';
COMMENT ON COLUMN "air_cabin"."is_sellable" IS '1=可销售舱位 0=不可销售';
COMMENT ON COLUMN "air_cabin"."is_published" IS '1=公布运价舱位 0=不公布';
COMMENT ON COLUMN "air_cabin"."baggage_override" IS '行李额覆盖(为空则继承等级标准)';
COMMENT ON COLUMN "air_cabin"."base_agency_fee" IS '基础代理费';
COMMENT ON COLUMN "air_cabin"."sort" IS '权重: 越大越靠前';
COMMENT ON COLUMN "air_cabin"."effect_start" IS '生效日期';
COMMENT ON COLUMN "air_cabin"."effect_end" IS '失效日期';
CREATE INDEX IF NOT EXISTS "idx_cabin_level_id" ON "air_cabin" (cabin_level_id ASC);

CREATE TABLE IF NOT EXISTS "air_cabin_level" (

    id BIGSERIAL,
    airline_code CHAR(2) NOT NULL,
    name VARCHAR(50) NOT NULL,
    standard_cabin_code CHAR(1) NOT NULL,
    child_discount decimal(5, 2) DEFAULT NULL,
    infant_discount decimal(5, 2) DEFAULT NULL,
    baggage VARCHAR(255) DEFAULT NULL,
    sort INTEGER NOT NULL DEFAULT 100,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_cabin_level" IS '航司舱位等级';
COMMENT ON COLUMN "air_cabin_level"."airline_code" IS '航司2字码';
COMMENT ON COLUMN "air_cabin_level"."name" IS '舱位等级名称(经济舱/公务舱/头等舱等)';
COMMENT ON COLUMN "air_cabin_level"."standard_cabin_code" IS '标准舱位代码(Y/C/F)';
COMMENT ON COLUMN "air_cabin_level"."child_discount" IS '儿童折扣(如67.00=6.7折)';
COMMENT ON COLUMN "air_cabin_level"."infant_discount" IS '婴儿折扣(如10.00=1折)';
COMMENT ON COLUMN "air_cabin_level"."baggage" IS '标准行李额(如\"20KG\")';
COMMENT ON COLUMN "air_cabin_level"."sort" IS '权重: 越大越靠前';

CREATE TABLE IF NOT EXISTS "air_fuel" (

    id BIGSERIAL,
    airline_code CHAR(2) NOT NULL,
    adult_fuel decimal(10, 2) NOT NULL DEFAULT 0.00,
    child_fuel decimal(10, 2) NULL DEFAULT 0.00,
    infant_fuel decimal(10, 2) NULL DEFAULT 0.00,
    mileage_threshold INTEGER NOT NULL DEFAULT 800,
    adult_fuel_long decimal(10, 2) NULL DEFAULT 0.00,
    child_fuel_long decimal(10, 2) NULL DEFAULT 0.00,
    infant_fuel_long decimal(10, 2) NULL DEFAULT 0.00,
    effect_start date DEFAULT NULL,
    effect_end date DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_fuel" IS '航司燃油费(按里程分档)';
COMMENT ON COLUMN "air_fuel"."airline_code" IS '航司2字码';
COMMENT ON COLUMN "air_fuel"."adult_fuel" IS '成人燃油费(元)';
COMMENT ON COLUMN "air_fuel"."child_fuel" IS '儿童燃油费(元)';
COMMENT ON COLUMN "air_fuel"."infant_fuel" IS '婴儿燃油费(元)';
COMMENT ON COLUMN "air_fuel"."mileage_threshold" IS '里程阈值(KM): 超过此值用另一档';
COMMENT ON COLUMN "air_fuel"."adult_fuel_long" IS '成人燃油费-长航线(元)';
COMMENT ON COLUMN "air_fuel"."child_fuel_long" IS '儿童燃油费-长航线(元)';
COMMENT ON COLUMN "air_fuel"."infant_fuel_long" IS '婴儿燃油费-长航线(元)';
COMMENT ON COLUMN "air_fuel"."effect_start" IS '生效日期';
COMMENT ON COLUMN "air_fuel"."effect_end" IS '失效日期';
CREATE INDEX IF NOT EXISTS "idx_airline_effect" ON "air_fuel" (airline_code ASC, effect_start ASC, effect_end ASC);

CREATE TABLE IF NOT EXISTS "air_fuel_detail" (

    id BIGSERIAL,
    airline_code CHAR(2) NOT NULL,
    dep_code CHAR(3) NOT NULL,
    arr_code CHAR(3) NOT NULL,
    mileage INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_fuel_detail" IS '航程里程(航司×出发×到达)';
COMMENT ON COLUMN "air_fuel_detail"."airline_code" IS '航司2字码';
COMMENT ON COLUMN "air_fuel_detail"."dep_code" IS '出发机场3字码';
COMMENT ON COLUMN "air_fuel_detail"."arr_code" IS '到达机场3字码';
COMMENT ON COLUMN "air_fuel_detail"."mileage" IS '里程(KM)';

CREATE TABLE IF NOT EXISTS "air_gauge" (

    id BIGSERIAL,
    airline_code CHAR(2) NOT NULL,
    cabin_codes VARCHAR(255) DEFAULT NULL,
    gauge_type_id INTEGER NOT NULL,
    effect_start TIMESTAMP DEFAULT NULL,
    effect_end TIMESTAMP DEFAULT NULL,
    discount_scope VARCHAR(100) DEFAULT NULL,
    fee_rate json NULL,
    refund_desc VARCHAR(1024) DEFAULT NULL,
    change_desc VARCHAR(255) DEFAULT NULL,
    is_noshow SMALLINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_gauge" IS '客规(退改签规则)';
COMMENT ON COLUMN "air_gauge"."airline_code" IS '航司2字码';
COMMENT ON COLUMN "air_gauge"."cabin_codes" IS '适用舱位编号集合(逗号分隔, 空=全部)';
COMMENT ON COLUMN "air_gauge"."gauge_type_id" IS '客规时间段类型ID';
COMMENT ON COLUMN "air_gauge"."effect_start" IS '生效时间';
COMMENT ON COLUMN "air_gauge"."effect_end" IS '失效时间';
COMMENT ON COLUMN "air_gauge"."discount_scope" IS '折扣范围(如\"1-3折/4折以上\")';
COMMENT ON COLUMN "air_gauge"."fee_rate" IS '退改费率集合({refund_rate,change_rate,format})';
COMMENT ON COLUMN "air_gauge"."refund_desc" IS '退票说明';
COMMENT ON COLUMN "air_gauge"."change_desc" IS '签转规定';
COMMENT ON COLUMN "air_gauge"."is_noshow" IS '是否为noshow规则';
CREATE INDEX IF NOT EXISTS "idx_airline_cabin" ON "air_gauge" (airline_code ASC, gauge_type_id ASC);

CREATE TABLE IF NOT EXISTS "air_gauge_type" (

    id BIGSERIAL,
    airline_code CHAR(2) NOT NULL,
    change_type SMALLINT NOT NULL,
    hours_before INTEGER DEFAULT NULL,
    hours_before_inclusive SMALLINT NOT NULL DEFAULT 0,
    hours_after INTEGER DEFAULT NULL,
    hours_after_inclusive SMALLINT NOT NULL DEFAULT 1,
    sort INTEGER NOT NULL DEFAULT 10,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_gauge_type" IS '客规时间段类型(退/改的时段定义)';
COMMENT ON COLUMN "air_gauge_type"."airline_code" IS '航司2字码';
COMMENT ON COLUMN "air_gauge_type"."change_type" IS '1=退票 2=改签';
COMMENT ON COLUMN "air_gauge_type"."hours_before" IS '航班离站前N小时';
COMMENT ON COLUMN "air_gauge_type"."hours_before_inclusive" IS 'hours_before是否包含(0=不包含 1=包含)';
COMMENT ON COLUMN "air_gauge_type"."hours_after" IS '航班离站后N小时';
COMMENT ON COLUMN "air_gauge_type"."hours_after_inclusive" IS 'hours_after是否包含(0=不包含 1=包含)';
COMMENT ON COLUMN "air_gauge_type"."sort" IS '排序: 越小越优先匹配';
CREATE INDEX IF NOT EXISTS "idx_airline_type" ON "air_gauge_type" (airline_code ASC, change_type ASC);

CREATE TABLE IF NOT EXISTS "air_plane_model" (

    id BIGSERIAL,
    code CHAR(10) NOT NULL,
    manufacturer VARCHAR(30) DEFAULT NULL,
    build_fee decimal(10, 2) NULL DEFAULT 0.00,
    is_active SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_plane_model" IS '机型数据(含机建费)';
COMMENT ON COLUMN "air_plane_model"."code" IS '机型代码(如738/A320)';
COMMENT ON COLUMN "air_plane_model"."manufacturer" IS '生产厂家(Boeing/Airbus/COMAC等)';
COMMENT ON COLUMN "air_plane_model"."build_fee" IS '机建费(元)';
COMMENT ON COLUMN "air_plane_model"."is_active" IS '1=启用 0=停用';

CREATE TABLE IF NOT EXISTS "air_platform" (

    id BIGSERIAL,
    name VARCHAR(64) NOT NULL,
    code VARCHAR(64) NOT NULL,
    is_active SMALLINT NOT NULL DEFAULT 1,
    auth_code VARCHAR(20) DEFAULT NULL,
    config_template VARCHAR(200) DEFAULT NULL,
    data_source VARCHAR(20) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_platform" IS '采购平台(上游数据源配置)';
COMMENT ON COLUMN "air_platform"."name" IS '平台名称(如IBE+/航班管家/TravelPort)';
COMMENT ON COLUMN "air_platform"."code" IS '平台编码';
COMMENT ON COLUMN "air_platform"."is_active" IS '1=启用 0=停用';
COMMENT ON COLUMN "air_platform"."auth_code" IS '回填票号授权码';
COMMENT ON COLUMN "air_platform"."config_template" IS '配置模板(JSON)';
COMMENT ON COLUMN "air_platform"."data_source" IS '数据源标识(IBE/SNSTN等)';

CREATE TABLE IF NOT EXISTS "air_region" (

    id BIGSERIAL,
    code VARCHAR(12) NOT NULL,
    name VARCHAR(32) NOT NULL,
    level SMALLINT NOT NULL,
    parent_code VARCHAR(12) DEFAULT NULL,
    province_code VARCHAR(12) DEFAULT NULL,
    city_iata_code CHAR(3) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "air_region" IS '行政区划(省/市/区三级)';
COMMENT ON COLUMN "air_region"."code" IS '行政区划代码';
COMMENT ON COLUMN "air_region"."name" IS '名称';
COMMENT ON COLUMN "air_region"."level" IS '层级: 1=省/直辖市 2=市 3=区县';
COMMENT ON COLUMN "air_region"."parent_code" IS '父级行政区划代码';
COMMENT ON COLUMN "air_region"."province_code" IS '顶级(省)行政区划代码';
COMMENT ON COLUMN "air_region"."city_iata_code" IS '城市3字码(关联air_airport.city_code)';
CREATE INDEX IF NOT EXISTS "idx_parent_code" ON "air_region" (parent_code ASC);
CREATE INDEX IF NOT EXISTS "idx_province_code" ON "air_region" (province_code ASC);

CREATE TABLE IF NOT EXISTS "attachment" (

    id BIGSERIAL,
    storage_mode VARCHAR(20) NOT NULL DEFAULT 'local',
    origin_name VARCHAR(255) DEFAULT NULL,
    object_name VARCHAR(50) DEFAULT NULL,
    hash VARCHAR(64) DEFAULT NULL,
    mime_type VARCHAR(255) DEFAULT NULL,
    storage_path VARCHAR(100) DEFAULT NULL,
    suffix VARCHAR(20) DEFAULT NULL,
    size_byte BIGINT DEFAULT NULL,
    size_info VARCHAR(50) DEFAULT NULL,
    url VARCHAR(255) DEFAULT NULL,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "attachment" IS '上传文件信息表';
COMMENT ON COLUMN "attachment"."id" IS '主键';
COMMENT ON COLUMN "attachment"."storage_mode" IS '存储模式:local=本地,oss=阿里云,qiniu=七牛云,cos=腾讯云';
COMMENT ON COLUMN "attachment"."origin_name" IS '原文件名';
COMMENT ON COLUMN "attachment"."object_name" IS '新文件名';
COMMENT ON COLUMN "attachment"."hash" IS '文件hash';
COMMENT ON COLUMN "attachment"."mime_type" IS '资源类型';
COMMENT ON COLUMN "attachment"."storage_path" IS '存储目录';
COMMENT ON COLUMN "attachment"."suffix" IS '文件后缀';
COMMENT ON COLUMN "attachment"."size_byte" IS '字节数';
COMMENT ON COLUMN "attachment"."size_info" IS '文件大小';
COMMENT ON COLUMN "attachment"."url" IS 'url地址';
COMMENT ON COLUMN "attachment"."created_by" IS '创建者';
COMMENT ON COLUMN "attachment"."updated_by" IS '更新者';
COMMENT ON COLUMN "attachment"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "attachment_storage_path_index" ON "attachment" (storage_path ASC);

CREATE TABLE IF NOT EXISTS "c_member" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    member_no VARCHAR(20) NOT NULL,
    nickname VARCHAR(50) NULL DEFAULT '',
    avatar VARCHAR(500) NULL DEFAULT '',
    level SMALLINT NULL DEFAULT 1,
    points_balance INTEGER NULL DEFAULT 0,
    points_version INTEGER NOT NULL DEFAULT 0,
    grade_id BIGINT DEFAULT NULL,
    total_earned_points INTEGER NOT NULL DEFAULT 0,
    wallet_balance decimal(12, 2) NULL DEFAULT 0.00,
    balance_version INTEGER NOT NULL DEFAULT 0,
    total_spent decimal(12, 2) NULL DEFAULT 0.00,
    order_count INTEGER NULL DEFAULT 0,
    sign_count INTEGER NULL DEFAULT 0,
    last_sign_date date DEFAULT NULL,
    source VARCHAR(20) NULL DEFAULT 'mini',
    status SMALLINT NULL DEFAULT 1,
    remark VARCHAR(255) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_member" IS 'C端会员(商户维度隔离)';
COMMENT ON COLUMN "c_member"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "c_member"."user_id" IS 'c_user.id';
COMMENT ON COLUMN "c_member"."member_no" IS '会员号(商户内唯一)';
COMMENT ON COLUMN "c_member"."nickname" IS '会员昵称';
COMMENT ON COLUMN "c_member"."avatar" IS '会员头像(可不同于c_user默认)';
COMMENT ON COLUMN "c_member"."level" IS '会员等级: 1=普通,2=银卡,3=金卡,4=钻石';
COMMENT ON COLUMN "c_member"."points_balance" IS '积分余额';
COMMENT ON COLUMN "c_member"."points_version" IS '积分版本号(乐观锁,每次积分变更+1)';
COMMENT ON COLUMN "c_member"."grade_id" IS '会员等级 c_member_grade.id';
COMMENT ON COLUMN "c_member"."total_earned_points" IS '累计获取积分(用于等级判定,不减)';
COMMENT ON COLUMN "c_member"."wallet_balance" IS '钱包余额';
COMMENT ON COLUMN "c_member"."balance_version" IS '余额版本号(乐观锁,每次余额变更+1)';
COMMENT ON COLUMN "c_member"."total_spent" IS '累计消费金额(升级依据)';
COMMENT ON COLUMN "c_member"."order_count" IS '累计订单数';
COMMENT ON COLUMN "c_member"."sign_count" IS '连续签到天数';
COMMENT ON COLUMN "c_member"."last_sign_date" IS '最后签到日期';
COMMENT ON COLUMN "c_member"."source" IS '注册来源: mini/web/h5/app/ota';
COMMENT ON COLUMN "c_member"."status" IS '1=正常,2=冻结,3=注销';
CREATE INDEX IF NOT EXISTS "idx_tenant_user" ON "c_member" (tenant_id ASC, user_id ASC);
CREATE INDEX IF NOT EXISTS "idx_user" ON "c_member" (user_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_level" ON "c_member" (tenant_id ASC, level ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "c_member" (tenant_id ASC, status ASC);

CREATE TABLE IF NOT EXISTS "c_member_address" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    receiver_name VARCHAR(30) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    province VARCHAR(20) NOT NULL,
    city VARCHAR(20) NOT NULL,
    district VARCHAR(20) NOT NULL,
    address VARCHAR(200) NOT NULL,
    is_default SMALLINT NULL DEFAULT 2,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_member_address" IS '会员收货地址';
COMMENT ON COLUMN "c_member_address"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "c_member_address"."member_id" IS 'c_member.id';
COMMENT ON COLUMN "c_member_address"."receiver_name" IS '收件人姓名';
COMMENT ON COLUMN "c_member_address"."receiver_phone" IS '收件人手机';
COMMENT ON COLUMN "c_member_address"."province" IS '省';
COMMENT ON COLUMN "c_member_address"."city" IS '市';
COMMENT ON COLUMN "c_member_address"."district" IS '区/县';
COMMENT ON COLUMN "c_member_address"."address" IS '详细地址';
COMMENT ON COLUMN "c_member_address"."is_default" IS '1=默认,2=非默认';
CREATE INDEX IF NOT EXISTS "idx_tenant_member" ON "c_member_address" (tenant_id ASC, member_id ASC);

CREATE TABLE IF NOT EXISTS "c_member_balance_log" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    amount decimal(12, 2) NOT NULL,
    before_balance decimal(12, 2) NOT NULL,
    after_balance decimal(12, 2) NOT NULL,
    version INTEGER NOT NULL,
    biz_type VARCHAR(20) NULL DEFAULT '',
    biz_id VARCHAR(64) NULL DEFAULT '0',
    operator_type VARCHAR(20) NULL DEFAULT '',
    operator_id BIGINT NULL DEFAULT 0,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_member_balance_log" IS '会员余额变更日志(版本控制+乐观锁)';
COMMENT ON COLUMN "c_member_balance_log"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "c_member_balance_log"."member_id" IS 'c_member.id';
COMMENT ON COLUMN "c_member_balance_log"."change_type" IS '变更类型: recharge=充值/payment=消费/refund=退款/withdraw=提现/gift=赠送/adjust=调整/freeze=冻结/unfreeze=解冻';
COMMENT ON COLUMN "c_member_balance_log"."amount" IS '变更金额(正=增加,负=减少)';
COMMENT ON COLUMN "c_member_balance_log"."before_balance" IS '变更前余额';
COMMENT ON COLUMN "c_member_balance_log"."after_balance" IS '变更后余额';
COMMENT ON COLUMN "c_member_balance_log"."version" IS '余额版本号(乐观锁,每次变更+1)';
COMMENT ON COLUMN "c_member_balance_log"."biz_type" IS '关联业务: order/refund/coupon/manual';
COMMENT ON COLUMN "c_member_balance_log"."biz_id" IS '关联业务ID(订单号/退款单号等)';
COMMENT ON COLUMN "c_member_balance_log"."operator_type" IS '操作人类型: member/admin/system';
COMMENT ON COLUMN "c_member_balance_log"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "c_member_balance_log"."remark" IS '备注';
COMMENT ON COLUMN "c_member_balance_log"."created_at" IS '变更时间';
CREATE INDEX IF NOT EXISTS "idx_member" ON "c_member_balance_log" (member_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_type" ON "c_member_balance_log" (tenant_id ASC, change_type ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_biz" ON "c_member_balance_log" (biz_type ASC, biz_id ASC);

CREATE TABLE IF NOT EXISTS "c_member_corporate" (

    id BIGSERIAL,
    user_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    airline_code CHAR(2) NOT NULL,
    group_id BIGINT NOT NULL,
    contract_id BIGINT NOT NULL,
    corp_member_no VARCHAR(50) NULL DEFAULT '',
    corp_type VARCHAR(20) NULL DEFAULT 'enterprise',
    status SMALLINT NOT NULL DEFAULT 1,
    source VARCHAR(20) NULL DEFAULT 'auto',
    policy_id BIGINT NULL DEFAULT 0,
    apply_id BIGINT NULL DEFAULT 0,
    activated_at TIMESTAMP DEFAULT NULL,
    expire_at TIMESTAMP DEFAULT NULL,
    exited_at TIMESTAMP DEFAULT NULL,
    exit_reason VARCHAR(200) NULL DEFAULT '',
    penalty_note VARCHAR(500) NULL DEFAULT '',
    uk_guard VARCHAR(60) GENERATED ALWAYS AS (if((status = 1),concat(user_id,_utf8mb4'-',airline_code),NULL)) STORED NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_member_corporate" IS '大客户成员身份(平台级,同航司唯一)';
COMMENT ON COLUMN "c_member_corporate"."user_id" IS 'c_user.id(平台级自然人)';
COMMENT ON COLUMN "c_member_corporate"."tenant_id" IS '申报商户ID(哪个商户提交的申报)';
COMMENT ON COLUMN "c_member_corporate"."member_id" IS 'c_member.id(冗余,商户维度查询)';
COMMENT ON COLUMN "c_member_corporate"."airline_code" IS '航司二字码';
COMMENT ON COLUMN "c_member_corporate"."group_id" IS 'corporate_group.id(所属集团)';
COMMENT ON COLUMN "c_member_corporate"."contract_id" IS 'corporate_contract.id(所属签约关系)';
COMMENT ON COLUMN "c_member_corporate"."corp_member_no" IS '大客户成员编号(航司分配或按规则生成)';
COMMENT ON COLUMN "c_member_corporate"."corp_type" IS 'enterprise/gp';
COMMENT ON COLUMN "c_member_corporate"."status" IS '1=有效,2=已退出,3=已过期,4=处罚冻结';
COMMENT ON COLUMN "c_member_corporate"."source" IS 'auto=平台自动申报,manual=人工申报';
COMMENT ON COLUMN "c_member_corporate"."policy_id" IS '触发自动申报的政策ID';
COMMENT ON COLUMN "c_member_corporate"."apply_id" IS '最近一次生效的申报记录ID';
COMMENT ON COLUMN "c_member_corporate"."activated_at" IS '身份生效时间';
COMMENT ON COLUMN "c_member_corporate"."expire_at" IS '身份过期时间(协议到期/资格到期)';
COMMENT ON COLUMN "c_member_corporate"."exited_at" IS '退出时间';
COMMENT ON COLUMN "c_member_corporate"."exit_reason" IS '退出原因';
COMMENT ON COLUMN "c_member_corporate"."penalty_note" IS '处罚备注(如: 同一航司重复申报被航司处罚)';
COMMENT ON COLUMN "c_member_corporate"."uk_guard" IS '部分唯一约束守卫列(仅status=1时参与唯一校验)';
CREATE INDEX IF NOT EXISTS "idx_tenant_member" ON "c_member_corporate" (tenant_id ASC, member_id ASC);
CREATE INDEX IF NOT EXISTS "idx_contract" ON "c_member_corporate" (contract_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "c_member_corporate" (group_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_user_airline" ON "c_member_corporate" (user_id ASC, airline_code ASC, status ASC);

CREATE TABLE IF NOT EXISTS "c_member_corporate_apply" (

    id BIGSERIAL,
    apply_no VARCHAR(40) NOT NULL,
    user_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    airline_code CHAR(2) NOT NULL,
    group_id BIGINT NOT NULL,
    contract_id BIGINT NOT NULL,
    corp_member_no VARCHAR(50) NULL DEFAULT '',
    submit_method VARCHAR(20) NOT NULL,
    submit_status SMALLINT NOT NULL DEFAULT 1,
    submit_at TIMESTAMP DEFAULT NULL,
    batch_no VARCHAR(40) NULL DEFAULT '',
    file_id BIGINT NULL DEFAULT 0,
    api_request json NULL,
    api_response json NULL,
    review_note VARCHAR(500) NULL DEFAULT '',
    reviewed_at TIMESTAMP DEFAULT NULL,
    corporate_id_result BIGINT NULL DEFAULT 0,
    apply_source VARCHAR(20) NULL DEFAULT 'auto',
    policy_id BIGINT NULL DEFAULT 0,
    conflict_check json NULL,
    fail_reason VARCHAR(500) NULL DEFAULT '',
    retry_count SMALLINT NULL DEFAULT 0,
    next_retry_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    uk_guard VARCHAR(60) GENERATED ALWAYS AS (if((submit_status in (1,2,3)),concat(user_id,_utf8mb4'-',airline_code),NULL)) STORED NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_member_corporate_apply" IS '大客户成员申报记录(全量审计)';
COMMENT ON COLUMN "c_member_corporate_apply"."apply_no" IS '申报单号';
COMMENT ON COLUMN "c_member_corporate_apply"."user_id" IS 'c_user.id';
COMMENT ON COLUMN "c_member_corporate_apply"."tenant_id" IS '申报商户ID';
COMMENT ON COLUMN "c_member_corporate_apply"."member_id" IS 'c_member.id';
COMMENT ON COLUMN "c_member_corporate_apply"."airline_code" IS '航司二字码';
COMMENT ON COLUMN "c_member_corporate_apply"."group_id" IS 'corporate_group.id(目标集团)';
COMMENT ON COLUMN "c_member_corporate_apply"."contract_id" IS 'corporate_contract.id(目标签约关系)';
COMMENT ON COLUMN "c_member_corporate_apply"."corp_member_no" IS '生成的大客户成员编号';
COMMENT ON COLUMN "c_member_corporate_apply"."submit_method" IS 'api/file';
COMMENT ON COLUMN "c_member_corporate_apply"."submit_status" IS '1=待提交,2=已提交,3=审核中,4=已通过,5=已拒绝,6=已撤回,7=提交失败';
COMMENT ON COLUMN "c_member_corporate_apply"."submit_at" IS '提交时间(向航司/供应商提交)';
COMMENT ON COLUMN "c_member_corporate_apply"."batch_no" IS '批量提交批次号(file方式用)';
COMMENT ON COLUMN "c_member_corporate_apply"."file_id" IS '上传文件ID(file方式,attachment.id)';
COMMENT ON COLUMN "c_member_corporate_apply"."api_request" IS 'API请求报文快照';
COMMENT ON COLUMN "c_member_corporate_apply"."api_response" IS 'API响应报文快照';
COMMENT ON COLUMN "c_member_corporate_apply"."review_note" IS '审核备注/拒绝原因';
COMMENT ON COLUMN "c_member_corporate_apply"."reviewed_at" IS '审核时间';
COMMENT ON COLUMN "c_member_corporate_apply"."corporate_id_result" IS '审核通过后写入 c_member_corporate.id';
COMMENT ON COLUMN "c_member_corporate_apply"."apply_source" IS 'auto=平台自动/manual=人工';
COMMENT ON COLUMN "c_member_corporate_apply"."policy_id" IS '触发的自动申报政策ID';
COMMENT ON COLUMN "c_member_corporate_apply"."conflict_check" IS '申报前冲突检测结果快照';
COMMENT ON COLUMN "c_member_corporate_apply"."fail_reason" IS '提交/审核失败原因';
COMMENT ON COLUMN "c_member_corporate_apply"."retry_count" IS '重试次数';
COMMENT ON COLUMN "c_member_corporate_apply"."next_retry_at" IS '下次重试时间';
COMMENT ON COLUMN "c_member_corporate_apply"."uk_guard" IS '部分唯一约束守卫列(防止重复提交待审核申报)';
CREATE INDEX IF NOT EXISTS "idx_user_airline" ON "c_member_corporate_apply" (user_id ASC, airline_code ASC, submit_status ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_member" ON "c_member_corporate_apply" (tenant_id ASC, member_id ASC);
CREATE INDEX IF NOT EXISTS "idx_contract" ON "c_member_corporate_apply" (contract_id ASC, submit_status ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "c_member_corporate_apply" (group_id ASC);
CREATE INDEX IF NOT EXISTS "idx_batch" ON "c_member_corporate_apply" (batch_no ASC);
CREATE INDEX IF NOT EXISTS "idx_status_retry" ON "c_member_corporate_apply" (submit_status ASC, next_retry_at ASC);

CREATE TABLE IF NOT EXISTS "c_member_grade" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    grade_code VARCHAR(20) NOT NULL,
    grade_name VARCHAR(30) NOT NULL,
    level SMALLINT NOT NULL DEFAULT 0,
    min_points INTEGER NOT NULL DEFAULT 0,
    max_points INTEGER DEFAULT NULL,
    discount_rate decimal(3, 2) NULL DEFAULT 1.00,
    points_earn_rate decimal(5, 2) NULL DEFAULT 1.00,
    free_upgrade_flight SMALLINT NOT NULL DEFAULT 2,
    free_lounge SMALLINT NOT NULL DEFAULT 2,
    priority_boarding SMALLINT NOT NULL DEFAULT 2,
    extra_baggage SMALLINT NULL DEFAULT 0,
    benefits_desc VARCHAR(1000) NULL DEFAULT '',
    icon VARCHAR(255) NULL DEFAULT '',
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_member_grade" IS '会员等级定义(按商户自定义)';
COMMENT ON COLUMN "c_member_grade"."tenant_id" IS '商户ID(0=平台通用)';
COMMENT ON COLUMN "c_member_grade"."grade_code" IS '等级编码(如: normal/silver/gold/platinum/diamond)';
COMMENT ON COLUMN "c_member_grade"."grade_name" IS '等级名称(如: 普通/银卡/金卡/白金/钻石)';
COMMENT ON COLUMN "c_member_grade"."level" IS '等级排序(数值越大等级越高)';
COMMENT ON COLUMN "c_member_grade"."min_points" IS '升级所需积分(累计获取积分)';
COMMENT ON COLUMN "c_member_grade"."max_points" IS '上限积分(NULL=无上限, 下一等级min_points-1)';
COMMENT ON COLUMN "c_member_grade"."discount_rate" IS '折扣率(如: 0.95=95折, 1.00=无折扣)';
COMMENT ON COLUMN "c_member_grade"."points_earn_rate" IS '积分获取倍率(如: 1.5=1.5倍积分)';
COMMENT ON COLUMN "c_member_grade"."free_upgrade_flight" IS '免费升舱权益: 1=有,2=无';
COMMENT ON COLUMN "c_member_grade"."free_lounge" IS '贵宾休息室: 1=有,2=无';
COMMENT ON COLUMN "c_member_grade"."priority_boarding" IS '优先登机: 1=有,2=无';
COMMENT ON COLUMN "c_member_grade"."extra_baggage" IS '额外行李额(KG, 0=无)';
COMMENT ON COLUMN "c_member_grade"."benefits_desc" IS '权益描述(JSON: 其他自定义权益)';
COMMENT ON COLUMN "c_member_grade"."icon" IS '等级图标URL';
COMMENT ON COLUMN "c_member_grade"."status" IS '1=启用,2=停用';
CREATE INDEX IF NOT EXISTS "idx_tenant_level" ON "c_member_grade" (tenant_id ASC, level ASC);

CREATE TABLE IF NOT EXISTS "c_member_points_log" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    points INTEGER NOT NULL,
    before_points INTEGER NOT NULL,
    after_points INTEGER NOT NULL,
    version INTEGER NOT NULL,
    biz_type VARCHAR(20) NULL DEFAULT '',
    biz_id VARCHAR(64) NULL DEFAULT '0',
    points_value decimal(12, 2) NULL DEFAULT 0.00,
    expire_at TIMESTAMP DEFAULT NULL,
    operator_type VARCHAR(20) NULL DEFAULT '',
    operator_id BIGINT NULL DEFAULT 0,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_member_points_log" IS '会员积分变更日志(版本控制+过期追踪)';
COMMENT ON COLUMN "c_member_points_log"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "c_member_points_log"."member_id" IS 'c_member.id';
COMMENT ON COLUMN "c_member_points_log"."change_type" IS '变更类型: earn=获取(消费返)/consume=消耗(积分抵扣)/expire=过期/gift=赠送/adjust=调整';
COMMENT ON COLUMN "c_member_points_log"."points" IS '变更积分数(正=增加,负=减少)';
COMMENT ON COLUMN "c_member_points_log"."before_points" IS '变更前积分';
COMMENT ON COLUMN "c_member_points_log"."after_points" IS '变更后积分';
COMMENT ON COLUMN "c_member_points_log"."version" IS '积分版本号(乐观锁,每次变更+1)';
COMMENT ON COLUMN "c_member_points_log"."biz_type" IS '关联业务: order/refund/manual/activity';
COMMENT ON COLUMN "c_member_points_log"."biz_id" IS '关联业务ID';
COMMENT ON COLUMN "c_member_points_log"."points_value" IS '积分等值金额(1积分=N分,用于兑换时)';
COMMENT ON COLUMN "c_member_points_log"."expire_at" IS '积分过期时间(获取时计算)';
COMMENT ON COLUMN "c_member_points_log"."operator_type" IS '操作人类型: member/admin/system/cron';
COMMENT ON COLUMN "c_member_points_log"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "c_member_points_log"."remark" IS '备注';
COMMENT ON COLUMN "c_member_points_log"."created_at" IS '变更时间';
CREATE INDEX IF NOT EXISTS "idx_member" ON "c_member_points_log" (member_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_type" ON "c_member_points_log" (tenant_id ASC, change_type ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_expire" ON "c_member_points_log" (expire_at ASC);

CREATE TABLE IF NOT EXISTS "c_passenger" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    name VARCHAR(30) DEFAULT NULL,
    name_encrypted varbinary(255) DEFAULT NULL,
    name_hash CHAR(64) DEFAULT NULL,
    id_type SMALLINT NOT NULL,
    id_number VARCHAR(30) DEFAULT NULL,
    id_number_encrypted varbinary(255) DEFAULT NULL,
    id_number_hash CHAR(64) DEFAULT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    phone_encrypted varbinary(255) DEFAULT NULL,
    phone_hash CHAR(64) DEFAULT NULL,
    nationality VARCHAR(20) NULL DEFAULT 'CN',
    birthday date DEFAULT NULL,
    gender SMALLINT NULL DEFAULT 0,
    is_self SMALLINT NULL DEFAULT 2,
    is_default SMALLINT NULL DEFAULT 2,
    flight_count INTEGER NULL DEFAULT 0,
    train_count INTEGER NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_passenger" IS '常用旅客(商户会员维度)';
COMMENT ON COLUMN "c_passenger"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "c_passenger"."member_id" IS 'c_member.id';
COMMENT ON COLUMN "c_passenger"."name" IS '姓名(脱敏)';
COMMENT ON COLUMN "c_passenger"."name_encrypted" IS '姓名密文';
COMMENT ON COLUMN "c_passenger"."name_hash" IS '姓名HMAC';
COMMENT ON COLUMN "c_passenger"."id_type" IS '证件类型: 1=身份证,2=护照,3=港澳通行证,4=台胞证,5=其他';
COMMENT ON COLUMN "c_passenger"."id_number" IS '证件号(脱敏)';
COMMENT ON COLUMN "c_passenger"."id_number_encrypted" IS '证件号密文';
COMMENT ON COLUMN "c_passenger"."id_number_hash" IS '证件号HMAC';
COMMENT ON COLUMN "c_passenger"."phone" IS '手机号(脱敏)';
COMMENT ON COLUMN "c_passenger"."phone_encrypted" IS '手机号密文';
COMMENT ON COLUMN "c_passenger"."phone_hash" IS '手机号HMAC';
COMMENT ON COLUMN "c_passenger"."nationality" IS '国籍/地区码';
COMMENT ON COLUMN "c_passenger"."birthday" IS '出生日期';
COMMENT ON COLUMN "c_passenger"."gender" IS '0=未知,1=男,2=女';
COMMENT ON COLUMN "c_passenger"."is_self" IS '1=本人,2=他人';
COMMENT ON COLUMN "c_passenger"."is_default" IS '1=默认,2=非默认';
COMMENT ON COLUMN "c_passenger"."flight_count" IS '乘机次数(排序依据)';
COMMENT ON COLUMN "c_passenger"."train_count" IS '乘车次数';
CREATE INDEX IF NOT EXISTS "idx_tenant_member" ON "c_passenger" (tenant_id ASC, member_id ASC);
CREATE INDEX IF NOT EXISTS "idx_phone_hash" ON "c_passenger" (phone_hash ASC);
CREATE INDEX IF NOT EXISTS "idx_name_hash" ON "c_passenger" (name_hash ASC);

CREATE TABLE IF NOT EXISTS "c_user" (

    id BIGSERIAL,
    phone VARCHAR(20) NOT NULL,
    phone_encrypted varbinary(255) NOT NULL,
    phone_hash CHAR(64) NOT NULL,
    real_name VARCHAR(30) DEFAULT NULL,
    real_name_encrypted varbinary(255) DEFAULT NULL,
    real_name_hash CHAR(64) DEFAULT NULL,
    id_type SMALLINT DEFAULT NULL,
    id_number VARCHAR(30) DEFAULT NULL,
    id_number_encrypted varbinary(255) DEFAULT NULL,
    id_number_hash CHAR(64) DEFAULT NULL,
    union_id VARCHAR(100) NULL DEFAULT '',
    avatar VARCHAR(500) NULL DEFAULT '',
    gender SMALLINT NULL DEFAULT 0,
    birthday date DEFAULT NULL,
    status SMALLINT NULL DEFAULT 1,
    last_login_at TIMESTAMP DEFAULT NULL,
    last_login_ip VARCHAR(45) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "c_user" IS 'C端自然人(平台级,全局唯一)';
COMMENT ON COLUMN "c_user"."id" IS '自然人ID';
COMMENT ON COLUMN "c_user"."phone" IS '手机号(脱敏: 138****8888)';
COMMENT ON COLUMN "c_user"."phone_encrypted" IS '手机号密文(AES-256-GCM)';
COMMENT ON COLUMN "c_user"."phone_hash" IS '手机号HMAC-SHA256(精确查找+唯一)';
COMMENT ON COLUMN "c_user"."real_name" IS '真实姓名(脱敏: 张*明)';
COMMENT ON COLUMN "c_user"."real_name_encrypted" IS '真实姓名密文';
COMMENT ON COLUMN "c_user"."real_name_hash" IS '真实姓名HMAC';
COMMENT ON COLUMN "c_user"."id_type" IS '证件类型: 1=身份证,2=护照,3=港澳通行证,4=台胞证,5=其他';
COMMENT ON COLUMN "c_user"."id_number" IS '证件号(脱敏: 310***********1234)';
COMMENT ON COLUMN "c_user"."id_number_encrypted" IS '证件号密文';
COMMENT ON COLUMN "c_user"."id_number_hash" IS '证件号HMAC(跨商户唯一校验)';
COMMENT ON COLUMN "c_user"."union_id" IS '微信UnionID(跨小程序关联同一自然人)';
COMMENT ON COLUMN "c_user"."avatar" IS '默认头像';
COMMENT ON COLUMN "c_user"."gender" IS '0=未知,1=男,2=女';
COMMENT ON COLUMN "c_user"."birthday" IS '出生日期';
COMMENT ON COLUMN "c_user"."status" IS '1=正常,2=冻结,3=注销';
COMMENT ON COLUMN "c_user"."last_login_at" IS '最后登录时间';
COMMENT ON COLUMN "c_user"."last_login_ip" IS '最后登录IP';
CREATE INDEX IF NOT EXISTS "idx_union_id" ON "c_user" (union_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "c_user" (status ASC);
CREATE INDEX IF NOT EXISTS "idx_real_name_hash" ON "c_user" (real_name_hash ASC);

CREATE TABLE IF NOT EXISTS "corporate_contract" (

    id BIGSERIAL,
    group_id BIGINT NOT NULL,
    airline_code VARCHAR(10) NOT NULL,
    contract_no VARCHAR(50) NULL DEFAULT '',
    corp_type VARCHAR(20) NULL DEFAULT 'enterprise',
    is_realname SMALLINT NOT NULL DEFAULT 1,
    age_min SMALLINT NULL DEFAULT 0,
    age_max SMALLINT NULL DEFAULT 0,
    multi_idcard SMALLINT NULL DEFAULT 0,
    pre_cmd_domestic VARCHAR(200) NULL DEFAULT '',
    pre_cmd_intl VARCHAR(200) NULL DEFAULT '',
    price_cmd_domestic VARCHAR(200) NULL DEFAULT '',
    price_cmd_intl VARCHAR(200) NULL DEFAULT '',
    biz_scope VARCHAR(20) NULL DEFAULT 'both',
    discount_info VARCHAR(200) NULL DEFAULT '',
    travel_target VARCHAR(100) NULL DEFAULT '',
    exclude_dates json NULL,
    submit_methods VARCHAR(50) NOT NULL,
    api_config json NULL,
    whitelist_tpl_id BIGINT NULL DEFAULT 0,
    submit_cycle VARCHAR(20) NULL DEFAULT 'realtime',
    review_days SMALLINT NULL DEFAULT 0,
    protocol_start date DEFAULT NULL,
    protocol_end date DEFAULT NULL,
    current_start date DEFAULT NULL,
    current_end date DEFAULT NULL,
    corp_code_rule VARCHAR(100) NULL DEFAULT '',
    status SMALLINT NULL DEFAULT 1,
    remark VARCHAR(500) NULL DEFAULT '',
    created_by BIGINT NULL DEFAULT 0,
    updated_by BIGINT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "corporate_contract" IS '大客户签约关系(集团×航司,航司特定配置)';
COMMENT ON COLUMN "corporate_contract"."group_id" IS 'corporate_group.id';
COMMENT ON COLUMN "corporate_contract"."airline_code" IS '签约航司二字码(如: CA)';
COMMENT ON COLUMN "corporate_contract"."contract_no" IS '大客户协议编号';
COMMENT ON COLUMN "corporate_contract"."corp_type" IS 'enterprise=企业大客户/gp=公务员';
COMMENT ON COLUMN "corporate_contract"."is_realname" IS '1=实名制(需白名单),0=非实名(年龄范围内即可)';
COMMENT ON COLUMN "corporate_contract"."age_min" IS '非实名最小年龄(0=不限, 如: 20)';
COMMENT ON COLUMN "corporate_contract"."age_max" IS '非实名最大年龄(0=不限, 如: 65)';
COMMENT ON COLUMN "corporate_contract"."multi_idcard" IS '1=支持多证件上报(如CZ多证件模板),0=单证件';
COMMENT ON COLUMN "corporate_contract"."pre_cmd_domestic" IS '国内出票前置指令(如: RMK IC CZ/2602342)';
COMMENT ON COLUMN "corporate_contract"."pre_cmd_intl" IS '国际出票前置指令(如: SSR CKIN CA HK1 VICO0WN10FTG)';
COMMENT ON COLUMN "corporate_contract"."price_cmd_domestic" IS '国内运价指令(如: PAT:A#CDK2602342)';
COMMENT ON COLUMN "corporate_contract"."price_cmd_intl" IS '国际运价指令(如: QTE:/CZ///#CV2602342)';
COMMENT ON COLUMN "corporate_contract"."biz_scope" IS 'domestic=仅国内/intl=仅国际/both=国内+国际';
COMMENT ON COLUMN "corporate_contract"."discount_info" IS '优惠信息摘要(如: 经济舱95折/公务舱9折/无优惠送里程)';
COMMENT ON COLUMN "corporate_contract"."travel_target" IS '差旅指标(如: 20万/年)';
COMMENT ON COLUMN "corporate_contract"."exclude_dates" IS '不适用日期规则(JSON数组)';
COMMENT ON COLUMN "corporate_contract"."submit_methods" IS '支持的申报方式: api/file/api+file';
COMMENT ON COLUMN "corporate_contract"."api_config" IS 'API申报配置(接口地址/认证方式/报文格式)';
COMMENT ON COLUMN "corporate_contract"."whitelist_tpl_id" IS '白名单模板ID(corporate_whitelist_template.id)';
COMMENT ON COLUMN "corporate_contract"."submit_cycle" IS '申报周期: realtime/daily/weekly/monthly';
COMMENT ON COLUMN "corporate_contract"."review_days" IS '预估审核天数(0=实时)';
COMMENT ON COLUMN "corporate_contract"."protocol_start" IS '协议开始日期(如: 2023-10-10)';
COMMENT ON COLUMN "corporate_contract"."protocol_end" IS '协议结束日期(如: 2026-12-31)';
COMMENT ON COLUMN "corporate_contract"."current_start" IS '当前有效期开始(如: 2023-10-10,每年续签会更新)';
COMMENT ON COLUMN "corporate_contract"."current_end" IS '当前有效期结束(如: 2024-10-10)';
COMMENT ON COLUMN "corporate_contract"."corp_code_rule" IS '大客户员工编号生成规则(如: {airline}-{group}-{seq})';
COMMENT ON COLUMN "corporate_contract"."status" IS '1=有效,2=暂停,3=已过期';
CREATE INDEX IF NOT EXISTS "idx_airline_status" ON "corporate_contract" (airline_code ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_corp_type" ON "corporate_contract" (corp_type ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_realname" ON "corporate_contract" (is_realname ASC, status ASC);

CREATE TABLE IF NOT EXISTS "corporate_group" (

    id BIGSERIAL,
    group_name VARCHAR(100) NOT NULL,
    group_code VARCHAR(50) NOT NULL,
    unified_social_credit VARCHAR(20) NULL DEFAULT '',
    contact_name VARCHAR(30) NULL DEFAULT '',
    contact_phone VARCHAR(20) NULL DEFAULT '',
    address VARCHAR(300) NULL DEFAULT '',
    industry VARCHAR(30) NULL DEFAULT '',
    scale VARCHAR(20) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    status SMALLINT NULL DEFAULT 1,
    created_by BIGINT NULL DEFAULT 0,
    updated_by BIGINT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "corporate_group" IS '大客户集团主体(平台级,一个集团可跨航司签约)';
COMMENT ON COLUMN "corporate_group"."group_name" IS '大客户集团名称(如: 华为技术有限公司)';
COMMENT ON COLUMN "corporate_group"."group_code" IS '集团编码(唯一标识,如: HUAWEI)';
COMMENT ON COLUMN "corporate_group"."unified_social_credit" IS '统一社会信用代码(企业唯一标识)';
COMMENT ON COLUMN "corporate_group"."contact_name" IS '集团联系人';
COMMENT ON COLUMN "corporate_group"."contact_phone" IS '集团联系电话';
COMMENT ON COLUMN "corporate_group"."address" IS '集团地址';
COMMENT ON COLUMN "corporate_group"."industry" IS '行业分类(如: 通信/互联网/金融)';
COMMENT ON COLUMN "corporate_group"."scale" IS '企业规模(如: 万人以上/千人/百人)';
COMMENT ON COLUMN "corporate_group"."remark" IS '备注';
COMMENT ON COLUMN "corporate_group"."status" IS '1=有效,2=停用';
CREATE INDEX IF NOT EXISTS "idx_status" ON "corporate_group" (status ASC);

CREATE TABLE IF NOT EXISTS "corporate_policy" (

    id BIGSERIAL,
    policy_name VARCHAR(100) NOT NULL,
    policy_code VARCHAR(50) NOT NULL,
    airline_code VARCHAR(10) NOT NULL,
    group_id BIGINT NOT NULL,
    contract_id BIGINT NOT NULL,
    conditions json NOT NULL,
    priority SMALLINT NULL DEFAULT 0,
    auto_submit SMALLINT NULL DEFAULT 1,
    status SMALLINT NULL DEFAULT 1,
    created_by BIGINT NULL DEFAULT 0,
    updated_by BIGINT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "corporate_policy" IS '大客户自动申报政策';
COMMENT ON COLUMN "corporate_policy"."policy_name" IS '政策名称(如: CA航司华北散客自动申报华为)';
COMMENT ON COLUMN "corporate_policy"."policy_code" IS '政策编码(唯一)';
COMMENT ON COLUMN "corporate_policy"."airline_code" IS '适用航司';
COMMENT ON COLUMN "corporate_policy"."group_id" IS 'corporate_group.id(目标集团)';
COMMENT ON COLUMN "corporate_policy"."contract_id" IS 'corporate_contract.id(目标签约关系)';
COMMENT ON COLUMN "corporate_policy"."conditions" IS '申报条件(航线/舱位/消费金额/航班次数等)';
COMMENT ON COLUMN "corporate_policy"."priority" IS '优先级(数值越大越高,同航司多政策时取最高)';
COMMENT ON COLUMN "corporate_policy"."auto_submit" IS '1=匹配后自动提交申报,2=仅提示需人工确认';
COMMENT ON COLUMN "corporate_policy"."status" IS '1=启用,2=停用';
CREATE INDEX IF NOT EXISTS "idx_airline_status" ON "corporate_policy" (airline_code ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_contract" ON "corporate_policy" (contract_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "corporate_policy" (group_id ASC);

CREATE TABLE IF NOT EXISTS "corporate_policy_match_log" (

    id BIGSERIAL,
    contract_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    rule_id INTEGER DEFAULT NULL,
    match_type SMALLINT NOT NULL,
    c_user_id BIGINT NOT NULL,
    airline_code CHAR(2) NOT NULL,
    dep_code CHAR(3) DEFAULT NULL,
    arr_code CHAR(3) DEFAULT NULL,
    cabin_code CHAR(1) DEFAULT NULL,
    discount decimal(5, 2) DEFAULT NULL,
    match_result VARCHAR(32) NOT NULL,
    match_snapshot json NULL,
    order_no VARCHAR(40) DEFAULT NULL,
    apply_id BIGINT DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "corporate_policy_match_log" IS '大客户政策匹配记录(自动匹配+批量匹配日志)';
COMMENT ON COLUMN "corporate_policy_match_log"."contract_id" IS '签约ID';
COMMENT ON COLUMN "corporate_policy_match_log"."group_id" IS '集团ID';
COMMENT ON COLUMN "corporate_policy_match_log"."rule_id" IS '匹配到的规则ID(未匹配=NULL)';
COMMENT ON COLUMN "corporate_policy_match_log"."match_type" IS '匹配类型: 1=自动下单匹配 2=批量散客匹配';
COMMENT ON COLUMN "corporate_policy_match_log"."c_user_id" IS 'C端用户ID';
COMMENT ON COLUMN "corporate_policy_match_log"."airline_code" IS '航司2字码';
COMMENT ON COLUMN "corporate_policy_match_log"."dep_code" IS '出发机场';
COMMENT ON COLUMN "corporate_policy_match_log"."arr_code" IS '到达机场';
COMMENT ON COLUMN "corporate_policy_match_log"."cabin_code" IS '舱位代码';
COMMENT ON COLUMN "corporate_policy_match_log"."discount" IS '当前折扣';
COMMENT ON COLUMN "corporate_policy_match_log"."match_result" IS '匹配结果';
COMMENT ON COLUMN "corporate_policy_match_log"."match_snapshot" IS '匹配快照(输入条件+匹配到的规则详情)';
COMMENT ON COLUMN "corporate_policy_match_log"."order_no" IS '关联订单号(下单匹配时)';
COMMENT ON COLUMN "corporate_policy_match_log"."apply_id" IS '关联申报ID(c_member_corporate_apply.id)';
CREATE INDEX IF NOT EXISTS "idx_contract_id" ON "corporate_policy_match_log" (contract_id ASC);
CREATE INDEX IF NOT EXISTS "idx_c_user_id" ON "corporate_policy_match_log" (c_user_id ASC, airline_code ASC);
CREATE INDEX IF NOT EXISTS "idx_order_no" ON "corporate_policy_match_log" (order_no ASC);

CREATE TABLE IF NOT EXISTS "corporate_policy_rule" (

    id BIGSERIAL,
    contract_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    airline_code CHAR(2) DEFAULT NULL,
    dep_code CHAR(3) DEFAULT NULL,
    arr_code CHAR(3) DEFAULT NULL,
    cabin_level VARCHAR(20) DEFAULT NULL,
    discount_min decimal(5, 2) DEFAULT NULL,
    discount_max decimal(5, 2) DEFAULT NULL,
    trip_type SMALLINT DEFAULT NULL,
    is_domestic SMALLINT DEFAULT NULL,
    priority INTEGER NOT NULL DEFAULT 100,
    is_active SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "corporate_policy_rule" IS '大客户政策匹配规则(航线/舱位/折扣匹配)';
COMMENT ON COLUMN "corporate_policy_rule"."contract_id" IS '大客户签约ID';
COMMENT ON COLUMN "corporate_policy_rule"."group_id" IS '大客户集团ID';
COMMENT ON COLUMN "corporate_policy_rule"."airline_code" IS '航司2字码(空=全部航司)';
COMMENT ON COLUMN "corporate_policy_rule"."dep_code" IS '出发机场(空=全部)';
COMMENT ON COLUMN "corporate_policy_rule"."arr_code" IS '到达机场(空=全部)';
COMMENT ON COLUMN "corporate_policy_rule"."cabin_level" IS '舱位等级(如Y/C/F, 空=全部)';
COMMENT ON COLUMN "corporate_policy_rule"."discount_min" IS '折扣下限(如30.00=3折起)';
COMMENT ON COLUMN "corporate_policy_rule"."discount_max" IS '折扣上限(如100.00=全价)';
COMMENT ON COLUMN "corporate_policy_rule"."trip_type" IS '行程类型: 1=单程 2=往返 3=多程(空=全部)';
COMMENT ON COLUMN "corporate_policy_rule"."is_domestic" IS '1=国内 0=国际 NULL=全部';
COMMENT ON COLUMN "corporate_policy_rule"."priority" IS '优先级: 数值越小越优先';
COMMENT ON COLUMN "corporate_policy_rule"."is_active" IS '1=启用 0=停用';
CREATE INDEX IF NOT EXISTS "idx_contract_id" ON "corporate_policy_rule" (contract_id ASC);
CREATE INDEX IF NOT EXISTS "idx_airline_route" ON "corporate_policy_rule" (airline_code ASC, dep_code ASC, arr_code ASC);

CREATE TABLE IF NOT EXISTS "corporate_whitelist_batch" (

    id BIGSERIAL,
    batch_no VARCHAR(40) NOT NULL,
    contract_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    airline_code CHAR(2) NOT NULL,
    template_id BIGINT NULL DEFAULT 0,
    submit_method VARCHAR(20) NOT NULL,
    action_type CHAR(1) NULL DEFAULT 'A',
    total_count INTEGER NOT NULL DEFAULT 0,
    success_count INTEGER NOT NULL DEFAULT 0,
    fail_count INTEGER NOT NULL DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    file_id BIGINT NULL DEFAULT 0,
    file_original_name VARCHAR(255) NULL DEFAULT '',
    api_request json NULL,
    api_response json NULL,
    submit_at TIMESTAMP DEFAULT NULL,
    finished_at TIMESTAMP DEFAULT NULL,
    review_note VARCHAR(500) NULL DEFAULT '',
    operator_id BIGINT NULL DEFAULT 0,
    operator_name VARCHAR(50) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "corporate_whitelist_batch" IS '白名单提交批次(一次提交=一个批次)';
COMMENT ON COLUMN "corporate_whitelist_batch"."batch_no" IS '批次号(如: WL20250701123456)';
COMMENT ON COLUMN "corporate_whitelist_batch"."contract_id" IS '签约关系ID(corporate_contract.id)';
COMMENT ON COLUMN "corporate_whitelist_batch"."group_id" IS '集团ID(corporate_group.id)';
COMMENT ON COLUMN "corporate_whitelist_batch"."airline_code" IS '航司二字码(冗余)';
COMMENT ON COLUMN "corporate_whitelist_batch"."template_id" IS '使用的模板ID(corporate_whitelist_template.id)';
COMMENT ON COLUMN "corporate_whitelist_batch"."submit_method" IS 'api/file';
COMMENT ON COLUMN "corporate_whitelist_batch"."action_type" IS 'A=新增,D=删除,U=更新';
COMMENT ON COLUMN "corporate_whitelist_batch"."total_count" IS '总条数';
COMMENT ON COLUMN "corporate_whitelist_batch"."success_count" IS '成功条数';
COMMENT ON COLUMN "corporate_whitelist_batch"."fail_count" IS '失败条数';
COMMENT ON COLUMN "corporate_whitelist_batch"."status" IS '1=待提交,2=提交中,3=部分成功,4=全部成功,5=全部失败,6=已撤回';
COMMENT ON COLUMN "corporate_whitelist_batch"."file_id" IS '上传文件ID(file方式,attachment.id)';
COMMENT ON COLUMN "corporate_whitelist_batch"."file_original_name" IS '原始文件名';
COMMENT ON COLUMN "corporate_whitelist_batch"."api_request" IS 'API请求报文快照';
COMMENT ON COLUMN "corporate_whitelist_batch"."api_response" IS 'API响应报文快照';
COMMENT ON COLUMN "corporate_whitelist_batch"."submit_at" IS '提交时间';
COMMENT ON COLUMN "corporate_whitelist_batch"."finished_at" IS '处理完成时间';
COMMENT ON COLUMN "corporate_whitelist_batch"."review_note" IS '审核/处理备注';
COMMENT ON COLUMN "corporate_whitelist_batch"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "corporate_whitelist_batch"."operator_name" IS '操作人姓名(冗余)';
CREATE INDEX IF NOT EXISTS "idx_contract" ON "corporate_whitelist_batch" (contract_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_airline_status" ON "corporate_whitelist_batch" (airline_code ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_created" ON "corporate_whitelist_batch" (created_at ASC);

CREATE TABLE IF NOT EXISTS "corporate_whitelist_member" (

    id BIGSERIAL,
    batch_id BIGINT NOT NULL,
    contract_id BIGINT NOT NULL,
    airline_code CHAR(2) NOT NULL,
    line_no INTEGER NOT NULL DEFAULT 0,
    action CHAR(1) NULL DEFAULT 'A',
    name_cn VARCHAR(50) NULL DEFAULT '',
    name_en VARCHAR(80) NULL DEFAULT '',
    last_name_en VARCHAR(40) NULL DEFAULT '',
    first_name_en VARCHAR(40) NULL DEFAULT '',
    id_type VARCHAR(10) NULL DEFAULT '',
    id_number VARCHAR(50) NULL DEFAULT '',
    id_number_2_type VARCHAR(10) NULL DEFAULT '',
    id_number_2 VARCHAR(50) NULL DEFAULT '',
    id_number_3_type VARCHAR(10) NULL DEFAULT '',
    id_number_3 VARCHAR(50) NULL DEFAULT '',
    birthday date DEFAULT NULL,
    gender CHAR(1) NULL DEFAULT '',
    mobile VARCHAR(20) NULL DEFAULT '',
    corp_member_code VARCHAR(50) NULL DEFAULT '',
    employee_type VARCHAR(20) NULL DEFAULT '',
    expiry_date date DEFAULT NULL,
    extra_fields json NULL,
    user_id BIGINT NULL DEFAULT 0,
    member_id BIGINT NULL DEFAULT 0,
    passenger_id BIGINT NULL DEFAULT 0,
    match_status SMALLINT NULL DEFAULT 0,
    match_log VARCHAR(500) NULL DEFAULT '',
    submit_status SMALLINT NULL DEFAULT 1,
    submit_error VARCHAR(500) NULL DEFAULT '',
    corporate_member_id BIGINT NULL DEFAULT 0,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "corporate_whitelist_member" IS '白名单成员明细(航司视角名单数据)';
COMMENT ON COLUMN "corporate_whitelist_member"."batch_id" IS '批次ID(corporate_whitelist_batch.id)';
COMMENT ON COLUMN "corporate_whitelist_member"."contract_id" IS '签约关系ID(冗余)';
COMMENT ON COLUMN "corporate_whitelist_member"."airline_code" IS '航司二字码(冗余)';
COMMENT ON COLUMN "corporate_whitelist_member"."line_no" IS '原始行号(文件导入时)';
COMMENT ON COLUMN "corporate_whitelist_member"."action" IS 'A=新增,D=删除';
COMMENT ON COLUMN "corporate_whitelist_member"."name_cn" IS '中文姓名';
COMMENT ON COLUMN "corporate_whitelist_member"."name_en" IS '英文姓名(姓/名拼接后)';
COMMENT ON COLUMN "corporate_whitelist_member"."last_name_en" IS '英文姓';
COMMENT ON COLUMN "corporate_whitelist_member"."first_name_en" IS '英文名';
COMMENT ON COLUMN "corporate_whitelist_member"."id_type" IS '证件类型(NI=身份证/PP=护照/HX=回乡证/HY=海员证/TW=台胞证/OTHER=其他)';
COMMENT ON COLUMN "corporate_whitelist_member"."id_number" IS '证件号码';
COMMENT ON COLUMN "corporate_whitelist_member"."id_number_2_type" IS '第二证件类型';
COMMENT ON COLUMN "corporate_whitelist_member"."id_number_2" IS '第二证件号码(如CZ多证件模式)';
COMMENT ON COLUMN "corporate_whitelist_member"."id_number_3_type" IS '第三证件类型';
COMMENT ON COLUMN "corporate_whitelist_member"."id_number_3" IS '第三证件号码';
COMMENT ON COLUMN "corporate_whitelist_member"."birthday" IS '出生日期';
COMMENT ON COLUMN "corporate_whitelist_member"."gender" IS 'M=男/F=女';
COMMENT ON COLUMN "corporate_whitelist_member"."mobile" IS '手机号码(CA国航要求)';
COMMENT ON COLUMN "corporate_whitelist_member"."corp_member_code" IS '大客户成员编码(3U川航/企业卡号等)';
COMMENT ON COLUMN "corporate_whitelist_member"."employee_type" IS '员工类型(CA国航: 普通管理员/管理员/领导)';
COMMENT ON COLUMN "corporate_whitelist_member"."expiry_date" IS '协议截止日期(3U川航要求)';
COMMENT ON COLUMN "corporate_whitelist_member"."extra_fields" IS '模板扩展字段(航司特有字段)';
COMMENT ON COLUMN "corporate_whitelist_member"."user_id" IS '关联c_user.id(匹配后回填)';
COMMENT ON COLUMN "corporate_whitelist_member"."member_id" IS '关联c_member.id(匹配后回填)';
COMMENT ON COLUMN "corporate_whitelist_member"."passenger_id" IS '关联c_passenger.id(匹配后回填)';
COMMENT ON COLUMN "corporate_whitelist_member"."match_status" IS '0=未匹配,1=已匹配,2=多人匹配需人工,3=匹配失败';
COMMENT ON COLUMN "corporate_whitelist_member"."match_log" IS '匹配日志';
COMMENT ON COLUMN "corporate_whitelist_member"."submit_status" IS '1=待提交,2=已提交,3=已通过,4=已拒绝,5=提交失败';
COMMENT ON COLUMN "corporate_whitelist_member"."submit_error" IS '提交/审核失败原因';
COMMENT ON COLUMN "corporate_whitelist_member"."corporate_member_id" IS '审核通过后写入 c_member_corporate.id';
CREATE INDEX IF NOT EXISTS "idx_batch" ON "corporate_whitelist_member" (batch_id ASC, submit_status ASC);
CREATE INDEX IF NOT EXISTS "idx_contract" ON "corporate_whitelist_member" (contract_id ASC, action ASC);
CREATE INDEX IF NOT EXISTS "idx_id_number" ON "corporate_whitelist_member" (id_type ASC, id_number ASC);
CREATE INDEX IF NOT EXISTS "idx_user" ON "corporate_whitelist_member" (user_id ASC, airline_code ASC);
CREATE INDEX IF NOT EXISTS "idx_match" ON "corporate_whitelist_member" (match_status ASC);

CREATE TABLE IF NOT EXISTS "corporate_whitelist_template" (

    id BIGSERIAL,
    airline_code CHAR(2) NOT NULL,
    template_name VARCHAR(100) NOT NULL,
    template_code VARCHAR(50) NOT NULL,
    field_config json NOT NULL,
    sample_row json NULL,
    max_rows_per_batch INTEGER NULL DEFAULT 5000,
    supported_actions VARCHAR(50) NULL DEFAULT 'A,D',
    encoding VARCHAR(20) NULL DEFAULT 'UTF-8',
    file_format VARCHAR(10) NULL DEFAULT 'xlsx',
    submit_method VARCHAR(30) NOT NULL DEFAULT 'file',
    api_endpoint VARCHAR(500) NULL DEFAULT '',
    api_config json NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    is_active SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "corporate_whitelist_template" IS '航司白名单导入模板(各航司格式不同)';
COMMENT ON COLUMN "corporate_whitelist_template"."airline_code" IS '航司二字码';
COMMENT ON COLUMN "corporate_whitelist_template"."template_name" IS '模板名称(如: CZ单证件白名单/CZ多证件白名单/3U白名单)';
COMMENT ON COLUMN "corporate_whitelist_template"."template_code" IS '模板编码(如: CZ_SINGLE_ID/CZ_MULTI_ID/3U_STANDARD)';
COMMENT ON COLUMN "corporate_whitelist_template"."field_config" IS '字段配置(JSON,定义每个字段的名称/类型/必填/校验规则)';
COMMENT ON COLUMN "corporate_whitelist_template"."sample_row" IS '示例行数据(供前端展示/下载模板)';
COMMENT ON COLUMN "corporate_whitelist_template"."max_rows_per_batch" IS '单次最大导入行数';
COMMENT ON COLUMN "corporate_whitelist_template"."supported_actions" IS '支持的操作类型: A=新增,D=删除,U=更新';
COMMENT ON COLUMN "corporate_whitelist_template"."encoding" IS '文件编码要求';
COMMENT ON COLUMN "corporate_whitelist_template"."file_format" IS '文件格式: xlsx/csv/txt';
COMMENT ON COLUMN "corporate_whitelist_template"."submit_method" IS '提交方式: api/file/both';
COMMENT ON COLUMN "corporate_whitelist_template"."api_endpoint" IS 'API提交地址(如航司提供)';
COMMENT ON COLUMN "corporate_whitelist_template"."api_config" IS 'API鉴权/请求格式配置';
COMMENT ON COLUMN "corporate_whitelist_template"."remark" IS '模板说明/注意事项';
COMMENT ON COLUMN "corporate_whitelist_template"."is_active" IS '1=启用,0=停用';
CREATE INDEX IF NOT EXISTS "idx_airline" ON "corporate_whitelist_template" (airline_code ASC, is_active ASC);

CREATE TABLE IF NOT EXISTS "data_permission_policy" (

    id BIGSERIAL,
    platform VARCHAR(20) NOT NULL DEFAULT 'pmc',
    tenant_id BIGINT NOT NULL DEFAULT 0,
    user_id BIGINT NOT NULL DEFAULT 0,
    position_id BIGINT NOT NULL DEFAULT 0,
    role_id BIGINT NOT NULL DEFAULT 0,
    policy_type VARCHAR(20) NOT NULL,
    resource VARCHAR(50) NOT NULL DEFAULT '',
    is_default SMALLINT NOT NULL DEFAULT 1,
    value json NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "data_permission_policy" IS '数据权限策略';
COMMENT ON COLUMN "data_permission_policy"."platform" IS '所属端:pmc/tmc/mmc';
COMMENT ON COLUMN "data_permission_policy"."tenant_id" IS '租户ID,saas端=0';
COMMENT ON COLUMN "data_permission_policy"."user_id" IS '用户ID（与角色二选一）';
COMMENT ON COLUMN "data_permission_policy"."position_id" IS '岗位ID（与用户二选一）';
COMMENT ON COLUMN "data_permission_policy"."role_id" IS '角色ID(user/position/role 三选一)';
COMMENT ON COLUMN "data_permission_policy"."policy_type" IS '策略类型（DEPT_SELF, DEPT_TREE, ALL, SELF, CUSTOM_DEPT, CUSTOM_FUNC）';
COMMENT ON COLUMN "data_permission_policy"."resource" IS '作用资源:order/customer/...';
COMMENT ON COLUMN "data_permission_policy"."is_default" IS '是否默认策略（默认值：true）';
COMMENT ON COLUMN "data_permission_policy"."value" IS '策略值';
CREATE INDEX IF NOT EXISTS "idx_subject" ON "data_permission_policy" (platform ASC, tenant_id ASC, user_id ASC, role_id ASC, position_id ASC);
CREATE INDEX IF NOT EXISTS "idx_resource" ON "data_permission_policy" (platform ASC, tenant_id ASC, resource ASC);

CREATE TABLE IF NOT EXISTS "finance_company_account" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    account_no VARCHAR(30) NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    group_id BIGINT NOT NULL,
    group_name VARCHAR(200) NULL DEFAULT '',
    account_type VARCHAR(20) NOT NULL,
    credit_limit decimal(14, 2) NULL DEFAULT 0.00,
    credit_used decimal(14, 2) NULL DEFAULT 0.00,
    credit_available decimal(14, 2) NULL DEFAULT 0.00,
    balance decimal(14, 2) NOT NULL DEFAULT 0.00,
    frozen_amount decimal(14, 2) NULL DEFAULT 0.00,
    settle_period VARCHAR(20) NULL DEFAULT 'MONTHLY',
    settle_day SMALLINT DEFAULT NULL,
    overdue_grace_days SMALLINT NULL DEFAULT 7,
    account_status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    open_at TIMESTAMP DEFAULT NULL,
    last_settle_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_company_account" IS '企业结算账户';
COMMENT ON COLUMN "finance_company_account"."tenant_id" IS '商户ID(TMC)';
COMMENT ON COLUMN "finance_company_account"."account_no" IS '账户编号(如: FA20250701001)';
COMMENT ON COLUMN "finance_company_account"."account_name" IS '账户名称(如: 华夏航空-华为POC)';
COMMENT ON COLUMN "finance_company_account"."group_id" IS '企业集团ID corporate_group.id';
COMMENT ON COLUMN "finance_company_account"."group_name" IS '企业名称(冗余)';
COMMENT ON COLUMN "finance_company_account"."account_type" IS '账户类型: PREPAID=预存/CREDIT=信用/MIXED=混合';
COMMENT ON COLUMN "finance_company_account"."credit_limit" IS '授信额度(account_type=CREDIT/MIXED时有效)';
COMMENT ON COLUMN "finance_company_account"."credit_used" IS '已用额度';
COMMENT ON COLUMN "finance_company_account"."credit_available" IS '可用额度';
COMMENT ON COLUMN "finance_company_account"."balance" IS '账户余额(预存部分)';
COMMENT ON COLUMN "finance_company_account"."frozen_amount" IS '冻结金额(在途订单占用)';
COMMENT ON COLUMN "finance_company_account"."settle_period" IS '结算周期: REALTIME/WEEKLY/BIWEEKLY/MONTHLY';
COMMENT ON COLUMN "finance_company_account"."settle_day" IS '结算日(周期为月结时,每月几号,如: 15)';
COMMENT ON COLUMN "finance_company_account"."overdue_grace_days" IS '逾期宽限天数';
COMMENT ON COLUMN "finance_company_account"."account_status" IS '账户状态: AVAILABLE/DISABLED/FROZEN/CLOSED';
COMMENT ON COLUMN "finance_company_account"."open_at" IS '开户时间';
COMMENT ON COLUMN "finance_company_account"."last_settle_at" IS '最近结算时间';
COMMENT ON COLUMN "finance_company_account"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_group" ON "finance_company_account" (group_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "finance_company_account" (account_status ASC);

CREATE TABLE IF NOT EXISTS "finance_company_account_log" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    account_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    change_type VARCHAR(30) NOT NULL,
    amount decimal(14, 2) NOT NULL,
    balance_before decimal(14, 2) NOT NULL,
    balance_after decimal(14, 2) NOT NULL,
    related_biz_type VARCHAR(30) NULL DEFAULT '',
    related_biz_id VARCHAR(64) NULL DEFAULT '',
    operator_id BIGINT NULL DEFAULT 0,
    operator_name VARCHAR(30) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_company_account_log" IS '企业账户流水';
COMMENT ON COLUMN "finance_company_account_log"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "finance_company_account_log"."account_id" IS '企业结算账户ID';
COMMENT ON COLUMN "finance_company_account_log"."group_id" IS '企业集团ID';
COMMENT ON COLUMN "finance_company_account_log"."change_type" IS '变动类型: RECHARGE=充值/CONSUME=消费/REFUND=退款回充/FREEZE=冻结/UNFREEZE=解冻/ADJUST=调整/CREDIT_RELEASE=信用释放';
COMMENT ON COLUMN "finance_company_account_log"."amount" IS '变动金额(正=增,负=减)';
COMMENT ON COLUMN "finance_company_account_log"."balance_before" IS '变动前余额';
COMMENT ON COLUMN "finance_company_account_log"."balance_after" IS '变动后余额';
COMMENT ON COLUMN "finance_company_account_log"."related_biz_type" IS '关联业务类型: order/payment/bill/adjust';
COMMENT ON COLUMN "finance_company_account_log"."related_biz_id" IS '关联业务ID';
COMMENT ON COLUMN "finance_company_account_log"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "finance_company_account_log"."operator_name" IS '操作人姓名';
COMMENT ON COLUMN "finance_company_account_log"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_account" ON "finance_company_account_log" (account_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "finance_company_account_log" (group_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_type" ON "finance_company_account_log" (tenant_id ASC, change_type ASC, created_at ASC);

CREATE TABLE IF NOT EXISTS "finance_company_bill" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    bill_no VARCHAR(40) NOT NULL,
    account_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    group_name VARCHAR(200) NULL DEFAULT '',
    period_start date NOT NULL,
    period_end date NOT NULL,
    bill_type VARCHAR(20) NOT NULL DEFAULT 'NORMAL',
    bill_category VARCHAR(20) NOT NULL DEFAULT 'NORMAL',
    total_amount decimal(14, 2) NOT NULL,
    paid_amount decimal(14, 2) NULL DEFAULT 0.00,
    outstanding_amount decimal(14, 2) NULL DEFAULT 0.00,
    overdue_date date DEFAULT NULL,
    bill_status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    invoice_status VARCHAR(20) NOT NULL DEFAULT 'NOT_INVOICED',
    reconciliation_status VARCHAR(20) NOT NULL DEFAULT 'UNRECONCILED',
    adjustment_type VARCHAR(20) NULL DEFAULT '',
    settle_user_id BIGINT NULL DEFAULT 0,
    settle_user_name VARCHAR(50) NULL DEFAULT '',
    confirm_at TIMESTAMP DEFAULT NULL,
    sent_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_company_bill" IS '企业账单(销售侧)';
COMMENT ON COLUMN "finance_company_bill"."tenant_id" IS '商户ID(TMC)';
COMMENT ON COLUMN "finance_company_bill"."bill_no" IS '账单编号(如: B2026032300001)';
COMMENT ON COLUMN "finance_company_bill"."account_id" IS '企业结算账户ID';
COMMENT ON COLUMN "finance_company_bill"."group_id" IS '企业集团ID';
COMMENT ON COLUMN "finance_company_bill"."group_name" IS '企业名称(冗余)';
COMMENT ON COLUMN "finance_company_bill"."period_start" IS '结算期间开始';
COMMENT ON COLUMN "finance_company_bill"."period_end" IS '结算期间结束';
COMMENT ON COLUMN "finance_company_bill"."bill_type" IS '账单类型: NORMAL=正常/ADJUSTMENT=调整/CREDIT_NOTE=贷项通知单/DEBIT_NOTE=借项通知单';
COMMENT ON COLUMN "finance_company_bill"."bill_category" IS '账单分类: NORMAL=正常/ADJUSTMENT=调整';
COMMENT ON COLUMN "finance_company_bill"."total_amount" IS '账单总金额';
COMMENT ON COLUMN "finance_company_bill"."paid_amount" IS '已付金额';
COMMENT ON COLUMN "finance_company_bill"."outstanding_amount" IS '未付金额';
COMMENT ON COLUMN "finance_company_bill"."overdue_date" IS '逾期日期';
COMMENT ON COLUMN "finance_company_bill"."bill_status" IS '账单状态: DRAFT/PENDING/CONFIRMED/SENT/OVERDUE/PARTIAL_PAID/PAID/CANCELLED';
COMMENT ON COLUMN "finance_company_bill"."invoice_status" IS '开票状态: NOT_INVOICED/INVOICED/PARTIAL_INVOICED';
COMMENT ON COLUMN "finance_company_bill"."reconciliation_status" IS '清账状态: UNRECONCILED/PARTIAL_RECONCILED/RECONCILED';
COMMENT ON COLUMN "finance_company_bill"."adjustment_type" IS '调整项类型: DISCOUNT/CHARGE/OTHER';
COMMENT ON COLUMN "finance_company_bill"."settle_user_id" IS '结算员ID';
COMMENT ON COLUMN "finance_company_bill"."settle_user_name" IS '结算员姓名';
COMMENT ON COLUMN "finance_company_bill"."confirm_at" IS '确认时间';
COMMENT ON COLUMN "finance_company_bill"."sent_at" IS '发送时间';
COMMENT ON COLUMN "finance_company_bill"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_account" ON "finance_company_bill" (account_id ASC, period_start ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "finance_company_bill" (group_id ASC, bill_status ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "finance_company_bill" (bill_status ASC, overdue_date ASC);
CREATE INDEX IF NOT EXISTS "idx_period" ON "finance_company_bill" (period_start ASC, period_end ASC);

CREATE TABLE IF NOT EXISTS "finance_company_bill_item" (

    id BIGSERIAL,
    bill_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    order_no VARCHAR(40) NULL DEFAULT '',
    sales_id BIGINT NOT NULL,
    biz_type VARCHAR(20) NOT NULL,
    sales_amount decimal(12, 2) NOT NULL,
    service_fee decimal(12, 2) NULL DEFAULT 0.00,
    insurance_fee decimal(12, 2) NULL DEFAULT 0.00,
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    settle_amount decimal(12, 2) NOT NULL,
    contract_id BIGINT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_company_bill_item" IS '企业账单明细';
COMMENT ON COLUMN "finance_company_bill_item"."bill_id" IS '企业账单ID';
COMMENT ON COLUMN "finance_company_bill_item"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "finance_company_bill_item"."order_id" IS '主订单ID';
COMMENT ON COLUMN "finance_company_bill_item"."order_no" IS '订单号(冗余)';
COMMENT ON COLUMN "finance_company_bill_item"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "finance_company_bill_item"."biz_type" IS '业务类型: flight/train/hotel/mall/insurance/car';
COMMENT ON COLUMN "finance_company_bill_item"."sales_amount" IS '销售金额';
COMMENT ON COLUMN "finance_company_bill_item"."service_fee" IS '服务费';
COMMENT ON COLUMN "finance_company_bill_item"."insurance_fee" IS '保险费';
COMMENT ON COLUMN "finance_company_bill_item"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "finance_company_bill_item"."settle_amount" IS '应结金额(销售+服务+保险-退款)';
COMMENT ON COLUMN "finance_company_bill_item"."contract_id" IS '大客户签约ID(用于政策匹配)';
CREATE INDEX IF NOT EXISTS "idx_bill" ON "finance_company_bill_item" (bill_id ASC);
CREATE INDEX IF NOT EXISTS "idx_order" ON "finance_company_bill_item" (order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "finance_company_bill_item" (sales_id ASC);

CREATE TABLE IF NOT EXISTS "finance_company_payment" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    payment_no VARCHAR(40) NOT NULL,
    account_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    group_name VARCHAR(200) NULL DEFAULT '',
    payment_method VARCHAR(20) NOT NULL,
    payment_amount decimal(14, 2) NOT NULL,
    payment_at TIMESTAMP NOT NULL,
    bank_name VARCHAR(100) NULL DEFAULT '',
    bank_account VARCHAR(50) NULL DEFAULT '',
    voucher_url VARCHAR(500) NULL DEFAULT '',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    confirm_user_id BIGINT NULL DEFAULT 0,
    confirm_user_name VARCHAR(50) NULL DEFAULT '',
    confirm_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_company_payment" IS '企业来款(客户付款记录)';
COMMENT ON COLUMN "finance_company_payment"."tenant_id" IS '商户ID(TMC)';
COMMENT ON COLUMN "finance_company_payment"."payment_no" IS '来款编号(如: CP2026032300001)';
COMMENT ON COLUMN "finance_company_payment"."account_id" IS '企业结算账户ID';
COMMENT ON COLUMN "finance_company_payment"."group_id" IS '企业集团ID';
COMMENT ON COLUMN "finance_company_payment"."group_name" IS '企业名称(冗余)';
COMMENT ON COLUMN "finance_company_payment"."payment_method" IS '付款方式: BANK_TRANSFER/ALIPAY/WECHAT/CASH/OTHER';
COMMENT ON COLUMN "finance_company_payment"."payment_amount" IS '付款金额';
COMMENT ON COLUMN "finance_company_payment"."payment_at" IS '付款时间';
COMMENT ON COLUMN "finance_company_payment"."bank_name" IS '银行名称';
COMMENT ON COLUMN "finance_company_payment"."bank_account" IS '银行账号';
COMMENT ON COLUMN "finance_company_payment"."voucher_url" IS '付款凭证URL';
COMMENT ON COLUMN "finance_company_payment"."status" IS '状态: PENDING/CONFIRMED/CANCELLED';
COMMENT ON COLUMN "finance_company_payment"."confirm_user_id" IS '确认人ID';
COMMENT ON COLUMN "finance_company_payment"."confirm_user_name" IS '确认人姓名';
COMMENT ON COLUMN "finance_company_payment"."confirm_at" IS '确认时间';
COMMENT ON COLUMN "finance_company_payment"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_account" ON "finance_company_payment" (account_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "finance_company_payment" (group_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "finance_company_payment" (status ASC, payment_at ASC);

CREATE TABLE IF NOT EXISTS "finance_invoice" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    invoice_no VARCHAR(40) NOT NULL,
    invoice_type VARCHAR(20) NOT NULL,
    group_id BIGINT NOT NULL,
    group_name VARCHAR(200) NULL DEFAULT '',
    bill_id BIGINT NOT NULL,
    bill_no VARCHAR(40) NULL DEFAULT '',
    bill_type VARCHAR(20) NOT NULL DEFAULT 'COMPANY',
    invoice_amount decimal(14, 2) NOT NULL,
    tax_amount decimal(12, 2) NULL DEFAULT 0.00,
    tax_rate decimal(5, 4) DEFAULT NULL,
    invoice_title VARCHAR(200) NOT NULL,
    tax_number VARCHAR(50) NOT NULL,
    invoice_content VARCHAR(200) NULL DEFAULT '',
    receiver_name VARCHAR(50) NULL DEFAULT '',
    receiver_mobile VARCHAR(20) NULL DEFAULT '',
    receiver_address VARCHAR(300) NULL DEFAULT '',
    invoice_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    issue_at TIMESTAMP DEFAULT NULL,
    send_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_invoice" IS '发票';
COMMENT ON COLUMN "finance_invoice"."tenant_id" IS '商户ID(TMC)';
COMMENT ON COLUMN "finance_invoice"."invoice_no" IS '发票号码(如: INV2026032300001)';
COMMENT ON COLUMN "finance_invoice"."invoice_type" IS '发票类型: VAT_NORMAL=增值税普通/VAT_SPECIAL=增值税专用/ELECTRONIC=电子发票/TRAIN_INVOICE=火车票';
COMMENT ON COLUMN "finance_invoice"."group_id" IS '开票企业ID corporate_group.id';
COMMENT ON COLUMN "finance_invoice"."group_name" IS '开票企业名称(冗余)';
COMMENT ON COLUMN "finance_invoice"."bill_id" IS '关联账单ID(企业账单/供应商账单)';
COMMENT ON COLUMN "finance_invoice"."bill_no" IS '关联账单编号(冗余)';
COMMENT ON COLUMN "finance_invoice"."bill_type" IS '账单方向: COMPANY=企业账单/SUPPLIER=供应商账单';
COMMENT ON COLUMN "finance_invoice"."invoice_amount" IS '发票金额';
COMMENT ON COLUMN "finance_invoice"."tax_amount" IS '税额';
COMMENT ON COLUMN "finance_invoice"."tax_rate" IS '税率(如: 0.06=6%)';
COMMENT ON COLUMN "finance_invoice"."invoice_title" IS '发票抬头';
COMMENT ON COLUMN "finance_invoice"."tax_number" IS '税号';
COMMENT ON COLUMN "finance_invoice"."invoice_content" IS '发票内容(如: *经纪代理服务*)';
COMMENT ON COLUMN "finance_invoice"."receiver_name" IS '收件人姓名';
COMMENT ON COLUMN "finance_invoice"."receiver_mobile" IS '收件人电话';
COMMENT ON COLUMN "finance_invoice"."receiver_address" IS '收件人地址';
COMMENT ON COLUMN "finance_invoice"."invoice_status" IS '发票状态: PENDING/ISSUED/SENT/RECEIVED/INVALID/RETURNED';
COMMENT ON COLUMN "finance_invoice"."issue_at" IS '开票时间';
COMMENT ON COLUMN "finance_invoice"."send_at" IS '寄送时间';
COMMENT ON COLUMN "finance_invoice"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_group" ON "finance_invoice" (group_id ASC);
CREATE INDEX IF NOT EXISTS "idx_bill" ON "finance_invoice" (bill_type ASC, bill_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "finance_invoice" (invoice_status ASC);

CREATE TABLE IF NOT EXISTS "finance_refund" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    refund_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    biz_type VARCHAR(20) NOT NULL,
    item_id BIGINT NOT NULL,
    group_id BIGINT NULL DEFAULT 0,
    refund_type VARCHAR(20) NOT NULL,
    refund_amount decimal(12, 2) NOT NULL,
    refund_fee decimal(12, 2) NULL DEFAULT 0.00,
    actual_refund_amount decimal(12, 2) NOT NULL,
    refund_reason VARCHAR(500) NOT NULL,
    refund_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    audit_user_id BIGINT NULL DEFAULT 0,
    audit_user_name VARCHAR(50) NULL DEFAULT '',
    audit_at TIMESTAMP DEFAULT NULL,
    audit_remark VARCHAR(500) NULL DEFAULT '',
    refund_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_refund" IS '退款单(全业务线通用)';
COMMENT ON COLUMN "finance_refund"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "finance_refund"."refund_no" IS '退款编号(如: REF2026032300001)';
COMMENT ON COLUMN "finance_refund"."order_id" IS '主订单ID';
COMMENT ON COLUMN "finance_refund"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "finance_refund"."biz_type" IS '业务类型: flight/train/hotel/mall/insurance/car';
COMMENT ON COLUMN "finance_refund"."item_id" IS '子订单ID(按biz_type指向对应item表)';
COMMENT ON COLUMN "finance_refund"."group_id" IS '企业集团ID(大客户退款时)';
COMMENT ON COLUMN "finance_refund"."refund_type" IS '退款类型: VOLUNTARY=自愿/INVOLUNTARY=非自愿(航变等)';
COMMENT ON COLUMN "finance_refund"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "finance_refund"."refund_fee" IS '退款手续费';
COMMENT ON COLUMN "finance_refund"."actual_refund_amount" IS '实际退款金额(退款金额-手续费)';
COMMENT ON COLUMN "finance_refund"."refund_reason" IS '退款原因';
COMMENT ON COLUMN "finance_refund"."refund_status" IS '退款状态: PENDING/AUDIT_PASS/AUDIT_REJECT/PROCESSING/COMPLETED/FAILED/CANCELLED';
COMMENT ON COLUMN "finance_refund"."audit_user_id" IS '审核人ID';
COMMENT ON COLUMN "finance_refund"."audit_user_name" IS '审核人姓名';
COMMENT ON COLUMN "finance_refund"."audit_at" IS '审核时间';
COMMENT ON COLUMN "finance_refund"."audit_remark" IS '审核备注';
COMMENT ON COLUMN "finance_refund"."refund_at" IS '退款完成时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "finance_refund" (order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_item" ON "finance_refund" (biz_type ASC, item_id ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "finance_refund" (group_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "finance_refund" (refund_status ASC, created_at ASC);

CREATE TABLE IF NOT EXISTS "finance_refund_log" (

    id BIGSERIAL,
    refund_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    from_status SMALLINT NOT NULL,
    to_status SMALLINT NOT NULL,
    action VARCHAR(20) NOT NULL,
    operator_type VARCHAR(20) NULL DEFAULT '',
    operator_id BIGINT NULL DEFAULT 0,
    operator_name VARCHAR(30) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_refund_log" IS '退款流程日志(审核+审批+打款全追踪)';
COMMENT ON COLUMN "finance_refund_log"."refund_id" IS 'finance_refund.id';
COMMENT ON COLUMN "finance_refund_log"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "finance_refund_log"."from_status" IS '原状态';
COMMENT ON COLUMN "finance_refund_log"."to_status" IS '新状态';
COMMENT ON COLUMN "finance_refund_log"."action" IS '操作: apply=申请/audit_pass=审核通过/audit_reject=审核驳回/review_pass=审批通过/review_reject=审批驳回/transfer=打款/transfer_fail=打款失败/cancel=取消';
COMMENT ON COLUMN "finance_refund_log"."operator_type" IS '操作人类型: member/admin/system/cron';
COMMENT ON COLUMN "finance_refund_log"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "finance_refund_log"."operator_name" IS '操作人姓名';
COMMENT ON COLUMN "finance_refund_log"."remark" IS '审核意见/打款备注';
COMMENT ON COLUMN "finance_refund_log"."created_at" IS '操作时间';
CREATE INDEX IF NOT EXISTS "idx_refund" ON "finance_refund_log" (refund_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "finance_refund_log" (tenant_id ASC, to_status ASC, created_at ASC);

CREATE TABLE IF NOT EXISTS "finance_supplier_account" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    account_no VARCHAR(30) NOT NULL,
    supplier_type VARCHAR(30) NOT NULL,
    supplier_id BIGINT NULL DEFAULT 0,
    supplier_name VARCHAR(200) NOT NULL,
    account_type VARCHAR(20) NOT NULL DEFAULT 'CREDIT',
    balance decimal(14, 2) NULL DEFAULT 0.00,
    credit_limit decimal(14, 2) NULL DEFAULT 0.00,
    credit_used decimal(14, 2) NULL DEFAULT 0.00,
    credit_available decimal(14, 2) NULL DEFAULT 0.00,
    settle_period VARCHAR(20) NULL DEFAULT 'MONTHLY',
    account_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    open_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_supplier_account" IS '供应商账户(采购侧)';
COMMENT ON COLUMN "finance_supplier_account"."tenant_id" IS '商户ID(TMC)';
COMMENT ON COLUMN "finance_supplier_account"."account_no" IS '账户编号';
COMMENT ON COLUMN "finance_supplier_account"."supplier_type" IS '供应商类型: airline_b2b/airline_b2t/ota_ctrip/ota_qunar/ota_meituan/ota_fligy/railway_12306/hotel_supplier/mall_supplier/insurance_supplier';
COMMENT ON COLUMN "finance_supplier_account"."supplier_id" IS '供应商ID(如航司则关联air_airline.id)';
COMMENT ON COLUMN "finance_supplier_account"."supplier_name" IS '供应商名称';
COMMENT ON COLUMN "finance_supplier_account"."account_type" IS '账户类型: PREPAID=预存/CREDIT=信用';
COMMENT ON COLUMN "finance_supplier_account"."balance" IS '账户余额(预存)';
COMMENT ON COLUMN "finance_supplier_account"."credit_limit" IS '授信额度';
COMMENT ON COLUMN "finance_supplier_account"."credit_used" IS '已用额度';
COMMENT ON COLUMN "finance_supplier_account"."credit_available" IS '可用额度';
COMMENT ON COLUMN "finance_supplier_account"."settle_period" IS '结算周期';
COMMENT ON COLUMN "finance_supplier_account"."account_status" IS '账户状态: ACTIVE/INACTIVE/FROZEN';
COMMENT ON COLUMN "finance_supplier_account"."open_at" IS '开户时间';
COMMENT ON COLUMN "finance_supplier_account"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_supplier_type" ON "finance_supplier_account" (supplier_type ASC, supplier_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "finance_supplier_account" (account_status ASC);

CREATE TABLE IF NOT EXISTS "finance_supplier_bill" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    bill_no VARCHAR(40) NOT NULL,
    supplier_account_id BIGINT NOT NULL,
    supplier_type VARCHAR(30) NOT NULL,
    supplier_id BIGINT NOT NULL,
    supplier_name VARCHAR(200) NULL DEFAULT '',
    period_start date NOT NULL,
    period_end date NOT NULL,
    bill_amount decimal(14, 2) NOT NULL,
    paid_amount decimal(14, 2) NULL DEFAULT 0.00,
    outstanding_amount decimal(14, 2) NULL DEFAULT 0.00,
    bill_status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    due_date date DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_supplier_bill" IS '供应商账单(采购侧)';
COMMENT ON COLUMN "finance_supplier_bill"."tenant_id" IS '商户ID(TMC)';
COMMENT ON COLUMN "finance_supplier_bill"."bill_no" IS '账单编号(如: SB2026032300001)';
COMMENT ON COLUMN "finance_supplier_bill"."supplier_account_id" IS '供应商账户ID';
COMMENT ON COLUMN "finance_supplier_bill"."supplier_type" IS '供应商类型';
COMMENT ON COLUMN "finance_supplier_bill"."supplier_id" IS '供应商ID';
COMMENT ON COLUMN "finance_supplier_bill"."supplier_name" IS '供应商名称(冗余)';
COMMENT ON COLUMN "finance_supplier_bill"."period_start" IS '账单期间开始';
COMMENT ON COLUMN "finance_supplier_bill"."period_end" IS '账单期间结束';
COMMENT ON COLUMN "finance_supplier_bill"."bill_amount" IS '账单金额(应付)';
COMMENT ON COLUMN "finance_supplier_bill"."paid_amount" IS '已付金额';
COMMENT ON COLUMN "finance_supplier_bill"."outstanding_amount" IS '未付金额';
COMMENT ON COLUMN "finance_supplier_bill"."bill_status" IS '状态: DRAFT/CONFIRMED/SENT/PARTIAL_PAID/PAID/OVERDUE/CANCELLED';
COMMENT ON COLUMN "finance_supplier_bill"."due_date" IS '到期日期';
COMMENT ON COLUMN "finance_supplier_bill"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_supplier_account" ON "finance_supplier_bill" (supplier_account_id ASC, period_start ASC);
CREATE INDEX IF NOT EXISTS "idx_supplier" ON "finance_supplier_bill" (supplier_type ASC, supplier_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "finance_supplier_bill" (bill_status ASC, due_date ASC);

CREATE TABLE IF NOT EXISTS "finance_supplier_payment" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    payment_no VARCHAR(40) NOT NULL,
    supplier_bill_id BIGINT NOT NULL,
    supplier_account_id BIGINT NOT NULL,
    supplier_type VARCHAR(30) NOT NULL,
    supplier_id BIGINT NOT NULL,
    supplier_name VARCHAR(200) NULL DEFAULT '',
    payment_amount decimal(14, 2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    payment_at TIMESTAMP NOT NULL,
    bank_name VARCHAR(100) NULL DEFAULT '',
    bank_account VARCHAR(50) NULL DEFAULT '',
    voucher_url VARCHAR(500) NULL DEFAULT '',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    approve_user_id BIGINT NULL DEFAULT 0,
    approve_user_name VARCHAR(50) NULL DEFAULT '',
    approve_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "finance_supplier_payment" IS '供应商付款(采购侧)';
COMMENT ON COLUMN "finance_supplier_payment"."tenant_id" IS '商户ID(TMC)';
COMMENT ON COLUMN "finance_supplier_payment"."payment_no" IS '付款编号(如: SP2026032300001)';
COMMENT ON COLUMN "finance_supplier_payment"."supplier_bill_id" IS '供应商账单ID';
COMMENT ON COLUMN "finance_supplier_payment"."supplier_account_id" IS '供应商账户ID';
COMMENT ON COLUMN "finance_supplier_payment"."supplier_type" IS '供应商类型';
COMMENT ON COLUMN "finance_supplier_payment"."supplier_id" IS '供应商ID';
COMMENT ON COLUMN "finance_supplier_payment"."supplier_name" IS '供应商名称(冗余)';
COMMENT ON COLUMN "finance_supplier_payment"."payment_amount" IS '付款金额';
COMMENT ON COLUMN "finance_supplier_payment"."payment_method" IS '付款方式: BANK_TRANSFER/ALIPAY/WECHAT/CASH/OTHER';
COMMENT ON COLUMN "finance_supplier_payment"."payment_at" IS '付款时间';
COMMENT ON COLUMN "finance_supplier_payment"."bank_name" IS '收款银行';
COMMENT ON COLUMN "finance_supplier_payment"."bank_account" IS '收款账号';
COMMENT ON COLUMN "finance_supplier_payment"."voucher_url" IS '付款凭证URL';
COMMENT ON COLUMN "finance_supplier_payment"."status" IS '状态: PENDING/APPROVED/PAID/CANCELLED';
COMMENT ON COLUMN "finance_supplier_payment"."approve_user_id" IS '审批人ID';
COMMENT ON COLUMN "finance_supplier_payment"."approve_user_name" IS '审批人姓名';
COMMENT ON COLUMN "finance_supplier_payment"."approve_at" IS '审批时间';
COMMENT ON COLUMN "finance_supplier_payment"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_bill" ON "finance_supplier_payment" (supplier_bill_id ASC);
CREATE INDEX IF NOT EXISTS "idx_supplier" ON "finance_supplier_payment" (supplier_type ASC, supplier_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "finance_supplier_payment" (status ASC, payment_at ASC);

CREATE TABLE IF NOT EXISTS "hotel_brand" (

    id BIGSERIAL,
    brand_code VARCHAR(20) NOT NULL,
    brand_name VARCHAR(100) NOT NULL,
    brand_name_en VARCHAR(100) NULL DEFAULT '',
    logo_url VARCHAR(500) NULL DEFAULT '',
    level SMALLINT NULL DEFAULT 0,
    country VARCHAR(50) NULL DEFAULT '',
    sort_order INTEGER NULL DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "hotel_brand" IS '酒店品牌';
COMMENT ON COLUMN "hotel_brand"."brand_code" IS '品牌编码(如: HILTON/ACCOR)';
COMMENT ON COLUMN "hotel_brand"."brand_name" IS '品牌名称(如: 希尔顿/雅高)';
COMMENT ON COLUMN "hotel_brand"."brand_name_en" IS '品牌英文名';
COMMENT ON COLUMN "hotel_brand"."logo_url" IS '品牌Logo URL';
COMMENT ON COLUMN "hotel_brand"."level" IS '品牌档次: 1=经济,2=舒适,3=高端,4=豪华';
COMMENT ON COLUMN "hotel_brand"."country" IS '所属国家';
COMMENT ON COLUMN "hotel_brand"."sort_order" IS '排序权重';
COMMENT ON COLUMN "hotel_brand"."status" IS '1=启用,2=停用';
CREATE INDEX IF NOT EXISTS "idx_status" ON "hotel_brand" (status ASC, sort_order ASC);

CREATE TABLE IF NOT EXISTS "hotel_info" (

    id BIGSERIAL,
    hotel_code VARCHAR(30) NOT NULL,
    hotel_name VARCHAR(200) NOT NULL,
    hotel_name_en VARCHAR(200) NULL DEFAULT '',
    brand_id BIGINT NULL DEFAULT 0,
    city_code VARCHAR(20) NOT NULL,
    city_name VARCHAR(30) NULL DEFAULT '',
    district VARCHAR(50) NULL DEFAULT '',
    address VARCHAR(500) NULL DEFAULT '',
    longitude decimal(10, 6) DEFAULT NULL,
    latitude decimal(10, 6) DEFAULT NULL,
    star_rate SMALLINT NULL DEFAULT 0,
    phone VARCHAR(30) NULL DEFAULT '',
    check_in_time VARCHAR(10) NULL DEFAULT '14:00',
    check_out_time VARCHAR(10) NULL DEFAULT '12:00',
    facilities json NULL,
    images json NULL,
    description TEXT NULL,
    supplier_type VARCHAR(30) NULL DEFAULT '',
    supplier_hotel_id VARCHAR(50) NULL DEFAULT '',
    sort_order INTEGER NULL DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "hotel_info" IS '酒店信息';
COMMENT ON COLUMN "hotel_info"."hotel_code" IS '酒店编码(供应商侧唯一ID)';
COMMENT ON COLUMN "hotel_info"."hotel_name" IS '酒店名称';
COMMENT ON COLUMN "hotel_info"."hotel_name_en" IS '酒店英文名';
COMMENT ON COLUMN "hotel_info"."brand_id" IS '品牌ID hotel_brand.id';
COMMENT ON COLUMN "hotel_info"."city_code" IS '城市编码(对接air_region)';
COMMENT ON COLUMN "hotel_info"."city_name" IS '城市名';
COMMENT ON COLUMN "hotel_info"."district" IS '行政区/商圈';
COMMENT ON COLUMN "hotel_info"."address" IS '详细地址';
COMMENT ON COLUMN "hotel_info"."longitude" IS '经度';
COMMENT ON COLUMN "hotel_info"."latitude" IS '纬度';
COMMENT ON COLUMN "hotel_info"."star_rate" IS '星级: 1-5, 0=未评';
COMMENT ON COLUMN "hotel_info"."phone" IS '酒店电话';
COMMENT ON COLUMN "hotel_info"."check_in_time" IS '最早入住时间';
COMMENT ON COLUMN "hotel_info"."check_out_time" IS '最晚退房时间';
COMMENT ON COLUMN "hotel_info"."facilities" IS '设施标签(如: [\"WiFi\",\"停车场\",\"健身房\",\"游泳池\"])';
COMMENT ON COLUMN "hotel_info"."images" IS '酒店图片列表(如: [{\"url\":\"...\",\"type\":\"exterior\",\"sort\":1}])';
COMMENT ON COLUMN "hotel_info"."description" IS '酒店简介';
COMMENT ON COLUMN "hotel_info"."supplier_type" IS '数据来源: ota_ctrip/ota_meituan/ota_fligy/hotel_direct';
COMMENT ON COLUMN "hotel_info"."supplier_hotel_id" IS '供应商侧酒店ID';
COMMENT ON COLUMN "hotel_info"."sort_order" IS '排序权重';
COMMENT ON COLUMN "hotel_info"."status" IS '1=启用,2=停用,3=下架';
CREATE INDEX IF NOT EXISTS "idx_city" ON "hotel_info" (city_code ASC, star_rate ASC);
CREATE INDEX IF NOT EXISTS "idx_brand" ON "hotel_info" (brand_id ASC);
CREATE INDEX IF NOT EXISTS "idx_supplier" ON "hotel_info" (supplier_type ASC, supplier_hotel_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status" ON "hotel_info" (status ASC, sort_order ASC);
CREATE INDEX IF NOT EXISTS "idx_location" ON "hotel_info" (longitude ASC, latitude ASC);

CREATE TABLE IF NOT EXISTS "hotel_room_type" (

    id BIGSERIAL,
    hotel_id BIGINT NOT NULL,
    room_type_code VARCHAR(30) NOT NULL,
    room_type_name VARCHAR(100) NOT NULL,
    bed_type VARCHAR(20) NULL DEFAULT '',
    area VARCHAR(20) NULL DEFAULT '',
    floor VARCHAR(50) NULL DEFAULT '',
    max_occupancy SMALLINT NULL DEFAULT 2,
    breakfast VARCHAR(20) NULL DEFAULT '',
    wifi SMALLINT NULL DEFAULT 1,
    window SMALLINT NULL DEFAULT 1,
    cancel_policy VARCHAR(500) NULL DEFAULT '',
    facilities json NULL,
    images json NULL,
    supplier_room_id VARCHAR(50) NULL DEFAULT '',
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "hotel_room_type" IS '酒店房型';
COMMENT ON COLUMN "hotel_room_type"."hotel_id" IS '酒店ID hotel_info.id';
COMMENT ON COLUMN "hotel_room_type"."room_type_code" IS '房型编码(供应商侧)';
COMMENT ON COLUMN "hotel_room_type"."room_type_name" IS '房型名称(如: 高级大床房)';
COMMENT ON COLUMN "hotel_room_type"."bed_type" IS '床型: single_bed=单人大床/double_bed=双人双床/king_bed=豪华大床/twin_bed=标准双床';
COMMENT ON COLUMN "hotel_room_type"."area" IS '面积(如: 35㎡)';
COMMENT ON COLUMN "hotel_room_type"."floor" IS '楼层范围(如: 5-12层)';
COMMENT ON COLUMN "hotel_room_type"."max_occupancy" IS '最大入住人数';
COMMENT ON COLUMN "hotel_room_type"."breakfast" IS '早餐: none=无早/single=单早/double=双早';
COMMENT ON COLUMN "hotel_room_type"."wifi" IS '1=有WiFi,2=无WiFi';
COMMENT ON COLUMN "hotel_room_type"."window" IS '1=有窗,2=无窗,3=部分有窗';
COMMENT ON COLUMN "hotel_room_type"."cancel_policy" IS '取消政策摘要';
COMMENT ON COLUMN "hotel_room_type"."facilities" IS '房型设施标签(如: [\"浴缸\",\"迷你吧\",\"保险箱\"])';
COMMENT ON COLUMN "hotel_room_type"."images" IS '房型图片';
COMMENT ON COLUMN "hotel_room_type"."supplier_room_id" IS '供应商侧房型ID';
COMMENT ON COLUMN "hotel_room_type"."status" IS '1=启用,2=停用';
CREATE INDEX IF NOT EXISTS "idx_hotel" ON "hotel_room_type" (hotel_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_supplier" ON "hotel_room_type" (supplier_room_id ASC);

CREATE TABLE IF NOT EXISTS "insurance_product" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    product_code VARCHAR(30) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    insurance_type VARCHAR(20) NOT NULL,
    insurance_company VARCHAR(100) NOT NULL,
    insurance_company_code VARCHAR(20) NULL DEFAULT '',
    premium decimal(10, 2) NOT NULL,
    coverage_amount decimal(12, 2) NOT NULL,
    coverage_desc VARCHAR(500) NULL DEFAULT '',
    coverage_detail TEXT NULL,
    effective_rule VARCHAR(200) NULL DEFAULT '',
    duration_type VARCHAR(20) NOT NULL DEFAULT 'trip',
    duration_days SMALLINT NULL DEFAULT 0,
    refund_rule VARCHAR(200) NULL DEFAULT '',
    sale_start_date date DEFAULT NULL,
    sale_end_date date DEFAULT NULL,
    sort_order INTEGER NULL DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "insurance_product" IS '保险产品';
COMMENT ON COLUMN "insurance_product"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "insurance_product"."product_code" IS '产品编码';
COMMENT ON COLUMN "insurance_product"."product_name" IS '产品名称(如: 航空意外险-基础版)';
COMMENT ON COLUMN "insurance_product"."insurance_type" IS '保险类型: aviation=航空意外/travel=旅行险/cancel=取消险/delay=延误险';
COMMENT ON COLUMN "insurance_product"."insurance_company" IS '保险公司名称';
COMMENT ON COLUMN "insurance_product"."insurance_company_code" IS '保险公司编码';
COMMENT ON COLUMN "insurance_product"."premium" IS '保费(每份)';
COMMENT ON COLUMN "insurance_product"."coverage_amount" IS '保额';
COMMENT ON COLUMN "insurance_product"."coverage_desc" IS '保障内容摘要';
COMMENT ON COLUMN "insurance_product"."coverage_detail" IS '保障条款详情(JSON)';
COMMENT ON COLUMN "insurance_product"."effective_rule" IS '生效规则(如: 出票后次日零时生效)';
COMMENT ON COLUMN "insurance_product"."duration_type" IS '保障期间: trip=单次行程/fixed=固定天数/year=年险';
COMMENT ON COLUMN "insurance_product"."duration_days" IS '固定天数(duration_type=fixed时有效)';
COMMENT ON COLUMN "insurance_product"."refund_rule" IS '退保规则';
COMMENT ON COLUMN "insurance_product"."sale_start_date" IS '销售开始日期';
COMMENT ON COLUMN "insurance_product"."sale_end_date" IS '销售结束日期';
COMMENT ON COLUMN "insurance_product"."sort_order" IS '排序权重';
COMMENT ON COLUMN "insurance_product"."status" IS '1=上架,2=下架,3=停售';
CREATE INDEX IF NOT EXISTS "idx_type" ON "insurance_product" (insurance_type ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_company" ON "insurance_product" (insurance_company_code ASC);

CREATE TABLE IF NOT EXISTS "mall_after_sale" (

    id BIGSERIAL,
    after_sale_no VARCHAR(40) NOT NULL,
    tenant_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL DEFAULT 0,
    type SMALLINT NOT NULL,
    reason VARCHAR(255) NOT NULL DEFAULT '',
    description VARCHAR(500) NOT NULL DEFAULT '',
    quantity SMALLINT NOT NULL DEFAULT 1,
    refund_amount decimal(12, 2) NOT NULL DEFAULT 0.00,
    agreed_amount decimal(12, 2) NOT NULL DEFAULT 0.00,
    actual_amount decimal(12, 2) NOT NULL DEFAULT 0.00,
    audit_status SMALLINT NOT NULL DEFAULT 1,
    audit_remark VARCHAR(255) NOT NULL DEFAULT '',
    audit_at TIMESTAMP DEFAULT NULL,
    user_shipped SMALLINT NOT NULL DEFAULT 0,
    user_express_id BIGINT NOT NULL DEFAULT 0,
    user_express_no VARCHAR(50) NOT NULL DEFAULT '',
    user_shipped_at TIMESTAMP DEFAULT NULL,
    merchant_received SMALLINT NOT NULL DEFAULT 0,
    merchant_received_at TIMESTAMP DEFAULT NULL,
    merchant_shipped SMALLINT NOT NULL DEFAULT 0,
    merchant_express_id BIGINT NOT NULL DEFAULT 0,
    merchant_express_no VARCHAR(50) NOT NULL DEFAULT '',
    merchant_shipped_at TIMESTAMP DEFAULT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    refund_status SMALLINT NOT NULL DEFAULT 0,
    refund_at TIMESTAMP DEFAULT NULL,
    refund_no VARCHAR(64) NOT NULL DEFAULT '',
    completed_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_after_sale" IS '售后单';
COMMENT ON COLUMN "mall_after_sale"."after_sale_no" IS '售后单号';
COMMENT ON COLUMN "mall_after_sale"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "mall_after_sale"."order_id" IS '主订单ID';
COMMENT ON COLUMN "mall_after_sale"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "mall_after_sale"."item_id" IS '子订单ID order_item_mall.id';
COMMENT ON COLUMN "mall_after_sale"."user_id" IS 'C端用户ID';
COMMENT ON COLUMN "mall_after_sale"."member_id" IS '商户会员ID';
COMMENT ON COLUMN "mall_after_sale"."type" IS '1=退货退款,2=换货,3=仅退款';
COMMENT ON COLUMN "mall_after_sale"."reason" IS '用户申请原因';
COMMENT ON COLUMN "mall_after_sale"."description" IS '问题描述';
COMMENT ON COLUMN "mall_after_sale"."quantity" IS '售后数量';
COMMENT ON COLUMN "mall_after_sale"."refund_amount" IS '申请退款金额';
COMMENT ON COLUMN "mall_after_sale"."agreed_amount" IS '商家同意退款金额';
COMMENT ON COLUMN "mall_after_sale"."actual_amount" IS '实际退款金额';
COMMENT ON COLUMN "mall_after_sale"."audit_status" IS '1=待审核,2=审核通过,3=审核拒绝';
COMMENT ON COLUMN "mall_after_sale"."audit_remark" IS '审核备注/拒绝原因';
COMMENT ON COLUMN "mall_after_sale"."audit_at" IS '审核时间';
COMMENT ON COLUMN "mall_after_sale"."user_shipped" IS '0=用户未发货,1=已发货';
COMMENT ON COLUMN "mall_after_sale"."user_express_id" IS '用户退货快递公司ID';
COMMENT ON COLUMN "mall_after_sale"."user_express_no" IS '用户退货快递单号';
COMMENT ON COLUMN "mall_after_sale"."user_shipped_at" IS '用户发货时间';
COMMENT ON COLUMN "mall_after_sale"."merchant_received" IS '0=商家未收货,1=已收货';
COMMENT ON COLUMN "mall_after_sale"."merchant_received_at" IS '商家收货时间';
COMMENT ON COLUMN "mall_after_sale"."merchant_shipped" IS '0=商家未发换货,1=已发换货';
COMMENT ON COLUMN "mall_after_sale"."merchant_express_id" IS '商家换货快递ID';
COMMENT ON COLUMN "mall_after_sale"."merchant_express_no" IS '商家换货快递单号';
COMMENT ON COLUMN "mall_after_sale"."merchant_shipped_at" IS '商家发货时间';
COMMENT ON COLUMN "mall_after_sale"."status" IS '1=进行中,2=已完成,3=已取消,4=已关闭';
COMMENT ON COLUMN "mall_after_sale"."refund_status" IS '0=未退款,1=退款中,2=已退款,3=退款失败';
COMMENT ON COLUMN "mall_after_sale"."refund_at" IS '退款到账时间';
COMMENT ON COLUMN "mall_after_sale"."refund_no" IS '退款流水号';
COMMENT ON COLUMN "mall_after_sale"."completed_at" IS '完成时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "mall_after_sale" (order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_item" ON "mall_after_sale" (item_id ASC);
CREATE INDEX IF NOT EXISTS "idx_user_status" ON "mall_after_sale" (user_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_audit" ON "mall_after_sale" (tenant_id ASC, audit_status ASC, status ASC);

CREATE TABLE IF NOT EXISTS "mall_after_sale_image" (

    id BIGSERIAL,
    after_sale_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL DEFAULT '',
    image_type SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 100,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_after_sale_image" IS '售后凭证图片';
COMMENT ON COLUMN "mall_after_sale_image"."after_sale_id" IS '售后单ID';
COMMENT ON COLUMN "mall_after_sale_image"."image_url" IS '图片URL';
COMMENT ON COLUMN "mall_after_sale_image"."image_type" IS '1=用户凭证,2=商家凭证';
COMMENT ON COLUMN "mall_after_sale_image"."sort" IS '排序';
CREATE INDEX IF NOT EXISTS "idx_after_sale" ON "mall_after_sale_image" (after_sale_id ASC);

CREATE TABLE IF NOT EXISTS "mall_after_sale_log" (

    id BIGSERIAL,
    after_sale_id BIGINT NOT NULL,
    operator_type SMALLINT NOT NULL,
    operator_id BIGINT NOT NULL DEFAULT 0,
    action VARCHAR(60) NOT NULL DEFAULT '',
    content VARCHAR(500) NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_after_sale_log" IS '售后进度日志';
COMMENT ON COLUMN "mall_after_sale_log"."after_sale_id" IS '售后单ID';
COMMENT ON COLUMN "mall_after_sale_log"."operator_type" IS '1=用户,2=商家,3=系统';
COMMENT ON COLUMN "mall_after_sale_log"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "mall_after_sale_log"."action" IS '动作(如:提交申请/审核通过/用户发货)';
COMMENT ON COLUMN "mall_after_sale_log"."content" IS '日志内容';
CREATE INDEX IF NOT EXISTS "idx_after_sale" ON "mall_after_sale_log" (after_sale_id ASC, created_at ASC);

CREATE TABLE IF NOT EXISTS "mall_cart" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL DEFAULT 0,
    goods_id BIGINT NOT NULL,
    sku_id BIGINT NOT NULL DEFAULT 0,
    quantity SMALLINT NOT NULL DEFAULT 1,
    is_checked SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_cart" IS '购物车';
COMMENT ON COLUMN "mall_cart"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "mall_cart"."user_id" IS 'C端用户ID c_user.id';
COMMENT ON COLUMN "mall_cart"."member_id" IS '商户会员ID c_member.id';
COMMENT ON COLUMN "mall_cart"."goods_id" IS '商品ID';
COMMENT ON COLUMN "mall_cart"."sku_id" IS 'SKU ID, 0=单规格';
COMMENT ON COLUMN "mall_cart"."quantity" IS '数量';
COMMENT ON COLUMN "mall_cart"."is_checked" IS '1=选中,0=未选中';
CREATE INDEX IF NOT EXISTS "idx_member" ON "mall_cart" (member_id ASC);

CREATE TABLE IF NOT EXISTS "mall_category" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    parent_id BIGINT NOT NULL DEFAULT 0,
    name VARCHAR(60) NOT NULL DEFAULT '',
    icon VARCHAR(255) NOT NULL DEFAULT '',
    sort SMALLINT NOT NULL DEFAULT 100,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_category" IS '商城分类';
COMMENT ON COLUMN "mall_category"."tenant_id" IS '商户ID, 0=平台公共分类';
COMMENT ON COLUMN "mall_category"."parent_id" IS '父分类ID, 0=顶级';
COMMENT ON COLUMN "mall_category"."name" IS '分类名称';
COMMENT ON COLUMN "mall_category"."icon" IS '分类图标URL';
COMMENT ON COLUMN "mall_category"."sort" IS '排序(小值靠前)';
COMMENT ON COLUMN "mall_category"."status" IS '1=启用,0=禁用';
CREATE INDEX IF NOT EXISTS "idx_tenant_parent" ON "mall_category" (tenant_id ASC, parent_id ASC, sort ASC);

CREATE TABLE IF NOT EXISTS "mall_comment" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    goods_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL DEFAULT 0,
    score SMALLINT NOT NULL DEFAULT 5,
    content VARCHAR(1000) NOT NULL DEFAULT '',
    is_anonymous SMALLINT NOT NULL DEFAULT 0,
    reply_content VARCHAR(500) NOT NULL DEFAULT '',
    reply_at TIMESTAMP DEFAULT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_comment" IS '商品评价';
COMMENT ON COLUMN "mall_comment"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "mall_comment"."order_id" IS '主订单ID';
COMMENT ON COLUMN "mall_comment"."item_id" IS '子订单ID';
COMMENT ON COLUMN "mall_comment"."goods_id" IS '商品ID';
COMMENT ON COLUMN "mall_comment"."user_id" IS 'C端用户ID';
COMMENT ON COLUMN "mall_comment"."member_id" IS '商户会员ID';
COMMENT ON COLUMN "mall_comment"."score" IS '评分(1-5)';
COMMENT ON COLUMN "mall_comment"."content" IS '评价内容';
COMMENT ON COLUMN "mall_comment"."is_anonymous" IS '1=匿名,0=实名';
COMMENT ON COLUMN "mall_comment"."reply_content" IS '商家回复';
COMMENT ON COLUMN "mall_comment"."reply_at" IS '回复时间';
COMMENT ON COLUMN "mall_comment"."status" IS '1=正常,2=隐藏';
CREATE INDEX IF NOT EXISTS "idx_goods" ON "mall_comment" (goods_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_user" ON "mall_comment" (user_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant" ON "mall_comment" (tenant_id ASC, status ASC);

CREATE TABLE IF NOT EXISTS "mall_comment_image" (

    id BIGSERIAL,
    comment_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL DEFAULT '',
    sort SMALLINT NOT NULL DEFAULT 100,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_comment_image" IS '评价图片';
COMMENT ON COLUMN "mall_comment_image"."comment_id" IS '评价ID';
COMMENT ON COLUMN "mall_comment_image"."image_url" IS '图片URL';
COMMENT ON COLUMN "mall_comment_image"."sort" IS '排序';
CREATE INDEX IF NOT EXISTS "idx_comment" ON "mall_comment_image" (comment_id ASC);

CREATE TABLE IF NOT EXISTS "mall_coupon" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL DEFAULT '',
    coupon_type SMALLINT NOT NULL DEFAULT 1,
    reduce_price decimal(12, 2) NOT NULL DEFAULT 0.00,
    discount SMALLINT NOT NULL DEFAULT 0,
    min_price decimal(12, 2) NOT NULL DEFAULT 0.00,
    max_discount_price decimal(12, 2) NOT NULL DEFAULT 0.00,
    expire_type SMALLINT NOT NULL DEFAULT 1,
    expire_day SMALLINT NOT NULL DEFAULT 0,
    start_time TIMESTAMP DEFAULT NULL,
    end_time TIMESTAMP DEFAULT NULL,
    apply_range SMALLINT NOT NULL DEFAULT 1,
    total_num INTEGER NOT NULL DEFAULT 0,
    receive_num INTEGER NOT NULL DEFAULT 0,
    per_limit SMALLINT NOT NULL DEFAULT 1,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_coupon" IS '优惠券定义';
COMMENT ON COLUMN "mall_coupon"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "mall_coupon"."name" IS '优惠券名称';
COMMENT ON COLUMN "mall_coupon"."coupon_type" IS '1=满减券,2=折扣券';
COMMENT ON COLUMN "mall_coupon"."reduce_price" IS '满减金额(coupon_type=1)';
COMMENT ON COLUMN "mall_coupon"."discount" IS '折扣率1-99(coupon_type=2, 如85=8.5折)';
COMMENT ON COLUMN "mall_coupon"."min_price" IS '最低消费金额';
COMMENT ON COLUMN "mall_coupon"."max_discount_price" IS '折扣券最多抵扣金额';
COMMENT ON COLUMN "mall_coupon"."expire_type" IS '1=领取后N天有效,2=固定时间段';
COMMENT ON COLUMN "mall_coupon"."expire_day" IS '领取后有效天数(expire_type=1)';
COMMENT ON COLUMN "mall_coupon"."start_time" IS '有效期开始(expire_type=2)';
COMMENT ON COLUMN "mall_coupon"."end_time" IS '有效期结束(expire_type=2)';
COMMENT ON COLUMN "mall_coupon"."apply_range" IS '1=全场通用,2=指定商品,3=指定分类';
COMMENT ON COLUMN "mall_coupon"."total_num" IS '发放总量,0=不限';
COMMENT ON COLUMN "mall_coupon"."receive_num" IS '已领取数量';
COMMENT ON COLUMN "mall_coupon"."per_limit" IS '每人限领数量,0=不限';
COMMENT ON COLUMN "mall_coupon"."status" IS '1=启用,0=禁用';
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "mall_coupon" (tenant_id ASC, status ASC);

CREATE TABLE IF NOT EXISTS "mall_coupon_scope" (

    id BIGSERIAL,
    coupon_id BIGINT NOT NULL,
    scope_type SMALLINT NOT NULL,
    target_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_coupon_scope" IS '优惠券适用范围';
COMMENT ON COLUMN "mall_coupon_scope"."coupon_id" IS '优惠券ID';
COMMENT ON COLUMN "mall_coupon_scope"."scope_type" IS '1=商品,2=分类';
COMMENT ON COLUMN "mall_coupon_scope"."target_id" IS '商品ID或分类ID';
CREATE INDEX IF NOT EXISTS "idx_coupon" ON "mall_coupon_scope" (coupon_id ASC);

CREATE TABLE IF NOT EXISTS "mall_delivery_rule" (

    id BIGSERIAL,
    template_id BIGINT NOT NULL,
    region_ids TEXT NOT NULL,
    first_unit decimal(10, 2) NOT NULL DEFAULT 0.00,
    first_fee decimal(12, 2) NOT NULL DEFAULT 0.00,
    additional_unit decimal(10, 2) NOT NULL DEFAULT 0.00,
    additional_fee decimal(12, 2) NOT NULL DEFAULT 0.00,
    is_free SMALLINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_delivery_rule" IS '运费规则';
COMMENT ON COLUMN "mall_delivery_rule"."template_id" IS '运费模板ID';
COMMENT ON COLUMN "mall_delivery_rule"."region_ids" IS '可配送区域(城市ID集,逗号分隔)';
COMMENT ON COLUMN "mall_delivery_rule"."first_unit" IS '首件/首重';
COMMENT ON COLUMN "mall_delivery_rule"."first_fee" IS '首费(元)';
COMMENT ON COLUMN "mall_delivery_rule"."additional_unit" IS '续件/续重';
COMMENT ON COLUMN "mall_delivery_rule"."additional_fee" IS '续费(元)';
COMMENT ON COLUMN "mall_delivery_rule"."is_free" IS '1=包邮(该区域免运费)';
CREATE INDEX IF NOT EXISTS "idx_template" ON "mall_delivery_rule" (template_id ASC);

CREATE TABLE IF NOT EXISTS "mall_delivery_template" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL DEFAULT '',
    method SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 100,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_delivery_template" IS '运费模板';
COMMENT ON COLUMN "mall_delivery_template"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "mall_delivery_template"."name" IS '模板名称';
COMMENT ON COLUMN "mall_delivery_template"."method" IS '1=按件数,2=按重量';
COMMENT ON COLUMN "mall_delivery_template"."sort" IS '排序';
CREATE INDEX IF NOT EXISTS "idx_tenant" ON "mall_delivery_template" (tenant_id ASC);

CREATE TABLE IF NOT EXISTS "mall_express" (

    id BIGSERIAL,
    code VARCHAR(30) NOT NULL DEFAULT '',
    name VARCHAR(60) NOT NULL DEFAULT '',
    sort SMALLINT NOT NULL DEFAULT 100,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_express" IS '快递公司';
COMMENT ON COLUMN "mall_express"."code" IS '快递公司编码(如:SF/YTO/ZTO)';
COMMENT ON COLUMN "mall_express"."name" IS '快递公司名称';
COMMENT ON COLUMN "mall_express"."sort" IS '排序';
COMMENT ON COLUMN "mall_express"."status" IS '1=启用,0=禁用';

CREATE TABLE IF NOT EXISTS "mall_favorite" (

    id BIGSERIAL,
    user_id BIGINT NOT NULL,
    goods_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_favorite" IS '商品收藏';
COMMENT ON COLUMN "mall_favorite"."user_id" IS 'C端用户ID c_user.id';
COMMENT ON COLUMN "mall_favorite"."goods_id" IS '商品ID';
COMMENT ON COLUMN "mall_favorite"."tenant_id" IS '商户ID';

CREATE TABLE IF NOT EXISTS "mall_goods" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    goods_no VARCHAR(64) NOT NULL DEFAULT '',
    name VARCHAR(255) NOT NULL DEFAULT '',
    subtitle VARCHAR(255) NOT NULL DEFAULT '',
    category_id BIGINT NOT NULL DEFAULT 0,
    spec_type SMALLINT NOT NULL DEFAULT 1,
    deduct_stock_type SMALLINT NOT NULL DEFAULT 2,
    main_image VARCHAR(255) NOT NULL DEFAULT '',
    content TEXT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    sort INTEGER NOT NULL DEFAULT 100,
    sales_actual INTEGER NOT NULL DEFAULT 0,
    sales_virtual INTEGER NOT NULL DEFAULT 0,
    view_count INTEGER NOT NULL DEFAULT 0,
    is_virtual SMALLINT NOT NULL DEFAULT 0,
    virtual_auto SMALLINT NOT NULL DEFAULT 0,
    virtual_content TEXT NULL,
    delivery_id BIGINT NOT NULL DEFAULT 0,
    limit_num INTEGER NOT NULL DEFAULT 0,
    single_num INTEGER NOT NULL DEFAULT 0,
    weight decimal(10, 2) NOT NULL DEFAULT 0.00,
    is_points_gift SMALLINT NOT NULL DEFAULT 1,
    is_points_discount SMALLINT NOT NULL DEFAULT 1,
    max_points_discount INTEGER NOT NULL DEFAULT 0,
    is_comment SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_goods" IS '商品主表';
COMMENT ON COLUMN "mall_goods"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "mall_goods"."goods_no" IS '商品编码';
COMMENT ON COLUMN "mall_goods"."name" IS '商品名称';
COMMENT ON COLUMN "mall_goods"."subtitle" IS '商品副标题/卖点';
COMMENT ON COLUMN "mall_goods"."category_id" IS '主分类ID';
COMMENT ON COLUMN "mall_goods"."spec_type" IS '1=单规格,2=多规格';
COMMENT ON COLUMN "mall_goods"."deduct_stock_type" IS '1=下单减库存,2=付款减库存';
COMMENT ON COLUMN "mall_goods"."main_image" IS '主图URL';
COMMENT ON COLUMN "mall_goods"."content" IS '商品详情(富文本)';
COMMENT ON COLUMN "mall_goods"."status" IS '1=上架,2=仓库中,3=回收站';
COMMENT ON COLUMN "mall_goods"."sort" IS '排序';
COMMENT ON COLUMN "mall_goods"."sales_actual" IS '实际销量';
COMMENT ON COLUMN "mall_goods"."sales_virtual" IS '虚拟销量';
COMMENT ON COLUMN "mall_goods"."view_count" IS '浏览量';
COMMENT ON COLUMN "mall_goods"."is_virtual" IS '0=实物,1=虚拟商品';
COMMENT ON COLUMN "mall_goods"."virtual_auto" IS '虚拟商品是否自动发货 0=否,1=是';
COMMENT ON COLUMN "mall_goods"."virtual_content" IS '虚拟商品内容(自动发货时)';
COMMENT ON COLUMN "mall_goods"."delivery_id" IS '运费模板ID';
COMMENT ON COLUMN "mall_goods"."limit_num" IS '限购数量,0=不限';
COMMENT ON COLUMN "mall_goods"."single_num" IS '起购数量,0=不限';
COMMENT ON COLUMN "mall_goods"."weight" IS '重量(Kg,运费计算)';
COMMENT ON COLUMN "mall_goods"."is_points_gift" IS '1=赠送积分,0=否';
COMMENT ON COLUMN "mall_goods"."is_points_discount" IS '1=允许积分抵扣,0=否';
COMMENT ON COLUMN "mall_goods"."max_points_discount" IS '最大积分抵扣数量';
COMMENT ON COLUMN "mall_goods"."is_comment" IS '1=允许评价,0=否';
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "mall_goods" (tenant_id ASC, status ASC, sort ASC);
CREATE INDEX IF NOT EXISTS "idx_category" ON "mall_goods" (category_id ASC);

CREATE TABLE IF NOT EXISTS "mall_goods_category" (

    id BIGSERIAL,
    goods_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_goods_category" IS '商品-分类关联';
COMMENT ON COLUMN "mall_goods_category"."goods_id" IS '商品ID';
COMMENT ON COLUMN "mall_goods_category"."category_id" IS '分类ID';
CREATE INDEX IF NOT EXISTS "idx_category" ON "mall_goods_category" (category_id ASC);

CREATE TABLE IF NOT EXISTS "mall_goods_image" (

    id BIGSERIAL,
    goods_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL DEFAULT '',
    image_type SMALLINT NOT NULL DEFAULT 0,
    sort SMALLINT NOT NULL DEFAULT 100,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_goods_image" IS '商品图片';
COMMENT ON COLUMN "mall_goods_image"."goods_id" IS '商品ID';
COMMENT ON COLUMN "mall_goods_image"."image_url" IS '图片URL';
COMMENT ON COLUMN "mall_goods_image"."image_type" IS '0=主图,1=详情图';
COMMENT ON COLUMN "mall_goods_image"."sort" IS '排序';
CREATE INDEX IF NOT EXISTS "idx_goods" ON "mall_goods_image" (goods_id ASC, sort ASC);

CREATE TABLE IF NOT EXISTS "mall_goods_sku" (

    id BIGSERIAL,
    goods_id BIGINT NOT NULL,
    sku_no VARCHAR(64) NOT NULL DEFAULT '',
    spec_values VARCHAR(255) NOT NULL DEFAULT '',
    spec_value_ids VARCHAR(255) NOT NULL DEFAULT '',
    image VARCHAR(255) NOT NULL DEFAULT '',
    price decimal(12, 2) NOT NULL DEFAULT 0.00,
    line_price decimal(12, 2) NOT NULL DEFAULT 0.00,
    cost_price decimal(12, 2) NOT NULL DEFAULT 0.00,
    stock INTEGER NOT NULL DEFAULT 0,
    stock_lock INTEGER NOT NULL DEFAULT 0,
    weight decimal(10, 2) NOT NULL DEFAULT 0.00,
    barcode VARCHAR(64) NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_goods_sku" IS '商品SKU';
COMMENT ON COLUMN "mall_goods_sku"."goods_id" IS '商品ID';
COMMENT ON COLUMN "mall_goods_sku"."sku_no" IS 'SKU编码';
COMMENT ON COLUMN "mall_goods_sku"."spec_values" IS '规格值组合(如: 颜色:红;尺码:XL)';
COMMENT ON COLUMN "mall_goods_sku"."spec_value_ids" IS '规格值ID组合(逗号分隔,排序后)';
COMMENT ON COLUMN "mall_goods_sku"."image" IS 'SKU图片';
COMMENT ON COLUMN "mall_goods_sku"."price" IS '销售价';
COMMENT ON COLUMN "mall_goods_sku"."line_price" IS '划线价(原价)';
COMMENT ON COLUMN "mall_goods_sku"."cost_price" IS '成本价';
COMMENT ON COLUMN "mall_goods_sku"."stock" IS '库存';
COMMENT ON COLUMN "mall_goods_sku"."stock_lock" IS '锁定库存(已下单未付款)';
COMMENT ON COLUMN "mall_goods_sku"."weight" IS '重量(Kg)';
COMMENT ON COLUMN "mall_goods_sku"."barcode" IS '条形码';
CREATE INDEX IF NOT EXISTS "idx_goods" ON "mall_goods_sku" (goods_id ASC);

CREATE TABLE IF NOT EXISTS "mall_goods_spec_rel" (

    id BIGSERIAL,
    goods_id BIGINT NOT NULL,
    spec_id BIGINT NOT NULL,
    spec_value_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_goods_spec_rel" IS '商品-规格值关联';
COMMENT ON COLUMN "mall_goods_spec_rel"."goods_id" IS '商品ID';
COMMENT ON COLUMN "mall_goods_spec_rel"."spec_id" IS '规格组ID';
COMMENT ON COLUMN "mall_goods_spec_rel"."spec_value_id" IS '规格值ID';
CREATE INDEX IF NOT EXISTS "idx_goods" ON "mall_goods_spec_rel" (goods_id ASC);

CREATE TABLE IF NOT EXISTS "mall_spec" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(60) NOT NULL DEFAULT '',
    sort SMALLINT NOT NULL DEFAULT 100,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_spec" IS '商品规格组';
COMMENT ON COLUMN "mall_spec"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "mall_spec"."name" IS '规格组名称(如:颜色)';
COMMENT ON COLUMN "mall_spec"."sort" IS '排序';
CREATE INDEX IF NOT EXISTS "idx_tenant" ON "mall_spec" (tenant_id ASC);

CREATE TABLE IF NOT EXISTS "mall_spec_value" (

    id BIGSERIAL,
    spec_id BIGINT NOT NULL,
    value VARCHAR(120) NOT NULL DEFAULT '',
    sort SMALLINT NOT NULL DEFAULT 100,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_spec_value" IS '商品规格值';
COMMENT ON COLUMN "mall_spec_value"."spec_id" IS '规格组ID';
COMMENT ON COLUMN "mall_spec_value"."value" IS '规格值(如:香槟金)';
COMMENT ON COLUMN "mall_spec_value"."sort" IS '排序';
CREATE INDEX IF NOT EXISTS "idx_spec" ON "mall_spec_value" (spec_id ASC);

CREATE TABLE IF NOT EXISTS "mall_user_coupon" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    coupon_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL DEFAULT 0,
    coupon_type SMALLINT NOT NULL DEFAULT 1,
    reduce_price decimal(12, 2) NOT NULL DEFAULT 0.00,
    discount SMALLINT NOT NULL DEFAULT 0,
    min_price decimal(12, 2) NOT NULL DEFAULT 0.00,
    max_discount_price decimal(12, 2) NOT NULL DEFAULT 0.00,
    expire_type SMALLINT NOT NULL DEFAULT 1,
    expire_day SMALLINT NOT NULL DEFAULT 0,
    start_time TIMESTAMP DEFAULT NULL,
    end_time TIMESTAMP DEFAULT NULL,
    apply_range SMALLINT NOT NULL DEFAULT 1,
    status SMALLINT NOT NULL DEFAULT 1,
    used_at TIMESTAMP DEFAULT NULL,
    used_order_id BIGINT NOT NULL DEFAULT 0,
    received_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mall_user_coupon" IS '用户优惠券实例';
COMMENT ON COLUMN "mall_user_coupon"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "mall_user_coupon"."coupon_id" IS '优惠券ID';
COMMENT ON COLUMN "mall_user_coupon"."user_id" IS 'C端用户ID c_user.id';
COMMENT ON COLUMN "mall_user_coupon"."member_id" IS '商户会员ID c_member.id';
COMMENT ON COLUMN "mall_user_coupon"."coupon_type" IS '1=满减,2=折扣(冗余防JOIN)';
COMMENT ON COLUMN "mall_user_coupon"."reduce_price" IS '满减金额(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."discount" IS '折扣率(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."min_price" IS '最低消费(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."max_discount_price" IS '最多抵扣(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."expire_type" IS '有效期类型(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."expire_day" IS '有效天数(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."start_time" IS '固定开始(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."end_time" IS '固定结束(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."apply_range" IS '适用范围(冗余)';
COMMENT ON COLUMN "mall_user_coupon"."status" IS '1=可使用,2=已使用,3=已过期,4=已作废';
COMMENT ON COLUMN "mall_user_coupon"."used_at" IS '使用时间';
COMMENT ON COLUMN "mall_user_coupon"."used_order_id" IS '使用的订单ID';
COMMENT ON COLUMN "mall_user_coupon"."received_at" IS '领取时间';
CREATE INDEX IF NOT EXISTS "idx_user_status" ON "mall_user_coupon" (user_id ASC, status ASC, end_time ASC);
CREATE INDEX IF NOT EXISTS "idx_member_status" ON "mall_user_coupon" (member_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_coupon" ON "mall_user_coupon" (coupon_id ASC);

CREATE TABLE IF NOT EXISTS "migrations" (

    id BIGSERIAL,
    migration VARCHAR(255) NOT NULL,
    batch INTEGER NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "mmc_department" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(50) NOT NULL,
    parent_id BIGINT NOT NULL DEFAULT 0,
    path VARCHAR(500) NOT NULL DEFAULT '',
    level SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_department" IS 'Merchant部门';
CREATE INDEX IF NOT EXISTS "idx_tenant_parent" ON "mmc_department" (tenant_id ASC, parent_id ASC, sort ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_path" ON "mmc_department" (tenant_id ASC, path(200);

CREATE TABLE IF NOT EXISTS "mmc_dept_leader" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    dept_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_dept_leader" IS 'Merchant部门领导';
CREATE INDEX IF NOT EXISTS "idx_tenant" ON "mmc_dept_leader" (tenant_id ASC);

CREATE TABLE IF NOT EXISTS "mmc_login_log" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    user_id BIGINT NOT NULL DEFAULT 0,
    username VARCHAR(50) NOT NULL,
    ip VARCHAR(45) DEFAULT NULL,
    os VARCHAR(255) DEFAULT NULL,
    browser VARCHAR(255) DEFAULT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    message VARCHAR(50) DEFAULT NULL,
    login_time TIMESTAMP NOT NULL,
    remark VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_login_log" IS 'MMC 端登录日志';
COMMENT ON COLUMN "mmc_login_log"."tenant_id" IS '商户租户ID';
COMMENT ON COLUMN "mmc_login_log"."user_id" IS '指向 mmc_user.id';
CREATE INDEX IF NOT EXISTS "idx_tenant_user_time" ON "mmc_login_log" (tenant_id ASC, user_id ASC, login_time ASC);
CREATE INDEX IF NOT EXISTS "idx_username" ON "mmc_login_log" (username ASC);

CREATE TABLE IF NOT EXISTS "mmc_menu" (

    id BIGSERIAL,
    parent_id BIGINT NOT NULL DEFAULT 0,
    name VARCHAR(50) NOT NULL DEFAULT '',
    type SMALLINT NOT NULL DEFAULT 2,
    permission_key VARCHAR(100) NOT NULL DEFAULT '',
    meta json NULL,
    path VARCHAR(60) NOT NULL DEFAULT '',
    component VARCHAR(150) NOT NULL DEFAULT '',
    redirect VARCHAR(100) NOT NULL DEFAULT '',
    status SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(60) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_menu" IS 'Merchant端菜单(全局共享)';
COMMENT ON COLUMN "mmc_menu"."type" IS '1=目录,2=菜单,3=按钮';
CREATE INDEX IF NOT EXISTS "idx_parent" ON "mmc_menu" (parent_id ASC, sort ASC);

CREATE TABLE IF NOT EXISTS "mmc_operation_log" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    user_id BIGINT NOT NULL DEFAULT 0,
    username VARCHAR(50) NOT NULL,
    method VARCHAR(20) NOT NULL,
    router VARCHAR(500) NOT NULL,
    service_name VARCHAR(30) NOT NULL,
    ip VARCHAR(45) DEFAULT NULL,
    created_at timestamp DEFAULT NULL,
    updated_at timestamp DEFAULT NULL,
    remark VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_operation_log" IS 'MMC 端操作日志';
COMMENT ON COLUMN "mmc_operation_log"."user_id" IS '指向 mmc_user.id';
CREATE INDEX IF NOT EXISTS "idx_tenant_user_time" ON "mmc_operation_log" (tenant_id ASC, user_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_username" ON "mmc_operation_log" (username ASC);

CREATE TABLE IF NOT EXISTS "mmc_package" (

    id BIGSERIAL,
    owner_type VARCHAR(10) NOT NULL,
    owner_tenant_id BIGINT NOT NULL DEFAULT 0,
    package_name VARCHAR(50) NOT NULL,
    package_code VARCHAR(50) NOT NULL,
    applicable_type VARCHAR(20) NOT NULL DEFAULT 'merchant',
    source_template_id BIGINT NOT NULL DEFAULT 0,
    account_count INTEGER NOT NULL DEFAULT 50,
    description VARCHAR(255) NOT NULL DEFAULT '',
    status SMALLINT NOT NULL DEFAULT 1,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_package" IS '商户套餐表';
COMMENT ON COLUMN "mmc_package"."owner_type" IS 'system=平台标准模板,tmc=TMC自定义';
COMMENT ON COLUMN "mmc_package"."owner_tenant_id" IS 'TMC租户ID,system=0';
COMMENT ON COLUMN "mmc_package"."applicable_type" IS '应用对象:merchant=商户/distributor=分销商/all=通用';
COMMENT ON COLUMN "mmc_package"."source_template_id" IS '派生自哪个system模板,0=完全自建';
COMMENT ON COLUMN "mmc_package"."account_count" IS '账号数量上限';
COMMENT ON COLUMN "mmc_package"."status" IS '1=启用,2=停用';
CREATE INDEX IF NOT EXISTS "idx_owner_status" ON "mmc_package" (owner_type ASC, owner_tenant_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_template" ON "mmc_package" (source_template_id ASC);

CREATE TABLE IF NOT EXISTS "mmc_package_menu" (

    id BIGSERIAL,
    package_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_package_menu" IS '商户套餐-菜单关联';
COMMENT ON COLUMN "mmc_package_menu"."menu_id" IS '指向 mmc_menu.id';
CREATE INDEX IF NOT EXISTS "idx_menu" ON "mmc_package_menu" (menu_id ASC);

CREATE TABLE IF NOT EXISTS "mmc_position" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(50) NOT NULL,
    dept_id BIGINT NOT NULL,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_position" IS 'Merchant岗位';
CREATE INDEX IF NOT EXISTS "idx_tenant_dept" ON "mmc_position" (tenant_id ASC, dept_id ASC);

CREATE TABLE IF NOT EXISTS "mmc_role" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(30) NOT NULL,
    code VARCHAR(100) NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_role" IS 'Merchant角色';
COMMENT ON COLUMN "mmc_role"."tenant_id" IS '商户ID';
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "mmc_role" (tenant_id ASC, status ASC);

CREATE TABLE IF NOT EXISTS "mmc_role_menu" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_role_menu" IS 'Merchant角色-菜单';
CREATE INDEX IF NOT EXISTS "idx_tenant" ON "mmc_role_menu" (tenant_id ASC);
CREATE INDEX IF NOT EXISTS "idx_menu" ON "mmc_role_menu" (menu_id ASC);

CREATE TABLE IF NOT EXISTS "mmc_user" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    nickname VARCHAR(30) NOT NULL DEFAULT '',
    employee_no VARCHAR(50) NOT NULL DEFAULT '',
    phone VARCHAR(20) DEFAULT NULL,
    phone_encrypted varbinary(255) DEFAULT NULL,
    phone_hash CHAR(64) DEFAULT NULL,
    email VARCHAR(80) DEFAULT NULL,
    email_encrypted varbinary(255) DEFAULT NULL,
    email_hash CHAR(64) DEFAULT NULL,
    avatar VARCHAR(255) NOT NULL DEFAULT '',
    signed VARCHAR(255) NOT NULL DEFAULT '',
    is_owner SMALLINT NOT NULL DEFAULT 2,
    status SMALLINT NOT NULL DEFAULT 1,
    enable_2fa SMALLINT NOT NULL DEFAULT 2,
    pwd_error_count SMALLINT NOT NULL DEFAULT 0,
    locked_until TIMESTAMP DEFAULT NULL,
    password_updated_at TIMESTAMP DEFAULT NULL,
    login_ip VARCHAR(45) NOT NULL DEFAULT '',
    login_time timestamp DEFAULT NULL,
    backend_setting json NULL,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_user" IS 'MMC 端用户表(商户/分销商)';
COMMENT ON COLUMN "mmc_user"."tenant_id" IS '商户/分销商租户ID';
COMMENT ON COLUMN "mmc_user"."username" IS '用户名(商户内唯一)';
COMMENT ON COLUMN "mmc_user"."password" IS '密码';
COMMENT ON COLUMN "mmc_user"."phone_encrypted" IS '手机号密文';
COMMENT ON COLUMN "mmc_user"."phone_hash" IS '手机号HMAC';
COMMENT ON COLUMN "mmc_user"."email_encrypted" IS '邮箱密文';
COMMENT ON COLUMN "mmc_user"."email_hash" IS '邮箱HMAC';
COMMENT ON COLUMN "mmc_user"."is_owner" IS '是否商户主管理员:1=是,2=否';
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "mmc_user" (tenant_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_phone_hash" ON "mmc_user" (phone_hash ASC);
CREATE INDEX IF NOT EXISTS "idx_email_hash" ON "mmc_user" (email_hash ASC);

CREATE TABLE IF NOT EXISTS "mmc_user_dept" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    dept_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_user_dept" IS 'Merchant用户-部门';
CREATE INDEX IF NOT EXISTS "idx_dept" ON "mmc_user_dept" (dept_id ASC);

CREATE TABLE IF NOT EXISTS "mmc_user_position" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    position_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_user_position" IS 'Merchant用户-岗位';
CREATE INDEX IF NOT EXISTS "idx_position" ON "mmc_user_position" (position_id ASC);

CREATE TABLE IF NOT EXISTS "mmc_user_role" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "mmc_user_role" IS 'Merchant用户-角色';
CREATE INDEX IF NOT EXISTS "idx_user" ON "mmc_user_role" (user_id ASC);
CREATE INDEX IF NOT EXISTS "idx_role" ON "mmc_user_role" (role_id ASC);

CREATE TABLE IF NOT EXISTS "order" (

    id BIGSERIAL,
    order_no VARCHAR(32) NOT NULL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    business_types VARCHAR(100) NULL DEFAULT '',
    order_type VARCHAR(20) NULL DEFAULT 'normal',
    parent_order_id BIGINT NULL DEFAULT 0,
    split_from_item_ids json NULL,
    split_version SMALLINT NULL DEFAULT 1,
    status SMALLINT NOT NULL DEFAULT 1,
    sales_count SMALLINT NULL DEFAULT 0,
    item_count SMALLINT NULL DEFAULT 0,
    passenger_count SMALLINT NULL DEFAULT 0,
    total_amount decimal(12, 2) NULL DEFAULT 0.00,
    paid_amount decimal(12, 2) NULL DEFAULT 0.00,
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    change_diff decimal(12, 2) NULL DEFAULT 0.00,
    service_fee decimal(12, 2) NULL DEFAULT 0.00,
    insurance_fee decimal(12, 2) NULL DEFAULT 0.00,
    currency VARCHAR(3) NULL DEFAULT 'CNY',
    contact_name VARCHAR(30) NULL DEFAULT '',
    contact_phone VARCHAR(20) NULL DEFAULT '',
    payment_method VARCHAR(20) NULL DEFAULT '',
    payment_time TIMESTAMP DEFAULT NULL,
    payment_no VARCHAR(64) NULL DEFAULT '',
    delivery_type SMALLINT NOT NULL DEFAULT 0,
    coupon_id BIGINT NOT NULL DEFAULT 0,
    coupon_amount decimal(12, 2) NOT NULL DEFAULT 0.00,
    points_used INTEGER NOT NULL DEFAULT 0,
    points_amount decimal(12, 2) NOT NULL DEFAULT 0.00,
    buyer_remark VARCHAR(500) NOT NULL DEFAULT '',
    source VARCHAR(20) NULL DEFAULT 'mini',
    channel_id BIGINT NULL DEFAULT 0,
    contract_id BIGINT NULL DEFAULT 0,
    group_id BIGINT NULL DEFAULT 0,
    remark VARCHAR(500) NULL DEFAULT '',
    internal_remark VARCHAR(500) NULL DEFAULT '',
    task_id BIGINT NULL DEFAULT 0,
    ip VARCHAR(45) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order" IS '主订单(大订单)';
COMMENT ON COLUMN "order"."order_no" IS '订单号(如: HX20250701123456)';
COMMENT ON COLUMN "order"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order"."member_id" IS 'c_member.id';
COMMENT ON COLUMN "order"."user_id" IS 'c_user.id(冗余,跨商户查询)';
COMMENT ON COLUMN "order"."business_types" IS '涉及业务类型(逗号分隔): flight,train,hotel,mall';
COMMENT ON COLUMN "order"."order_type" IS 'normal=普通/group=团购/corporate=大客户/gp=公务员';
COMMENT ON COLUMN "order"."parent_order_id" IS '父订单ID(拆单溯源,0=原始订单)';
COMMENT ON COLUMN "order"."split_from_item_ids" IS '拆单来源item IDs(从原订单拆出的item)';
COMMENT ON COLUMN "order"."split_version" IS '拆单版本(1=原始,>1=被拆过)';
COMMENT ON COLUMN "order"."status" IS '1=待支付,2=已支付/处理中,3=部分完成,4=全部完成,5=已取消,6=部分退改,7=已关闭';
COMMENT ON COLUMN "order"."sales_count" IS '销售业务订单数';
COMMENT ON COLUMN "order"."item_count" IS '子订单总数';
COMMENT ON COLUMN "order"."passenger_count" IS '旅客人数';
COMMENT ON COLUMN "order"."total_amount" IS '订单总金额';
COMMENT ON COLUMN "order"."paid_amount" IS '实付金额';
COMMENT ON COLUMN "order"."refund_amount" IS '累计退款金额';
COMMENT ON COLUMN "order"."change_diff" IS '累计改签差价(正=补价,负=退差)';
COMMENT ON COLUMN "order"."service_fee" IS '服务费合计';
COMMENT ON COLUMN "order"."insurance_fee" IS '保险费合计';
COMMENT ON COLUMN "order"."currency" IS '币种';
COMMENT ON COLUMN "order"."contact_name" IS '联系人姓名';
COMMENT ON COLUMN "order"."contact_phone" IS '联系人手机';
COMMENT ON COLUMN "order"."payment_method" IS '支付方式: wechat/alipay/balance/credit/mixed';
COMMENT ON COLUMN "order"."payment_time" IS '支付时间';
COMMENT ON COLUMN "order"."payment_no" IS '支付流水号';
COMMENT ON COLUMN "order"."delivery_type" IS '0=无(机票/酒店),1=快递,2=自提,3=无需物流';
COMMENT ON COLUMN "order"."coupon_id" IS '优惠券ID';
COMMENT ON COLUMN "order"."coupon_amount" IS '优惠券抵扣金额';
COMMENT ON COLUMN "order"."points_used" IS '使用积分数量';
COMMENT ON COLUMN "order"."points_amount" IS '积分抵扣金额';
COMMENT ON COLUMN "order"."buyer_remark" IS '买家留言';
COMMENT ON COLUMN "order"."source" IS '下单来源: mini/web/h5/app/ota/api';
COMMENT ON COLUMN "order"."channel_id" IS '分销渠道ID(分销商场景)';
COMMENT ON COLUMN "order"."contract_id" IS '大客户签约ID(大客户订单关联 corporate_contract.id)';
COMMENT ON COLUMN "order"."group_id" IS '大客户集团ID(冗余, corporate_group.id)';
COMMENT ON COLUMN "order"."remark" IS '客户备注';
COMMENT ON COLUMN "order"."internal_remark" IS '内部备注(仅B端可见)';
COMMENT ON COLUMN "order"."task_id" IS '关联任务ID service_task.id(代客下单时关联)';
COMMENT ON COLUMN "order"."ip" IS '下单IP';
CREATE INDEX IF NOT EXISTS "idx_tenant_member" ON "order" (tenant_id ASC, member_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_user" ON "order" (user_id ASC);
CREATE INDEX IF NOT EXISTS "idx_parent" ON "order" (parent_order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_contract" ON "order" (contract_id ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "order" (group_id ASC);
CREATE INDEX IF NOT EXISTS "idx_created" ON "order" (created_at ASC);

CREATE TABLE IF NOT EXISTS "order_change" (

    id BIGSERIAL,
    change_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    biz_type VARCHAR(20) NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    origin_item_ids json NOT NULL,
    new_item_ids json NULL,
    change_reason VARCHAR(20) NULL DEFAULT '',
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    change_fee decimal(12, 2) NULL DEFAULT 0.00,
    change_diff decimal(12, 2) NULL DEFAULT 0.00,
    refund_to VARCHAR(20) NULL DEFAULT 'original',
    apply_at TIMESTAMP DEFAULT NULL,
    confirm_at TIMESTAMP DEFAULT NULL,
    complete_at TIMESTAMP DEFAULT NULL,
    operator_type VARCHAR(20) NULL DEFAULT 'member',
    operator_id BIGINT NULL DEFAULT 0,
    remark VARCHAR(500) NULL DEFAULT '',
    internal_remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_change" IS '订单变更记录(退/改/签)';
COMMENT ON COLUMN "order_change"."change_no" IS '变更单号(如: HX20250701123456-C001)';
COMMENT ON COLUMN "order_change"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_change"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "order_change"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_change"."member_id" IS 'c_member.id';
COMMENT ON COLUMN "order_change"."change_type" IS 'refund=退票/change=改签/endorse=签转/cancel=取消(酒店)';
COMMENT ON COLUMN "order_change"."biz_type" IS 'flight/train/hotel';
COMMENT ON COLUMN "order_change"."status" IS '1=待审核,2=处理中,3=已完成,4=已拒绝,5=已取消';
COMMENT ON COLUMN "order_change"."origin_item_ids" IS '原item ID列表(按biz_type对应不同表)';
COMMENT ON COLUMN "order_change"."new_item_ids" IS '新item ID列表(仅改签产生新item)';
COMMENT ON COLUMN "order_change"."change_reason" IS '变更原因: voluntary=自愿/force=航司取消/weather=天气/schedule_change=航班变动';
COMMENT ON COLUMN "order_change"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "order_change"."change_fee" IS '变更手续费';
COMMENT ON COLUMN "order_change"."change_diff" IS '改签差价(正=补价,负=退差)';
COMMENT ON COLUMN "order_change"."refund_to" IS '退款去向: original=原路退回/balance=退到钱包';
COMMENT ON COLUMN "order_change"."apply_at" IS '申请时间';
COMMENT ON COLUMN "order_change"."confirm_at" IS '确认时间';
COMMENT ON COLUMN "order_change"."complete_at" IS '完成时间';
COMMENT ON COLUMN "order_change"."operator_type" IS 'member=用户申请/admin=后台操作/system=系统自动';
COMMENT ON COLUMN "order_change"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "order_change"."internal_remark" IS '内部备注(仅B端)';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_change" (order_id ASC, change_type ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "order_change" (sales_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order_change" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_member" ON "order_change" (member_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_type_status" ON "order_change" (biz_type ASC, change_type ASC, status ASC);

CREATE TABLE IF NOT EXISTS "order_item_car" (

    id BIGSERIAL,
    item_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    member_id BIGINT NULL DEFAULT 0,
    product_id BIGINT NULL DEFAULT 0,
    product_snapshot json NULL,
    item_amount decimal(12, 2) NULL DEFAULT 0.00,
    paid_amount decimal(12, 2) NULL DEFAULT 0.00,
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    service_fee decimal(12, 2) NULL DEFAULT 0.00,
    car_type VARCHAR(20) NULL DEFAULT '',
    car_model VARCHAR(30) NULL DEFAULT '',
    car_brand VARCHAR(30) NULL DEFAULT '',
    plate_no VARCHAR(20) NULL DEFAULT '',
    driver_name VARCHAR(30) NULL DEFAULT '',
    driver_phone VARCHAR(20) NULL DEFAULT '',
    pickup_city_code VARCHAR(20) NULL DEFAULT '',
    pickup_city_name VARCHAR(30) NULL DEFAULT '',
    pickup_address VARCHAR(300) NULL DEFAULT '',
    pickup_time TIMESTAMP NOT NULL,
    dropoff_city_code VARCHAR(20) NULL DEFAULT '',
    dropoff_city_name VARCHAR(30) NULL DEFAULT '',
    dropoff_address VARCHAR(300) NULL DEFAULT '',
    dropoff_time TIMESTAMP DEFAULT NULL,
    passenger_name VARCHAR(30) NULL DEFAULT '',
    passenger_phone VARCHAR(20) NULL DEFAULT '',
    flight_no VARCHAR(10) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    effective_at TIMESTAMP DEFAULT NULL,
    expire_at TIMESTAMP DEFAULT NULL,
    cancel_deadline TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_item_car" IS '用车子订单(单次行程=最小操作单元)';
COMMENT ON COLUMN "order_item_car"."item_no" IS '子订单号';
COMMENT ON COLUMN "order_item_car"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_item_car"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "order_item_car"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_item_car"."status" IS '1=待确认,2=已确认,3=进行中,4=已完成,5=取消中,6=已取消,7=预订失败';
COMMENT ON COLUMN "order_item_car"."member_id" IS '会员ID c_member.id';
COMMENT ON COLUMN "order_item_car"."product_id" IS '产品ID';
COMMENT ON COLUMN "order_item_car"."product_snapshot" IS '产品快照';
COMMENT ON COLUMN "order_item_car"."item_amount" IS '子订单金额';
COMMENT ON COLUMN "order_item_car"."paid_amount" IS '实付金额';
COMMENT ON COLUMN "order_item_car"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "order_item_car"."service_fee" IS '服务费';
COMMENT ON COLUMN "order_item_car"."car_type" IS '用车类型: airport_pickup=接机/airport_dropoff=送机/city_transfer=市内接送/daily_rent=日租/hourly_rent=时租';
COMMENT ON COLUMN "order_item_car"."car_model" IS '车型: economy=经济型/comfort=舒适型/business=商务型/luxury=豪华型';
COMMENT ON COLUMN "order_item_car"."car_brand" IS '车辆品牌(如: 帕萨特)';
COMMENT ON COLUMN "order_item_car"."plate_no" IS '车牌号(派车后回填)';
COMMENT ON COLUMN "order_item_car"."driver_name" IS '司机姓名(派车后回填)';
COMMENT ON COLUMN "order_item_car"."driver_phone" IS '司机电话(派车后回填)';
COMMENT ON COLUMN "order_item_car"."pickup_city_code" IS '上车城市编码';
COMMENT ON COLUMN "order_item_car"."pickup_city_name" IS '上车城市名';
COMMENT ON COLUMN "order_item_car"."pickup_address" IS '上车地址';
COMMENT ON COLUMN "order_item_car"."pickup_time" IS '上车时间';
COMMENT ON COLUMN "order_item_car"."dropoff_city_code" IS '下车城市编码';
COMMENT ON COLUMN "order_item_car"."dropoff_city_name" IS '下车城市名';
COMMENT ON COLUMN "order_item_car"."dropoff_address" IS '下车地址';
COMMENT ON COLUMN "order_item_car"."dropoff_time" IS '下车时间(完成后回填)';
COMMENT ON COLUMN "order_item_car"."passenger_name" IS '乘车人姓名(快照)';
COMMENT ON COLUMN "order_item_car"."passenger_phone" IS '乘车人手机(快照)';
COMMENT ON COLUMN "order_item_car"."flight_no" IS '关联航班号(接送机时)';
COMMENT ON COLUMN "order_item_car"."remark" IS '备注';
COMMENT ON COLUMN "order_item_car"."effective_at" IS '生效时间(上车时间)';
COMMENT ON COLUMN "order_item_car"."expire_at" IS '失效时间(下车时间)';
COMMENT ON COLUMN "order_item_car"."cancel_deadline" IS '免费取消截止时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_item_car" (order_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "order_item_car" (sales_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order_item_car" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_pickup_date" ON "order_item_car" (pickup_city_code ASC, pickup_time ASC);
CREATE INDEX IF NOT EXISTS "idx_effective" ON "order_item_car" (effective_at ASC);

CREATE TABLE IF NOT EXISTS "order_item_flight" (

    id BIGSERIAL,
    item_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    parent_item_id BIGINT NULL DEFAULT 0,
    change_id BIGINT NULL DEFAULT 0,
    member_id BIGINT NULL DEFAULT 0,
    passenger_id BIGINT NULL DEFAULT 0,
    passenger_name VARCHAR(30) NULL DEFAULT '',
    passenger_id_type SMALLINT DEFAULT NULL,
    passenger_id_no VARCHAR(30) NULL DEFAULT '',
    product_id BIGINT NULL DEFAULT 0,
    product_snapshot json NULL,
    unit_price decimal(12, 2) NULL DEFAULT 0.00,
    item_amount decimal(12, 2) NULL DEFAULT 0.00,
    paid_amount decimal(12, 2) NULL DEFAULT 0.00,
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    change_fee decimal(12, 2) NULL DEFAULT 0.00,
    service_fee decimal(12, 2) NULL DEFAULT 0.00,
    insurance_fee decimal(12, 2) NULL DEFAULT 0.00,
    journey_id BIGINT NULL DEFAULT 0,
    journey_index SMALLINT NULL DEFAULT 0,
    flight_type VARCHAR(10) NOT NULL,
    ticket_no VARCHAR(50) NULL DEFAULT '',
    carrier_code CHAR(2) NOT NULL,
    flight_no VARCHAR(10) NOT NULL,
    share_flight_no VARCHAR(10) NULL DEFAULT '',
    departure_code CHAR(3) NOT NULL,
    departure_name VARCHAR(30) NULL DEFAULT '',
    arrival_code CHAR(3) NOT NULL,
    arrival_name VARCHAR(30) NULL DEFAULT '',
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    cabin_class VARCHAR(5) NOT NULL,
    cabin_code VARCHAR(10) NULL DEFAULT '',
    cabin_name VARCHAR(20) NULL DEFAULT '',
    aircraft_type VARCHAR(20) NULL DEFAULT '',
    meal VARCHAR(10) NULL DEFAULT '',
    stop_count SMALLINT NULL DEFAULT 0,
    free_baggage VARCHAR(20) NULL DEFAULT '',
    refund_rule VARCHAR(200) NULL DEFAULT '',
    change_rule VARCHAR(200) NULL DEFAULT '',
    effective_at TIMESTAMP DEFAULT NULL,
    expire_at TIMESTAMP DEFAULT NULL,
    cancel_deadline TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_item_flight" IS '机票子订单(人×程=最小操作单元)';
COMMENT ON COLUMN "order_item_flight"."item_no" IS '子订单号(如: HX20250701123456-001)';
COMMENT ON COLUMN "order_item_flight"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_item_flight"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "order_item_flight"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_item_flight"."status" IS '1=待处理,2=处理中,3=已出票,4=已使用,5=退票中,6=已退票,7=改签中,8=已改签,9=已取消,10=出票失败';
COMMENT ON COLUMN "order_item_flight"."parent_item_id" IS '改签关联: 改签后新item指向原item,0=原始item';
COMMENT ON COLUMN "order_item_flight"."change_id" IS '变更单ID(退/改/签)';
COMMENT ON COLUMN "order_item_flight"."member_id" IS '会员ID c_member.id';
COMMENT ON COLUMN "order_item_flight"."passenger_id" IS '旅客ID c_passenger.id';
COMMENT ON COLUMN "order_item_flight"."passenger_name" IS '旅客姓名(下单快照)';
COMMENT ON COLUMN "order_item_flight"."passenger_id_type" IS '旅客证件类型(快照): 1=身份证,2=护照...';
COMMENT ON COLUMN "order_item_flight"."passenger_id_no" IS '旅客证件号(快照脱敏)';
COMMENT ON COLUMN "order_item_flight"."product_id" IS '产品ID';
COMMENT ON COLUMN "order_item_flight"."product_snapshot" IS '产品快照(下单时票价/舱位/规则等)';
COMMENT ON COLUMN "order_item_flight"."unit_price" IS '票价';
COMMENT ON COLUMN "order_item_flight"."item_amount" IS '子订单金额(票价+机建+燃油)';
COMMENT ON COLUMN "order_item_flight"."paid_amount" IS '实付金额';
COMMENT ON COLUMN "order_item_flight"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "order_item_flight"."change_fee" IS '改签手续费';
COMMENT ON COLUMN "order_item_flight"."service_fee" IS '服务费';
COMMENT ON COLUMN "order_item_flight"."insurance_fee" IS '保险费';
COMMENT ON COLUMN "order_item_flight"."journey_id" IS '行程ID(同一次行程的多程item共享,0=无关联)';
COMMENT ON COLUMN "order_item_flight"."journey_index" IS '行程序号(第几程,0=无关联,1=第一段,2=第二段...)';
COMMENT ON COLUMN "order_item_flight"."flight_type" IS '航程类型: departure=去程/return=回程/oneway=单程/transit=中转';
COMMENT ON COLUMN "order_item_flight"."ticket_no" IS '票号(出票后回填,如: 999-1234567890)';
COMMENT ON COLUMN "order_item_flight"."carrier_code" IS '承运航司二字码(如: CA)';
COMMENT ON COLUMN "order_item_flight"."flight_no" IS '航班号(如: CA1234)';
COMMENT ON COLUMN "order_item_flight"."share_flight_no" IS '共享航班号(如有)';
COMMENT ON COLUMN "order_item_flight"."departure_code" IS '出发机场三字码(如: PEK)';
COMMENT ON COLUMN "order_item_flight"."departure_name" IS '出发城市/机场名';
COMMENT ON COLUMN "order_item_flight"."arrival_code" IS '到达机场三字码(如: SHA)';
COMMENT ON COLUMN "order_item_flight"."arrival_name" IS '到达城市/机场名';
COMMENT ON COLUMN "order_item_flight"."departure_time" IS '起飞时间';
COMMENT ON COLUMN "order_item_flight"."arrival_time" IS '降落时间';
COMMENT ON COLUMN "order_item_flight"."cabin_class" IS '舱位等级: Y=经济/C=公务/F=头等';
COMMENT ON COLUMN "order_item_flight"."cabin_code" IS '子舱位编码(如: Y/B/M/K)';
COMMENT ON COLUMN "order_item_flight"."cabin_name" IS '舱位中文名(如: 经济舱)';
COMMENT ON COLUMN "order_item_flight"."aircraft_type" IS '机型(如: 737-800)';
COMMENT ON COLUMN "order_item_flight"."meal" IS '餐食: M=餐/B=轻食/N=无';
COMMENT ON COLUMN "order_item_flight"."stop_count" IS '经停次数';
COMMENT ON COLUMN "order_item_flight"."free_baggage" IS '免费行李额(如: 20KG)';
COMMENT ON COLUMN "order_item_flight"."refund_rule" IS '退票规则摘要(快照)';
COMMENT ON COLUMN "order_item_flight"."change_rule" IS '改签规则摘要(快照)';
COMMENT ON COLUMN "order_item_flight"."effective_at" IS '生效时间(起飞时间)';
COMMENT ON COLUMN "order_item_flight"."expire_at" IS '失效时间(降落时间)';
COMMENT ON COLUMN "order_item_flight"."cancel_deadline" IS '免费取消截止时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_item_flight" (order_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "order_item_flight" (sales_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_journey" ON "order_item_flight" (journey_id ASC, journey_index ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order_item_flight" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_passenger" ON "order_item_flight" (passenger_id ASC);
CREATE INDEX IF NOT EXISTS "idx_parent_item" ON "order_item_flight" (parent_item_id ASC);
CREATE INDEX IF NOT EXISTS "idx_ticket_no" ON "order_item_flight" (ticket_no ASC);
CREATE INDEX IF NOT EXISTS "idx_carrier_flight" ON "order_item_flight" (carrier_code ASC, flight_no ASC, departure_time ASC);
CREATE INDEX IF NOT EXISTS "idx_route" ON "order_item_flight" (departure_code ASC, arrival_code ASC, departure_time ASC);
CREATE INDEX IF NOT EXISTS "idx_effective" ON "order_item_flight" (effective_at ASC);

CREATE TABLE IF NOT EXISTS "order_item_hotel" (

    id BIGSERIAL,
    item_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    change_id BIGINT NULL DEFAULT 0,
    member_id BIGINT NULL DEFAULT 0,
    product_id BIGINT NULL DEFAULT 0,
    product_snapshot json NULL,
    unit_price decimal(12, 2) NULL DEFAULT 0.00,
    item_amount decimal(12, 2) NULL DEFAULT 0.00,
    paid_amount decimal(12, 2) NULL DEFAULT 0.00,
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    service_fee decimal(12, 2) NULL DEFAULT 0.00,
    insurance_fee decimal(12, 2) NULL DEFAULT 0.00,
    cost_price decimal(12, 2) NULL DEFAULT 0.00,
    confirmation_no VARCHAR(50) NULL DEFAULT '',
    hotel_id BIGINT NULL DEFAULT 0,
    hotel_name VARCHAR(100) NULL DEFAULT '',
    room_type_id BIGINT NULL DEFAULT 0,
    room_type_name VARCHAR(50) NULL DEFAULT '',
    city_code VARCHAR(20) NULL DEFAULT '',
    city_name VARCHAR(30) NULL DEFAULT '',
    address VARCHAR(300) NULL DEFAULT '',
    star_rate SMALLINT NULL DEFAULT 0,
    check_in_date date NOT NULL,
    check_out_date date NOT NULL,
    nights SMALLINT NULL DEFAULT 1,
    room_count SMALLINT NULL DEFAULT 1,
    breakfast VARCHAR(20) NULL DEFAULT '',
    bed_type VARCHAR(20) NULL DEFAULT '',
    cancel_policy VARCHAR(200) NULL DEFAULT '',
    supplier_type VARCHAR(30) NULL DEFAULT '',
    supplier_hotel_id VARCHAR(50) NULL DEFAULT '',
    supplier_room_id VARCHAR(50) NULL DEFAULT '',
    supplier_order_no VARCHAR(64) NULL DEFAULT '',
    guest_name VARCHAR(30) NULL DEFAULT '',
    guest_phone VARCHAR(20) NULL DEFAULT '',
    guest_id_type SMALLINT DEFAULT NULL,
    guest_id_no VARCHAR(30) NULL DEFAULT '',
    special_request VARCHAR(500) NULL DEFAULT '',
    effective_at TIMESTAMP DEFAULT NULL,
    expire_at TIMESTAMP DEFAULT NULL,
    cancel_deadline TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_item_hotel" IS '酒店子订单(人×晚×间=最小操作单元)';
COMMENT ON COLUMN "order_item_hotel"."item_no" IS '子订单号';
COMMENT ON COLUMN "order_item_hotel"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_item_hotel"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "order_item_hotel"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_item_hotel"."status" IS '1=待确认,2=处理中,3=已确认,4=已入住,5=取消中,6=已取消,7=已退房,8=预订失败';
COMMENT ON COLUMN "order_item_hotel"."change_id" IS '变更单ID(取消/修改)';
COMMENT ON COLUMN "order_item_hotel"."member_id" IS '会员ID c_member.id';
COMMENT ON COLUMN "order_item_hotel"."product_id" IS '产品ID';
COMMENT ON COLUMN "order_item_hotel"."product_snapshot" IS '产品快照';
COMMENT ON COLUMN "order_item_hotel"."unit_price" IS '每晚房价';
COMMENT ON COLUMN "order_item_hotel"."item_amount" IS '子订单金额(房价×晚数×间数)';
COMMENT ON COLUMN "order_item_hotel"."paid_amount" IS '实付金额';
COMMENT ON COLUMN "order_item_hotel"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "order_item_hotel"."service_fee" IS '服务费';
COMMENT ON COLUMN "order_item_hotel"."insurance_fee" IS '保险费';
COMMENT ON COLUMN "order_item_hotel"."cost_price" IS '采购成本单价';
COMMENT ON COLUMN "order_item_hotel"."confirmation_no" IS '酒店确认号(确认后回填)';
COMMENT ON COLUMN "order_item_hotel"."hotel_id" IS '酒店ID';
COMMENT ON COLUMN "order_item_hotel"."hotel_name" IS '酒店名称';
COMMENT ON COLUMN "order_item_hotel"."room_type_id" IS '房型ID';
COMMENT ON COLUMN "order_item_hotel"."room_type_name" IS '房型名称(如: 高级大床房)';
COMMENT ON COLUMN "order_item_hotel"."city_code" IS '城市编码';
COMMENT ON COLUMN "order_item_hotel"."city_name" IS '城市名';
COMMENT ON COLUMN "order_item_hotel"."address" IS '酒店地址';
COMMENT ON COLUMN "order_item_hotel"."star_rate" IS '星级(1-5)';
COMMENT ON COLUMN "order_item_hotel"."check_in_date" IS '入住日期';
COMMENT ON COLUMN "order_item_hotel"."check_out_date" IS '离店日期';
COMMENT ON COLUMN "order_item_hotel"."nights" IS '晚数';
COMMENT ON COLUMN "order_item_hotel"."room_count" IS '房间数';
COMMENT ON COLUMN "order_item_hotel"."breakfast" IS '早餐: 无/单早/双早';
COMMENT ON COLUMN "order_item_hotel"."bed_type" IS '床型: 大床/双床/大/双';
COMMENT ON COLUMN "order_item_hotel"."cancel_policy" IS '取消政策摘要(快照)';
COMMENT ON COLUMN "order_item_hotel"."supplier_type" IS '供应商类型: ota_ctrip/ota_meituan/ota_fligy/hotel_direct';
COMMENT ON COLUMN "order_item_hotel"."supplier_hotel_id" IS '供应商侧酒店ID';
COMMENT ON COLUMN "order_item_hotel"."supplier_room_id" IS '供应商侧房型ID';
COMMENT ON COLUMN "order_item_hotel"."supplier_order_no" IS '供应商订单号(确认后回填)';
COMMENT ON COLUMN "order_item_hotel"."guest_name" IS '入住人姓名(快照)';
COMMENT ON COLUMN "order_item_hotel"."guest_phone" IS '入住人手机(快照)';
COMMENT ON COLUMN "order_item_hotel"."guest_id_type" IS '入住人证件类型(快照): 1=身份证,2=护照...';
COMMENT ON COLUMN "order_item_hotel"."guest_id_no" IS '入住人证件号(快照脱敏)';
COMMENT ON COLUMN "order_item_hotel"."special_request" IS '特殊要求(如: 无烟房/高楼层/加床)';
COMMENT ON COLUMN "order_item_hotel"."effective_at" IS '生效时间(入住日)';
COMMENT ON COLUMN "order_item_hotel"."expire_at" IS '失效时间(离店日)';
COMMENT ON COLUMN "order_item_hotel"."cancel_deadline" IS '免费取消截止时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_item_hotel" (order_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "order_item_hotel" (sales_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order_item_hotel" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_hotel_date" ON "order_item_hotel" (hotel_id ASC, check_in_date ASC);
CREATE INDEX IF NOT EXISTS "idx_effective" ON "order_item_hotel" (effective_at ASC);

CREATE TABLE IF NOT EXISTS "order_item_insurance" (

    id BIGSERIAL,
    item_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    member_id BIGINT NULL DEFAULT 0,
    passenger_id BIGINT NULL DEFAULT 0,
    insured_name VARCHAR(30) NOT NULL,
    insured_id_type SMALLINT DEFAULT NULL,
    insured_id_no VARCHAR(30) NULL DEFAULT '',
    product_id BIGINT NOT NULL,
    product_snapshot json NULL,
    premium decimal(10, 2) NOT NULL,
    paid_amount decimal(10, 2) NULL DEFAULT 0.00,
    refund_amount decimal(10, 2) NULL DEFAULT 0.00,
    policy_no VARCHAR(50) NULL DEFAULT '',
    effective_at TIMESTAMP DEFAULT NULL,
    expire_at TIMESTAMP DEFAULT NULL,
    related_biz_type VARCHAR(20) NULL DEFAULT '',
    related_item_id BIGINT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_item_insurance" IS '保险子订单(按被保人+产品=最小操作单元)';
COMMENT ON COLUMN "order_item_insurance"."item_no" IS '子订单号';
COMMENT ON COLUMN "order_item_insurance"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_item_insurance"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "order_item_insurance"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_item_insurance"."status" IS '1=待生效,2=已生效,3=已失效,4=退保中,5=已退保,6=已取消';
COMMENT ON COLUMN "order_item_insurance"."member_id" IS '会员ID c_member.id';
COMMENT ON COLUMN "order_item_insurance"."passenger_id" IS '旅客ID c_passenger.id(关联出行人)';
COMMENT ON COLUMN "order_item_insurance"."insured_name" IS '被保险人姓名(快照)';
COMMENT ON COLUMN "order_item_insurance"."insured_id_type" IS '被保险人证件类型(快照): 1=身份证,2=护照...';
COMMENT ON COLUMN "order_item_insurance"."insured_id_no" IS '被保险人证件号(快照脱敏)';
COMMENT ON COLUMN "order_item_insurance"."product_id" IS '保险产品ID insurance_product.id';
COMMENT ON COLUMN "order_item_insurance"."product_snapshot" IS '产品快照(名称/保费/保额/条款等)';
COMMENT ON COLUMN "order_item_insurance"."premium" IS '保费';
COMMENT ON COLUMN "order_item_insurance"."paid_amount" IS '实付金额';
COMMENT ON COLUMN "order_item_insurance"."refund_amount" IS '退保金额';
COMMENT ON COLUMN "order_item_insurance"."policy_no" IS '保单号(生效后回填)';
COMMENT ON COLUMN "order_item_insurance"."effective_at" IS '生效时间';
COMMENT ON COLUMN "order_item_insurance"."expire_at" IS '失效时间';
COMMENT ON COLUMN "order_item_insurance"."related_biz_type" IS '关联业务类型: flight/train/hotel(与哪类出行绑定)';
COMMENT ON COLUMN "order_item_insurance"."related_item_id" IS '关联子订单ID(绑定的机票/火车票item)';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_item_insurance" (order_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "order_item_insurance" (sales_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order_item_insurance" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_passenger" ON "order_item_insurance" (passenger_id ASC);
CREATE INDEX IF NOT EXISTS "idx_policy_no" ON "order_item_insurance" (policy_no ASC);
CREATE INDEX IF NOT EXISTS "idx_effective" ON "order_item_insurance" (effective_at ASC);

CREATE TABLE IF NOT EXISTS "order_item_mall" (

    id BIGSERIAL,
    item_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    member_id BIGINT NULL DEFAULT 0,
    product_id BIGINT NOT NULL DEFAULT 0,
    product_snapshot json NULL,
    unit_price decimal(12, 2) NULL DEFAULT 0.00,
    quantity SMALLINT NULL DEFAULT 1,
    item_amount decimal(12, 2) NULL DEFAULT 0.00,
    paid_amount decimal(12, 2) NULL DEFAULT 0.00,
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    after_sale_status SMALLINT NOT NULL DEFAULT 0,
    coupon_id BIGINT NOT NULL DEFAULT 0,
    coupon_amount decimal(12, 2) NOT NULL DEFAULT 0.00,
    delivery_type SMALLINT NOT NULL DEFAULT 1,
    express_id BIGINT NOT NULL DEFAULT 0,
    buyer_remark VARCHAR(255) NOT NULL DEFAULT '',
    service_fee decimal(12, 2) NULL DEFAULT 0.00,
    goods_name VARCHAR(200) NOT NULL DEFAULT '',
    sku_id BIGINT NULL DEFAULT 0,
    sku_attrs VARCHAR(200) NULL DEFAULT '',
    points_used INTEGER NULL DEFAULT 0,
    points_amount decimal(12, 2) NULL DEFAULT 0.00,
    address_id BIGINT NULL DEFAULT 0,
    logistics_no VARCHAR(50) NULL DEFAULT '',
    logistics_company VARCHAR(30) NULL DEFAULT '',
    shipped_at TIMESTAMP DEFAULT NULL,
    received_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_item_mall" IS '商城子订单(商品件=最小操作单元)';
COMMENT ON COLUMN "order_item_mall"."item_no" IS '子订单号';
COMMENT ON COLUMN "order_item_mall"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_item_mall"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "order_item_mall"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_item_mall"."status" IS '1=待发货,2=已发货,3=已收货,4=退货中,5=已退货,6=已取消';
COMMENT ON COLUMN "order_item_mall"."member_id" IS '会员ID c_member.id';
COMMENT ON COLUMN "order_item_mall"."product_id" IS '商品ID mall_goods.id';
COMMENT ON COLUMN "order_item_mall"."product_snapshot" IS '商品快照(名称/图片/规格等)';
COMMENT ON COLUMN "order_item_mall"."unit_price" IS '单价';
COMMENT ON COLUMN "order_item_mall"."quantity" IS '数量';
COMMENT ON COLUMN "order_item_mall"."item_amount" IS '子订单金额';
COMMENT ON COLUMN "order_item_mall"."paid_amount" IS '实付金额';
COMMENT ON COLUMN "order_item_mall"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "order_item_mall"."after_sale_status" IS '0=无售后,1=售后中,2=售后完成';
COMMENT ON COLUMN "order_item_mall"."coupon_id" IS '使用的优惠券ID mall_user_coupon.id';
COMMENT ON COLUMN "order_item_mall"."coupon_amount" IS '优惠券抵扣金额';
COMMENT ON COLUMN "order_item_mall"."delivery_type" IS '1=快递配送,2=上门自提,3=无需物流';
COMMENT ON COLUMN "order_item_mall"."express_id" IS '快递公司ID mall_express.id';
COMMENT ON COLUMN "order_item_mall"."buyer_remark" IS '买家备注';
COMMENT ON COLUMN "order_item_mall"."service_fee" IS '服务费';
COMMENT ON COLUMN "order_item_mall"."goods_name" IS '商品名称(快照)';
COMMENT ON COLUMN "order_item_mall"."sku_id" IS 'SKU ID';
COMMENT ON COLUMN "order_item_mall"."sku_attrs" IS 'SKU属性(如: 颜色:红;尺码:XL)';
COMMENT ON COLUMN "order_item_mall"."points_used" IS '使用积分数';
COMMENT ON COLUMN "order_item_mall"."points_amount" IS '积分抵扣金额';
COMMENT ON COLUMN "order_item_mall"."address_id" IS '收货地址ID c_member_address.id';
COMMENT ON COLUMN "order_item_mall"."logistics_no" IS '物流单号';
COMMENT ON COLUMN "order_item_mall"."logistics_company" IS '物流公司';
COMMENT ON COLUMN "order_item_mall"."shipped_at" IS '发货时间';
COMMENT ON COLUMN "order_item_mall"."received_at" IS '收货时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_item_mall" (order_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "order_item_mall" (sales_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order_item_mall" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_address" ON "order_item_mall" (address_id ASC);

CREATE TABLE IF NOT EXISTS "order_item_status_log" (

    id BIGSERIAL,
    item_type VARCHAR(20) NOT NULL,
    item_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    from_status SMALLINT NOT NULL,
    to_status SMALLINT NOT NULL,
    trigger_type VARCHAR(20) NULL DEFAULT '',
    trigger_id BIGINT NULL DEFAULT 0,
    operator_type VARCHAR(20) NULL DEFAULT '',
    operator_id BIGINT NULL DEFAULT 0,
    operator_name VARCHAR(30) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_item_status_log" IS '子订单状态变更日志(出票/退改/发货等全追踪)';
COMMENT ON COLUMN "order_item_status_log"."item_type" IS '子订单类型: flight/train/hotel/mall/insurance/car';
COMMENT ON COLUMN "order_item_status_log"."item_id" IS '子订单ID(指向对应item表)';
COMMENT ON COLUMN "order_item_status_log"."order_id" IS '主订单ID(冗余,便于查询)';
COMMENT ON COLUMN "order_item_status_log"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "order_item_status_log"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_item_status_log"."from_status" IS '原状态';
COMMENT ON COLUMN "order_item_status_log"."to_status" IS '新状态';
COMMENT ON COLUMN "order_item_status_log"."trigger_type" IS '触发类型: purchase_confirm/ticket_issue/refund_apply/refund_confirm/change_apply/change_confirm/cancel/ship/receive/system';
COMMENT ON COLUMN "order_item_status_log"."trigger_id" IS '触发ID(如procure_item_id/change_id/after_sale_id)';
COMMENT ON COLUMN "order_item_status_log"."operator_type" IS '操作人类型: member/admin/system/cron';
COMMENT ON COLUMN "order_item_status_log"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "order_item_status_log"."operator_name" IS '操作人姓名';
COMMENT ON COLUMN "order_item_status_log"."remark" IS '备注(如出票失败原因)';
COMMENT ON COLUMN "order_item_status_log"."created_at" IS '变更时间';
CREATE INDEX IF NOT EXISTS "idx_item" ON "order_item_status_log" (item_type ASC, item_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_item_status_log" (order_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_type" ON "order_item_status_log" (tenant_id ASC, item_type ASC, to_status ASC, created_at ASC);

CREATE TABLE IF NOT EXISTS "order_item_train" (

    id BIGSERIAL,
    item_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    parent_item_id BIGINT NULL DEFAULT 0,
    change_id BIGINT NULL DEFAULT 0,
    member_id BIGINT NULL DEFAULT 0,
    passenger_id BIGINT NULL DEFAULT 0,
    passenger_name VARCHAR(30) NULL DEFAULT '',
    passenger_id_type SMALLINT DEFAULT NULL,
    passenger_id_no VARCHAR(30) NULL DEFAULT '',
    product_id BIGINT NULL DEFAULT 0,
    product_snapshot json NULL,
    unit_price decimal(12, 2) NULL DEFAULT 0.00,
    item_amount decimal(12, 2) NULL DEFAULT 0.00,
    paid_amount decimal(12, 2) NULL DEFAULT 0.00,
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    change_fee decimal(12, 2) NULL DEFAULT 0.00,
    service_fee decimal(12, 2) NULL DEFAULT 0.00,
    cost_price decimal(12, 2) NULL DEFAULT 0.00,
    cancel_rule VARCHAR(200) NULL DEFAULT '',
    insurance_fee decimal(12, 2) NULL DEFAULT 0.00,
    ticket_no VARCHAR(50) NULL DEFAULT '',
    train_no VARCHAR(20) NOT NULL,
    train_type VARCHAR(10) NULL DEFAULT '',
    departure_code VARCHAR(20) NOT NULL,
    departure_name VARCHAR(30) NULL DEFAULT '',
    arrival_code VARCHAR(20) NOT NULL,
    arrival_name VARCHAR(30) NULL DEFAULT '',
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    duration INTEGER NULL DEFAULT 0,
    seat_type VARCHAR(20) NOT NULL,
    seat_code VARCHAR(10) NULL DEFAULT '',
    carriage_no VARCHAR(10) NULL DEFAULT '',
    seat_no VARCHAR(10) NULL DEFAULT '',
    supplier_order_no VARCHAR(64) NULL DEFAULT '',
    is_student SMALLINT NULL DEFAULT 2,
    effective_at TIMESTAMP DEFAULT NULL,
    expire_at TIMESTAMP DEFAULT NULL,
    cancel_deadline TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_item_train" IS '火车票子订单(人×程=最小操作单元)';
COMMENT ON COLUMN "order_item_train"."item_no" IS '子订单号';
COMMENT ON COLUMN "order_item_train"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_item_train"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "order_item_train"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_item_train"."status" IS '1=待处理,2=处理中,3=已出票,4=已使用,5=退票中,6=已退票,7=改签中,8=已改签,9=已取消,10=出票失败';
COMMENT ON COLUMN "order_item_train"."parent_item_id" IS '改签关联: 改签后新item指向原item,0=原始item';
COMMENT ON COLUMN "order_item_train"."change_id" IS '变更单ID';
COMMENT ON COLUMN "order_item_train"."member_id" IS '会员ID c_member.id';
COMMENT ON COLUMN "order_item_train"."passenger_id" IS '旅客ID c_passenger.id';
COMMENT ON COLUMN "order_item_train"."passenger_name" IS '旅客姓名(快照)';
COMMENT ON COLUMN "order_item_train"."passenger_id_type" IS '旅客证件类型(快照)';
COMMENT ON COLUMN "order_item_train"."passenger_id_no" IS '旅客证件号(快照脱敏)';
COMMENT ON COLUMN "order_item_train"."product_id" IS '产品ID';
COMMENT ON COLUMN "order_item_train"."product_snapshot" IS '产品快照';
COMMENT ON COLUMN "order_item_train"."unit_price" IS '票价';
COMMENT ON COLUMN "order_item_train"."item_amount" IS '子订单金额';
COMMENT ON COLUMN "order_item_train"."paid_amount" IS '实付金额';
COMMENT ON COLUMN "order_item_train"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "order_item_train"."change_fee" IS '改签手续费';
COMMENT ON COLUMN "order_item_train"."service_fee" IS '服务费';
COMMENT ON COLUMN "order_item_train"."cost_price" IS '采购成本单价';
COMMENT ON COLUMN "order_item_train"."cancel_rule" IS '退改规则摘要(快照)';
COMMENT ON COLUMN "order_item_train"."insurance_fee" IS '保险费';
COMMENT ON COLUMN "order_item_train"."ticket_no" IS '火车票号(出票后回填)';
COMMENT ON COLUMN "order_item_train"."train_no" IS '车次(如: G101)';
COMMENT ON COLUMN "order_item_train"."train_type" IS '列车类型(如: G/D/C/Z/T/K)';
COMMENT ON COLUMN "order_item_train"."departure_code" IS '出发站编码';
COMMENT ON COLUMN "order_item_train"."departure_name" IS '出发站名';
COMMENT ON COLUMN "order_item_train"."arrival_code" IS '到达站编码';
COMMENT ON COLUMN "order_item_train"."arrival_name" IS '到达站名';
COMMENT ON COLUMN "order_item_train"."departure_time" IS '出发时间';
COMMENT ON COLUMN "order_item_train"."arrival_time" IS '到达时间';
COMMENT ON COLUMN "order_item_train"."duration" IS '行程时长(分钟)';
COMMENT ON COLUMN "order_item_train"."seat_type" IS '座位类型(如: 二等座/一等座/商务座/硬卧/软卧)';
COMMENT ON COLUMN "order_item_train"."seat_code" IS '座位编码';
COMMENT ON COLUMN "order_item_train"."carriage_no" IS '车厢号(出票后)';
COMMENT ON COLUMN "order_item_train"."seat_no" IS '座位号(出票后)';
COMMENT ON COLUMN "order_item_train"."supplier_order_no" IS '供应商订单号(12306出票后回填)';
COMMENT ON COLUMN "order_item_train"."is_student" IS '1=学生票,2=成人票';
COMMENT ON COLUMN "order_item_train"."effective_at" IS '生效时间(出发时间)';
COMMENT ON COLUMN "order_item_train"."expire_at" IS '失效时间(到达时间)';
COMMENT ON COLUMN "order_item_train"."cancel_deadline" IS '免费取消截止时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_item_train" (order_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "order_item_train" (sales_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order_item_train" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_passenger" ON "order_item_train" (passenger_id ASC);
CREATE INDEX IF NOT EXISTS "idx_parent_item" ON "order_item_train" (parent_item_id ASC);
CREATE INDEX IF NOT EXISTS "idx_ticket_no" ON "order_item_train" (ticket_no ASC);
CREATE INDEX IF NOT EXISTS "idx_train_date" ON "order_item_train" (train_no ASC, departure_time ASC);
CREATE INDEX IF NOT EXISTS "idx_effective" ON "order_item_train" (effective_at ASC);

CREATE TABLE IF NOT EXISTS "order_procure_item" (

    id BIGSERIAL,
    procurement_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    biz_type VARCHAR(20) NOT NULL,
    sales_item_id BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    cost_price decimal(12, 2) NULL DEFAULT 0.00,
    cost_amount decimal(12, 2) NULL DEFAULT 0.00,
    settle_amount decimal(12, 2) NULL DEFAULT 0.00,
    supplier_ticket_no VARCHAR(50) NULL DEFAULT '',
    supplier_pnr VARCHAR(30) NULL DEFAULT '',
    fail_reason VARCHAR(500) NULL DEFAULT '',
    retry_count SMALLINT NULL DEFAULT 0,
    next_retry_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_procure_item" IS '采购子订单(关联销售item,按渠道出票)';
COMMENT ON COLUMN "order_procure_item"."procurement_id" IS '采购业务订单ID';
COMMENT ON COLUMN "order_procure_item"."order_id" IS '主订单ID(冗余)';
COMMENT ON COLUMN "order_procure_item"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_procure_item"."biz_type" IS '业务类型: flight/train/hotel/mall';
COMMENT ON COLUMN "order_procure_item"."sales_item_id" IS '关联销售子订单ID(按biz_type指向对应表)';
COMMENT ON COLUMN "order_procure_item"."status" IS '1=待采购,2=采购中,3=已出票/已确认,4=采购失败,5=已取消';
COMMENT ON COLUMN "order_procure_item"."cost_price" IS '采购成本单价';
COMMENT ON COLUMN "order_procure_item"."cost_amount" IS '采购总金额';
COMMENT ON COLUMN "order_procure_item"."settle_amount" IS '已结算金额';
COMMENT ON COLUMN "order_procure_item"."supplier_ticket_no" IS '供应商票号/确认号(出票后回填)';
COMMENT ON COLUMN "order_procure_item"."supplier_pnr" IS '航司PNR(机票采购)';
COMMENT ON COLUMN "order_procure_item"."fail_reason" IS '失败原因';
COMMENT ON COLUMN "order_procure_item"."retry_count" IS '重试次数';
COMMENT ON COLUMN "order_procure_item"."next_retry_at" IS '下次重试时间';
CREATE INDEX IF NOT EXISTS "idx_procurement" ON "order_procure_item" (procurement_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_sales_item" ON "order_procure_item" (biz_type ASC, sales_item_id ASC);
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_procure_item" (order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant" ON "order_procure_item" (tenant_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_status_retry" ON "order_procure_item" (status ASC, next_retry_at ASC);

CREATE TABLE IF NOT EXISTS "order_procurement" (

    id BIGSERIAL,
    procurement_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    biz_type VARCHAR(20) NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    staff_id BIGINT NULL DEFAULT 0,
    staff_name VARCHAR(30) NULL DEFAULT '',
    item_count SMALLINT NULL DEFAULT 0,
    cost_amount decimal(12, 2) NULL DEFAULT 0.00,
    settle_amount decimal(12, 2) NULL DEFAULT 0.00,
    supplier_type VARCHAR(30) NOT NULL,
    supplier_id BIGINT NULL DEFAULT 0,
    supplier_name VARCHAR(50) NULL DEFAULT '',
    supplier_account VARCHAR(50) NULL DEFAULT '',
    supplier_order_no VARCHAR(64) NULL DEFAULT '',
    procure_at TIMESTAMP DEFAULT NULL,
    ticket_at TIMESTAMP DEFAULT NULL,
    fail_reason VARCHAR(500) NULL DEFAULT '',
    retry_count SMALLINT NULL DEFAULT 0,
    next_retry_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_procurement" IS '采购业务订单(按渠道拆分,绑采购员)';
COMMENT ON COLUMN "order_procurement"."procurement_no" IS '采购单号(如: HX20250701123456-P-CA01)';
COMMENT ON COLUMN "order_procurement"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_procurement"."sales_id" IS '来源销售业务订单ID';
COMMENT ON COLUMN "order_procurement"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_procurement"."biz_type" IS '业务类型: flight/train/hotel/mall';
COMMENT ON COLUMN "order_procurement"."status" IS '1=待采购,2=采购中,3=已出票/已确认,4=部分出票,5=采购失败,6=已取消';
COMMENT ON COLUMN "order_procurement"."staff_id" IS '采购员ID(指向 mmc_user.id)';
COMMENT ON COLUMN "order_procurement"."staff_name" IS '采购员姓名(冗余)';
COMMENT ON COLUMN "order_procurement"."item_count" IS '采购子订单数';
COMMENT ON COLUMN "order_procurement"."cost_amount" IS '采购成本金额';
COMMENT ON COLUMN "order_procurement"."settle_amount" IS '已结算金额';
COMMENT ON COLUMN "order_procurement"."supplier_type" IS '供应商类型: airline_b2b/airline_b2t/ota_ctrip/ota_qunar/ota_meituan/ota_fligy/railway_12306/hotel_supplier/mall_supplier';
COMMENT ON COLUMN "order_procurement"."supplier_id" IS '供应商ID';
COMMENT ON COLUMN "order_procurement"."supplier_name" IS '供应商名称';
COMMENT ON COLUMN "order_procurement"."supplier_account" IS '供应商账号(如航司B2B账号/携程代理账号)';
COMMENT ON COLUMN "order_procurement"."supplier_order_no" IS '供应商订单号(出票后回填)';
COMMENT ON COLUMN "order_procurement"."procure_at" IS '采购提交时间';
COMMENT ON COLUMN "order_procurement"."ticket_at" IS '出票/确认时间';
COMMENT ON COLUMN "order_procurement"."fail_reason" IS '失败原因';
COMMENT ON COLUMN "order_procurement"."retry_count" IS '重试次数';
COMMENT ON COLUMN "order_procurement"."next_retry_at" IS '下次重试时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_procurement" (order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_sales" ON "order_procurement" (sales_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_biz_status" ON "order_procurement" (tenant_id ASC, biz_type ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_staff" ON "order_procurement" (tenant_id ASC, staff_id ASC);
CREATE INDEX IF NOT EXISTS "idx_supplier" ON "order_procurement" (supplier_type ASC, supplier_order_no ASC);
CREATE INDEX IF NOT EXISTS "idx_status_retry" ON "order_procurement" (status ASC, next_retry_at ASC);

CREATE TABLE IF NOT EXISTS "order_sales" (

    id BIGSERIAL,
    sales_no VARCHAR(40) NOT NULL,
    order_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    biz_type VARCHAR(20) NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    staff_id BIGINT NULL DEFAULT 0,
    staff_name VARCHAR(30) NULL DEFAULT '',
    item_count SMALLINT NULL DEFAULT 0,
    passenger_count SMALLINT NULL DEFAULT 0,
    sales_amount decimal(12, 2) NULL DEFAULT 0.00,
    settle_amount decimal(12, 2) NULL DEFAULT 0.00,
    refund_amount decimal(12, 2) NULL DEFAULT 0.00,
    service_fee decimal(12, 2) NULL DEFAULT 0.00,
    insurance_fee decimal(12, 2) NULL DEFAULT 0.00,
    source VARCHAR(20) NULL DEFAULT 'mini',
    channel_id BIGINT NULL DEFAULT 0,
    contract_id BIGINT NULL DEFAULT 0,
    group_id BIGINT NULL DEFAULT 0,
    contact_name VARCHAR(30) NULL DEFAULT '',
    contact_phone VARCHAR(20) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    internal_remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_sales" IS '销售业务订单(按业务类型拆分,绑销售员)';
COMMENT ON COLUMN "order_sales"."sales_no" IS '销售单号(如: HX20250701123456-S-F001)';
COMMENT ON COLUMN "order_sales"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_sales"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_sales"."biz_type" IS '业务类型: flight/train/hotel/mall';
COMMENT ON COLUMN "order_sales"."status" IS '1=待处理,2=处理中,3=部分出票,4=全部完成,5=已取消,6=部分退改,7=出票失败待重采';
COMMENT ON COLUMN "order_sales"."staff_id" IS '销售员ID(指向 mmc_user.id)';
COMMENT ON COLUMN "order_sales"."staff_name" IS '销售员姓名(冗余)';
COMMENT ON COLUMN "order_sales"."item_count" IS '子订单数';
COMMENT ON COLUMN "order_sales"."passenger_count" IS '旅客人数';
COMMENT ON COLUMN "order_sales"."sales_amount" IS '销售金额(售价合计)';
COMMENT ON COLUMN "order_sales"."settle_amount" IS '已结算金额';
COMMENT ON COLUMN "order_sales"."refund_amount" IS '退款金额';
COMMENT ON COLUMN "order_sales"."service_fee" IS '服务费合计';
COMMENT ON COLUMN "order_sales"."insurance_fee" IS '保险费合计';
COMMENT ON COLUMN "order_sales"."source" IS '来源: mini/web/h5/app/ota/api';
COMMENT ON COLUMN "order_sales"."channel_id" IS '分销渠道ID';
COMMENT ON COLUMN "order_sales"."contract_id" IS '大客户签约ID(corporate_contract.id)';
COMMENT ON COLUMN "order_sales"."group_id" IS '大客户集团ID(冗余)';
COMMENT ON COLUMN "order_sales"."contact_name" IS '联系人';
COMMENT ON COLUMN "order_sales"."contact_phone" IS '联系电话';
COMMENT ON COLUMN "order_sales"."remark" IS '客户备注';
COMMENT ON COLUMN "order_sales"."internal_remark" IS '内部备注';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_sales" (order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_biz_status" ON "order_sales" (tenant_id ASC, biz_type ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_staff" ON "order_sales" (tenant_id ASC, staff_id ASC);
CREATE INDEX IF NOT EXISTS "idx_contract" ON "order_sales" (contract_id ASC);
CREATE INDEX IF NOT EXISTS "idx_group" ON "order_sales" (group_id ASC);

CREATE TABLE IF NOT EXISTS "order_status_log" (

    id BIGSERIAL,
    order_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    from_status SMALLINT NOT NULL,
    to_status SMALLINT NOT NULL,
    biz_type VARCHAR(20) NULL DEFAULT '',
    biz_id BIGINT NULL DEFAULT 0,
    operator_type VARCHAR(20) NULL DEFAULT '',
    operator_id BIGINT NULL DEFAULT 0,
    operator_name VARCHAR(30) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "order_status_log" IS '订单状态变更日志(全链路追踪)';
COMMENT ON COLUMN "order_status_log"."order_id" IS '主订单ID';
COMMENT ON COLUMN "order_status_log"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "order_status_log"."from_status" IS '原状态';
COMMENT ON COLUMN "order_status_log"."to_status" IS '新状态';
COMMENT ON COLUMN "order_status_log"."biz_type" IS '触发来源类型: order/item_flight/item_train/item_hotel/item_mall/payment/refund/change/system';
COMMENT ON COLUMN "order_status_log"."biz_id" IS '触发来源ID(如item_id/change_id/payment_id)';
COMMENT ON COLUMN "order_status_log"."operator_type" IS '操作人类型: member/admin/system/cron';
COMMENT ON COLUMN "order_status_log"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "order_status_log"."operator_name" IS '操作人姓名';
COMMENT ON COLUMN "order_status_log"."remark" IS '备注';
COMMENT ON COLUMN "order_status_log"."created_at" IS '变更时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "order_status_log" (order_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "order_status_log" (tenant_id ASC, to_status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_biz" ON "order_status_log" (biz_type ASC, biz_id ASC);

CREATE TABLE IF NOT EXISTS "payment_log" (

    id BIGSERIAL,
    payment_no VARCHAR(64) NOT NULL,
    order_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    pay_method VARCHAR(20) NOT NULL,
    pay_channel VARCHAR(30) NULL DEFAULT '',
    amount decimal(12, 2) NOT NULL,
    currency VARCHAR(3) NULL DEFAULT 'CNY',
    status SMALLINT NOT NULL DEFAULT 1,
    callback_status SMALLINT NULL DEFAULT 0,
    transaction_id VARCHAR(64) NULL DEFAULT '',
    callback_at TIMESTAMP DEFAULT NULL,
    callback_raw json NULL,
    retry_count SMALLINT NULL DEFAULT 0,
    next_retry_at TIMESTAMP DEFAULT NULL,
    expire_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "payment_log" IS '支付流水日志(全流程追踪+对账)';
COMMENT ON COLUMN "payment_log"."payment_no" IS '支付流水号(唯一)';
COMMENT ON COLUMN "payment_log"."order_id" IS '主订单ID';
COMMENT ON COLUMN "payment_log"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "payment_log"."member_id" IS 'c_member.id';
COMMENT ON COLUMN "payment_log"."pay_method" IS '支付方式: wechat/alipay/balance/credit/mixed';
COMMENT ON COLUMN "payment_log"."pay_channel" IS '支付渠道(微信JSAPI/微信H5/支付宝APP等)';
COMMENT ON COLUMN "payment_log"."amount" IS '支付金额';
COMMENT ON COLUMN "payment_log"."currency" IS '币种';
COMMENT ON COLUMN "payment_log"."status" IS '1=待支付,2=支付中,3=支付成功,4=支付失败,5=已关闭,6=已退款';
COMMENT ON COLUMN "payment_log"."callback_status" IS '回调状态: 0=未回调,1=成功,2=失败,3=重复回调';
COMMENT ON COLUMN "payment_log"."transaction_id" IS '第三方支付交易号(微信/支付宝返回)';
COMMENT ON COLUMN "payment_log"."callback_at" IS '回调时间';
COMMENT ON COLUMN "payment_log"."callback_raw" IS '回调原始报文(存档备查)';
COMMENT ON COLUMN "payment_log"."retry_count" IS '重试次数';
COMMENT ON COLUMN "payment_log"."next_retry_at" IS '下次重试时间';
COMMENT ON COLUMN "payment_log"."expire_at" IS '支付过期时间(超时未支付自动关闭)';
COMMENT ON COLUMN "payment_log"."created_at" IS '创建时间';
COMMENT ON COLUMN "payment_log"."updated_at" IS '更新时间';
CREATE INDEX IF NOT EXISTS "idx_order" ON "payment_log" (order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "payment_log" (tenant_id ASC, status ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_member" ON "payment_log" (member_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_transaction" ON "payment_log" (transaction_id ASC);
CREATE INDEX IF NOT EXISTS "idx_status_retry" ON "payment_log" (status ASC, next_retry_at ASC);

CREATE TABLE IF NOT EXISTS "pmc_department" (

    id BIGSERIAL,
    name VARCHAR(50) NOT NULL,
    parent_id BIGINT NOT NULL DEFAULT 0,
    path VARCHAR(500) NOT NULL DEFAULT '',
    level SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_department" IS 'SaaS部门';
COMMENT ON COLUMN "pmc_department"."path" IS '物化路径 /1/3/7/';
CREATE INDEX IF NOT EXISTS "idx_parent" ON "pmc_department" (parent_id ASC, sort ASC);
CREATE INDEX IF NOT EXISTS "idx_path" ON "pmc_department" (path(255);

CREATE TABLE IF NOT EXISTS "pmc_dept_leader" (

    id BIGSERIAL,
    dept_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_dept_leader" IS 'SaaS部门领导';

CREATE TABLE IF NOT EXISTS "pmc_login_log" (

    id BIGSERIAL,
    user_id BIGINT NOT NULL DEFAULT 0,
    username VARCHAR(50) NOT NULL,
    ip VARCHAR(45) DEFAULT NULL,
    os VARCHAR(255) DEFAULT NULL,
    browser VARCHAR(255) DEFAULT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    message VARCHAR(50) DEFAULT NULL,
    login_time TIMESTAMP NOT NULL,
    remark VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_login_log" IS 'PMC 端登录日志';
COMMENT ON COLUMN "pmc_login_log"."user_id" IS '指向 pmc_user.id';
COMMENT ON COLUMN "pmc_login_log"."status" IS '1=成功,2=失败';
CREATE INDEX IF NOT EXISTS "idx_user_time" ON "pmc_login_log" (user_id ASC, login_time ASC);
CREATE INDEX IF NOT EXISTS "idx_username" ON "pmc_login_log" (username ASC);

CREATE TABLE IF NOT EXISTS "pmc_menu" (

    id BIGSERIAL,
    parent_id BIGINT NOT NULL DEFAULT 0,
    name VARCHAR(50) NOT NULL DEFAULT '',
    type SMALLINT NOT NULL DEFAULT 2,
    permission_key VARCHAR(100) NOT NULL DEFAULT '',
    meta json NULL,
    path VARCHAR(60) NOT NULL DEFAULT '',
    component VARCHAR(150) NOT NULL DEFAULT '',
    redirect VARCHAR(100) NOT NULL DEFAULT '',
    status SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(60) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_menu" IS 'SaaS平台端菜单';
COMMENT ON COLUMN "pmc_menu"."type" IS '1=目录,2=菜单,3=按钮';
COMMENT ON COLUMN "pmc_menu"."permission_key" IS '权限标识 e.g. order:export';
CREATE INDEX IF NOT EXISTS "idx_parent" ON "pmc_menu" (parent_id ASC, sort ASC);

CREATE TABLE IF NOT EXISTS "pmc_operation_log" (

    id BIGSERIAL,
    user_id BIGINT NOT NULL DEFAULT 0,
    username VARCHAR(50) NOT NULL,
    method VARCHAR(20) NOT NULL,
    router VARCHAR(500) NOT NULL,
    service_name VARCHAR(30) NOT NULL,
    ip VARCHAR(45) DEFAULT NULL,
    created_at timestamp DEFAULT NULL,
    updated_at timestamp DEFAULT NULL,
    remark VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_operation_log" IS 'PMC 端操作日志';
COMMENT ON COLUMN "pmc_operation_log"."user_id" IS '指向 pmc_user.id';
CREATE INDEX IF NOT EXISTS "idx_user_time" ON "pmc_operation_log" (user_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_username" ON "pmc_operation_log" (username ASC);

CREATE TABLE IF NOT EXISTS "pmc_position" (

    id BIGSERIAL,
    name VARCHAR(50) NOT NULL,
    dept_id BIGINT NOT NULL,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_position" IS 'SaaS岗位';
CREATE INDEX IF NOT EXISTS "idx_dept" ON "pmc_position" (dept_id ASC);

CREATE TABLE IF NOT EXISTS "pmc_role" (

    id BIGSERIAL,
    name VARCHAR(30) NOT NULL,
    code VARCHAR(100) NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_role" IS 'SaaS平台端角色';

CREATE TABLE IF NOT EXISTS "pmc_role_menu" (

    id BIGSERIAL,
    role_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_role_menu" IS 'SaaS角色-菜单';
CREATE INDEX IF NOT EXISTS "idx_menu" ON "pmc_role_menu" (menu_id ASC);

CREATE TABLE IF NOT EXISTS "pmc_user" (

    id BIGSERIAL,
    username VARCHAR(20) NOT NULL,
    password VARCHAR(100) NOT NULL,
    nickname VARCHAR(30) NOT NULL DEFAULT '',
    phone VARCHAR(20) DEFAULT NULL,
    phone_encrypted varbinary(255) DEFAULT NULL,
    phone_hash CHAR(64) DEFAULT NULL,
    email VARCHAR(80) DEFAULT NULL,
    email_encrypted varbinary(255) DEFAULT NULL,
    email_hash CHAR(64) DEFAULT NULL,
    avatar VARCHAR(255) NOT NULL DEFAULT '',
    signed VARCHAR(255) NOT NULL DEFAULT '',
    status SMALLINT NOT NULL DEFAULT 1,
    enable_2fa SMALLINT NOT NULL DEFAULT 2,
    pwd_error_count SMALLINT NOT NULL DEFAULT 0,
    locked_until TIMESTAMP DEFAULT NULL,
    password_updated_at TIMESTAMP DEFAULT NULL,
    login_ip VARCHAR(45) NOT NULL DEFAULT '',
    login_time timestamp DEFAULT NULL,
    backend_setting json NULL,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_user" IS 'PMC 端用户表(平台内部员工)';
COMMENT ON COLUMN "pmc_user"."id" IS '用户ID,主键';
COMMENT ON COLUMN "pmc_user"."username" IS '用户名';
COMMENT ON COLUMN "pmc_user"."password" IS '密码';
COMMENT ON COLUMN "pmc_user"."nickname" IS '用户昵称';
COMMENT ON COLUMN "pmc_user"."phone" IS '手机号';
COMMENT ON COLUMN "pmc_user"."phone_encrypted" IS '手机号密文(AES-256-GCM,应用层加密)';
COMMENT ON COLUMN "pmc_user"."phone_hash" IS '手机号HMAC-SHA256(用于精确查找)';
COMMENT ON COLUMN "pmc_user"."email" IS '邮箱';
COMMENT ON COLUMN "pmc_user"."email_encrypted" IS '邮箱密文(AES-256-GCM)';
COMMENT ON COLUMN "pmc_user"."email_hash" IS '邮箱HMAC-SHA256';
COMMENT ON COLUMN "pmc_user"."avatar" IS '用户头像';
COMMENT ON COLUMN "pmc_user"."signed" IS '个人签名';
COMMENT ON COLUMN "pmc_user"."status" IS '状态:1=正常,2=停用';
COMMENT ON COLUMN "pmc_user"."enable_2fa" IS '是否启用2FA:1=是,2=否';
COMMENT ON COLUMN "pmc_user"."pwd_error_count" IS '连续密码错误次数';
COMMENT ON COLUMN "pmc_user"."locked_until" IS '锁定到此时间(NULL=未锁)';
COMMENT ON COLUMN "pmc_user"."password_updated_at" IS '密码上次修改时间';
COMMENT ON COLUMN "pmc_user"."login_ip" IS '最后登录IP';
COMMENT ON COLUMN "pmc_user"."login_time" IS '最后登录时间';
COMMENT ON COLUMN "pmc_user"."backend_setting" IS '后台设置数据';
COMMENT ON COLUMN "pmc_user"."created_by" IS '创建者';
COMMENT ON COLUMN "pmc_user"."updated_by" IS '更新者';
COMMENT ON COLUMN "pmc_user"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_phone_hash" ON "pmc_user" (phone_hash ASC);
CREATE INDEX IF NOT EXISTS "idx_email_hash" ON "pmc_user" (email_hash ASC);

CREATE TABLE IF NOT EXISTS "pmc_user_dept" (

    id BIGSERIAL,
    user_id BIGINT NOT NULL,
    dept_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_user_dept" IS 'PMC用户-部门';
CREATE INDEX IF NOT EXISTS "idx_dept" ON "pmc_user_dept" (dept_id ASC);

CREATE TABLE IF NOT EXISTS "pmc_user_position" (

    id BIGSERIAL,
    user_id BIGINT NOT NULL,
    position_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_user_position" IS 'PMC用户-岗位';
CREATE INDEX IF NOT EXISTS "idx_position" ON "pmc_user_position" (position_id ASC);

CREATE TABLE IF NOT EXISTS "pmc_user_role" (

    id BIGSERIAL,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "pmc_user_role" IS 'PMC用户-角色';
CREATE INDEX IF NOT EXISTS "idx_role" ON "pmc_user_role" (role_id ASC);

CREATE TABLE IF NOT EXISTS "rules" (

    id BIGSERIAL,
    ptype VARCHAR(8) NOT NULL DEFAULT '',
    v0 VARCHAR(100) NOT NULL DEFAULT '',
    v1 VARCHAR(100) NOT NULL DEFAULT '',
    v2 VARCHAR(100) NOT NULL DEFAULT '',
    v3 VARCHAR(50) NOT NULL DEFAULT '',
    v4 VARCHAR(50) NOT NULL DEFAULT '',
    v5 VARCHAR(50) NOT NULL DEFAULT '',
    created_at timestamp DEFAULT NULL,
    updated_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX IF NOT EXISTS "idx_ptype_v0_v1" ON "rules" (ptype ASC, v0 ASC, v1 ASC);
CREATE INDEX IF NOT EXISTS "idx_v1_v2" ON "rules" (v1 ASC, v2 ASC);

CREATE TABLE IF NOT EXISTS "service_task" (

    id BIGSERIAL,
    task_no VARCHAR(40) NOT NULL,
    tenant_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    sales_id BIGINT NULL DEFAULT 0,
    task_type VARCHAR(30) NOT NULL,
    task_status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    task_source VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
    priority SMALLINT NULL DEFAULT 2,
    assign_to BIGINT NULL DEFAULT 0,
    assign_name VARCHAR(30) NULL DEFAULT '',
    assign_at TIMESTAMP DEFAULT NULL,
    process_at TIMESTAMP DEFAULT NULL,
    close_at TIMESTAMP DEFAULT NULL,
    company_id BIGINT NULL DEFAULT 0,
    company_name VARCHAR(200) NULL DEFAULT '',
    contact_name VARCHAR(30) NULL DEFAULT '',
    contact_phone VARCHAR(20) NULL DEFAULT '',
    remark VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "service_task" IS '服务任务(TMC工单)';
COMMENT ON COLUMN "service_task"."task_no" IS '任务编号(如: TK20250701123456-001)';
COMMENT ON COLUMN "service_task"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "service_task"."order_id" IS '主订单ID';
COMMENT ON COLUMN "service_task"."sales_id" IS '销售业务订单ID';
COMMENT ON COLUMN "service_task"."task_type" IS '任务类型: domestic_flight/international_flight/hotel/hotel_night_audit/train/insurance/car/eagle_eye/demand/travel_customize/corporate_agreement/corporate_direct';
COMMENT ON COLUMN "service_task"."task_status" IS '任务状态: PENDING/PROCESSING/SUSPENDED/WAITING_TICKET/WAITING_REMINDER/REFUND_AUDIT/REFUND_REVIEW/CHANGE_TICKET/CHANGE_AUDIT/COMPLETED/CLOSED';
COMMENT ON COLUMN "service_task"."task_source" IS '任务来源: SYSTEM=系统自动/MANUAL=手工创建';
COMMENT ON COLUMN "service_task"."priority" IS '优先级: 1=低,2=中,3=高,4=紧急';
COMMENT ON COLUMN "service_task"."assign_to" IS '分配给(mmc_user.id), 0=未分配';
COMMENT ON COLUMN "service_task"."assign_name" IS '分配人姓名(冗余)';
COMMENT ON COLUMN "service_task"."assign_at" IS '分配时间';
COMMENT ON COLUMN "service_task"."process_at" IS '开始处理时间';
COMMENT ON COLUMN "service_task"."close_at" IS '关闭时间';
COMMENT ON COLUMN "service_task"."company_id" IS '企业客户ID(corporate_group.id)';
COMMENT ON COLUMN "service_task"."company_name" IS '企业名称(冗余)';
COMMENT ON COLUMN "service_task"."contact_name" IS '联系人';
COMMENT ON COLUMN "service_task"."contact_phone" IS '联系电话';
COMMENT ON COLUMN "service_task"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_order" ON "service_task" (order_id ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_type_status" ON "service_task" (tenant_id ASC, task_type ASC, task_status ASC);
CREATE INDEX IF NOT EXISTS "idx_assign" ON "service_task" (assign_to ASC, task_status ASC);
CREATE INDEX IF NOT EXISTS "idx_status_priority" ON "service_task" (task_status ASC, priority ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_company" ON "service_task" (company_id ASC);
CREATE INDEX IF NOT EXISTS "idx_created" ON "service_task" (created_at ASC);

CREATE TABLE IF NOT EXISTS "service_task_assign_rule" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    task_type VARCHAR(30) NOT NULL,
    rule_type VARCHAR(20) NOT NULL DEFAULT 'round_robin',
    target_user_ids json NULL,
    skill_tags json NULL,
    priority SMALLINT NULL DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "service_task_assign_rule" IS '任务分配规则';
COMMENT ON COLUMN "service_task_assign_rule"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "service_task_assign_rule"."task_type" IS '任务类型';
COMMENT ON COLUMN "service_task_assign_rule"."rule_type" IS '分配策略: round_robin=轮询/least_load=最少任务/skill=技能匹配/manual=手工分配';
COMMENT ON COLUMN "service_task_assign_rule"."target_user_ids" IS '目标用户ID列表(轮询/技能匹配时用)';
COMMENT ON COLUMN "service_task_assign_rule"."skill_tags" IS '技能标签(skill策略时用, 如: [\"国际机票\",\"退改签\"])';
COMMENT ON COLUMN "service_task_assign_rule"."priority" IS '规则优先级(数值越大越优先)';
COMMENT ON COLUMN "service_task_assign_rule"."status" IS '1=启用,2=停用';
CREATE INDEX IF NOT EXISTS "idx_tenant_type" ON "service_task_assign_rule" (tenant_id ASC, task_type ASC, status ASC);

CREATE TABLE IF NOT EXISTS "service_task_log" (

    id BIGSERIAL,
    task_id BIGINT NOT NULL,
    tenant_id BIGINT NOT NULL,
    operator_id BIGINT NOT NULL,
    operator_name VARCHAR(30) NULL DEFAULT '',
    operator_type VARCHAR(10) NOT NULL,
    action VARCHAR(30) NOT NULL,
    from_status VARCHAR(30) NULL DEFAULT '',
    to_status VARCHAR(30) NULL DEFAULT '',
    content VARCHAR(500) NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "service_task_log" IS '任务操作日志';
COMMENT ON COLUMN "service_task_log"."task_id" IS '任务ID service_task.id';
COMMENT ON COLUMN "service_task_log"."tenant_id" IS '商户ID';
COMMENT ON COLUMN "service_task_log"."operator_id" IS '操作人ID';
COMMENT ON COLUMN "service_task_log"."operator_name" IS '操作人姓名';
COMMENT ON COLUMN "service_task_log"."operator_type" IS '操作人类型: pmc/tmc/mmc/system';
COMMENT ON COLUMN "service_task_log"."action" IS '操作: created/assigned/claimed/processed/suspended/resumed/transferred/refund_audit/refund_review/change_ticket/change_audit/completed/closed/reopened';
COMMENT ON COLUMN "service_task_log"."from_status" IS '原状态';
COMMENT ON COLUMN "service_task_log"."to_status" IS '新状态';
COMMENT ON COLUMN "service_task_log"."content" IS '操作内容/备注';
CREATE INDEX IF NOT EXISTS "idx_task" ON "service_task_log" (task_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_operator" ON "service_task_log" (tenant_id ASC, operator_id ASC);

CREATE TABLE IF NOT EXISTS "tenant" (

    id BIGSERIAL,
    name VARCHAR(32) NOT NULL,
    tenant_type VARCHAR(20) NOT NULL DEFAULT 'merchant',
    parent_tenant_id BIGINT NOT NULL DEFAULT 0,
    package_id BIGINT NOT NULL DEFAULT 0,
    mmc_package_id BIGINT NOT NULL DEFAULT 0,
    user_id BIGINT NOT NULL,
    account_count INTEGER NOT NULL DEFAULT 100,
    contact_name VARCHAR(16) NOT NULL,
    contact_phone VARCHAR(16) NOT NULL,
    bind_domain VARCHAR(128) DEFAULT NULL,
    expire_at TIMESTAMP NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tenant" IS '租户表';
COMMENT ON COLUMN "tenant"."id" IS '租户编号';
COMMENT ON COLUMN "tenant"."name" IS '租户名称';
COMMENT ON COLUMN "tenant"."tenant_type" IS '租户类型:tmc=集团/merchant=商户/distributor=分销商';
COMMENT ON COLUMN "tenant"."parent_tenant_id" IS '上级租户ID,平台直建=0';
COMMENT ON COLUMN "tenant"."package_id" IS '套餐编号(tmc 必填,merchant/distributor=0 改用 mmc_package_id)';
COMMENT ON COLUMN "tenant"."mmc_package_id" IS 'MMC套餐ID(tenant_type=merchant/distributor 时使用)';
COMMENT ON COLUMN "tenant"."user_id" IS '用户编号，租户管理员';
COMMENT ON COLUMN "tenant"."account_count" IS '账号最大数量';
COMMENT ON COLUMN "tenant"."contact_name" IS '联系人姓名';
COMMENT ON COLUMN "tenant"."contact_phone" IS '联系人手机';
COMMENT ON COLUMN "tenant"."bind_domain" IS '绑定域名';
COMMENT ON COLUMN "tenant"."expire_at" IS '过期时间';
COMMENT ON COLUMN "tenant"."status" IS '租户状态:1=正常,2=停用';
COMMENT ON COLUMN "tenant"."created_by" IS '创建者';
COMMENT ON COLUMN "tenant"."updated_by" IS '更新者';
COMMENT ON COLUMN "tenant"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_type_status" ON "tenant" (tenant_type ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_parent_type" ON "tenant" (parent_tenant_id ASC, tenant_type ASC);

CREATE TABLE IF NOT EXISTS "tmc_department" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(50) NOT NULL,
    parent_id BIGINT NOT NULL DEFAULT 0,
    path VARCHAR(500) NOT NULL DEFAULT '',
    level SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_department" IS 'TMC部门';
CREATE INDEX IF NOT EXISTS "idx_tenant_parent" ON "tmc_department" (tenant_id ASC, parent_id ASC, sort ASC);
CREATE INDEX IF NOT EXISTS "idx_tenant_path" ON "tmc_department" (tenant_id ASC, path(200);

CREATE TABLE IF NOT EXISTS "tmc_dept_leader" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    dept_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_dept_leader" IS 'TMC部门领导';
CREATE INDEX IF NOT EXISTS "idx_tenant" ON "tmc_dept_leader" (tenant_id ASC);

CREATE TABLE IF NOT EXISTS "tmc_login_log" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    user_id BIGINT NOT NULL DEFAULT 0,
    username VARCHAR(50) NOT NULL,
    ip VARCHAR(45) DEFAULT NULL,
    os VARCHAR(255) DEFAULT NULL,
    browser VARCHAR(255) DEFAULT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    message VARCHAR(50) DEFAULT NULL,
    login_time TIMESTAMP NOT NULL,
    remark VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_login_log" IS 'TMC 端登录日志';
COMMENT ON COLUMN "tmc_login_log"."tenant_id" IS 'TMC集团ID';
COMMENT ON COLUMN "tmc_login_log"."user_id" IS '指向 tmc_user.id';
CREATE INDEX IF NOT EXISTS "idx_tenant_user_time" ON "tmc_login_log" (tenant_id ASC, user_id ASC, login_time ASC);
CREATE INDEX IF NOT EXISTS "idx_username" ON "tmc_login_log" (username ASC);

CREATE TABLE IF NOT EXISTS "tmc_menu" (

    id BIGSERIAL,
    parent_id BIGINT NOT NULL DEFAULT 0,
    name VARCHAR(50) NOT NULL DEFAULT '',
    type SMALLINT NOT NULL DEFAULT 2,
    permission_key VARCHAR(100) NOT NULL DEFAULT '',
    meta json NULL,
    path VARCHAR(60) NOT NULL DEFAULT '',
    component VARCHAR(150) NOT NULL DEFAULT '',
    redirect VARCHAR(100) NOT NULL DEFAULT '',
    status SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(60) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_menu" IS 'TMC端菜单(全局共享)';
COMMENT ON COLUMN "tmc_menu"."type" IS '1=目录,2=菜单,3=按钮';
CREATE INDEX IF NOT EXISTS "idx_parent" ON "tmc_menu" (parent_id ASC, sort ASC);

CREATE TABLE IF NOT EXISTS "tmc_operation_log" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    user_id BIGINT NOT NULL DEFAULT 0,
    username VARCHAR(50) NOT NULL,
    method VARCHAR(20) NOT NULL,
    router VARCHAR(500) NOT NULL,
    service_name VARCHAR(30) NOT NULL,
    ip VARCHAR(45) DEFAULT NULL,
    created_at timestamp DEFAULT NULL,
    updated_at timestamp DEFAULT NULL,
    remark VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_operation_log" IS 'TMC 端操作日志';
COMMENT ON COLUMN "tmc_operation_log"."user_id" IS '指向 tmc_user.id';
CREATE INDEX IF NOT EXISTS "idx_tenant_user_time" ON "tmc_operation_log" (tenant_id ASC, user_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_username" ON "tmc_operation_log" (username ASC);

CREATE TABLE IF NOT EXISTS "tmc_package" (

    id BIGSERIAL,
    package_name VARCHAR(20) NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_package" IS '多租户套餐';
COMMENT ON COLUMN "tmc_package"."id" IS '套餐ID';
COMMENT ON COLUMN "tmc_package"."package_name" IS '套餐名称';
COMMENT ON COLUMN "tmc_package"."status" IS '状态:1=正常,2=停用';
COMMENT ON COLUMN "tmc_package"."created_by" IS '创建者';
COMMENT ON COLUMN "tmc_package"."updated_by" IS '更新者';
COMMENT ON COLUMN "tmc_package"."remark" IS '备注';

CREATE TABLE IF NOT EXISTS "tmc_package_change_log" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    package_type VARCHAR(20) NOT NULL,
    from_package_id BIGINT NOT NULL DEFAULT 0,
    to_package_id BIGINT NOT NULL DEFAULT 0,
    change_type VARCHAR(20) NOT NULL,
    reason VARCHAR(255) NOT NULL DEFAULT '',
    operator_id BIGINT NOT NULL,
    operator_platform VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_package_change_log" IS '租户套餐变更日志';
COMMENT ON COLUMN "tmc_package_change_log"."package_type" IS 'tmc_package/merchant_package';
COMMENT ON COLUMN "tmc_package_change_log"."change_type" IS 'upgrade/downgrade/bind/unbind';
CREATE INDEX IF NOT EXISTS "idx_tenant_time" ON "tmc_package_change_log" (tenant_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_operator" ON "tmc_package_change_log" (operator_id ASC);

CREATE TABLE IF NOT EXISTS "tmc_package_menu" (

    package_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL,
    platform VARCHAR(20) NOT NULL DEFAULT 'mmc',
    PRIMARY KEY ("package_id", "menu_id")
);
COMMENT ON COLUMN "tmc_package_menu"."package_id" IS '套餐ID';
COMMENT ON COLUMN "tmc_package_menu"."menu_id" IS '菜单ID';
COMMENT ON COLUMN "tmc_package_menu"."platform" IS '菜单所属端:tmc/mmc';
CREATE INDEX IF NOT EXISTS "idx_platform_menu" ON "tmc_package_menu" (platform ASC, menu_id ASC);

CREATE TABLE IF NOT EXISTS "tmc_position" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(50) NOT NULL,
    dept_id BIGINT NOT NULL,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_position" IS 'TMC岗位';
CREATE INDEX IF NOT EXISTS "idx_tenant_dept" ON "tmc_position" (tenant_id ASC, dept_id ASC);

CREATE TABLE IF NOT EXISTS "tmc_role" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    name VARCHAR(30) NOT NULL,
    code VARCHAR(100) NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    sort SMALLINT NOT NULL DEFAULT 0,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_role" IS 'TMC角色';
COMMENT ON COLUMN "tmc_role"."tenant_id" IS 'TMC集团ID';
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "tmc_role" (tenant_id ASC, status ASC);

CREATE TABLE IF NOT EXISTS "tmc_role_menu" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_role_menu" IS 'TMC角色-菜单';
CREATE INDEX IF NOT EXISTS "idx_tenant" ON "tmc_role_menu" (tenant_id ASC);
CREATE INDEX IF NOT EXISTS "idx_menu" ON "tmc_role_menu" (menu_id ASC);

CREATE TABLE IF NOT EXISTS "tmc_user" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    nickname VARCHAR(30) NOT NULL DEFAULT '',
    employee_no VARCHAR(50) NOT NULL DEFAULT '',
    phone VARCHAR(20) DEFAULT NULL,
    phone_encrypted varbinary(255) DEFAULT NULL,
    phone_hash CHAR(64) DEFAULT NULL,
    email VARCHAR(80) DEFAULT NULL,
    email_encrypted varbinary(255) DEFAULT NULL,
    email_hash CHAR(64) DEFAULT NULL,
    avatar VARCHAR(255) NOT NULL DEFAULT '',
    signed VARCHAR(255) NOT NULL DEFAULT '',
    is_owner SMALLINT NOT NULL DEFAULT 2,
    status SMALLINT NOT NULL DEFAULT 1,
    enable_2fa SMALLINT NOT NULL DEFAULT 2,
    pwd_error_count SMALLINT NOT NULL DEFAULT 0,
    locked_until TIMESTAMP DEFAULT NULL,
    password_updated_at TIMESTAMP DEFAULT NULL,
    login_ip VARCHAR(45) NOT NULL DEFAULT '',
    login_time timestamp DEFAULT NULL,
    backend_setting json NULL,
    created_by BIGINT NOT NULL DEFAULT 0,
    updated_by BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    remark VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_user" IS 'TMC 端用户表';
COMMENT ON COLUMN "tmc_user"."id" IS '用户ID';
COMMENT ON COLUMN "tmc_user"."tenant_id" IS 'TMC集团ID';
COMMENT ON COLUMN "tmc_user"."username" IS '用户名(集团内唯一)';
COMMENT ON COLUMN "tmc_user"."password" IS '密码';
COMMENT ON COLUMN "tmc_user"."nickname" IS '昵称';
COMMENT ON COLUMN "tmc_user"."employee_no" IS '工号';
COMMENT ON COLUMN "tmc_user"."phone" IS '手机号';
COMMENT ON COLUMN "tmc_user"."phone_encrypted" IS '手机号密文';
COMMENT ON COLUMN "tmc_user"."phone_hash" IS '手机号HMAC';
COMMENT ON COLUMN "tmc_user"."email" IS '邮箱';
COMMENT ON COLUMN "tmc_user"."email_encrypted" IS '邮箱密文';
COMMENT ON COLUMN "tmc_user"."email_hash" IS '邮箱HMAC';
COMMENT ON COLUMN "tmc_user"."avatar" IS '头像';
COMMENT ON COLUMN "tmc_user"."signed" IS '个人签名';
COMMENT ON COLUMN "tmc_user"."is_owner" IS '是否集团主管理员:1=是,2=否';
COMMENT ON COLUMN "tmc_user"."status" IS '状态:1=正常,2=停用';
COMMENT ON COLUMN "tmc_user"."enable_2fa" IS '是否启用2FA:1=是,2=否';
COMMENT ON COLUMN "tmc_user"."pwd_error_count" IS '连续密码错误次数';
COMMENT ON COLUMN "tmc_user"."locked_until" IS '锁定到此时间(NULL=未锁)';
COMMENT ON COLUMN "tmc_user"."password_updated_at" IS '密码上次修改时间';
COMMENT ON COLUMN "tmc_user"."login_ip" IS '最后登录IP';
COMMENT ON COLUMN "tmc_user"."login_time" IS '最后登录时间';
COMMENT ON COLUMN "tmc_user"."backend_setting" IS '后台设置数据';
COMMENT ON COLUMN "tmc_user"."remark" IS '备注';
CREATE INDEX IF NOT EXISTS "idx_tenant_status" ON "tmc_user" (tenant_id ASC, status ASC);
CREATE INDEX IF NOT EXISTS "idx_phone_hash" ON "tmc_user" (phone_hash ASC);
CREATE INDEX IF NOT EXISTS "idx_email_hash" ON "tmc_user" (email_hash ASC);

CREATE TABLE IF NOT EXISTS "tmc_user_dept" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    dept_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_user_dept" IS 'TMC用户-部门';
CREATE INDEX IF NOT EXISTS "idx_dept" ON "tmc_user_dept" (dept_id ASC);

CREATE TABLE IF NOT EXISTS "tmc_user_position" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    position_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_user_position" IS 'TMC用户-岗位';
CREATE INDEX IF NOT EXISTS "idx_position" ON "tmc_user_position" (position_id ASC);

CREATE TABLE IF NOT EXISTS "tmc_user_role" (

    id BIGSERIAL,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "tmc_user_role" IS 'TMC用户-角色';
CREATE INDEX IF NOT EXISTS "idx_user" ON "tmc_user_role" (user_id ASC);
CREATE INDEX IF NOT EXISTS "idx_role" ON "tmc_user_role" (role_id ASC);

CREATE TABLE IF NOT EXISTS "train_seat_type" (

    id BIGSERIAL,
    seat_code VARCHAR(10) NOT NULL,
    seat_name VARCHAR(30) NOT NULL,
    train_type_code VARCHAR(10) NULL DEFAULT '',
    cabin_class VARCHAR(10) NULL DEFAULT '',
    refund_rate_24h decimal(5, 2) DEFAULT NULL,
    refund_rate_48h decimal(5, 2) DEFAULT NULL,
    refund_rate_8d decimal(5, 2) DEFAULT NULL,
    sort_order INTEGER NULL DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "train_seat_type" IS '火车座席类型';
COMMENT ON COLUMN "train_seat_type"."seat_code" IS '座席编码(如: SWZ/ZY/ZE/RW/YW/RZ/YZ)';
COMMENT ON COLUMN "train_seat_type"."seat_name" IS '座席名称(如: 商务座/一等座/二等座/软卧/硬卧/软座/硬座)';
COMMENT ON COLUMN "train_seat_type"."train_type_code" IS '适用列车类型(空=通用, 如: G/D)';
COMMENT ON COLUMN "train_seat_type"."cabin_class" IS '舱位等级映射: business/first/second/sleeper';
COMMENT ON COLUMN "train_seat_type"."refund_rate_24h" IS '24h内退票费率(如: 0.20=20%)';
COMMENT ON COLUMN "train_seat_type"."refund_rate_48h" IS '48h内退票费率';
COMMENT ON COLUMN "train_seat_type"."refund_rate_8d" IS '8天内退票费率';
COMMENT ON COLUMN "train_seat_type"."sort_order" IS '排序(商务>一等>二等...)';
COMMENT ON COLUMN "train_seat_type"."status" IS '1=启用,2=停用';

CREATE TABLE IF NOT EXISTS "train_station" (

    id BIGSERIAL,
    station_code VARCHAR(20) NOT NULL,
    station_name VARCHAR(50) NOT NULL,
    city_code VARCHAR(20) NOT NULL,
    city_name VARCHAR(30) NULL DEFAULT '',
    pinyin VARCHAR(100) NULL DEFAULT '',
    short_pinyin VARCHAR(20) NULL DEFAULT '',
    longitude decimal(10, 6) DEFAULT NULL,
    latitude decimal(10, 6) DEFAULT NULL,
    sort_order INTEGER NULL DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "train_station" IS '火车站点';
COMMENT ON COLUMN "train_station"."station_code" IS '站点编码(如: BJN=北京南)';
COMMENT ON COLUMN "train_station"."station_name" IS '站点名称(如: 北京南站)';
COMMENT ON COLUMN "train_station"."city_code" IS '所属城市编码(对接air_region)';
COMMENT ON COLUMN "train_station"."city_name" IS '城市名';
COMMENT ON COLUMN "train_station"."pinyin" IS '站名拼音(如: beiJingNan)';
COMMENT ON COLUMN "train_station"."short_pinyin" IS '简拼(如: BJN)';
COMMENT ON COLUMN "train_station"."longitude" IS '经度';
COMMENT ON COLUMN "train_station"."latitude" IS '纬度';
COMMENT ON COLUMN "train_station"."sort_order" IS '排序权重';
COMMENT ON COLUMN "train_station"."status" IS '1=启用,2=停用';
CREATE INDEX IF NOT EXISTS "idx_city" ON "train_station" (city_code ASC);
CREATE INDEX IF NOT EXISTS "idx_pinyin" ON "train_station" (pinyin ASC);

CREATE TABLE IF NOT EXISTS "train_type" (

    id BIGSERIAL,
    type_code VARCHAR(10) NOT NULL,
    type_name VARCHAR(30) NOT NULL,
    speed_level SMALLINT NULL DEFAULT 0,
    refund_rule VARCHAR(500) NULL DEFAULT '',
    change_rule VARCHAR(500) NULL DEFAULT '',
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "train_type" IS '列车类型';
COMMENT ON COLUMN "train_type"."type_code" IS '类型编码(如: G/D/C/Z/T/K)';
COMMENT ON COLUMN "train_type"."type_name" IS '类型名称(如: 高铁/动车/城际/直达/特快/普快)';
COMMENT ON COLUMN "train_type"."speed_level" IS '速度等级: 1=最快(G),2=快(D/C),3=中(Z/T),4=慢(K/其他)';
COMMENT ON COLUMN "train_type"."refund_rule" IS '退票规则摘要(按类型通用规则)';
COMMENT ON COLUMN "train_type"."change_rule" IS '改签规则摘要';
COMMENT ON COLUMN "train_type"."status" IS '1=启用,2=停用';

CREATE TABLE IF NOT EXISTS "user_third_party_auth" (

    id BIGSERIAL,
    platform VARCHAR(20) NOT NULL,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    user_id BIGINT NOT NULL,
    provider VARCHAR(30) NOT NULL,
    provider_app_id VARCHAR(64) NOT NULL DEFAULT '',
    open_id VARCHAR(100) NOT NULL,
    union_id VARCHAR(100) NOT NULL DEFAULT '',
    unionid_principal VARCHAR(64) NOT NULL DEFAULT '',
    nickname VARCHAR(100) NOT NULL DEFAULT '',
    avatar VARCHAR(500) NOT NULL DEFAULT '',
    access_token varbinary(1024) DEFAULT NULL,
    refresh_token varbinary(1024) DEFAULT NULL,
    expire_at TIMESTAMP DEFAULT NULL,
    scope VARCHAR(255) NOT NULL DEFAULT '',
    raw_info json NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    bound_at TIMESTAMP DEFAULT NULL,
    last_login_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    deleted_at timestamp DEFAULT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "user_third_party_auth" IS '三方授权绑定表(三端共享)';
COMMENT ON COLUMN "user_third_party_auth"."platform" IS '所属端:pmc/tmc/mmc';
COMMENT ON COLUMN "user_third_party_auth"."tenant_id" IS '租户ID,saas=0';
COMMENT ON COLUMN "user_third_party_auth"."user_id" IS '端内 user_id (按 platform 指向对应 *_user 表)';
COMMENT ON COLUMN "user_third_party_auth"."provider" IS 'wechat_mp/wechat_open/wechat_work/wechat_mini/douyin/alipay/qq/dingtalk/feishu';
COMMENT ON COLUMN "user_third_party_auth"."provider_app_id" IS '三方应用 AppID (同 provider 可能多个应用)';
COMMENT ON COLUMN "user_third_party_auth"."open_id" IS '三方应用内唯一标识';
COMMENT ON COLUMN "user_third_party_auth"."union_id" IS '同主体下跨应用唯一标识(微信/支付宝)';
COMMENT ON COLUMN "user_third_party_auth"."unionid_principal" IS '开放平台主体ID(多主体场景区分)';
COMMENT ON COLUMN "user_third_party_auth"."nickname" IS '三方昵称(缓存)';
COMMENT ON COLUMN "user_third_party_auth"."avatar" IS '三方头像(缓存)';
COMMENT ON COLUMN "user_third_party_auth"."access_token" IS 'access_token 密文(AES-256-GCM)';
COMMENT ON COLUMN "user_third_party_auth"."refresh_token" IS 'refresh_token 密文';
COMMENT ON COLUMN "user_third_party_auth"."expire_at" IS 'access_token 过期时间';
COMMENT ON COLUMN "user_third_party_auth"."scope" IS '授权 scope (snsapi_userinfo 等)';
COMMENT ON COLUMN "user_third_party_auth"."raw_info" IS '三方原始返回信息';
COMMENT ON COLUMN "user_third_party_auth"."status" IS '状态:1=已绑定,2=已解绑';
COMMENT ON COLUMN "user_third_party_auth"."bound_at" IS '首次绑定时间';
COMMENT ON COLUMN "user_third_party_auth"."last_login_at" IS '最近一次三方登录时间';
CREATE INDEX IF NOT EXISTS "idx_provider_union" ON "user_third_party_auth" (provider ASC, unionid_principal ASC, union_id ASC);
CREATE INDEX IF NOT EXISTS "idx_user" ON "user_third_party_auth" (platform ASC, user_id ASC);

CREATE TABLE IF NOT EXISTS "user_third_party_login_log" (

    id BIGSERIAL,
    platform VARCHAR(20) NOT NULL,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    user_id BIGINT NOT NULL DEFAULT 0,
    provider VARCHAR(30) NOT NULL,
    open_id VARCHAR(100) NOT NULL DEFAULT '',
    scene VARCHAR(20) NOT NULL,
    ip VARCHAR(45) DEFAULT NULL,
    os VARCHAR(255) DEFAULT NULL,
    browser VARCHAR(255) DEFAULT NULL,
    status SMALLINT NOT NULL DEFAULT 1,
    error_code VARCHAR(50) NOT NULL DEFAULT '',
    message VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY ("id")
);
COMMENT ON TABLE "user_third_party_login_log" IS '三方授权登录/绑定日志';
COMMENT ON COLUMN "user_third_party_login_log"."platform" IS '所属端:pmc/tmc/mmc';
COMMENT ON COLUMN "user_third_party_login_log"."user_id" IS '0=未绑定/扫码失败/匿名扫码';
COMMENT ON COLUMN "user_third_party_login_log"."scene" IS 'login=三方登录,bind=绑定,unbind=解绑,refresh=刷新token';
COMMENT ON COLUMN "user_third_party_login_log"."status" IS '1=成功,2=失败';
COMMENT ON COLUMN "user_third_party_login_log"."error_code" IS '失败错误码';
CREATE INDEX IF NOT EXISTS "idx_user_time" ON "user_third_party_login_log" (platform ASC, user_id ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_provider_time" ON "user_third_party_login_log" (provider ASC, created_at ASC);
CREATE INDEX IF NOT EXISTS "idx_openid_time" ON "user_third_party_login_log" (provider ASC, open_id ASC, created_at ASC);

