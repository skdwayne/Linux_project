# Git #


    Workspace：工作区
    Index / Stage：暂存区
    Repository：仓库区（或本地仓库）
    Remote：远程仓库

一、新建代码库
    # 在当前目录新建一个Git代码库
    $ git init
    # 新建一个目录，将其初始化为Git代码库
    $ git init [project-name]
    # 下载一个项目和它的整个代码历史
    $ git clone [url]

二、配置

Git的设置文件为.gitconfig，它可以在用户主目录下（全局配置），也可以在项目目录下（项目配置）。

    # 显示当前的Git配置
    $ git config --list
    # 编辑Git配置文件
    $ git config -e [--global]
    # 设置提交代码时的用户信息
    $ git config [--global] user.name "[name]"
    $ git config [--global] user.email "[email address]"

三、增加/删除文件

    # 添加指定文件到暂存区
    $ git add [file1] [file2] ...
    # 添加指定目录到暂存区，包括子目录
    $ git add [dir]
    # 添加当前目录的所有文件到暂存区
    $ git add .
    # 删除工作区文件，并且将这次删除放入暂存区
    $ git rm [file1] [file2] ...
    # 停止追踪指定文件，但该文件会保留在工作区
    $ git rm --cached [file]
    # 改名文件，并且将这个改名放入暂存区
    $ git mv [file-original] [file-renamed]

四、代码提交

    # 提交暂存区到仓库区，-m后面输入的是本次提交的说明，可以输入任意内容，当然最好是有意义的，这样你就能从历史记录里方便地找到改动记录
    $ git commit -m [message]
    # 提交暂存区的指定文件到仓库区
    $ git commit [file1] [file2] ... -m [message]
    # 提交工作区自上次commit之后的变化，直接到仓库区
    $ git commit -a
    # 提交时显示所有diff信息
    $ git commit -v
    # 使用一次新的commit，替代上一次提交
    # 如果代码没有任何新变化，则用来改写上一次commit的提交信息
    $ git commit --amend -m [message]
    # 重做上一次commit，并包括指定文件的新变化
    $ git commit --amend [file1] [file2] ...

五、分支

    # 列出所有本地分支
    $ git branch
    # 列出所有远程分支
    $ git branch -r
    # 列出所有本地分支和远程分支
    $ git branch -a
    # 新建一个分支，但依然停留在当前分支
    $ git branch [branch-name]
    # 新建一个分支，并切换到该分支
    $ git checkout -b [branch]
    # 新建一个分支，指向指定commit
    $ git branch [branch] [commit]
    # 新建一个分支，与指定的远程分支建立追踪关系
    $ git branch --track [branch] [remote-branch]
    # 切换到指定分支，并更新工作区
    $ git checkout [branch-name]

    # 建立追踪关系，在现有分支与指定的远程分支之间

    $ git branch --set-upstream [branch] [remote-branch]

    # 合并指定分支到当前分支

    $ git merge [branch]

    # 选择一个commit，合并进当前分支

    $ git cherry-pick [commit]

    # 删除分支

    $ git branch -d [branch-name]

    # 删除远程分支

    $ git push origin --delete [branch-name]

    $ git branch -dr [remote/branch]


六、标签


    # 列出所有tag

    $ git tag

    # 新建一个tag在当前commit

    $ git tag [tag]

    # 新建一个tag在指定commit

    $ git tag [tag] [commit]

    # 查看tag信息

    $ git show [tag]

    # 提交指定tag

    $ git push [remote] [tag]

    # 提交所有tag

    $ git push [remote] --tags

    # 新建一个分支，指向某个tag

    $ git checkout -b [branch] [tag]


七、查看信息


    # 显示有变更的文件

    $ git status

    # 显示当前分支的版本历史

    $ git log

    # 显示commit历史，以及每次commit发生变更的文件

    $ git log --stat

    # 显示某个文件的版本历史，包括文件改名

    $ git log --follow [file]

    $ git whatchanged [file]

    # 显示指定文件相关的每一次diff

    $ git log -p [file]

    # 显示指定文件是什么人在什么时间修改过

    $ git blame [file]

    # 显示暂存区和工作区的差异

    $ git diff

    # 显示暂存区和上一个commit的差异

    $ git diff --cached [file]

    # 显示工作区与当前分支最新commit之间的差异

    $ git diff HEAD

    # 显示两次提交之间的差异

    $ git diff [first-branch]...[second-branch]

    # 显示某次提交的元数据和内容变化

    $ git show [commit]

    # 显示某次提交发生变化的文件

    $ git show --name-only [commit]

    # 显示某次提交时，某个文件的内容

    $ git show [commit]:[filename]

    # 显示当前分支的最近几次提交

    $ git reflog


