#!/bin/bash
#Author: ZhangShijie
#Date:20161031
#Project:销管系统

#文件与目录变量
MOBILE_FILE=SmaMobile.war.zip
MOBILE_NAME=SmaMobile
PC_FILE=CustomerApp.war.zip
PC_NAME=CustomerApp
S_DIRETORY=/opt/ftpsite/xiaoguan
D_DIRETORY=/apps/tomcat_appdir

#日志日期和时间变量
LOG_CDATE=`date "+%Y-%m-%d"` #如果执行的话后面执行的时间都一样，因此此时间是不固定的，这是用于记录日志生成的时间
LOG_CTIME=`date  "+%H-%M-%S"`

#代码打包时间变量
CDATE=$(date "+%Y-%m-%d")
CTIME=$(date "+%H-%M-%S")

#脚本位置等变量
SHELL_NAME="deploy.sh"
SHELL_DIR="/home/www"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}.LOG"
LOCK_FILE="/tmp/deploy.lock"

#获取Jenkins传递的参数
METHOD=$1
GROUP_LIST=$2
VERSION=$3

#通过jenkins传递参数定义PC端服务器列表
if [[ ${GROUP_LIST} == "1" ]];then
    PC_LIST="10.2.11.128"
    echo "第一次上线，上线服务器为${PC_LIST},线上HA负载在线服务器为${PC_LIST}"
    sleep 2
elif [[ ${GROUP_LIST} == "2" ]];then
    PC_LIST="10.2.11.199 10.2.11.204"
    echo "第二次上线，上线服务器为${PC_LIST},线上HA负载在线服务器为${PC_LIST}"
    sleep 2
elif [[ ${GROUP_LIST} == "3" ]];then
    PC_LIST="10.2.11.128 10.2.11.199 10.2.11.204"
    echo "第三次上线,将第一次的服务器添加到负载当中，最终线上HA负载在线服务器为${PC_LIST}"
    #exit 3
else
    echo "参数 error"
    exit 3
fi

writelog(){
	LOGINFO=$1
	echo "${CDATE} ${CTIME}: ${SHELL_NAME}:${LOGINFO}" >> ${SHELL_LOG}
}

copy_file(){
    if test -f /opt/ftpsite/xiaoguan/CustomerApp.war.zip;then
	PKG_NAME="${PC_NAME}"_"${CDATE}"_"${CTIME}"
	echo "开始复制销管系统上线文件......"
	mv ${S_DIRETORY}/${PC_FILE}  ${S_DIRETORY}/${PKG_NAME}.war.zip
	for node in ${PC_LIST};do #循环服务器节点列表
	    scp -P 30022  ${S_DIRETORY}/${PKG_NAME}.war.zip  www@$node:/apps/tomcat_appdir  #将压缩后的代码包复制到web服务器的/opt/webroot
	    ssh -p 30022 ${node} "cd /apps/tomcat_appdir && unzip  ${PKG_NAME}.war.zip -d /apps/tomcat_webdir/${PKG_NAME} && rm -rf  /apps/tomcat/webapps/CustomerApp && ln -sv /apps/tomcat_webdir/${PKG_NAME}  /apps/tomcat/webapps/CustomerApp"
	if [ $? -eq 0 ];then
    	    echo "销管项目移动端端服务器${node}上线文件复制完成"
    	    echo "发送邮件中。。。"
    	    echo "销管项目移动端端服务器${node}文件复制并发部署完成" |  mail -s "复制文件完成" 1669121886@qq.com 
	else
	    echo "销管项目移动端端服务器${node} 部署失败" |  mail -s "部署失败" 1669121886@qq.com     
	fi
	done
    else
	echo "上线文件CustomerApp.war.zip不存在"
	exit 3
    fi
}

stop_service(){
    if [ ${METHOD} == "deploy" ];then #假如是上线部署
	if test -f /opt/ftpsite/xiaoguan/CustomerApp.war.zip;then #先判断上线文件是不是存在
    	    for node in ${PC_LIST};do #循环服务器节点列表
            ssh -p 30022  www@${node} "/etc/init.d/tomcat stop"
            done
	else
	   echo "CustomerApp.war.zip文件不存在"
	   exit 4
        fi
    else
        for node in ${PC_LIST};do #假如不是上线，即是回滚和任意版本的回滚，就先循环服务器节点列表停服务
        ssh -p 30022  www@${node} "/etc/init.d/tomcat stop"
        done      
    fi
}

start_service(){
    for node in ${PC_LIST};do #循环服务器节点列表
    ssh -p 30022  www@${node} "/etc/init.d/tomcat start"
    done
}

#回滚到指定版本
rollback_designated(){
    for node in ${PC_LIST};do
	ssh -p 30022  www@${node} "rm -rf /apps/tomcat/webapps/CustomerApp  && ln -sv /apps/tomcat_webdir/${VERSION} /apps/tomcat/webapps/CustomerApp  && echo "${node} 回滚到指定版本成功!""
    done
}

#一键回滚到上一版本
rollback_last_version(){
    for node in ${PC_LIST};do
        NAME=`ssh -p 30022  www@${node}  ""/bin/ls -l  -rt /apps/tomcat_webdir | awk '{print $9}' | tail -n 2 | head -n1""`
	ssh -p 30022  www@${node}  "rm -rf /apps/tomcat/webapps/CustomerApp && ln -sv /apps/tomcat_webdir/${NAME} /apps/tomcat/webapps/CustomerApp && echo "${node} 一键回滚到上一版本成功""
    done
}

usage(){
    echo "使用方法为[shell脚本  deploy|rollback]"
}

main(){
    DEPLOY_METHOD=$1
    ROLLBACK_VER=$3
        case ${DEPLOY_METHOD}  in
	deploy)
	    stop_service;
	    copy_file;
 	    start_service;
	    ;;
	rollback_designated)
	    stop_service;
	    rollback_designated;
	    start_service;
	    ;;
	rollback_lastversion)
	    rollback_last_version;
	    ;;
	*)
	    usage;
	esac;
}
main $1 $2 $3
