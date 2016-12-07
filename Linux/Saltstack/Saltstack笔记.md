
# saltstack #

> 作者：杨进杰
> 归档：学习笔记
> 日期： 



## saltstack安装 ##


1.1 安装源
1.1	安装epel源

    # cd /usr/local/src/ 
    # wget http://mirrors.sohu.com/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm
    # rpm -ivh epel-release-6-8.noarch.rpm

### 安装rpmforge ###

这步很重要，在redhat 6和centos 6的epel源上没有python-jinja2，一开始安装变卡在这了. 
# wget http://apt.sw.be/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
# rpm -Uvh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
1.2 安装依赖包
# yum install python-jinja2
1.3 安装saltstack
只需要一台安装master即可，其他的全部安装minion.
3.1 安装salt-master
# yum -y install salt-master --enablerepo=epel-testing
3.2 安装salt-minion
#yum -y install salt-minion --enablerepo=epel-testing

1.4 配置saltstack
4.1 minion配置
# cat  /etc/salt/minion | grep "^  master"
 master: 192.168.0.2
看清楚了master前面有两个空格,这行代码表示我要连接的saltstack的master是192.168.0.2
4.2 master配置
# cat /etc/salt/master | grep '^  interface'
 interface: 192.168.0.2
master监听192.168.0.2,老样子前面也是有两个空格，否则启动的时候会报错.
1.5 启动saltstack
5.1 启动master
# service salt-master start
 Starting salt-master daemon:                               [  OK  ]
5.2 启动minion
#service salt-minion start
 Starting salt-minion daemon:                               [  OK  ]
1.6 测试saltstack
接下来的命令都在master上执行
6.1 查看minion列表

# salt-key -L
Accepted Keys:
 Unaccepted Keys:
 minion1
 Rejected Keys:

 
6.2 接受所有key
# salt-key -A
在提示中提示y确认即可.接下来便可以向minion发送命令了
6.3 简单测试
# salt '*' test.ping
 minion1：
 True
1.7 附加redhat5的安装方法
如果你是redhat 5版本，走下面的操作
1. 快速安装minion的方法
# wget --no-check-certificate -O - http://bootstrap.saltstack.org | sh
2. 常规安装方法
2.1 安装源
# rpm -ivh http://mirrors.kernel.org/fedora-epel/5/x86_64/epel-release-5-4.noarch.rpm
2. 2 安装salt-minion
yum install salt-minion




2.3 .  安装salt-master
yum install salt-master
第2章 结束语
salt的安装方法相比puppet简单很多，担心初学者犯糊涂所以本没有讲太多的配置，着重讲安装，最后在来了一个简单test.ping测试. 后续的文章大家可以关注咱们的ttlsa以及saltstack中文网，当然还有官方站点
更多saltstack学习资料：《saltstack自动化运维》
2.1 参考网址
saltstack中文站：http://wiki.saltstack.cnsaltstack
官方站：http://www.saltstack.com
saltstack运维生存时间：http://www.ttlsa.com











	
