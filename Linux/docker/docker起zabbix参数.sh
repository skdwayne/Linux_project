
docker run \
-d \
--name zabbix-db \
-v /backups:/backups \
-v /docker/zabbix/mysqldata/:/var/lib/mysql \
-v /etc/localtime:/etc/localtime:ro \
--env="MARIADB_USER=zabbix" \
--env="MARIADB_PASS=my_password" \
monitoringartist/zabbix-db-mariadb

docker run \
-d \
--name zabbix \
-p 80:80 \
-p 10051:10051 \
-v /etc/localtime:/etc/localtime:ro \
--link zabbix-db:zabbix.db \
--env="ZS_DBHost=zabbix.db" \
--env="ZS_DBUser=zabbix" \
--env="ZS_DBPassword=my_password" \
--env="PHP_date_timezone=Asia/Shanghai" \
monitoringartist/zabbix-3.0-xxl:latest
