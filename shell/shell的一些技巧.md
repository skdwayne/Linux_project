shell的一些技巧

####　获取参数=后面的内容
[root@web01 ~]#　echo "--basedir=/applica" | sed -e 's/^[^=]*=//'
/applica

