# 华夏航服B2B2C - 基于MineAdmin的项目目录结构与开发规范

## 一、MineAdmin框架概述

| 维度 | 技术选型 |
|------|---------|
| 后端框架 | Hyperf 3.1 + Swoole 5.0+ |
| 后端语言 | PHP 8.1+ |
| 前端框架 | Vue 3 + Vite 5 + TypeScript |
| 前端UI | Arco Design Vue |
| 数据库 | MySQL 8.0+ |
| 缓存 | Redis 4.0+ |
| 权限 | Casbin (策略权限) |
| 文档 | Swagger (注解自动生成) |
| 迁移 | Phinx Migrations |
| 插件 | MineAdmin Plugin System |

### MineAdmin核心约定

- **分层架构**：Controller → Service → Mapper(Model) 三层分离
- **插件化**：业务模块以插件(plugin)形式开发，支持安装/卸载
- **Schema注解**：通过PHP 8 Attribute注解自动生成Swagger文档
- **CRUD生成**：通过命令行工具自动生成Controller/Service/Mapper/Schema
- **权限粒度**：菜单权限 + 按钮权限 + 数据权限(岗位级/用户级)
- **多端适配**：通过 `app/Http/{端标识}/Controller` 区分不同端

---

## 二、项目后端目录结构

