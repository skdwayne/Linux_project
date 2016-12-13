#!/bin/bash

unzip_path="/tmp/oracle"
RSP_ORACLE_HOME="/u01/app/oracle/product/12c/database_1"

if [[ -d /home/oracle/response ]]
then
	rm -rf /home/oracle/response
	mkdir -p /home/oracle/response
else
	mkdir -p /home/oracle/response
fi

###########################################bash_profile################################################
bash_profile="/home/oracle/.bash_profile"
ORACLE_BASE="/u01/app/oracle"
ORACLE_HOME="\$ORACLE_BASE/product/12c/database_1"
ORACLE_SID="orcl"

flag=`grep "ORACLE" $bash_profile`
if [[ -z $flag ]]
then
	echo "export ORACLE_BASE=$ORACLE_BASE" >> $bash_profile
	echo "export ORACLE_HOME=$ORACLE_HOME" >> $bash_profile
	echo "export ORACLE_SID=$ORACLE_SID" >> $bash_profile
	echo "export PATH=$PATH:$ORACLE_HOME/bin" >> $bash_profile
fi
##########################################################################################################

#######################################db_install#######################################################
db_install_file="/home/oracle/response/db_install.rsp"
#安装的版本 不能更改
grep "oracle.install.responseFileVersion" $unzip_path/database/response/db_install.rsp | grep -v "#" >> $db_install_file

#选择安装类型：1.只装数据库软件 2.安装数据库软件并建库 3.升级数据库
#1.INSTALL_DB_SWONLY
#2.INSTALL_DB_AND_CONFIG
#3.UPGRADE_DB
echo "oracle.install.option=INSTALL_DB_SWONLY" >> $db_install_file

#主机名
echo "ORACLE_HOSTNAME=`hostname`" >> $db_install_file

#指定oracle inventory目录的所有者 通常会是oinstall或者dba
echo "UNIX_GROUP_NAME=dba" >> $db_install_file

#指定产品清单oracle inventory目录的路径
echo "INVENTORY_LOCATION=/u01/app/oracle/oraInventory" >> $db_install_file

#指定数据库语言
echo "SELECTED_LANGUAGES=en,zh_CN" >> $db_install_file

#设置ORALCE_HOME的路径
echo "ORACLE_HOME=$RSP_ORACLE_HOME" >> $db_install_file

#设置ORALCE_BASE的路径
echo "ORACLE_BASE=$ORACLE_BASE" >> $db_install_file

#选择Oracle安装数据库软件的版本 EE=企业版
echo "oracle.install.db.InstallEdition=EE" >> $db_install_file

#设置组
echo "oracle.install.db.DBA_GROUP=dba" >> $db_install_file
echo "oracle.install.db.OPER_GROUP=dba" >> $db_install_file
echo "oracle.install.db.BACKUPDBA_GROUP=dba" >> $db_install_file
echo "oracle.install.db.DGDBA_GROUP=dba" >> $db_install_file
echo "oracle.install.db.KMDBA_GROUP=dba" >> $db_install_file

#选择数据库的用途，一般用途/事物处理，数据仓库
#GENERAL_PURPOSE/TRANSACTION_PROCESSING
#DATA_WAREHOUSE
echo "oracle.install.db.config.starterdb.type=GENERAL_PURPOSE" >> $db_install_file

#指定globalname
echo "oracle.install.db.config.starterdb.globalDBName=globalDBName " >> $db_install_file

#SID
echo "oracle.install.db.config.starterdb.SID=$ORACLE_SID" >> $db_install_file

#字符集
echo "oracle.install.db.config.starterdb.characterSet=AL32UTF8" >> $db_install_file

#密码
echo "oracle.install.db.config.starterdb.password.ALL=oracle" >> $db_install_file
#echo "oracle.install.db.config.starterdb.password.SYS=oracle" >> $db_install_file
#echo "oracle.install.db.config.starterdb.password.SYSTEM=oracle" >> $db_install_file
#echo "oracle.install.db.config.starterdb.password.SYSMAN=oracle" >> $db_install_file
#echo "oracle.install.db.config.starterdb.password.DBSNMP=oracle" >> $db_install_file

#设置安全更新
echo "DECLINE_SECURITY_UPDATES=true" >> $db_install_file
#############################################################################################################

##############################################dbca####################################################
dbca_file="/home/oracle/response/dbca.rsp"

echo "[GENERAL]" >> $dbca_file
grep "RESPONSEFILE_VERSION" $unzip_path/database/response/dbca.rsp | grep -v "#" >> $dbca_file
grep "OPERATION_TYPE" $unzip_path/database/response/dbca.rsp | grep -v "#" >> $dbca_file

#当操作类型选择创建数据库CREATEDATABASE会使用下面的选项
echo "[CREATEDATABASE]" >> $dbca_file
#数据库的全局数据库名称：SID+主机名
echo "GDBNAME = \"${ORACLE_SID}.`hostname`\"" >> $dbca_file
#SID
echo "SID = ${ORACLE_SID}" >> $dbca_file
#模板文件
grep "TEMPLATENAME" $unzip_path/database/response/dbca.rsp | grep -v "#" >> $dbca_file
#####################################################################################################

################################################netca######################################################
netca_file="/home/oracle/response/netca.rsp"

echo "[GENERAL]" >> $netca_file
grep "RESPONSEFILE_VERSION" $unzip_path/database/response/netca.rsp | grep -v "#" >> $netca_file
grep "CREATE_TYPE" $unzip_path/database/response/netca.rsp | grep -v "#" >> $netca_file

#设置是否是安装需要图形界面
echo "SHOW_GUI=false" >> $netca_file

#日志文件
echo "LOG_FILE=\"\"/home/oracle/netca.log\"\"" >> $netca_file

echo "[oracle.net.ca]" >> $netca_file

#安装的组件
grep "INSTALLED_COMPONENTS" $unzip_path/database/response/netca.rsp | grep -v "#" >> $netca_file

#安装的类型
grep "INSTALL_TYPE" $unzip_path/database/response/netca.rsp | grep -v "#" >> $netca_file

#监听器的个数
echo "LISTENER_NUMBER=1" >> $netca_file

#监听器的名字
echo "LISTENER_NAMES={\"LISTENER\"}"  >> $netca_file

#监听地址
echo "LISTENER_PROTOCOLS={\"TCP;1521\"}" >> $netca_file

#启动监听器的名字
echo "LISTENER_START=\"\"LISTENER\"\"" >> $netca_file

#命名的格式
echo "NAMING_METHODS={\"TNSNAMES\",\"ONAMES\",\"HOSTNAME\"}" >> $netca_file

#网络服务名字的个数
echo "NSN_NUMBER=1" >> $netca_file

#网络服务名字
echo "NSN_NAMES={\"EXTPROC_CONNECTION_DATA\"}" >> $netca_file

#oracle数据库名
echo "NSN_SERVICE={\"${ORACLE_SID}.`hostname`\"}" >> $netca_file

#网络协议
echo "NSN_PROTOCOLS={\"TCP;HOSTNAME;1521\"}" >> $netca_file
#######################################################################################################

echo "$unzip_path/database/runInstaller -silent -responseFile $db_install_file"
echo "dbca -silent -createDatabase -responseFile $dbca_file"
echo "netca -silent -responseFile $netca_file"
