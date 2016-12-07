

[root@lb01 ~]# export LC_ALL=C
[root@lb01 ~]# echo {a..e} {A..E}|xargs -n1|awk '/[A-Z]/'
A
B
C
D
E
