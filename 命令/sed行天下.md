# 功能说明

Sed是Stream Editor(流编辑器)缩写，是操作、过滤和转换文本内容的强大工具。常用功能有增删改查，过滤，取行。

    [root@oldboy ~]# sed --version  #→ sed软件版本
    GNU sed version 4.2.1
# 语法格式

    sed [options] [sed-commands] [input-file]
    sed [选项] [sed命令]  [输入文件]
    说明：
    1. 注意sed和后面的选项之间至少有一个空格。
    2. 为了避免混淆，本文称呼sed为sed软件。sed-commands(sed命令)是sed软件内置的一些命令选项，为了和前面的options(选项)区分，故称为sed命令。
    3. sed-commands既可以是单个sed命令，也可以是多个sed命令组合。
    4. input-file(输入文件)是可选项，sed还能够从标准输入如管道获取输入。

# 命令执行流程


概括流程：Sed软件从文件或管道中读取一行，处理一行，输出一行；再读取一行，再处理一行，再输出一行……

**模式空间:sed软件内部的一个临时缓存，用于存放读取到的内容。**

# 使用范例

## 1. 统一实验文本

```bash
    #创建包含下面内容的文件，后面的操作都会使用这个文件。
    [root@oldboy ~]# cat person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
```

## 2. 增删改查

### 2.1 增

> - a 追加文本到指定行后
> - i 插入文本到指定行前

#### 2.1.1 单行增加

```bash
    [root@oldboy ~]# sed '2a 106,dandan,CSO' person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    106,dandan,CSO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed '2i 106,dandan,CSO' person.txt
    101,oldboy,CEO
    106,dandan,CSO
    102,zhangyao,CTO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
```

#### 2.1.2 多行增加

```bash
    [root@oldboy ~]# sed '2a 106,dandan,CSO\n107,bingbing,CCO' person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    106,dandan,CSO #→第1种写法
    107,bingbing,CCO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed '2a 106,dandan,CSO \
    > 107,bingbing,CCO' person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    106,dandan,CSO #→第2种写法
    107,bingbing,CCO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO

    sed命令i的使用方法是一样的，因此不再列出。
```

企业案例1：优化SSH配置（一键完成增加若干参数）

在我们学习系统优化时，有一个优化点：更改ssh服务远程登录的配置。主要的操作是在ssh的配置文件加入下面5行文本。(下面参数的具体含义见其他课程。)

```bash
    Port 52113
    PermitRootLogin no
    PermitEmptyPasswords no
    UseDNS no
    GSSAPIAuthentication no
```

我们可以使用vi命令编辑这个文本，但这样就比较麻烦，现在想一条命令增加5行文本到第13行前？

#### 指定执行的地址范围

    sed软件可以对单行或多行进行处理。如果在sed命令前面不指定地址范围，那么默认会匹配所有行。

    用法：n1[,n2]{sed-commands}
    地址用逗号分隔的，n1,n2可以用数字、正则表达式、或二者的组合表示。
    例子：

```bash
    10{sed-commands}对第10行操作
    10,20{sed-commands} 对10到20行操作,包括第10,20行
    10，+20{sed-commands}   对10到30(10+20)行操作,包括第10,30行
    1~2{sed-commands}   对1,3,5,7,……行操作
    10，${sed-commands} 对10到最后一行($代表最后一行)操作,包括第10行
    /oldboy/{sed-commands} 对匹配oldboy的行操作
    /oldboy/,/Alex/{sed-commands}  对匹配oldboy的行到匹配Alex的行操作
    /oldboy/,${sed-commands}   对匹配oldboy的行到最后一行操作
    /oldboy/,10{sed-commands}  对匹配oldboy的行到第10行操作，注意：如果前10行没有匹配到oldboy，sed软件会显示10行以后的匹配oldboy的行，如果有。
    1,/Alex/{sed-commands} 对第1行到匹配Alex的行操作
    /oldboy/,+2{sed-commands}  对匹配oldboy的行到其后的2行操作
```

### 2.2 删

> d 删除指定的行

```bash
    [root@oldboy ~]# sed 'd' person.txt
    [root@oldboy ~]#
    [root@oldboy ~]# sed '2d' person.txt
    101,oldboy,CEO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed '2,5d' person.txt
    101,oldboy,CEO
    [root@oldboy ~]# sed '3,$d' person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    [root@oldboy ~]# sed '1~2d' person.txt
    102,zhangyao,CTO
    104,yy,CFO
    [root@oldboy ~]# sed  '1,+2d' person.txt
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed '/zhangyao/d' person.txt
    101,oldboy,CEO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed '/oldboy/,/Alex/d' person.txt
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed '/oldboy/,3d' person.txt
    104,yy,CFO
    105,feixue,CIO
```

