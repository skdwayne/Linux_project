
9.vi/vim	   linux命令行文本编辑器  ===>windows 记事本/文本文档
    1.vi  oldboy.txt
    2.进入命令模式
    3.需要进入编辑模式（insert插入模式） a/i
    4.打字
    5.编辑结束后退出 编辑模式 ====>esc
    6.保存退出  :wq    不保存强制退出  :q!

	vi命令:
	:set nu     :set nonu
	G   移动到文件的最后一行
	gg	移动到文件的第一行（首行）
	ngg	移动到文件的第n行

	yy	复制当前整行
	p	粘贴
	np	粘贴n次，n次数

	dd	剪切当前一行
	ndd	剪切接下来的多少行，包括 光标所在行
	dG	shanchu 剪切当前行到文件结尾
	D/d$	剪切光标后位置到行尾

	x	删除光标位置字符

	u	撤销上一次操作

	消除高亮：:noh