
<!-- TOC -->

- [iptables](#iptables)
    - [iptables防火墙简介](#iptables%E9%98%B2%E7%81%AB%E5%A2%99%E7%AE%80%E4%BB%8B)
    - [iptables术语和名词](#iptables%E6%9C%AF%E8%AF%AD%E5%92%8C%E5%90%8D%E8%AF%8D)
    - [iptables匹配流程](#iptables%E5%8C%B9%E9%85%8D%E6%B5%81%E7%A8%8B)
        - [iptables工作流程小结](#iptables%E5%B7%A5%E4%BD%9C%E6%B5%81%E7%A8%8B%E5%B0%8F%E7%BB%93)
        - [iptables 4张表（tables）](#iptables-4%E5%BC%A0%E8%A1%A8tables)

<!-- /TOC -->

# iptables

> 大并发的情况，不能开iptables，会影响性能，用硬件防火墙。

安全优化：
1. 尽可能不给服务器配置外网IP。可以通过代理转发。
2. 并发不是特别大的情况，在外网IP的环境，开启防火墙。

## iptables防火墙简介

UNIX/Linux自带的优秀且开放源代码的完全自由的基于包过滤的防火墙工具，功能强大，使用非常灵活，可以对流入流出服务器的数据包进行很精细的控制。可在低配下跑的非常好。iptables主要工作在OSI二、三、四层，若重新编译内核，iptables也可以支持7层控制（squid代理+iptables）。

ntop iptraf iftop 查看流量
squid web正向代理，查看http访问日志

## iptables术语和名词

> 1、什么是容器？

    包含或者说属于的关系

> 2、什么是Netfilter/iptables？

    Netfilter是表（tables）的容器，Netfilter包含多张表。

> 3、什么是表（tables）？

    表（tables）是链的容器

> 4、什么是链（chains）？

    链（chains）是规则（Policys）的容器。

> 5、什么是规则（policy）？

    规则（policy）就是iptables一系列过滤信息的规范和具体命令。

iptables==》表（tables）==》链（chains）==》规则（policy）

> iptables命令中常见的控制类型有

```txt
ACCEPT：允许通过.
LOG：记录日志信息,然后传给下一条规则继续匹配.
REJECT：拒绝通过,必要时会给出提示.
DROP：直接丢弃,不给出任何回应.
```

> 规则链则依据处理数据包的位置不同而进行分类：

```txt
PREROUTING：在进行路由选择前处理数据包
INPUT：处理入站的数据包
OUTPUT：处理出站的数据包
FORWARD：处理转发的数据包
POSTROUTING：在进行路由选择后处理数据包
```

## iptables匹配流程

> iptables采用数据包过滤机制工作的，会对请求的数据包的包头数据进行分析，根据预先设定的规则进行匹配决定是否放行。

数据包流向：从左至右
![iptables1](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables.jpg)

### iptables工作流程小结

**1. 防火墙是一层层过滤的，实际是按照匹配规则的顺序从上往下，从前到后进行过滤的。
2. 如果匹配上规则，即明确表明是阻止还是通过，此时数据包就不再向下匹配新规则了。
3. 如果所有规则中没有表明是阻止还是通过这个数据包，也就是没有匹配上规则，向下进行匹配，直到匹配默认规则得到明确的阻止还是通过。
4. 防火墙的默认规则是对应链的所有的规则执行完才会执行的。**

### iptables 4张表（tables）

1. filter（默认的表，主机防火墙使用的表）：确定是否放行该数据包（过滤）
    包含三个链：INPUT，OUTPUT，FORWARD
2. nat（网络地址转换）：修改数据包中的源、目标IP地址或端口
    应用场景：一、用于局域网共享上网；二、端口及IP映射。
    包含三个链：PREROUTING，OUTPUT，POSTROUTING
    PREROUTING：数据包到达防火墙最先经过的链 (for altering packets as soon as they come in)
    POSTROUTING：数据包离开防火墙最后经过的链 (for altering packets as they are about to go out)
    OUTPUT： (for altering locally-generated packets before routing) 在路由前对本地生成的数据包进行修改
3. mangle：为数据包设置标记，修改报文原数据
    This table is used for specialized packet alteration.
    例如：一些路由标记。
    修改数据包中特殊的路由标记，如TTL，TOS，MARK等
4. raw：确定是否对该数据包进行状态跟踪
    This table is used  mainly  for  configuring  exemptions from connection tracking in combination with the NOTRACK target.

使用raw表内的TRACE target即可实现对iptables规则的跟踪调试。

