#!/bin/bash
pid=0
clean()
{
        echo $pid
	kill -TERM `ps -ef|grep -v 'grep'|grep mysqld|awk -F" " '{print $2}'`
	wait "$pid"
	exit 143;
}
trap clean TERM
lock=`cat /usr/local/mysql/conf/my.cnf|grep socket|awk -F"=" '{print $2}'|head -n 1`.lock
if [ "`ls -A /home/mysqldata`" = "" ];then
	/usr/local/mysql/bin/mysqld --initialize  --user=mysql --basedir=/usr/local/mysql --datadir=/home/mysqldata >> /tmp/mysql.log 2>&1
	/usr/local/mysql/bin/mysqld_safe &
	sleep 10
	mysqladmin -uroot -p`cat /tmp/mysql.log |grep "root@localhost"|awk -F:" " {'print $2'}` password 111111
	kill -9 `ps -ef|grep -v 'grep'|grep mysqld|awk -F" " {'print $2'}`
fi
if [ -f $lock ];then
	rm -f $lock
fi
/usr/local/mysql/bin/mysqld  --defaults-file=/usr/local/mysql/conf/my.cnf --user=mysql & pid="$!"
while true
do
tail -f /dev/null & wait ${!}
done
