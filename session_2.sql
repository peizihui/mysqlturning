-- STEP 3;
SELECT * FROM halodb.mylock;

-- STEP 5 ，若session1 锁定mylock表时，session 可以正常执行；
-- 读成功
select * from person;
-- 写成功；
insert into person values(2,'lishi');

-- STEP 8  当前session插入数据会等待获得锁
insert into mylock values(8,'f');

