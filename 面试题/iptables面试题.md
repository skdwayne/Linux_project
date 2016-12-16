
# 1. 企业面试口试题

1、详述iptales工作流程以及规则过滤顺序？

![iptables-20161216](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables-20161216.jpg)
![iptables2](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables-flow1.jpg)
![iptables-4tables](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables-4tables.jpg)

2、iptables有几个表以及每个表有几个链？

```bash
四表五链
    filter:
        - INPUT        ## 负责过滤所有目标地址是本机地址的数据包
        - FORWARD      ## 负责转发流经主机的数据包。
        - OUTPUT       ## 处理出站的数据包
    nat:
        - OUTPUT       ## for altering   locally-generated   packets   before   routing
        - PREROUTING   ## for altering packets as soon as  they  come  in
        - POSTROUTING  ## for altering packets as they are about to go  out
    mangle:
        - INPUT
        - FORWARD
        - OUTPUT
        - PREROUTING
        - POSTROUTING
    raw:
        - PREROUTING
        - OUTPUT
```

3、iptables的几个表以及每个表对应链的作用，对应企业应用场景？

    见上题

4、画图讲解iptables包过滤经过不同表和链简易流程图并阐述。

![iptables-flow1-20161216](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables-flow1-20161216.jpg)

5、请写出查看iptables当前所有规则的命令。

    iptables -nL
    iptables -S

6、禁止来自10.0.0.188 ip地址访问80端口的请求

    iptables -t filter -A INPUT -s 10.0.0.188 -p tcp --dport 80 -j DROP
    -t filter 可省略

7、如何使在命令行执行的iptables规则永久生效？

    [root@web01 ~]# /etc/init.d/iptables save
    iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]

    iptables-save >/etc/sysconfig/iptables

8、实现把访问10.0.0.3:80的请求转到172.16.1.17:80

    iptables -t nat -A PREROUTING -d 10.0.0.3 -p tcp --dport 80 -j DNAT --to-destination 172.16.1.17:80

9、实现172.16.1.0/24段所有主机通过124.32.54.26外网IP共享上网。



10、描述tcp 3次握手及四次断开过程？

![tcp-ip-20161216](http://oi480zo5x.bkt.clouddn.com/Linux_project/tcp-ip-20161216.jpg?imageView/2/w/500/q/100)

11.详细描述HTTP工作原理？



12.请描述iptables的常见生产应用场景。



13、请描述下面iptables命令的作用

iptables -N syn-flood
iptables -A INPUT -i eth0 -syn -j syn-flood
iptables -A syn-flood -m limit -limit 5000/s -limit-burst 200 -j RETURN
iptables -A syn-flood -j DROP



14、企业WEB应用较大并发场景如何优化iptables?



## 2. 企业运维经验面试题：

15、写一个防火墙配置脚本，只允许远程主机访问本机的80端口（奇虎360面试题）



16、请描述如何配置一个linux上网网关？



17、请描述如何配置一个专业的安全的WEB服务器主机防火墙？


18、企业实战题6：请用至少两种方法实现！

写一个脚本解决DOS攻击生产案例

提示：根据web日志或者或者网络连接数，监控当某个IP并发连接数或者短时内PV达到100，即调用防火墙命令封掉对应的IP，监控频率每隔3分钟。防火墙命令为：iptables -A INPUT -s 10.0.1.10 -j DROP。

（此题来自老男孩教育SHELL编程必会考试题之一）



19、/var/log/messages日志出现kernel: nf_conntrack: table full, dropping packet.请问是什么原因导致的？如何解决？


20、压轴上机实战iptables考试题
