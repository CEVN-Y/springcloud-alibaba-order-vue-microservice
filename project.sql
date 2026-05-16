-- ====================== 1. 用户库 db_user ======================
CREATE DATABASE IF NOT EXISTS db_user DEFAULT CHARACTER SET utf8mb4;
USE db_user;

DROP TABLE IF EXISTS t_user;
CREATE TABLE t_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(50) NOT NULL COMMENT '密码',
    phone VARCHAR(20) COMMENT '手机号',
    money DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT '余额'
);

INSERT INTO t_user(username,password,phone,money)
VALUES ('admin','123456','13800138000',100000.00);

-- SEATA回滚表
CREATE TABLE undo_log (
  id bigint NOT NULL AUTO_INCREMENT,
  branch_id bigint NOT NULL,
  xid varchar(100) NOT NULL,
  context varchar(128) NOT NULL,
  rollback_info longblob NOT NULL,
  log_status int NOT NULL,
  log_created datetime NOT NULL,
  log_modified datetime NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_undo_log (xid,branch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ====================== 2. 商品库 db_product ======================
CREATE DATABASE IF NOT EXISTS db_product DEFAULT CHARACTER SET utf8mb4;
USE db_product;

DROP TABLE IF EXISTS t_product;
CREATE TABLE t_product (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '商品ID',
    product_name VARCHAR(100) NOT NULL COMMENT '商品名',
    stock INT NOT NULL DEFAULT 0 COMMENT '库存',
    price DECIMAL(10,2) NOT NULL COMMENT '价格'
);

INSERT INTO t_product(product_name,stock,price) VALUES
('iPhone 15 Pro',99,8999.00),
('AirPods Pro 2',198,1899.00),
('华为 Mate 60 Pro',80,6999.00),
('小米 14 Ultra',90,6499.00),
('OPPO Find X7 Ultra',70,5999.00),
('vivo X100 Pro',85,5999.00),
('荣耀 Magic6 Pro',66,5699.00),
('三星 Galaxy Buds3 Pro',120,1599.00),
('小米 Buds 5 Pro',200,899.00),
('华为 FreeBuds Pro 4',150,1299.00);

-- SEATA回滚表
CREATE TABLE undo_log (
  id bigint NOT NULL AUTO_INCREMENT,
  branch_id bigint NOT NULL,
  xid varchar(100) NOT NULL,
  context varchar(128) NOT NULL,
  rollback_info longblob NOT NULL,
  log_status int NOT NULL,
  log_created datetime NOT NULL,
  log_modified datetime NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_undo_log (xid,branch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ====================== 3. 订单库 db_order ======================
CREATE DATABASE IF NOT EXISTS db_order DEFAULT CHARACTER SET utf8mb4;
USE db_order;

DROP TABLE IF EXISTS t_order;
CREATE TABLE t_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '订单ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    order_no VARCHAR(100) NOT NULL COMMENT '订单号'
);

-- SEATA回滚表
CREATE TABLE undo_log (
  id bigint NOT NULL AUTO_INCREMENT,
  branch_id bigint NOT NULL,
  xid varchar(100) NOT NULL,
  context varchar(128) NOT NULL,
  rollback_info longblob NOT NULL,
  log_status int NOT NULL,
  log_created datetime NOT NULL,
  log_modified datetime NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_undo_log (xid,branch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;