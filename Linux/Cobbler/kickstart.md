[TOC]

# **导言**


> 作为中小公司的运维，经常会遇到一些机械式的重复工作，例如：有时公司同时上线几十甚至上百台服务器，而且需要我们在短时间内完成系统安装。

常规的办法有什么？

    光盘安装系统===>一个服务器DVD内置光驱百千块，百台服务器都配光驱就浪费了，因为一台服务器也就开始装系统能用的上，以后用的机会屈指可数。用USB外置光驱，插来插去也醉了。
    U盘安装系统===>还是同样的问题，要一台一台服务器插U盘。
    网络安装系统(ftp,http,nfs) ===>这个方法不错，只要服务器能联网就可以装系统了，但还是需要一台台服务器去敲键盘点鼠标。时刻想偷懒的我们，有没有更好的方法！

高逼格的方法：

    Kickstart
    Cobbler
    在进入主题前，首先会向大家介绍一下什么是pxe，pxe能干什么，Kickstart是什么，Cobbler又有什么特别。



# 简介
## 什么是PXE

    PXE，全名Pre-boot Execution Environment，预启动执行环境；
    通过网络接口启动计算机，不依赖本地存储设备（如硬盘）或本地已安装的操作系统；
    由Intel和Systemsoft公司于1999年9月20日公布的技术；
    Client/Server的工作模式；
    PXE客户端会调用网际协议(IP)、用户数据报协议(UDP)、动态主机设定协议(DHCP)、小型文件传输协议(TFTP)等网络协议；
    PXE客户端(client)这个术语是指机器在PXE启动过程中的角色。一个PXE客户端可以是一台服务器、笔记本电脑或者其他装有PXE启动代码的机器（我们电脑的网卡）。

## DHCP简介

DHCP（Dynamic Host Configuration Protocol，动态主机配置协议）通常被应用在大型的局域网络环境中，主要作用是集中的管理、分配IP地址，使网络环境中的主机动态的获得IP地址、网关地址、DNS服务器地址等信息，并能够提升地址的使用率。


## DNCP服务安装配置
    [root@55 ~]# yum -y install dhcp
    [root@55 ~]# rpm -ql dhcp |grep "dhcpd.conf" ##查看配置文件位置
    /etc/dhcp/dhcpd.conf
    /usr/share/doc/dhcp-4.1.1/dhcpd-conf-to-ldap
    /usr/share/doc/dhcp-4.1.1/dhcpd.conf.sample
    /usr/share/man/man5/dhcpd.conf.5.gz


    [root@55 ~]# cat /etc/dhcp/dhcpd.conf
    #
    # DHCP Server Configuration file.
    #   see /usr/share/doc/dhcp*/dhcpd.conf.sample
    #   see 'man 5 dhcpd.conf'
    #


    [root@55 ~]# vim /etc/dhcp/dhcpd.conf
    subnet 172.16.1.0 netmask 255.255.255.0 {
    range 172.16.1.100 172.16.1.200;
    option subnet-mask 255.255.255.0;
    default-lease-time 21600;
    max-lease-time 43200;
    next-server 172.16.1.55;
    filename "/pxelinux.0";
    }
    
    # 注释说明
    range 10.0.0.100 10.0.0.200; # 可分配的起始IP-结束IP
    option subnet-mask 255.255.255.0;# 设定netmask
    default-lease-time 21600;# 设置默认的IP租用期限
    max-lease-time 43200;# 设置最大的IP租用期限
    next-server 10.0.0.7;# 告知客户端TFTP服务器的ip
    filename "/pxelinux.0";  # 告知客户端从TFTP根目录下载pxelinux.0文件


    [root@55 ~]# /etc/init.d/dhcpd start
    Starting dhcpd:[  OK  ]
    [root@55 ~]# netstat -lntup |grep dhcp
    udp0  0 0.0.0.0:67  0.0.0.0:*   51068/dhcpd  

** 本来软件装完后都要加入开机自启动，但这个Kickstart系统就不能开机自启动，而且用完后服务都要关闭，防止未来重启服务器自动重装系统了。**

** 如果机器数量过多的话，注意dhcp服务器的地址池，不要因为耗尽IP而导致dhcpd服务器没有IP地址release的情况。**



## DHCP指定监听网卡

