用awk如何自动填充空数据的列为最近的不为空的数据？

比如以下文本：

name1,1,21,address1
name2,0,,
name3,0,,
name4,1,30,address4
name5,0,24,address5
name6,1,,
name7,1,29,address7
其中name2、name3和name6的第三列和第四列都为空值，我想实现这些空值自动填充为它们上方的相应列不为空的数据，如下所示：

name1,1,21,address1
name2,0,21,address1
name3,0,21,address1
name4,1,30,address4
name5,0,24,address5
name6,1,24,address5
name7,1,29,address7
请问用awk怎样实现呢？其他语言的版本不需要~



 vi 1.txt

name1,1,21,address1
name2,0,,
name3,0,,
name4,1,30,address4
name5,0,24,address5
name6,1,,
name7,1,29,address7

awk -F',' 'BEGIN{OFS=","}{if($1!=""&&$2!=""&&$3!=""&&$4!=""){a=$1;b=$2;c=$3;d=$4}else{if($1==""){$1=a;}if($2==""){$2=b;}if($3==""){$3=c;}if($4==""){$4=d}}print;}' 1.txt

name1,1,21,address1
name2,0,21,address1
name3,0,21,address1
name4,1,30,address4
name5,0,24,address5
name6,1,24,address5
name7,1,29,address7



可以用脚本实现，可能不是最简单的

#!/bin/bash
awk '{print}' aa.txt | while read line
do
        a1=`echo $line | awk -F , '{print $1}'`
        a2=`echo $line | awk -F , '{print $2}'`
        a3=`echo $line | awk -F , '{print $3}'`
        a4=`echo $line | awk -F , '{print $4}'`
        if [[ ! -z $a1 && ! -z $a2 && ! -z $a3 && ! -z $a1 ]];then
                echo "$a1,$a2,$a3,$a4" >> bb.txt
                b1=$a1
                b2=$a2
                b3=$a3
                b4=$a4
        else
                if [ -z $a1 ];then
                        a1=$b1
                fi
                if [ -z $a2 ];then
                        a2=$b2
                fi
                if [ -z $a3 ];then
                        a3=$b3
                fi
                if [ -z $a4 ];then
                        a4=$b4
                fi
                echo  "$a1,$a2,$a3,$a4" >> bb.txt
        fi
done


打酱油的2537
 awk -F","  '{if($3){b=null;for(i=3;i<=NF;i++){b=b","$i}print $0}else{$0=$0b;gsub(/,+/,",",$0);print $0}}' 文件

 
蓝玉龙3275
 awk -F"," '{if(FNR==1){tmp3=$3;tmp4=$4;}if($3==null)$3=tmp3;if($4==null)$4=tmp4;tmp3=$3;tmp4=$4;a[FNR]=$1","$2","$3","$4; print a[FNR]}' 1.txt

 

 
 awk -F, 'BEGIN{OFS=","}                     
{
for(i=1;i<5;++i)
  if(length($i)==0) 
    $i = rec[i];
split($0,rec);
print
}' in_file


 awk -F"," 'BEGIN{OFS=","}{if($3){th=$3;fo=$4;print $0}else{print $1,$2,th,fo}}' yourfile 


 

awk -F, '{
for(i = 1; i <= NF; i++) {
    a[i] = $i != "" ? $i : a[i];
}
printf("%s %s %s %s\n", a[1], a[2], a[3], a[4])}' file

name1 1 21 address1
name2 0 21 address1
name3 0 21 address1
name4 1 30 address4
name5 0 24 address5
name6 1 24 address5
name7 1 29 address7