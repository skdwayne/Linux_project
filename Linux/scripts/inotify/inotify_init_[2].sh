#!/bin/sh
SRC=/backup/  
DES=oldboy
IP=172.16.1.41
User=rsync_backup
#DST=/etc/rsyncd 远程rsync模块下的目录
INWT=/usr/bin/inotifywait
RSYNC=/usr/bin/rsync
  
$RSYNC -az $SRC $User@$IP::$DES --password-file=/etc/rsync.password
