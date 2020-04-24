Step-by-Step 了解 MyISAM 锁机制；

# 1.初始化建表

## 1.1 按着要求建表；

```
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
```

  

## 1.2MySQL  Workbench 分别建立connection;

- connection 1 打开sql 编辑器，命名session_1;
- 在另外一个链接中打开编辑器，命名session_2;

# 2. 执行sql,验证锁机制；

## 2.1  step 1  获得表的read锁定



```
-- step 1  获得表的read锁定
lock table mylock read;
```

![image-20200424154447731](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424154447731.png)

## 2.2 step 2; 执行该步骤之后到session_2 执行step3;

```
-- step 2; 执行该步骤之后到session_2 执行step3;
select * from mylock;
```

![image-20200424154714239](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424154714239.png)



**结论** ：当session1 加锁的时候，当前session1可以查询该表记录



## 2.3 



```
-- STEP 3;
SELECT * FROM halodb.mylock;
```

![image-20200424154837568](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424154837568.png)

**结论** ：当session1 加锁的时候，当前session2可以查询该表记录

## 2.4  STEP 4 在session1 中，查询另外的表；

```
-- STEP 4 ;;当前session不能查询没有锁定的表
select * from person;
```

![image-20200424155147063](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424155147063.png)

**结论** ：在当前session1中，锁没有释放，不能执行另外表的查询；更新也不可以；





## 2.5  STEP 5 ，若session1 锁定mylock表时，session2 可以正常在其他表进行操作；

```
-- 读成功
select * from person;
```

![image-20200424155733416](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424155733416.png)



```
-- 写成功；
insert into person values(2,'lishi');
```

![image-20200424155827978](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424155827978.png)

![image-20200424155850640](http://q8xc9za4f.bkt.clouddn.com/cloudflare/image-20200424155850640.png)



**结论** ： 在session1 中锁定的表mylock，在session1中操作其他表person 提示able 'person' was not locked with LOCK TABLES	；在session2中执行读写都不受影响；者点应该很容易理解；

