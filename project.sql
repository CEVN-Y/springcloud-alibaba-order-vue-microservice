-- 1. 用户库：db_user
CREATE DATABASE IF NOT EXISTS db_user DEFAULT CHARACTER SET utf8mb4;
USE db_user;
DROP TABLE IF EXISTS t_user;
CREATE TABLE t_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    phone VARCHAR(20) COMMENT '手机号'
);
INSERT INTO t_user(username,phone) VALUES ('测试用户','13800138000');

-- 2. 商品库：db_product
CREATE DATABASE IF NOT EXISTS db_product DEFAULT CHARACTER SET utf8mb4;
USE db_product;
DROP TABLE IF EXISTS t_product;
CREATE TABLE t_product (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '商品ID',
    product_name VARCHAR(100) NOT NULL COMMENT '商品名称',
    stock INT NOT NULL DEFAULT 0 COMMENT '库存',
    price DECIMAL(10,2) NOT NULL COMMENT '价格'
);
INSERT INTO t_product(product_name,stock,price) VALUES ('测试商品',10,99.90);

-- 3. 订单库：db_order
CREATE DATABASE IF NOT EXISTS db_order DEFAULT CHARACTER SET utf8mb4;
USE db_order;
DROP TABLE IF EXISTS t_order;
CREATE TABLE t_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '订单ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    order_no VARCHAR(100) NOT NULL COMMENT '订单编号'
);