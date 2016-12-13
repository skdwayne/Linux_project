#!/bin/bash

#selinux and iptables
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
service iptables stop
chkconfig iptables off

#hostname
hostname oracle
flag=`grep "oracle" /etc/hosts`
if [[ -z $flag ]]
then
	echo "`ifconfig eth0 | awk -F ':|B' '/Bcast/{print $2}'`   oracle" >> /etc/hosts
fi
flag=`grep "oracle" /etc/sysconfig/network`
if [[ -z $flag ]]
then
	sed -i -r 's/HOSTNAME=(.*)/HOSTNAME=oracle/g' /etc/sysconfig/network
fi

#user
id oracle &> /dev/null
if [[ $? != 0 ]]
then
	groupadd dba
	useradd oracle -g dba
fi

#limit
limit="/etc/security/limits.conf"
flag=`grep oracle $limit`
if [[ -z $flag ]]
then
	echo "oracle soft nproc 2047" >> $limit
	echo "oracle hard nproc 16384" >> $limit
	echo "oracle soft nofile 1024" >> $limit
	echo "oracle hard nofile 65536" >> $limit
	echo "oracle hard memlock unlimited" >> $limit
	echo "oracle soft memlock unlimited" >> $limit
	echo "oracle soft nstack 10240" >> $limit
	echo "oracle hard nstack 32768" >> $limit
fi

#kernel
kernel="/etc/sysctl.conf"
flag=`grep oracle $kernel`
if [[ -z $flag ]]
then
	echo "#oracle" >> $kernel
	echo "kernel.msgmax = 65536" >> $kernel
	echo "kernel.shmall = 4294967296" >> $kernel
	echo "fs.file-max = 6815744" >> $kernel
	echo "kernel.sem = 250 32000 100 128" >> $kernel
	echo "kernel.shmmni = 4096" >> $kernel
	echo "kernel.shmmax = 4398046511104" >> $kernel
	echo "net.core.rmem_default = 262144" >> $kernel
	echo "net.core.rmem_max = 4194304" >> $kernel
	echo "net.core.wmem_default = 262144" >> $kernel
	echo "net.core.wmem_max = 1048576" >> $kernel
	echo "fs.aio-max-nr = 1048576" >> $kernel
	echo "net.ipv4.ip_local_port_range = 9000 65500" >> $kernel
	sysctl -p /etc/sysctl.conf
fi

#yum
yum -y install  binutils compat-libstdc++-33  elfutils-libelf elfutils-libelf-devel expat  gcc  gcc-c++ glibc  glibc-common glibc-devel glibc-headers libaio libaio-devel  libgcc  libstdc++  libstdc++-devel make  pdksh sysstat  unixODBC unixODBC-devel compat-libcap1 ksh

rm -rf /u01/app/oracle
mkdir -p /u01/app/oracle
chown -R oracle.dba /u01

echo "the system will be reboot [YES/NO]"
read key
if [[ $key == "YES" ]] || [[ $key == "yes" ]] || [[ $key == "Y" ]] || [[ $key == "y" ]]
then
	shutdown -r now
else
	exit
fi