```
huaxia-b2b2c-server/                     # 后端根目录
├── app/                                  # 应用核心代码
│   ├── Common/                           # 公共模块(跨插件复用)
│   │   ├── Constant/                     # 常量定义
│   │   │   ├── OrderConstant.php         #   订单状态/类型常量
│   │   │   ├── ApprovalConstant.php      #   审批状态/模式常量
│   │   │   ├── FinanceConstant.php       #   财务类型常量
│   │   │   └── OaConstant.php            #   OA平台常量
│   │   ├── Enum/                         # 枚举类(PHP 8.1 Enum)
│   │   │   ├── OrderStatus.php           #   订单状态枚举
│   │   │   ├── ApprovalMode.php          #   审批模式枚举
│   │   │   ├── ProcurementType.php       #   采购类型枚举
│   │   │   └── SettlementType.php        #   结算方式枚举
│   │   ├── Exception/                    # 业务异常类
│   │   │   ├── BizException.php          #   通用业务异常
│   │   │   ├── OrderException.php        #   订单业务异常
│   │   │   └── TicketException.php       #   出票业务异常
│   │   ├── Event/                        # 领域事件(MineAdmin内置事件机制)
│   │   │   ├── OrderPaidEvent.php        #   订单已支付事件
│   │   │   ├── OrderTicketedEvent.php    #   订单已出票事件
│   │   │   ├── ApprovalApprovedEvent.php #   审批通过事件
│   │   │   ├── ApprovalRejectedEvent.php #   审批拒绝事件
│   │   │   └── ProcurementResultEvent.php#   采购结果事件
│   │   ├── Listener/                     # 事件监听器
│   │   │   ├── OnOrderPaid.php           #   订单支付后→触发采购
│   │   │   ├── OnApprovalApproved.php    #   审批通过→业务联动
│   │   │   ├── OnTicketResult.php        #   出票结果→更新订单+通知
│   │   │   └── OnFlightChange.php        #   航变→推送通知
│   │   ├── Trait/                        # 复用Trait
│   │   │   ├── TraceAwareTrait.php       #   全链路trace_id注入
│   │   │   ├── TenantScopeTrait.php      #   租户数据隔离
│   │   │   └── SoftDeleteTrait.php       #   软删除
│   │   └── Helper/                       # 工具类
│   │       ├── PriceCalculator.php       #   价格计算(加价/折扣/协议价)
│   │       ├── TraceHelper.php           #   链路追踪工具
│   │       └── SnowflakeHelper.php       #   雪花ID生成
│   │
│   ├── Http/                             # HTTP控制器(按端分组)
│   │   ├── Admin/                        # PMC平台端控制器
│   │   │   ├── Controller/
│   │   │   │   ├── System/               #   系统管理(继承MineAdmin)
│   │   │   │   │   ├── UserController.php
│   │   │   │   │   ├── RoleController.php
│   │   │   │   │   └── MenuController.php
│   │   │   │   ├── Tenant/               #   租户管理
│   │   │   │   │   └── TenantController.php
│   │   │   │   ├── Tmc/                  #   TMC管理
│   │   │   │   │   └── TmcManageController.php
│   │   │   │   ├── Procurement/          #   采购渠道管理
│   │   │   │   │   ├── ChannelController.php
│   │   │   │   │   └── ChannelAccountController.php
│   │   │   │   ├── OpenApi/              #   开放平台管理
│   │   │   │   │   ├── AppController.php
│   │   │   │   │   └── ApiLogController.php
│   │   │   │   └── Report/               #   报表
│   │   │   │       └── DashboardController.php
│   │   │   └── AbstractController.php    #   PMC端基类控制器
│   │   │
│   │   ├── Tmc/                          # TMC集团端控制器
│   │   │   ├── Controller/
│   │   │   │   ├── System/               #   系统管理(继承MineAdmin)
│   │   │   │   ├── Mmc/                  #   商户管理
│   │   │   │   │   └── MmcManageController.php
│   │   │   │   ├── Procurement/          #   采购配置
│   │   │   │   │   ├── ProcurementRuleController.php
│   │   │   │   │   └── ProcurementVerifyController.php
│   │   │   │   ├── Settlement/           #   结算管理
│   │   │   │   │   ├── SettlementController.php
│   │   │   │   │   └── CreditController.php
│   │   │   │   ├── Pricing/              #   销售策略
│   │   │   │   │   └── PricingRuleController.php
│   │   │   │   ├── Profit/               #   分润管理
│   │   │   │   │   └── ProfitSharingController.php
│   │   │   │   ├── Oa/                   #   OA对接配置
│   │   │   │   │   ├── OaConfigController.php
│   │   │   │   │   └── OaUserMappingController.php
│   │   │   │   ├── Corporate/            #   大客户管理
│   │   │   │   │   └── CorporateController.php
│   │   │   │   ├── Finance/              #   财务管理
│   │   │   │   │   ├── InvoiceController.php
│   │   │   │   │   └── MonthlyBillController.php
│   │   │   │   └── Order/                #   订单管理
│   │   │   │       └── OrderController.php
│   │   │   └── AbstractController.php    #   TMC端基类控制器
│   │   │
│   │   ├── Mmc/                          # MMC商户端控制器
│   │   │   ├── Controller/
│   │   │   │   ├── System/               #   系统管理(继承MineAdmin)
│   │   │   │   ├── Order/                #   订单管理
│   │   │   │   │   ├── OrderController.php
│   │   │   │   │   └── AfterSaleController.php
│   │   │   │   ├── Ticket/               #   出票管理
│   │   │   │   │   └── TicketController.php
│   │   │   │   ├── Procurement/          #   采购规则配置
│   │   │   │   │   └── ProcurementRuleController.php
│   │   │   │   ├── Approval/             #   审批管理
│   │   │   │   │   └── ApprovalController.php
│   │   │   │   ├── Coupon/               #   优惠券管理
│   │   │   │   │   └── CouponController.php
│   │   │   │   ├── Decorate/             #   装修管理
│   │   │   │   │   └── DecorateController.php
│   │   │   │   ├── Mall/                 #   积分商城
│   │   │   │   │   ├── GoodsController.php
│   │   │   │   │   └── CategoryController.php
│   │   │   │   └── Member/               #   会员管理
│   │   │   │       └── MemberController.php
│   │   │   └── AbstractController.php    #   MMC端基类控制器
│   │   │
│   │   ├── Api/                          # C端/开放平台API
│   │   │   ├── Controller/
│   │   │   │   ├── C/                    #   C端客户端接口
│   │   │   │   │   ├── AuthController.php        #   登录注册
│   │   │   │   │   ├── FlightSearchController.php#   机票搜索
│   │   │   │   │   ├── OrderController.php       #   下单/订单
│   │   │   │   │   ├── ApprovalController.php    #   差旅审批
│   │   │   │   │   ├── MemberController.php      #   会员中心
│   │   │   │   │   ├── MallController.php        #   积分商城
│   │   │   │   │   ├── FavoriteController.php    #   收藏
│   │   │   │   │   └── CommentController.php     #   评论
│   │   │   │   └── Open/                #   开放平台接口
│   │   │   │       ├── AuthController.php        #   API鉴权
│   │   │   │       ├── OrderController.php       #   订单API
│   │   │   │       └── FlightController.php      #   航班查询API
│   │   │   └── AbstractController.php
│   │   │
│   │   └── Callback/                     # 回调控制器(第三方通知)
│   │       ├── Controller/
│   │       │   ├── PaymentCallbackController.php  # 支付回调
│   │       │   ├── OaCallbackController.php       # OA审批回调
│   │       │   └── ProcurementCallbackController.php # 采购渠道回调
│   │       └── AbstractController.php
│   │
│   ├── Schema/                           # Swagger Schema注解
│   │   ├── OrderSchema.php               #   订单相关Schema
│   │   ├── FlightSchema.php              #   航班相关Schema
│   │   ├── ApprovalSchema.php            #   审批相关Schema
│   │   ├── FinanceSchema.php             #   财务相关Schema
│   │   └── ...
│   │
│   ├── Service/                          # 业务服务层(核心逻辑)
│   │   ├── Order/                        #   订单服务
│   │   │   ├── OrderService.php          #     订单主服务
│   │   │   ├── OrderCreateService.php    #     下单服务(含事务)
│   │   │   ├── OrderQueryService.php     #     订单查询服务
│   │   │   └── OrderStatusService.php    #   订单状态机服务
│   │   ├── Ticket/                       #   出票服务
│   │   │   ├── TicketService.php         #     出票主服务
│   │   │   └── TicketVerifyService.php   #     验价服务
│   │   ├── Procurement/                  #   采购服务
│   │   │   ├── ProcurementService.php    #     采购主服务
│   │   │   ├── AutoProcurementService.php#     自动采购服务
│   │   │   ├── ProcurementVerifyService.php #  外采核销服务
│   │   │   └── ChannelAdapter/           #     采购渠道适配器
│   │   │       ├── ChannelAdapterInterface.php
│   │   │       ├── CtripAdapter.php      #       携程渠道
│   │   │       └── DirectAdapter.php     #       直连航司
│   │   ├── Approval/                     #   审批服务
│   │   │   ├── ApprovalService.php       #     审批主服务
│   │   │   └── ApprovalBusinessService.php #   审批业务联动服务
│   │   ├── OA/                           #   OA对接服务
│   │   │   ├── OaService.php             #     OA主服务(工厂模式)
│   │   │   ├── Contract/                 #     适配器接口
│   │   │   │   └── OaAdapterInterface.php
│   │   │   ├── DingTalkAdapter.php       #     钉钉适配器
│   │   │   ├── FeishuAdapter.php         #     飞书适配器
│   │   │   ├── WeComAdapter.php          #     企微适配器
│   │   │   └── OaCallbackService.php     #     回调处理服务
│   │   ├── Finance/                      #   财务服务
│   │   │   ├── SettlementService.php     #     结算服务
│   │   │   ├── ProfitSharingService.php  #     分润服务
│   │   │   ├── InvoiceService.php        #     发票服务
│   │   │   └── CreditService.php         #     信用额度服务
│   │   ├── Pricing/                      #   销售策略服务
│   │   │   ├── PricingService.php        #     销售价计算
│   │   │   └── ServiceFeeService.php     #     服务费计算
│   │   ├── Corporate/                    #   大客户服务
│   │   │   ├── CorporateService.php      #     大客户管理
│   │   │   └── CorporateMatchService.php #     大客户匹配(出票时)
│   │   ├── Member/                       #   会员服务
│   │   │   ├── MemberService.php         #     会员主服务
│   │   │   ├── MemberGradeService.php    #     等级升级服务
│   │   │   └── SignInService.php         #     签到服务
│   │   ├── Coupon/                       #   优惠券服务
│   │   │   └── CouponService.php         #     优惠券发放/核销
│   │   ├── Notify/                       #   消息通知服务
│   │   │   ├── NotifyService.php         #     通知主服务(工厂)
│   │   │   ├── SmsNotifyService.php      #     短信通知
│   │   │   ├── WechatNotifyService.php   #     微信模板消息
│   │   │   └── InboxNotifyService.php    #     站内信
│   │   ├── Mall/                         #   积分商城服务
│   │   │   ├── GoodsService.php
│   │   │   ├── CartService.php
│   │   │   └── ExchangeService.php
│   │   └── OpenApi/                      #   开放平台服务
│   │       ├── OpenApiAuthService.php     #     API鉴权
│   │       └── OpenApiBillingService.php  #     计费服务
│   │
│   ├── Model/                            # 数据模型层(Eloquent ORM)
│   │   ├── Order/                        #   订单域
│   │   │   ├── Order.php
│   │   │   ├── OrderItemFlight.php
│   │   │   ├── OrderItemHotel.php
│   │   │   ├── OrderItemTrain.php
│   │   │   ├── OrderItemCar.php
│   │   │   ├── OrderProcurement.php
│   │   │   └── OrderStatusLog.php
│   │   ├── Air/                          #   航空域
│   │   │   ├── AirAirline.php
│   │   │   ├── AirAirport.php
│   │   │   ├── AirCabin.php
│   │   │   └── AirGauge.php
│   │   ├── Finance/                      #   财务域
│   │   │   ├── FinanceCompanyAccount.php
│   │   │   ├── FinanceRefund.php
│   │   │   └── FinanceInvoice.php
│   │   ├── Approval/                     #   审批域
│   │   │   ├── ApprovalInstance.php
│   │   │   └── ApprovalRecord.php
│   │   ├── OA/                           #   OA对接域
│   │   │   ├── OaConfig.php
│   │   │   ├── OaUserMapping.php
│   │   │   └── OaCallbackLog.php
│   │   ├── Procurement/                  #   采购域
│   │   │   ├── ProcurementChannel.php
│   │   │   ├── ProcurementAccount.php
│   │   │   └── ProcurementRule.php
│   │   ├── Corporate/                    #   大客户域
│   │   │   ├── CorporateGroup.php
│   │   │   ├── CorporatePolicy.php
│   │   │   └── CorporatePolicyRule.php
│   │   ├── Member/                       #   会员域
│   │   │   ├── CUser.php
│   │   │   ├── CMember.php
│   │   │   ├── CMemberGrade.php
│   │   │   └── CPassenger.php
│   │   ├── Mall/                         #   商城域
│   │   │   ├── MallGoods.php
│   │   │   ├── MallGoodsSku.php
│   │   │   └── MallCart.php
│   │   ├── Pmc/                          #   PMC平台端权限
│   │   │   ├── PmcUser.php
│   │   │   ├── PmcRole.php
│   │   │   └── PmcMenu.php
│   │   ├── Tmc/                          #   TMC集团端权限
│   │   │   ├── TmcUser.php
│   │   │   ├── TmcRole.php
│   │   │   └── TmcMenu.php
│   │   └── Mmc/                          #   MMC商户端权限
│   │       ├── MmcUser.php
│   │       ├── MmcRole.php
│   │       └── MmcMenu.php
│   │
│   ├── Repository/                       # 数据访问层(Mapper)
│   │   ├── Order/
│   │   │   └── OrderRepository.php
│   │   ├── Finance/
│   │   │   └── FinanceRepository.php
│   │   └── ...                           #   与Model一一对应
│   │
│   └── Queue/                            # 异步队列消费者
│       ├── TicketQueueConsumer.php       #   出票队列消费者
│       ├── RefundQueueConsumer.php       #   退款队列消费者
│       ├── NotifyQueueConsumer.php       #   通知队列消费者
│       ├── ProcurementVerifyConsumer.php #   外采核销队列消费者
│       ├── MonthlyBillConsumer.php       #   月结账单生成消费者
│       └── PointsExpireConsumer.php      #   积分过期处理消费者
│
├── config/                               # 配置文件
│   ├── config.php                        #   基础配置
│   ├── routes.php                        #   路由入口
│   └── autoload/
│       ├── server.php                    #   Swoole服务配置
│       ├── databases.php                 #   数据库配置
│       ├── redis.php                     #   Redis配置
│       ├── jwt.php                       #   JWT配置
│       ├── permission.php                #   Casbin权限配置
│       ├── middlewares.php               #   中间件配置
│       ├── queue.php                     #   队列配置(RabbitMQ/Redis)
│       ├── swagger.php                   #   Swagger配置
│       ├── logger.php                    #   日志配置
│       ├── exceptions.php                #   异常处理配置
│       ├── cache.php                     #   缓存配置
│       └── custom/                       #   业务自定义配置
│           ├── procurement.php           #     采购渠道配置
│           ├── oa.php                    #     OA对接配置
│           ├── payment.php               #     支付配置
│           └── notify.php                #     通知渠道配置
│
├── databases/                            # 数据库迁移文件
│   ├── migrations/                       #   迁移文件(按日期前缀)
│   │   ├── 20260627000001_create_approval_instance.php
│   │   ├── 20260627000002_create_approval_record.php
│   │   ├── 20260627000003_create_oa_config.php
│   │   ├── 20260627000004_create_oa_user_mapping.php
│   │   ├── 20260627000005_create_oa_callback_log.php
│   │   ├── 20260627000006_create_procurement_channel.php
│   │   ├── 20260627000007_create_procurement_account.php
│   │   ├── 20260627000008_create_procurement_rule.php
│   │   ├── 20260627000009_create_settlement_config.php
│   │   ├── 20260627000010_create_profit_sharing_rule.php
│   │   └── ...
│   └── seeders/                          #   种子数据
│       ├── base_menu_seeder.php          #     基础菜单
│       ├── base_role_seeder.php          #     基础角色
│       └── base_data_seeder.php          #     基础数据(航司/机场)
│
├── plugin/                               # 插件目录(核心业务模块)
│   ├── hx-air/                           #   航空业务插件
│   │   ├── mine.json                     #     插件定义
│   │   └── src/
│   │       ├── ConfigProvider.php
│   │       ├── Controller/
│   │       ├── Service/
│   │       └── Model/
│   │
│   ├── hx-order/                         #   订单业务插件
│   │   ├── mine.json
│   │   └── src/
│   │       ├── ConfigProvider.php
│   │       ├── Controller/
│   │       ├── Service/
│   │       ├── Model/
│   │       └── Queue/
│   │
│   ├── hx-finance/                       #   财务业务插件
│   │   ├── mine.json
│   │   └── src/
│   │
│   ├── hx-approval/                      #   审批业务插件
│   │   ├── mine.json
│   │   └── src/
│   │
│   ├── hx-oa/                            #   OA对接插件
│   │   ├── mine.json
│   │   └── src/
│   │
│   ├── hx-procurement/                   #   采购业务插件
│   │   ├── mine.json
│   │   └── src/
│   │
│   ├── hx-member/                        #   会员业务插件
│   │   ├── mine.json
│   │   └── src/
│   │
│   ├── hx-mall/                          #   积分商城插件
│   │   ├── mine.json
│   │   └── src/
│   │
│   ├── hx-openapi/                       #   开放平台插件
│   │   ├── mine.json
│   │   └── src/
│   │
│   └── hx-notify/                        #   消息通知插件
│       ├── mine.json
│       └── src/
│
├── storage/                              # 运行时存储
│   ├── logs/                             #   日志文件
│   ├── swagger/                          #   Swagger JSON
│   └── upload/                           #   上传文件
│
├── tests/                                # 测试
│   ├── Unit/                             #   单元测试
│   │   ├── Service/
│   │   └── Model/
│   └── Feature/                          #   功能测试
│       ├── Order/
│       ├── Approval/
│       └── Finance/
│
├── bin/                                  # 可执行文件
│   └── hyperf.php                        #   Hyperf入口
│
├── composer.json                         #   Composer依赖
├── .env.example                          #   环境变量模板
└── docker-compose.yml                    #   Docker编排
```

