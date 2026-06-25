-- ============================================================================
-- hx_b2b2c_v7: 脱敏字段唯一/查找索引 补充与修正
-- 日期: 2025-06-27
-- 说明: 补充缺失的 hash 查找索引, 确保脱敏场景下的精确查找性能
-- 涉及表: c_passenger / c_user / pmc_user / tmc_user / mmc_user
-- 执行: mysql -u root -p hx_b2b2c < hx_b2b2c_v7_sensitive_hash_indexes.sql
-- ============================================================================

SET NAMES utf8mb4;

-- ============================================================================
-- 现状盘点
-- ============================================================================
--
-- 表              | 已有 hash 索引                                                  | 缺失
-- --------------- | --------------------------------------------------------------- | ----
-- c_passenger     | uk_tenant_member_id_hash(tenant_id,member_id,id_type,id_number_hash) | idx_phone_hash, idx_name_hash
-- c_user          | uk_phone_hash(phone_hash), uk_id_type_hash(id_type,id_number_hash) | idx_real_name_hash
-- pmc_user        | uk_user_phone_hash(phone_hash), uk_user_email_hash(email_hash)    | idx_phone_hash, idx_email_hash (非唯一查找)
-- tmc_user        | uk_tenant_phone_hash, uk_tenant_email_hash, idx_phone_hash, idx_email_hash | 无 (已完整)
-- mmc_user        | uk_tenant_phone_hash, uk_tenant_email_hash, idx_phone_hash, idx_email_hash | 无 (已完整)
--
-- 注: pmc_user 的 uk_user_phone_hash / uk_user_email_hash 本身可做精确查找,
--     但 UNIQUE INDEX 在 NULL 值场景下不参与索引, 补 idx 保证 NULL 行也可被扫描到.
-- ============================================================================

-- ============================================================
-- 1. c_passenger (常用旅客) - 补2个查找索引
-- ============================================================

-- 手机号精确查找(客服按手机号查旅客)
ALTER TABLE `c_passenger`
  ADD INDEX `idx_phone_hash` (`phone_hash` ASC) USING BTREE;

-- 姓名精确查找(客服按姓名查旅客)
ALTER TABLE `c_passenger`
  ADD INDEX `idx_name_hash` (`name_hash` ASC) USING BTREE;

-- ============================================================
-- 2. c_user (C端自然人) - 补1个查找索引
-- ============================================================

-- 真实姓名精确查找(后台按姓名查用户)
ALTER TABLE `c_user`
  ADD INDEX `idx_real_name_hash` (`real_name_hash` ASC) USING BTREE;

-- ============================================================
-- 3. pmc_user (平台用户) - 补2个非唯一查找索引
--    说明: uk_user_phone_hash / uk_user_email_hash 是 UNIQUE,
--    但 UNIQUE INDEX 对 NULL 值不生效(phone_hash/email_hash 允许 NULL),
--    补普通 INDEX 确保已填充 hash 的行都能走索引查找
-- ============================================================

ALTER TABLE `pmc_user`
  ADD INDEX `idx_phone_hash` (`phone_hash` ASC) USING BTREE;

ALTER TABLE `pmc_user`
  ADD INDEX `idx_email_hash` (`email_hash` ASC) USING BTREE;

-- ============================================================================
-- 改造完成, 共补充 5 个索引
--   c_passenger:  +idx_phone_hash, +idx_name_hash
--   c_user:       +idx_real_name_hash
--   pmc_user:     +idx_phone_hash, +idx_email_hash
-- ============================================================================
--
-- 回滚语句 (如需撤销):
-- ALTER TABLE `c_passenger` DROP INDEX `idx_phone_hash`, DROP INDEX `idx_name_hash`;
-- ALTER TABLE `c_user`      DROP INDEX `idx_real_name_hash`;
-- ALTER TABLE `pmc_user`    DROP INDEX `idx_phone_hash`, DROP INDEX `idx_email_hash`;