指定监听网卡（老版本需要指定），新版本默认会自动识别，此处设置会导致使用cobbler时无法启动dhcpd
** 多网卡默认监听eth0，指定DHCP监听eth1网卡**

    [root@55 ~]# cat /etc/sysconfig/dhcpd
    # Command line options here
    DHCPDARGS=eth1
    [root@55 ~]# tailf /var/log/messages


#安装TFTP服务
## TFTP简介

TFTP（Trivial File Transfer Protocol,简单文件传输协议）是TCP/IP协议族中的一个用来在客户机与服务器之间进行简单文件传输的协议，提供不复杂、开销不大的文件传输服务。端口号为69。

## TFTP安装配置

    [root@55 ~]# yum -y install tftp-server
    [root@55 ~]# cat /etc/xinetd.d/tftp
    # default: off
    # description: The tftp server serves files using the trivial file transfer \
    #	protocol.  The tftp protocol is often used to boot diskless \
    #	workstations, download configuration files to network-aware printers, \
    #	and to start the installation process for some operating systems.
    service tftp
    {
    	socket_type		= dgram
    	protocol		= udp
    	wait			= yes
    	user			= root
    	server			= /usr/sbin/in.tftpd
    	server_args		= -s /var/lib/tftpboot
    	disable			= no  ###改成no
    	per_source		= 11
    	cps			= 100 2
    	flags			= IPv4
    }
    
    [root@55 ~]# sed -i '/disable/s#yes#no#' /etc/xinetd.d/tftp
    
    [root@55 ~]# /etc/init.d/xinetd start
    Starting xinetd:   [  OK  ]
    [root@55 ~]# netstat -lntup |grep xinetd
    udp0  0 0.0.0.0:69  0.0.0.0:*   56083/xinetd

## 配置HTTP服务


> 可以用Apache或Nginx提供HTTP服务。Python的命令web服务不行，会有报错。

    [root@55 ~]# yum -y install httpd
    [root@55 ~]# sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
    [root@55 ~]# /etc/init.d/httpd start
    Starting httpd:[  OK  ]
    [root@55 ~]# mkdir /var/www/html/CentOS-6.7
    [root@55 ~]# mount /dev/cdrom /var/www/html/CentOS-6.7/
    mount: block device /dev/sr0 is write-protected, mounting read-only
    [root@55 ~]# df -h
    Filesystem  Size  Used Avail Use% Mounted on
    /dev/sda319G  2.8G   15G  16% /
    tmpfs   133M 0  133M   0% /dev/shm
    /dev/sda1   194M   40M  145M  22% /boot
    /dev/sr03.7G  3.7G 0 100% /var/www/html/CentOS-6.7

浏览器访问http://10.0.0.55/CentOS-6.7/，检验配置是否正确



## 配置支持PXE的启动程序

### PXE引导配置（bootstrap）



> syslinux是一个功能强大的引导加载程序，而且兼容各种介质。SYSLINUX是一个小型的Linux操作系统，它的目的是简化首次安装Linux的时间，并建立修护或其它特殊用途的启动盘。如果没有找到pxelinux.0这个文件,可以安装一下。

    [root@55 ~]# yum -y install syslinux
    [root@55 ~]# cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
    # 复制启动菜单程序文件
    [root@55 ~]# cp -a /var/www/html/CentOS-6.7/isolinux/* /var/lib/tftpboot/
    [root@55 ~]# ls /var/lib/tftpboot/
    boot.cat  grub.conf   isolinux.bin  memtest splash.jpg  vesamenu.c32
    boot.msg  initrd.img  isolinux.cfg  pxelinux.0  TRANS.TBL   vmlinuz
    # 新建一个pxelinux.cfg目录，存放客户端的配置文件。
    [root@55 ~]# mkdir -p /var/lib/tftpboot/pxelinux.cfg
    [root@55 ~]# cp /var/www/html/CentOS-6.7/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default



### PXE配置文件default解析