---

## 三、前端目录结构（MineAdmin-Vue）

```
huaxia-b2b2c-web/                        # 前端根目录
├── src/
│   ├── api/                              # API请求模块
│   │   ├── pmc/                          #   PMC平台端API
│   │   │   ├── system.ts                #     系统管理
│   │   │   ├── tenant.ts                #     租户管理
│   │   │   ├── procurement.ts           #     采购渠道
│   │   │   └── openapi.ts               #     开放平台
│   │   ├── tmc/                          #   TMC集团端API
│   │   │   ├── mmc.ts                   #     商户管理
│   │   │   ├── procurement.ts           #     采购配置
│   │   │   ├── settlement.ts            #     结算
│   │   │   ├── pricing.ts               #     销售策略
│   │   │   ├── profit.ts                #     分润
│   │   │   ├── oa.ts                    #     OA配置
│   │   │   ├── corporate.ts             #     大客户
│   │   │   └── order.ts                 #     订单
│   │   ├── mmc/                          #   MMC商户端API
│   │   │   ├── order.ts                 #     订单
│   │   │   ├── ticket.ts                #     出票
│   │   │   ├── approval.ts              #     审批
│   │   │   ├── coupon.ts                #     优惠券
│   │   │   ├── decorate.ts              #     装修
│   │   │   ├── mall.ts                  #     商城
│   │   │   └── member.ts                #     会员
│   │   └── common/                       #   公共API
│   │       ├── upload.ts                #     上传
│   │       └── dict.ts                  #     字典
│   │
│   ├── views/                            # 页面视图(按端+模块)
│   │   ├── pmc/                          #   PMC平台端页面
│   │   │   ├── system/                   #     系统管理
│   │   │   ├── tenant/                   #     租户管理
│   │   │   ├── procurement/              #     采购渠道管理
│   │   │   ├── openapi/                  #     开放平台
│   │   │   └── report/                   #     报表
│   │   ├── tmc/                          #   TMC集团端页面
│   │   │   ├── mmc/                      #     商户管理
│   │   │   ├── procurement/              #     采购配置
│   │   │   ├── settlement/               #     结算管理
│   │   │   ├── pricing/                  #     销售策略
│   │   │   ├── profit/                   #     分润
│   │   │   ├── oa/                       #     OA对接
│   │   │   ├── corporate/                #     大客户
│   │   │   ├── finance/                  #     财务
│   │   │   └── order/                    #     订单
│   │   ├── mmc/                          #   MMC商户端页面
│   │   │   ├── order/                    #     订单
│   │   │   ├── ticket/                   #     出票
│   │   │   ├── approval/                 #     审批
│   │   │   ├── coupon/                   #     优惠券
│   │   │   ├── decorate/                 #     装修
│   │   │   ├── mall/                     #     商城
│   │   │   └── member/                   #     会员
│   │   └── common/                       #   公共页面
│   │       ├── profile/                  #     个人中心
│   │       └── result/                   #     结果页
│   │
│   ├── components/                       # 公共组件
│   │   ├── FlightSearch/                 #   航班搜索组件
│   │   ├── OrderTable/                   #   订单表格组件
│   │   ├── PriceDisplay/                 #   价格展示组件
│   │   ├── PassengerForm/                #   乘机人表单
│   │   ├── ApprovalStatus/               #   审批状态组件
│   │   └── FinanceChart/                 #   财务图表组件
│   │
│   ├── composables/                      # 组合式函数
│   │   ├── useOrder.ts                   #   订单逻辑复用
│   │   ├── usePrice.ts                   #   价格计算复用
│   │   └── usePermission.ts              #   权限判断复用
│   │
│   ├── stores/                           # Pinia状态管理
│   │   ├── useUserStore.ts               #   用户信息
│   │   ├── usePermissionStore.ts         #   权限菜单
│   │   └── useAppStore.ts                #   应用状态
│   │
│   ├── router/                           # 路由配置
│   │   ├── pmcRoutes.ts                  #   PMC端路由
│   │   ├── tmcRoutes.ts                  #   TMC端路由
│   │   └── mmcRoutes.ts                  #   MMC端路由
│   │
│   ├── layouts/                          # 布局组件
│   │   ├── PmcLayout.vue                 #   PMC端布局
│   │   ├── TmcLayout.vue                 #   TMC端布局
│   │   └── MmcLayout.vue                 #   MMC端布局
│   │
│   └── utils/                            # 工具函数
│       ├── request.ts                    #   HTTP请求封装
│       ├── auth.ts                       #   Token管理
│       └── format.ts                     #   格式化工具
│
├── .env.development                      # 开发环境配置
├── .env.production                       # 生产环境配置
├── package.json
├── tsconfig.json
└── vite.config.ts
```

