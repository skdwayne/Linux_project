
#火爆MySQL部署现场
#二进制安装MySQL


useradd -s /sbin/nologin  -M mysql

#cd root/tools
tar xf mysql-5.5.51-linux2.6-x86_64.tar.gz
mkdir -p /application/
mv mysql-5.5.51-linux2.6-x86_64 /application/mysql-5.5.51
ln -s /application/mysql-5.5.51/ /application/mysql

chown -R mysql.mysql /application/mysql/

/application/mysql/scripts/mysql_install_db --basedir=/application/mysql --datadir=/application/mysql/data --user=mysql


###故障
##1./tmp权限
##2.主机名解析 hosts解析 #ping 主机名

cp /application/mysql/support-files/mysql.server  /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
sed -i 's#/usr/local/mysql#/application/mysql#g' /application/mysql/bin/mysqld_safe /etc/init.d/mysqld
\cp /application/mysql/support-files/my-small.cnf /etc/my.cnf
/etc/init.d/mysqld start



#PATH路径
echo 'export PATH=/application/mysql/bin:$PATH' >>/etc/profile
source /etc/profile
which mysql

#加入开机自启动
chkconfig --add mysqld
chkconfig mysqld on

#给MySQL root用户设置密码
/application/mysql/bin/mysqladmin -u root password '111111'

#重新登录MySQL数据库
mysql -uroot -p111111
