#!/bin/bash
#for CentOS 6

[ -f /etc/init.d/functions ] && source /etc/init.d/functions
[ $UID -ne "0" ]&&{
       echo "Please sudo su - root"
                exit 1
 		}
#
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
# backup_script
#
#


## yum url
baseurl2=http://172.16.1.155/yum_data/
baseurl3=http://172.16.1.132/cobbler/repo_mirror/my-repo/
CobblerConfigUrl=http://172.16.1.132/cobbler/ks_mirror/config

## salt-master IP
SaltMasterIp=172.16.1.61

## ntpd server IP
NtpServser=172.16.1.62

## for internal server
GateWay=172.16.1.6

## function log
log_init(){
      if [ $? -eq 0 ];then
        action "$1" /bin/true >>cobbler_install.log
      else
        action "$1" /bin/false >>cobbler_install_error.log
      fi
}

dir_make(){
	mkdir -p /app/logs
	mkdir -p /application/
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
	172.16.1.53     db03 db03.etiantian.org
	172.16.1.31     nfs01
	172.16.1.41     backup
	172.16.1.61     m01
	172.16.1.62     jumpserver
	IEOF
}

selinux_config(){
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
	setenforce 0
	/etc/init.d/iptables stop
	/etc/init.d/iptables stop
	echo -e "\033[31m SELinux & iptables ok! \033[0m"
	grep -qc "*                -       nofile          65535" /etc/security/limits.conf||  echo '*                -       nofile          65535' >>/etc/security/limits.conf
	#sleep 1
}

time_sync(){
	if [ "$(ifconfig eth1|awk -F"[ :]+" 'NR==2{print $4}')" != "$NtpServser" ];then
	echo '##time sync by yjj at 2016/09/06' >>/var/spool/cron/root
	echo "*/5 * * * * /usr/sbin/ntpdate $NtpServser >/dev/null 2>&1" >>/var/spool/cron/root
	fi
}

ssh_config(){
	# sed -i 's@#PermitRootLogin yes@#PermitRootLogin no@' /etc/ssh/sshd_config

	sed -i 's@^GSSAPIAuthentication yes$@GSSAPIAuthentication no@' /etc/ssh/sshd_config
	sed -i '/^#UseDNS/s@#UseDNS yes@UseDNS no@g' /etc/ssh/sshd_config
	sed -i 's@#PermitEmptyPasswords no@PermitEmptyPasswords no@g' /etc/ssh/sshd_config
	sed -i 's@#Port 22@Port 52113@g' /etc/ssh/sshd_config
	/etc/init.d/sshd restart
	echo -e "\033[31m SSH OK! \033[0m"
}

hostname_config(){
	IP=`ifconfig eth0|awk -F"[ :]+" 'NR==2{print $4}'`
	case $IP in
	10.0.0.41) sed -i.bak 's#HOSTNAME=.*#HOSTNAME=backup#g' /etc/sysconfig/network && hostname backup
	;;
	10.0.0.31) sed -i.bak 's#HOSTNAME=.*#HOSTNAME=nfs01#g' /etc/sysconfig/network && hostname nfs01
	;;
	*) sed -i.bak 's#HOSTNAME=.*#HOSTNAME=ztt#g' /etc/sysconfig/network && hostname ztt
	;;
	esac
	echo -e "\033[31m hostname ok \033[0m"
	#sleep 1
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
	GATEWAY=$GateWay
	EOF
	/etc/init.d/network restart
	grep -qc "nameservr 10.0.0.2" /etc/resolv.conf||echo "nameservr 10.0.0.2">>/etc/resolv.conf
}


## chkconfig
chk_config(){
	chkconfig |egrep -v "sshd|crond|sysstat|rsyslog|network"|awk '{print "chkconfig",$1,"--level 3 off"}'|bash
}

## sysctl
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
}

contact(){
	echo -e "\033[31m +-------------------------------------------------+ \033[0m"
	echo -e "\033[31m |                   Done!!!                       | \033[0m"
	echo -e "\033[31m |            E-mail:493535459@QQ.COM              | \033[0m"
	echo -e "\033[31m |            ^_^ ^_^ ^_^ ^_^ ^_^ ^_^              | \033[0m"
	echo -e "\033[31m +-------------------------------------------------+ \033[0m"
}

##
localyum() {
	[ -f /etc/yum.repos.d/CentOS-Base.repo ] && mv /etc/yum.repos.d/CentOS-Base.repo{,.bak}
	[ -f /etc/yum.repos.d/cobbler-config.repo ] && mv /etc/yum.repos.d/cobbler-config.repo{,.bak}

	cat > /etc/yum.repos.d/yjj.repo <<-YEOF
	[yjj]
	name=CentOS_6
	baseurl=$baseurl2
	enabled=1
	gpgcheck=0
	[localyum]
	name=CentOS6
	baseurl=$baseurl3
	enabled=1
	gpgcheck=0
	YEOF

	yum clean all
	yum makecache
}


