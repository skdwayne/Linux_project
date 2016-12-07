#!/bin/bash
##############################################################
# File Name: /var/www/html/ks_config/optimization.sh
# Version: V1.0
# Author: yao zhang
# Organization: www.zyops.com
# Created Time : 2015-12-03 15:23:08
# Description: Linux system initialization
##############################################################
. /etc/init.d/functions
Ip=172.16.1.61
Port=80
ConfigDir=ks_config
# Judge Http server is ok?
PortNum=`nmap $Ip  -p $Port 2>/dev/null|grep open|wc -l`
[ $PortNum -lt 1 ] && {
        echo "Http server is bad!"
        exit 1
}
# Defined result function
function Msg(){
        if [ $? -eq 0 ];then
          action "$1" /bin/true
        else
          action "$1" /bin/false
        fi
}
# Defined IP function
function ConfigIP(){
        Suffix=`ifconfig eth0|awk -F "[ .]+" 'NR==2 {print $6}'`
        cat >/etc/sysconfig/network-scripts/ifcfg-eth0 <<-END
        DEVICE=eth0
        TYPE=Ethernet
        ONBOOT=yes
        NM_CONTROLLED=yes
        BOOTPROTO=none
        IPADDR=10.0.0.$Suffix
        PREFIX=24
        GATEWAY=10.0.0.2
        DNS1=10.0.0.2
        DEFROUTE=yes
        IPV4_FAILURE_FATAL=yes
        IPV6INIT=no
        NAME="System eth0"
        END
        Msg "config eth0"
}
# Defined Yum source Functions
function yum(){
        YumDir=/etc/yum.repos.d
        [ -f "$YumDir/CentOS-Base.repo" ] && cp $YumDir/CentOS-Base.repo{,.ori} 
        wget -O $YumDir/CentOS-Base.repo http://$Ip:$Port/$ConfigDir/CentOS-Base.repo &>/dev/null &&\
        wget -O $YumDir/epel.repo http://$Ip:$Port/$ConfigDir/epel.repo &>/dev/null &&\
        Msg "YUM source"
}
# Defined Hide the system version number Functions
function HideVersion(){
        [ -f "/etc/issue" ] && >/etc/issue
        Msg "Hide issue" 
        [ -f "/etc/issue.net" ] && > /etc/issue.net
        Msg "Hide issue.net"
}
# Defined OPEN FILES Functions
function openfiles(){
        [ -f "/etc/security/limits.conf" ] && {
        echo '*  -  nofile  65535' >> /etc/security/limits.conf
        Msg "open files"
        }
}
# Defined Kernel parameters Functions
function kernel(){
        KernelDir=/etc
        [ -f "$KernelDir/sysctl.conf" ] && /bin/mv $KernelDir/sysctl.conf{,.ori}
        wget -O $KernelDir/sysctl.conf http://$Ip:$Port/$ConfigDir/sysctl.conf &>/dev/null
        Msg "Kernel config"
}
# Defined System Startup Services Functions
function boot(){
        for oldboy in `chkconfig --list|grep "3:on"|awk '{print $1}'|grep -vE "crond|network|rsyslog|sshd|sysstat"` 
          do 
           chkconfig $oldboy off
        done
        Msg "BOOT config"
}
# Defined Time Synchronization Functions
function Time(){
        echo "#time sync by zhangyao at $(date +%F)" >>/var/spool/cron/root
        echo '*/5 * * * * /usr/sbin/ntpdate time.nist.gov &>/dev/null' >>/var/spool/cron/root
        Msg "Time Synchronization"
}
# Defined main Functions
function main(){
        ConfigIP
        yum
        HideVersion
        openfiles
        kernel
        boot
        Time
}
main	
