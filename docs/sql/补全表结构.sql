-- ============================================================
-- 温州华夏航服B2B2C平台 - 数据库表结构补全DDL
-- 版本: v1.0
-- 日期: 2026-06-27
-- 说明: 补全合同需求中缺失的表结构，基于现有hx_b2b2c_v10.sql扩展
-- ============================================================

-- ============================================================
-- 1. 审批流程系统
-- ============================================================

-- 审批流程定义
CREATE TABLE approval_flow (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL DEFAULT 0, -- 租户ID(0=全局)
    flow_code VARCHAR(64) NOT NULL, -- 流程编码 如 WF202606140001
    flow_name VARCHAR(128) NOT NULL, -- 流程名称
    flow_type VARCHAR(32) NOT NULL, -- 流程类型: travel_approval=差旅审批, expense_approval=费用审批
    version INT NOT NULL DEFAULT 1, -- 流程版本
    status SMALLINT NOT NULL DEFAULT 0, -- 状态: 0=草稿, 1=已发布, 2=已停用
    description TEXT, -- 流程描述
    created_by BIGINT, -- 创建人
    published_at TIMESTAMP, -- 发布时间
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    UNIQUE(tenant_id, flow_code, version)
);

COMMENT ON TABLE approval_flow IS '审批流程定义表';
COMMENT ON COLUMN approval_flow.tenant_id IS '租户ID(0=全局)';
COMMENT ON COLUMN approval_flow.flow_type IS '流程类型: travel_approval=差旅审批, expense_approval=费用审批';

