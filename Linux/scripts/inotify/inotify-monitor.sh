#!/bin/bash

/usr/bin/inotifywait -mrq  --format '%w%f' -e create,close_write,delete /backup /var/www \
|while read file
do
  rsync -az /backup/ --delete rsync_backup@172.16.1.41::backup \
  --password-file=/etc/rsync.password
  rsync -az /var/www/html/ --delete rsync_backup@172.16.1.41::backup/html \
  --password-file=/etc/rsync.password
done

