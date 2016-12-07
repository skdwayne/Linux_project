inotify


[root@rsync-client-inotify ~]# cat auto_rsync.sh
#!/bin/bash
src1='/data/web/redhat.sx/'
src2='/data/web_data/redhat.sx/'
des1=web
des2=data
host1=172.16.100.1
host2=172.16.100.1
user=rsync_backup
allrsync='/usr/bin/rsync -rpgovz --delete --progress'
/usr/local/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w %w%f %e' -e modify,delete,create,attr
ib $src | while read DATE TIME DIR FILE EVENT;
do
case $DIR in
${src1}*)
$allrsync $src1 $user@$host1::$des1 --password-file=/etc/rsync.password && echo "$DATE $TIME $FILE was rsynced" &>> /var/log
/rsync-$des1-$host1.log
$allrsync $src1 $user@$host2::$des1 --password-file=/etc/rsync.password && echo "$DATE $TIME $FILE was rsynced" &>> /var/log
/rsync-$des1-$host2.log
;;
${src2}*)
$allrsync  $src2 $user@$host1::$des2 --password-file=/etc/rsync.password && echo "$DATE $TIME $FILE was rsynced" &>> /var/lo
g/rsync-$des2-$host1.log
$allrsync  $src2 $user@$host2::$des2 --password-file=/etc/rsync.password && echo "$DATE $TIME $FILE was rsynced" &>> /var/lo
g/rsync-$des2-$host2.log
;;
esac
done