八、远程同步


    # 下载远程仓库的所有变动

    $ git fetch [remote]

    # 显示所有远程仓库

    $ git remote -v

    # 显示某个远程仓库的信息

    $ git remote show [remote]

    # 增加一个新的远程仓库，并命名

    $ git remote add [shortname] [url]

    # 取回远程仓库的变化，并与本地分支合并

    $ git pull [remote] [branch]

    # 上传本地指定分支到远程仓库

    $ git push [remote] [branch]

    # 强行推送当前分支到远程仓库，即使有冲突

    $ git push [remote] --force

    # 推送所有分支到远程仓库

    $ git push [remote] --all


九、撤销


    # 恢复暂存区的指定文件到工作区

    $ git checkout [file]

    # 恢复某个commit的指定文件到工作区

    $ git checkout [commit] [file]

    # 恢复上一个commit的所有文件到工作区

    $ git checkout .

    # 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变

    $ git reset [file]

    # 重置暂存区与工作区，与上一次commit保持一致

    $ git reset --hard

    # 重置当前分支的指针为指定commit，同时重置暂存区，但工作区不变

    $ git reset [commit]

    # 重置当前分支的HEAD为指定commit，同时重置暂存区和工作区，与指定commit一致

    $ git reset --hard [commit]

    # 重置当前HEAD为指定commit，但保持暂存区和工作区不变

    $ git reset --keep [commit]

    # 新建一个commit，用来撤销指定commit

    # 后者的所有变化都将被前者抵消，并且应用到当前分支

    $ git revert [commit]


十、其他


    # 生成一个可供发布的压缩包

    $ git archive



git add readme.txt


$ git commit -m "wrote a readme file"
[master (root-commit) cf4b2e8] wrote a readme file
 1 file changed, 1 insertion(+)
 create mode 100644 readme.txt



简单解释一下git commit命令，

git commit命令执行成功后会告诉你，1个文件被改动（我们新添加的readme.txt文件），插入了两行内容（readme.txt有两行内容）。

为什么Git添加文件需要add，commit一共两步呢？因为commit可以一次提交很多文件，所以你可以多次add不同的文件，比如：

$ git add file1.txt
$ git add file2.txt file3.txt
$ git commit -m "add 3 files."



# 小结 #

    初始化一个Git仓库，使用git init命令。

    添加文件到Git仓库，分两步：

    第一步，使用命令git add <file>，注意，可反复多次使用，添加多个文件；

    第二步，使用命令git commit，完成


# 问题 #

    warning: LF will be replaced by CRLF in readme.txt.
    The file will have its original line endings in your working directory.

    git config core.autocrlf false



### 刚创建的github版本库，在push代码时出错： ###

    $ git push -u origin master
    To git@github.com:**/Demo.git
    ! [rejected] master -> master (non-fast-forward)
    error: failed to push some refs to ‘git@github.com:**/Demo.git’
    hint: Updates were rejected because the tip of your current branch is behind
    hint: its remote counterpart. Merge the remote changes (e.g. ‘git pull’)
    hint: before pushing again.
    hint: See the ‘Note about fast-forwards’ in ‘git push –help’ for details.

> 网上搜索了下，是因为远程repository和我本地的repository冲突导致的，而我在创建版本库后，在github的版本库页面点击了创建README.md文件的按钮创建了说明文档，但是却没有pull到本地。这样就产生了版本冲突的问题。

有如下几种解决方法：

    1.使用强制push的方法：

    $ git push -u origin master -f

    这样会使远程修改丢失，一般是不可取的，尤其是多人协作开发的时候。

    2.push前先将远程repository修改pull下来

    $ git pull origin master

    $ git push -u origin master

    3.若不想merge远程和本地修改，可以先创建新的分支：

    $ git branch [name]
    然后push

    $ git push -u origin [name]
