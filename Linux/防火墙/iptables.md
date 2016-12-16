
<!-- TOC -->

- [iptables](#iptables)
    - [iptables防火墙简介](#iptables%E9%98%B2%E7%81%AB%E5%A2%99%E7%AE%80%E4%BB%8B)
    - [iptables术语和名词](#iptables%E6%9C%AF%E8%AF%AD%E5%92%8C%E5%90%8D%E8%AF%8D)
    - [iptables匹配流程](#iptables%E5%8C%B9%E9%85%8D%E6%B5%81%E7%A8%8B)
        - [iptables工作流程小结](#iptables%E5%B7%A5%E4%BD%9C%E6%B5%81%E7%A8%8B%E5%B0%8F%E7%BB%93)
        - [iptables 4张表（tables）](#iptables-4%E5%BC%A0%E8%A1%A8tables)
            - [filter](#filter)
            - [nat](#nat)
            - [mangle](#mangle)
            - [raw](#raw)
    - [iptables表和链工作的流程图](#iptables%E8%A1%A8%E5%92%8C%E9%93%BE%E5%B7%A5%E4%BD%9C%E7%9A%84%E6%B5%81%E7%A8%8B%E5%9B%BE)
    - [iptabes命令](#iptabes%E5%91%BD%E4%BB%A4)
        - [iptables版本](#iptables%E7%89%88%E6%9C%AC)
        - [iptables模块](#iptables%E6%A8%A1%E5%9D%97)
        - [iptables -h](#iptables--h)
        - [iptables常用命令](#iptables%E5%B8%B8%E7%94%A8%E5%91%BD%E4%BB%A4)
        - [实例](#%E5%AE%9E%E4%BE%8B)
            - [禁止当前SSH端口，此处为50517](#%E7%A6%81%E6%AD%A2%E5%BD%93%E5%89%8Dssh%E7%AB%AF%E5%8F%A3%E6%AD%A4%E5%A4%84%E4%B8%BA50517)
            - [禁止80端口](#%E7%A6%81%E6%AD%A280%E7%AB%AF%E5%8F%A3)
            - [禁止来自202.106.0.20IP地址访问服务器873端口端口的请求，协议为tcp](#%E7%A6%81%E6%AD%A2%E6%9D%A5%E8%87%AA202106020ip%E5%9C%B0%E5%9D%80%E8%AE%BF%E9%97%AE%E6%9C%8D%E5%8A%A1%E5%99%A8873%E7%AB%AF%E5%8F%A3%E7%AB%AF%E5%8F%A3%E7%9A%84%E8%AF%B7%E6%B1%82%E5%8D%8F%E8%AE%AE%E4%B8%BAtcp)
            - [限制指定时间包的允许通过数量及并发数,不使用防火墙，使用nginx实现](#%E9%99%90%E5%88%B6%E6%8C%87%E5%AE%9A%E6%97%B6%E9%97%B4%E5%8C%85%E7%9A%84%E5%85%81%E8%AE%B8%E9%80%9A%E8%BF%87%E6%95%B0%E9%87%8F%E5%8F%8A%E5%B9%B6%E5%8F%91%E6%95%B0%E4%B8%8D%E4%BD%BF%E7%94%A8%E9%98%B2%E7%81%AB%E5%A2%99%E4%BD%BF%E7%94%A8nginx%E5%AE%9E%E7%8E%B0)
            - [匹配端口范围](#%E5%8C%B9%E9%85%8D%E7%AB%AF%E5%8F%A3%E8%8C%83%E5%9B%B4)
            - [匹配ICMP类型](#%E5%8C%B9%E9%85%8Dicmp%E7%B1%BB%E5%9E%8B)
            - [匹配指定的网络接口](#%E5%8C%B9%E9%85%8D%E6%8C%87%E5%AE%9A%E7%9A%84%E7%BD%91%E7%BB%9C%E6%8E%A5%E5%8F%A3)
            - [允许关联的状态包通过(web服务不要使用FTP服务)](#%E5%85%81%E8%AE%B8%E5%85%B3%E8%81%94%E7%9A%84%E7%8A%B6%E6%80%81%E5%8C%85%E9%80%9A%E8%BF%87web%E6%9C%8D%E5%8A%A1%E4%B8%8D%E8%A6%81%E4%BD%BF%E7%94%A8ftp%E6%9C%8D%E5%8A%A1)
    - [生产配置](#%E7%94%9F%E4%BA%A7%E9%85%8D%E7%BD%AE)
        - [生产场景iptables示例](#%E7%94%9F%E4%BA%A7%E5%9C%BA%E6%99%AFiptables%E7%A4%BA%E4%BE%8B)
        - [局域网共享的两条命令方法](#%E5%B1%80%E5%9F%9F%E7%BD%91%E5%85%B1%E4%BA%AB%E7%9A%84%E4%B8%A4%E6%9D%A1%E5%91%BD%E4%BB%A4%E6%96%B9%E6%B3%95)
        - [iptables常用企业案例](#iptables%E5%B8%B8%E7%94%A8%E4%BC%81%E4%B8%9A%E6%A1%88%E4%BE%8B)
        - [脚本](#%E8%84%9A%E6%9C%AC)
            - [自动封IP](#%E8%87%AA%E5%8A%A8%E5%B0%81ip)
            - [v1.1](#v11)
            - [v1.2](#v12)
    - [问题记录](#%E9%97%AE%E9%A2%98%E8%AE%B0%E5%BD%95)

<!-- /TOC -->

# iptables

> 大并发的情况，不能开iptables，会影响性能，用硬件防火墙。

安全优化：
1. 尽可能不给服务器配置外网IP。可以通过代理转发，或者通过防火墙映射。
2. 并发不是特别大的情况，在外网IP的环境，开启防火墙。

## iptables防火墙简介

```txt
UNIX/Linux自带的优秀且开放源代码的完全自由的**基于包过滤**的防火墙工具，功能强大，使用非常灵活，可以对流入流出服务器的数据包进行很精细的控制。可在低配下跑的非常好。iptables主要工作在OSI二、三、四层，若重新编译内核，iptables也可以支持7层控制（squid代理+iptables）。

ntop iptraf iftop 查看流量

squid web正向代理，查看http访问日志
```

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
![iptables-20161216](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables-20161216.jpg)

### iptables工作流程小结

```txt
1. 防火墙是一层层过滤的，实际是按照匹配规则的顺序从上往下，从前到后进行过滤的。
2. 如果匹配上规则，即明确表明是阻止还是通过，此时数据包就不再向下匹配新规则了。
3. 如果所有规则中没有表明是阻止还是通过这个数据包，也就是没有匹配上规则，向下进行匹配，直到匹配默认规则得到明确的阻止还是通过。
4. 防火墙的默认规则是对应链的所有的规则执行完才会执行的。
```

### iptables 4张表（tables）

#### filter

```txt
    默认的表，主机防火墙使用的表：确定是否放行该数据包（过滤）
    包含三个链：INPUT，OUTPUT，FORWARD
        INPUT：负责过滤所有目标地址是本机地址的数据包。通俗的讲，及时过滤进入主机的数据包。
        FORWARD：负责转发流经主机的数据包。起转发作用，和NAT关系很大。
        OUTPUT：处理出站的数据包
```

#### nat

```txt
   网络地址转换：修改数据包中的源、目标IP地址或端口

    应用场景：一、用于局域网共享上网；二、端口及IP映射。
    包含三个链：PREROUTING，OUTPUT，POSTROUTING
    PREROUTING：数据包到达防火墙最先经过的链 (for altering packets as soon as they come in)
    POSTROUTING：数据包离开防火墙最后经过的链 (for altering packets as they are about to go out)
    OUTPUT： (for altering locally-generated packets before routing) 在路由前对本地生成的数据包进行修改
```

#### mangle

```txt
为数据包设置标记，修改报文原数据

This table is used for specialized packet alteration.
例如：一些路由标记。
修改数据包中特殊的路由标记，如TTL，TOS，MARK等
```

#### raw

```txt
确定是否对该数据包进行状态跟踪

This table is used  mainly  for  configuring  exemptions from connection tracking in combination with the NOTRACK target.
```

使用raw表内的TRACE target即可实现对iptables规则的跟踪调试。

## iptables表和链工作的流程图

![iptables2](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables-flow1.jpg)

iptables重点工作流程

![iptables3](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables-flow2.jpg)

```txt
规则表的先后顺序:raw→mangle→nat→filter
规则链的先后顺序:
* 入站顺序:PREROUTING→INPUT
* 出站顺序:OUTPUT→POSTROUTING
* 转发顺序:PREROUTING→FORWARD→POSTROUTING
```

![iptables-4tables](http://oi480zo5x.bkt.clouddn.com/Linux_project/iptables-4tables.jpg)

> 还有三点注意事项

1. 没有指定规则表则默认指filter表。
2. 不指定规则链则指表内所有的规则链。
3. 在规则链中匹配规则时会依次检查，匹配即停止（LOG规则例外），若没匹配项则按链的默认状态处理。

## iptabes命令

### iptables版本

```bash
[root@web01 ~]# iptables -V
iptables v1.4.7
```

### iptables模块

> iptables默认加载的模块

```bash
[root@web01 ~]# lsmod|egrep "nat|filter"
iptable_filter          2793  0 
ip_tables              17831  1 iptable_filter
```

> 加载如下模块到Linux内核

```bash
modprobe ip_tables
modprobe iptable_filter
modprobe iptable_nat
modprobe ip_conntrack
modprobe ip_conntrack_ftp
modprobe ip_nat_ftp
modprobe ipt_state

[root@web01 ~]# lsmod|egrep "nat|filter"
nf_nat_ftp              3443  0
nf_conntrack_ftp       11953  1 nf_nat_ftp
iptable_nat             5923  0
nf_nat                 22676  2 nf_nat_ftp,iptable_nat
nf_conntrack_ipv4       9154  3 iptable_nat,nf_nat
nf_conntrack           79206  6 xt_state,nf_nat_ftp,nf_conntrack_ftp,iptable_nat,nf_nat,nf_conntrack_ipv4
iptable_filter          2793  0
ip_tables              17831  2 iptable_nat,iptable_filter
```

### iptables -h

```bash
[root@web01 ~]# iptables -h
iptables v1.4.7

Usage: iptables -[ACD] chain rule-specification [options]
       iptables -I chain [rulenum] rule-specification [options]
       iptables -R chain rulenum rule-specification [options]
       iptables -D chain rulenum [options]
       iptables -[LS] [chain [rulenum]] [options]
       iptables -[FZ] [chain] [options]
       iptables -[NX] chain
       iptables -E old-chain-name new-chain-name
       iptables -P chain target [options]
       iptables -h (print this help information)

Commands:
Either long or short options are allowed.
  --append  -A chain		Append to chain  ## 在规则链的末尾加入新规则
  --check   -C chain		Check for the existence of a rule
  --delete  -D chain		Delete matching rule from chain  ## 删除链上的规则
  --delete  -D chain rulenum
				Delete rule rulenum (1 = first) from chain  ## 删除某一条规则
  --insert  -I chain [rulenum]
				Insert in chain as rulenum (default 1=first)  ## 在指定规则链的头部加入新规则
  --replace -R chain rulenum
				Replace rule rulenum (1 = first) in chain
  --list    -L [chain [rulenum]]
				List the rules in a chain or all chains  ## 列表规则链
  --list-rules -S [chain [rulenum]]
				Print the rules in a chain or all chains
  --flush   -F [chain]		Delete all rules in  chain or all chains  ## 清除所有规则，不会处理默认的规则
  --zero    -Z [chain [rulenum]]
				Zero counters in chain or all chains  ## 所有链的记数器清零
  --new     -N chain		Create a new user-defined chain  ## 创建新的自定义链
  --delete-chain
            -X [chain]		Delete a user-defined chain  ## 删除用户自定义的链
  --policy  -P chain target
				Change policy on chain to target  ##设置默认策略：iptables -P INPUT (DROP|ACCEPT)
  --rename-chain
            -E old-chain new-chain
				Change chain name, (moving any references)
Options:
[!] --proto	-p proto	protocol: by number or name, eg. 'tcp'  ## 匹配协议，如：全部协议/TCP协议/UDP协议/ICMP协议，加叹号"!"表示除这个IP之外
[!] --source	-s address[/mask][...]  ## 匹配源地址IP/MASK，加叹号"!"表示除这个IP之外
				source specification
[!] --destination -d address[/mask][...]  ## 匹配目标地址，加叹号"!"表示除此之外
				destination specification
[!] --in-interface -i input name[+]  ## 匹配从这块网卡进入的数据，例："-i eth0" 表示从eth0进入的数据，加叹号"!"表示除此之外
				network interface name ([+] for wildcard)
 --jump	-j target
				target for rule (may load target extension)  ## 目标的处理，例如：ACCEPT（接受）、DROP（丢弃）、REJECT（拒绝）
  --goto      -g chain
                              jump to chain with no return
  --match	-m match
				extended match (may load extension)
  --numeric	-n		numeric output of addresses and ports  ## 数字输出
[!] --out-interface -o output name[+]  ## 匹配从这块网卡流出的数据，例："-o eth1" 表示从eth1出去的数据，INPUT上不能使用，加叹号"!"表示除此之外
				network interface name ([+] for wildcard)
  --table	-t table	table to manipulate (default: 'filter')  ## 指定表类型
  --verbose	-v		verbose mode
  --line-numbers		print line numbers when listing  ## 显示规则的序号（行号）
  --exact	-x		expand numbers (display exact values)
[!] --fragment	-f		match second or further fragments only
  --modprobe=<command>		try to insert modules using this command
  --set-counters PKTS BYTES	set the counter during insert/append
[!] --version	-V		print package version.

  --sport num  ## 匹配源端口号，例：匹配指定端口--sport 80，或者匹配范围--sport 80:1000
  --dport num  ## 匹配目的端口号，例：匹配指定端口--dport 80，或者匹配范围--dport 80:1000
  -m mulitport  ## 匹配多端口，例：-m mulitport -dport 21,22,23,24
  -m  ## 扩展匹配，例："-m tcp"的意思是使用 tcp 扩展模块的功能 (tcp扩展模块提供了 --dport, --tcp-flags, --sync等功能）
  -p icmp --icmp-type 8  ## 表示匹配icmp协议的类型8
  -m state --state  ## 匹配网络状态：
        NEW：已经或将启动新的连接
        ESTABLISHED：已建立的连接
        RELATED：正在启动的新连接
        INVALID：非法或无法识别的
    注：FTP服务是特殊的，需要匹配状态连接
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
---------------不使用防火墙做如下操作，直接使用nginx
    限制指定时间包的允许通过数量及并发数
    -m limit --limit n/{second/minute/hour}:
    指定时间内的请求速率"n"为速率，后面为时间分别为：秒、分、时
    --limit-burst [n]
    在同一时间内允许通过的请求"n"为数字,不指定默认为5
    iptables -I INPUT -s 10.0.1.0/24 -p icmp --icmp-type 8 -m limit --limit 5/min --limit-burst 2 -j ACCEPT
```

### iptables常用命令

```bsh
清除默认规则
iptables -F   ## 清除所有规则，不会处理默认的规则 等价于--flush
iptables -X   ## 删除用户自定义的链 等价于--delete-chain
iptables -Z   ## 链的计数器清零 等价于--zero

-n             数字
-L             列表
-t             指定表
-A             添加规则到指定链的结尾，最后一条
-I             添加规则到指定链的开头，第一条
-p             协议
--dport        目的端口
-j --jump      处理的行为
--line-numbers 显示序号
-s             指定源地址
```

### 实例

#### 禁止当前SSH端口，此处为50517

```bash
[root@web01 ~]# ss -lntup|grep sshd
tcp    LISTEN     0      128                   :::50517                :::*      users:(("sshd",5455,4))
tcp    LISTEN     0      128                    *:50517                 *:*      users:(("sshd",5455,3))
[root@web01 ~]# iptables -t filter -A INPUT -p tcp --dport 50517 -j DROP

**删除临时规则**:
    1. iptables -F
    2. iptables -t filter -D INPUT -p tcp --dport 50517 -j DROP
    3. iptables -D INPUT 序列号（iptables --line-numbers -L）
    4. /etc/init.d/iptables stop(restart)

iptables -A INPUT -p tcp --dport 50517 -j DROP
iptables -t filter -A INPUT -p tcp --dport 50517 -j DROP
注：
1. iptables默认用的就是filter表，因此，以上两条命令等价
2. 其中INPUT DROP要大写
3. --jump  -j  target
    target for rule (may load target extension)

基本的处理行为：ACCEPT（接受）、DROP（丢弃）、REJECT（拒绝）
使用DROP代替REJECT

恢复刚才断掉的SSH连接
1. 去机房重启系统或者登陆服务器删除刚才的禁止规则
2. 让机房人员重启服务器或者让机房人员拿用户密码登录进去
3. 通过服务器的远程管理卡管理（推荐）
4. 先写一个定时任务，每5分钟就停止防火墙。
5. 测试环境测试好，写成脚本，批量执行。
```

```bash
[root@web01 ~]# iptables -nL
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
DROP       tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:50517   ## 此规则禁止SSH连接

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

iptables --line-numbers -L ## 查看序号
iptables -D INPUT 1        ## 删除指定规则
```

使用-A和-I的顺序，防火墙的过滤根据规则顺序的。

1. -A 是添加规则到指定链的结尾，最后一条。
2. -I 是添加规则到指定链的开头，第一条。

```BASH
[root@web01 ~]# iptables -t filter -I INPUT -p tcp --dport 50517 -j ACCEPT
[root@web01 ~]# iptables -nL
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:50517 
DROP       tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:50517   ## 在禁止规则前面添加接受规则，SSH可以连接，有匹配的规则，不再向下匹配

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination       

iptables -F
iptables -X
iptables -Z
```

#### 禁止80端口

开启web01，nginx

```bash
[root@web01 ~]# ip a |grep 10.0.0
    inet 10.0.0.8/24 brd 10.0.0.255 scope global eth0
[root@web01 ~]# ss -lntup |grep 80
tcp    LISTEN     0      511                    *:80                    *:*      users:(("nginx",1971,6),("nginx",5681,6))
```

访问如下：

![web](http://oi480zo5x.bkt.clouddn.com/Linux_project/web.png)

```bash
[root@web01 ~]# iptables -t filter -A INPUT -p tcp --dport 80 -j DROP
[root@web01 ~]# iptables -nL
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:80 

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination       
添加规则之后，80端口无法访问
```

#### 禁止来自202.106.0.20IP地址访问服务器873端口端口的请求，协议为tcp

```bash
[root@web01 ~]# iptables -A INPUT -s 202.106.0.20 -p tcp --dport 873 -j DROP
[root@web01 ~]# iptables --line-numbers -L
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         
1    DROP       tcp  --  gjjline.bta.net.cn   anywhere            tcp dpt:rsync 

Chain FORWARD (policy ACCEPT)
num  target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
num  target     prot opt source               destination         
```

#### 限制指定时间包的允许通过数量及并发数,不使用防火墙，使用nginx实现

```bash
-m limit --limit n/{second/minute/hour}:
指定时间内的请求速率"n"为速率，后面为时间分别为：秒、分、时
--limit-burst [n]：
在同一时间内允许通过的请求"n"为数字,不指定默认为5
iptables -I INPUT -s 10.0.1.0/24 -p icmp --icmp-type 8 -m limit --limit 5/min --limit-burst 2 -j ACCEPT
```

#### 匹配端口范围

```bash
iptables -A INPUT -p tcp --sport 22:80
iptables -I INPUT -p tcp --dport 21,22,23,24 -j ACCEPT===》错误语法
iptables -I INPUT -p tcp -m multiport --dport 21,22,23,24 -j ACCEPT
iptables -I INPUT -p tcp --dport 3306:8809 -j ACCEPT
iptables -I INPUT -p tcp --dport 18:80 -j DROP
```

#### 匹配ICMP类型

```bash
iptables -A INPUT -p icmp --icmp-type 8
例：iptables -A INPUT -p icmp --icmp-type 8 -j DROP
iptables -A INPUT -p icmp -m icmp --icmp-type any -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -p icmp -m icmp --icmp-type any -j ACCEPT
```

#### 匹配指定的网络接口

```bash
iptables -A INPUT -i eth0
iptables -A FORWARD -o eth0
```

#### 允许关联的状态包通过(web服务不要使用FTP服务)

```bash
#others RELATED ftp协议
#允许关联的状态包
iptables -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

## 生产配置

```BASH
[root@web01 ~]# iptables -A INPUT -p tcp --dport 50517 -j ACCEPT  ## 局域网内不用配置，针对外网可以考虑如何优化
[root@web01 ~]# iptables -A INPUT -p tcp -s 10.0.0.0/24 -j ACCEPT
[root@web01 ~]# iptables -A INPUT -p tcp -s 192.168.1.0/24 -j ACCEPT
[root@web01 ~]# iptables -P INPUT DROP
[root@web01 ~]# iptables -P FORWARD ACCEPT
[root@web01 ~]# iptables -P OUTPUT ACCEPT
[root@web01 ~]# iptables -nL
Chain INPUT (policy DROP)
target     prot opt source               destination         
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:50517 
ACCEPT     tcp  --  10.0.0.0/24          0.0.0.0/0           
ACCEPT     tcp  --  192.168.1.0/24       0.0.0.0/0           

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
[root@web01 ~]# iptables -A INPUT -p tcp --dport 80 -j ACCEPT
[root@web01 ~]# iptables -A INPUT -p tcp --dport 443 -j ACCEPT
[root@web01 ~]# iptables -A INPUT -i lo -j ACCEPT
[root@web01 ~]# iptables -A OUTPUT -o lo -j ACCEPT
[root@web01 ~]# iptables -A INPUT -p icmp -m icmp --icmp-type any -j ACCEPT
[root@web01 ~]# iptables -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
[root@web01 ~]# iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

[root@web01 ~]# iptables -nL
Chain INPUT (policy DROP)
target     prot opt source               destination         
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:50517 
ACCEPT     tcp  --  10.0.0.0/24          0.0.0.0/0           
ACCEPT     tcp  --  192.168.1.0/24       0.0.0.0/0           
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:80 
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:443 
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           icmp type 255 
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 

## 保存规则到文件
[root@web01 ~]# /etc/init.d/iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
或者使用如下方法：
[root@web01 ~]# iptables-save >/etc/sysconfig/iptables
```


### 生产场景iptables示例

```bash
iptables -A INPUT -s 124.43.62.96/27 -p all -j ACCEPT   办公室固定IP段。
iptables -A INPUT -s 192.168.1.0/24 -p all -j ACCEPT    IDC机房的内网网段。
iptables -A INPUT -s 10.0.0.0/24 -p all -j ACCEPT       其他机房的内网网段。
iptables -A INPUT -s 203.83.24.0/24 -p all -j ACCEPT    IDC机房的外网网段
iptables -A INPUT -s 201.82.34.0/24 -p all -j ACCEPT    其它IDC机房的外网网段
```

iptables实战应用场景

```bash
1. 主机防火墙 filter(INPUT)
2. 局域网共享上网 nat(POSTROUTING)
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -o eth0 -j SNAT --to-source 10.0.0.9
```

###  局域网共享的两条命令方法

方法1：适合于有固定外网地址的：

```bash
1. 无外网IP服务器，设置默认路由
    route add default gw 172.16.1.8  ## 临时生效
    可设置网卡配置文件，添加网关172.16.1.8，永久生效
        [root@lb01 ~]# route -n
        Kernel IP routing table
        Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
        172.16.1.0      0.0.0.0         255.255.255.0   U     0      0        0 eth1
        169.254.0.0     0.0.0.0         255.255.0.0     U     1003   0        0 eth1
        0.0.0.0         172.16.1.8      0.0.0.0         UG    0      0        0 eth1

2. 有外网IP的服务器开启内核转发
    vim /etc/sysctl.conf ## 设置如下内容
        net.ipv4.ip_forward = 1
    sysctl -p  ## 使设置生效
3. 设置转发
    iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -o eth0 -j SNAT --to-source 10.0.0.7
        1. -s 192.168.1.0/24 办公室或IDC内网网段。
        2. -o eth0 为网关的外网卡接口。
        3. -j SNAT --to-source 10.0.0.7 是网关外网卡IP地址。
            ## 规则查看
            [root@web01 ~]# iptables -nL -t nat
            Chain PREROUTING (policy ACCEPT)
            target     prot opt source               destination

            Chain POSTROUTING (policy ACCEPT)
            target     prot opt source               destination
            SNAT       all  --  172.16.1.0/24        0.0.0.0/0           to:10.0.0.8

            Chain OUTPUT (policy ACCEPT)
            target     prot opt source               destination
4. 成功

```

方法2：适合变化外网地址（ADSL）：

```bash
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -j MASQUERADE
MASQUERADE #为伪装
```

端口映射：

```bash
iptables -t nat -A PREROUTING -d 10.0.0.9 -p tcp --dport 80 -j DNAT --to-destination 172.16.1.6:80
```

端口映射企业应用场景：

```txt
1. 把访问外网IP及端口的请求映射到内网某个服务器及端口（企业内部）。
2. 硬件防火墙，把访问LVS/nginx外网VIP及80端口的请求映射到IDC 负载均衡服务器内部IP及端口上（IDC机房的操作）
```

### iptables常用企业案例

```bash
1. Linux主机防火墙（表：FILTER  链：INPUT）。
2. 局域网机器共享上网（表：NAT 链：POSTROUTING）：
iptables -t nat POSTROUTING-s 172.16.1.0/24 -o eth0 -j SNAT --to-source 10.0.0.7

3. 外部地址和端口，映射为内部地址和端口（表：NAT  链：PREROUTING）：
iptables -t nat -A PREROUTING -d 10.0.0.7 -p tcp --dport 80 -j DNAT --to-destination 172.16.1.8:9000
```

实现10网段外网IP和内网172网段IP一对一映射

```bash
实现公网IP：124.42.34.112一对一映射到内部server 10.0.0.8：
网关IP：eth0:124.42.60.109    eth1:10.0.0.254
首先在路由网关上绑定124.42.34.112，可以是别名的方式：
-A PREROUTING -d 124.42.34.112 -j DNAT --to-destination 10.0.0.8
-A POSTROUTING -s 10.0.0.8 -o eth0 -j SNAT --to-source 124.42.34.112
-A POSTROUTING -S 10.0.0.0/255.255.240.0 -d 124.42.34.112 -j SNAT --to-source 10.0.0.254

映射多个外网IP上网
iptables -t nat -A POSTROUTING -s 10.0.1.0/255.255.240.0 -o eth0 -j SNAT --to-source 124.42.60.11-124.42.60.16

```

###  脚本

#### 自动封IP

```bash
分析web或应用日志或者网络连接状态封掉垃圾IP
#!/bin/sh
/bin/netstat -na|grep ESTABLISHED|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -rn|head -10|grep -v -E '192.168|127.0'|awk '{if ($2!=null && $1>4) {print $2}}'>/home/shell/dropip
for i in $(cat /home/shell/dropip)
do
        /sbin/iptables -I INPUT -s $i -j DROP
#-m limit --limit 20/min --limit-burst 6
        echo "$i kill at `date`">>/var/log/ddos
done

```

#### v1.1

```bash
#!/bin/bash
# function: a server firewall
# version:1.1
################################################
#define variable PATH
IPT=/sbin/iptables
LAN_GW_IP=192.168.0.15
WAN_GW_IP=10.0.0.15
LAN_SERVER=192.168.0.14

echo 1 > /proc/sys/net/ipv4/ip_forward
modprobe ip_tables
modprobe iptable_filter
modprobe iptable_nat
modprobe ip_conntrack
modprobe ip_conntrack_ftp
modprobe ip_nat_ftp
modprobe ipt_state

#Remove any existing rules
$IPT -F
$IPT -X

#setting default firewall policy
$IPT --policy OUTPUT ACCEPT
$IPT --policy FORWARD ACCEPT
$IPT -P INPUT DROP

#setting for loopback interface
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT


# prevent all Stealth Scans and TCP State Flags
$IPT -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
# All of the bits are cleared
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
$IPT -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
#SYN and RST are both set
$IPT -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
# SYN and FIN are both set
$IPT -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
# FIN and RST are both set
$IPT -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
# FIN is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
# PSH is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
# URG is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP


#setting access rules
#one,ip access rules,allow all the ips of hudong.com
$IPT -A INPUT -s 202.81.17.0/24 -p all -j ACCEPT
$IPT -A INPUT -s 202.81.18.0/24 -p all -j ACCEPT
$IPT -A INPUT -s 124.43.62.96/27 -p all -j ACCEPT
$IPT -A INPUT -s 192.168.1.0/24 -p all -j ACCEPT
$IPT -A INPUT -s 10.0.0.0/24 -p all -j ACCEPT


#second,port access rules
#nagios
$IPT -A INPUT  -s 192.168.1.0/24  -p tcp  --dport 5666 -j ACCEPT
$IPT -A INPUT  -s 202.81.17.0/24  -p tcp  --dport 5666 -j ACCEPT
$IPT -A INPUT  -s 202.81.18.0/24  -p tcp  --dport 5666 -j ACCEPT

#db
$IPT -A INPUT  -s 192.168.1.0/24  -p tcp  --dport 3306 -j ACCEPT
$IPT -A INPUT  -s 192.168.1.0/24  -p tcp  --dport 3307 -j ACCEPT
$IPT -A INPUT  -s 192.168.1.0/24  -p tcp  --dport 3308 -j ACCEPT
$IPT -A INPUT  -s 192.168.1.0/24  -p tcp  --dport 1521 -j ACCEPT

#ssh difference from other servers here.........................................................>>
$IPT -A INPUT -s 202.81.17.0/24  -p tcp  --dport 50718 -j ACCEPT
$IPT -A INPUT -s 202.81.18.0/24  -p tcp  --dport 50718 -j ACCEPT
$IPT -A INPUT -s 124.43.62.96/27  -p tcp  --dport 50718 -j ACCEPT
$IPT -A INPUT -s 192.168.1.0/24  -p tcp  --dport 50718 -j ACCEPT
$IPT -A INPUT   -p tcp  -s 10.0.0.0/24 --dport 22 -j ACCEPT
#ftp
#$IPT -A INPUT   -p tcp  --dport 21 -j ACCEPT

#http
$IPT -A INPUT   -p tcp  --dport 80 -j ACCEPT
$IPT -A INPUT   -s 192.168.1.0/24  -p  tcp  -m multiport --dport 8080,8081,8082,8888,8010,8020,8030,8150 -j ACCEPT
$IPT -A INPUT   -s 202.81.17.0/24  -p tcp  -m multiport --dport 8080,8081,8082,8888,8010,8020,8030,8150 -j ACCEPT
$IPT -A INPUT   -s 124.43.62.96/27 -p tcp  -m multiport --dport 8080,8081,8082,8888,8010,8020,8030,8150 -j ACCEPT


#snmp
$IPT -A INPUT -s 192.168.1.0/24 -p UDP  --dport 161 -j ACCEPT 
$IPT -A INPUT -s 202.81.17.0/24 -p UDP  --dport 161 -j ACCEPT 
$IPT -A INPUT -s 202.81.18.0/24 -p UDP  --dport 161 -j ACCEPT 

#rsync
$IPT -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 873   -j ACCEPT
$IPT -A INPUT -s 202.81.17.0/24 -p tcp -m tcp --dport 873   -j ACCEPT
$IPT -A INPUT -s 202.81.18.0/24 -p tcp -m tcp --dport 873   -j ACCEPT
$IPT -A INPUT -s 124.43.62.96/27 -p tcp -m tcp --dport 873   -j ACCEPT

#nfs 2049,portmap 111
$IPT -A INPUT -s 192.168.1.0/24 -p udp  -m multiport --dport 111,892,2049 -j ACCEPT 
$IPT -A INPUT -s 192.168.1.0/24 -p tcp  -m multiport --dport 111,892,2049 -j ACCEPT 

#others RELATED
#$IPT -A INPUT -p icmp -m icmp --icmp-type any -j ACCEPT
$IPT -A INPUT -s 124.43.62.96/27 -p icmp -m icmp --icmp-type any -j ACCEPT
$IPT -A INPUT -s 192.168.1.0/24 -p icmp -m icmp --icmp-type any -j ACCEPT

$IPT -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

###############nat start##############################
#nat internet
iptables -t nat -A POSTROUTING -s 192.168.0.0/255.255.255.0 -o eth1 -j SNAT --to-source $LAN_GW_IP

#www server nat wan to lan
iptables -t nat -A PREROUTING  -d $WAN_GW_IP -p tcp -m tcp --dport 80 -j DNAT --to-destination $LAN_SERVER:80
iptables -t nat -A POSTROUTING -d $LAN_SERVER -p tcp --dport 80 -j SNAT --to $LAN_GW_IP
```

#### v1.2

```bash
#!/bin/bash
# function: a server firewall
# version:1.2
################################################
#define variable PATH

IPT=/sbin/iptables

#Remove any existing rules
$IPT -F
$IPT -X
$IPT -Z
#setting default firewall policy
$IPT --policy OUTPUT ACCEPT
$IPT --policy FORWARD DROP
$IPT -P INPUT DROP

#setting for loopback interface
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

# Source Address Spoofing and Other Bad Addresses
$IPT -A INPUT -i eth0 -s 172.16.0.0/12 -j DROP
$IPT -A INPUT -i eth0 -s 0.0.0.0/8 -j DROP
$IPT -A INPUT -i eth0 -s 169.254.0.0/16 -j DROP
$IPT -A INPUT -i eth0 -s 192.0.2.0/24 -j DROP

# prevent all Stealth Scans and TCP State Flags
$IPT -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
# All of the bits are cleared
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
$IPT -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
#SYN and RST are both set
$IPT -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
# SYN and FIN are both set
$IPT -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
# FIN and RST are both set
$IPT -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
# FIN is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
# PSH is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
# URG is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP



#setting access rules
#one,ip access rules,allow all the ips of 
$IPT -A INPUT -s 10.0.10.0/24 -p all -j ACCEPT
$IPT -A INPUT -s 10.0.0.0/24 -p all -j ACCEPT

#下面的是重复的，作为知识点保留

#second,port access rules
#nagios
$IPT -A INPUT  -s 10.0.10.0/24  -p tcp  --dport 5666 -j ACCEPT
$IPT -A INPUT  -s 10.0.0.0/24  -p tcp  --dport 5666 -j ACCEPT

#db
$IPT -A INPUT  -s 10.0.0.0/24  -p tcp  --dport 3306 -j ACCEPT
$IPT -A INPUT  -s 10.0.0.0/24  -p tcp  --dport 3307 -j ACCEPT
$IPT -A INPUT  -s 10.0.10.0/24  -p tcp  --dport 3306 -j ACCEPT
$IPT -A INPUT  -s 10.0.10.0/24  -p tcp  --dport 3307 -j ACCEPT

#ssh difference from other servers here.>>
$IPT -A INPUT -s 10.0.0.0/24  -p tcp  --dport 52113 -j ACCEPT
$IPT -A INPUT -s 10.0.10.0/24  -p tcp  --dport 52113 -j ACCEPT

$IPT -A INPUT   -p tcp  --dport 22 -j ACCEPT

#http
$IPT -A INPUT   -p tcp  --dport 80 -j ACCEPT

#snmp
$IPT -A INPUT -s 10.0.0.0/24 -p UDP  --dport 161 -j ACCEPT 
$IPT -A INPUT -s 10.0.10.0/24 -p UDP  --dport 161 -j ACCEPT 

#rsync
$IPT -A INPUT -s 10.0.0.0/24 -p tcp -m tcp --dport 873   -j ACCEPT
$IPT -A INPUT -s 10.0.10.0/24 -p tcp -m tcp --dport 873   -j ACCEPT

#icmp
#$IPT -A INPUT -p icmp -m icmp --icmp-type any -j ACCEPT

#others RELATED
$IPT -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

## 问题记录

dmesg里面显示 ip_conntrack:table full, dropping packet.的错误提示.如何解决。

```bash
net.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
```
