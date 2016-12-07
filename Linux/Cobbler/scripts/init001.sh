#!/bin/bash
#for CentOS 6
# 2364640877@QQ.COM
# dir_make
# deploy_hosts
# eth1_config
# eth1_gateway
# chk_config
# sysctl_config
# selinux_config
# ssh_config
# time_sync
# localyum
# package_install
# client_salt_zabbix
# zabbix_agent_config
# salt_minion_config
# jump_server
# drbd_nfs_config
# user_add
# mem_cached
# manager_init
#
[ $UID -ne "0" ]&&{
       echo "Please sudo su - root"
                exit 1
 		}

[ -f /etc/init.d/functions ] && source /etc/init.d/functions
[ -f /etc/profile ] && source /etc/profile

## yum repo
baseurl=http://172.16.1.61/

## configuration files from RemoteUrl
RemoteUrl=http://172.16.1.61/

## ntpd server IP
NtpServser=172.16.1.62

## for internal server
GateWay=172.16.1.6

## log
log_init(){
      if [ $? -eq 0 ];then
        action "$1" /bin/true >>/root/init.log
      else
        action "$1" /bin/false >>/root/init_error.log
      fi
}

dir_make(){
	mkdir -p /app/logs
	mkdir -p /application/
  mkdir -p /server/scripts

  log_init "dir_make"
}

## deploy hosts
deploy_hosts(){
	cat >/etc/hosts<<-IEOF
	127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
	::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
	172.16.1.5      lb01
	172.16.1.6      lb02
	172.16.1.7      web02
	172.16.1.8      web01
	172.16.1.51     db01 db01.etiantian.org
	172.16.1.52     db02 db02.etiantian.org
	172.16.1.31     nfs01
	172.16.1.41     backup
	172.16.1.61     m01
	172.16.1.62     jumpserver
	IEOF
  log_init "deploy_hosts"
}

## selinux && iptables optimization
selinux_config(){
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
	setenforce 0
	/etc/init.d/iptables stop >/dev/null 2>&1
	/etc/init.d/iptables stop >/dev/null 2>&1
	#echo -e "\033[31m SELinux & iptables ok! \033[0m"
	grep -qc "*                -       nofile          65535" /etc/security/limits.conf||  echo '*                -       nofile          65535' >>/etc/security/limits.conf
	#sleep 1
  log_init "selinux_config"
}

## time sync
time_sync(){
	if [ "$(ifconfig eth1|awk -F"[ :]+" 'NR==2{print $4}')" != "$NtpServser" ];then
	grep -qc "/usr/sbin/ntpdate $NtpServser" /var/spool/cron/root ||echo -e "##time sync at $(date +%F) \n*/5 * * * * /usr/sbin/ntpdate $NtpServser >/dev/null 2>&1" >>/var/spool/cron/root
	fi
  log_init "time_sync"
}

## ssh optimization
ssh_config(){
	# sed -i 's@#PermitRootLogin yes@#PermitRootLogin no@' /etc/ssh/sshd_config

	sed -i 's@^GSSAPIAuthentication yes$@GSSAPIAuthentication no@' /etc/ssh/sshd_config
	sed -i '/^#UseDNS/s@#UseDNS yes@UseDNS no@g' /etc/ssh/sshd_config
	sed -i 's@#PermitEmptyPasswords no@PermitEmptyPasswords no@g' /etc/ssh/sshd_config
	sed -i 's@#Port 22@Port 52113@g' /etc/ssh/sshd_config
	/etc/init.d/sshd restart
	#echo -e "\033[31m SSH OK! \033[0m"
  log_init "ssh_config"
}

##
hostname_config(){
	IP=`ifconfig eth0|awk -F"[ :]+" 'NR==2{print $4}'`
	case $IP in
	10.0.0.41) sed -i.bak 's#HOSTNAME=.*#HOSTNAME=backup#g' /etc/sysconfig/network && hostname backup
	;;
	10.0.0.31) sed -i.bak 's#HOSTNAME=.*#HOSTNAME=nfs01#g' /etc/sysconfig/network && hostname nfs01
	;;
	*) sed -i.bak 's#HOSTNAME=.*#HOSTNAME=lcm#g' /etc/sysconfig/network && hostname lcm
	;;
	esac
	echo -e "\033[31m hostname ok \033[0m"
	#sleep 1
  log_init "hostname_config"
}

