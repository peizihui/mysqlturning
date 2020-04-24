CREATE TEMPORARY TABLE `INNODB_LOCK_WAITS` (
  `requesting_trx_id` varchar(18) NOT NULL DEFAULT '', #请求事务（被阻止）的ID。
  `requested_lock_id` varchar(81) NOT NULL DEFAULT '', #事务正在等待的锁的ID。
  `blocking_trx_id` varchar(18) NOT NULL DEFAULT '', #当前运行事务的ID。
  `blocking_lock_id` varchar(81) NOT NULL DEFAULT '' #进行的事务所持有的锁的ID。
) ENGINE=MEMORY DEFAULT CHARSET=utf8;