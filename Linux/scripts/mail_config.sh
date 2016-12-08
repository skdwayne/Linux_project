#!/bin/bash
##mail smtp config
[ `grep "set from=brave0517@163.com" /etc/mail.rc|wc -l` -eq 1 ] || cat >>/etc/mail.rc<<EOF
set from=brave0517@163.com 
set smtp=smtp.163.com
set smtp-auth-user=brave0517@163.com
set smtp-auth-password=xxxx   ### 密码
set smtp-auth=login
EOF
