
Linux下wget中文编码导致的乱码现象，由于所打开的文件采用的汉字编码方式不同，一般有utf-8 和gb2312两种编码方式，
修改系统的配置文件/etc/vimrc即可：

vim /etc/vimrc
#加入下面语句即可：
set fileencodings=utf-8,gb2312,gbk,gb18030 //支持中文编码
set termencoding=utf-8   
set fileformats=unix
set encoding=prc
