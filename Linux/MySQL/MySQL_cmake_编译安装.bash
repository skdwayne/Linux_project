---------MySQL cmake 编译安装

[root@test ~]# wget https://cmake.org/files/v3.6/cmake-3.6.3.tar.gz
[root@test ~]# tar xf cmake-3.6.3.tar.gz 
[root@test ~]# cd cmake-3.6.3
[root@test cmake-3.6.3]# ./configure 
[root@test cmake-3.6.3]# gmake
[root@test cmake-3.6.3]# gmake install
[root@test cmake-3.6.3]# cd

## mysql 依赖包
yum install ncurses-devel libaio-devel -y
useradd -s /sbin/nologin -M mysql

[root@test ~]# tar xf mysql-5.5.32.tar.gz
[root@test ~]# cd mysql-5.5.32

cmake . \
-DCMAKE_INSTALL_PREFIX=/application/mysql-5.5.32 \
-DMYSQL_DATADIR=/application/mysql-5.5.32/data \
-DMYSQL_UNIX_ADDR=/application/mysql-5.5.32/tmp/mysqld.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii \
-DENABLED_LOCAL_INFILE=ON \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
-DWITHOUT_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FAST_MUTEXES=1 \
-DWITH_ZLIB=bundled \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_READLINE=1 \
-DWITH_EMBEDDED_SERVER=1 \
-DWITH_DEBUG=0

make && make install 


[root@test mysql-5.5.32]# ln -s /application/mysql-5.5.32/ /application/mysql



root密码忘了  可以通过  MySQL_safe 搞定

[root@db02 /]# tar zcvf data20161113.mysql.tar.gz data/{3306,3307,3308}/my{sql,.cnf} 
data/3306/mysql
data/3306/my.cnf
data/3307/mysql
data/3307/my.cnf
data/3308/mysql
data/3308/my.cnf


-------------------------------------------
老男孩教育运维28期MySQL编译安装实践
1.3 安装相关包
1.3.1 cmake软件
方法1：优先
yum install cmake -y
rpm -qa cmake

1.3.2 依赖包
yum install ncurses-devel -y

1.4 开始安装mysql
1.4.1 创建用户和组
useradd mysql -s /sbin/nologin -M

1.4.2 解压编译MySQL
tar zxf mysql-5.5.49.tar.gz
cd mysql-5.5.49
cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.5.49 \
-DMYSQL_DATADIR=/application/mysql-5.5.49/data \
-DMYSQL_UNIX_ADDR=/application/mysql-5.5.49/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii \
-DENABLED_LOCAL_INFILE=ON \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
-DWITHOUT_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FAST_MUTEXES=1 \
-DWITH_ZLIB=bundled \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_READLINE=1 \
-DWITH_EMBEDDED_SERVER=1 \
-DWITH_DEBUG=0

-------------------------
cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.5.49 \   ## 安装路径
-DMYSQL_DATADIR=/application/mysql-5.5.49/data \             ## 数据文件路径
-DMYSQL_UNIX_ADDR=/application/mysql-5.5.49/tmp/mysql.sock \   ## sock文件路径  
-DDEFAULT_CHARSET=utf8 \                        ## 字符集
-DDEFAULT_COLLATION=utf8_general_ci \             ##  校对规则
-DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii \         ##  额外字符集
-DENABLED_LOCAL_INFILE=ON \                     
-DWITH_INNOBASE_STORAGE_ENGINE=1 \               ## 支持的引擎
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
-DWITHOUT_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FAST_MUTEXES=1 \
-DWITH_ZLIB=bundled \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_READLINE=1 \
-DWITH_EMBEDDED_SERVER=1 \
-DWITH_DEBUG=0
-------------------

#-- Build files have been written to: /root/tools/mysql-5.5.49
提示，编译时可配置的选项很多，具体可参考结尾附录或官方文档：
make
#[100%] Built target my_safe_process
make install
ln -s /application/mysql-5.5.49/ /application/mysql
ll /application/mysql
如果上述操作未出现错误，则MySQL5.5.49软件cmake方式的安装就算成功了。

初始化

[root@db02 mysql-5.5.49]# /application/mysql-5.5.49/scripts/mysql_install_db --basedir=/application/mysql-5.5.49/ --datadir=/application/mysql-5.5.49/data/ --user=mysql

[root@db02 mysql-5.5.49]# \cp support-files/my-small.cnf /etc/my.cnf


[root@db02 mysql-5.5.49]# cp support-files/mysql.server /etc/init.d/mysqld
[root@db02 mysql-5.5.49]# chmod +x /etc/init.d/mysqld

[root@db02 ~]# mkdir /data/{3306,3307}/data -p





