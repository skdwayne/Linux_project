九九乘法表

[root@web01 ~]# for((i=1;i<10;i++));do for((j=1;j<=i;j++))do printf "$j*$i=$((i*j))\t" ;done;printf "\n";done 




