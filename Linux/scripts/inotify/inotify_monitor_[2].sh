#!/bin/bash
  
###########################
sync[0]='/backup/,172.16.1.41,oldboy,rsync_backup'
# localdir,host,rsync_module,auth_user
  
INWT=/usr/bin/inotifywait
RSYNC=/usr/bin/rsync
PASS=/etc/rsync.password
###########################
  
for item in ${sync[@]}; do
  
dir=`echo $item | awk -F"," '{print $1}'`
host=`echo $item | awk -F"," '{print $2}'`
module=`echo $item | awk -F"," '{print $3}'`
user=`echo $item | awk -F"," '{print $4}'`
  
$INWT -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f %e' \
--event CLOSE_WRITE,create,move $dir | while read date time file event
do
#echo $event'-'$file
case $event in
MODIFY|CREATE|MOVE|MODIFY,ISDIR|CREATE,ISDIR|MODIFY,ISDIR)
if [ "${file: -4}" != '4913' ] && [ "${file: -1}" != '~' ]; then
cmd="$RSYNC -zahqzt --exclude='*' --password-file=$PASS \
--include=$file $dir $user@$host::$module > /dev/null 2>1&"
echo $cmd
$cmd
fi
;;
  
MOVED_FROM|MOVED_FROM,ISDIR|DELETE,ISDIR)
if [ "${file: -4}" != '4913' ] && [ "${file: -1}" != '~' ]; then
cmd="$RSYNC -zahqzt --password-file=$PASS --exclude=$file \
$dir $user@$host::$module > /dev/null 2>1&"
echo $cmd
$cmd
fi

;;
esac
done &
done
