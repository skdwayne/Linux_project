
# test用法

## 基本格式：

> test expression

    expression为test命令构造的表达式。
    这里expression是test命令可以理解的任何有效表达式，该简化格式将是读者可能会踫见的最常用格式
    返回值：
    test命令或者返回0(真) 或者返回1(假).

    test可理解的表达式类型分为四类：

        - 表达式判断
        - 字符串比较
        - 数字比较
        - 文件比较

#### 1）判断表达式

    if test  (表达式为真)
    if test !表达式为假
    test 表达式1 –a 表达式 2        两个表达式都为真
    test 表达式1 –o 表达式2         两个表达式有一个为真

### 2）判断字符串

    test –n 字符串                 字符串的长度非零
    test –z 字符串                 字符串的长度为零
    test 字符串  1  ＝字符串 2         字符串相等
    test 字符串  1 !＝字符串 2         字符串不等

#### 3）判断整数,符号只能用于整数，如果用字符串则会报错（此时可以使用字符串判断上述）

    test 整数 1 –eq 整数2          整数相等
    test 整数 1 –ge 整数2          整数1大于等于整数2
    test 整数 1 –gt 整数 2         整数1大于整数2
    test 整数 1 –le 整数 2         整数1小于等于整数2
    test 整数 1 –lt 整数 2         整数1小于整数2
    test 整数 1 –ne 整数 2         整数1不等于整数2

    if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ];then
        echo "   "
    else #do nothing
    fi

#### 4）判断文件

    test  File1 –ef  File2             两个文件具有同样的设备号和i结点号
    test  File1 –nt  File2             文件1比文件2 新
    test  File1 –ot  File2             文件1比文件2 旧
    test –b File            文件存在并且是块设备文件
    test –c File            文件存在并且是字符设备文件
    test –d File            文件存在并且是目录
    test –e File            文件存在
    test –f File            文件存在并且是正规文件
    test –g File            文件存在并且是设置了组ID
    test –G File            文件存在并且属于有效组ID
    test –h File            文件存在并且是一个符号链接（同-L）
    test –k File            文件存在并且设置了sticky位
    test –b File            文件存在并且是块设备文件
    test –L File            文件存在并且是一个符号链接（同-h）
    test –o File            文件存在并且属于有效用户ID
    test –p File            文件存在并且是一个命名管道
    test –r File            文件存在并且可读
    test –s File            文件存在并且是一个套接字
    test –t FD              文件描述符是在一个终端打开的
    test –u File            文件存在并且设置了它的set-user-id位
    test –w File            文件存在并且可写
    test –x File            文件存在并且可执行

**test xxx 可以简写成 [  xxx  ] 的形式。**

注意：在使用"["简写test时，**左中括号后面的空格和右括号前面的空格是必需的**，如果没有空格，Shell不可能辨别表达式何时开始何时结束．

也就是说

    test option file

可以全部改写成：

    [ option file ]

例如:

    test –w File

改写成    

    [ –w File ]

【示例】

    //判断第一个参数是否为空字符串，不空则打印
    if test -n "$1"
    then
    echo "$1"
    fi

测试，放到文件当中
    #!/bin/sh
    if test -n "$1"
    then
    echo "$1"
    fi

执行
    chmod +x test.sh
    ./test.sh abc