---

## 四、小程序目录结构（uni-app）

```
huaxia-b2b2c-miniapp/                     # 小程序根目录
├── src/
│   ├── pages/                            # 页面
│   │   ├── index/                        #   首页(可装修)
│   │   ├── flight/                       #   机票搜索/详情/下单
│   │   ├── hotel/                        #   酒店搜索/详情/下单
│   │   ├── train/                        #   火车票搜索/详情/下单
│   │   ├── order/                        #   订单列表/详情
│   │   ├── approval/                     #   差旅审批
│   │   ├── member/                       #   会员中心
│   │   ├── mall/                         #   积分商城
│   │   ├── coupon/                       #   优惠券
│   │   ├── favorite/                     #   收藏
│   │   └── mine/                         #   我的
│   ├── components/                       # 公共组件
│   │   ├── FlightCard/                   #   航班卡片
│   │   ├── OrderCard/                    #   订单卡片
│   │   └── PriceTag/                     #   价格标签
│   ├── api/                              # API请求
│   ├── store/                            # Pinia状态管理
│   ├── utils/                            # 工具函数
│   ├── static/                           # 静态资源
│   └── App.vue
│
├── manifest.json                         # uni-app配置
├── pages.json                            # 页面路由
└── uni.scss                              # 全局样式
```

