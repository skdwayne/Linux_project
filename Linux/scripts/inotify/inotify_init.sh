#!/bin/sh
SRC=/backup/


DES=backup
IP=172.16.1.41
USER=rsync_backup
#DST=/etc/rsyncd 远程rsync模块下的目录
INWT=/usr/bin/inotifywait
RSYNC=/usr/bin/rsync

$RSYNC -zahqt --password-file=/etc/rsync.password $SRC $USER@$IP::$DES
#$RSYNC -az $SRC $User@$IP::$DES --password-file=/etc/rsync.password
