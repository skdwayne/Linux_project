mysql相关


Atlas
Atlas是由 Qihoo 360,  Web平台部基础架构团队开发维护的一个基于MySQL协议的数据中间层项目。它在MySQL官方推出的MySQL-Proxy 0.8.2版本的基础上，修改了大量bug，添加了很多功能特性。目前该项目在360公司内部得到了广泛应用，很多MySQL业务已经接入了Atlas平台，每天承载的读写请求数达几十亿条。

中间件可放在web上    节省服务器

mysql -uroot -poldboy123 -S /data/3308/mysql.sock<<EOF
change master  to
master_host='172.16.1.51',
master_user='rep',
master_password='oldboy123',
MASTER_LOG_FILE='mysql-bin.000673',
MASTER_LOG_POS=1602;
EOF

mysql -uroot -poldboy123 -S /data/3307/mysql.sock -e 'show slave status\G'|egrep "_Behind_|Slave"


监控MySQL主从是否同步

主库建表，每隔多久写入当前时间，从库将时间与当前系统时间比对，如果不一致  相差
超过两秒，我们就认为  延迟


在从库的my.cnf中加入如下参数，然后重启服务生效即可。
log-slave-updates  #<==必须要有这个参数
     log-bin = /data/3307/mysql-bin
     expire_logs_days = 7  #<==相当于find /data/3307/ -type f -name " mysql-bin.000*" -mtime +7 |xargs rm -f

innodb_buffer_pool_size = 2048M   给数据库所有内存的百分之30 左右  具体还需要看业务

不要用MySQL自带的缓存
query  什么什么的

共享表空间对应物理数据文件：
[root@resin01 3306]# ll /data/3306/data/ibdata1 
-rw-rw---- 1 mysql mysql 134217728 01-27 14:19 /data/3306/data/ibdata1
独立表空间对应物理数据文件：
innodb_file_per_table
innodb_data_home_dir = /data/xxx

 有关事务内容  了解
http://www.cnblogs.com/ymy124/p/3718439.html



MySQL参数详解   整理
http://www.xuliangwei.com/xubusi/213.html

MyISAM引擎重要参数：
key_buffer_size = 1024M
session级别参数及全局参数：
sort_buffer_size = 1M
join_buffer_size = 1M

session级别参数 每线程独占，不能太大 


创建后引擎的更改，5.0以上：
ALTER TABLE oldboy ENGINE = INNODB;
ALTER TABLE oldboy ENGINE = MyISAM;


mysqldump > oldboy_1.sql
nohup sed -e 's/MyISAM/InnoDB/g' old2boy.sql > oldboy_1.sql &
mysql <oldboy_1.sql
数据量不好。
-d表结构
-t数据



独立命令：
mysql_convert_table_format  --user=root --password=oldboy123 --socket=/data/3306/mysql.sock --engine=MyISAM oldboy t2
依赖：yum -y install perl-DBI perl-DBD-MySQL perl-Time-HiRes 

[root@db01 mysql]# which mysql_convert_table_format
/application/mysql/bin/mysql_convert_table_format


		

命令语法：rename table 原表名 to 新表名; 
alter table oldboy rename to test;

mysql> rename table test to oldboy;
Query OK, 0 rows affected (0.00 sec)

mysql> show tables;
+------------------+
| Tables_in_oldboy |
+------------------+
| oldboy           |
+------------------+
1 row in set (0.00 sec)


mysql> alter table oldboy rename to test;
Query OK, 0 rows affected (0.00 sec)

mysql> show tables;
+------------------+
| Tables_in_oldboy |
+------------------+
| test             |
+------------------+
1 row in set (0.00 sec)



mysql> drop table test;
Query OK, 0 rows affected (0.00 sec)

mysql> show tables;
Empty set (0.00 sec)

mysql> drop database oldboy;
Query OK, 0 rows affected (0.02 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| gbk_oldboy         |
| mysql              |
| performance_schema |
| test               |
+--------------------+
5 rows in set (0.00 sec)



delimiter $$  指定结束符

drop procedure if exists pro_test $$

create procedure pro_test(in loop_test int) begin  declare i int default 0; declare rand_num int; while i< loop_test do select cast(rand()*10000 as unsigned) into rand_num; insert into test(num) values(rand_num); set i = i+1; end while;end $$

delimiter ;

call pro_test(5000000);
会比较慢，需要等


[root@db01 tmp]# gzip -d b.sql.gz 
[root@db01 tmp]# ls
a.sql.gz  B_oldboy.sql  b.sql  noB_oldboy.sql.gz
[root@db01 tmp]# mysql -uroot -p123456 -S /data/3306//mysql.sock <b.sql 
[root@db01 tmp]# mysql -uroot -p123456 -S /data/3306//mysql.sock -e "select * from oldboy.test;"
+----+---------+
| id | name    |
+----+---------+
|  3 | inca    |
|  5 | kaka    |
|  1 | oldboy  |
|  2 | oldgirl |
|  4 | zuma    |
+----+---------+


[root@db01 tmp]# mysql -uroot -p123456 -S /data/3306//mysql.sock -e "create database oldboy;"
[root@db01 tmp]# mysql -uroot -p123456 -S /data/3306/mysql.sock <a.sql 
ERROR 1046 (3D000) at line 22: No database selected
[root@db01 tmp]# mysql -uroot -p123456 -S /data/3306/mysql.sock oldboy<a.sql 
[root@db01 tmp]# mysql -uroot -p123456 -S /data/3306//mysql.sock -e "select * from oldboy.test;"
+----+---------+
| id | name    |
+----+---------+
|  3 | inca    |
|  5 | kaka    |
|  1 | oldboy  |
|  2 | oldgirl |
|  4 | zuma    |
+----+---------+






老男孩老师工作中 遇到  单表2亿条



http://www.cnblogs.com/pedro/p/4627239.html



