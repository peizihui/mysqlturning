
CREATE TEMPORARY TABLE `INNODB_LOCKS` (
  `lock_id` varchar(81) NOT NULL DEFAULT '', #内部的唯一锁ID号。
  `lock_trx_id` varchar(18) NOT NULL DEFAULT '', #持有锁的事务的ID。
  `lock_mode` varchar(32) NOT NULL DEFAULT '', #锁定模式。允许锁定模式描述符 S，X， IS，IX， GAP，AUTO_INC。
  `lock_type` varchar(32) NOT NULL DEFAULT '', #锁的类型。行锁还是表锁。
  `lock_table` varchar(1024) NOT NULL DEFAULT '', #已锁定或包含锁定记录的表的名称。
  `lock_index` varchar(1024) DEFAULT NULL, #索引的名称，如果LOCK_TYPE是 RECORD; 否则NULL。
  `lock_space` bigint(21) unsigned DEFAULT NULL, #锁定记录的表空间ID，如果 LOCK_TYPE是RECORD; 否则NULL。
  `lock_page` bigint(21) unsigned DEFAULT NULL, #锁定记录的页码，如果 LOCK_TYPE是RECORD; 否则NULL。
  `lock_rec` bigint(21) unsigned DEFAULT NULL, #页面内锁定记录的堆号，如果 LOCK_TYPE是RECORD; 否则NULL。
  `lock_data` varchar(8192) DEFAULT NULL #与锁相关的数据（如：主键ID值，索引列的值）。如果LOCK_TYPE是RECORD，则显示值，否则显示值NULL。
) ENGINE=MEMORY DEFAULT CHARSET=utf8;