#### 企业案例2：打印文件内容但不包含oldboy

```bash
    [root@oldboy ~]# sed '/oldboy/d' person.txt #→删除包含"oldboy"的行
    102,zhangyao,CTO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
```

### 2.3 改

#### 2.3.1 按行替换

> c 用新行取代旧行

```bash
    [root@oldboy ~]# sed '2c 106,dandan,CSO' person.txt
    101,oldboy,CEO
    106,dandan,CSO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
```

#### 2.3.2 文本替换

> s：单独使用→将每一行中第一处匹配的字符串进行替换 ==>sed命令 
g：每一行进行全部替换 ==>sed命令s的替换标志之一，非sed命令 
-i：修改文件内容 ==>sed软件的选项

sed软件替换模型(方框▇被替换成三角▲)

```bash
    sed -i 's/▇/▲/g' oldboy.log
    sed -i 's#▇#▲#g' oldboy.log
```

观察特点

1. 两边是引号，引号里面的两边分别为s和g，中间是三个一样的字符/或#作为定界符。#能在替换内容包含/有助于区别。定界符可以是任意符号如:或|等，但当替换内容包含定界符时，需转义即: |。经过长期实践，建议大家使用#作为定界符。
2. 定界符/或#，第一个和第二个之间的就是被替换的内容，第二个和第三个之间的就是替换后的内容。
3. s#▇#▲#g，▇能用正则表达式，但▲不能用，必须是具体的。
4. 默认sed软件是对模式空间(内存中的数据)操作，而-i选项会更改磁盘上的文件内容。

```bash
    [root@oldboy ~]# sed 's#zhangyao#oldboyedu#g' person.txt
    101,oldboy,CEO
    102,oldboyedu,CTO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# cat person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed -i 's#zhangyao#BBB#g' person.txt
    [root@oldboy ~]# cat person.txt
    101,oldboy,CEO
    102,BBB,CTO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed -i 's#oldboyedu#zhangyao#g' person.txt #→还原测试文件
```

#### 企业案例3：指定行修改配置文件

指定行精确修改配置文件，这样可以防止修改多了地方。

    [root@oldboy ~]# sed '3s#0#9#' person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    193,Alex,COO
    104,yy,CFO
    105,feixue,CIO

### 2.3.3 变量替换

```bash
    [root@oldboy ~]# cat test.txt #→再新建一个文本
    a
    b
    a
    [root@oldboy ~]# x=a
    [root@oldboy ~]# y=b
    [root@oldboy ~]# echo $x $y
    a b
    [root@oldboy ~]# sed s#$x#$y#g test.txt
    b
    b
    b
    [root@oldboy ~]# sed 's#$x#$y#g' test.txt
    a
    b
    a
    [root@oldboy ~]# sed 's#'$x'#'$y'#g' test.txt
    b
    b
    b
    [root@oldboy ~]# sed "s#$x#$y#g" test.txt
    b
    b
    b
    [root@oldboy ~]# eval sed 's#$x#$y#g' test.txt
    b
    b
    b
```

### 2.3.4 分组替换\( \)和\1的使用说明

sed软件的\( \)的功能可以记住正则表达式的一部分，其中，\1为第一个记住的模式即第一个小括号中的匹配内容，\2第二记住的模式，即第二个小括号中的匹配内容，sed最多可以记住9个。

例：echo I am oldboy teacher.如果想保留这一行的单词oldboy，删除剩下的部分，使用圆括号标记想保留的部分。

    [root@oldboy ~]# echo I am oldboy teacher. |sed 's#^.*am \([a-z].*\) tea.*$#\1#g'
    oldboy
    [root@oldboy ~]# echo I am oldboy teacher. |sed -r 's#^.*am ([a-z].*) tea.*$#\1#g'
    oldboy
    [root@oldboy ~]# echo I am oldboy teacher. |sed -r 's#I (.*) (.*) teacher.#\1\2#g'
    amoldboy

#### 命令说明

思路：用oldboy字符替换I am oldboy teacher.

下面解释用□代替空格