> 新建一个虚拟机，内存给1G

    [root@55 ~]# cat /var/lib/tftpboot/pxelinux.cfg/default
    default vesamenu.c32   ##默认会加载一个菜单
    #prompt 1         ###开启会显示命令行'boot: '提示符。prompt值为0时则不提示，将会直接启动'default'参数中指定的内容
    timeout 600  # timeout时间是引导时等待用户手动选择的时间，设为1可直接引导，单位为1/10秒。
    
    display boot.msg
    ## 菜单背景图片、标题、颜色
    menu background splash.jpg
    menu title Welcome to CentOS 6.7!
    menu color border 0 #ffffffff #00000000
    menu color sel 7 #ffffffff #ff000000
    menu color title 0 #ffffffff #00000000
    menu color tabmsg 0 #ffffffff #00000000
    menu color unsel 0 #ffffffff #00000000
    menu color hotsel 0 #ff000000 #ffffffff
    menu color hotkey 7 #ffffffff #ff000000
    menu color scrollbar 0 #ffffffff #00000000
    # label指定在boot:提示符下输入的关键字，比如boot:linux[ENTER]，这个会启动label linux下标记的kernel和initrd.img文件。
    label linux   # 一个标签就是前面图片的一行选项。
      menu label ^Install or upgrade an existing system
      menu default
      kernel vmlinuz  # 指定要启动的内核。同样要注意路径，默认是/tftpboot目录。
      append initrd=initrd.img  # 指定追加给内核的参数，initrd.img是一个最小的linux系统
    label vesa
      menu label Install system with ^basic video driver
      kernel vmlinuz
      append initrd=initrd.img nomodeset
    label rescue
      menu label ^Rescue installed system
      kernel vmlinuz
      append initrd=initrd.img rescue
    label local
      menu label Boot from ^local drive
      localboot 0xffff
    label memtest86
      menu label ^Memory test
      kernel memtest
      append -

## 预热之手动网络安装

> 新建一台空白虚拟机，不要挂载ISO，打开电源



###添加如下信息  可以指定mac绑定IP


    [root@55 ~]# cat /var/lib/dhcpd/dhcpd.leases
    # The format of this file is documented in the dhcpd.leases(5) manual page.
    # This lease file was written by isc-dhcp-4.1.1-P1
    
    server-duid "\000\001\000\001\037\245v\276\000\014)\027\215\360";
    
    lease 172.16.1.100 {
      starts 5 2016/10/28 03:44:10;
      ends 5 2016/10/28 09:44:10;
      cltt 5 2016/10/28 03:44:10;
      binding state active;
      next binding state free;
      hardware ethernet 00:0c:29:17:06:25;
      uid "\000VM\012\007\231\027\341\366\236h\231\002]\027\006\033";
    }
    [root@55 ~]#


# 创建ks.cfg文件



> 通常，我们在安装操作系统的过程中，需要大量的和服务器交互操作，为了减少这个交互过程，kickstart就诞生了。使用这种kickstart，只需事先定义好一个Kickstart自动应答配置文件ks.cfg（通常存放在安装服务器上），并让安装程序知道该配置文件的位置，在安装过程中安装程序就可以自己从该文件中读取安装配置，这样就避免了在安装过程中多次的人机交互，从而实现无人值守的自动化安装。

生成kickstart配置文件的三种方法：

- 方法1、 每安装好一台Centos机器，Centos安装程序都会创建一个kickstart配置文件，记录你的真实安装配置。如果你希望实现和某系统类似的安装，可以基于该系统的kickstart配置文件来生成你自己的kickstart配置文件。（生成的文件名字叫anaconda-ks.cfg位于/root/anaconda-ks.cfg）

- 方法2、Centos提供了一个图形化的kickstart配置工具。在任何一个安装好的Linux系统上运行该工具，就可以很容易地创建你自己的kickstart配置文件。kickstart配置工具命令为redhat-config-kickstart（RHEL3）或system-config-kickstart（RHEL4，RHEL5）.网上有很多用CentOS桌面版生成ks文件的文章，如果有现成的系统就没什么可说。但没有现成的，也没有必要去用桌面版，命令行也很简单。
  -方法3、阅读kickstart配置文件的手册。用任何一个文本编辑器都可以创建你自己的kickstart配置文件。



## 查看anaconda-ks.cfg

    [root@55 ~]# cat anaconda-ks.cfg
    # Kickstart file automatically generated by anaconda.
    
    #version=DEVEL
    install
    cdrom
    lang en_US.UTF-8
    keyboard us
    network --onboot no --device eth0 --bootproto dhcp --noipv6
    rootpw  --iscrypted $6$YaQpDjJ0dMlJfNCM$tv0XsR//NXWQQyapdjgMBj1kqxkNIyFHJs717R9oN32FVCqhXI6fGDetwshOwo34R9B2WKIuOXNgW2YSvO2GY1
    firewall --service=ssh
    authconfig --enableshadow --passalgo=sha512
    selinux --enforcing
    timezone Asia/Shanghai
    bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
    # The following is the partition information you requested
    # Note that any partitions you deleted are not expressed
    # here so unless you clear all partitions first, this is
    # not guaranteed to work
    #clearpart --none
    
    #part /boot --fstype=ext3 --asprimary --size=200
    #part swap --asprimary --size=768
    #part / --fstype=ext4 --grow --asprimary --size=200


    repo --name="CentOS"  --baseurl=cdrom:sr0 --cost=100

    %packages
    @base
    @compat-libraries
    @core
    @debugging
    @development
    @server-policy
    @workstation-policy
    python-dmidecode
    sgpio
    device-mapper-persistent-data
    systemtap-client
    %end




