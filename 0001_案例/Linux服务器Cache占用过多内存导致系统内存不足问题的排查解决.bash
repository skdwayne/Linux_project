Linux服务器Cache占用过多内存导致系统内存不足问题的排查解决






Linux服务器Cache占用过多内存导致系统内存不足问题的排查解决


网址: http://www.cnblogs.com/panfeng412/archive/2013/12/10/drop-caches-under-linux-system.html

问题描述
Linux服务器内存使用量超过阈值，触发报警。

问题排查
首先，通过free命令观察系统的内存使用情况，显示如下：

             total       used       free     shared    buffers     cached
Mem:      24675796   24587144      88652          0     357012    1612488
-/+ buffers/cache:   22617644    2058152
Swap:      2096472     108224    1988248
其中，可以看出内存总量为24675796KB，已使用22617644KB，只剩余2058152KB。

然后，接着通过top命令，shift + M按内存排序后，观察系统中使用内存最大的进程情况，发现只占用了18GB内存，其他进程均很小，可忽略。

因此，还有将近4GB内存（22617644KB-18GB，约4GB）用到什么地方了呢？

进一步，通过cat /proc/meminfo发现，其中有将近4GB（3688732 KB）的Slab内存：

......
Mapped:          25212 kB
Slab:          3688732 kB
PageTables:      43524 kB
......
Slab是用于存放内核数据结构缓存，再通过slabtop命令查看这部分内存的使用情况：

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
13926348 13926348 100%    0.21K 773686       18   3494744K dentry_cache
334040 262056  78%    0.09K   8351       40     33404K buffer_head
151040 150537  99%    0.74K  30208        5    120832K ext3_inode_cache
发现其中大部分（大约3.5GB）都是用于了dentry_cache。

问题解决
1. 修改/proc/sys/vm/drop_caches，释放Slab占用的cache内存空间（参考drop_caches的官方文档）：

复制代码
Writing to this will cause the kernel to drop clean caches, dentries and inodes from memory, causing that memory to become free.
To free pagecache:
* echo 1 > /proc/sys/vm/drop_caches
To free dentries and inodes:
* echo 2 > /proc/sys/vm/drop_caches
To free pagecache, dentries and inodes:
* echo 3 > /proc/sys/vm/drop_caches
As this is a non-destructive operation, and dirty objects are notfreeable, the user should run "sync" first in order to make sure allcached objects are freed.
This tunable was added in 2.6.16.
复制代码
2. 方法1需要用户具有root权限，如果不是root，但有sudo权限，可以通过sysctl命令进行设置：

$sync
$sudo sysctl -w vm.drop_caches=3
$sudo sysctl -w vm.drop_caches=0 #recovery drop_caches
操作后可以通过sudo sysctl -a | grep drop_caches查看是否生效