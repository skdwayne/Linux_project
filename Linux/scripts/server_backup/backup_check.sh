#!/bin/bash
Time=$(date +%F-%A)

cd /backup && \
num=$(find . -type f -name "$Time-md5.txt" |xargs md5sum -c|grep -v "OK"|wc -l)
	if [ $num -eq 0 ];then 
   		echo  "$Time It's OK"|mailx -s "backup_info-Yes" 493535459@qq.com
		find -type f  -name "*-md5.txt"|xargs rm -f
	else 
 	  	echo "$Time Failed!"|mailx -s "backup_info-No" 493535459@qq.com
	fi

#delete
find -type f -mtime +180 ! -name "backup*Saturday.tar.gz"  -name "backup*"|xargs rm -f
