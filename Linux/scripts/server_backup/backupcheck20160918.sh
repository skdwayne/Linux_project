#!/bin/bash
Time=$(date +%F-%A -d "-1day")

cd /backup && \

find . -type f -name "$Time-md5.txt" |xargs md5sum -c >/tmp/backup_md5sum

num=$(grep -v "OK" /tmp/backup_md5sum |wc -l)
	if [ $num -eq 0 ];then 
   		mailx -s "backup_info-Yes" 493535459@qq.com </tmp/backup_md5sum
		find -type f  -name "*-md5.txt"|xargs rm -f
	else 
 	  	mailx -s "backup_info-No" 493535459@qq.com </tmp/backup_md5sum
	fi

#delete
find -type f -mtime +180 ! -name "backup*Monday.tar.gz"  -name "backup*"|xargs rm -f
