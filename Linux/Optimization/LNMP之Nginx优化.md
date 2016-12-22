# Nginx优化

## Table of Contents

<!-- TOC -->

- [Nginx优化](#nginx%E4%BC%98%E5%8C%96)
    - [Table of Contents](#table-of-contents)
    - [隐藏Nginx版本号](#%E9%9A%90%E8%97%8Fnginx%E7%89%88%E6%9C%AC%E5%8F%B7)
    - [更改Nginx服务用户](#%E6%9B%B4%E6%94%B9nginx%E6%9C%8D%E5%8A%A1%E7%94%A8%E6%88%B7)
    - [更改Nginx master用户，服务降权](#%E6%9B%B4%E6%94%B9nginx-master%E7%94%A8%E6%88%B7%E6%9C%8D%E5%8A%A1%E9%99%8D%E6%9D%83)
    - [调整worker进程数](#%E8%B0%83%E6%95%B4worker%E8%BF%9B%E7%A8%8B%E6%95%B0)
    - [绑定不同的Nginx进程到不同的核心上](#%E7%BB%91%E5%AE%9A%E4%B8%8D%E5%90%8C%E7%9A%84nginx%E8%BF%9B%E7%A8%8B%E5%88%B0%E4%B8%8D%E5%90%8C%E7%9A%84%E6%A0%B8%E5%BF%83%E4%B8%8A)
    - [调整Nginx模型为epoll，默认就是](#%E8%B0%83%E6%95%B4nginx%E6%A8%A1%E5%9E%8B%E4%B8%BAepoll%E9%BB%98%E8%AE%A4%E5%B0%B1%E6%98%AF)
    - [调整worker单个进程的最大连接数，默认1024，不宜过大，也不宜过小](#%E8%B0%83%E6%95%B4worker%E5%8D%95%E4%B8%AA%E8%BF%9B%E7%A8%8B%E7%9A%84%E6%9C%80%E5%A4%A7%E8%BF%9E%E6%8E%A5%E6%95%B0%E9%BB%98%E8%AE%A41024%E4%B8%8D%E5%AE%9C%E8%BF%87%E5%A4%A7%E4%B9%9F%E4%B8%8D%E5%AE%9C%E8%BF%87%E5%B0%8F)
    - [配置Nginx Worker进程最大打开文件数](#%E9%85%8D%E7%BD%AEnginx-worker%E8%BF%9B%E7%A8%8B%E6%9C%80%E5%A4%A7%E6%89%93%E5%BC%80%E6%96%87%E4%BB%B6%E6%95%B0)
    - [开启高效传输](#%E5%BC%80%E5%90%AF%E9%AB%98%E6%95%88%E4%BC%A0%E8%BE%93)
    - [优化Nginx连接参数调整连接超时时间](#%E4%BC%98%E5%8C%96nginx%E8%BF%9E%E6%8E%A5%E5%8F%82%E6%95%B0%E8%B0%83%E6%95%B4%E8%BF%9E%E6%8E%A5%E8%B6%85%E6%97%B6%E6%97%B6%E9%97%B4)
    - [上传文件大小限制](#%E4%B8%8A%E4%BC%A0%E6%96%87%E4%BB%B6%E5%A4%A7%E5%B0%8F%E9%99%90%E5%88%B6)
    - [FastCGI参数调整](#fastcgi%E5%8F%82%E6%95%B0%E8%B0%83%E6%95%B4)
    - [**Nginx gzip压缩**](#nginx-gzip%E5%8E%8B%E7%BC%A9)
        - [Nginx gzip压缩的优点](#nginx-gzip%E5%8E%8B%E7%BC%A9%E7%9A%84%E4%BC%98%E7%82%B9)
        - [参数说明](#%E5%8F%82%E6%95%B0%E8%AF%B4%E6%98%8E)
    - [**Nginx expires缓存实现性能优化**](#nginx-expires%E7%BC%93%E5%AD%98%E5%AE%9E%E7%8E%B0%E6%80%A7%E8%83%BD%E4%BC%98%E5%8C%96)
        - [Nginx expires 功能介绍](#nginx-expires-%E5%8A%9F%E8%83%BD%E4%BB%8B%E7%BB%8D)
        - [Nginx expires作用介绍](#nginx-expires%E4%BD%9C%E7%94%A8%E4%BB%8B%E7%BB%8D)
        - [Nginx expires 功能优点](#nginx-expires-%E5%8A%9F%E8%83%BD%E4%BC%98%E7%82%B9)
        - [Nginx expires功能缺点及解决方法](#nginx-expires%E5%8A%9F%E8%83%BD%E7%BC%BA%E7%82%B9%E5%8F%8A%E8%A7%A3%E5%86%B3%E6%96%B9%E6%B3%95)
        - [企业网站缓存日期曾经的案例参考](#%E4%BC%81%E4%B8%9A%E7%BD%91%E7%AB%99%E7%BC%93%E5%AD%98%E6%97%A5%E6%9C%9F%E6%9B%BE%E7%BB%8F%E7%9A%84%E6%A1%88%E4%BE%8B%E5%8F%82%E8%80%83)
        - [企业网站有可能不希望被缓存的内容](#%E4%BC%81%E4%B8%9A%E7%BD%91%E7%AB%99%E6%9C%89%E5%8F%AF%E8%83%BD%E4%B8%8D%E5%B8%8C%E6%9C%9B%E8%A2%AB%E7%BC%93%E5%AD%98%E7%9A%84%E5%86%85%E5%AE%B9)
    - [Nginx日志相关优化与安装](#nginx%E6%97%A5%E5%BF%97%E7%9B%B8%E5%85%B3%E4%BC%98%E5%8C%96%E4%B8%8E%E5%AE%89%E8%A3%85)
        - [编写脚本脚本实现Nginx access日志轮询](#%E7%BC%96%E5%86%99%E8%84%9A%E6%9C%AC%E8%84%9A%E6%9C%AC%E5%AE%9E%E7%8E%B0nginx-access%E6%97%A5%E5%BF%97%E8%BD%AE%E8%AF%A2)
        - [不记录不需要的访问日志](#%E4%B8%8D%E8%AE%B0%E5%BD%95%E4%B8%8D%E9%9C%80%E8%A6%81%E7%9A%84%E8%AE%BF%E9%97%AE%E6%97%A5%E5%BF%97)
        - [访问日志的权限设置](#%E8%AE%BF%E9%97%AE%E6%97%A5%E5%BF%97%E7%9A%84%E6%9D%83%E9%99%90%E8%AE%BE%E7%BD%AE)
    - [Nginx站点目录及文件URL访问控制](#nginx%E7%AB%99%E7%82%B9%E7%9B%AE%E5%BD%95%E5%8F%8A%E6%96%87%E4%BB%B6url%E8%AE%BF%E9%97%AE%E6%8E%A7%E5%88%B6)
    - [配置Nginx禁止非法域名解析访问企业网站](#%E9%85%8D%E7%BD%AEnginx%E7%A6%81%E6%AD%A2%E9%9D%9E%E6%B3%95%E5%9F%9F%E5%90%8D%E8%A7%A3%E6%9E%90%E8%AE%BF%E9%97%AE%E4%BC%81%E4%B8%9A%E7%BD%91%E7%AB%99)
    - [优雅显示错误页面](#%E4%BC%98%E9%9B%85%E6%98%BE%E7%A4%BA%E9%94%99%E8%AF%AF%E9%A1%B5%E9%9D%A2)
    - [Nginx图片及目录防盗链解决方案](#nginx%E5%9B%BE%E7%89%87%E5%8F%8A%E7%9B%AE%E5%BD%95%E9%98%B2%E7%9B%97%E9%93%BE%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88)
        - [常见防盗链解决方案的基本原理](#%E5%B8%B8%E8%A7%81%E9%98%B2%E7%9B%97%E9%93%BE%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88%E7%9A%84%E5%9F%BA%E6%9C%AC%E5%8E%9F%E7%90%86)
    - [Nginx站点目录文件及目录权限优化](#nginx%E7%AB%99%E7%82%B9%E7%9B%AE%E5%BD%95%E6%96%87%E4%BB%B6%E5%8F%8A%E7%9B%AE%E5%BD%95%E6%9D%83%E9%99%90%E4%BC%98%E5%8C%96)
    - [**Nginx防爬虫**](#nginx%E9%98%B2%E7%88%AC%E8%99%AB)
        - [Nginx防爬虫优化](#nginx%E9%98%B2%E7%88%AC%E8%99%AB%E4%BC%98%E5%8C%96)
    - [利用Nginx限制HTTP请求的方法](#%E5%88%A9%E7%94%A8nginx%E9%99%90%E5%88%B6http%E8%AF%B7%E6%B1%82%E7%9A%84%E6%96%B9%E6%B3%95)
    - [使用CDN做网站内容加速](#%E4%BD%BF%E7%94%A8cdn%E5%81%9A%E7%BD%91%E7%AB%99%E5%86%85%E5%AE%B9%E5%8A%A0%E9%80%9F)
    - [Nginx程序架构优化](#nginx%E7%A8%8B%E5%BA%8F%E6%9E%B6%E6%9E%84%E4%BC%98%E5%8C%96)
    - [控制Nginx并发连接数](#%E6%8E%A7%E5%88%B6nginx%E5%B9%B6%E5%8F%91%E8%BF%9E%E6%8E%A5%E6%95%B0)
    - [控制客户端请求Nginx的速率](#%E6%8E%A7%E5%88%B6%E5%AE%A2%E6%88%B7%E7%AB%AF%E8%AF%B7%E6%B1%82nginx%E7%9A%84%E9%80%9F%E7%8E%87)
    - [配置普通用户启动nginx](#%E9%85%8D%E7%BD%AE%E6%99%AE%E9%80%9A%E7%94%A8%E6%88%B7%E5%90%AF%E5%8A%A8nginx)
    - [完整配置](#%E5%AE%8C%E6%95%B4%E9%85%8D%E7%BD%AE)

<!-- /TOC -->


## 隐藏Nginx版本号

> 通过配置文件更改

```sh
http{
    server_tokens off;
}
```

> 通过修改源码，编译修改（可修改应用名）

```sh
下载源码
    [root@web01 src]# wget http://nginx.org/download/nginx-1.10.2.tar.gz

    [root@web01 src]# tar xf nginx-1.10.2.tar.gz 
    [root@web01 src]# cd nginx-1.10.2/src/core/

vim nginx.h
    13 #define NGINX_VERSION      "5.1.7"                 ## 修改为想要的版本号
    14 #define NGINX_VER          "yjj/" NGINX_VERSION    ## 将nginx修改想要修改的软件名称
    22 #define NGINX_VAR          "yjj"                   ## 将NGINX修改为想要修改的软件名称。
    23 #define NGX_OLDPID_EXT     ".oldbin"

------
    [root@web01 core]# pwd
    /root/src/nginx-1.10.2/src/core
    [root@web01 core]# cd ..
    [root@web01 src]# ls
    core  event  http  mail  misc  os  stream
    [root@web01 src]# vim http/ngx_http_header_filter_module.c 
    >> 49 static char ngx_http_server_string[] = "Server: yjj" CRLF;
    此处为curl显示出来的名称

# 关闭server_tokens off;  可以显示我们设置的如下显示信息
    [root@web01 src]# vim http/ngx_http_special_response.c   ## 对外页面报错时，它会控制是否展示敏感信息。修改28~30行
    21  static u_char ngx_http_error_full_tail[] =
    22 "<hr><center>" NGINX_VER "</center>" CRLF     ## 设置server_tokens on;显示的内容就是 NGINX_VER
    23 "</body>" CRLF
    24 "</html>" CRLF
    25 ;


    28  static u_char ngx_http_error_tail[] =
    29 "<hr><center>yjj</center>" CRLF
    30 "</body>" CRLF          
    31 "</html>" CRLF          
------

编译安装，编译参数请根据实际情况
    [root@web01 nginx-1.10.2]# ./configure --prefix=/application/nginx-1.10.2/ --user=www --group=www
    [root@web01 nginx-1.10.2]# make 
    [root@web01 nginx-1.10.2]# make install
    [root@web01 ~]# /application/nginx-1.10.2/sbin/nginx 

验证
    [root@web01 ~]# curl -I 127.0.0.1
    HTTP/1.1 200 OK
    Server: yjj/5.1.7
    Date: Tue, 20 Dec 2016 08:35:27 GMT
    Content-Type: text/html
    Content-Length: 612
    Last-Modified: Tue, 20 Dec 2016 08:33:40 GMT
    Connection: keep-alive
    ETag: "5858ece4-264"
    Accept-Ranges: bytes

```
![nginx1-20161220](http://oi480zo5x.bkt.clouddn.com/Linux_project/nginx1-20161220.jpg)

[Back to TOC](#table-of-contents)

## 更改Nginx服务用户

    通过配置文件配置
    在编译的时候指定
    此方式修改nginx worker进程用户，master用户需要使用如下方法

## 更改Nginx master用户，服务降权



## 调整worker进程数

```sh
在高并发、访问量的Web服务场景，需要事先启动好更多的nginx进程，以保证快速响应并处理大量并发用户的请求.
优化Nginx进程对应nginx服务的配置参数如下：

worker_processes  1;   ## 调整worker进程数，根据CPU核数设置

[root@db02 ~]# grep "processor" /proc/cpuinfo |wc -l
1
[root@db02 ~]# grep -c "processor" /proc/cpuinfo
1
可以使用top命令，按 1 查看
## 查看CPU总颗数
[root@db02 ~]# grep "physical id" /proc/cpuinfo |sort|uniq|wc -l
1
```

[Back to TOC](#table-of-contents)

## 绑定不同的Nginx进程到不同的核心上

> 默认情况Nginx的多个进程有可能跑在某一个或某一核的CPU上，导致Nginx进程使用硬件的资源不均。
可以分配不同的Nginx进程给不同的CPU处理，达到充分有效利用硬件的多CPU多核资源的目的。

```sh
worker_processes  1;
worker_cpu_affinity 0001 0010 0100 1000;
#worker_cpu_affinity就是配置nginx进程CPU亲和力的参数，即把不同的进程分给不同的CPU处理。
这里0001 0010 0100 1000是掩码，分别代表1、2、3、4核cpu核心，由于worker_processes进程数为4，因此上述配置会把每个进程分配一核CPU处理，默认情况下进程不会绑定任何CPU，参数位置为main段
```

```sh
    taskset -c  可以指定不同进程的核心
```

[Back to TOC](#table-of-contents)

## 调整Nginx模型为epoll，默认就是

```txt
Nginx的连接处理机制在于不同的操作系统会采用不同的I/O模型，在Linux下，Nginx使用epoll的I/O多路复用模型，在Freebsd中使用kqueue的I/O多路复用模型，在Solaris中使用/dev/poll方式的I/O多路复用模型，在Windows使用的是icop，等待。
要根据系统类型选择不同的事件处理模型，可供使用的选择的有“use [kqueue|rtsig|epoll|/dev/poll|select|pokk]”。
```

[Back to TOC](#table-of-contents)

## 调整worker单个进程的最大连接数，默认1024，不宜过大，也不宜过小

```sh
worker_connections  1024;
```
[Back to TOC](#table-of-contents)

## 配置Nginx Worker进程最大打开文件数

```sh
Nginx worker进程的最大打开文件数，这个控制连接数的参数为worker_rlimit_nofile。

worker_rlimit_nofile 65535
#最大打开文件数，可设置为系统优化有的ulimit-HSn的结果。
```
[Back to TOC](#table-of-contents)

## 开启高效传输

```sh
sendfile参数用于开启文件的高效传输模式，同时将tcp_nopush和tcp_nodelay两个指定设为on，可防止网络及磁盘I/O阻塞，提升Nginx工作效率。
syntax：    sendfile on|off  #参数语法
default：    sendfile off    #参数默认大小
context：    http，server，location，if in location #可放置的标签段

参数作用：激活或者禁用sendfile()功能。sendfile()是作用于两个文件描述符之间的数据拷贝函数，这个拷贝操作是在内核之中，被称为“零拷贝”，sendfile()和read和write函数要高效很多，因为read和wrtie函数要把数据拷贝到应用层再进行操作。相关控制参数还有sendfile_max_chunk。

http://nginx.org/en/docs/http/ngx_http_core_module.html#sendfile

2.设置参数：tcp_nopush on；

Syntax:  tcp_nopush on | off;  #参数语法
Default:   tcp_nopush off;      #参数默认大小
Context:    http, server, location  #可以放置标签段

参数作用：激活或禁用Linux上的TCP_CORK socker选项，此选项仅仅开启sendfile时才生效，激活这个tcp_nopush参数可以运行把http response header和文件的开始放在一个文件里发布，减少网络报文段的数量。

http://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nodelay


3.设置参数：tcp_nodelay on；

用于激活tcp_nodelay功能，提高I/O性能

Syntax:     tcp_nodelay on | off;
Default:    tcp_nodelay on;
Context:    http, server, location


参数作用：默认情况下数据发送时，内核并不会马上发送，可能会等待更多的字节组成一个数据包，这样可以提高I/O性能，但是，在每次只发送很少字节的业务场景，使用tcp_nodelay功能，等待时间会比较长。

参数生产条件：激活或禁用tcp_nodelay选项，当一个连接进入到keep-alive状态时生效
```

[Back to TOC](#table-of-contents)

## 优化Nginx连接参数调整连接超时时间

```sh
1、什么是连接超时？

    这里的服务员相当于Nginx服务建立的连接，当服务器建立的连接没有接收到处理请求时，可在指定的事件内就让它超时自动退出。还有当Nginx和fastcgi服务建立连接请求PHP时，如果因为一些原因（负载高、停止响应）fastcgi服务无法给Nginx返回数据，此时可以通过配置Nginx服务参数使其不会四等。例如：可设置如果Fastcgi 10秒内不能返回数据，那么Nginx就终端本次请求。

2、连接超时的作用

    1）设置将无用的连接尽快超时，可以保护服务器的系统资源（CPU、内存、磁盘）

    2）当连接很多时，及时断掉那些已经建立好的但又长时间不做事的连接，以减少其占用的服务器资源，因为服务器维护连接也是消耗资源的。

    3）有时黑客或而恶意用户攻击网站，就会不断和服务器建立多个连接，消耗连接数，但是什么也不操作。只是持续建立连接，这就会大量的消耗服务器的资源，此时就应该及时断掉这些恶意占用资源的连接。

    4）LNMP环境中，如果用户请求了动态服务，则Nginx就会建立连接请求fastcgi服务以及MySQL服务，此时这个Nginx连接就要设定一个超时时间，在用户容忍的时间内返回数据，或者再多等一会后端服务返回数据，具体策略要看业务。


3.连接超时带来的问题以及不同程序连接设定知识

    服务器建立新连接也是要消耗资源的，因此，超时设置的太短而并发很大，就会导致服务器瞬间无法响应用户的请求，导致体验下降。

    企业生产有些PHP程序站点就会系统设置短连接，因为PHP程序建立连接消耗的资源和时间相对要少些。而对于java程序站点一般建议设置长连接，因为java程序建立消耗的资源和时间更多。


4.Nginx连接超时的参数设置

    （1）设置参数：keeplived_timeout 60;

    用于设置客户端连接保持会话的超时时间为60秒。超过这个时间，服务器会关闭该连接，此数值为参考值。

    Syntax:   keepalive_timeout timeout [header_timeout]; #参数语法
    Default:  keepalive_timeout 75s;  #参数默认大小
    Context:    http, server, location   #可以放置的标签段


    参数作用：keep-alive可以使客户端到服务端已经建立的连接一直工作不退出，当服务器有持续请求时，keep-alive会使用正在建立的连接提供服务，从而避免服务器重新建立新连接处理请求。


    （2）设置参数：client_header_timeout 15；

    用于设置读取客户端请求头数据的超时时间，此处的数值15单位是秒。


    Syntax:   client_header_timeout time;

    Default:  client_header_timeout 60s;

    Context:     http, server

    参数作用：设置读取客户端请求头数据的超时时间。如果超过这个时间，客户端还没有发送完整的header数据，服务端将数据返回“Request time out （408）”错误。


    （3）设置参数：client_body_timeout 15；


    用于设置读取客户端请求主体的超时时间，默认值是60
    Syntax:   client_body_timeout time;
    Default:  client_body_timeout 60s;
    Context:   http, server, location


    参数作用：设置读取客户端请求主体的超时时间。这个超时仅仅为两次成功的读取操作之间的一个超时，非请求整个主体数据的超时时间，如果在这个超时时间内，客户端没有发送任何数据，Nginx将返回“Request time out（408）”错误，默认值是60.

    http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_timeout


    （4）设置参数：send_timeout 25；

    用户指定响应客户端的超时时间。这个超时时间仅限于两个链接活动之间的事件，如果超过这个时间，客户端没有任何活动，Nginx将会关闭连接，默认值为60s，可以改为参考值25s

    Syntax:   send_timeout time;
    Default:     send_timeout 60s;
    Context:  http, server, location

    参数作用：设置服务器端传送http响应信息到客户端的超时时间，这个超时时间仅仅为两次成功握手后的一个超时，非请求整个响应数据的超时时间，如在这个超时时间内，客户端没有收到任何数据，连接将被关闭。

http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_timeout

操作步骤

一般放在http标签即可
    http {
        sendfile        on;
        tcp_nopush on;
        tcp_nodelay on;
        server_tokens off;
        server_names_hash_bucket_size 128;
        server_names_hash_max_size 512;
        keepalive_timeout  65;
        client_header_timeout 15s;
        client_body_timeout 15s;
        send_timeout 60s;
    }

配置参数介绍如下：

keeplived_timeout 60;

###设置客户端连接保持会话的超时时间，超过这个时间，服务器会关闭该连接。

tcp_nodelay on;
####打开tcp_nodelay，在包含了keepalive参数才有效
client_header_timeout 15;
####设置客户端请求头读取超时时间，如果超过这个时间，客户端还没有发送任何数据，Nginx将返回“Request time out（408）”错误
client_body_timeout 15;
####设置客户端请求主体读取超时时间，如果超过这个时间，客户端还没有发送任何数据，Nginx将返回“Request time out（408）”错误
send_timeout 15;
####指定响应客户端的超时时间。这个超过仅限于两个连接活动之间的时间，如果超过这个时间，客户端没有任何活动，Nginx将会关闭连接。

优化服务器域名的bash表大小

哈希表和监听端口关联，每个端口都是最多关联到三张表：确切名字的哈希表，以星号起始的通配符名字的哈希表和以星号结束的统配符名字的哈希表。哈希表的尺寸在配置阶段进行了优化，可以以最小的CPU缓存命中率失败来找到名字。Nginx首先会搜索确切名字的哈希表，如果没有找到，则搜索以星号起始的通配符名称的哈希表，如果还是没有找到，继续搜索以星号结束的通配符名字的哈希表。

注意.nginx.org存储在通配符名字的哈希表中，而不在明确名字的哈希表中，由于正则表达式是一个个串行测试的，因此该方式也是最慢的，并且不可扩展。

举个例子，如果Nginx.org和www.nginx.org来访问服务器最频繁，那么明确的定义出来更为有效

    server {
        listen       80;
        server_name  nginx.org  www.nginx.org *.nginx.org
        location / {
            root   html/www;
            index  index.php index.html index.htm;
        }

server_names_hash_bucket_size size的值，具体信息如下

server_names_hash_bucket_size size 512；

#默认是512KB 一般要看系统给出确切的值。这里一般是cpu L1的4-5倍

官方说明：

Syntax:     server_names_hash_bucket_size size;
Default:    server_names_hash_bucket_size 32|64|128;
Context:   http

参数作用：设置存放域名（server names）的最大哈希表大小。
```

[Back to TOC](#table-of-contents)

## 上传文件大小限制

```txt
上传文件大小（http Request body size）的限制（动态应用）

设置上传文件大小需要在nginx的主配置文件加入如下参数

client_max_body_size 8m;

具体大小根据公司的业务调整，如果不清楚设置为8m即可

Syntax:    client_max_body_size size;
Default:     client_max_body_size 1m;  #默认值是1m
Context:     http, server, location

参数作用：设置最大的允许客户端请求主体大小，在请求头域有“Content-Length”，如果超过了此配置值，客户端会收到413错误，意思是请求的条目过大，有可能浏览器不能正确的显示这个错误，设置为0表示禁止检查客户端请求主体大小，此参数对服务端的安全有一定的作用。

[ngx_http_core_module](http://nginx.org/en/docs/http/ngx_http_core_module.html)
```

调整超时时间
    FastCGI跟PHP的连接
    Nginx跟客户端的连接
    java使用长链接，java进程时间需要稍长一点

[Back to TOC](#table-of-contents)

## FastCGI参数调整

fastcgi参数是配合nginx向后请求PHP动态引擎服务的相关参数

![FastCGI-20161221](http://oi480zo5x.bkt.clouddn.com/Linux_project/FastCGI-20161221.jpg)

 Nginx Fastcgi常见参数 | 列表说明
---------|----------
 fastcgi_connect_timeout | 表示nginx服务器和后端FastCGI服务器连接的超时时间，默认值为60s，这个参数通常不要超过75s，因为建立的连接越多消耗的资源就越多
 fastcgi_send_timeout | 设置nginx允许FastCGI服务返回数据的超时时间，即在规定时间之内后端服务器必须传完所有的数据，否则，nginx将断开这个连接，默认值为60s
 fastcgi_read_timeout | 设置Nginx从FastCGI服务端读取响应信息的超时时间。表示建立连接成功后，nginx等待后端服务器的响应时间，是nginx已经进入后端的排队之中等候处理的时间
 fastcgi_buffer_size | 这是nginx fastcgi的缓冲区大小参数，设定用来读取FastCGI服务端收到的第一部分响应信息的缓冲区大小，这里的第一部分通常会包含一个小的响应头部，默认情况，这个参数大小是由fastcgi_buffers指定的一个缓冲区的大小
 fastcgi_buffers | 设定用来读取从FastCGI服务端收到的响应信息的缓冲区大小以及缓冲区数量。默认值`fastcgi_buffers 8 4|8k`；指定本地需要用多少和多大的缓冲区来缓冲FastCGI的应答请求。如果一个PHP脚本所产生的页面大小为256lb，那么会为其分配4个64kb的缓存区用来缓存。如果站点大部分脚本所产生的页面大小为256kb，那么可以把这个值设置为“16 16k”、“464k”等
 fastcgi_busy_buffers_size | 用于设置系统很忙时可以使用`fastcgi_buffers`大小，官方推荐的大小为`fastcgi_buffers*2` 默认`fastcgi_busy_buffers_size 8k|16k `
 fastcgi_temp_file_write_size | fastcgi临时文件的大小，可设置128-256k
 fastcgi_cache yjj_nginx | 表示开启FastCGI缓存并为其指定一个名称。开启缓存非常有用，可以有效降低CPU的负载，并且防止502错误的发送，但是开启缓存也会引起其他问题，要根据具体情况选择。
 fastcgi_cache_path | fastcgi_cache缓存目录，可以设置目录哈希层级。比如2:2会生成256*256个子目录，keys_zene是这个缓存空间的名字，cache是用多少内存(这样热门的内容nginx直接放入内存，提高访问速度)，inactive表示默认失效时间，max_size表示最多用多少硬盘空间，需要注意的是fastcgi_cache缓存是先卸载fastcgi_temp_path再移到fastcgi_cache_path。所以这两个目录最好在同一个分区
 fastcgi_cache_vaild | 示例：`fastcgi_cache_valid 2000 302 1h;` <br>用来指定应答代码的缓存时间，实例中的值将200和302应答缓存一个小时.<br>示例：`fastcgi_cache_valid 301 1d;` <br>将304应该缓存1天。还可以设置缓存1分钟（1m）
 fastcgi_cache_min_user | 示例：`fastcgi_cache_min_user 1;` <br>设置请求几次之后响应将被缓存。
 fastcgi_cache_user_stale | 示例：`fastcgi_cache_use_stale error timeout invaild_header http_500;` <br>定义哪些情况下用过期缓存
 fastcgi_cache_key | 示例：fastcgi_cache_key <br> $request_method://$host$request_uri; <br> fastcgi_cache_key http://$host$request_uri; <br><br>定义fastcgi_cache的key，示例中就以请求的URI作为缓存的key，nginx会取这个key的md5作为缓存文件，如果设置了缓存哈希目录，Nginx会从后往前取响应的位置作为目录。注意一定要加上$request_method作为cache key，否则如果HEAD类型的先请求会导致后面的GET请求返回为空

[fastcgi cache资料](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache)

> PHP 优化设置

```sh
在http标签设置

fastcgi_connect_timeout 240;
fastcgi_send_timeout 240;
fastcgi_read_timeout 240;
fastcgi_buffer_size 64k;
fastcgi_buffers 4 64k;
fastcgi_busy_buffers_size 128k;
fastcgi_temp_file_write_size 128k;
#fastcgi_temp_path /data/ngx_fcgi_tmp;  需要有路径
fastcgi_cache_path /data/ngx_fcgi_cache levels=2:2 keys_zone=ngx_fcgi_cache:512m inactive=1d max_size=40g;
```

> PHP缓存 可以配置在server标签和http标签

```txt
fastcgi_cache ngx_fcgi_cache;
fastcgi_cache_valid 200 302 1h;
fastcgi_cache_valid 301 1d;
fastcgi_cache_valid any 1m;
fastcgi_cache_min_uses 1;
fastcgi_cache_use_stale error timeout invalid_header http_500;
fastcgi_cache_key http://$host$request_uri;
```

[Module ngx_http_fastcgi_module](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_buffer_siz)

[Module ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)

[Back to TOC](#table-of-contents)

## **Nginx gzip压缩**

> Nginx gzip压缩模块提供了压缩文件内容的功能，用户请求的内容在发送之前，Nginx服务器会根据一些具体的策略实施压缩，以节约网站出口带宽，同时加快了数据传输效率，提升了用户访问体验。

### Nginx gzip压缩的优点

```
1. 提升网站用户体验：由于发给用户的内容小了，所以用户访问单位大小的页面就快了，用户体验提升了，网站口碑就好了。
2. 节约网站带宽成本，由于数据是压缩传输的，因此，此举节省了网站的带宽流量成本，不过压缩会稍微消耗一些CPU资源，这个一般可以忽略。此功能既能让用户体验增强，公司也少花钱。对于几乎所有的Web服务来说，这是一个非常重要的功能，Apache服务也由此功能。
3. 需要和不需要压缩的对象
    1. 纯文本内容压缩比很高，因此纯文本内容是最好压缩，例如：html、js、css、xml、shtml等格式的文件
    2. 被压缩的纯文本文件必须要大于1KB，由于压缩算法的特殊原因，极小的文件压缩可能反而变大。
    3. 图片、视频（流媒体）等文件尽量不要压缩，因为这些文件大多数都是经历压缩的，如果再压缩很坑不会减小或减少很少，或者可能增加。而在压缩时还会消耗大量的CPU、内存资源
    4. 参数介绍及配置说明

    此压缩功能很类似早起的Apache服务的mod_defalate压缩功能，Nginx的gzip压缩功能依赖于ngx_http_gzip_module模块，默认已安装。
```

[Back to TOC](#table-of-contents)

### 参数说明

```sh
gzip on; #开启gzip压缩功能

gzip_min_length 1k;
#设置允许压缩的页面最小字节数，页面字节数从header头的Content-Length中获取，默认值是0，表示不管页面多大都进行压缩，建议设置成大于1K，如果小于1K可能会越压越大

gzip_buffers 4 16k;
#压缩缓冲区大小，表示申请4个单位为16K的内存作为压缩结果流缓存，默认是申请与原始是数据大小相同的内存空间来存储gzip压缩结果；

gzip_http_version 1.1
#压缩版本（默认1.1 前端为squid2.5时使用1.0）用于设置识别HTTP协议版本，默认是1.1，目前大部分浏览器已经支持GZIP压缩，使用默认即可。

gzip_comp_level 2;
#压缩比率，用来指定GZIP压缩比，1压缩比最小，处理速度最快；9压缩比最大，传输速度快，但处理最慢，也消耗CPU资源

gzip_types  text/css text/xml application/javascript; 
#用来指定压缩的类型，“text/html”类型总是会被压缩，这个就是HTTP原理部分讲的媒体类型。

gzip_vary on;
#vary hear支持，该选项可以让前端的缓存服务器缓存经过GZIP压缩的页面，例如用缓存经过Nginx压缩的数据。

配置在http标签端

http{
    gzip on;
    gzip_min_length  1k;
    gzip_buffers     4 32k;
    gzip_http_version 1.1;
    gzip_comp_level 9;
    gzip_types  text/css text/xml application/javascript; 
    gzip_vary on;
}
```

[Back to TOC](#table-of-contents)

## **Nginx expires缓存实现性能优化**

### Nginx expires 功能介绍

```
简单地说，Nginx expires的功能就是为用户访问的网站内容设定一个国企时间，当用户第一次访问到这些内容时，会把这样内容存储在用户浏览器本地，这样用户第二次及此后继续访问网站，浏览器会检查加载缓存在用户浏览器本地的内容，就不会去服务器下载了。直到缓存的内容过期或被清除为止。
深入理解，expires的功能就是允许通过Nginx 配置文件控制HTTP的“Expires”和“Cache-Contorl”响应头部内容，告诉客户端刘琦是否缓存和缓存多久以内访问的内容。这个expires模块控制Nginx 服务器应答时Expires头内容和Cache-Control头的max-age指定。
这些HTTP头向客户端表名了内容的有效性和持久性。如果客户端本地有内容缓存，则内容就可以从缓存（除非已经过期）而不是从服务器读取，然后客户端会检查缓存中的副本。
```

[Back to TOC](#table-of-contents)

### Nginx expires作用介绍
    在网站的开发和运营中，对于图片、视频、css、js等网站元素的更改机会较少，特别是图片，这时可以将图片设置在客户端浏览器本地缓存365天或3650天，而降css、js、html等代码缓存10~30天，这样用户第一次打开页面后，会在本地的浏览器按照过期日期缓存响应的内容，下次用户再打开类似页面，重复的元素就无需下载了，从而加快了用户访问速度，由于用户的访问请求和数据减少了，因此节省了服务器端大量的带宽。此功能和apache的expire相似。

[Back to TOC](#table-of-contents)

### Nginx expires 功能优点

```sh
1. Expires可以降低网站的带宽，节约成本。
2. 加快用户访问网站的速度，提升了用户访问体验。
3. 服务器访问量降低了，服务器压力就减轻了，服务器成本也会降低，甚至可以解决人力成本。
    对于几乎所有Web来说，这是非常重要的功能之一，Apache服务也由此功能。
4. Nginx expires 配置详解
    1. 根据文件扩展名进行判断，添加expires功能范例。
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires      3650d;
    }
    该范例的意思是当前用户访问网站URL结尾的文件扩展名为上述指定的各种类型的图片时，设置缓存3650天，即10年。

    2. 根据URI中的路径（目录）进行判断，添加expires功能范例。
    ## Add expires header according to URI(path or dir).
    location ~ ^/(images|javascript|js|css|flash|media|static)/ {
        expires 360d;
    }
    意思是当用户访问URI中包含上述路径（例：images、js、css，这些在服务端是程序目录）时，把访问的内容设置缓存360天，即1年。如果要想缓存30天，设置30d即可。


    location ~ .*\.(js|css)?$
    {
        expires      30d;
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires      10y;
        root   html/www; 
    }

```

[Back to TOC](#table-of-contents)

### Nginx expires功能缺点及解决方法

```sh
当网站被缓存的页面或数据更新了，此时用户看到的可能还是旧的已经缓存的内容，这样会影响用户体验。
对经常需要变动的图片等文件，可以缩短对象缓存时间，例如：谷歌和百度的首页图片经常根据不同的日期换成一些节日的图，所以这里可以将图片设置为缓存期为1天。
当网站改版或更新内容时，可以在服务器将缓存的对象改名（网站代码程序）。
    1. 对于网站的图片、软件，一般不会被用户直接修改，用户层面上的修改图片，实际上是重新传到服务器，虽然内容一样但是是一个新的图片名了
    2. 网站改版升级会修改JS、CSS元素，若改版的时候对这些元素该了名，会使得前端的CDN以及用户需要重新缓存内容。
```

[Back to TOC](#table-of-contents)

### 企业网站缓存日期曾经的案例参考

```txt
    若企业的业务和访问量不同，那么网站的缓存期时间设置也是不同的，比如：
    - 51CTP：1周
    - sina：15天
    - 京东：25年
    - 淘宝：10年
```

[Back to TOC](#table-of-contents)

### 企业网站有可能不希望被缓存的内容

1. 广告图片，用于广告服务，都缓存了就不好控制展示了。
2. 网站流量统计工具（js代码）都缓存了流量统计就不准了
3. 更新很频繁的文件（google的logo），如果按天，缓存效果还是显著的。

[Back to TOC](#table-of-contents)

## Nginx日志相关优化与安装

[Back to TOC](#table-of-contents)

### 编写脚本脚本实现Nginx access日志轮询

> Nginx目前没有类似Apache的通过cronlog或者rotatelog对日志分割处理的能力，但是，运维人员可以通过利用脚本开发、Nginx的信号控制功能或reload重新加载，来实现日志自动切割，轮询。

```sh
[root@web02 /]# mkdir /server/scripts/ -p
[root@web02 /]# cd /server/scripts/
[root@web02 scripts]# cat cut_nginx_log.sh
cd /application/nginx/logs && \
/bin/mv www_access.log www_access_$(data +%F -d -1dy).log  #将日志按日志改成前一天的名称
/application/nginx/sbin/nginx -s reload         #重新加载nginx使得重新生成访问日志文件

提示：实际上脚本的功能很简单，就是改名日志，然后加载nginx，重新生成文件记录日志。

将这段脚本保存后加入到定时任务，设置每天凌晨0点进行切割日志
[root@web02 scripts]# crontab -e
### cut nginx access log
00 00 * * * /bin/sh /server/scripts/cut_nginx.log.sh >/dev/null 2>&1
解释：每天0点执行cut_nginx_log.sh脚本，将脚本的输出重定向到空。
```

[Back to TOC](#table-of-contents)

### 不记录不需要的访问日志

> 对于负载均衡器健康检查节点或某些特定文件(比如图片、js、css)的日志，一般不需要记录下来，因为在统计PV时是按照页面计算的。

> 日志写入频繁会大量消耗磁盘I/O，降低服务的性能。

```sh
location ~ .*\.(js|jpg|JPG|jpeg|JPEG|css|bmp|gif|GIF)$ {
    access_log off;
}
这里用location标签匹配不记录日志的元素扩展名，然后关掉了日志。
```

### 访问日志的权限设置

> 加入日志目录为/app/logs，则授权方法为

```sh
chown -R root.root /app/logs/
chmod -R 700 /app/logs
```

[Back to TOC](#table-of-contents)

## Nginx站点目录及文件URL访问控制

根据扩展名限制程序和文件访问
Web2.0时代，绝大多数网站都是以用户为中心，例如：BBS、blog、sns产品，这几个产品共同特点就是不但允许用户发布内容到服务器，还允许用户发图片甚至附件到服务器，由于为用户打开了上传的功能，因为给服务器带来了很大的安全风险。
下面将利用Nginx配置禁止访问上传资源目录下的PHP、shell、perl、Python程序文件，这样用户即使上传了木马文件也没法去执行，从而加强了网站的安全。
配置Nginx，限制禁止解析指定目录下的制定程序。

```sh
范例1：配置Nginx，禁止解析指定目录下的指定程序。
    location ~ ^/images/.*\.(php|php5|sh|pl|py)$ 
        {
            deny all;
        } 
    location ~ ^/static/.*\.(php|php5|sh|pl|py)$ 
	    { 
	        deny all;
	    } 
	location ~* ^/data/(attachment|avatar)/.*\.(php|php5)$ 
	    { 
	        deny all; 
	    }

    location ~ ^/(static|js) {
            deny all;
    }

对目录访问进行设置
    location ~ ^/(static)/ {
            deny all;
    }

    location ~ ^/static {
            deny all;
    }

禁止访问目录并返回指定的http状态码
    location /admin/ { return 404; }
    location /templates/ { return 403; }

限制网站来源IP访问
案例环境：phpmyadmin 数据库的Web客户端，内部开发人员使用
禁止某目录让外界访问，但允许某IP访问该目录，切支持PHP解析
    location ~ ^/docker/ { 
        allow 202.111.12.211; 
        deny all;
    }

主网站：
location /admin/ { return 404; }
server标签 监听内网 站点目录 和上面一样
vpn拨号 访问admin

location / { 
	deny 192.168.1.1; 
	allow 192.168.1.0/24; 
	allow 10.1.1.0/16; 
	deny all; 
}


Nginx做反向代理的时候限制客户端IP
if ( $remote_addr = 10.0.0.7 ) {
    return 403;
    }
if ( $remote_addr = 218.247.17.130 ) {
        set $allow_access_root 'true';
}
```

[Module ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html)

[Nginx变量](http://nginx.org/en/docs/varindex.html)

[Back to TOC](#table-of-contents)

## 配置Nginx禁止非法域名解析访问企业网站

> Nginx如何预防用户IP访问网站（恶意域名解析，相当于是直接IP访问企业网站）

> 让使用IP访问的网站用户，或者而已解析域名的用户，收到501错误

```txt
#Only allow these request methods
     if ($request_method !~ ^(GET|HEAD|POST)$ ) {
         return 501;
     }
#Do not accept DELETE, SEARCH and other methods

目录权限、请求方法、限制指定目录扩展名程序解析、文件系统挂载控制可执行程序及suid。
tcp协议栈优化、iptables防火墙控制
内部管理：跳板机 日志审计、VPN

配置Nginx禁止恶意解析
当server标签没有匹配的内容，服务器返回第一个server标签内容
    server {
        listen 80 default_server;
        server_name _;
        return 501;
    }
```

[Back to TOC](#table-of-contents)

## 优雅显示错误页面

> 在网站的运行过程中，可能由于页面不存在或者系统过载等原因，导致网站无法正常响应用于的请求，此时Web服务默认会返回系统默认的错误码，或者很不友好的页面。影响用户体验

```sh
范例1：对错误代码403实行本地页面跳转。
###www
    server {
        listen       80;
        server_name  www.yjjztt.top;
        location / {
            root   html/www;
            index  index.html index.htm;
        }
        error_page  403  /403.html;  #<==当页面出现403错误时，会跳转到403.html页面显示给用户。
    }
上面的/403.html是相对于站点根目录html/www的

error_page   500 502 503 504  /50x.html;

阿里门户网站天猫的Nginx优雅显示配置案例如下：
error_page 500 501 502 503 504  http://err.tmall.com/error2.html;
error_page 400 403 404 405 408 410 411 412 413 414 415 http://err.tmall.com/error1.html;


if ($http_user_agent ~* "qihoobot|Baiduspider|Googlebot|Googlebot-Mobile|Googlebot-Image|Mediapartners-Google|Adsbot-Google|Yahoo! Slurp China|YoudaoBot|Sosospider|Sogou spider|Sogou web spider|MSNBot") { 
     return 403; 
} 

通过301跳转到主页。
    server {
    listen 80 default_server;
    server_name _;
    rewrite ^(.*) http://www.yjjztt.top/$1 permanent;
    }
    
要放在第一个server

  if ($host !~ ^www/.yjjztt/.top$){
    rewrite ^(.*) http://www.yjjztt.top/$1 permanent;
}

如果header信息和host主机名字字段非http://www.yjjztt.top，就301跳转到http://www.yjjztt.top

```

[Back to TOC](#table-of-contents)

## Nginx图片及目录防盗链解决方案

> 什么是资源盗链

    简单的说，就是某些不发的网站未经许可，通过在其自身网站程序里非法调用其他网站的资源吗，然后在自己的网站上显示。达到补充自身网站的效果，这一举动不但浪费了调用网站的流量，还造成服务器的压力，甚至宕机。

> 网站资源被盗链带来的问题

```
若网站图片及相关资源被盗链，最直接的影响就是网络带宽占用加大了，带宽费用多了，网站流量也可能忽高忽低，nagios/zabbix等报警服务频繁报警。
最严重的情况就是网站的资源被非法使用，导致网站带宽成本加大和服务器压力加大，有可能会导致数万元的损失，且网站的正常用户访问也会受到影响。
```

> 网站资源被盗链严重问题企业真实案例

```
公司的CDN源站的流量没有变动，但是CDN加速那边的流量无故超了好几个GB，不知道怎么如理。
该故障的影响：
    由于是购买的CDN网站加速服务，因此虽然流量多了几个GB，但是业务未受影响。只是，这么大的异常流量，持续下去可直接导致公司无故损失数万元。
解决方案：
    第一，对IDC及CDN带宽做监控报警。
    第二，作为高级运维或者运维经理，每天上班的重要任务，就是经常查看网站流量图，关注流量变化，关注异常流量
    第三，对访问日志做分析，对于异常流量迅速定位，并且和公司市场推广等有比较好的默契沟通
```

[Back to TOC](#table-of-contents)

### 常见防盗链解决方案的基本原理

> 根据http referer 实现防盗链

```
    在HTTP协议中，有一个表头字段叫referer，使用URL格式来表示哪里的链接用了当前网页的资源。通过referer可以检测目标访问的来源网页，如果是资源文件，可以跟踪到显示它的网页地址，一旦检测出来不是本站，马上进行阻止或返回指定的页面。
    HTTP Referer是header的一部分，当浏览器向Web服务器发送请求的时候，一般会带上Referer，告诉服务器我是从哪个页面链接过来的，服务器籍此可以获得一些信息用于处理，Apache、Nginx、Lighttpd三者都支持根据http referer实现防盗链referer是目前网站图片、附件、html最常用的盗链手段。

     log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';
```

> Nginx防盗链演示

```
1.利用referer并且针对扩展名rewrite重定向。

#Preventing hot linking of images and other file types
location ~* ^.+\.(jpg|png|swf|flv|rar|zip)$ {
    valid_referers none blocked *.yjjztt.top yjjztt.top;
    if ($invalid_referer) {
        rewrite ^/ http://bbs.yjjztt.top/img/nolink.gif;
    }
    root html/www;
}

要根据主机公司实际业务（是否有外联的合作），进行域名设置。
针对防盗链中设置进行解释
jpg|png|swf|flv|rar|zip   表示对jpg、gif等zip为后缀的文件实行防盗链处理
 *.yjjztt.top yjjztt.top  表示这个请求可以正常访问上面指定的文件资源
if{}中内容的意思是：如果地址不是上面指定的地址就跳转到通过rewrite指定的地址，也可以直接通过retum返回403错误
return 403为定义的http返回状态码
rewrite ^/ http://bbs.yjjztt.top/img/nolink.gif;表示显示一张防盗链图片
access_log off;表示不记录访问日志，减轻压力
expires 3d指的是所有文件3天的浏览器缓存
```

[Back to TOC](#table-of-contents)

## Nginx站点目录文件及目录权限优化

> 为了保证网站不遭受木马入侵，所有站点的用户和组都应该为root，所有目录权限是755；所有文件权限是644.

```sh
-rw-r--r--  1 root root      20 May 26 12:04 test_info.php
drw-r--r--  8 root root    4096 May 29 16:41 uploads
```

> 可以设置上传只可以put不可以get，或者使用location不允许访问共享服务器的内容，图片服务器禁止访问php|py|sh。这样就算黑客将php木马上传上来也无法进行执行

> 集群架构中不同角色的权限具体思路说明

 **服务器角色** | **权限处理** | **安全系数**
---------|----------|---------
 动态web集群 | 目录权限755，文件权限644，所有目录和文件用户和组都是root。<br>环境nginx+php | 文件不能被改，目录不能被写入
 static图片集群 | 目录权限755，文件权限644，所有目录和文件用户和组都是root。 | 文件不能被改，目录不能被写入
 上传upload集群 | 目录权限755，文件权限644，所有目录和文件用户和组都是root。<br>特别：用户上传的目录设置为755，用户和组使用Nginx服务配置的用户 | 文件不能被修改、目录不能被写入，但是用户上传你的目录允许写入文件，但是需要通过Nginx的其他功能禁止读文件

## **Nginx防爬虫**

> robots.txt机器人协议介绍

> Robots协议（也成为爬虫协议、机器人协议等）的全称是“网络爬虫排除标准”(Robots Exclusin Protocol)网站通过Robots协议告诉引擎那个页面可以抓取，那些页面不能抓取。

> 机器人协议八卦

[jd_robots](https://www.jd.com/robots.txt)

[taobao](https://www.taobao.com/robots.txt)

[Back to TOC](#table-of-contents)

### Nginx防爬虫优化

> 我们可以根据客户端的user-agents信息，轻松地阻止爬虫取我们的网站防爬虫

```sh
范例：阻止下载协议代理
## Block download agents ##
     if ($http_user_agent ~* LWP::Simple|BBBike|wget) {
            return 403;
     }
说明：如果用户匹配了if后面的客户端(例如wget)就返回403

范例：添加内容防止N多爬虫代理访问网站

 if ($http_user_agent ~* "qihoobot|Baiduspider|Googlebot|Googlebot-Mobile|Googlebot-Image|Mediapartners-Google|Adsbot-Google|Yahoo! Slurp China|YoudaoBot|Sosospider|Sogou spider|Sogou web spider|MSNBot") { 
     return 403; 
} 

测试禁止不同的浏览器软件访问

 if ($http_user_agent ~* "Firefox|MSIE") 
{ 
rewrite ^(.*) http://blog.yjjztt.top/$1 permanent;
}

如果浏览器为Firefox或者IE就会跳转到http:blog.yjjztt.top
提示：
这里主要用了$remote_addr这个函数在记录。
查看更多函数

[root@web02 conf]# cat fastcgi_params
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;
fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  HTTPS              $https if_not_empty;
fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;
# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;
```

[Back to TOC](#table-of-contents)

## 利用Nginx限制HTTP请求的方法

> HTTP最常用的方法为GET/POST，我们可以通过Nginx限制http请求的方法来达到提升服务器安全的目的，例如，让HTTP只能使用GET、HEAD和POST方法配置如下：

```
 #Only allow these request methods
     if ($request_method !~ ^(GET|HEAD|POST)$ ) {
         return 501;
     }
#Do not accept DELETE, SEARCH and other methods
```

> 设置对应的用户相关权限，这样一旦程序有漏洞，木马就有可能被上传到服务器挂载的对应存储服务器的目录里，虽然我们也做了禁止PHP、SH、PL、PY等扩展名的解析限制，但是还是会遗漏一些我们想不到的可执行文件。对于这种情况，该怎么办捏？事实上，还可以通过限制上传服务器的web服务（可以具体到文件）使用GET方法，来达到防治用户通过上传服务器访问存储内容，让访问存储渠道只能从静态或图片服务器入口进入。例如，在上传服务器上限制HTTP的GET方法的配置如下：

```
 ## Only allow GET request methods ##
     if ($request_method ~* ^(GET)$ ) {
         return 501;
     }

提示：还可以加一层location更具体的限制文件名
```

[Back to TOC](#table-of-contents)

## 使用CDN做网站内容加速

```
CDN的全称是Content Delivery Network,中文意思是内容分发网络。
通过现有的Internet中增加一层新的网络架构，将网站的内容发布到最接近用户的cache服务器内，通过智能DNS负载均衡技术，判断用户的来源，让用户就近使用和服务器相同线路的带宽访问cache服务器取得所需的内容。
例如：天津网通用户访问天津网通Cache服务器上的内容，北京电信访问北京电信Cache服务器上的内容。这样可以减少数据在网络上传输的事件，提高访问速度。
CDN是一套全国或全球的分布式缓存集群，其实质是通过智能DNS判断用户的来源地域以及上网线路，为用户选择一个最接近用户地狱以及和用户上网线路相同的服务器节点，因为地狱近，切线路相同，所以，可以大幅度提升浏览网站的体验。

CDN的价值
1. 为架设网站的企业省钱。
2. 提升企业网站的用户访问体验（相同线路，相同地域，内存访问）。
3. 可以阻挡大部分流量攻击，例如：DDOS攻击
```

[Back to TOC](#table-of-contents)

## Nginx程序架构优化

```
1.为网站程序解耦
    解耦是开发人员中流行的一个名词，简单地说就是把一堆程序嗲吗按照业务用途分开，然后提供服务，例如：注册登录、上传、下载、订单支付等都应该是独立的程序服务，只不过在客户端看来是一个整体而已。如果中小公司做不到上述细致的解耦，最起码让下面的几个程序模块独立。
    1.网站页面服务
    2.图片附件及下载服务。
    3.上传图片服务
    上述三者的功能尽量分离。分离的最佳方式是分别使用独立的服务器（需要改动程序）如果程序实在不好改，次选方案是在前端负载均衡器haproxy/nginx上，根据URI设置
```

[Back to TOC](#table-of-contents)

## 控制Nginx并发连接数

nginx_http_limit_conn_module这个模块用于限制每个定义的key值的连接数，特别是单IP的连接数。
不是所有的连接数都会被计数。一个符合要求的连接是整个请求头已经被读取的连接。
控制Nginx并发连接数量参数的说明如下：

```sh
limit_conn_zone参数：
语法：limit_conn_zone key zone=name:size;
上下文:http
用于设置共享内存区域，key可以是字符串，nginx自有变量或前两个组合，如$binary_remote_addr、$server_name。name为内存区域的名称，size为内存区域的大小。
limit_conn参数：
语法：limit_conn zone number;
上下文：http、server、location
```

```
1. 限制单IP并发连接数（做了没什么效果，不用做，方法论）
Nginx的配置文件如下：
[root@web01 ~]# cat /application/nginx/conf/nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    limit_conn_zone $binary_remote_addr zone=addr:10m;

    server {
        listen       80;
        server_name   www.yjjztt.top;
        location / {
            root   html;
            index  index.html index.htm;
            limit_conn addr 1; #<==限制单IP的并发连接为1
        }
    }
}

以上功能应用场景之一是可以用于服务器下载：
        location /download/ {
            limit_conn addr 1;
        }
一般不用
```

[Back to TOC](#table-of-contents)

## 控制客户端请求Nginx的速率

ngx_http_limit_req_module模块用于限制每个IP访问定义key的请求速率。
limit_req_zone参数说明如下：
语法：limit_req_zonekey zone=name:size rate=rate;
用于设置共享内存区域，key可以是字符串、Nginx自有变量或前两个组合，如$binary_remote_addr。name为内存区域的名称，size为内存区域的大小，rate为速率，单位为r/s，每秒一个请求。

```
工作中不需要用
[root@web01 ~]# cat /application/nginx/conf/nginx.conf         
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
#<==以请求的客户端IP作为key值，内存区域命名为one，分配10m内存空间，访问速率限制为1秒1次请求(request)
    server {
        listen       80;
        server_name   www.yjjztt.top;
        location / {
            root   html;
            index  index.html index.htm;
            limit_req zone=one burst=5; 
#<==使用前面定义的名为one的内存空间，队列值为5，即可以有5个请求排队等待。
        }
    }
}
```

## 配置普通用户启动nginx

为什么要让Nginx服务使用普通用户
默认情况下，Nginx的Master进程使用的是root用户，Worker进程使用的是Nginx指定的普通用户，使用root用户跑Nginx的Master进程由两个最大的问题：
    - 管理权限必须是root，这就使得最小化分配权限原则遇到难题
    - 使用root跑Nginx服务，一旦网站出现漏洞，用户就很容易获得服务器root权限

给Nginx服务降权解决方案
    - 给Nginx服务降权，用inca用户跑Nginx服务，给开发及运维设置普通账号，只要和inca同组即可管理Nginx，该方案解决了Nginx管理问题，防止root分配权限过大。
    - 开发人员使用普通账户即可管理Nginx服务以及站点下的程序和日志
    - 采取项目负责制，即谁负载项目维护处了问题就是谁负责。

实施

```sh
    1）添加用户并创建相关目录和文件，操作如下：
    [root@www ~]# useradd inca
    [root@www ~]# su - inca
    [inca@www ~]$ pwd
    /home/inca
    [inca@www ~]$ mkdir conf logs www
    [inca@www ~]$ cp /application/nginx/conf/mime.types ~/conf/
    [inca@www ~]$ echo inca >www/index.html
    2）配置Nginx配置文件，配置后的查看命令如下：
    [inca@www ~]$ cat conf/nginx.conf 
    worker_processes  4;
    worker_cpu_affinity 0001 0010 0100 1000;
    worker_rlimit_nofile 65535;
    error_log  /home/inca/logs/error.log;
    user inca inca;
    pid        /home/inca/logs/nginx.pid;
    events {
        use epoll;
        worker_connections  10240;
    }
    http {
        include       mime.types;
        default_type  application/octet-stream;
        sendfile        on;
        keepalive_timeout  65;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for"';


        #web.fei fa daolian..............
        server {
            listen       8080;
            server_name  www.yjjztt.top;
            root   /home/inca/www;
            location / {
                index  index.php index.html index.htm;
                    }
            access_log  /home/inca/logs/web_blog_access.log  main;
            }
    }

```

> 切换用户，启动Nginx

```sh
[root@web02 ~]# su - inca
[inca@web02 ~]$  /application/nginx/sbin/nginx -c /home/inca/conf/nginx.conf &>/dev/null &
```

本解决方案的优点如下：
1. 给Nginx服务降权，让网站更安全
2. 按用户设置站点权限，使站点更安全（无需虚拟化隔离）
3. 开发不需要用root即可完整管理服务及站点
4. 可实现对责任划分，网络问题属于运维的责任，打开不就是开发责任或共同承担

[Back to TOC](#table-of-contents)

## 完整配置

```sh
[root@nginx conf]# cat nginx.conf
worker_processes  4;
worker_cpu_affinity 0001 0010 0100 1000;
worker_rlimit_nofile 65535;
user nginx;
events {
    use epoll;
    worker_connections  2048;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    tcp_nopush on;
    keepalive_timeout  65;
    tcp_nodelay on;
    client_header_timeout 15; 
    client_body_timeout 15; 
    send_timeout 15;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    server_tokens off;
    fastcgi_connect_timeout 240;
    fastcgi_send_timeout 240;
    fastcgi_read_timeout 240;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
    #fastcgi_temp_path /data/ngx_fcgi_tmp;
    fastcgi_cache_path /data/ngx_fcgi_cache levels=2:2 keys_zone=ngx_fcgi_cache:512m inactive=1d max_size=40g;

    #web...............
    server {
        listen       80;
        server_name  blog.yjj.com;
        root   html/blog;
        location / {
            root   html/blog;
            index  index.php index.html index.htm;
                }
        location ~ .*\.(php|php5)?$
        {      
         fastcgi_pass  127.0.0.1:9000;
         fastcgi_index index.php;
         include fastcgi.conf;
         fastcgi_cache ngx_fcgi_cache;
         fastcgi_cache_valid 200 302 1h;
         fastcgi_cache_valid 301 1d;
         fastcgi_cache_valid any 1m;
         fastcgi_cache_min_uses 1;
         fastcgi_cache_use_stale error timeout invalid_header http_500;
         fastcgi_cache_key http://$host$request_uri;
         }
         access_log  logs/web_blog_access.log  main;
         }

upstream blog_yjj{
    server 10.0.0.8:8000 weight=1;
}
    server {
        listen       8000;
        server_name  blog.yjj.com;
        location / {
            proxy_pass http://blog_yjj;
            proxy_set_header Host  $host;
            proxy_set_header X-Forwarded-For  $remote_addr;
              }
         access_log  logs/proxy_blog_access.log  main;
           }
}
```

[Back to TOC](#table-of-contents)
