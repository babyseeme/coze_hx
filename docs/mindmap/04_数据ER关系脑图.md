# 数据ER关系脑图

```
华夏航服B2B2C - 数据ER关系(核心实体)
├── 租户与权限域
│   ├── tenant ──┬── pmc_* (PMC平台端权限体系)
│   │            ├── tmc_* (TMC集团端权限体系)
│   │            └── mmc_* (MMC商户端权限体系)
│   ├── pmc_user ── pmc_role ── pmc_menu
│   ├── tmc_user ── tmc_role ── tmc_menu
│   └── mmc_user ── mmc_role ── mmc_menu
│
├── C端用户域
│   ├── c_user ──┬── c_member ── c_member_grade
│   │            ├── c_passenger
│   │            ├── favorite(全局收藏) ── favorite_*(业务附表)
│   │            ├── comment_*(分业务评论)
│   │            └── coupon_user ── coupon(优惠券)
│   └── c_member ── c_member_point_log
│
├── 订单域
│   ├── order ──┬── order_item_flight
│   │           ├── order_item_train
│   │           ├── order_item_hotel
│   │           ├── order_item_car
│   │           ├── order_item_mall
│   │           └── order_item_insurance
│   ├── order ── order_status_log (含trace_id)
│   ├── order ── order_procurement (采购单)
│   ├── order ── after_sale(全局售后) ── after_sale_*(业务售后)
│   ├── order ── payment_log
│   └── order ── finance_invoice
│
├── 航空基础数据域
│   ├── air_airline ── air_gauge(运价)
│   ├── air_airport ── air_route(航线)
│   ├── air_cabin
│   └── air_airport ── train_station(火车数据)
│
├── 酒店域
│   ├── hotel_brand ── hotel_info ── hotel_room_type
│   └── hotel_info ── comment_hotel
│
├── 财务域
│   ├── finance_company_account ── balance_log(含trace_id)
│   ├── finance_refund ── finance_invoice
│   └── finance_settlement_rule(新增) ── finance_settlement_log
│
├── 航司大客户域
│   ├── corporate_contract ── corporate_policy ── corporate_policy_rule
│   └── corporate_group ── corporate_contract
│
├── 审批域(对接第三方OA)
│   ├── oa_config(OA平台配置) ── 钉钉/飞书/企微
│   ├── oa_user_mapping(用户映射) ── oa_config
│   ├── oa_callback_log(OA回调日志)
│   ├── approval_instance(审批实例) ── oa_config(同步OA)
│   └── approval_record(审批记录) ── approval_instance
│
├── 采购域(新增)
│   ├── procurement_channel(采购渠道)
│   ├── procurement_account(渠道账号/按TMC)
│   ├── procurement_rule(自动采购规则)
│   └── procurement_verify_log(验价日志)
│
├── 销售策略域(新增)
│   ├── pricing_rule(加价规则)
│   ├── pricing_strategy(定价策略)
│   └── service_fee_rule(服务费规则)
│
├── 消息通知域(新增)
│   ├── notify_template(通知模板)
│   ├── notify_config(场景-渠道配置)
│   └── notify_log(通知记录)
│
├── 开放平台域(新增)
│   ├── open_api(接口定义)
│   ├── open_app(应用/TMC创建/绑定MMC)
│   ├── open_app_key(appkey管理)
│   ├── open_api_auth(接口授权)
│   └── open_api_log(调用日志)
│
└── 全链路追踪(新增)
    ├── trace_context(trace_id+span_id)
    ├── 所有日志表增加trace_id字段
    └── queue_task(队列任务版本+快照)
```
