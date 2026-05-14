-- Seata AT模式 必须的回滚日志表，db_user、db_product、db_order 三个库都要执行
CREATE TABLE IF NOT EXISTS `undo_log` (
  `id` bigint AUTO_INCREMENT COMMENT '主键id',
  `branch_id` bigint NOT NULL COMMENT '分支事务id',
  `xid` varchar(100) NOT NULL COMMENT '全局事务id',
  `context` varchar(128) NOT NULL COMMENT '上下文',
  `rollback_info` longblob NOT NULL COMMENT '回滚信息',
  `log_status` int NOT NULL COMMENT '日志状态 0:正常 1:已完成',
  `log_created` datetime NOT NULL COMMENT '创建时间',
  `log_modified` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_undo_log` (`xid`,`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Seata分布式事务回滚日志表';