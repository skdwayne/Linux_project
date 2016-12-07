
### 镜像操作

    docker search  镜像名                     #从docker官方仓库搜索镜像
    docker pull centos                       #下载centos镜像
    docker save centos > /opt/centos.tar.gz  #镜像导出
    docker load < /opt/centos.tar.gz         #镜像导入
    docker images                            #查看本机存在的镜像

【示例】
    docker search centos
    docker pull centos:6   ### 如果不指定tag，默认下载latest




### 容器操作

    docker run -i -t centos:6 /bin/bash

    -i:开启交互式shell
    -t:为容器分配一个伪tty终端
    -d:以守护进程方式运行docker容器
    --name:
    centos：指定镜像的名字
    docker start 5eb5ee832f57  ##启动刚刚退出的容器，也可以使用NAME

>进入容器

    docker attach 77079090e085
    docker inspect --format "{{ .State.Pid }}" d09969389b95
    nsenter --target 43964 --mount --uts --ipc --net --pid
    

>编写脚本，进入容器

    [root@vir ~]# cat docker_in.sh 
    #!/bin/bash
    
    # Use nsenter to access docker
    
    docker_in(){
       NAME_ID=$1
       PID=$(docker inspect -f "{{ .State.Pid }}" $NAME_ID) 
       nsenter -t $PID -m -u -i -n -p
    }
    docker_in $1


提交镜像

    docker commit -m "centos6_http_server" d09969389b95 yjj/httpd:v1


