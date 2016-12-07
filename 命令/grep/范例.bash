范例


[root@db02 ~]# ip a |grep -Po 'inet \K\S+'
127.0.0.1/8
10.0.0.52/24
172.16.1.52/24

[root@db02 ~]# ifconfig eth0|grep -Po '(?<=t addr:)\S+'
10.0.0.52

[root@db02 ~]# ifconfig eth0|grep -Po '[(\d).]+(?=\s+Bca)'
10.0.0.52

ifconfig eth0|grep -Po --color '\w:\K.*(?=  B)'

