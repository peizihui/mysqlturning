CREATE TEMPORARY TABLE `INNODB_TRX` (
  `trx_id` varchar(18) NOT NULL DEFAULT '', #内部的唯一交易ID号
  `trx_state` varchar(13) NOT NULL DEFAULT '', #事务执行状态。允许值是 RUNNING，LOCK WAIT， ROLLING BACK，和 COMMITTING
  `trx_started` datetime , #交易开始时间。
  `trx_requested_lock_id` varchar(81) DEFAULT NULL, #事务当前正在等待的锁的ID，如果TRX_STATE不是LOCK WAIT; 则为NULL。
  `trx_wait_started` datetime DEFAULT NULL, #事务开始等待锁定的时间，如果 TRX_STATE不是LOCK WAIT; 则为NULL。
  `trx_weight` bigint(21) unsigned NOT NULL DEFAULT '0', #事务的权重，反映（但不一定是确切的计数）更改的行数和事务锁定的行数。
  `trx_mysql_thread_id` bigint(21) unsigned NOT NULL DEFAULT '0', #MySQL线程ID。
  `trx_query` varchar(1024) DEFAULT NULL, #事务正在执行的SQL语句。
  `trx_operation_state` varchar(64) DEFAULT NULL, #事务的当前操作，如果有的话; 否则 NULL。
  `trx_tables_in_use` bigint(21) unsigned NOT NULL DEFAULT '0', #InnoDB处理此事务的当前SQL语句时使用 的表数。
  `trx_tables_locked` bigint(21) unsigned NOT NULL DEFAULT '0', #InnoDB当前SQL语句具有行锁定 的表的数量
  `trx_lock_structs` bigint(21) unsigned NOT NULL DEFAULT '0', #事务保留的锁数。
  `trx_lock_memory_bytes` bigint(21) unsigned NOT NULL DEFAULT '0', #内存中此事务的锁结构占用的总大小。
  `trx_rows_locked` bigint(21) unsigned NOT NULL DEFAULT '0', #此交易锁定的大致数字或行数。该值可能包括实际存在但对事务不可见的删除标记行。
  `trx_rows_modified` bigint(21) unsigned NOT NULL DEFAULT '0', #此事务中已修改和插入的行数。
  `trx_concurrency_tickets` bigint(21) unsigned NOT NULL DEFAULT '0', #指示当前事务在被换出之前可以执行多少工作，由innodb_concurrency_tickets 系统变量指定 。
  `trx_isolation_level` varchar(16) NOT NULL DEFAULT '', #当前事务的隔离级别。
  `trx_unique_checks` int(1) NOT NULL DEFAULT '0', #是否为当前事务打开或关闭唯一检查。例如，在批量数据加载期间可能会关闭它们。
  `trx_foreign_key_checks` int(1) NOT NULL DEFAULT '0', #是否为当前事务打开或关闭外键检查。例如，在批量数据加载期间可能会关闭它们。
  `trx_last_foreign_key_error` varchar(256) DEFAULT NULL, #最后一个外键错误的详细错误消息（如果有）; 否则为NULL。
  `trx_adaptive_hash_latched` int(1) NOT NULL DEFAULT '0', #自适应哈希索引是否被当前事务锁定。当自适应哈希索引搜索系统被分区时，单个事务不会锁定整个自适应哈希索引。自适应哈希索引分区由 innodb_adaptive_hash_index_parts，默认设置为8。
  `trx_adaptive_hash_timeout` bigint(21) unsigned NOT NULL DEFAULT '0', #是否立即为自适应哈希索引放弃搜索锁存器，或者在MySQL的调用之间保留它。当没有自适应哈希索引争用时，该值保持为零，语句保留锁存器直到它们完成。在争用期间，它倒计时到零，并且语句在每次行查找后立即释放锁存器。当自适应散列索引搜索系统被分区（受控制 innodb_adaptive_hash_index_parts）时，该值保持为0。
  `trx_is_read_only` int(1) NOT NULL DEFAULT '0', #值为1表示事务是只读的。
  `trx_autocommit_non_locking` int(1) NOT NULL DEFAULT '0' #值为1表示事务是 SELECT不使用FOR UPDATEor LOCK IN SHARED MODE子句的语句，并且正在执行， autocommit因此事务将仅包含此一个语句。当此列和TRX_IS_READ_ONLY都为1时，InnoDB优化事务以减少与更改表数据的事务关联的开销。
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

