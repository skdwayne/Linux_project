shell技巧总结

### 判断字符串长度

[root@web01 ~]# echo $OLDBOY|wc -L
11
[root@web01 ~]# echo $OLDBOY|awk '{print length($0)}'
11
[root@web01 ~]# awk '{print length($0)}' <<<$OLDBOY

[root@web01 ~]# expr length "$OLDBOY"
11
[root@web01 ~]# 

echo "${#OLDBOY}"