## eth1
eth1_config() {
	ip=`ifconfig eth0|awk -F"[ :.]+" 'NR==2{print $7}'`
	cat >/etc/sysconfig/network-scripts/ifcfg-eth1 <<-EOF
	DEVICE=eth1
	TYPE=Ethernet
	ONBOOT=yes
	NM_CONTROLLED=yes
	BOOTPROTO=none
	IPADDR=172.16.1.${ip}
	NETMASK=255.255.255.0
	IPV6INIT=no
	USERCTL=no
	EOF
	/etc/init.d/network restart
	grep -qc "nameservr 10.0.0.2" /etc/resolv.conf||echo "nameservr 10.0.0.2">>/etc/resolv.conf
  log_init "eth1_config"
}

eth1_gateway(){
  [ "$(hostname)" = "lb02" ] && return
  grep -qc "GATEWAY=$GateWay" /etc/sysconfig/network-scripts/ifcfg-eth1||echo "GATEWAY=$GateWay" >> /etc/sysconfig/network-scripts/ifcfg-eth1
  log_init "eth1_gateway"
}


## chkconfig
chk_config(){
	chkconfig |egrep -v "sshd|crond|sysstat|rsyslog|network"|awk '{print "chkconfig",$1,"--level 3 off"}'|bash
  log_init "chk_config"
}

