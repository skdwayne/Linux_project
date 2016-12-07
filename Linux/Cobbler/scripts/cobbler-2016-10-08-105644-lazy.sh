#!/bin/bash
#by yjj
#for CentOS 6

[ -f /etc/init.d/functions ] && source /etc/init.d/functions
[ $UID -ne "0" ]&&{
       echo "Please sudo su - root"
                exit 1
 		}
YumServer=172.16.1.132

selinux_config(){
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0
/etc/init.d/iptables stop
/etc/init.d/iptables stop
echo -e "\033[31m SELinux & iptables ok! \033[0m"
echo '*                -       nofile          65535' >>/etc/security/limits.conf
sleep 1
}

time_sync(){
echo '##time sync by yjj at 2016/09/06' >>/var/spool/cron/root
echo ' */5 * * * * /usr/sbin/ntpdate ntp1.aliyun.com >/dev/null 2>&1' >>/var/spool/cron/root
}

ssh_config(){
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
sleep 1
}
eth1_config() {
ip=`ifconfig eth0|awk -F"[ :.]+" 'NR==2{print $7}'`
cat >/etc/sysconfig/network-scripts/ifcfg-eth1 <<EOF
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
}


##开机自启
chk_config(){
chkconfig |egrep -v "sshd|crond|sysstat|rsyslog|network"|awk '{print "chkconfig",$1,"--level 3 off"}'|bash
}

##内核优化
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
echo -e "\033[31m |               optimizer is done                 | \033[0m"
echo -e "\033[31m |            E-mail:493535459@QQ.COM              | \033[0m"
echo -e "\033[31m |            ^_^ ^_^ ^_^ ^_^ ^_^ ^_^              | \033[0m"
echo -e "\033[31m +-------------------------------------------------+ \033[0m"

}
package_install() {
mv /etc/yum.repos.d/CentOS-Base.repo{,.bak} &&\
cat > /etc/yum.repos.d/yjj.repo <<YEOF
[yjj]
name=CentOS_6
baseurl=http://${YumServer}/cobbler/repo_mirror/my-repo/
enabled=1
gpgcheck=0
YEOF
yum clean all
yum makecache 
yum install -y salt-minion zabbix-agent
}
main(){
#    hostname_config
    chk_config	
    sysctl_config
    selinux_config
    ssh_config
    time_sync
    eth1_config
    package_install

    contact

echo -e "\033[45;37;5mComplete\033[0m"
}
main
