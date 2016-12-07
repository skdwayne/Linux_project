
### CentOS7修改网卡为eth0

1.编辑网卡信息

    [root@centos7 ~]# cd /etc/sysconfig/network-scripts/  #进入网卡目录

    [root@centos7 network-scripts]# mv ifcfg-eno16777728 ifcfg-eth0  #重命名网卡名称

    [root@centos7 network-scripts]# cat ifcfg-eth0  #编辑网卡信息
    TYPE=Ethernet
    BOOTPROTO=static
    DEFROUTE=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV4_FAILURE_FATAL=no
    NAME=eth0  #name修改为eth0
    ONBOOT=yes
    IPADDR=192.168.56.12
    NETMASK=255.255.255.0
    GATEWAY=192.168.56.2
    DNS1=192.168.56.2

2.修改grub

    [root@centos7 ~]# cat /etc/sysconfig/grub  #编辑内核信息,添加红色字段的
    GRUB_TIMEOUT=5
    GRUB_DEFAULT=saved
    GRUB_DISABLE_SUBMENU=true
    GRUB_TERMINAL_OUTPUT="console"
    GRUB_CMDLINE_LINUX="crashkernel=auto rhgb net.ifnames=0 biosdevname=0 quiet"
    GRUB_DISABLE_RECOVERY="true"

    [root@centos7 ~]# grub2-mkconfig -o /boot/grub2/grub.cfg  #生成启动菜单
      Generating
    grub configuration file ...
      Found
    linux image: /boot/vmlinuz-3.10.0-229.el7.x86_64
      Found
    initrd image: /boot/initramfs-3.10.0-229.el7.x86_64.img
      Found
    linux image: /boot/vmlinuz-0-rescue-1100f7e6c97d4afaad2e396403ba7f61
      Found
    initrd image: /boot/initramfs-0-rescue-1100f7e6c97d4afaad2e396403ba7f61.img
      Done

3.验证是否修改成功

    [root@centos7 ~]# reboot  #必须重启系统生效
    [root@centos7 ~]# yum install net-tools  #默认centos7不支持ifconfig 需要安装net-tools包
    [root@centos7 ~]# ifconfig eth0  #再次查看网卡信息
    eth0:
    flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
    inet 192.168.56.12  netmask 255.255.255.0  broadcast 192.168.56.255
    inet6 fe80::20c:29ff:fe5c:7bb1  prefixlen 64
    scopeid 0x20<link>
    ether 00:0c:29:5c:7b:b1  txqueuelen 1000  (Ethernet)
    RX packets 152  bytes 14503 (14.1 KiB)
    RX errors 0  dropped 0
    overruns 0  frame 0
    TX packets 98  bytes 14402 (14.0 KiB)
    TX errors 0  dropped 0 overruns 0  carrier 0
    collisions 0
