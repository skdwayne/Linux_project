# Nginx + Lua WAF

## Table of Contents

<!-- TOC -->

- [Nginx + Lua WAF](#nginx--lua-waf)
    - [Table of Contents](#table-of-contents)
    - [参考链接](#%E5%8F%82%E8%80%83%E9%93%BE%E6%8E%A5)
    - [Start](#start)
    - [解压NDK和lua-nginx-module](#%E8%A7%A3%E5%8E%8Bndk%E5%92%8Clua-nginx-module)
    - [安装LuaJIT,Luajit是Lua即时编译器。](#%E5%AE%89%E8%A3%85luajitluajit%E6%98%AFlua%E5%8D%B3%E6%97%B6%E7%BC%96%E8%AF%91%E5%99%A8)
    - [编译安装Nginx](#%E7%BC%96%E8%AF%91%E5%AE%89%E8%A3%85nginx)
    - [测试安装](#%E6%B5%8B%E8%AF%95%E5%AE%89%E8%A3%85)
    - [OpenResty](#openresty)
    - [测试OpenResty](#%E6%B5%8B%E8%AF%95openresty)
    - [WAF](#waf)
    - [问题记录](#%E9%97%AE%E9%A2%98%E8%AE%B0%E5%BD%95)
        - [ld returned 1 exit status](#ld-returned-1-exit-status)

<!-- /TOC -->

## 参考链接

- [luajit](http://luajit.org/)
- [ngx_lua_waf](https://github.com/loveshell/ngx_lua_waf)
- [PCRE - Perl Compatible Regular Expressions](http://www.pcre.org/)
- [PCRE Download](ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/)
- [ngx_devel_kit](https://github.com/simpl/ngx_devel_kit)
- [ngx_devel_kit/releases](https://github.com/simpl/ngx_devel_kit/releases)
- [lua-nginx-module](https://github.com/openresty/lua-nginx-module)
- [lua-nginx-module/releases](https://github.com/openresty/lua-nginx-module/releases)

[Back to TOC](#table-of-contents)

## Start

```sh
[root@centos tools]# pwd
/home/yjj/tools
[root@centos tools]# wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
[root@centos tools]# ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz
## 解压到指定位置，后面编译Nginx时会用到
[root@centos tools]# tar xf pcre-8.39.tar.gz -C /usr/local/src/

[root@centos tools]# wget https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz
[root@centos tools]# wget https://github.com/openresty/lua-nginx-module/archive/v0.10.7.tar.gz
```

[Back to TOC](#table-of-contents)

## 解压NDK和lua-nginx-module

```sh
[root@centos tools]# tar xf v0.10.7.tar.gz 
[root@centos tools]# tar xf v0.3.0.tar.gz
[root@centos tools]# ls
LuaJIT-2.0.4.tar.gz      mysql-5.6.34.tar.gz  ngx_devel_kit-0.3.0  php-7.0.13.tar.gz
lua-nginx-module-0.10.7  nginx-1.10.2         pcre-8.39.tar.gz     v0.10.7.tar.gz
mariadb-10.1.19.tar.gz   nginx-1.10.2.tar.gz  php-5.6.28.tar.gz    v0.3.0.tar.gz
```

[Back to TOC](#table-of-contents)

## 安装LuaJIT,Luajit是Lua即时编译器。

```bash
[root@centos tools]# tar xf LuaJIT-2.0.4.tar.gz
[root@centos tools]# cd LuaJIT-2.0.4
[root@centos LuaJIT-2.0.4]# ls
COPYRIGHT  doc  dynasm  etc  Makefile  README  src
[root@centos LuaJIT-2.0.4]# make && make install

```

[Back to TOC](#table-of-contents)

## 编译安装Nginx

```bash
[root@centos tools]# wget http://nginx.org/download/nginx-1.10.2.tar.gz
[root@centos tools]# tar nginx-1.10.2.tar.gz
[root@centos tools]# cd nginx-1.10.2

[root@centos nginx-1.10.2]# ./configure --prefix=/application/nginx-1.10.2 --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-file-aio --with-http_dav_module --add-module=../ngx_devel_kit-0.3.0/ --add-module=../lua-nginx-module-0.10.7/ --with-pcre=/usr/local/src/pcre-8.39
[root@centos nginx-1.10.2]# make -j2 && make install
[root@centos nginx-1.10.2]# ln -s /usr/local/lib/libluajit-5.1.so.2 /lib64/libluajit-5.1.so.2
如果不创建符号链接，可能出现以下异常： error while loading shared libraries: libluajit-5.1.so.2: cannot open shared object file: No such file or directory

[root@centos nginx-1.10.2]# cd /application/
[root@centos application]# ln -s nginx-1.10.2 nginx
[root@centos application]# ll
total 8
drwxr-xr-x 3 root root 4096 Dec 21 19:31 backup
lrwxrwxrwx 1 root root   12 Dec 21 19:30 nginx -> nginx-1.10.2
drwxr-xr-x 6 root root 4096 Dec 21 19:27 nginx-1.10.2
```

[Back to TOC](#table-of-contents)

## 测试安装

```bash
[root@centos application]# cd /application/nginx/conf/
[root@centos conf]# vim nginx.conf

 42         location /hello {   
 43             default_type 'text/plain';
 44             content_by_lua 'ngx.say("hello,lua")';                                  
 45         }

[root@centos conf]# /application/nginx/sbin/nginx -t
nginx: the configuration file /application/nginx-1.10.2/conf/nginx.conf syntax is ok
nginx: configuration file /application/nginx-1.10.2/conf/nginx.conf test is successful
[root@centos conf]# /application/nginx/sbin/nginx
然后访问http://xxx.xxx.xxx.xxx/hello，如果出现hello,lua。表示安装完成,然后就可以。
```

![hello lua-20161221](http://oi480zo5x.bkt.clouddn.com/Linux_project/hello%20lua-20161221.png)

[Back to TOC](#table-of-contents)

## OpenResty

[OpenResty](https://openresty.org/en/)

```bash
[root@centos ~]# yum install -y readline-devel pcre-devel openssl-devel
[root@centos ~]# cd /home/yjj/tools/
[root@centos tools]# wget https://openresty.org/download/ngx_openresty-1.9.7.2.tar.gz
[root@centos tools]# tar xf ngx_openresty-1.9.7.2.tar.gz 
[root@centos tools]# cd ngx_openresty-1.9.7.2
[root@centos ngx_openresty-1.9.7.2]# ./configure --prefix=/application/ngx_openresty-1.9.7.2 \
--with-luajit --with-http_stub_status_module \
--with-pcre=/usr/local/src/pcre-8.39 --with-pcre-jit
[root@centos ngx_openresty-1.9.7.2]# gmake && gmake install

[root@centos ngx_openresty-1.9.7.2]# cd /application/
[root@centos application]# ls
backup  nginx  nginx-1.10.2  ngx_openresty-1.9.7.2
[root@centos application]# ln -s ngx_openresty-1.9.7.2/ ngx_openresty
```

[Back to TOC](#table-of-contents)

## 测试OpenResty

```
[root@centos application]# vim /application/ngx_openresty/nginx/conf/nginx.conf

     server {                      
         location /hello {         
             default_type text/html;
             content_by_lua_block {
                 ngx.say("Hello YJJ")                                                 
             }                     
         }                         
     }    

[root@centos application]# /application/ngx_openresty/nginx/sbin/nginx -t
nginx: the configuration file /application/ngx_openresty-1.9.7.2/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /application/ngx_openresty-1.9.7.2/nginx/conf/nginx.conf test is successful
[root@centos application]# /application/ngx_openresty/nginx/sbin/nginx
[root@centos application]# curl 127.0.0.1/hello
Hello YJJ

```

[Back to TOC](#table-of-contents)

## WAF

```
[root@centos ~]# git clone https://github.com/unixhot/waf.git
[root@centos ~]# cp -a ./waf/waf/ /application/ngx_openresty/nginx/conf/

修改Nginx的配置文件，加入以下配置。同时WAF日志默认存放在/tmp/日期_waf.log，同时修改waf路径下的config.lua的规则路径（**config_rule_dir = "/application/ngx_openresty/nginx/conf/waf/rule-config"**）
#WAF  如果路径非以下路径，请注意修改
     lua_shared_dict limit 50m;                  
     lua_package_path "/application/ngx_openresty/nginx/conf/waf/?.lua";             
     init_by_lua_file "/application/ngx_openresty/nginx/conf/waf/init.lua";
     access_by_lua_file "/application/ngx_openresty/nginx/conf/waf/access.lua";

[root@centos ~]# /application/ngx_openresty/nginx/sbin/nginx -t
[root@centos ~]# /application/ngx_openresty/nginx/sbin/nginx

浏览器访问
http://www.yjjztt.top/test.php?id=../etc/passwd
```

[Back to TOC](#table-of-contents)

## 问题记录

### ld returned 1 exit status

	-L/home/yjj/tools/ngx_openresty-1.9.7.2/build/luajit-root/application/ngx_openresty-1.9.7.2/luajit/lib -Wl,-rpath,/application/ngx_openresty-1.9.7.2/luajit/lib -Wl,-E -lpthread -lcrypt -L/home/yjj/tools/ngx_openresty-1.9.7.2/build/luajit-root/application/ngx_openresty-1.9.7.2/luajit/lib -lluajit-5.1 -lm -ldl -lpcre -lssl -lcrypto -ldl -lz
objs/addon/src/ngx_http_lua_regex.o: In function `ngx_http_lua_regex_free_study_data':
/home/yjj/tools/ngx_openresty-1.9.7.2/build/nginx-1.9.7/../ngx_lua-0.10.0/src/ngx_http_lua_regex.c:1948: undefined reference to `pcre_free_study'
objs/addon/src/ngx_http_lua_regex.o: In function `ngx_http_lua_ffi_destroy_regex':
/home/yjj/tools/ngx_openresty-1.9.7.2/build/nginx-1.9.7/../ngx_lua-0.10.0/src/ngx_http_lua_regex.c:2335: undefined reference to `pcre_free_study'
collect2: ld returned 1 exit status
gmake[2]: *** [objs/nginx] Error 1
gmake[2]: Leaving directory `/home/yjj/tools/ngx_openresty-1.9.7.2/build/nginx-1.9.7'
gmake[1]: *** [build] Error 2
gmake[1]: Leaving directory `/home/yjj/tools/ngx_openresty-1.9.7.2/build/nginx-1.9.7'
gmake: *** [all] Error 2


解决办法：

```sh
yum -y install libtool
指定pcre源码路径编译安装
```

[Back to TOC](#table-of-contents)