---

## 五、开发规范

### 5.1 命名规范

| 对象 | 规范 | 示例 |
|------|------|------|
| 数据库表 | 小写+下划线, 按域前缀 | `order_item_flight`, `oa_config` |
| PHP类名 | 大驼峰(PascalCase) | `OrderService`, `ApprovalInstance` |
| PHP方法名 | 小驼峰(camelCase) | `createOrder()`, `getApprovalStatus()` |
| PHP常量 | 大写+下划线 | `ORDER_STATUS_PAID` |
| PHP枚举 | 大驼峰类+小写值 | `enum OrderStatus: string { case Paid = 'paid'; }` |
| API路由 | 小写+短横线, RESTful | `GET /api/v1/order-item-flight/{id}` |
| Vue组件 | 大驼峰(PascalCase) | `FlightSearch.vue`, `OrderTable.vue` |
| Vue文件 | 与组件名一致 | `FlightSearch.vue` |
| CSS类名 | BEM规范 | `order-card__title--active` |
| SQL迁移 | 日期前缀+描述 | `20260627000001_create_approval_instance.php` |

### 5.2 Controller规范

```php
// 1. 每个Controller方法只做: 参数接收 → 调用Service → 返回响应
// 2. 不在Controller中写业务逻辑
// 3. 使用Schema注解自动生成Swagger文档

#[Controller]
#[Api(tags: '审批管理', position: 1)]
class ApprovalController extends AbstractController
{
    #[GetMapping('list')]
    #[Operation(summary: '审批列表')]
    public function list(): Response
    {
        return $this->success($this->service->getPageList($this->request->all()));
    }
    
    #[PostMapping('create')]
    #[Operation(summary: '创建审批')]
    public function create(): Response
    {
        return $this->success($this->service->createApproval($this->request->all()));
    }
}
```

