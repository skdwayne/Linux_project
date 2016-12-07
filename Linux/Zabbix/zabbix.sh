


远程管理服务器就有远程管理卡，比如Dell idRAC，HP ILO，IBM IMM

查看硬件的温度/风扇，服务器就有ipmitool。使用ipmitool实现对服务器的命令行远程管理

yum -y install OpenIPMI ipmitool  # 物理机可以成功，虚拟机不行
ipmitool sdr type Temperature

服务器内置的远程控制卡，功能不全

远程控制卡，最好跟平时使用的网络分开，另接一台交换机，IP是独立的

lscpu

top
  zx
  x,y     . Toggle highlights: 'x' sort field; 'y' running tasks
  z,b     . Toggle: 'z' color/mono; 'b' bold/reverse (only if 'x' or 'y')
 <,>     . Move sort field:

 [root@zabbix ~]# hdparm -t /dev/sda
 /dev/sda:
  Timing buffered disk reads: 934 MB in  3.00 seconds = 311.17 MB/sec
 测试磁盘io

MRTG   监控网络链路流量负载的工具软件

cacti 网络流量监测图形分析工具

smokeping 专门的网络监测工具



网络
iftop ##直接输入监听 eth0
iftop -i eth1

** WAF




----------------
tar xfP zabbix3.0.5_yum.tar.gz
yum -y --nogpgcheck -C install httpd zabbix-web zabbix-server-mysql zabbix-web-mysql zabbix-get mysql-server php55w php55w-mysql php55w-common php55w-gd php55w-mbstring php55w-mcrypt php55w-devel php55w-xml php55w-bcmath zabbix-agent zabbix-get zabbix-java-gateway wqy-microhei-fonts


\cp /usr/share/mysql/my-medium.cnf /etc/my.cnf

/etc/init.d/mysqld start

mysql -uroot -e"create database zabbix character set utf8 collate utf8_bin;"
mysql -uroot -e"grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';"
mysql -uroot -e"flush privileges;"

zcat /tmp/zabbix.sql.gz|mysql -uzabbix -pzabbix zabbix


sed -i 's#max_execution_time = 30#max_execution_time = 300#;s#max_input_time = 60#max_input_time = 300#;s#post_max_size = 8M#post_max_size = 16M#;910a date.timezone = Asia/Shanghai' /etc/php.ini


sed -i '115a DBPassword=zabbix' /etc/zabbix/zabbix_server.conf

cp -R /usr/share/zabbix/ /var/www/html/

chmod -R 755 /etc/zabbix/web
chown -R apache.apache /etc/zabbix/web


echo "ServerName 127.0.0.1:80">>/etc/httpd/conf/httpd.conf
/etc/init.d/httpd start
/etc/init.d/zabbix-server start



zabbix-server 接收数据、比较数据、存储数据（MySQL）、报警
zabbix agent 收集服务器相关数据，然后发送给zabbix server进程

服务端要监控自己，本身也要安装
yum install zabbix-agent -y

web01安装、如果安装了老版本，卸载之后，重新安装新版本
yum -C localinstall http://mirrors.aliyun.com/zabbix/zabbix/3.0/rhel/6/x86_64/zabbix-agent-3.0.5-1.el6.x86_64.rpm
rpm -qa zabbix-agent

所有需要监控的服务器都需要执行：
sed -i 's#Server=127.0.0.1#Server= 172.16.1.61#' /etc/zabbix/zabbix_agentd.conf
/etc/init.d/zabbix-agent start

server 端  修改默认字符
\cp /usr/share/fonts/wqy-microhei/wqy-microhei.ttc /usr/share/fonts/dejavu/DejaVuSans.ttf

自定义监控项
web01

UserParameter=login-user,who|wc -l
[root@web01 ~]# vim /etc/zabbix/zabbix_agentd.conf
[root@web01 ~]# /etc/init.d/zabbix-agent restart

m01
示例
zabbix_get -s 127.0.0.1 -p 10050 -k "system.cpu.load[all,avg1]"

-k指定key，在agent端设置的key
[root@m01 ~]# zabbix_get -s 172.16.1.8 -p 10050 -k login-user
2





zabbix 声音报警
状态改变 才会输出声音
好到坏   或者   坏到好



OneAlert
initctl stop onealert
