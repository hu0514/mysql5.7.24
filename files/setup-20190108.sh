#!/bin/bash
/usr/local/mysql/bin/mysqld --initialize  --user=mysql --basedir=/usr/local/mysql --datadir=/home/mysqldata >> /tmp/mysql.log 2>&1
/usr/local/mysql/bin/mysqld_safe &
sleep 10
mysqladmin -uroot -p`cat /tmp/mysql.log |grep "root@localhost"|awk -F:" " {'print $2'}` password 111111
kill -9 `ps -ef|grep -v 'grep'|grep mysqld|awk -F" " {'print $2'}`
/usr/local/mysql/bin/mysqld_safe