### 5.3 Service规范

```php
// 1. Service承载全部业务逻辑
// 2. 事务在Service层管理
// 3. 使用领域事件解耦
// 4. 全链路trace_id透传

class OrderCreateService
{
    use TraceAwareTrait;  // 自动注入trace_id
    
    public function createOrder(array $data): Order
    {
        return Db::transaction(function () use ($data) {
            // 1. 创建订单
            $order = $this->orderRepository->create($data);
            $order->trace_id = $this->getTraceId();
            
            // 2. 发起领域事件
            EventDispatcher::dispatch(new OrderPaidEvent($order));
            
            return $order;
        });
    }
}
```

### 5.4 Model规范

```php
// 1. Model只定义字段映射、类型转换、关联关系
// 2. 不在Model中写业务逻辑
// 3. 使用Cast进行JSON字段自动转换

#[Model]
class ApprovalInstance extends Model
{
    protected ?string $table = 'approval_instance';
    
    protected array $casts = [
        'biz_data' => 'json',
    ];
    
    protected array $fillable = [
        'tenant_id', 'instance_no', 'title', 'biz_type',
        'mode_type', 'status', 'oa_platform', 'oa_instance_id',
        'trace_id',
    ];
    
    public function records(): HasMany
    {
        return $this->hasMany(ApprovalRecord::class, 'instance_id');
    }
}
```