-- 审批流程节点
CREATE TABLE approval_node (
    id BIGSERIAL PRIMARY KEY,
    flow_id BIGINT NOT NULL REFERENCES approval_flow(id),
    node_code VARCHAR(64) NOT NULL, -- 节点编码
    node_name VARCHAR(128) NOT NULL, -- 节点名称
    node_type VARCHAR(32) NOT NULL, -- 节点类型: start=开始, condition=条件分支, approval=人工审批, auto_pass=自动通过, auto_reject=自动拒绝, end=结束
    approval_type VARCHAR(32), -- 审批类型(人工审批时): manual=人工审核, auto_pass=自动通过, auto_reject=自动拒绝
    approver_type VARCHAR(32), -- 审批人类型: role=角色, superior=上级, self=发起人本人, specified=指定成员, multi_superior=连续多级上级, self_select=发起人自选
    approver_ids JSONB, -- 审批人ID列表(角色ID/用户ID, JSON数组)
    multi_approval_mode VARCHAR(32), -- 多人审批方式: sequential=依次审批, countersign=会签, or_sign=或签
    empty_handler VARCHAR(32), -- 审批人为空时: admin=转交审批管理员, specified=指定人员
    empty_handler_id BIGINT, -- 指定人员ID
    position_x INT DEFAULT 0, -- 画布X坐标
    position_y INT DEFAULT 0, -- 画布Y坐标
    sort_order INT DEFAULT 0, -- 排序
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE approval_node IS '审批流程节点表';
COMMENT ON COLUMN approval_node.node_type IS '节点类型: start=开始, condition=条件分支, approval=人工审批, auto_pass=自动通过, auto_reject=自动拒绝, end=结束';
COMMENT ON COLUMN approval_node.approver_type IS '审批人类型: role=角色, superior=上级, self=发起人本人, specified=指定成员, multi_superior=连续多级上级, self_select=发起人自选';
COMMENT ON COLUMN approval_node.multi_approval_mode IS '多人审批方式: sequential=依次审批, countersign=会签, or_sign=或签';

-- 审批流程连线(节点间流转关系)
CREATE TABLE approval_edge (
    id BIGSERIAL PRIMARY KEY,
    flow_id BIGINT NOT NULL REFERENCES approval_flow(id),
    from_node_id BIGINT NOT NULL REFERENCES approval_node(id),
    to_node_id BIGINT NOT NULL REFERENCES approval_node(id),
    edge_type VARCHAR(32) NOT NULL DEFAULT 'normal', -- 连线类型: normal=正常, condition=条件分支
    condition_group_id BIGINT, -- 条件组ID(条件分支时)
    label VARCHAR(128), -- 连线标签
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE approval_edge IS '审批流程连线表';

-- 审批条件组
CREATE TABLE approval_condition_group (
    id BIGSERIAL PRIMARY KEY,
    node_id BIGINT NOT NULL REFERENCES approval_node(id), -- 条件分支节点ID
    group_name VARCHAR(128), -- 条件组名称
    is_default SMALLINT NOT NULL DEFAULT 0, -- 是否默认分支
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE approval_condition_group IS '审批条件组表';

-- 审批条件项
CREATE TABLE approval_condition_item (
    id BIGSERIAL PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES approval_condition_group(id),
    field_key VARCHAR(64) NOT NULL, -- 条件字段: amount=金额, days=天数, department=部门等
    operator VARCHAR(32) NOT NULL, -- 操作符: eq=等于, neq=不等于, gt=大于, gte=大于等于, lt=小于, lte=小于等于, in=包含, between=区间
    field_value JSONB NOT NULL, -- 条件值(JSON)
    logic VARCHAR(8) NOT NULL DEFAULT 'AND', -- 逻辑关系: AND/OR
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE approval_condition_item IS '审批条件项表';

-- 审批表单设计
CREATE TABLE approval_form (
    id BIGSERIAL PRIMARY KEY,
    flow_id BIGINT NOT NULL REFERENCES approval_flow(id),
    form_name VARCHAR(128) NOT NULL,
    form_config JSONB NOT NULL, -- 表单配置(JSON: 字段列表/验证规则/布局)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE approval_form IS '审批表单设计表';

-- 审批实例(运行时)
CREATE TABLE approval_instance (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    flow_id BIGINT NOT NULL REFERENCES approval_flow(id),
    flow_version INT NOT NULL,
    instance_no VARCHAR(64) NOT NULL, -- 审批单号
    title VARCHAR(256) NOT NULL, -- 审批标题
    form_data JSONB, -- 表单数据
    biz_type VARCHAR(32), -- 业务类型: flight=机票, hotel=酒店, train=火车票
    biz_id BIGINT, -- 业务ID(订单ID等)
    mode_type VARCHAR(32), -- 审批模式: pre_order=先审后单, approval_order=审批下单, post_order=先付后审
    initiator_id BIGINT NOT NULL, -- 发起人ID
    initiator_type VARCHAR(16) NOT NULL, -- 发起人类型: mmc_user=MMC用户, c_user=C端用户
    current_node_id BIGINT, -- 当前节点ID
    status VARCHAR(32) NOT NULL DEFAULT 'pending', -- 状态: pending=审批中, approved=已通过, rejected=已拒绝, cancelled=已撤销, terminated=已终止
    submit_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 提交时间
    finish_at TIMESTAMP, -- 完成时间
    approval_deadline TIMESTAMP, -- 审批期限(模式3: 先付后审的提交期限)
    trace_id VARCHAR(64), -- 全链路追踪ID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE approval_instance IS '审批实例表';
COMMENT ON COLUMN approval_instance.mode_type IS '审批模式: pre_order=先审后单, approval_order=审批下单, post_order=先付后审';

-- 审批记录(运行时)
CREATE TABLE approval_record (
    id BIGSERIAL PRIMARY KEY,
    instance_id BIGINT NOT NULL REFERENCES approval_instance(id),
    node_id BIGINT NOT NULL REFERENCES approval_node(id),
    node_name VARCHAR(128), -- 节点名称(冗余)
    handler_id BIGINT NOT NULL, -- 处理人ID
    handler_name VARCHAR(64), -- 处理人姓名(冗余)
    handler_type VARCHAR(16) NOT NULL, -- 处理人类型: mmc_user=MMC用户, system=系统
    action VARCHAR(32) NOT NULL, -- 操作: approve=同意, reject=拒绝, transfer=转交, cancel=撤销, terminate=终止
    opinion TEXT, -- 审批意见
    transfer_to_id BIGINT, -- 转交给谁
    transfer_to_name VARCHAR(64),
    trace_id VARCHAR(64), -- 全链路追踪ID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE approval_record IS '审批记录表';
COMMENT ON COLUMN approval_record.action IS '操作: approve=同意, reject=拒绝, transfer=转交, cancel=撤销, terminate=终止';


-- ============================================================
-- 2. 采购渠道与规则
-- ============================================================

-- 采购渠道
CREATE TABLE procurement_channel (
    id BIGSERIAL PRIMARY KEY,
    channel_code VARCHAR(64) NOT NULL, -- 渠道编码
    channel_name VARCHAR(128) NOT NULL, -- 渠道名称
    channel_type VARCHAR(32) NOT NULL, -- 渠道类型: airline_b2b=航司B2B, travelport=中航信, third_party=第三方接口, manual=人工外采
    supplier_type VARCHAR(32), -- 供应商类型: flight=机票, hotel=酒店, train=火车票, insurance=保险
    api_url VARCHAR(512), -- 接口地址
    api_config JSONB, -- 接口配置(认证方式/参数映射等)
    status SMALLINT NOT NULL DEFAULT 1, -- 状态: 0=禁用, 1=启用
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    UNIQUE(channel_code)
);

COMMENT ON TABLE procurement_channel IS '采购渠道表';
COMMENT ON COLUMN procurement_channel.channel_type IS '渠道类型: airline_b2b=航司B2B, travelport=中航信, third_party=第三方接口, manual=人工外采';

-- 采购渠道账号(TMC维度)
CREATE TABLE procurement_account (
    id BIGSERIAL PRIMARY KEY,
    channel_id BIGINT NOT NULL REFERENCES procurement_channel(id),
    tmc_tenant_id BIGINT NOT NULL, -- TMC租户ID
    account_name VARCHAR(128), -- 账号名称
    account_no VARCHAR(128), -- 账号
    account_config JSONB, -- 认证配置(加密存储)
    quota_limit INT, -- 调用配额限制
    quota_used INT DEFAULT 0, -- 已使用配额
    status SMALLINT NOT NULL DEFAULT 1, -- 状态: 0=禁用, 1=启用
    last_test_at TIMESTAMP, -- 最后测试时间
    last_test_result VARCHAR(32), -- 最后测试结果: success/fail
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE procurement_account IS '采购渠道账号表(TMC维度)';

-- 自动采购规则(三层: PMC/TMC/MMC)
CREATE TABLE procurement_rule (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL, -- 规则所属租户(0=PMC全局)
    tenant_type VARCHAR(16) NOT NULL, -- 租户类型: pmc=平台, tmc=集团, mmc=商户
    rule_name VARCHAR(128) NOT NULL, -- 规则名称
    product_type VARCHAR(32) NOT NULL DEFAULT 'flight', -- 产品类型: flight=机票, hotel=酒店, train=火车票
    airline_code VARCHAR(16), -- 航司代码(可空=不限)
    departure_code VARCHAR(16), -- 出发城市代码
    arrival_code VARCHAR(16), -- 到达城市代码
    cabin_class VARCHAR(16), -- 舱位等级
    price_min DECIMAL(12,2), -- 金额范围-最小
    price_max DECIMAL(12,2), -- 金额范围-最大
    time_start TIME, -- 有效时间-开始
    time_end TIME, -- 有效时间-结束
    week_days VARCHAR(16), -- 有效星期(1-7, 逗号分隔)
    channel_id BIGINT REFERENCES procurement_channel(id), -- 指定采购渠道
    procurement_type VARCHAR(16) NOT NULL DEFAULT 'auto', -- 采购方式: auto=自动, manual=手动
    verify_threshold_type VARCHAR(16), -- 验价阈值类型: percent=百分比, fixed=固定值
    verify_threshold_value DECIMAL(12,2), -- 验价阈值
    priority INT NOT NULL DEFAULT 0, -- 优先级(越大越优先)
    status SMALLINT NOT NULL DEFAULT 1, -- 状态: 0=禁用, 1=启用
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE procurement_rule IS '自动采购规则表(三层配置)';
COMMENT ON COLUMN procurement_rule.tenant_type IS '租户类型: pmc=平台, tmc=集团, mmc=商户';
COMMENT ON COLUMN procurement_rule.verify_threshold_type IS '验价阈值类型: percent=百分比, fixed=固定值';

-- 采购验价日志
CREATE TABLE procurement_verify_log (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    order_item_id BIGINT NOT NULL,
    channel_id BIGINT REFERENCES procurement_channel(id),
    cache_price DECIMAL(12,2), -- 缓存价格
    real_price DECIMAL(12,2), -- 实时验价
    threshold_type VARCHAR(16),
    threshold_value DECIMAL(12,2),
    price_diff DECIMAL(12,2), -- 价格差异
    verify_result VARCHAR(16) NOT NULL, -- 验价结果: pass=通过, fail=不通过, retry=重试
    verify_remark TEXT,
    trace_id VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE procurement_verify_log IS '采购验价日志表';

-- 外采核销记录
CREATE TABLE procurement_reconciliation (
    id BIGSERIAL PRIMARY KEY,
    tmc_tenant_id BIGINT NOT NULL,
    batch_no VARCHAR(64) NOT NULL, -- 导入批次号
    order_id BIGINT, -- 关联订单ID
    order_item_id BIGINT, -- 关联订单项ID
    pnr VARCHAR(64), -- PNR
    ticket_no VARCHAR(64), -- 票号
    procurement_price DECIMAL(12,2), -- 采购价
    status VARCHAR(16) NOT NULL DEFAULT 'pending', -- 核销状态: pending=待核销, matched=已匹配, failed=匹配失败
    fail_reason TEXT, -- 失败原因
    trace_id VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE procurement_reconciliation IS '外采核销记录表';


-- ============================================================
-- 3. 销售策略
-- ============================================================

-- 加价规则
CREATE TABLE pricing_rule (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL, -- 规则所属租户
    tenant_type VARCHAR(16) NOT NULL, -- 租户类型: tmc=集团, mmc=商户
    rule_name VARCHAR(128) NOT NULL, -- 规则名称
    product_type VARCHAR(32) NOT NULL DEFAULT 'flight', -- 产品类型
    airline_code VARCHAR(16), -- 航司代码
    departure_code VARCHAR(16), -- 出发城市
    arrival_code VARCHAR(16), -- 到达城市
    cabin_class VARCHAR(16), -- 舱位等级
    markup_type VARCHAR(16) NOT NULL, -- 加价类型: fixed=固定加价, percent=比例加价, mixed=固定+比例
    fixed_amount DECIMAL(12,2), -- 固定加价金额
    percent_rate DECIMAL(5,4), -- 浮动比例(如0.0500表示5%)
    min_markup DECIMAL(12,2), -- 最低加价(比例加价时保底)
    max_markup DECIMAL(12,2), -- 最高加价(比例加价时封顶)
    service_fee DECIMAL(12,2), -- 服务费
    priority INT NOT NULL DEFAULT 0, -- 优先级
    status SMALLINT NOT NULL DEFAULT 1,
    effective_start TIMESTAMP, -- 生效开始时间
    effective_end TIMESTAMP, -- 生效结束时间
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE pricing_rule IS '加价规则表';
COMMENT ON COLUMN pricing_rule.markup_type IS '加价类型: fixed=固定加价, percent=比例加价, mixed=固定+比例';

-- 服务费规则
CREATE TABLE service_fee_rule (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    tenant_type VARCHAR(16) NOT NULL,
    rule_name VARCHAR(128) NOT NULL,
    product_type VARCHAR(32) NOT NULL DEFAULT 'flight',
    fee_type VARCHAR(32) NOT NULL, -- 费用类型: booking=订座费, ticketing=出票费, refund=退票费, change=改签费, service=服务费
    calc_type VARCHAR(16) NOT NULL, -- 计费方式: fixed=固定, percent=比例, tiered=阶梯
    fixed_amount DECIMAL(12,2), -- 固定金额
    percent_rate DECIMAL(5,4), -- 比例
    tiered_config JSONB, -- 阶梯配置(JSON: [{min, max, amount/percent}])
    airline_code VARCHAR(16),
    status SMALLINT NOT NULL DEFAULT 1,
    effective_start TIMESTAMP,
    effective_end TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE service_fee_rule IS '服务费规则表';
COMMENT ON COLUMN service_fee_rule.fee_type IS '费用类型: booking=订座费, ticketing=出票费, refund=退票费, change=改签费, service=服务费';


-- ============================================================
-- 4. 结算方式配置
-- ============================================================

-- 结算方式配置(TMC对MMC / PMC对TMC)
CREATE TABLE settlement_config (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL, -- 上级租户ID(TMC或PMC)
    target_tenant_id BIGINT NOT NULL, -- 下级租户ID(MMC或TMC)
    target_tenant_type VARCHAR(16) NOT NULL, -- 下级类型: mmc=商户, tmc=集团
    settlement_type VARCHAR(32) NOT NULL, -- 结算方式: prepaid=预付, monthly=月结, credit=信用额度, mixed=混合
    credit_amount DECIMAL(14,2), -- 信用额度
    credit_warning_rate DECIMAL(5,4), -- 额度预警比例(如0.8000表示80%)
    credit_frozen SMALLINT DEFAULT 0, -- 是否冻结: 0=否, 1=是
    monthly_settle_day INT, -- 月结日(每月几号出账单)
    monthly_payment_day INT, -- 月结付款日(每月几号前付款)
    payment_terms INT, -- 付款期限(天)
    config JSONB, -- 其他配置
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE settlement_config IS '结算方式配置表';
COMMENT ON COLUMN settlement_config.settlement_type IS '结算方式: prepaid=预付, monthly=月结, credit=信用额度, mixed=混合';


-- ============================================================
-- 5. 分润管理
-- ============================================================

-- 分润规则
CREATE TABLE profit_sharing_rule (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL, -- 上级租户ID(PMC或TMC)
    target_tenant_id BIGINT NOT NULL, -- 下级租户ID(TMC或MMC)
    target_tenant_type VARCHAR(16) NOT NULL, -- 下级类型
    rule_name VARCHAR(128) NOT NULL,
    product_type VARCHAR(32) NOT NULL DEFAULT 'flight',
    calc_type VARCHAR(16) NOT NULL, -- 计算方式: fixed=固定金额, percent=比例, tiered=阶梯
    fixed_amount DECIMAL(12,2), -- 固定金额
    percent_rate DECIMAL(5,4), -- 比例
    tiered_config JSONB, -- 阶梯配置
    sharing_timing VARCHAR(16) NOT NULL DEFAULT 'order', -- 分润时机: order=按订单, period=按周期
    period_type VARCHAR(16), -- 周期类型: weekly=周, monthly=月(按周期时)
    airline_code VARCHAR(16),
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE profit_sharing_rule IS '分润规则表';
COMMENT ON COLUMN profit_sharing_rule.sharing_timing IS '分润时机: order=按订单, period=按周期';

-- 分润记录
CREATE TABLE profit_sharing_log (
    id BIGSERIAL PRIMARY KEY,
    rule_id BIGINT REFERENCES profit_sharing_rule(id),
    order_id BIGINT, -- 关联订单
    from_tenant_id BIGINT NOT NULL, -- 付款方租户ID
    to_tenant_id BIGINT NOT NULL, -- 收款方租户ID
    order_amount DECIMAL(12,2), -- 订单金额
    sharing_amount DECIMAL(12,2) NOT NULL, -- 分润金额
    calc_detail JSONB, -- 计算明细
    status VARCHAR(16) NOT NULL DEFAULT 'pending', -- 状态: pending=待结算, settled=已结算, failed=失败
    settled_at TIMESTAMP,
    trace_id VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE profit_sharing_log IS '分润记录表';


-- ============================================================
-- 6. 通用售后系统
-- ============================================================

-- 全局售后总表(C端统一查询)
CREATE TABLE after_sale (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    after_sale_no VARCHAR(64) NOT NULL, -- 售后单号
    order_id BIGINT NOT NULL, -- 关联订单ID
    order_item_id BIGINT, -- 关联订单项ID
    biz_type VARCHAR(32) NOT NULL, -- 业务类型: flight=机票, hotel=酒店, train=火车票, mall=商城, car=用车, insurance=保险
    biz_id BIGINT, -- 业务售后表ID
    user_id BIGINT NOT NULL, -- C端用户ID
    type VARCHAR(32) NOT NULL, -- 售后类型: refund=退款, return=退货, exchange=换货, change=改签
    reason VARCHAR(256), -- 售后原因
    amount DECIMAL(12,2), -- 售后金额
    status VARCHAR(32) NOT NULL DEFAULT 'pending', -- 状态: pending=待审核, approved=已通过, rejected=已拒绝, processing=处理中, completed=已完成, cancelled=已取消
    trace_id VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(after_sale_no)
);

COMMENT ON TABLE after_sale IS '全局售后总表(C端统一查询入口)';
COMMENT ON COLUMN after_sale.biz_type IS '业务类型: flight=机票, hotel=酒店, train=火车票, mall=商城, car=用车, insurance=保险';

-- 机票售后
CREATE TABLE after_sale_flight (
    id BIGSERIAL PRIMARY KEY,
    after_sale_id BIGINT NOT NULL REFERENCES after_sale(id),
    order_item_flight_id BIGINT NOT NULL,
    type VARCHAR(32) NOT NULL, -- refund=退票, change=改签
    refund_fee DECIMAL(12,2), -- 退票费
    refund_amount DECIMAL(12,2), -- 退款金额
    change_flight_info JSONB, -- 改签航班信息
    change_fee DECIMAL(12,2), -- 改签费
    pnr VARCHAR(64),
    ticket_nos TEXT, -- 票号(逗号分隔)
    procurement_status VARCHAR(32), -- 采购端状态
    procurement_remark TEXT, -- 采购端备注
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE after_sale_flight IS '机票售后表';

-- 酒店售后
CREATE TABLE after_sale_hotel (
    id BIGSERIAL PRIMARY KEY,
    after_sale_id BIGINT NOT NULL REFERENCES after_sale(id),
    order_item_hotel_id BIGINT NOT NULL,
    type VARCHAR(32) NOT NULL, -- refund=退款
    refund_amount DECIMAL(12,2),
    hotel_cancel_no VARCHAR(64), -- 酒店取消单号
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE after_sale_hotel IS '酒店售后表';

-- 火车票售后
CREATE TABLE after_sale_train (
    id BIGSERIAL PRIMARY KEY,
    after_sale_id BIGINT NOT NULL REFERENCES after_sale(id),
    order_item_train_id BIGINT NOT NULL,
    type VARCHAR(32) NOT NULL, -- refund=退票, change=改签
    refund_fee DECIMAL(12,2),
    refund_amount DECIMAL(12,2),
    change_train_info JSONB,
    change_fee DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE after_sale_train IS '火车票售后表';

-- 商城售后(保留mall_after_sale字段，升级关联after_sale)
-- 说明: mall_after_sale表已存在，需增加after_sale_id字段关联全局售后总表
ALTER TABLE mall_after_sale ADD COLUMN IF NOT EXISTS after_sale_id BIGINT REFERENCES after_sale(id);


-- ============================================================
-- 7. 评论系统(分业务)
-- ============================================================

-- 订单评论
CREATE TABLE comment_order (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    order_item_id BIGINT NOT NULL,
    biz_type VARCHAR(32) NOT NULL, -- 业务类型: flight/hotel/train/car
    user_id BIGINT NOT NULL, -- C端用户ID
    overall_score SMALLINT NOT NULL, -- 综合评分(1-5)
    service_score SMALLINT, -- 服务评分
    price_score SMALLINT, -- 价格评分
    experience_score SMALLINT, -- 体验评分
    content TEXT, -- 评论内容
    is_anonymous SMALLINT NOT NULL DEFAULT 0, -- 是否匿名
    reply_content TEXT, -- 商户/平台回复
    reply_by BIGINT, -- 回复人
    reply_at TIMESTAMP,
    follow_up_content TEXT, -- 追评内容
    follow_up_at TIMESTAMP,
    status SMALLINT NOT NULL DEFAULT 1, -- 状态: 0=隐藏, 1=显示
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE comment_order IS '订单评论表(按业务分表, 不同业务体量不同)';

-- 商品评论(保留mall_comment字段结构)
-- mall_comment表已存在，维持不变，独立于订单评论

-- 评论图片
CREATE TABLE comment_image (
    id BIGSERIAL PRIMARY KEY,
    comment_type VARCHAR(32) NOT NULL, -- 评论类型: order=订单评论, mall=商品评论, hotel=酒店评论
    comment_id BIGINT NOT NULL, -- 评论ID
    image_url VARCHAR(512) NOT NULL,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE comment_image IS '评论图片表(通用)';


-- ============================================================
-- 8. 通用收藏系统
-- ============================================================

-- 全局收藏总表(C端统一展示)
CREATE TABLE favorite (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL, -- C端用户ID
    biz_type VARCHAR(32) NOT NULL, -- 业务类型: flight=航班, hotel=酒店, mall=商品
    biz_id BIGINT NOT NULL, -- 业务收藏附表ID
    title VARCHAR(256), -- 标题(冗余, 便于列表展示)
    image_url VARCHAR(512), -- 图片(冗余)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, biz_type, biz_id)
);

COMMENT ON TABLE favorite IS '全局收藏总表(C端统一展示, 类型区分)';

-- 航班收藏附表
CREATE TABLE favorite_flight (
    id BIGSERIAL PRIMARY KEY,
    favorite_id BIGINT REFERENCES favorite(id),
    airline_code VARCHAR(16),
    departure_code VARCHAR(16),
    arrival_code VARCHAR(16),
    departure_name VARCHAR(64),
    arrival_name VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE favorite_flight IS '航班收藏附表';

-- 酒店收藏附表
CREATE TABLE favorite_hotel (
    id BIGSERIAL PRIMARY KEY,
    favorite_id BIGINT REFERENCES favorite(id),
    hotel_id BIGINT,
    hotel_name VARCHAR(256),
    city_code VARCHAR(16),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE favorite_hotel IS '酒店收藏附表';

-- 商品收藏附表
CREATE TABLE favorite_mall (
    id BIGSERIAL PRIMARY KEY,
    favorite_id BIGINT REFERENCES favorite(id),
    goods_id BIGINT,
    goods_name VARCHAR(256),
    price INT, -- 积分价格
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE favorite_mall IS '商品收藏附表';


-- ============================================================
-- 9. 通用优惠券系统
-- ============================================================

-- 优惠券模板(仅MMC可创建)
CREATE TABLE coupon (
    id BIGSERIAL PRIMARY KEY,
    mmc_tenant_id BIGINT NOT NULL, -- 所属MMC租户
    coupon_name VARCHAR(128) NOT NULL,
    coupon_type VARCHAR(32) NOT NULL, -- 券类型: discount=折扣券, reduction=满减券, cash=直减券, flight=机票券, hotel=酒店券, universal=通用券
    apply_type VARCHAR(32) NOT NULL, -- 适用类型: flight=机票, hotel=酒店, mall=商城, universal=通用
    discount_rate DECIMAL(5,4), -- 折扣率(折扣券)
    min_amount DECIMAL(12,2), -- 最低消费金额(满减券)
    reduction_amount DECIMAL(12,2), -- 减免金额(满减券/直减券)
    total_count INT NOT NULL, -- 发行总量
    used_count INT NOT NULL DEFAULT 0, -- 已使用数量
    remain_count INT NOT NULL, -- 剩余数量
    per_limit INT DEFAULT 1, -- 每人限领
    effective_type VARCHAR(16) NOT NULL, -- 时效类型: fixed=固定时间, days=领取后N天
    effective_start TIMESTAMP, -- 固定开始时间
    effective_end TIMESTAMP, -- 固定结束时间
    effective_days INT, -- 领取后有效天数
    status SMALLINT NOT NULL DEFAULT 1,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE coupon IS '通用优惠券模板(仅MMC可创建)';
COMMENT ON COLUMN coupon.coupon_type IS '券类型: discount=折扣券, reduction=满减券, cash=直减券, flight=机票券, hotel=酒店券, universal=通用券';
COMMENT ON COLUMN coupon.apply_type IS '适用类型: flight=机票, hotel=酒店, mall=商城, universal=通用';

-- 用户优惠券
CREATE TABLE coupon_user (
    id BIGSERIAL PRIMARY KEY,
    coupon_id BIGINT NOT NULL REFERENCES coupon(id),
    user_id BIGINT NOT NULL,
    mmc_tenant_id BIGINT NOT NULL,
    coupon_code VARCHAR(64), -- 券码
    status VARCHAR(16) NOT NULL DEFAULT 'unused', -- unused=未使用, used=已使用, expired=已过期
    used_order_id BIGINT, -- 使用的订单ID
    received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 领取时间
    used_at TIMESTAMP, -- 使用时间
    expired_at TIMESTAMP, -- 过期时间
    UNIQUE(coupon_id, user_id)
);

COMMENT ON TABLE coupon_user IS '用户优惠券表';


-- ============================================================
-- 10. 用户签到系统
-- ============================================================

-- 签到规则
CREATE TABLE sign_in_rule (
    id BIGSERIAL PRIMARY KEY,
    mmc_tenant_id BIGINT NOT NULL, -- 所属MMC租户
    reward_type VARCHAR(16) NOT NULL, -- 奖励类型: point=积分, coupon=优惠券
    reward_amount INT NOT NULL, -- 奖励数量(积分值)
    continuous_days INT NOT NULL DEFAULT 1, -- 连续签到天数(1=每日签到)
    continuous_bonus INT, -- 连续签到额外奖励
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE sign_in_rule IS '签到规则表';

-- 签到记录
CREATE TABLE sign_in_log (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    mmc_tenant_id BIGINT NOT NULL,
    rule_id BIGINT REFERENCES sign_in_rule(id),
    continuous_days INT NOT NULL DEFAULT 1, -- 当前连续签到天数
    reward_type VARCHAR(16),
    reward_amount INT,
    sign_date DATE NOT NULL, -- 签到日期
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, mmc_tenant_id, sign_date)
);

COMMENT ON TABLE sign_in_log IS '签到记录表';


-- ============================================================
-- 11. 用户标签系统
-- ============================================================

-- 标签定义
CREATE TABLE user_tag (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    tenant_type VARCHAR(16) NOT NULL, -- tmc/mmc
    tag_name VARCHAR(64) NOT NULL, -- 标签名称
    tag_category VARCHAR(32), -- 标签分类: manual=手动, auto=自动(规则生成)
    tag_color VARCHAR(16), -- 标签颜色
    auto_rule JSONB, -- 自动打标规则(自动标签时)
    user_count INT DEFAULT 0, -- 关联用户数
    sort_order INT DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tenant_id, tenant_type, tag_name)
);

COMMENT ON TABLE user_tag IS '用户标签定义表';

-- 用户标签关联
CREATE TABLE user_tag_relation (
    id BIGSERIAL PRIMARY KEY,
    tag_id BIGINT NOT NULL REFERENCES user_tag(id),
    user_id BIGINT NOT NULL,
    source VARCHAR(16) NOT NULL DEFAULT 'manual', -- 来源: manual=手动, auto=自动
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tag_id, user_id)
);

COMMENT ON TABLE user_tag_relation IS '用户标签关联表';


-- ============================================================
-- 12. 消息通知系统
-- ============================================================

-- 通知模板
CREATE TABLE notify_template (
    id BIGSERIAL PRIMARY KEY,
    template_code VARCHAR(64) NOT NULL, -- 模板编码
    template_name VARCHAR(128) NOT NULL,
    channel VARCHAR(32) NOT NULL, -- 渠道: sms=短信, wechat=微信模板消息, miniprogram=小程序订阅消息, inbox=站内信, email=邮件
    template_content TEXT NOT NULL, -- 模板内容(支持变量: {{var}})
    template_id VARCHAR(128), -- 第三方模板ID(微信/短信等)
    variables JSONB, -- 变量说明
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(template_code, channel)
);

COMMENT ON TABLE notify_template IS '通知模板表';

-- 通知场景配置(按场景配置渠道)
CREATE TABLE notify_config (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL, -- 租户ID
    scene_code VARCHAR(64) NOT NULL, -- 场景编码: ticket_success=出票成功, flight_change=航变通知, refund_success=退款到账, approval_pending=审批待办, monthly_bill=月结账单, promotion=促销活动
    scene_name VARCHAR(128) NOT NULL, -- 场景名称
    channels JSONB NOT NULL, -- 启用的渠道列表 ["sms","wechat","miniprogram","inbox","email"]
    enabled SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tenant_id, scene_code)
);

COMMENT ON TABLE notify_config IS '通知场景配置表(按场景配置渠道)';

-- 通知记录
CREATE TABLE notify_log (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT, -- 接收用户ID
    scene_code VARCHAR(64), -- 场景编码
    channel VARCHAR(32) NOT NULL, -- 发送渠道
    template_id BIGINT REFERENCES notify_template(id),
    content TEXT, -- 实际发送内容
    receiver VARCHAR(128), -- 接收人(手机号/openid/邮箱)
    status VARCHAR(16) NOT NULL DEFAULT 'pending', -- pending=待发送, sent=已发送, failed=发送失败
    third_party_id VARCHAR(128), -- 第三方消息ID
    error_msg TEXT, -- 失败原因
    trace_id VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP
);

COMMENT ON TABLE notify_log IS '通知记录表';

-- 站内信
CREATE TABLE notify_inbox (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    title VARCHAR(256) NOT NULL,
    content TEXT NOT NULL,
    biz_type VARCHAR(32), -- 业务类型
    biz_id BIGINT, -- 业务ID
    is_read SMALLINT NOT NULL DEFAULT 0,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE notify_inbox IS '站内信表';


-- ============================================================
-- 13. 开放平台
-- ============================================================

-- API接口定义
CREATE TABLE open_api (
    id BIGSERIAL PRIMARY KEY,
    api_code VARCHAR(64) NOT NULL, -- 接口编码
    api_name VARCHAR(128) NOT NULL,
    api_path VARCHAR(256) NOT NULL, -- 接口路径
    method VARCHAR(16) NOT NULL, -- HTTP方法: GET/POST/PUT/DELETE
    api_group VARCHAR(64), -- 接口分组
    version VARCHAR(16) NOT NULL DEFAULT 'v1',
    description TEXT,
    request_schema JSONB, -- 请求参数定义
    response_schema JSONB, -- 响应参数定义
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(api_code, version)
);

COMMENT ON TABLE open_api IS '开放平台API接口定义表';

-- API应用(TMC创建, 绑定MMC)
CREATE TABLE open_app (
    id BIGSERIAL PRIMARY KEY,
    tmc_tenant_id BIGINT NOT NULL, -- TMC租户ID
    mmc_tenant_id BIGINT NOT NULL, -- 绑定的MMC租户ID(订单归属)
    app_name VARCHAR(128) NOT NULL, -- 应用名称
    app_key VARCHAR(64) NOT NULL, -- AppKey
    app_secret VARCHAR(128) NOT NULL, -- AppSecret(加密存储)
    ip_whitelist JSONB, -- IP白名单
    concurrency_limit INT, -- 并发限制
    rate_limit INT, -- 频次限制(次/分钟)
    status SMALLINT NOT NULL DEFAULT 1, -- 0=禁用, 1=启用
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    UNIQUE(app_key)
);

COMMENT ON TABLE open_app IS '开放平台应用表(TMC创建, 每个应用绑定一个MMC)';

-- API接口授权(PMC授权给TMC)
CREATE TABLE open_api_auth (
    id BIGSERIAL PRIMARY KEY,
    tmc_tenant_id BIGINT NOT NULL, -- TMC租户ID
    api_id BIGINT NOT NULL REFERENCES open_api(id), -- API接口ID
    authorized SMALLINT NOT NULL DEFAULT 1, -- 是否授权
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tmc_tenant_id, api_id)
);

COMMENT ON TABLE open_api_auth IS 'API接口授权表(PMC授权给TMC)';

-- TMC开放平台计费配置(PMC配置)
CREATE TABLE open_billing_config (
    id BIGSERIAL PRIMARY KEY,
    tmc_tenant_id BIGINT NOT NULL,
    billing_type VARCHAR(16) NOT NULL, -- 计费方式: per_call=按次, monthly=按月
    per_call_price DECIMAL(12,4), -- 单次价格
    monthly_price DECIMAL(12,2), -- 月费
    monthly_free_calls INT, -- 月免费调用次数
    concurrency_limit INT, -- PMC设置并发上限
    rate_limit INT, -- PMC设置频次上限
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE open_billing_config IS 'TMC开放平台计费配置表(PMC配置)';

-- API调用日志
CREATE TABLE open_api_log (
    id BIGSERIAL PRIMARY KEY,
    app_id BIGINT REFERENCES open_app(id),
    api_id BIGINT REFERENCES open_api(id),
    tmc_tenant_id BIGINT NOT NULL,
    mmc_tenant_id BIGINT NOT NULL,
    request_method VARCHAR(16),
    request_path VARCHAR(256),
    request_params JSONB,
    request_ip VARCHAR(64),
    response_code INT,
    response_data JSONB,
    duration INT, -- 耗时(ms)
    trace_id VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE open_api_log IS 'API调用日志表';


-- ============================================================
-- 14. 小程序装修
-- ============================================================

-- 装修页面
CREATE TABLE decorate_page (
    id BIGSERIAL PRIMARY KEY,
    mmc_tenant_id BIGINT NOT NULL,
    page_type VARCHAR(32) NOT NULL, -- 页面类型: home=首页, activity=活动页, custom=自定义页
    page_name VARCHAR(128) NOT NULL,
    page_config JSONB NOT NULL, -- 页面配置(组件列表+排序+参数)
    is_published SMALLINT NOT NULL DEFAULT 0, -- 是否已发布
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE decorate_page IS '小程序装修页面表';
COMMENT ON COLUMN decorate_page.page_config IS '页面配置(JSON: 组件列表+排序+参数)';

-- 广告位管理
CREATE TABLE ad_slot (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    slot_code VARCHAR(64) NOT NULL, -- 广告位编码
    slot_name VARCHAR(128) NOT NULL, -- 广告位名称
    slot_type VARCHAR(32) NOT NULL, -- 类型: banner=轮播, popup=弹窗, fixed=固定位
    position VARCHAR(32), -- 位置: home_top=首页顶部, home_middle=首页中部等
    width INT, -- 宽度
    height INT, -- 高度
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tenant_id, slot_code)
);

COMMENT ON TABLE ad_slot IS '广告位管理表';

-- 广告内容
CREATE TABLE ad_content (
    id BIGSERIAL PRIMARY KEY,
    slot_id BIGINT NOT NULL REFERENCES ad_slot(id),
    title VARCHAR(256),
    image_url VARCHAR(512) NOT NULL,
    link_type VARCHAR(16), -- 链接类型: page=内部页面, url=外部链接, mini_program=小程序页面
    link_url VARCHAR(512),
    sort_order INT DEFAULT 0,
    effective_start TIMESTAMP,
    effective_end TIMESTAMP,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE ad_content IS '广告内容表';

-- 公告管理
CREATE TABLE announcement (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    title VARCHAR(256) NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(16) NOT NULL DEFAULT 'notice', -- 类型: notice=通知, activity=活动, policy=政策
    is_top SMALLINT NOT NULL DEFAULT 0, -- 是否置顶
    effective_start TIMESTAMP,
    effective_end TIMESTAMP,
    status SMALLINT NOT NULL DEFAULT 1,
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE announcement IS '公告管理表';


-- ============================================================
-- 15. 队列任务版本控制
-- ============================================================

-- 队列任务表
CREATE TABLE queue_task (
    id BIGSERIAL PRIMARY KEY,
    task_type VARCHAR(64) NOT NULL, -- 任务类型: ticketing=出票, refund=退款, import_whitelist=白名单导入, bill_generate=账单生成等
    task_version INT NOT NULL DEFAULT 1, -- 任务版本号
    payload JSONB NOT NULL, -- 任务数据
    snapshot JSONB, -- 业务数据快照(出票时的价格/库存等)
    priority INT NOT NULL DEFAULT 0, -- 优先级
    max_attempts INT NOT NULL DEFAULT 3, -- 最大重试次数
    attempts INT NOT NULL DEFAULT 0, -- 已重试次数
    status VARCHAR(16) NOT NULL DEFAULT 'pending', -- pending=待处理, running=处理中, completed=已完成, failed=失败
    error_msg TEXT, -- 失败原因
    scheduled_at TIMESTAMP, -- 计划执行时间
    started_at TIMESTAMP, -- 开始执行时间
    completed_at TIMESTAMP, -- 完成时间
    trace_id VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE queue_task IS '队列任务表(含版本控制和业务数据快照)';
COMMENT ON COLUMN queue_task.snapshot IS '业务数据快照: 记录任务产生时的业务状态, 失败重试时追溯';


-- ============================================================
-- 16. 差旅政策
-- ============================================================

-- 差旅政策
CREATE TABLE travel_policy (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    tenant_type VARCHAR(16) NOT NULL, -- tmc/mmc
    policy_name VARCHAR(128) NOT NULL,
    policy_type VARCHAR(32) NOT NULL, -- policy类型: flight=机票, hotel=酒店, train=火车票
    rules JSONB NOT NULL, -- 政策规则(JSON: 航线限制/舱位限制/价格上限/酒店星级标准/火车座席标准等)
    violation_action VARCHAR(16) NOT NULL DEFAULT 'warn', -- 违规动作: warn=仅提示, block=阻止下单
    apply_scope VARCHAR(16) NOT NULL DEFAULT 'all', -- 适用范围: all=全员, department=指定部门, tag=指定标签
    scope_config JSONB, -- 适用范围配置
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE travel_policy IS '差旅政策表';


-- ============================================================
-- 17. 订单tag标识(扩展order表)
-- ============================================================

-- 给order表增加tag字段(标识订单来源)
ALTER TABLE "order" ADD COLUMN IF NOT EXISTS order_tag VARCHAR(32);
COMMENT ON COLUMN "order".order_tag IS '订单来源标识: openapi=开放平台, mini_program=小程序, web=Web端, app=App端';

-- 给order表增加trace_id字段(全链路追踪)
ALTER TABLE "order" ADD COLUMN IF NOT EXISTS trace_id VARCHAR(64);
COMMENT ON COLUMN "order".trace_id IS '全链路追踪ID';

-- 给order_status_log增加trace_id
ALTER TABLE order_status_log ADD COLUMN IF NOT EXISTS trace_id VARCHAR(64);
COMMENT ON COLUMN order_status_log.trace_id IS '全链路追踪ID';

-- 给balance_log增加trace_id
ALTER TABLE balance_log ADD COLUMN IF NOT EXISTS trace_id VARCHAR(64);
COMMENT ON COLUMN balance_log.trace_id IS '全链路追踪ID';

-- 给pmc_operation_log增加trace_id
ALTER TABLE pmc_operation_log ADD COLUMN IF NOT EXISTS trace_id VARCHAR(64);
COMMENT ON COLUMN pmc_operation_log.trace_id IS '全链路追踪ID';

-- 给tmc_operation_log增加trace_id
ALTER TABLE tmc_operation_log ADD COLUMN IF NOT EXISTS trace_id VARCHAR(64);
COMMENT ON COLUMN tmc_operation_log.trace_id IS '全链路追踪ID';

-- 给mmc_operation_log增加trace_id
ALTER TABLE mmc_operation_log ADD COLUMN IF NOT EXISTS trace_id VARCHAR(64);
COMMENT ON COLUMN mmc_operation_log.trace_id IS '全链路追踪ID';


-- ============================================================
-- 18. 用车服务扩展(order_item_car字段补全)
-- ============================================================

-- 扩展order_item_car表字段(如果字段不存在则添加)
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS car_type VARCHAR(32); -- 车型: economy=经济, comfort=舒适, business=商务, luxury=豪华
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS service_type VARCHAR(32); -- 服务类型: airport_pickup=机场接机, airport_dropoff=机场送机, city=市内, cross_city=跨城
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS pickup_address VARCHAR(256); -- 上车地址
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS dropoff_address VARCHAR(256); -- 下车地址
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS pickup_time TIMESTAMP; -- 预约上车时间
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS driver_name VARCHAR(64); -- 司机姓名
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS driver_phone VARCHAR(32); -- 司机电话
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS car_no VARCHAR(32); -- 车牌号
ALTER TABLE order_item_car ADD COLUMN IF NOT EXISTS fee_detail JSONB; -- 费用明细

COMMENT ON COLUMN order_item_car.car_type IS '车型: economy=经济, comfort=舒适, business=商务, luxury=豪华';
COMMENT ON COLUMN order_item_car.service_type IS '服务类型: airport_pickup=机场接机, airport_dropoff=机场送机, city=市内, cross_city=跨城';


-- ============================================================
-- 19. 会员体系补全
-- ============================================================

-- 会员等级升级规则
CREATE TABLE member_grade_rule (
    id BIGSERIAL PRIMARY KEY,
    mmc_tenant_id BIGINT NOT NULL,
    from_grade_id BIGINT, -- 原等级ID
    to_grade_id BIGINT NOT NULL, -- 目标等级ID
    rule_type VARCHAR(16) NOT NULL, -- 规则类型: order_count=订单数, order_amount=消费金额, point=积分
    threshold DECIMAL(12,2) NOT NULL, -- 升级阈值
    is_auto_upgrade SMALLINT NOT NULL DEFAULT 1, -- 是否自动升级
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE member_grade_rule IS '会员等级升级规则表';

-- 会员权益
CREATE TABLE member_benefit (
    id BIGSERIAL PRIMARY KEY,
    mmc_tenant_id BIGINT NOT NULL,
    grade_id BIGINT NOT NULL, -- 等级ID
    benefit_type VARCHAR(32) NOT NULL, -- 权益类型: discount=折扣, coupon=专属优惠券, point_rate=积分倍率, priority_service=优先服务
    benefit_config JSONB NOT NULL, -- 权益配置
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE member_benefit IS '会员权益配置表';


-- ============================================================
-- 20. 促销活动
-- ============================================================

-- 促销活动
CREATE TABLE promotion_activity (
    id BIGSERIAL PRIMARY KEY,
    mmc_tenant_id BIGINT NOT NULL,
    activity_name VARCHAR(128) NOT NULL,
    activity_type VARCHAR(32) NOT NULL, -- 类型: seckill=秒杀, group_buy=团购, full_reduction=满减
    product_type VARCHAR(32) NOT NULL DEFAULT 'flight', -- 产品类型
    activity_config JSONB NOT NULL, -- 活动配置(时间/规则/商品等)
    status SMALLINT NOT NULL DEFAULT 0, -- 0=未开始, 1=进行中, 2=已结束, 3=已取消
    effective_start TIMESTAMP,
    effective_end TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE promotion_activity IS '促销活动表';


-- ============================================================
-- 21. 供应商管理(通用)
-- ============================================================

CREATE TABLE supplier (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    supplier_name VARCHAR(128) NOT NULL,
    supplier_type VARCHAR(32) NOT NULL, -- 类型: airline=航司, hotel=酒店, insurance=保险, car=用车, ticket=门票, other=其他
    contact_name VARCHAR(64),
    contact_phone VARCHAR(32),
    contact_email VARCHAR(128),
    address TEXT,
    settlement_type VARCHAR(32), -- 结算方式: prepaid=预付, monthly=月结, credit=信用额度
    contract_start DATE,
    contract_end DATE,
    bank_name VARCHAR(128),
    bank_account VARCHAR(64),
    bank_no VARCHAR(64),
    status SMALLINT NOT NULL DEFAULT 1,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE supplier IS '通用供应商管理表';


-- ============================================================
-- 22. 数据报表快照(用于统计加速)
-- ============================================================

CREATE TABLE report_snapshot (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL,
    tenant_type VARCHAR(16) NOT NULL, -- pmc/tmc/mmc
    report_type VARCHAR(32) NOT NULL, -- 报表类型: transaction=交易, procurement=采购, sales=销售, customer=客户
    dimension VARCHAR(32) NOT NULL, -- 维度: daily=日, weekly=周, monthly=月
    dimension_date DATE NOT NULL, -- 维度日期
    metrics JSONB NOT NULL, -- 指标数据
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tenant_id, tenant_type, report_type, dimension, dimension_date)
);

COMMENT ON TABLE report_snapshot IS '数据报表快照表(定时生成, 加速查询)';


-- ============================================================
-- 索引创建
-- ============================================================

-- 审批相关索引
CREATE INDEX idx_approval_flow_tenant ON approval_flow(tenant_id, status);
CREATE INDEX idx_approval_instance_tenant ON approval_instance(tenant_id, status);
CREATE INDEX idx_approval_instance_initiator ON approval_instance(initiator_id, initiator_type);
CREATE INDEX idx_approval_instance_biz ON approval_instance(biz_type, biz_id);
CREATE INDEX idx_approval_record_instance ON approval_instance(id);

-- 采购相关索引
CREATE INDEX idx_procurement_rule_tenant ON procurement_rule(tenant_id, tenant_type, status);
CREATE INDEX idx_procurement_verify_log_order ON procurement_verify_log(order_id);
CREATE INDEX idx_procurement_reconciliation_tmc ON procurement_reconciliation(tmc_tenant_id, status);

-- 销售策略索引
CREATE INDEX idx_pricing_rule_tenant ON pricing_rule(tenant_id, tenant_type, status);
CREATE INDEX idx_service_fee_rule_tenant ON service_fee_rule(tenant_id, tenant_type, status);

-- 结算配置索引
CREATE INDEX idx_settlement_config_target ON settlement_config(tenant_id, target_tenant_id);

-- 分润索引
CREATE INDEX idx_profit_sharing_rule_target ON profit_sharing_rule(tenant_id, target_tenant_id);
CREATE INDEX idx_profit_sharing_log_order ON profit_sharing_log(order_id);

-- 售后索引
CREATE INDEX idx_after_sale_user ON after_sale(user_id, status);
CREATE INDEX idx_after_sale_order ON after_sale(order_id);

-- 收藏索引
CREATE INDEX idx_favorite_user ON favorite(user_id, biz_type);

-- 优惠券索引
CREATE INDEX idx_coupon_mmc ON coupon(mmc_tenant_id, status);
CREATE INDEX idx_coupon_user_user ON coupon_user(user_id, status);

-- 签到索引
CREATE INDEX idx_sign_in_log_user ON sign_in_log(user_id, mmc_tenant_id);

-- 标签索引
CREATE INDEX idx_user_tag_tenant ON user_tag(tenant_id, tenant_type);
CREATE INDEX idx_user_tag_relation_user ON user_tag_relation(user_id);

-- 消息索引
CREATE INDEX idx_notify_log_user ON notify_log(user_id, created_at);
CREATE INDEX idx_notify_inbox_user ON notify_inbox(user_id, is_read);

-- 开放平台索引
CREATE INDEX idx_open_app_tmc ON open_app(tmc_tenant_id, status);
CREATE INDEX idx_open_api_log_app ON open_api_log(app_id, created_at);
CREATE INDEX idx_open_api_log_trace ON open_api_log(trace_id);

-- 队列任务索引
CREATE INDEX idx_queue_task_type_status ON queue_task(task_type, status);
CREATE INDEX idx_queue_task_trace ON queue_task(trace_id);
CREATE INDEX idx_queue_task_scheduled ON queue_task(scheduled_at) WHERE status = 'pending';

-- 报表快照索引
CREATE INDEX idx_report_snapshot_tenant ON report_snapshot(tenant_id, tenant_type, report_type, dimension_date);
