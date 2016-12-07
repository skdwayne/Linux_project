

awk -F"[/ :]" 'BEGIN{y["Apr"]="04"}{print $3"-"y[$2]"-"$1,$4":"$5":"$6$7}' test 


ftp服务器


yum -y install vsftpd
useradd -d /data/ftphome -s /sbin/nologin ftp30


vim /etc/vsftpd/ftp_user.txt

db_load -T -t hash -f /etc/vsftpd/ftp_user.txt /etc/vsftpd/vsftpd_login.db

# 创建 PAM 验证文件
cat >/etc/pam.d/ftp<<EOF
auth required /lib64/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login  
account required /lib64/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login
EOF

cat>/etc/vsftpd/vsftpd.conf<<EOF
anonymous_enable=NO
local_enable=YES
guest_enable=YES
write_enable=YES
guest_username=ftp30
listen=YES
pasv_min_port=30000
pasv_max_port=30999
user_config_dir=/etc/vsftpd/user_conf
virtual_use_local_privs=NO
anon_world_readable_only=NO
anon_upload_enable=NO
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
EOF

mkdir /etc/vsftpd/user_conf

zy：用户名
cat>/etc/vsftpd/user_conf/zy<<EOF 
virtual_use_local_privs=NO
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
EOF