### 5.5 队列消费者规范

```php
// 1. 消费者类放在 app/Queue/ 目录
// 2. 消费消息时必须校验 schema_version
// 3. 消费失败写入 queue_task 表(status=failed)
// 4. 全链路trace_id从消息体中恢复

class TicketQueueConsumer implements ConsumerInterface
{
    public function consume(ConsumeMessage $message): string
    {
        $data = json_decode($message->getBody(), true);
        TraceHelper::setTraceId($data['trace_id'] ?? '');
        
        try {
            $this->ticketService->processTicket($data);
            return Result::ACK;
        } catch (\Throwable $e) {
            $this->queueTaskService->markFailed($data['task_id'], $e->getMessage());
            return Result::NACK;
        }
    }
}
```

### 5.6 领域事件规范

```php
// 1. 事件类放在 app/Common/Event/
// 2. 事件名: {聚合}{动作}Event (如 OrderPaidEvent)
// 3. 监听器放在 app/Common/Listener/
// 4. 监听器名: On{动作} (如 OnOrderPaid)

// 事件定义
class OrderPaidEvent
{
    public function __construct(
        public readonly int $orderId,
        public readonly string $traceId,
        public readonly array $snapshot = [],  // 业务数据快照
    ) {}
}

// 监听器注册 (config/autoload/listener.php)
return [
    OnOrderPaid::class,
    OnApprovalApproved::class,
    OnTicketResult::class,
];
```

### 5.7 插件开发规范

```json
// plugin/hx-order/mine.json
{
    "name": "hx-order",
    "title": "订单管理",
    "description": "华夏航服订单管理插件",
    "version": "1.0.0",
    "author": "huaxia",
    "dependencies": {
        "hx-air": ">=1.0.0",
        "hx-finance": ">=1.0.0"
    }
}
```

