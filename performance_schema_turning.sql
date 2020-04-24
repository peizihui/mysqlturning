-- 语句事件记录表，这些表记录了语句事件信息，当前语句事件表events_statements_current、历史语句事件表events_statements_history和长语句历史事件表events_statements_history_long、以及聚合后的摘要表summary，其中，summary表还可以根据帐号(account)，主机(host)，程序(program)，线程(thread)，用户(user)和全局(global)再进行细分)
show tables like '%statement%';




-- 等待事件记录表，与语句事件类型的相关记录表类似：
show tables like '%wait%';


-- 阶段事件记录表，记录语句执行的阶段事件的表
show tables like '%stage%';


-- 事务事件记录表，记录事务相关的事件的表
show tables like '%transaction%';



-- 监控文件系统层调用的表
show tables like '%file%';


-- 监视内存使用的表
show tables like '%memory%';

-- 动态对performance_schema进行配置的配置表
show tables like '%setup%';
