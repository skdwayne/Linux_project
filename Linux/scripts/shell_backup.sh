
backup() {
cat >/etc/rsyncd.conf 
\#rsync_config_______________start
\##rsyncd.conf start##
uid = rsync
gid = rsync
use chroot = no
max connections = 200
timeout = 300
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
ignore errors
read only = false
list = false
hosts allow = 172.16.1.0/24
#hosts deny = 0.0.0.0/32
auth users = rsync_backup
secrets file = /etc/rsync.password

[backup]
path = /backup/
[nfsbackup]
path = /nfsbackup/

}


main (){
    backup
}
main