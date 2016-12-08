#CentOS 7 1511


##网卡设置

    [root@localhost ~]# cat /etc/sysconfig/network-scripts/ifcfg-eno16777736 
    TYPE=Ethernet
    BOOTPROTO=none
    DEFROUTE=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_PEERDNS=yes
    IPV6_PEERROUTES=yes
    IPV6_FAILURE_FATAL=no
    NAME=eno16777736
    UUID=cea75fb8-ffa7-4641-898f-b942f99b1736
    DEVICE=eno16777736
    ONBOOT=yes
    IPADDR0=10.0.0.158
    GATEWAY0=10.0.0.2
    DNS1=223.5.5.5

> 重启网卡，添加epel源

    systemctl restart network
    yum install wget -y
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo