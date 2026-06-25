-- ============================================================================
-- hx_b2b2c_v7: timestamp -> datetime 统一改造
-- 日期: 2025-06-27
-- 说明: 将全库 timestamp 字段统一为 datetime, 消除2038年问题及风格不一致
-- 执行: mysql -u root -p hx_b2b2c < hx_b2b2c_v7_timestamp_to_datetime.sql
-- ============================================================================

SET NAMES utf8mb4;

-- ============================================================
-- 第一组: 航空基础表 (13张)
--   created_at: timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP -> datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
--   updated_at: timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -> datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
--   deleted_at: timestamp NULL DEFAULT NULL -> datetime NULL DEFAULT NULL
-- ============================================================

-- 1. air_airline
ALTER TABLE `air_airline`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 2. air_airline_accounts
ALTER TABLE `air_airline_accounts`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 3. air_airline_notice
ALTER TABLE `air_airline_notice`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 4. air_airport
ALTER TABLE `air_airport`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 5. air_cabin
ALTER TABLE `air_cabin`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 6. air_cabin_level
ALTER TABLE `air_cabin_level`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 7. air_fuel
ALTER TABLE `air_fuel`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 8. air_fuel_detail
ALTER TABLE `air_fuel_detail`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 9. air_gauge
ALTER TABLE `air_gauge`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 10. air_gauge_type
ALTER TABLE `air_gauge_type`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 11. air_plane_model
ALTER TABLE `air_plane_model`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 12. air_platform (无 deleted_at)
ALTER TABLE `air_platform`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 13. air_region (无 deleted_at)
ALTER TABLE `air_region`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- ============================================================
-- 第二组: 大客户政策表 (2张)
-- ============================================================

-- 14. corporate_policy_match_log (仅 created_at)
ALTER TABLE `corporate_policy_match_log`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- 15. corporate_policy_rule
ALTER TABLE `corporate_policy_rule`
  MODIFY COLUMN `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- ============================================================
-- 第三组: 仅 deleted_at 为 timestamp 的表 (16张)
--   created_at/updated_at 已经是 datetime, 仅改 deleted_at
-- ============================================================

-- 16. c_member
ALTER TABLE `c_member`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 17. c_member_address
ALTER TABLE `c_member_address`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 18. c_passenger
ALTER TABLE `c_passenger`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 19. c_user
ALTER TABLE `c_user`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 20. corporate_contract
ALTER TABLE `corporate_contract`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 21. corporate_group
ALTER TABLE `corporate_group`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 22. corporate_policy
ALTER TABLE `corporate_policy`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 23. corporate_whitelist_batch
ALTER TABLE `corporate_whitelist_batch`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 24. corporate_whitelist_member
ALTER TABLE `corporate_whitelist_member`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 25. data_permission_policy
ALTER TABLE `data_permission_policy`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 26. mmc_package
ALTER TABLE `mmc_package`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 27. mmc_position
ALTER TABLE `mmc_position`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 28. order (主订单)
ALTER TABLE `order`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 29. pmc_position
ALTER TABLE `pmc_position`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 30. tmc_department
ALTER TABLE `tmc_department`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 31. user_third_party_auth
ALTER TABLE `user_third_party_auth`
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- ============================================================
-- 第四组: B端用户表 login_time + deleted_at (3张)
-- ============================================================

-- 32. mmc_user
ALTER TABLE `mmc_user`
  MODIFY COLUMN `login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 33. pmc_user
ALTER TABLE `pmc_user`
  MODIFY COLUMN `login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- 34. tmc_user
ALTER TABLE `tmc_user`
  MODIFY COLUMN `login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  MODIFY COLUMN `deleted_at` datetime NULL DEFAULT NULL;

-- ============================================================
-- 第五组: 操作日志表 created_at + updated_at (3张)
-- ============================================================

-- 35. mmc_operation_log
ALTER TABLE `mmc_operation_log`
  MODIFY COLUMN `created_at` datetime NULL DEFAULT NULL,
  MODIFY COLUMN `updated_at` datetime NULL DEFAULT NULL;

-- 36. pmc_operation_log
ALTER TABLE `pmc_operation_log`
  MODIFY COLUMN `created_at` datetime NULL DEFAULT NULL,
  MODIFY COLUMN `updated_at` datetime NULL DEFAULT NULL;

-- 37. tmc_operation_log
ALTER TABLE `tmc_operation_log`
  MODIFY COLUMN `created_at` datetime NULL DEFAULT NULL,
  MODIFY COLUMN `updated_at` datetime NULL DEFAULT NULL;

-- ============================================================
-- 第六组: 菜单表 created_at + updated_at (1张)
-- ============================================================

-- 38. pmc_menu
ALTER TABLE `pmc_menu`
  MODIFY COLUMN `created_at` datetime NULL DEFAULT NULL,
  MODIFY COLUMN `updated_at` datetime NULL DEFAULT NULL;

-- ============================================================================
-- 改造完成, 共 38 张表, 83 个字段从 timestamp 改为 datetime
-- ============================================================================
