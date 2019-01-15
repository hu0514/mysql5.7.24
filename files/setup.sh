#!/bin/bash
lock=`cat /usr/local/mysql/conf/my.cnf|grep socket|awk -F"=" '{print $2}'|head -n 1`.lock
if [ "`ls -A /home/mysqldata`" = "" ];then
	/usr/local/mysql/bin/mysqld --initialize  --user=mysql --basedir=/usr/local/mysql --datadir=/home/mysqldata >> /tmp/mysql.log 2>&1
	/usr/local/mysql/bin/mysqld_safe &
	sleep 5
	mysqladmin -uroot -p`cat /tmp/mysql.log |grep "root@localhost"|awk -F:" " {'print $2'}` password 111111
	mysql -uroot -p111111 -e "create user 'root'@'%' identified by'111111';"
	mysql -uroot -p111111 -e "grant all privileges on *.* to 'root'@'%' with grant option;"
	mysql -uroot -p111111 -e "flush privileges;"
	/usr/local/mysql/support-files/mysql.server stop
fi
if [ -f $lock ];then
	rm -f $lock
fi
exec /usr/local/mysql/bin/mysqld 
