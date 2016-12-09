<!-- TOC -->

- [CentOS 6、7之间的差异](#centos-67%E4%B9%8B%E9%97%B4%E7%9A%84%E5%B7%AE%E5%BC%82)
    - [启动方式的差异](#%E5%90%AF%E5%8A%A8%E6%96%B9%E5%BC%8F%E7%9A%84%E5%B7%AE%E5%BC%82)
        - [SystemV init](#systemv-init)
            - [特点](#%E7%89%B9%E7%82%B9)
            - [应用场景](#%E5%BA%94%E7%94%A8%E5%9C%BA%E6%99%AF)
            - [优点&缺点](#%E4%BC%98%E7%82%B9%E7%BC%BA%E7%82%B9)
            - [未来的趋势](#%E6%9C%AA%E6%9D%A5%E7%9A%84%E8%B6%8B%E5%8A%BF)
        - [应运而生的技术，Upstart技术](#%E5%BA%94%E8%BF%90%E8%80%8C%E7%94%9F%E7%9A%84%E6%8A%80%E6%9C%AFupstart%E6%8A%80%E6%9C%AF)
        - [Systemd技术](#systemd%E6%8A%80%E6%9C%AF)
    - [网卡名称区别](#%E7%BD%91%E5%8D%A1%E5%90%8D%E7%A7%B0%E5%8C%BA%E5%88%AB)
    - [网络配置相关命令区别](#%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE%E7%9B%B8%E5%85%B3%E5%91%BD%E4%BB%A4%E5%8C%BA%E5%88%AB)
    - [主机名和系统版本号配置文件区别](#%E4%B8%BB%E6%9C%BA%E5%90%8D%E5%92%8C%E7%B3%BB%E7%BB%9F%E7%89%88%E6%9C%AC%E5%8F%B7%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E5%8C%BA%E5%88%AB)
    - [运行级别Runlevel区别](#%E8%BF%90%E8%A1%8C%E7%BA%A7%E5%88%ABrunlevel%E5%8C%BA%E5%88%AB)
        - [/etc/inittab](#etcinittab)
    - [管理服务区别](#%E7%AE%A1%E7%90%86%E6%9C%8D%E5%8A%A1%E5%8C%BA%E5%88%AB)
        - [命令补全](#%E5%91%BD%E4%BB%A4%E8%A1%A5%E5%85%A8)

<!-- /TOC -->

# CentOS 6、7之间的差异

## 启动方式的差异

### SystemV init

#### 特点

```
    1. 系统第1个进程（pid=1）为init
    2. init进程是所有进程的祖先，kill不了，只能自杀
    3. 大多数Linux发行版的init系统是和SystemV相兼容的，被称为sysvinit
    4. 代表系统：CentOS6
```

#### 应用场景

>应用于服务器和PC机的时代。

#### 优点&缺点

    SysV init运行非常良好，概念简单清晰。
    它主要依赖于Shell脚本，这就决定了它的最大弱点：启动太慢

#### 未来的趋势

    移动平台，需要启动快的系统

### 应运而生的技术，Upstart技术

>因竞争对手太强，被淘汰

>代表系统：Ubuntu14，从Ubuntu15开始使用systemd

### Systemd技术

* 新系统都会采用的技术（RedHat7，CentOS7，Ubuntu15等）；
* 设计目标是客服sysvinit固有的缺点，提高系统的启动速度；
* 和Sysvinit兼容，降低迁移成本；
* 最主要有点：并行启动。

>三种启动技术对比

![start-technology](http://i.imgur.com/ffIh4VT.jpg)

```
ABCD四个任务有依赖关系
init:总时间T1+T2+T3+T4+T5+T6
upstart:总时间T1+T2+T3，启动速度加快，但是有依赖关系的服务还是必须先启动。
systemd:总时间T，即使有依赖关系的服务，也能并发启动。
并发启动原理之一：解决socket依赖
并发启动原理之二：解决D-Bus依赖
并发启动原理之三：解决文件系统依赖
```

## 网卡名称区别

```
传统上，Linux的网络接口命名为eth0、eth1，但这些名称并不一定符合实际的硬件插槽等，这可能会导致不同的网络配置错误。
基于MAC地址的udev规则在虚拟化的环境中并不有用，这里的MAC地址如端口数量一样无常。

CentOS6/REHL6，引入了一致可预测的网络设备命名网络接口的方法。这些特性可以唯一确定网络接口的名称以使定位和区分设备更容易，并且在这样一种方式下，无论是否重启机器、过了多少时间、或者改变硬件，其名字都是持久不变的。
然而这种命名规则并不是默认开启的。

CentOS7/REHL7，这种可预见的命名规则变成了默认。根据这一规则，接口名称被自动基于固件，拓扑结构和位置信息来确定。
现在，即使添加或移除网络设备，接口名称仍然保持固定，而无需重新枚举，和坏掉的硬件可以无缝替换。
```

## 网络配置相关命令区别

```
ip: yum -y install iproute
centos7主推使用ip命令。
ifconfig: yum -y install net-tools
setup: yum -y install setuptool   废弃命令，只是一个图形工具。依赖于其他几个服务。
我们需要安装用到的网络服务，防火墙，系统服务等。

nmtui：替代setup命令
```

## 主机名和系统版本号配置文件区别

>主机名的配置文件变了

    /etc/hostname

>查看系统版本号

```bash
/etc/redhat-release

所有支持systemd系统的统一发行版名称和版本号文件。
[root@centos7 ~]# cat /etc/os-release 
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CENTOS_MANTISBT_PROJECT="CentOS-7"
CENTOS_MANTISBT_PROJECT_VERSION="7"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="7"

```

## 运行级别Runlevel区别

### /etc/inittab

>runlevel

```bash
[root@centos7 ~]# cat /etc/inittab 
# inittab is no longer used when using systemd.
#
# ADDING CONFIGURATION HERE WILL HAVE NO EFFECT ON YOUR SYSTEM.
#
# Ctrl-Alt-Delete is handled by /usr/lib/systemd/system/ctrl-alt-del.target
#
# systemd uses 'targets' instead of runlevels. By default, there are two main targets:
#
# multi-user.target: analogous to runlevel 3
# graphical.target: analogous to runlevel 5
#
# To view current default target, run:
# systemctl get-default
#
# To set a default target, run:
# systemctl set-default TARGET.target
#
```

>systemctl 查看、设置启动级别

```bash
[root@centos7 ~]# systemctl get-default
multi-user.target
[root@centos7 ~]# systemctl set-default graphical.target
Removed symlink /etc/systemd/system/default.target.
Created symlink from /etc/systemd/system/default.target to /usr/lib/systemd/system/graphical.target.
[root@centos7 ~]# systemctl get-default
graphical.target
[root@centos7 ~]# ll /etc/systemd/system/default.target   ## 本质为软链接
lrwxrwxrwx. 1 root root 40 Dec 10 00:50 /etc/systemd/system/default.target -> /usr/lib/systemd/system/graphical.target
[root@centos7 ~]# systemctl set-default multi-user.target
Removed symlink /etc/systemd/system/default.target.
Created symlink from /etc/systemd/system/default.target to /usr/lib/systemd/system/multi-user.target.
```

>runlevel实质

```bash
[root@centos7 ~]# ls -lh /usr/lib/systemd/system/runlevel*.target
lrwxrwxrwx. 1 root root 15 Dec 10 00:29 /usr/lib/systemd/system/runlevel0.target -> poweroff.target
lrwxrwxrwx. 1 root root 13 Dec 10 00:29 /usr/lib/systemd/system/runlevel1.target -> rescue.target
lrwxrwxrwx. 1 root root 17 Dec 10 00:29 /usr/lib/systemd/system/runlevel2.target -> multi-user.target
lrwxrwxrwx. 1 root root 17 Dec 10 00:29 /usr/lib/systemd/system/runlevel3.target -> multi-user.target
lrwxrwxrwx. 1 root root 17 Dec 10 00:29 /usr/lib/systemd/system/runlevel4.target -> multi-user.target
lrwxrwxrwx. 1 root root 16 Dec 10 00:29 /usr/lib/systemd/system/runlevel5.target -> graphical.target
lrwxrwxrwx. 1 root root 13 Dec 10 00:29 /usr/lib/systemd/system/runlevel6.target -> reboot.target
```

>所有可用的单元文件存放在/usr/lib/systemd/system 和/etc/systemd/system/目录（后者优先级更高）

```bash
[root@centos7 ~]# ls -lh /usr/lib/systemd/system  ## 类似/etc/init.d 目录

[root@centos7 system]# cd /usr/lib/systemd/system/
[root@centos7 system]# cat crond.service 
[Unit]
Description=Command Scheduler
After=auditd.service systemd-user-sessions.service time-sync.target

[Service]
EnvironmentFile=/etc/sysconfig/crond
ExecStart=/usr/sbin/crond -n $CRONDARGS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process

[Install]
WantedBy=multi-user.target

```
## 管理服务区别

* chkconfig
* service
* /etc/init.d/
* systemctl：融合service和chkconfig的功能于一体，兼容SysV和LSB的启动脚本，而且能够在进程启动过程中更有效地引导加载服务。

```bash
[root@centos7 ~]# ll /etc/systemd/system
total 4
drwxr-xr-x. 2 root root   54 Dec 10 00:30 basic.target.wants
lrwxrwxrwx. 1 root root   41 Dec 10 00:29 dbus-org.fedoraproject.FirewallD1.service -> /usr/lib/systemd/system/firewalld.service
lrwxrwxrwx. 1 root root   46 Dec 10 00:29 dbus-org.freedesktop.NetworkManager.service -> /usr/lib/systemd/system/NetworkManager.service
lrwxrwxrwx. 1 root root   57 Dec 10 00:29 dbus-org.freedesktop.nm-dispatcher.service -> /usr/lib/systemd/system/NetworkManager-dispatcher.service
lrwxrwxrwx. 1 root root   41 Dec 10 00:52 default.target -> /usr/lib/systemd/system/multi-user.target
drwxr-xr-x. 2 root root   85 Dec 10 00:29 default.target.wants
drwxr-xr-x. 2 root root   31 Dec 10 00:29 getty.target.wants
drwxr-xr-x. 2 root root 4096 Dec 10 00:35 multi-user.target.wants
drwxr-xr-x. 2 root root   43 Dec 10 00:29 system-update.target.wants
[root@centos7 ~]#

```

Sysvinit、systemd命令区别
![sysvinit-systemd](http://i.imgur.com/JBHkklM.jpg)

### 命令补全

>systemctl 命令补全：bash-completion安装之后，需要退出重新登录

>[root@centos7 ~]# rpm -ivh http://mirrors.aliyun.com/centos/7/os/x86_64/Packages/bash-completion-2.1-6.el7.noarch.rpm

>使用systemctl 命令使用补全查看服务状态

```bash
[root@centos7 ~]# systemctl status crond.service
● crond.service - Command Scheduler
   Loaded: loaded (/usr/lib/systemd/system/crond.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2016-12-10 00:39:29 CST; 24min ago
 Main PID: 754 (crond)
   CGroup: /system.slice/crond.service
           └─754 /usr/sbin/crond -n

Dec 10 00:39:29 centos7 systemd[1]: Started Command Scheduler.
Dec 10 00:39:29 centos7 systemd[1]: Starting Command Scheduler...
Dec 10 00:39:30 centos7 crond[754]: (CRON) INFO (RANDOM_DELAY will ...)
Dec 10 00:39:30 centos7 crond[754]: (CRON) INFO (running with inoti...)
Hint: Some lines were ellipsized, use -l to show in full.
```

>查看系统启动项

```bash
[root@centos7 system]# systemctl list-unit-files |grep enabled
auditd.service                              enabled 
crond.service                               enabled 
dbus-org.fedoraproject.FirewallD1.service   enabled 
dbus-org.freedesktop.NetworkManager.service enabled 
dbus-org.freedesktop.nm-dispatcher.service  enabled 
firewalld.service                           enabled 
getty@.service                              enabled 
irqbalance.service                          enabled 
microcode.service                           enabled 
NetworkManager-dispatcher.service           enabled 
NetworkManager.service                      enabled 
postfix.service                             enabled 
rsyslog.service                             enabled 
sshd.service                                enabled 
systemd-readahead-collect.service           enabled 
systemd-readahead-drop.service              enabled 
systemd-readahead-replay.service            enabled 
tuned.service                               enabled 
default.target                              enabled 
multi-user.target                           enabled 
remote-fs.target                            enabled 
```