```php
// plugin/hx-order/src/ConfigProvider.php
class ConfigProvider
{
    public function __invoke(): array
    {
        return [
            'commands' => [],
            'dependencies' => [],
            'listeners' => [
                OnOrderPaid::class,
            ],
            'annotations' => [
                'scan' => [
                    'paths' => [
                        __DIR__,
                    ],
                ],
            ],
        ];
    }
}
```

### 5.8 Git分支规范

```
main              # 生产分支
├── develop       # 开发主分支
├── feature/xxx   # 功能分支
├── fix/xxx       # Bug修复分支
├── release/x.x   # 发布分支
└── hotfix/xxx    # 紧急修复分支
```

### 5.9 提交信息规范

```
feat(order): 新增订单创建接口
fix(approval): 修复审批回调幂等校验
refactor(procurement): 重构采购渠道适配器为策略模式
docs(api): 更新开放平台API文档
test(finance): 新增分润计算单元测试
chore(deps): 升级Hyperf到3.1.40
```

### 5.10 接口版本规范

```
/api/v1/order/create       # 当前版本
/api/v2/order/create       # 大版本升级(破坏性变更)

版本策略:
- v1→v2: 字段删除/重命名/类型变更等破坏性变更
- v1内: 新增可选字段、新增接口,不升级版本号
- 旧版本至少保留6个月过渡期
```

---

## 六、MineAdmin三端适配方案

### 6.1 三端登录入口

MineAdmin默认单端，需扩展为三端独立登录：

| 端 | 登录入口 | JWT标识 | 中间件 |
|----|---------|--------|--------|
| PMC | `POST /admin/passport/login` | `guard: pmc` | PmcAuthMiddleware |
| TMC | `POST /tmc/passport/login` | `guard: tmc` | TmcAuthMiddleware |
| MMC | `POST /mmc/passport/login` | `guard: mmc` | MmcAuthMiddleware |
| C端 | `POST /api/c/auth/login` | `guard: c` | CAuthMiddleware |
| 开放平台 | `POST /open/auth/token` | `apiKey + sign` | OpenApiAuthMiddleware |

### 6.2 中间件注册

```php
// config/autoload/middlewares.php
return [
    'http' => [
        // PMC端
        PmcAuthMiddleware::class,
        // TMC端
        TmcAuthMiddleware::class,
        // MMC端
        MmcAuthMiddleware::class,
        // C端
        CAuthMiddleware::class,
        // 开放平台
        OpenApiAuthMiddleware::class,
        // 全链路追踪
        TraceMiddleware::class,
        // 租户数据隔离
        TenantScopeMiddleware::class,
    ],
];
```

### 6.3 Casbin权限策略

三端共用Casbin引擎，各自独立的策略表：

```php
// config/autoload/permission.php
return [
    'model' => [
        // PMC端策略
        'pmc' => [
            'type' => 'file',
            'path' => BASE_PATH . '/config/casbin/pmc_model.conf',
        ],
        // TMC端策略
        'tmc' => [
            'type' => 'file',
            'path' => BASE_PATH . '/config/casbin/tmc_model.conf',
        ],
        // MMC端策略
        'mmc' => [
            'type' => 'file',
            'path' => BASE_PATH . '/config/casbin/mmc_model.conf',
        ],
    ],
    'adapter' => [
        'pmc' => PmcCasbinRule::class,
        'tmc' => TmcCasbinRule::class,
        'mmc' => MmcCasbinRule::class,
    ],
];
```

---

## 七、开发环境启动

```bash
# 1. 克隆项目
composer create-project mineadmin/mineadmin huaxia-b2b2c --keep-vcs

# 2. 安装后端依赖
cd huaxia-b2b2c
composer install

# 3. 配置环境变量
cp .env.example .env
# 编辑 .env 配置数据库/Redis

# 4. 执行数据库迁移
php bin/hyperf.php migrate

# 5. 初始化种子数据
php bin/hyperf.php db:seed

# 6. 启动后端开发服务
composer dev
# 后端服务: http://127.0.0.1:9501
# Swagger: http://127.0.0.1:9503/swagger

# 7. 安装前端依赖
cd web
pnpm install

# 8. 启动前端开发服务
pnpm dev
# 前端页面: http://127.0.0.1:2888

# 9. 安装业务插件
php bin/hyperf.php mine:plugin-install hx-air
php bin/hyperf.php mine:plugin-install hx-order
# ... 依次安装所有业务插件
```