1. ^.*am□ –>这句的意思是以任意字符开头到am□为止，匹配文件中的I am□字符串;
2. \([a-z].*\)□–>这句的外壳就是括号\(\），里面的[a-z]表示匹配26个字母的任何一个，[a-z].*合起来就是匹配任意多个字符，本题来说就是匹配oldboy字符串，由于oldboy字符串是需要保留的,因此用括号括起来匹配，后面通过\1来取oldboy字符串。
3. □tea.*$–>表示以空格tea起始,任意字符结尾，实际就是匹配oldboy字符串后，紧接着的字符串□teacher.;
4. 后面被替换的内容中的\1就是取前面的括号里的内容了，也就是我们要的oldboy字符串。
5. ()是扩展正则表达式的元字符，sed软件默认识别基本正则表达式，想要使用扩展正则需要使用\转义，即\(\）。sed使用-r选项则可以识别扩展正则表达式，此时使用\(\）反而会出错。

企业案例4：系统开机启动项优化

    [root@oldboy ~]# chkconfig --list|grep "3:on"|grep -vE "sshd|crond|network|rsyslog|sysstat"|awk '{print $1}'|sed -r  's#^(.*)#chkconfig \1 off#g'|bash
    [root@oldboy ~]# chkconfig --list|grep "3:on"
    crond   0:off   1:off   2:on3:on4:on5:on6:off
    network 0:off   1:off   2:on3:on4:on5:on6:off
    rsyslog 0:off   1:off   2:on3:on4:on5:on6:off
    sshd0:off   1:off   2:on3:on4:on5:on6:off
    sysstat 0:off   1:on2:on3:on4:on5:on6:off

### 2.3.5 特殊符号&代表被替换的内容

    [root@oldboy ~]# sed '1,3s#C#--&--#g' person.txt #→此处&等于C
    101,oldboy,--C--EO  #→将1到3行的C替换为--C--
    102,zhangyao,--C--TO
    103,yy,--C--OO
    104,feixue,CFO
    105,dandan,CIO


#### 企业案例5：批量重命名文件

当前目录下有文件如下所示：

    [root@oldboy test]# ls
    stu_102999_1_finished.jpg stu_102999_2_finished.jpg stu_102999_3_finished.jpg stu_102999_4_finished.jpg stu_102999_5_finished.jpg
    要求用sed命令重命名，效果为stu_102999_1_finished.jpg==>stu_102999_1.jpg,即删除文件名的_finished

### 2.4 查

> p 输出指定内容，但默认会输出2次匹配的结果，因此使用n取消默认输出

#### 2.4.1 按行查询

```bash
    [root@oldboy ~]# sed '2p' person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    102,zhangyao,CTO
    103,Alex,COO
    104,yy,CFO
    105,feixue,CIO
    [root@oldboy ~]# sed -n '2p' person.txt
    102,zhangyao,CTO
    [root@oldboy ~]# sed -n '2,3p' person.txt
    102,zhangyao,CTO
    103,Alex,COO
    说明：取行就用sed，最简单
    [root@oldboy ~]# sed -n '1~2p' person.txt
    101,oldboy,CEO
    103,Alex,COO
    105,feixue,CIO
    [root@oldboy ~]# sed -n 'p' person.txt
    101,oldboy,CEO
    102,zhangyao,CTO
    103,yy,COO
    104,feixue,CFO
    105,dandan,CIO
```

#### 2.4.2 按字符串查询

```bash
    [root@oldboy ~]# sed -n '/CTO/p' person.txt
    102,zhangyao,CTO
    [root@oldboy ~]# sed -n '/CTO/,/CFO/p' person.txt
    102,zhangyao,CTO
    103,Alex,COO
    104,yy,CFO
```

#### 2.4.3 混合查询

```bash
    [root@oldboy ~]# sed -n '2,/CFO/p' person.txt
    102,zhangyao,CTO
    103,Alex,COO
    104,yy,CFO
    [root@oldboy ~]# sed -n '/feixue/,2p' person.txt
    105,feixue,CIO
    特殊情况，前两行没有匹配到feixue，就向后匹配，如果匹配到feixue就打印此行。
```

# 扩展

> - Ms→对第M行处理，无g，只处理第一处匹配，有g第M行全部替换 
> - Ng→对每一行，从第N处开始替换 
> - Ms、Ng合用表示只对第M行从第N处匹配开始替换

```bash
    cat >num.txt <<EOF
    1 1 1 1 1
    1 1 1 1 1
    1 1 1 1 1
    1 1 1 1 1
    EOF

    sed '2s#1#0#' num.txt
    sed '2s#1#0#g' num.txt
    sed '2s#1#0#2g' num.txt
    sed '2,3s#1#0#2g' num.txt
    sed 's#1#0#2g' num.txt
    sed '2s#1#0#2' num.txt

    sed  "=" person.txt|sed 'N;s#\n# #'

    sed  -n "$=" person.txt
    1. sed -e '3,$d' -e 's#10#01#' person.txt
    2. sed '3,$d;s#10#01#' person.txt
```


