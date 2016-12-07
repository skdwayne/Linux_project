[root@localhost ~]# echo '127.0.0.1 = localhost'|grep -Po '=\s\K.*'
localhost


[root@localhost ~]# grep -Po '(^[^ ]+).*\1' 123
qujian --- qujian
chiling --- achiling
lihao  ---   alihao
[root@localhost ~]# grep -Po '(^[^ ]+).*\1\w+' 123
qujian --- qujian123
chiling --- achiling999
lihao  ---   alihao123




[root@localhost ~]# ifconfig eth0|grep -Po --color '\w:\K.*(?=  B)'
10.0.0.7

[root@localhost ~]# cat 1
127   127ip1
abc  abc123
baidu google123
123	123sina
[root@localhost ~]# grep -Po '(\w+)\s.*\1\w+' 1
127   127ip1
abc  abc123
123	123sina
[root@localhost ~]# grep -Po '(^[^ ]).*\1\w+' 1
127   127ip1
abc  abc123
123	123sina
[root@localhost ~]# grep -Po '(^.*)\s.*\1\w+' 1
127   127ip1
abc  abc123
123	123sina


He like his liker.
		He like his lover.
		She love her liker.
		She love her lover.
	1、删除以上内容当中包含单词“l..e”前后一致的行；
	2、将文件中“l..e”前后一致的行中，最后一个l..e词首的l换成大写L；



[root@localhost ~]# grep -Po '<([Hh].>).*\1' 2
<H1>welcome to my homepage</H1>
<h2>welcome to my homepage</h2>
<h3>welcome to my homepage</h3>
[root@localhost ~]# cat 2
<div>hello world</div>
<H1>welcome to my homepage</H1>
<div>hello world</div>
<h2>welcome to my homepage</h2>
<div>hello world</div>
<h3>welcome to my homepage</h3>
<div>hello world</div>