package_install(){
	if [ -f /etc/yum.repos.d/yjj.repo ];then
		yum install -y salt-minion
		yum install -y zabbix-agent
	fi

	[ "$(hostname)" = "nfs01" ] && yum install -y nfs-utils rpcbind
	[ "$(hostname)" = "backup" ] && yum install -y nfs-utils rpcbind

	[ "$(hostname)" = "db01" ] && yum install -y mysql-yjj
	[ "$(hostname)" = "web01" ] && yum install -y nginx-php-yjj nfs-utils rpcbind
	[ "$(hostname)" = "web02" ] && yum install -y apache-php-yjj nfs-utils rpcbind

	[ "$(hostname)" = "lb01" ] && yum install nginx-yjj keepalived -y
	[ "$(hostname)" = "lb02" ] && yum install nginx-yjj keepalived -y
}


zabbix_agent_config() {
	sed -i 's#^Server=.*#Server=172.16.1.61#g' /etc/zabbix/zabbix_agentd.conf
	sed -i 's#^ServerActive=.*#ServerActive=172.16.1.61#g' /etc/zabbix/zabbix_agentd.conf
	sed -ri 's@^Hostname=(.*)@#Hostname=\1@g' /etc/zabbix/zabbix_agentd.conf

	if [ `/etc/init.d/zabbix-agent status|grep stopped|wc -l` -eq 1 ];then
		/etc/init.d/zabbix-agent start
	else
		/etc/init.d/zabbix-agent restart
	fi
}

salt_minion_config(){
	sed -i "16 a master: ${SaltMasterIp}" /etc/salt/minion
	sed -i "79 a id: $(hostname)" /etc/salt/minion
	/etc/init.d/salt-minion start
	RETVAL=$?
	if [ $RETVAL -ne 0 ];then
		 /etc/init.d/salt-minion restart
	fi
}

## client of m01
client_salt_zabbix(){
	if [ "$(ifconfig eth1|awk -F"[ :]+" 'NR==2{print $4}')" != "172.16.1.61" ];then
		#salt_minion_config
		zabbix_agent_config
	fi
}

drbd_nfs_config(){
	[ "$(hostname)" != "nfs01" -o "$(hostname)" != "backup" ] && return
	#echo -e "n\np\n1\n\n\n\nw "|fdisk /dev/sdb
	#partprobe

	cat >/etc/exports<<-EEE
	/data/www/www/upload 172.16.1.0/24(rw,sync,all_squash,anonuid=1000,anongid=1000)
	/data/www/blog/upload 172.16.1.0/24(rw,sync,all_squash,anonuid=1000,anongid=1000)
	/data/www/bbs/upload 172.16.1.0/24(rw,sync,all_squash,anonuid=1000,anongid=1000)
	/data/www/edu/upload 172.16.1.0/24(rw,sync,all_squash,anonuid=1000,anongid=1000)
	EEE

	yum install kmod-drbd84 drbd84 -y
	yum install heartbeat -y
	modprobe drbd
	wget $CobblerConfigUrl/files/ha.d.tar.gz
	wget $CobblerConfigUrl/files/drbd.d.tar.gz
	tar xf ha.d.tar.gz -C /etc
	chmod 600 /etc/ha.d/authkeys
	tar xf drbd.d.tar.gz -C /etc
	echo "drbd_config OK">>/root/cobbler_install.log
}

jump_server(){
	[ "$(hostname)" != "jumpserver" ] && return
	## ntpd
	wget $CobblerConfigUrl/files/ntp.conf
	/bin/mv ntp.conf /etc/ntp.conf && /etc/init.d/ntpd start
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
	yjj      *    111111         *
	PEOF
	/etc/init.d/pptpd start
	chkconfig pptpd on

}

## user add
user_add(){
	useradd oldboy
	echo 111111|passwd --stdin oldboy
	useradd aa
	echo 111111|passwd --stdin aa
	echo -e "oldboy ALL=(ALL) NOPASSWD: ALL\naa ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
}

## session
mem_cached(){
	[ "$(hostname)" != "lb02" ] && return
	#yum install -y libevent-devel nc
	yum install memcached-yjj -y
	#/application/memcached/bin/memcached -m 16m -p 11211 -d -u root -c 8192
	#echo -e "#start memcached\n/application/memcached/bin/memcached -m 16m -p 11211 -d -u root -c 8192" >>/etc/rc.local
}

## salt master config
salt_master(){
	yum install -y salt-master
	cat >>/etc/salt/master<<-SEOF
	auto_accept: True
	state_top: top.sls
	file_roots:
	  base:
	    - /srv/salt
	pillar_roots:
	  base:
	    - /srv/pillar
	SEOF
	service salt-master start
	service salt-master restart

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
	wget $CobblerConfigUrl/files/zabbix_bak.sql
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
}

## m01
manager_init(){
	#[ "$(hostname)" = "m01" ] && return
	if [ "$(ifconfig eth1|awk -F"[ :]+" 'NR==2{print $4}')" = "172.16.1.61" ];then
	#salt_master
	zabbix_server
	log_init "manager init"
	fi
}

backup_init(){
  wget
}
main(){
    #hostname_config
    dir_make
    deploy_hosts
    eth1_config
    chk_config
    sysctl_config
    selinux_config
    ssh_config
    time_sync
    localyum
    package_install
    client_salt_zabbix
    zabbix_agent_config
    salt_minion_config
    jump_server
    #drbd_nfs_config
    user_add
    mem_cached
    manager_init
    contact

    echo -e "\033[45;37;5mComplete\033[0m"
    /bin/rm $0
    exit 0
}
main
