# 后台运行shell

## 使用&符号在后台执行命令

你可以在Linux命令或者脚本后面增加&符号，从而使命令或脚本在后台执行，例如：

    $ ./my-shell-script.sh &

## 使用nohup在后台执行命令

使用&符号在后台执行命令或脚本后，如果你退出登录，这个命令就会被自动终止掉。要避免这种情况，你可以使用nohup命令，如下所示：

    $ nohup ./my-shell-script.sh &

## 使用screen执行命令

通过nohup和&符号在后台执行命令后，即使你退出登录，这个命令也会一直执行。但是，你无法重新连接到这个会话，要想重新连接到这个会话，你可以使用screen命令。.

Linux的screen命令提供了分离和重新连接一个会话的功能。当你重新连接这个会话的时候，你的终端和你分离的时候一模一样。

## 使用定时任务

使用at命令，你可以让一个命令在指定的日期和时间运行，例如要在明天上午10点在后台执行备份脚本，执行下面的命令：

    $ at -f backup.sh 10 am tomorrow

在批处理模式下执行某些任务需要启用一些选项。下面的文章会给出详细解释：.

    How To Capture Unix Top Command Output to a File in Readable Format
    Unix bc Command Line Calculator in Batch Mode
    How To Execute SSH and SCP in Batch Mode (Only when Passwordless login is enabled)

## 使用watch连续地执行一个命令

要想按一个固定的间隔不停地执行一个命令，可以使用watch命令，如下所示：

    $ watch df -h
