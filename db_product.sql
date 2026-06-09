/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : localhost:3306
 Source Schema         : db_product

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 27/05/2026 11:25:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_product
-- ----------------------------
DROP TABLE IF EXISTS `t_product`;
CREATE TABLE `t_product`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_product
-- ----------------------------
INSERT INTO `t_product` VALUES (1, 'iPhone 15 Pro', 82, 8999.00);
INSERT INTO `t_product` VALUES (2, 'AirPods Pro 2', 197, 1899.00);
INSERT INTO `t_product` VALUES (3, '华为 Mate 60 Pro', 77, 6999.00);
INSERT INTO `t_product` VALUES (4, '小米 14 Ultra', 89, 6499.00);
INSERT INTO `t_product` VALUES (5, 'OPPO Find X7 Ultra', 70, 5999.00);
INSERT INTO `t_product` VALUES (6, 'vivo X100 Pro', 84, 5999.00);
INSERT INTO `t_product` VALUES (7, '荣耀 Magic6 Pro', 66, 5699.00);
INSERT INTO `t_product` VALUES (8, '三星 Galaxy Buds3 Pro', 120, 1599.00);
INSERT INTO `t_product` VALUES (9, '小米 Buds 5 Pro', 197, 899.00);
INSERT INTO `t_product` VALUES (10, '华为 FreeBuds Pro 4', 147, 1299.00);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = 'Seata分布式事务回滚日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of undo_log
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
