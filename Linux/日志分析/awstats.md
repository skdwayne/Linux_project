<!-- TOC -->

- [Linux 日志分析工具之awstats](#linux-%E6%97%A5%E5%BF%97%E5%88%86%E6%9E%90%E5%B7%A5%E5%85%B7%E4%B9%8Bawstats)
    - [前言](#%E5%89%8D%E8%A8%80)
    - [awstats 简介](#awstats-%E7%AE%80%E4%BB%8B)
    - [[Features](http://www.awstats.org/)](#featureshttpwwwawstatsorg)
    - [详细介绍(百度百科)](#%E8%AF%A6%E7%BB%86%E4%BB%8B%E7%BB%8D%E7%99%BE%E5%BA%A6%E7%99%BE%E7%A7%91)
    - [awstats 运行原理](#awstats-%E8%BF%90%E8%A1%8C%E5%8E%9F%E7%90%86)
    - [环境准备](#%E7%8E%AF%E5%A2%83%E5%87%86%E5%A4%87)
    - [AWStats安装与配置](#awstats%E5%AE%89%E8%A3%85%E4%B8%8E%E9%85%8D%E7%BD%AE)
        - [修改test站点的awstats配置文件](#%E4%BF%AE%E6%94%B9test%E7%AB%99%E7%82%B9%E7%9A%84awstats%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6)
        - [awstats分析日志](#awstats%E5%88%86%E6%9E%90%E6%97%A5%E5%BF%97)
    - [awstats多站点](#awstats%E5%A4%9A%E7%AB%99%E7%82%B9)
    - [awstats分析nginx日志](#awstats%E5%88%86%E6%9E%90nginx%E6%97%A5%E5%BF%97)
        - [统计分析](#%E7%BB%9F%E8%AE%A1%E5%88%86%E6%9E%90)
        - [web展示](#web%E5%B1%95%E7%A4%BA)
    - [awstats问题汇总](#awstats%E9%97%AE%E9%A2%98%E6%B1%87%E6%80%BB)
        - [IP 地址国家、区域显示问题](#ip-%E5%9C%B0%E5%9D%80%E5%9B%BD%E5%AE%B6%E5%8C%BA%E5%9F%9F%E6%98%BE%E7%A4%BA%E9%97%AE%E9%A2%98)
        - [中文乱码](#%E4%B8%AD%E6%96%87%E4%B9%B1%E7%A0%81)

<!-- /TOC -->

# Linux 日志分析工具之awstats

## 前言

> [AWStats](http://www.awstats.org/) is a free powerful and featureful tool that generates advanced web, streaming, ftp or mail server statistics, graphically. This log analyzer works as a CGI or from command line and shows you all possible information your log contains, in few graphical web pages. It uses a partial information file to be able to process large log files, often and quickly. It can analyze log files from all major server tools like Apache log files (NCSA combined/XLF/ELF log format or common/CLF log format), WebStar, IIS (W3C log format) and a lot of other web, proxy, wap, streaming servers, mail servers and some ftp servers.

## awstats 简介

> AWStats is a free powerful and featureful server logfile analyzer that shows you all your Web/Mail/FTP statistics including visits, unique visitors, pages, hits, rush hours, os, browsers, search engines, keywords, robots visits, broken links and more Drag screenshots to sort.

> AWStats 软件是一个免费的强大的服务器的日志文件分析工具，显示你所有的网页/邮件/ FTP统计包括访问，访问者，页面，点击，高峰时间，操作系统，浏览器，搜索引擎，关键字，机器人访问，断开的链接和更多的阻力截图排序。

## [Features](http://www.awstats.org/)

A full log analysis enables AWStats to show you the following information:
* Number of visits, and number of unique visitors,
* Visits duration and last visits,
* Authenticated users, and last authenticated visits,
* Days of week and rush hours (pages, hits, KB for each hour and day of week),
* Domains/countries of hosts visitors (pages, hits, KB, 269 domains/countries detected, GeoIp detection),
* Hosts list, last visits and unresolved IP addresses list,
* Most viewed, entry and exit pages,
* Files type,
* Web compression statistics (for mod_gzip or mod_deflate),
* OS used (pages, hits, KB for each OS, 35 OS detected),
* Browsers used (pages, hits, KB for each browser, each version (Web, Wap, Media browsers: 97 browsers, more than 450 if using browsers_phone.pm library file),
* Visits of robots (319 robots detected),
* Worms attacks (5 worm's families),
* Search engines, keyphrases and keywords used to find your site (The 115 most famous search engines are detected like yahoo, google, altavista, etc...),
* HTTP errors (Page Not Found with last referrer, ...),
* Other personalized reports based on url, url parameters, referer field for miscellanous/marketing purpose,
* Number of times your site is "added to favourites bookmarks".
* Screen size (need to add some HTML tags in index page).
* Ratio of Browsers with support of: Java, Flash, RealG2 reader, Quicktime reader, WMA reader, PDF reader (need to add some HTML tags in index page).
* Cluster report for load balanced servers ratio.

## 详细介绍(百度百科)

```txt
AWStats是在Sourceforge上发展很快的一个基于Perl的WEB日志分析工具。相对于另外一个非常优秀的开放源代码的日志分析工具Webalizer，AWStats的优势在于：

1. 界面友好：可以根据浏览器直接调用相应语言界面（有简体中文版）

2. 基于Perl：并且很好的解决了跨平台问题，系统本身可以运行在GNU/Linux上或Windows上（安装了ActivePerl后）；分析的日志直接支持Apache格式 (combined)和IIS格式(需要修改)。Webalizer虽然也有Windows平台版，但目前已经缺乏 维护；AWStats完全可以实现用一套系统完成对自身站点不同WEB服务器：GNU/Linux/Apache和Windows/IIS服务器的统一统计。

3. 效率比较高：AWStats输出统计项目比Webalizer丰富了很多，速度仍可以达到Webalizer的1/3左右，对于一个日访问量 百万级的站点，这个速度都是足够的；

4. 配置/定制方便：系统提供了足够灵活但缺省也很合理的配置规则，需要修改的缺省配置不超过3，4项就可以开始运行，而且修改和扩展的插件还是 比较多的；

5. AWStats的设计者是面向精确的"Human visits"设计的，因此很多搜索引擎的机器人访问都被过滤掉了，因此有可能比其他日志统计工具统计的数字要低，来自公司内部的访问也可以通过IP过滤 设置过滤掉。

6. 提供了很多扩展的参数统计功能：使用ExtraXXXX系列配置生成针对具体应用的参数分析会对产品分析非常有用。

AWStats 是一个免费的强大而有个性的工具,带来先进的网络,流量，FTP或邮件服务器统计图. 本日志分析器作为CGI或从命令行在数个图形网页中显示你日志中包含的所有可能信息. 它利用一部分档案资料就能经常很快地处理大量日志档案, 它能分析日志文件来自从各大服务器工具 ,如 Apache日志档案 s (NCSA combined/XLF/ELF log format or common/CLF log format), WebStar, IIS (W3C的日志格式)及许多其他网站,Proxy(代理服务器)、Wap、流量服务器、邮件服务器和一些 FTP服务器 .

看一看这个比较表在最著名统计工具 (AWStats, Analog, Webalizer,...)之间有何特点和不同的想法.

AWStats 是一个在GNU通用公共许可证下发行的免费软件. 你可以看看这个许可证图表而知道你可以/不可以做.

由于AWStats工程来自网上信息,但也作为CGI、 它可以与允许进入Perl,CGI与日志的大型网站主办提供商一起工作.
```

## awstats 运行原理

> 工作原理

```txt
AWStats的功能很多，我在此主要用它来分析apache服务器的日志。安装使用之前还是说说大致的工作原理，AWStats提供一系列的perl脚本实现：服务配置，日志读取，报表生成等功能。而功能实现的具体执行过程是：首先，当然是apache将访问情况记录到日志中，AWStats每次执行更新时读取这些日志，分析日志数据，将结果存储到数据库中，(这个数据库是AWStats自带的（就是一文本文件），并不需要第三方软件支持。)，最后AWStats提供一个cgi程序通过web页面来显示数据库中所统计的数据。
```

> 工作模式

```txt
AWStats的工作模式：
分析日志：运行后将这样的日志统计结果归档到一个AWStats的数据库（纯文本）里
输出日志：分两种形式:
    * 一种是通过cgi程序读取统计结果数据库输出(Linux)
    * 一种是运行后台脚本将输出导出成静态文件(Windows)
```

## 环境准备

```sh
操作系统 CentOS 6.4 x86_64，软件版本 awstats 7.6（稳定版），
[root@web01 ~]# cat /etc/redhat-release 
CentOS release 6.7 (Final)
[root@web01 ~]# uname -r
2.6.32-573.el6.x86_64

[root@web01 ~]# rpm -qa awstats  ## 软件版本
awstats-7.6-1.noarch
```

[awstats-7.6下载](https://prdownloads.sourceforge.net/awstats/awstats-7.6-1.noarch.rpm)

[AWStats sourceforge](http://sourceforge.net/projects/awstats/)

## AWStats安装与配置

```sh
wget https://prdownloads.sourceforge.net/awstats/awstats-7.6-1.noarch.rpm

[root@web01 ~]# rpm -ivh awstats-7.6-1.noarch.rpm 
[root@web01 ~]# rpm -ql awstats |head
/etc/awstats/awstats.model.conf
/usr/local/awstats/README.md
/usr/local/awstats/docs/COPYING.TXT
/usr/local/awstats/docs/LICENSE.TXT
/usr/local/awstats/docs/awstats.pdf
/usr/local/awstats/docs/awstats_benchmark.html
/usr/local/awstats/docs/awstats_changelog.txt
/usr/local/awstats/docs/awstats_compare.html
/usr/local/awstats/docs/awstats_config.html
/usr/local/awstats/docs/awstats_contrib.html

说明：
cat /usr/local/awstats/README.md
```

> 接下来，执行/usr/local/awstats/tools下的awstats_configure.pl配置向导，用来生成awstats的配置文件，awstats配置文件的命名规则是awstats.website.conf。

```sh
[root@web01 awstats]# pwd
/usr/local/awstats
[root@web01 awstats]# ls
docs  README.md  tools  wwwroot

[root@web01 awstats]# cd tools/
[root@web01 tools]# ./awstats_configure.pl 

----- AWStats awstats_configure 1.0 (build 20140126) (c) Laurent Destailleur -----
This tool will help you to configure AWStats to analyze statistics for
one web server. You can try to use it to let it do all that is possible
in AWStats setup, however following the step by step manual setup
documentation (docs/index.html) is often a better idea. Above all if:
- You are not an administrator user,
- You want to analyze downloaded log files without web server,
- You want to analyze mail or ftp log files instead of web log files,
- You need to analyze load balanced servers log files,
- You want to 'understand' all possible ways to use AWStats...
Read the AWStats documentation (docs/index.html).

-----> Running OS detected: Linux, BSD or Unix

-----> Check for web server install    ## 检查安装的web server

Enter full config file path of your Web server.
Example: /etc/httpd/httpd.conf
Example: /usr/local/apache2/conf/httpd.conf
Example: c:\Program files\apache group\apache\conf\httpd.conf
Config file path ('none' to skip web server setup):     ### 设置Apache路径（nginx需要另外设置，默认的Awstats不支持分析）
> /application/nginx/conf/nginx.conf   

-----> Check and complete web server config file '/application/nginx/conf/nginx.conf'  ## 可以看到添加的设置是Apache的设置
  Add 'Alias /awstatsclasses "/usr/local/awstats/wwwroot/classes/"'
  Add 'Alias /awstatscss "/usr/local/awstats/wwwroot/css/"'
  Add 'Alias /awstatsicons "/usr/local/awstats/wwwroot/icon/"'
  Add 'ScriptAlias /awstats/ "/usr/local/awstats/wwwroot/cgi-bin/"'
  Add '<Directory>' directive
  AWStats directives added to Apache config file.

-----> Update model config file '/etc/awstats/awstats.model.conf'
  File awstats.model.conf updated.

-----> Need to create a new config file ?
Do you want me to build a new AWStats config/profile    ### 创建配置文件
file (required if first install) [y/N] ? y

-----> Define config file name to create
What is the name of your web site or profile analysis ?
Example: www.mysite.com
Example: demo
Your web site, virtual server or profile name:  ## 设置虚拟主机名字，比如www.test.com，此处我使用test，此处设置注意与后文web查看的内容保持一致
> test                        ### http://10.0.0.8/awstats/awstats.pl?config=test   等于号后面的内容

-----> Define config file path
In which directory do you plan to store your config file(s) ?
Default: /etc/awstats  ## 默认配置文件创建位置
Directory path to store config file(s) (Enter for default):  ## 配置config文件所在目录，回车表示使用默认
> 

-----> Create config file '/etc/awstats/awstats.test.conf'
 Config file /etc/awstats/awstats.test.conf created.

-----> Restart Web server with '/sbin/service httpd restart'  ## 由于设置了httpd，所以软件重启httpd（我们设置失败了）
httpd: Could not reliably determine the server's fully qualified domain name, using 172.16.1.8 for ServerName
Stopping httpd:                                            [  OK  ]
Starting httpd:                                            [  OK  ]

-----> Add update process inside a scheduler
Sorry, configure.pl does not support automatic add to cron yet.
You can do it manually by adding the following command to your cron:
/usr/local/awstats/wwwroot/cgi-bin/awstats.pl -update -config=test   ### 分析的命令，运行此命令即可
Or if you have several config files and prefer having only one command:
/usr/local/awstats/tools/awstats_updateall.pl now
Press ENTER to continue...       ### 提示没有成功加入定时任务，我们可以自行添加


A SIMPLE config file has been created: /etc/awstats/awstats.test.conf  ## 注意说明
You should have a look inside to check and change manually main parameters.
You can then manually update your statistics for 'test' with command:
> perl awstats.pl -update -config=test
You can also read your statistics for 'test' with URL:
> http://localhost/awstats/awstats.pl?config=test

Press ENTER to finish...   ## 提示配置文件创建完成和如何更新配置及建立静态报告页，回车退出向导

[root@web01 tools]# 
```

### 修改test站点的awstats配置文件

```sh
[root@web01 awstats]# cd /etc/awstats/
[root@web01 awstats]# ls
awstats.model.conf  awstats.test.conf

部分设置说明
[root@web01 awstats]# vim awstats.www.test.com.conf
[root@web01 awstats]# egrep "^(LogFile|DirData|Lang|SkipHosts|LevelForWor)" awstats.test.conf
LogFile="/var/log/httpd/access_log"   ## 日志文件存放路径，示例：LogFile="/log/www/access_%YYYY-24%MM-24%DD-24.log" ，其中%YYYY-24%MM-24%DD是指年月日模式
DirData="/var/lib/awstats"  ## 创建生成的数据路径
SkipHosts="127.0.0.1 REGEX[^192\.168\.]" ## 可以设置本地及内部的访问不做分析统计，注意自行修改
LevelForWormsDetection=0            # 0 disables Worms detection.  # 日志等级2，不对警告日志进行统计
Lang="auto"   ## 默认auto，可设置成cn

到这配置完成
```

### awstats分析日志

```sh
[root@web01 awstats]# /usr/local/awstats/wwwroot/cgi-bin/awstats.pl -update -config=test 
Create/Update database for config "/etc/awstats/awstats.test.conf" by AWStats version 7.6 (build 20161204)
From data in log file "/var/log/httpd/access_log"...
Phase 1 : First bypass old records, searching new record...
Searching new records from beginning of log file...
Phase 2 : Now process new records (Flush history on disk after 20000 hosts)...
Jumped lines in file: 0
Parsed lines in file: 130
 Found 0 dropped records,
 Found 0 comments,
 Found 0 blank records,
 Found 0 corrupted records,
 Found 0 old records,
 Found 130 new qualified records.
[root@web01 awstats]# cd /var/lib/awstats/
[root@web01 awstats]# ls
awstats122016.test.txt

访问如下站点
http://10.0.0.8/awstats/awstats.pl?config=test

```

查看分析结果：

![awstats1-20161219](http://oi480zo5x.bkt.clouddn.com/Linux_project/awstats1-20161219.jpg)

如果生成之后，访问上述站点，提示404，那么需要检查httpd配置文件，可能需要添加如下内容
```sh
[root@web01 awstats]# ll /usr/local/awstats/tools/
total 160
-rwxr-xr-x 1 root root 19788 Dec  3 20:59 awstats_buildstaticpages.pl
-rwxr-xr-x 1 root root 25990 Dec  3 20:59 awstats_configure.pl
-rwxr-xr-x 1 root root 12593 Dec  3 20:59 awstats_exportlib.pl
-rwxr-xr-x 1 root root  5389 Dec  3 20:59 awstats_updateall.pl
-r--r--r-- 1 root root   855 Dec  3 20:59 httpd_conf                ### 该配置文件配置匹配如下别名
-rwxr-xr-x 1 root root 33291 Dec  3 20:59 logresolvemerge.pl
-rwxr-xr-x 1 root root 27771 Dec  3 20:59 maillogconvert.pl
-rwxr-xr-x 1 root root  9755 Dec  3 20:59 urlaliasbuilder.pl
drwxr-xr-x 2 root root  4096 Dec 19 22:01 webmin
drwxr-xr-x 2 root root  4096 Dec 19 22:01 xslt

[root@web01 awstats]# cat /usr/local/awstats/tools/httpd_conf   ### 所以需要在httpd配置文件里面Include该文件
#
# Content of this file, with correct values, can be automatically added to
# your Apache server by using the AWStats configure.pl tool.
#


# If using Windows and Perl ActiveStat, this is to enable Perl script as CGI.
#ScriptInterpreterSource registry


#
# Directives to add to your Apache conf file to allow use of AWStats as a CGI.
# Note that path "/usr/local/awstats/" must reflect your AWStats install path.
#
Alias /awstatsclasses "/usr/local/awstats/wwwroot/classes/"
Alias /awstatscss "/usr/local/awstats/wwwroot/css/"
Alias /awstatsicons "/usr/local/awstats/wwwroot/icon/"
ScriptAlias /awstats/ "/usr/local/awstats/wwwroot/cgi-bin/"


#
# This is to permit URL access to scripts/files in AWStats directory.
#
<Directory "/usr/local/awstats/wwwroot">
    Options None
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>



[root@web01 conf]# grep "Include /usr/local/awstats/tools/httpd_conf" httpd.conf 
Include /usr/local/awstats/tools/httpd_conf
```

修改web界面显示语言

```sh
[root@web01 awstats]# sed -i.bak 's#Lang="auto"#Lang="cn"#g' /etc/awstats/awstats.test.conf
```

![awstats2-20161219](http://oi480zo5x.bkt.clouddn.com/Linux_project/awstats2-20161219.jpg)

## awstats多站点

> 从上述操作执行awstats_configure.pl脚本开始，即可

## awstats分析nginx日志

### 统计分析

```
1. 确保Perl环境OK
    [root@web01 ~]# perl --version

    This is perl, v5.10.1 (*) built for x86_64-linux-thread-multi

2. 配置nginx日志格式：

    log_format main  '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $bytes_sent '
                    '"$http_referer" "$http_user_agent" '
                    '"$gzip_ratio" "$http_x_forwarded_for" ';

3. 执行awstats_configure.pl，其他一致

    -----> Check for web server install    ## 检查安装的web server

    Enter full config file path of your Web server.
    Example: /etc/httpd/httpd.conf
    Example: /usr/local/apache2/conf/httpd.conf
    Example: c:\Program files\apache group\apache\conf\httpd.conf
    Config file path ('none' to skip web server setup):
    >     ## 这一步不填写
4. 修改日志文件路径
    LogFile="/application/nginx/logs/access_%YYYY-0%MM-0%DD-0.log   ## 根据是否切割等，设置

执行统计的顺序是：
Nginx 产生日志 –> 日志切割 –> Nginx 继续产生日志 –> 另存切割日志 –> 交由Awstats统计 –> 生成结果
```

### web展示

```sh
首先在 webroot 目录下创建一个文件夹。例：/data/webroot/awstats
然后让 Awstats 把静态页面生成到该目录中

    # mkdir  /data/webroot/awstats

    # /usr/local/awstats/tools/awstats_buildstaticpages.pl -update  \
    -config=www.moabc.net -lang=cn -dir=/data/admin_web/awstats  \
    -awstatsprog=/usr/local/awstats/wwwroot/cgi-bin/awstats.pl

上述命令的具体意思如下：

        /usr/local/awstats/tools/awstats_buildstaticpages.pl Awstats 静态页面生成工具
        -update -config=www.jackbillow.com 更新配置项
        -lang=cn 语言为中文
        -dir=/www/wwwroot/www.jackbillow.com/awstats 统计结果输出目录
        -awstatsprog=/usr/local/awstats/wwwroot/cgi-bin/awstats.pl Awstats 日志更新程序路径。

接下来，只需在nginx.conf 中，把该目录配置上去即可。
根据Apache配置修改server标签，定义转发规则（请自行修改），示例：
    server {
    listen       80;
    server_name  localhost;

    location ~ ^/web/ {
    root   /www/wwwroot;
    index  index.html;
    error_log off;
    charset gb2312;
    }

    location ~ ^/awstats/ {     # html 静态页面目录
            root   /www/wwwroot/www.test.com/awstats;
            index  index.html;
            access_log off;
            error_log off;
            charset gb2312; #最好把默认编码改成 gb2312避免浏览器因自动编码出现乱码的情况
    }

    location ~ ^/icon/ {             # 图标目录
            root   /usr/local/awstats/wwwroot;
            index  index.html;
            access_log off;
            error_log off;
            charset gb2312;
            }
    }
```

## awstats问题汇总

### IP 地址国家、区域显示问题 

![awstats3-20161219](http://oi480zo5x.bkt.clouddn.com/Linux_project/awstats3-20161219.jpg)

Awstats默认安装之后是不具有识别访问者的国家和地区信息的，所以需要安装插件支持Awstats列出访问者的国家和地区，便于分析GeoIP免费的是国家/IP的数据表，GeoIPCityLite是地区的数据表。

```sh
1. MaxMind目前免费提供了GeoIP和GeoIPCityLite数据包：可以定期每个月从以下地址下载
    [root@web01 ~]# mkdir -p src/
    [root@web01 ~]# cd src/
    [root@web01 src]# wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
    [root@web01 src]# wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
    [root@web01 src]# ls
    backup  GeoIP.dat.gz  GeoLiteCity.dat.gz
    [root@web01 src]# gunzip GeoIP.dat.gz 
    [root@web01 src]# gunzip GeoLiteCity.dat.gz 
    [root@web01 src]# ls
    backup  GeoIP.dat  GeoLiteCity.dat

2. 新建的目录，把两个文件移入新建的目录
    [root@web01 src]# mkdir /var/geoip
    [root@web01 src]# mv GeoIP.dat GeoLiteCity.dat /var/geoip

3. 安装GeoIP与GeoIP perl库
    [root@web01 awstats]# yum install –y GeoIP perl-Geo-IP

4. 修改awstats配置文件
    [root@web01 awstats]# vim /etc/awstats/awstats.test.conf

    1460 #LoadPlugin="geoip GEOIP_STANDARD /pathto/GeoIP.dat"
    1479 #LoadPlugin="geoip_city_maxmind GEOIP_STANDARD /pathto/GeoIPCity.dat"
    -------修改为如下内容
    LoadPlugin="geoip GEOIP_STANDARD /var/geoip/GeoIP.dat"
    LoadPlugin="geoip_city_maxmind GEOIP_STANDARD /var/geoip/GeoLiteCity.dat"

5. 删除旧的统计数据
    [root@web01 awstats]# rm -rf /var/lib/awstats/*

6. 重新生成
    [root@web01 awstats]# /usr/local/awstats/wwwroot/cgi-bin/awstats.pl -update -config=test

    Create/Update database for config "/etc/awstats/awstats.test.conf" by AWStats version 7.6 (build 20161204)
    From data in log file "/var/log/httpd/access_log"...
    Phase 1 : First bypass old records, searching new record...
    Searching new records from beginning of log file...
    Phase 2 : Now process new records (Flush history on disk after 20000 hosts)...
    Jumped lines in file: 0
    Parsed lines in file: 130
    Found 0 dropped records,
    Found 0 comments,
    Found 0 blank records,
    Found 0 corrupted records,
    Found 0 old records,
    Found 130 new qualified records.

查看新的统计数据
```

### 中文乱码

```sh
Awstats是一套非常好用的免费的日志分析软件,他是用perl实现的，支持web log、ftp log和mail log;而且它还能自动根据你浏览器的字符设置来选取语言(支持中文)。但是缺省安装的话有个问题,就是用来搜索的关键字如果是中文的话显示出来是乱码的。 之所以搜索的关键字句会变成乱码的原因，主要是因为现在的搜索引擎都是使用UTF8，而Awstats是使用decodeUTFkeys这个plugin来处理搜索引擎的UTF8关键字，默认是没有打开的，所以在显示上会出现乱码。要解决中文乱码问题,方法也很简单，

在配置文件中把decodeutfkeys这个plugin打开就可以了。在配置文件中找到：

#LoadPlugin="decodeutfkeys"

去掉前面的#就可以了。

[root@node6 ~]# vim /etc/awstats/awstats.test.conf
#LoadPlugin="decodeutfkeys"
----
LoadPlugin="decodeutfkeys"
```
