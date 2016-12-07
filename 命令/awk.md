


[root@db02 ~]# echo "20161002"|awk -vFIELDWIDTHS="4 2 2" -vOFS="-" '{print $1,$2,$3}'
2016-10-02

[root@db02 ~]# awk -v FIELDWIDTHS="4 2 2" -v OFS="-" '{print $1,$2,$3}'  <<<20160202
2016-02-02

[root@db02 ~]# awk -vFIELDWIDTHS="4 2 2" '{printf "%s-%s-%s\n",$1,$2,$3}' <<<20160202
2016-02-02



[root@db02 ~]#  sed -r 's@(.{4})(..)(..)@\1-\2-\3@' <<<"20161002"
2016-10-02