## ks.cfg详解

官网文档
CentOS5 : http://www.centos.org/docs/5/html/Installation_Guide-en-US/s1-kickstart2-options.html
CentOS6 : https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-options.html
官网自带中文版，选一下语言即可
ks.cfg文件组成大致分为3段

- 命令段


    键盘类型，语言，安装方式等系统的配置，有必选项和可选项，如果缺少某项必选项，安装时会中断并提示用户选择此项的选项

- 软件包段


    %packages
    @groupname：指定安装的包组
    package_name：指定安装的包
    -package_name：指定不安装的包


在安装过程中默认安装的软件包，安装软件时会自动分析依赖关系。

- 脚本段(可选)


    %pre:安装系统前执行的命令或脚本(由于只依赖于启动镜像，支持的命令很少)
    %post:安装系统后执行的命令或脚本(基本支持所有命令)
    
    关键字 	含义
    install 	告知安装程序，这是一次全新安装，而不是升级upgrade。
    url --url=" " 	通过FTP或HTTP从远程服务器上的安装树中安装。
    url --url="http://10.0.0.7/CentOS-6.7/"
    url --url ftp://<username>:<password>@<server>/<dir>
    nfs 	从指定的NFS服务器安装。
    nfs --server=nfsserver.example.com --dir=/tmp/install-tree
    text 	使用文本模式安装。
    lang 	设置在安装过程中使用的语言以及系统的缺省语言。lang en_US.UTF-8
    keyboard 	设置系统键盘类型。keyboard us
    zerombr 	清除mbr引导信息。
    bootloader 	系统引导相关配置。
    bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
    --location=,指定引导记录被写入的位置.有效的值如下:mbr(缺省),partition(在包含内核的分区的第一个扇区安装引导装载程序)或none(不安装引导装载程序)。
    --driveorder,指定在BIOS引导顺序中居首的驱动器。
    --append=,指定内核参数.要指定多个参数,使用空格分隔它们。
    network 	为通过网络的kickstart安装以及所安装的系统配置联网信息。
    network --bootproto=dhcp --device=eth0 --onboot=yes --noipv6 --hostname=CentOS6
    --bootproto=[dhcp/bootp/static]中的一种，缺省值是dhcp。bootp和dhcp被认为是相同的。
    static方法要求在kickstart文件里输入所有的网络信息。
    network --bootproto=static --ip=10.0.0.100 --netmask=255.255.255.0 --gateway=10.0.0.2 --nameserver=10.0.0.2
    请注意所有配置信息都必须在一行上指定,不能使用反斜线来换行。
    --ip=,要安装的机器的IP地址.
    --gateway=,IP地址格式的默认网关.
    --netmask=,安装的系统的子网掩码.
    --hostname=,安装的系统的主机名.
    --onboot=,是否在引导时启用该设备.
    --noipv6=,禁用此设备的IPv6.
    --nameserver=,配置dns解析.
    timezone 	设置系统时区。timezone --utc Asia/Shanghai
    authconfig 	系统认证信息。authconfig --enableshadow --passalgo=sha512
    设置密码加密方式为sha512 启用shadow文件。
    rootpw 	root密码
    clearpart 	清空分区。clearpart --all --initlabel
    --all 从系统中清除所有分区，--initlable 初始化磁盘标签
    part 	磁盘分区。
    part /boot --fstype=ext4 --asprimary --size=200
    part swap --size=1024
    part / --fstype=ext4 --grow --asprimary --size=200
    --fstype=,为分区设置文件系统类型.有效的类型为ext2,ext3,swap和vfat。
    --asprimary,强迫把分区分配为主分区,否则提示分区失败。
    --size=,以MB为单位的分区最小值.在此处指定一个整数值,如500.不要在数字后面加MB。
    --grow,告诉分区使用所有可用空间(若有),或使用设置的最大值。
    firstboot 	负责协助配置redhat一些重要的信息。
    firstboot --disable
    selinux 	关闭selinux。selinux --disabled
    firewall 	关闭防火墙。firewall --disabled
    logging 	设置日志级别。logging --level=info
    reboot 	设定安装完成后重启,此选项必须存在，不然kickstart显示一条消息，并等待用户按任意键后才重新引导，也可以选择halt关机。


