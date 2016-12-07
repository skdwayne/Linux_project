热备的工具xtrabackup。

1.备份数据使用-B参数，会在备份数据中增加建库及use库的语句。
2.备份数据使用-B参数，使得后面可以直接接多个库名。

[root@db01 ~]# mysqldump -uroot -p123456 -S /data/3306/mysql.sock -B test >/tmp/test.sql

[root@db01 ~]# 
[root@db01 ~]# mysqldump -uroot -p123456 -S /data/3306/mysql.sock test >/tmp/nob_test.sql

mysqldump -uroot -p123456 --events -S /data/3306/mysql.sock -A >/tmp/all_test.sql




b. -B参数说明
提示：-B参数是关键，表示接多个库，并且增加use db,和create database db的信息。
※※※※※（生产环境常用）
  -B, --databases     To dump several databases. Note the difference in usage;
                      In this case no tables are given. All name arguments are
                      regarded as databasenames. 'USE db_name;' will be
                      included in the output.
参数说明：该参数用于导出若干个数据库，在备份结果中会加入CREATE DATABASE `db_name`和USE db_name;
         -B后的参数都将被作为数据库名。该参数比较常用。当-B后的数据库列全时 同 -A参数。请看-A的说明。

		 


