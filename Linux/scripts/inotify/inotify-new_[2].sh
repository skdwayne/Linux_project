#!/bin/bash
Path=/data

/usr/bin/inotifywait -mrq  --format '%w%f' -e create,close_write,delete $Path \
| while read file
 do

   if [ -f $file ];then
       rsync -az $file rsync_backup@172.16.1.41::nfsbackup --password-file=/etc/rsync.password
   else
       cd $Path &&\
       rsync -az --delete ./  rsync_backup@172.16.1.41::nfsbackup --password-file=/etc/rsync.password
   fi
 done