## 编写ks文件


### 生成一个密码

    [root@55 ~]# grub-crypt
    Password:
    Retype password:
    $6$y.1FvZ2F9HlGOtpm$aRiHu9t8HQRhvQMMcsQsl5tLJytPD.Gs6sSYbkR3G0Q4YhOiCKELQg7NOPRW5/pydFg1hWqlvnhSrravB5Qus.
    
    [root@55 ks_config]# pwd
    /var/www/html/ks_config
    [root@55 ks_config]# cat CentOS-6.7-ks.cfg
    # Kickstart Configurator for CentOS 6.7 by yjj
    install
    url --url="http://172.16.1.55/CentOS-6.7/"
    text
    lang en_US.UTF-8
    keyboard us
    zerombr
    bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
    network --bootproto=dhcp --device=eth1 --onboot=yes --noipv6 --hostname=CentOS6
    timezone --utc Asia/Shanghai
    authconfig --enableshadow --passalgo=sha512
    rootpw --iscrypted $6$y.1FvZ2F9HlGOtpm$aRiHu9t8HQRhvQMMcsQsl5tLJytPD.Gs6sSYbkR3G0Q4YhOiCKELQg7NOPRW5/pydFg1hWqlvnhSrravB5Qus.
    clearpart --all --initlabel
    part /boot --fstype=ext4 --asprimary --size=200
    part swap --size=1024
    part / --fstype=ext4 --grow --asprimary --size=200
    firstboot --disable
    selinux --disabled
    firewall --disabled
    logging --level=info
    reboot
    %packages
    @base
    @compat-libraries
    @debugging
    @development
    tree
    nmap
    sysstat
    lrzsz
    dos2unix
    telnet
    %post
    wget -O /tmp/optimization.sh http://172.16.1.55/ks_config/optimization.sh &>/dev/null
    /bin/sh /tmp/optimization.sh
    %end

