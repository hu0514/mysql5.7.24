#!/bin/bash
data_path=/data/mysql5.7
default_file=/usr/local/mysql/conf/my.cnf
mysql_path=/usr/local/mysql

if [ -z ${MYSQL_ROOT_PWD} ];then
	MYSQL_ROOT_PWD='1234,abcd'
fi
if [ -z ${MYSQL_ROOT_HOST} ];then
	MYSQL_ROOT_HOST=%
fi

if [ ! -d ${data_path} ];then
	mkdir -p ${data_path}
	chmod -R 755 ${data_path}
	chown -R mysql:mysql ${data_path}
	cp ${default_file} /etc/my.cnf
	${mysql_path}/bin/mysqld --initialize-insecure
	cp ${default_file} ${data_path}/my.cnf	
	${mysql_path}/support-files/mysql.server start
	echo "123"
	${mysql_path}/bin/mysqladmin -uroot password ${MYSQL_ROOT_PWD}
	echo ${MYSQL_ROOT_PWD}
	sql="CREATE USER 'root'@'${MYSQL_ROOT_HOST}' IDENTIFIED BY'${MYSQL_ROOT_PWD}';GRANT ALL PRIVILEGES ON *.* TO 'root'@'${MYSQL_ROOT_HOST}' WITH GRANT OPTION;FLUSH PRIVILEGES;"
	${mysql_path}/bin/mysql -uroot -p${MYSQL_ROOT_PWD} -e "${sql}"
	${mysql_path}/support-files/mysql.server stop
	sleep 1
	echo "MYSQL START SUCCESS..."
	exec ${mysql_path}/bin/mysqld 
elif [ ! -f ${data_path}/my.cnf ];then
	rm -rf /etc/my.cnf
	cp ${default_file} /etc/my.cnf
	cp ${default_file} ${data_path}/my.cnf
	chown mysql:mysql /etc/my.cnf
	chmod 644 /etc/my.cnf
        if [ -f /tmp/mysql.sock.lock ];then
                rm -rf /tmp/mysql.sock.lock
        fi
	echo "MYSQL START SUCCESS..."
	exec ${mysql_path}/bin/mysqld 
else
	rm -rf /etc/my.cnf
	cp ${data_path}/my.cnf /etc/my.cnf
	chown mysql:mysql /etc/my.cnf
	chmod 644 /etc/my.cnf
	echo "234"
	if [ -f /tmp/mysql.sock.lock ];then
		rm -rf /tmp/mysql.sock.lock
	fi
	echo "MYSQL START SUCCESS..."
	exec ${mysql_path}/bin/mysqld 
	
fi


