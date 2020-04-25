Mysql 分析实际操作

# 文档

https://dev.mysql.com/doc/refman/8.0/en/partitioning-types.html



#1. performance schema 分析

## 1.1  哪类的SQL执行最多？

```
-- 1、哪类的SQL执行最多？
SELECT DIGEST_TEXT,COUNT_STAR,FIRST_SEEN,LAST_SEEN FROM events_statements_summary_by_digest ORDER BY COUNT_STAR DESC;
```

![image-20200424164627956](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424164627956.png)

##1.2 哪类SQL的平均响应时间最多？

```
-- 2、哪类SQL的平均响应时间最多？
SELECT DIGEST_TEXT,AVG_TIMER_WAIT FROM events_statements_summary_by_digest ORDER BY COUNT_STAR DESC;
```

![image-20200424165010706](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165010706.png)

## 1.3 哪类SQL排序记录数最多？

```
-- 3、哪类SQL排序记录数最多？
SELECT DIGEST_TEXT,SUM_SORT_ROWS FROM events_statements_summary_by_digest ORDER BY COUNT_STAR DESC;
```

![image-20200424165119616](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165119616.png)



## 1.4 哪类SQL扫描记录数最多？

```
-- 4、哪类SQL扫描记录数最多？
SELECT DIGEST_TEXT,SUM_ROWS_EXAMINED FROM events_statements_summary_by_digest ORDER BY COUNT_STAR DESC;
```

![image-20200424165220072](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165220072.png)



## 1.5 哪类SQL使用临时表最多？

```
-- 5、哪类SQL使用临时表最多？
SELECT DIGEST_TEXT,SUM_CREATED_TMP_TABLES,SUM_CREATED_TMP_DISK_TABLES FROM events_statements_summary_by_digest ORDER BY COUNT_STAR DESC;
```

![image-20200424165316961](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165316961.png)

## 1.6 哪类SQL返回结果集最多？

```
-- 6、哪类SQL返回结果集最多？
SELECT DIGEST_TEXT,SUM_ROWS_SENT FROM events_statements_summary_by_digest ORDER BY COUNT_STAR DESC;
```

![image-20200424165428181](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165428181.png)



## 1.7 哪个表物理IO最多？

```
-- 7、哪个表物理IO最多？
SELECT file_name,event_name,SUM_NUMBER_OF_BYTES_READ,SUM_NUMBER_OF_BYTES_WRITE FROM file_summary_by_instance ORDER BY SUM_NUMBER_OF_BYTES_READ + SUM_NUMBER_OF_BYTES_WRITE DESC;

```

![image-20200424165522249](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165522249.png)

## 1.8  哪个表逻辑IO最多？

```
-- 8、哪个表逻辑IO最多？
SELECT object_name,COUNT_READ,COUNT_WRITE,COUNT_FETCH,SUM_TIMER_WAIT FROM table_io_waits_summary_by_table ORDER BY sum_timer_wait DESC;
```

![image-20200424165639616](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165639616.png)

## 1.9 哪个索引访问最多？



```
-- 9、哪个索引访问最多？
SELECT OBJECT_NAME,INDEX_NAME,COUNT_FETCH,COUNT_INSERT,COUNT_UPDATE,COUNT_DELETE FROM table_io_waits_summary_by_index_usage ORDER BY SUM_TIMER_WAIT DESC ;
```

![image-20200424165810995](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165810995.png)

## 1.10  哪个索引从来没有用过？



```
-- 10、哪个索引从来没有用过？
SELECT OBJECT_SCHEMA,OBJECT_NAME,INDEX_NAME FROM table_io_waits_summary_by_index_usage WHERE INDEX_NAME IS NOT NULL AND COUNT_STAR = 0 AND OBJECT_SCHEMA <> 'mysql' ORDER BY OBJECT_SCHEMA,OBJECT_NAME;

```

![image-20200424165904280](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424165904280.png)

##  1.11、哪个等待事件消耗时间最多？

```
-- 11、哪个等待事件消耗时间最多？
SELECT EVENT_NAME,COUNT_STAR,SUM_TIMER_WAIT,AVG_TIMER_WAIT FROM events_waits_summary_global_by_event_name WHERE event_name != 'idle' ORDER BY SUM_TIMER_WAIT DESC;

```

![image-20200424170149888](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424170149888.png)



## 1.12 剖析某条SQL的执行情况，包括statement信息，stege信息，wait信息

```

-- 12-1、剖析某条SQL的执行情况，包括statement信息，stege信息，wait信息
SELECT EVENT_ID,sql_text FROM events_statements_history WHERE sql_text LIKE '%count(*)%';
```

![image-20200424170330879](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424170330879.png)

## 1.12.2 查看每个阶段的时间消耗



```
-- 12-2、查看每个阶段的时间消耗
SELECT event_id,EVENT_NAME,SOURCE,TIMER_END - TIMER_START FROM events_stages_history_long WHERE NESTING_EVENT_ID = 59;
```

![image-20200424170351782](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424170351782.png)

## 1.12.3 查看每个阶段的锁等待情况

```
-- 12-3、查看每个阶段的锁等待情况
SELECT event_id,event_name,source,timer_wait,object_name,index_name,operation,nesting_event_id FROM events_waits_history_long WHERE nesting_event_id = 1553;
```

![image-20200424170551781](F:\daily shell\mysql-turning\Mysql 分析实际操作.assets\image-20200424170551781.png)



# 2.  

## 2.1  

--  句事件记录表，这些表记录了语句事件信息，当前语句事件表events_statements_current、历史语句事件表events_statements_history和长语句历史事件表events_statements_history_long、以及聚合后的摘要表summary，其中，summary表还可以根据帐号(account)，主机(host)，程序(program)，线程(thread)，用户(user)和全局(global)再进行细分)
show tables like '%statement%';



```
show tables like '%statement%';
```



![image-20200424172609666](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424172609666.png)

## 2.2  等待事件记录表，与语句事件类型的相关记录表类似：

```
--  等待事件记录表，与语句事件类型的相关记录表类似：
show tables like '%wait%';

```

![image-20200424172913247](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424172913247.png)

## 2.3 阶段事件记录表，记录语句执行的阶段事件的表

```


-- 阶段事件记录表，记录语句执行的阶段事件的表
show tables like '%stage%';
```

![image-20200424173019263](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424173019263.png)



## 2.4  事务事件记录表，记录事务相关的事件的表

```
-- 事务事件记录表，记录事务相关的事件的表
show tables like '%transaction%';
```

![image-20200424173117699](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424173117699.png)

<img src="http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424173538682.png" alt="image-20200424173538682" style="zoom:150%;" />

## 2.5 监控文件系统层调用的表

```
-- 监控文件系统层调用的表
show tables like '%file%';
```

![image-20200424173641096](F:\daily shell\mysql-turning\Mysql 分析实际操作.assets\image-20200424173641096.png)

## 2.6  监视内存使用的表

```
-- 监视内存使用的表
show tables like '%memory%';
```

![image-20200424173318276](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424173318276.png)

![image-20200424173721906](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424173721906.png)

## 2.7  动态对performance_schema进行配置的配置表

```
-- 动态对performance_schema进行配置的配置表
show tables like '%setup%';
```

![image-20200424173803433](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424173803433.png)