## sysctl optimization
sysctl_config(){
	a=("net.ipv4.tcp_fin_timeout = 2" "net.ipv4.tcp_tw_reuse = 1" "net.ipv4.tcp_tw_recycle = 1" "net.ipv4.tcp_syncookies = 1" "net.ipv4.tcp_keepalive_time = 600" "net.ipv4.ip_local_port_range = 4000  65000" "net.ipv4.tcp_max_syn_backlog = 16384" "net.ipv4.tcp_max_tw_buckets = 36000" "net.ipv4.route.gc_timeout = 100" "net.ipv4.tcp_syn_retries = 1" "net.ipv4.tcp_synack_retries = 1" "net.core.somaxconn = 16384" "net.core.netdev_max_backlog =  16384" "net.ipv4.tcp_max_orphans = 16384" "net.nf_conntrack_max = 25000000" "net.netfilter.nf_conntrack_max = 25000000" "net.netfilter.nf_conntrack_tcp_timeout_established = 180" "net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120" "net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60" "net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120")
	i=0
	len=${#a[*]}
	dir=/etc/sysctl.conf
	while [ $i -lt $len ]
	do
		grep -qc "${a[$i]}" "$dir"||echo "${a[$i]}" >> "$dir"
		let i++
	done
	/sbin/sysctl -p >/dev/null 2>&1
  log_init "sysctl_config"
}

## local yum repo
localyum() {
	[ -f /etc/yum.repos.d/CentOS-Base.repo ] && mv /etc/yum.repos.d/CentOS-Base.repo{,.bak}

	cat > /etc/yum.repos.d/lcm.repo <<-YEOF
	[localyum]
	name=CentOS_6
	baseurl=$baseurl
	enabled=1
	gpgcheck=0
	YEOF

	yum clean all
	yum makecache
  log_init "localyum"
}


package_install(){
	if [ "$(hostname)" != "m01" ];then
		yum install -y zabbix-agent
	fi

	[ "$(hostname)" = "db01" -o "$(hostname)" = "db02" ] && yum install -y mysql-lcm

	if [ "$(hostname)" = "web01" ];then
    yum install -y nginx-php-lcm nfs-utils rpcbind && /etc/init.d/rpcbind start
	elif [ "$(hostname)" = "web02" ];then
    yum install -y apache-php-lcm nfs-utils rpcbind && /etc/init.d/rpcbind start
  fi

  if [ "$(hostname)" = "lb01" -o "$(hostname)" = "lb02" ];then
    yum install nginx-lb-lcm keepalived -y
  fi
  log_init "package_install"
}

## zabbix agent
zabbix_agent_config() {
	sed -i 's#^Server=.*#Server=172.16.1.61#g' /etc/zabbix/zabbix_agentd.conf
	sed -i 's#^ServerActive=.*#ServerActive=172.16.1.61#g' /etc/zabbix/zabbix_agentd.conf
	sed -ri 's@^Hostname=(.*)@#Hostname=\1@g' /etc/zabbix/zabbix_agentd.conf

	if [ `/etc/init.d/zabbix-agent status|grep stopped|wc -l` -eq 1 ];then
		/etc/init.d/zabbix-agent start
	else
		/etc/init.d/zabbix-agent restart
	fi
  log_init "zabbix_agent_config"
}

## client of m01
client_zabbix(){
	if [ "$(ifconfig eth1|awk -F"[ :]+" 'NR==2{print $4}')" != "172.16.1.61" ];then
		zabbix_agent_config
	fi
  log_init "client_salt_zabbix"
}

## jumpserver
jump_server(){
	[ "$(hostname)" != "jumpserver" ] && return
	## ntpd
	wget -O /etc/ntp.conf $RemoteUrl/files/ntp.conf
  /etc/init.d/ntpd start
	chkconfig ntpd on

	## vpn pptp
	yum install pptpd -y
	cat >>/etc/pptpd.conf<<-PPP
	localip $(ifconfig eth0|awk -F"[ :]+" 'NR==2{print $4}')
	remoteip 172.16.1.230-240
	PPP
	sed -i 's#net.ipv4.ip_forward = 0#net.ipv4.ip_forward = 1#g' /etc/sysctl.conf
	sysctl -p

	cat >>/etc/ppp/chap-secrets<<-PEOF
	lcm      *    123456         *
	PEOF
	/etc/init.d/pptpd start
	chkconfig pptpd on
  log_init "jump_server"
}

## user add
user_add(){
	useradd oldboy
	echo 123456|passwd --stdin oldboy
	useradd lcm
	echo 123456|passwd --stdin lcm
	echo -e "oldboy ALL=(ALL) NOPASSWD: ALL\nlcm ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
  log_init "user_add"
}

## zabbix server config
zabbix_server(){
	### install
	yum install httpd zabbix zabbix-server zabbix-web zabbix-server-mysql zabbix-web-mysql mysql-server -y

  ### PHP
	yum install php55w php55w-mysql php55w-common php55w-gd php55w-mbstring php55w-mcrypt php55w-devel php55w-xml php55w-bcmath -y
	cp -R /usr/share/zabbix/ /var/www/html/

	### mysql
	/etc/init.d/mysqld start
	mysql -e 'create database zabbix character set utf8 collate utf8_bin;'
	mysql -e 'grant all on zabbix.* to zabbix@'localhost' identified by "111111";'
	mysql -e 'flush privileges;'
	wget $RemoteUrl/files/zabbix_bak.sql
	#zcat /usr/share/doc/zabbix-server-mysql-3.0.5/create.sql.gz |mysql -uzabbix -p111111 zabbix
	mysql -uroot  <zabbix_bak.sql

	sed -i 's#post_max_size = 8M#post_max_size = 16M#g' /etc/php.ini
	sed -i 's#max_execution_time = 30#max_execution_time = 300#g' /etc/php.ini
	sed -i 's#max_input_time = 60#max_input_time = 300#g' /etc/php.ini
	sed -i 's#;date.timezone =#date.timezone = Asia/shanghai#g' /etc/php.ini

	sed -i 's@# DBHost=localhost@DBHost=localhost@g' /etc/zabbix/zabbix_server.conf
	sed -i 's@# DBPassword=@DBPassword=111111@g' /etc/zabbix/zabbix_server.conf
	sed -i '122 a DBSocket=/var/lib/mysql/mysql.sock' /etc/zabbix/zabbix_server.conf

	chmod -R 755 /etc/zabbix/web
	chown -R apache.apache /etc/zabbix/web
	/etc/init.d/httpd start
	/etc/init.d/zabbix-server start

  log_init "zabbix_server"
}

## m01
manager_init(){
	#[ "$(hostname)" = "m01" ] && return
	if [ "$(ifconfig eth1|awk -F"[ :]+" 'NR==2{print $4}')" = "172.16.1.61" ];then
	zabbix_server
	fi
  log_init "manager_init"
}

backup_script(){
  if [ "$(hostname)" = "nfs01" -o "$(hostname)" = "web01" -o "$(hostname)" = "web02" ];then
    wget -O /server/scripts/backup.sh $RemoteUrl/files/backup.sh
    grep -qc "/server/scripts/backup.sh" /var/spool/cron/root || echo -e "#### backup at $(date +%F) by init scripts \n00 00 * * * /bin/sh /server/scripts/backup.sh >/dev/null 2>&1" >> /var/spool/cron/root

    ## rsync
    wget -O /etc/rsync.password $RemoteUrl/files/client_rsync.password
    chmod 600 /etc/rsync.password

  elif [ "$(hostname)" = "backup" ];then
    wget -O /server/scripts/backup_check.sh $RemoteUrl/files/backup_check.sh
    grep -qc "/server/scripts/backup_check.sh" /var/spool/cron/root || echo -e "#### backup at $(date +%F) by init scripts \n20 00 * * * /bin/sh /server/scripts/backup_check.sh >/dev/null 2>&1" >> /var/spool/cron/root

    ## rsync daemon
    wget -O /etc/rsyncd.conf $RemoteUrl/files/rsyncd.conf
    wget -O /etc/rsync.password $RemoteUrl/files/rsync.password
    chmod 600 /etc/rsync.password
    useradd -u 893 -s /sbin/nologin -M www
    chown -R www.www /backup /oldboy /nfsbackup
    grep -qc "rsync --daemon" /etc/rc.local ||echo "/usr/bin/rsync --daemon" >>/etc/rc.local
    /usr/bin/rsync --daemon
  fi
}

nfs_config(){
  [ "$(hostname)" != "nfs01" -o "$(hostname)" != "backup" ] && return
  yum install -y nfs-utils rpcbind
  useradd -u 893 -s /sbin/nologin -M www
  mkdir /data/www/{www,blog,bbs}/upload -p
  cat >/etc/exports<<-EEE
	/data/www/www/upload 172.16.1.0/24(rw,sync,all_squash,anonuid=893,anongid=893)
	/data/www/blog/upload 172.16.1.0/24(rw,sync,all_squash,anonuid=893,anongid=893)
	/data/www/bbs/upload 172.16.1.0/24(rw,sync,all_squash,anonuid=893,anongid=893)
	EEE
  chown -R www.www /data/www/
  /etc/init.d/rpcbind start
  /etc/init.d/nfs start
  yum install keepalived
  #wget
}

mysql_init(){
  [ `hostname|cut -c1-2` != "db" ] && return
  yum install mysql-lcm
  Id=`hostname|cut -c4`
  sed -i.bak "s@server-id       = 1@#server-id      = $Id@g" /etc/my.cnf
  sed -i.bak 's@#log-bin=mysql-bin@log-bin=mysql-bin@g' /etc/my.cnf
  /etc/init.d/mysqld restart
}

lb_keepalived_config(){
  if [ "$(hostname)" = "lb01" ];then
    wget -O /etc/keepalived/keepalived.conf $RemoteUrl/files/lb01_keepalived.conf
    /etc/init.d/keepalived start
  elif [ "$(hostname)" = "lb02" ];then
    wget -O /etc/keepalived/keepalived.conf $RemoteUrl/files/lb02_keepalived.conf
    /etc/init.d/keepalived start
  fi
}

contact(){
	echo -e "\033[31m +-------------------------------------------------+ \033[0m"
	echo -e "\033[31m |                   Done!!!                       | \033[0m"
	echo -e "\033[31m |            E-mail:2364640877@QQ.COM             | \033[0m"
	echo -e "\033[31m |            ^_^ ^_^ ^_^ ^_^ ^_^ ^_^              | \033[0m"
	echo -e "\033[31m +-------------------------------------------------+ \033[0m"
}

main(){
    #hostname_config
    dir_make
    deploy_hosts
    eth1_config
    eth1_gateway
    chk_config
    sysctl_config
    selinux_config
    ssh_config
    time_sync
    localyum
    package_install
    client_zabbix
    zabbix_agent_config
    jump_server
    user_add
    manager_init
    backup_script
    nfs_config
    mysql_init
    lb_keepalived_config
    contact


    #echo -e "\033[45;37;5mComplete\033[0m"
    /bin/rm $0
    exit 0
}
main
