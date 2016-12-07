检查nginx状态


[root@web01 scripts]# cat check_web.sh
#!/bin/sh
num=`netstat -lntup|grep nginx|awk -F '[ :]+' '{print $5}'`
if [ $num -eq 80 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi
#有缺陷

[root@web01 scripts]# cat check_web.sh
#!/bin/sh
num=`netstat -lntup|grep nginx|awk -F '[ :]+' '{print $5}'`
if [ "$num" = "80" ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


[root@web01 scripts]# cat check_web.sh
#!/bin/sh
num=`netstat -lntup|grep nginx|wc -l`
if [ $num -ge 1 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


[root@web01 scripts]# cat check_web.sh 
#!/bin/sh
num=`nmap 10.0.0.8 -p 80|grep open|wc -l`
if [ $num -eq 1 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi

[root@web01 scripts]# cat check_web.sh
#!/bin/sh
wget --spider --timeout=10 --tries=2 http://10.0.0.8 &>/dev/null
if [ $? -eq 0 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


[root@web01 scripts]# cat check_web.sh 
#!/bin/sh
code=`curl -I -s -w "%{http_code}\n"  -o /dev/null http://10.0.0.8`
if [ "$code" = "200" ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


[root@web01 scripts]# cat check_web.sh
#!/bin/sh
code=`curl -I -s -w "%{http_code}\n"  -o /dev/null http://10.0.0.8|egrep -w "200|301|302"|wc -l`
if [ $code -ge 1 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi

[root@web01 scripts]# cat check_web.sh 
#!/bin/sh
code=`curl -I -s -w "%{http_code}\n"  -o /dev/null http://10.0.0.8`
if [[ $code =~ [23]0[012] ]]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


<?php
/* 
#this scripts is created by oldboy
#oldboy QQ:31333741
#site: http://www.etiantian.org
#blog: http://oldboy.blog.51cto.com
*/
              $link_id=mysql_connect('localhost','root','oldboy123') or mysql_error();
              if($link_id){
          echo "mysql successful by oldboy !";
        }else{
          echo mysql_error();
    }
?>


[root@web01 scripts]# cat check_db.php 
<?php
/* 
#this scripts is created by oldboy
#oldboy QQ:31333741
#site: http://www.etiantian.org
#blog: http://oldboy.blog.51cto.com
*/
              $link_id=mysql_connect('localhost','root','oldboy123') or mysql_error();
              if($link_id){
          echo "mysql successful by oldboy !";
        }else{
          echo mysql_error();
    }
?>
[root@web01 scripts]# /application/php/bin/php check_db.php 2>/dev/null|grep oldboy|wc -l
0
借助了http服务，将程序放入Http lnmp站点下
[root@web01 extra]# /etc/init.d/mysqld start
Starting MySQL.. SUCCESS! 
[root@web01 extra]# curl -s http://10.0.0.8/check_db.php|grep oldboy|wc -l


[root@web01 scripts]# cat check_web.sh
#!/bin/sh
num=`netstat -lntup|grep nginx|awk -F '[ :]+' '{print $5}'`
if [ $num -eq 80 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi
#有缺陷

[root@web01 scripts]# cat check_web.sh
#!/bin/sh
num=`netstat -lntup|grep nginx|awk -F '[ :]+' '{print $5}'`
if [ "$num" = "80" ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


[root@web01 scripts]# cat check_web.sh
#!/bin/sh
num=`netstat -lntup|grep nginx|wc -l`
if [ $num -ge 1 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


[root@web01 scripts]# cat check_web.sh 
#!/bin/sh
num=`nmap 10.0.0.8 -p 80|grep open|wc -l`
if [ $num -eq 1 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi

[root@web01 scripts]# cat check_web.sh
#!/bin/sh
wget --spider --timeout=10 --tries=2 http://10.0.0.8 &>/dev/null
if [ $? -eq 0 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi






[root@web01 scripts]# cat check_web.sh 
#!/bin/sh
code=`curl -I -s -w "%{http_code}\n"  -o /dev/null http://10.0.0.8`
if [ "$code" = "200" ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


[root@web01 scripts]# cat check_web.sh
#!/bin/sh
code=`curl -I -s -w "%{http_code}\n"  -o /dev/null http://10.0.0.8|egrep -w "200|301|302"|wc -l`
if [ $code -ge 1 ]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi

[root@web01 scripts]# cat check_web.sh 
#!/bin/sh
code=`curl -I -s -w "%{http_code}\n"  -o /dev/null http://10.0.0.8`
if [[ $code =~ [23]0[012] ]]
 then
   echo "web is running."
else
   echo "web is down. starting nginx"
   /application/nginx/sbin/nginx
fi


<?php
/* 
#this scripts is created by oldboy
#oldboy QQ:31333741
#site: http://www.etiantian.org
#blog: http://oldboy.blog.51cto.com
*/
              $link_id=mysql_connect('localhost','root','oldboy123') or mysql_error();
              if($link_id){
          echo "mysql successful by oldboy !";
        }else{
          echo mysql_error();
    }
?>


[root@web01 scripts]# cat check_db.php 
<?php
/* 
#this scripts is created by oldboy
#oldboy QQ:31333741
#site: http://www.etiantian.org
#blog: http://oldboy.blog.51cto.com
*/
              $link_id=mysql_connect('localhost','root','oldboy123') or mysql_error();
              if($link_id){
          echo "mysql successful by oldboy !";
        }else{
          echo mysql_error();
    }
?>
[root@web01 scripts]# /application/php/bin/php check_db.php 2>/dev/null|grep oldboy|wc -l
0
借助了http服务，将程序放入Http lnmp站点下
[root@web01 extra]# /etc/init.d/mysqld start
Starting MySQL.. SUCCESS! 
[root@web01 extra]# curl -s http://10.0.0.8/check_db.php|grep oldboy|wc -l


