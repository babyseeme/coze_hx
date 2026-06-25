/*
 Navicat MySQL Data Transfer

 Source Server         : 47.109.88.164（node-master）
 Source Server Type    : MySQL
 Source Server Version : 80035
 Source Host           : 47.109.88.164:30006
 Source Schema         : hx_b2b2c

 Target Server Type    : MySQL
 Target Server Version : 80035
 File Encoding         : 65001

 Date: 25/06/2026 16:06:41
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for attachment
-- ----------------------------
DROP TABLE IF EXISTS `attachment`;
CREATE TABLE `attachment`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `storage_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local' COMMENT '存储模式:local=本地,oss=阿里云,qiniu=七牛云,cos=腾讯云',
  `origin_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原文件名',
  `object_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新文件名',
  `hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件hash',
  `mime_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源类型',
  `storage_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '存储目录',
  `suffix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件后缀',
  `size_byte` bigint NULL DEFAULT NULL COMMENT '字节数',
  `size_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件大小',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'url地址',
  `created_by` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updated_by` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `attachment_hash_unique`(`hash` ASC) USING BTREE,
  INDEX `attachment_storage_path_index`(`storage_path` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '上传文件信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for data_permission_policy
-- ----------------------------
DROP TABLE IF EXISTS `data_permission_policy`;
CREATE TABLE `data_permission_policy`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pmc' COMMENT '所属端:pmc/tmc/mmc',
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '租户ID,saas端=0',
  `user_id` bigint NOT NULL DEFAULT 0 COMMENT '用户ID（与角色二选一）',
  `position_id` bigint NOT NULL DEFAULT 0 COMMENT '岗位ID（与用户二选一）',
  `role_id` bigint NOT NULL DEFAULT 0 COMMENT '角色ID(user/position/role 三选一)',
  `policy_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '策略类型（DEPT_SELF, DEPT_TREE, ALL, SELF, CUSTOM_DEPT, CUSTOM_FUNC）',
  `resource` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '作用资源:order/customer/...',
  `is_default` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否默认策略（默认值：true）',
  `value` json NULL COMMENT '策略值',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_subject`(`platform` ASC, `tenant_id` ASC, `user_id` ASC, `role_id` ASC, `position_id` ASC) USING BTREE,
  INDEX `idx_resource`(`platform` ASC, `tenant_id` ASC, `resource` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '数据权限策略' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_department
-- ----------------------------
DROP TABLE IF EXISTS `mmc_department`;
CREATE TABLE `mmc_department`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_parent`(`tenant_id` ASC, `parent_id` ASC, `sort` ASC) USING BTREE,
  INDEX `idx_tenant_path`(`tenant_id` ASC, `path`(200) ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_dept_leader
-- ----------------------------
DROP TABLE IF EXISTS `mmc_dept_leader`;
CREATE TABLE `mmc_dept_leader`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dept_user`(`dept_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant部门领导' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_login_log
-- ----------------------------
DROP TABLE IF EXISTS `mmc_login_log`;
CREATE TABLE `mmc_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '商户租户ID',
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 mmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1,
  `message` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_user_time`(`tenant_id` ASC, `user_id` ASC, `login_time` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MMC 端登录日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_menu
-- ----------------------------
DROP TABLE IF EXISTS `mmc_menu`;
CREATE TABLE `mmc_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` tinyint NOT NULL DEFAULT 2 COMMENT '1=目录,2=菜单,3=按钮',
  `permission_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `meta` json NULL,
  `path` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `component` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `redirect` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_perm_key`(`permission_key` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant端菜单(全局共享)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `mmc_operation_log`;
CREATE TABLE `mmc_operation_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 mmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `router` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_user_time`(`tenant_id` ASC, `user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MMC 端操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_package
-- ----------------------------
DROP TABLE IF EXISTS `mmc_package`;
CREATE TABLE `mmc_package`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'system=平台标准模板,tmc=TMC自定义',
  `owner_tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'TMC租户ID,system=0',
  `package_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `package_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `applicable_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'merchant' COMMENT '应用对象:merchant=商户/distributor=分销商/all=通用',
  `source_template_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '派生自哪个system模板,0=完全自建',
  `account_count` int UNSIGNED NOT NULL DEFAULT 50 COMMENT '账号数量上限',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '1=启用,2=停用',
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_owner_code`(`owner_type` ASC, `owner_tenant_id` ASC, `package_code` ASC) USING BTREE,
  INDEX `idx_owner_status`(`owner_type` ASC, `owner_tenant_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_template`(`source_template_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商户套餐表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_package_menu
-- ----------------------------
DROP TABLE IF EXISTS `mmc_package_menu`;
CREATE TABLE `mmc_package_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `package_id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL COMMENT '指向 mmc_menu.id',
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_package_menu`(`package_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_menu`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商户套餐-菜单关联' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_position
-- ----------------------------
DROP TABLE IF EXISTS `mmc_position`;
CREATE TABLE `mmc_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_dept`(`tenant_id` ASC, `dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_role
-- ----------------------------
DROP TABLE IF EXISTS `mmc_role`;
CREATE TABLE `mmc_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `mmc_role_menu`;
CREATE TABLE `mmc_role_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `idx_menu`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant角色-菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_user
-- ----------------------------
DROP TABLE IF EXISTS `mmc_user`;
CREATE TABLE `mmc_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT '商户/分销商租户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名(商户内唯一)',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `employee_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '手机号密文',
  `phone_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '手机号HMAC',
  `email` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '邮箱密文',
  `email_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '邮箱HMAC',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `signed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_owner` tinyint NOT NULL DEFAULT 2 COMMENT '是否商户主管理员:1=是,2=否',
  `status` tinyint NOT NULL DEFAULT 1,
  `enable_2fa` tinyint NOT NULL DEFAULT 2,
  `pwd_error_count` tinyint NOT NULL DEFAULT 0,
  `locked_until` datetime NULL DEFAULT NULL,
  `password_updated_at` datetime NULL DEFAULT NULL,
  `login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `login_time` timestamp NULL DEFAULT NULL,
  `backend_setting` json NULL,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_username`(`tenant_id` ASC, `username` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_phone_hash`(`tenant_id` ASC, `phone_hash` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_email_hash`(`tenant_id` ASC, `email_hash` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_phone_hash`(`phone_hash` ASC) USING BTREE,
  INDEX `idx_email_hash`(`email_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MMC 端用户表(商户/分销商)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_user_dept
-- ----------------------------
DROP TABLE IF EXISTS `mmc_user_dept`;
CREATE TABLE `mmc_user_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_dept`(`tenant_id` ASC, `user_id` ASC, `dept_id` ASC) USING BTREE,
  INDEX `idx_dept`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant用户-部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_user_position
-- ----------------------------
DROP TABLE IF EXISTS `mmc_user_position`;
CREATE TABLE `mmc_user_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `position_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_position`(`tenant_id` ASC, `user_id` ASC, `position_id` ASC) USING BTREE,
  INDEX `idx_position`(`position_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant用户-岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mmc_user_role
-- ----------------------------
DROP TABLE IF EXISTS `mmc_user_role`;
CREATE TABLE `mmc_user_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role_tenant`(`tenant_id` ASC, `user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_role`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Merchant用户-角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_department
-- ----------------------------
DROP TABLE IF EXISTS `pmc_department`;
CREATE TABLE `pmc_department`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '物化路径 /1/3/7/',
  `level` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `sort` ASC) USING BTREE,
  INDEX `idx_path`(`path`(255) ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_dept_leader
-- ----------------------------
DROP TABLE IF EXISTS `pmc_dept_leader`;
CREATE TABLE `pmc_dept_leader`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `dept_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dept_user`(`dept_id` ASC, `user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS部门领导' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_login_log
-- ----------------------------
DROP TABLE IF EXISTS `pmc_login_log`;
CREATE TABLE `pmc_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 pmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1 COMMENT '1=成功,2=失败',
  `message` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `login_time` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC 端登录日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_menu
-- ----------------------------
DROP TABLE IF EXISTS `pmc_menu`;
CREATE TABLE `pmc_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` tinyint NOT NULL DEFAULT 2 COMMENT '1=目录,2=菜单,3=按钮',
  `permission_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '权限标识 e.g. order:export',
  `meta` json NULL,
  `path` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `component` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `redirect` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_perm_key`(`permission_key` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS平台端菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `pmc_operation_log`;
CREATE TABLE `pmc_operation_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 pmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `router` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC 端操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_position
-- ----------------------------
DROP TABLE IF EXISTS `pmc_position`;
CREATE TABLE `pmc_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dept`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_role
-- ----------------------------
DROP TABLE IF EXISTS `pmc_role`;
CREATE TABLE `pmc_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS平台端角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `pmc_role_menu`;
CREATE TABLE `pmc_role_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_menu`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'SaaS角色-菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_user
-- ----------------------------
DROP TABLE IF EXISTS `pmc_user`;
CREATE TABLE `pmc_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID,主键',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `phone_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '手机号密文(AES-256-GCM,应用层加密)',
  `phone_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '手机号HMAC-SHA256(用于精确查找)',
  `email` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `email_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '邮箱密文(AES-256-GCM)',
  `email_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '邮箱HMAC-SHA256',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户头像',
  `signed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '个人签名',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态:1=正常,2=停用',
  `enable_2fa` tinyint NOT NULL DEFAULT 2 COMMENT '是否启用2FA:1=是,2=否',
  `pwd_error_count` tinyint NOT NULL DEFAULT 0 COMMENT '连续密码错误次数',
  `locked_until` datetime NULL DEFAULT NULL COMMENT '锁定到此时间(NULL=未锁)',
  `password_updated_at` datetime NULL DEFAULT NULL COMMENT '密码上次修改时间',
  `login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `login_time` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `backend_setting` json NULL COMMENT '后台设置数据',
  `created_by` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updated_by` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_username_unique`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_user_phone_hash`(`phone_hash` ASC) USING BTREE,
  UNIQUE INDEX `uk_user_email_hash`(`email_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC 端用户表(平台内部员工)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_user_dept
-- ----------------------------
DROP TABLE IF EXISTS `pmc_user_dept`;
CREATE TABLE `pmc_user_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_dept`(`user_id` ASC, `dept_id` ASC) USING BTREE,
  INDEX `idx_dept`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC用户-部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_user_position
-- ----------------------------
DROP TABLE IF EXISTS `pmc_user_position`;
CREATE TABLE `pmc_user_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `position_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_position`(`user_id` ASC, `position_id` ASC) USING BTREE,
  INDEX `idx_position`(`position_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC用户-岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pmc_user_role
-- ----------------------------
DROP TABLE IF EXISTS `pmc_user_role`;
CREATE TABLE `pmc_user_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_role`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PMC用户-角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for rules
-- ----------------------------
DROP TABLE IF EXISTS `rules`;
CREATE TABLE `rules`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `ptype` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v0` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v1` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v2` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v4` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v5` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ptype_v0_v1`(`ptype` ASC, `v0` ASC, `v1` ASC) USING BTREE,
  INDEX `idx_v1_v2`(`v1` ASC, `v2` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tenant
-- ----------------------------
DROP TABLE IF EXISTS `tenant`;
CREATE TABLE `tenant`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '租户编号',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '租户名称',
  `tenant_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'merchant' COMMENT '租户类型:tmc=集团/merchant=商户/distributor=分销商',
  `parent_tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级租户ID,平台直建=0',
  `package_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '套餐编号(tmc 必填,merchant/distributor=0 改用 mmc_package_id)',
  `mmc_package_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'MMC套餐ID(tenant_type=merchant/distributor 时使用)',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '用户编号，租户管理员',
  `account_count` int UNSIGNED NOT NULL DEFAULT 100 COMMENT '账号最大数量',
  `contact_name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人手机',
  `bind_domain` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '绑定域名',
  `expire_at` datetime NOT NULL COMMENT '过期时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '租户状态:1=正常,2=停用',
  `created_by` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updated_by` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tenant_name_unique`(`name` ASC) USING BTREE,
  INDEX `idx_type_status`(`tenant_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_parent_type`(`parent_tenant_id` ASC, `tenant_type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '租户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_department
-- ----------------------------
DROP TABLE IF EXISTS `tmc_department`;
CREATE TABLE `tmc_department`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_parent`(`tenant_id` ASC, `parent_id` ASC, `sort` ASC) USING BTREE,
  INDEX `idx_tenant_path`(`tenant_id` ASC, `path`(200) ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_dept_leader
-- ----------------------------
DROP TABLE IF EXISTS `tmc_dept_leader`;
CREATE TABLE `tmc_dept_leader`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dept_user`(`dept_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC部门领导' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_login_log
-- ----------------------------
DROP TABLE IF EXISTS `tmc_login_log`;
CREATE TABLE `tmc_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'TMC集团ID',
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 tmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1,
  `message` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_user_time`(`tenant_id` ASC, `user_id` ASC, `login_time` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC 端登录日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_menu
-- ----------------------------
DROP TABLE IF EXISTS `tmc_menu`;
CREATE TABLE `tmc_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` tinyint NOT NULL DEFAULT 2 COMMENT '1=目录,2=菜单,3=按钮',
  `permission_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `meta` json NULL,
  `path` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `component` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `redirect` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_perm_key`(`permission_key` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `sort` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC端菜单(全局共享)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `tmc_operation_log`;
CREATE TABLE `tmc_operation_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '指向 tmc_user.id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `router` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_user_time`(`tenant_id` ASC, `user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC 端操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_package
-- ----------------------------
DROP TABLE IF EXISTS `tmc_package`;
CREATE TABLE `tmc_package`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '套餐ID',
  `package_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '套餐名称',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态:1=正常,2=停用',
  `created_by` bigint NOT NULL DEFAULT 0 COMMENT '创建者',
  `updated_by` bigint NOT NULL DEFAULT 0 COMMENT '更新者',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tenant_package_package_name_unique`(`package_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '多租户套餐' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_package_change_log
-- ----------------------------
DROP TABLE IF EXISTS `tmc_package_change_log`;
CREATE TABLE `tmc_package_change_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `package_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tmc_package/merchant_package',
  `from_package_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `to_package_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `change_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'upgrade/downgrade/bind/unbind',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `operator_id` bigint UNSIGNED NOT NULL,
  `operator_platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_time`(`tenant_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_operator`(`operator_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '租户套餐变更日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_package_menu
-- ----------------------------
DROP TABLE IF EXISTS `tmc_package_menu`;
CREATE TABLE `tmc_package_menu`  (
  `package_id` bigint UNSIGNED NOT NULL COMMENT '套餐ID',
  `menu_id` bigint UNSIGNED NOT NULL COMMENT '菜单ID',
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'mmc' COMMENT '菜单所属端:tmc/mmc',
  PRIMARY KEY (`package_id`, `menu_id`) USING BTREE,
  INDEX `idx_platform_menu`(`platform` ASC, `menu_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_position
-- ----------------------------
DROP TABLE IF EXISTS `tmc_position`;
CREATE TABLE `tmc_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tenant_dept`(`tenant_id` ASC, `dept_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_role
-- ----------------------------
DROP TABLE IF EXISTS `tmc_role`;
CREATE TABLE `tmc_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT 'TMC集团ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  `sort` smallint NOT NULL DEFAULT 0,
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_code`(`tenant_id` ASC, `code` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `tmc_role_menu`;
CREATE TABLE `tmc_role_menu`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `menu_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `idx_tenant`(`tenant_id` ASC) USING BTREE,
  INDEX `idx_menu`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC角色-菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_user
-- ----------------------------
DROP TABLE IF EXISTS `tmc_user`;
CREATE TABLE `tmc_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `tenant_id` bigint UNSIGNED NOT NULL COMMENT 'TMC集团ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名(集团内唯一)',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `employee_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '工号',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `phone_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '手机号密文',
  `phone_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '手机号HMAC',
  `email` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `email_encrypted` varbinary(255) NULL DEFAULT NULL COMMENT '邮箱密文',
  `email_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '邮箱HMAC',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '头像',
  `signed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '个人签名',
  `is_owner` tinyint NOT NULL DEFAULT 2 COMMENT '是否集团主管理员:1=是,2=否',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态:1=正常,2=停用',
  `enable_2fa` tinyint NOT NULL DEFAULT 2 COMMENT '是否启用2FA:1=是,2=否',
  `pwd_error_count` tinyint NOT NULL DEFAULT 0 COMMENT '连续密码错误次数',
  `locked_until` datetime NULL DEFAULT NULL COMMENT '锁定到此时间(NULL=未锁)',
  `password_updated_at` datetime NULL DEFAULT NULL COMMENT '密码上次修改时间',
  `login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `login_time` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `backend_setting` json NULL COMMENT '后台设置数据',
  `created_by` bigint NOT NULL DEFAULT 0,
  `updated_by` bigint NOT NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_username`(`tenant_id` ASC, `username` ASC) USING BTREE,
  INDEX `idx_tenant_status`(`tenant_id` ASC, `status` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_phone_hash`(`tenant_id` ASC, `phone_hash` ASC) USING BTREE,
  UNIQUE INDEX `uk_tenant_email_hash`(`tenant_id` ASC, `email_hash` ASC) USING BTREE,
  INDEX `idx_phone_hash`(`phone_hash` ASC) USING BTREE,
  INDEX `idx_email_hash`(`email_hash` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC 端用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_user_dept
-- ----------------------------
DROP TABLE IF EXISTS `tmc_user_dept`;
CREATE TABLE `tmc_user_dept`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `dept_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_dept`(`tenant_id` ASC, `user_id` ASC, `dept_id` ASC) USING BTREE,
  INDEX `idx_dept`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC用户-部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_user_position
-- ----------------------------
DROP TABLE IF EXISTS `tmc_user_position`;
CREATE TABLE `tmc_user_position`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `position_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_position`(`tenant_id` ASC, `user_id` ASC, `position_id` ASC) USING BTREE,
  INDEX `idx_position`(`position_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC用户-岗位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tmc_user_role
-- ----------------------------
DROP TABLE IF EXISTS `tmc_user_role`;
CREATE TABLE `tmc_user_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role_tenant`(`tenant_id` ASC, `user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_role`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'TMC用户-角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_third_party_auth
-- ----------------------------
DROP TABLE IF EXISTS `user_third_party_auth`;
CREATE TABLE `user_third_party_auth`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属端:pmc/tmc/mmc',
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '租户ID,saas=0',
  `user_id` bigint UNSIGNED NOT NULL COMMENT '端内 user_id (按 platform 指向对应 *_user 表)',
  `provider` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'wechat_mp/wechat_open/wechat_work/wechat_mini/douyin/alipay/qq/dingtalk/feishu',
  `provider_app_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '三方应用 AppID (同 provider 可能多个应用)',
  `open_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '三方应用内唯一标识',
  `union_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '同主体下跨应用唯一标识(微信/支付宝)',
  `unionid_principal` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '开放平台主体ID(多主体场景区分)',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '三方昵称(缓存)',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '三方头像(缓存)',
  `access_token` varbinary(1024) NULL DEFAULT NULL COMMENT 'access_token 密文(AES-256-GCM)',
  `refresh_token` varbinary(1024) NULL DEFAULT NULL COMMENT 'refresh_token 密文',
  `expire_at` datetime NULL DEFAULT NULL COMMENT 'access_token 过期时间',
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '授权 scope (snsapi_userinfo 等)',
  `raw_info` json NULL COMMENT '三方原始返回信息',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态:1=已绑定,2=已解绑',
  `bound_at` datetime NULL DEFAULT NULL COMMENT '首次绑定时间',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最近一次三方登录时间',
  `created_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_provider_app_openid`(`provider` ASC, `provider_app_id` ASC, `open_id` ASC) USING BTREE COMMENT '同应用内 open_id 全局唯一',
  UNIQUE INDEX `uk_user_provider`(`platform` ASC, `tenant_id` ASC, `user_id` ASC, `provider` ASC, `provider_app_id` ASC, `status` ASC) USING BTREE COMMENT '一个账号同一应用只能绑一次(status 参与避免历史解绑记录冲突)',
  INDEX `idx_provider_union`(`provider` ASC, `unionid_principal` ASC, `union_id` ASC) USING BTREE COMMENT '主体内通过 union_id 查全部账号',
  INDEX `idx_user`(`platform` ASC, `user_id` ASC) USING BTREE COMMENT '查某账号绑了哪些三方'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '三方授权绑定表(三端共享)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_third_party_login_log
-- ----------------------------
DROP TABLE IF EXISTS `user_third_party_login_log`;
CREATE TABLE `user_third_party_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属端:pmc/tmc/mmc',
  `tenant_id` bigint UNSIGNED NOT NULL DEFAULT 0,
  `user_id` bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=未绑定/扫码失败/匿名扫码',
  `provider` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `open_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scene` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'login=三方登录,bind=绑定,unbind=解绑,refresh=刷新token',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `os` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `browser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT 1 COMMENT '1=成功,2=失败',
  `error_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '失败错误码',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`platform` ASC, `user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_provider_time`(`provider` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_openid_time`(`provider` ASC, `open_id` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '三方授权登录/绑定日志' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
