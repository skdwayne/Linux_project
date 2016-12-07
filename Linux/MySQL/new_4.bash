


yum install httpd zabbix zabbix-server zabbix-web zabbix-server-mysql zabbix-web-mysql mysql-server -y

yum install php55w php55w-mysql php55w-common php55w-gd php55w-mbstring php55w-mcrypt php55w-devel php55w-xml php55w-bcmath -y
cp -R /usr/share/zabbix/ /var/www/html/


mysql -e 'create database zabbix character set utf8 collate utf8_bin;'
gzip -d zabbix_bak.sql.gz
mysql -uroot  <zabbix_bak.sql

mysql -e 'grant all on zabbix.* to zabbix@'localhost' identified by "111111";'
mysql -e 'flush privileges;'



sed -i 's#post_max_size = 8M#post_max_size = 16M#g' /etc/php.ini
sed -i 's#max_execution_time = 30#max_execution_time = 300#g' /etc/php.ini
sed -i 's#max_input_time = 60#max_input_time = 300#g' /etc/php.ini
sed -i 's#;date.timezone =#date.timezone = Asia/shanghai#g' /etc/php.ini


DBName=zabbix  默认为zabbix
DBName=zabbix  默认为zabbix

sed -i 's@# DBHost=localhost@DBHost=localhost@g' /etc/zabbix/zabbix_server.conf
sed -i 's@# DBPassword=@DBPassword=111111@g' /etc/zabbix/zabbix_server.conf
sed -i '122 a DBSocket=/var/lib/mysql/mysql.sock' /etc/zabbix/zabbix_server.conf



-----------------------------

##bin-log
mysql -uroot -poldboy123 -e 'show master status\G'|awk -F "[: ]+" 'NR==2{print $3}'

## Position
mysql -uroot -poldboy123 -e 'show master status\G'|awk -F "[: ]+" 'NR==3{print $3}'

## 备份主库
mysqldump -uroot -poldboy123 --events -S /tmp/mysql.sock -A -B|gzip >bak_$(date +%F).sql.gz

## 备份文件发送到从库
scp -P52113 bak_$(date +%F).sql.gz 172.16.1.52:~
scp -P52113 bak_$(date +%F).sql.gz 172.16.1.53:~

------从库操作

##
cd /root
gzip -d bak_$(date +%F).sql.gz
mysql -uroot -poldboy123 -S /tmp/mysql.sock <bak_$(date +%F).sql


MasterIp=ifconfig eth1|awk -F"[a-z :]+" 'NR==2{print $2}'
##bin-log
BinLog=mysql -uroot -poldboy123 -e 'show master status\G'|awk -F "[: ]+" 'NR==2{print $3}'

## Position
Position=mysql -uroot -poldboy123 -e 'show master status\G'|awk -F "[: ]+" 'NR==3{print $3}'

mysql -uroot -poldboy123 -S /tmp/mysql.sock<<-EOF
CHANGE MASTER TO
MASTER_HOST='172.16.1.51',
MASTER_PORT=3306,
MASTER_USER='mysqlrep',
MASTER_PASSWORD='111111',
MASTER_LOG_FILE="$BinLog",
MASTER_LOG_POS=$Position;
EOF

---------------------------------主从复制  [root@db01 ~]# cat 1.sh
#!/bin/bash

## backup
mysqldump -uroot -poldboy123 --events -S /tmp/mysql.sock -A -B|gzip >bak_$(date +%F).sql.gz

## sent
scp -P52113 bak_$(date +%F).sql.gz 172.16.1.52:~
scp -P52113 bak_$(date +%F).sql.gz 172.16.1.53:~

MasterIp=`ifconfig eth1|awk -F"[a-z :]+" 'NR==2{print $2}'`
##bin-log
BinLog=`mysql -uroot -poldboy123 -e 'show master status\G'|awk -F "[: ]+" 'NR==2{print $3}'`

## Position
Position=`mysql -uroot -poldboy123 -e 'show master status\G'|awk -F "[: ]+" 'NR==3{print $3}'`

for n in 53 52
do

ssh -p52113 172.16.1.$n "gzip -d bak_$(date +%F).sql.gz && mysql -uroot -poldboy123 -S /tmp/mysql.sock <bak_$(date +%F).sql"

ssh -p52113 172.16.1.$n "mysql -uroot -poldboy123 -S /tmp/mysql.sock<<-EOF
CHANGE MASTER TO
MASTER_HOST='172.16.1.51',
MASTER_PORT=3306,
MASTER_USER='mysqlrep',
MASTER_PASSWORD='111111',
MASTER_LOG_FILE='$BinLog',
MASTER_LOG_POS=$Position;
EOF
"
ssh -p52113 172.16.1.$n 'mysql -uroot -poldboy123 -e "start slave;"'
done
----------------------------------------------------------------------
