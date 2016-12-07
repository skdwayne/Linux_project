#!/bin/bash
IP=$(ifconfig eth1|awk -F"[ :]+" 'NR==2{print $4}')
Time=$(date +%F-%A -d "-1day")
mkdir -p /backup/$IP
cd / && \
tar zcfh /backup/$IP/backup-$Time.tar.gz etc/sudoers etc/ssh/sshd_config var/log/messages etc/hosts etc/sysconfig/iptables server/scripts etc/rc.local var/spool/cron/root && \
md5sum /backup/$IP/backup-$Time.tar.gz >/backup/$IP/$Time-md5.txt && \
rsync -az /backup/ rsync_backup@backup::backup/ --password-file=/etc/rsync.password
##delete
cd /backup/"$IP" && \
find . -type f -mtime +7 -name "backup*"|xargs rm -f
find . -type f -name "$Time-md5.txt"|xargs rm -f
