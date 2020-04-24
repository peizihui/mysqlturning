-- STEP 0  初始化建表；

CREATE TABLE `mylock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `mylock` (`id`, `NAME`) VALUES ('1', 'a');
INSERT INTO `mylock` (`id`, `NAME`) VALUES ('2', 'b');
INSERT INTO `mylock` (`id`, `NAME`) VALUES ('3', 'c');
INSERT INTO `mylock` (`id`, `NAME`) VALUES ('4', 'd');


CREATE TABLE `person_1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



--  step 1  获得表的read锁定
lock table mylock read;

-- step 2; 执行该步骤之后到session_2 执行step3;
select * from mylock;

-- STEP 4 ;;当前session不能查询没有锁定的表
select * from person;
-- 15:05:27	select * from person LIMIT 0, 500	Error Code: 1100. Table 'person' was not locked with LOCK TABLES	0.031 sec

insert into person values(2,'zhangsan');
-- 15:53:35	insert into person values(2,'zhangsan')	Error Code: 1100. Table 'person' was not locked with LOCK TABLES	0.188 sec


-- STEP 5. 当前session插入或者更新表会提示错误
insert into mylock values(9,'f');
-- 15:04:07	insert into mylock values(6,'f')	Error Code: 1099. Table 'mylock' was locked with a READ lock and can't be updated	0.016 sec


update mylock set name='aa' where id = 1;

-- STEP 9 释放锁<br />unlock tables;
unlock tables;