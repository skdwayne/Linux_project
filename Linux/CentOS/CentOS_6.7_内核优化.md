## CentOS 6.7 内核优化 ##

    net.ipv4.tcp_fin_timeout = 2
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_tw_recycle = 1
    net.ipv4.tcp_syncookies = 1
    net.ipv4.tcp_keepalive_time = 600
    net.ipv4.ip_local_port_range = 4000 65000
    net.ipv4.tcp_max_syn_backlog = 16384
    net.ipv4.tcp_max_tw_buckets = 36000
    net.ipv4.route.gc_timeout = 100
    net.ipv4.tcp_syn_retries = 1
    net.ipv4.tcp_synack_retries = 1
    net.core.somaxconn = 16384
    net.core.netdev_max_backlog =  16384
    net.ipv4.tcp_max_orphans = 16384

##防火墙优化
    net.nf_conntrack_max = 25000000
    net.netfilter.nf_conntrack_max = 25000000
    net.netfilter.nf_conntrack_tcp_timeout_established = 180
    net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
    net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
    net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120

----
    net.ipv4.tcp_max_syn_backlog = 65536
    net.core.wmem_default = 8388608
    net.core.rmem_default = 8388608
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    net.ipv4.tcp_timestamps = 0
    net.ipv4.tcp_tw_recycle = 1
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_mem = 94500000 915000000 927000000

    



> 让改动配置立即生效

    /sbin/sysctl -p


> 修改ulimit

    1.vi /etc/security/limits.conf
    *soft   nproc  65535
    *hard   nproc  65535
    *soft   nofile  65535
    *hard   nofile  65535
    2. vi /etc/security/limits.d/90-nproc.conf
    *  softnproc65535