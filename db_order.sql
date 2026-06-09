/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : localhost:3306
 Source Schema         : db_order

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 27/05/2026 11:25:30
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_order
-- ----------------------------
DROP TABLE IF EXISTS `t_order`;
CREATE TABLE `t_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `order_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_order
-- ----------------------------
INSERT INTO `t_order` VALUES (1, 1, 1, 'cf291fd6-4a3d-4125-af6c-606990c722e1');
INSERT INTO `t_order` VALUES (2, 1, 1, 'df387c0e-4e16-46f5-ae17-8721b6673b06');
INSERT INTO `t_order` VALUES (3, 1, 4, 'f1ed587a-3929-4b40-a748-57db9c747c8e');
INSERT INTO `t_order` VALUES (4, 1, 1, 'a94ee4e7-90be-42e6-a3c8-9a2986a8ccbe');
INSERT INTO `t_order` VALUES (5, 1, 1, '6b9b93ba-e13c-40ec-a1f3-b3687edb9aeb');
INSERT INTO `t_order` VALUES (6, 1, 1, 'b5621303-c0d9-429c-b55e-6cf1f22da95a');
INSERT INTO `t_order` VALUES (7, 1, 1, 'a581dcb5-c5d4-4072-a0fb-d444de3802d1');
INSERT INTO `t_order` VALUES (8, 1, 1, 'dd727104-db1d-43b3-9686-2ef68eb1f1cd');
INSERT INTO `t_order` VALUES (9, 2, 1, '5d2b60df-0f24-4a7c-b182-1f6c24578012');
INSERT INTO `t_order` VALUES (10, 2, 3, '734f984b-22bc-4295-a8de-651d3640d025');
INSERT INTO `t_order` VALUES (11, 2, 10, '8d26fd04-ec9e-48ad-90c2-a1a417834eaa');
INSERT INTO `t_order` VALUES (12, 2, 2, '49a8b386-b854-491a-b9b9-7d8abe2d4a29');
INSERT INTO `t_order` VALUES (13, 2, 9, 'c0ff6d3f-2def-4e74-989e-623737d3be0e');
INSERT INTO `t_order` VALUES (14, 2, 1, '0f953265-2acf-4d10-9b10-45df5fd4e3f4');
INSERT INTO `t_order` VALUES (15, 2, 6, 'b84cc6cf-1a25-4f61-b06a-2c514339cd54');
INSERT INTO `t_order` VALUES (16, 2, 1, '64628207-2b7f-4860-9e00-cbc906384ab6');
INSERT INTO `t_order` VALUES (17, 2, 9, '5f3fb291-8464-4b3a-a1af-e5620228b4f2');
INSERT INTO `t_order` VALUES (18, 2, 1, '09306c72-8432-4a12-9bb8-9c6357b9dcc1');
INSERT INTO `t_order` VALUES (19, 6, 9, '7f917a65-487c-4c8c-8bc6-8315541466c1');
INSERT INTO `t_order` VALUES (20, 6, 1, '35140761-3601-4a19-b494-56cf6d9ec613');
INSERT INTO `t_order` VALUES (21, 6, 3, '64ff3a55-a7b4-4cf3-b48c-ae6353ae9136');
INSERT INTO `t_order` VALUES (22, 6, 1, '3302ffee-5595-4fba-9f1b-26531b019700');
INSERT INTO `t_order` VALUES (23, 6, 3, 'e4e105ea-8964-4d86-9e24-20314022616e');
INSERT INTO `t_order` VALUES (24, 6, 10, '7111864d-fa39-4cf1-9ba9-dec08e65d8da');
INSERT INTO `t_order` VALUES (25, 6, 10, 'ef932591-f8a1-4ae6-bd02-9c798ae11944');

-- ----------------------------
-- Table structure for undo_log
-- ----------------------------
DROP TABLE IF EXISTS `undo_log`;
CREATE TABLE `undo_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `branch_id` bigint NOT NULL COMMENT '分支事务id',
  `xid` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '全局事务id',
  `context` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '上下文',
  `rollback_info` longblob NOT NULL COMMENT '回滚信息',
  `log_status` int NOT NULL COMMENT '日志状态 0:正常 1:已完成',
  `log_created` datetime NOT NULL COMMENT '创建时间',
  `log_modified` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ux_undo_log`(`xid` ASC, `branch_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'Seata分布式事务回滚日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of undo_log
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