## 开机优化脚本

    [root@cobbler ks_config]# cat optimization.sh
    #!/bin/bash
    . /etc/init.d/functions
    
    Ip=172.16.1.55
    Port=80
    ConfigDir=ks_config
    NtpServer=ntp1.aliyun.com
    
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
    	Suffix=`ifconfig eth1|awk -F "[ .]+" 'NR==2 {print $6}'`
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
    cat >/etc/sysconfig/network-scripts/ifcfg-eth1 <<-END
    	DEVICE=eth1
    	TYPE=Ethernet
    	ONBOOT=yes
    	NM_CONTROLLED=yes
    	BOOTPROTO=none
    	IPADDR=172.16.1.$Suffix
    	PREFIX=24
    	DEFROUTE=yes
    	IPV4_FAILURE_FATAL=yes
    	IPV6INIT=no
    	NAME="System eth1"
    	END
    Msg "config eth1"
    }
    
    # Defined Yum source Functions
    function yum(){
    	YumDir=/etc/yum.repos.d
    	[ -f "$YumDir/CentOS-Base.repo" ] && cp $YumDir/CentOS-Base.repo{,.ori}
    	wget -O $YumDir/CentOS-Base.repo http://$Ip:$Port/$ConfigDir/CentOS-Base.repo &>/dev/null &&\
    	wget -O $YumDir/epel.repo http://$Ip:$Port/$ConfigDir/epel.repo &>/dev/null &&\
    wget -O $YumDir/yjj.repo http://$Ip:$Port/$ConfigDir/etiantian.repo &>/dev/null
    	Msg "YUM source"
    }


    # Defined add Ordinary users Functions
    function AddUser(){
    	useradd yjj &>/dev/null &&\
    	echo "111111"|passwd --stdin yjj &>/dev/null &&\
    	sed  -i '98a yjjALL=(ALL)   NOPASSWD:ALL'  /etc/sudoers &&\
    	visudo -c &>/dev/null
    	Msg "AddUser yjj"
    }
    
    # Defined Hide the system version number Functions
    function HideVersion(){
    	[ -f "/etc/issue" ] && >/etc/issue
    Msg "Hide issue"
    	[ -f "/etc/issue.net" ] && > /etc/issue.net
    Msg "Hide issue.net"
    }


    # Defined SSHD config Functions
    function sshd(){
    	SshdDir=/etc/ssh
    	[ -f "$SshdDir/sshd_config" ] && /bin/mv $SshdDir/sshd_config{,.ori}
    	wget -O $SshdDir/sshd_config http://$Ip:$Port/$ConfigDir/sshd_config &>/dev/null &&\
    	chmod 600 $SshdDir/sshd_config
    Msg "sshd config"
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
    
    # Defined hosts file Functions
    function hosts(){
    HostsDir=/etc
    [ -f "$HostsDir/hosts" ] && /bin/mv $HostsDir/hosts{,.ori}
    wget -O $HostsDir/hosts http://$Ip:$Port/$ConfigDir/hosts &>/dev/null
    Msg "Hosts config"
    }
    
    # Defined System Startup Services Functions
    function boot(){
    	for auto in `chkconfig --list|grep "3:on"|awk '{print $1}'|grep -vE "crond|network|rsyslog|sshd"`
    	  do
    	   chkconfig $auto off
    	done
    	Msg "BOOT config"
    }
    
    # Defined Time Synchronization Functions
    function Time(){
    	echo "#time sync by yjj at $(date +%F)" >>/var/spool/cron/root
    	echo "*/5 * * * * /usr/sbin/ntpdate $NtpServer &>/dev/null" >>/var/spool/cron/root
    Msg "Time Synchronization"
    }
    
    # Defined main Functions
    function main(){
    	ConfigIP
    	yum
    	AddUser
    	HideVersion
    	sshd
    	openfiles
    	kernel
    	hosts
    	boot
    	Time		
    }
    
    main




### 整合编辑default配置文件

    最精简配置
    [root@55 ks_config]# cat /var/lib/tftpboot/pxelinux.cfg/default
    default ks
    prompt 0
    label ks
      kernel vmlinuz
      append initrd=initrd.img ks=http://172.16.1.55/ks_config/CentOS-6.7-ks.cfg ksdevice=eth1
    [root@55 ks_config]#
    # ksdevice=eth1代表当客户端有多块网卡的时候，要实现自动化需要设置从eth1安装，不指定的话，安装的时候系统会让你选择，那就不叫全自动化了。

## 无人值守安装 ##

打开电源

安装完成后验证

#知识扩展

### PXE配置文件default

由于多个客户端可以从一个PXE服务器引导，PXE引导映像使用了一个复杂的配置文件搜索方式来查找针对客户机的配置文件。如果客户机的网卡的MAC地址为8F：3H：AA：6B：CC：5D，对应的IP地址为10.0.0.195，那么客户机首先尝试以MAC地址为文件名匹配的配置文件，如果不存在就以IP地址来查找。根据上述环境针对这台主机要查找的以一个配置文件就是 /tftpboot/pxelinux.cfg/01-8F：3H：AA：6B：CC：5D。如果该文件不存在，就会根据IP地址来查找配置文件了，这个算法更复杂些，PXE映像查找会根据IP地址16进制命名的客户机配置文件。例如：10.0.0.195对应的16进制的形式为C0A801C3。（可以通过syslinux软件包提供的gethostip命令将10进制的IP转换为16进制）

如果C0A801C3文件不存在，就尝试查找C0A801C文件，如果C0A801C也不存在，那么就尝试C0A801文件，依次类推，直到查找C文件，如果C也不存在的话，那么最后尝试default文件。

总体来说，pxelinux搜索的文件的顺序是：

按精度最高的

    /tftpboot/pxelinux.cfg/01-88-99-aa-bb-cc-dd
    /tftpboot/pxelinux.cfg/C0A801C3
    /tftpboot/pxelinux.cfg/C0A801C
    /tftpboot/pxelinux.cfg/C0A801
    /tftpboot/pxelinux.cfg/C0A80
    /tftpboot/pxelinux.cfg/C0A8
    /tftpboot/pxelinux.cfg/C0A
    /tftpboot/pxelinux.cfg/C0
    /tftpboot/pxelinux.cfg/C
    /tftpboot/pxelinux.cfg/default

应用：如果已经从厂商获取了服务器MAC地址，就可以差异化定制安装服务器了。
