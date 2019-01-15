#base image
FROM centos

#add configfile
COPY ./files/boost_1_59_0.tar.gz /usr/local/boost/
COPY ./files/setup.sh /tmp/

#yum install base packages

RUN	yum install -y gcc gcc-c++ ncurses-devel libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel autoconf pcre-devel libtool-libs freetype-devel gd zlib-devel zip unzip wget crontabs iptables file bison cmake patch mlocate flex diffutils automake make  readline-devel  glibc-devel glibc-static glib2-devel  bzip2-devel gettext-devel libcap-devel logrotate openssl expect \
	&& groupadd mysql \
	&& useradd -s /sbin/nologin -g mysql mysql \
	&& cd /mnt \
	&& wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.24.tar.gz -O - | tar -zx \
	&& cd mysql-5.7.24 \
	&& cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DSYSCONFDIR=/usr/local/mysql/conf -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=complex -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1  -DWITH_BOOST=/usr/local/boost \
	&& make -j 4 && make install \
	&& chmod +w /usr/local/mysql \
	&& chown -R mysql:mysql /usr/local/mysql \
	&& mkdir /home/mysqldata \
	&& chown -R mysql:mysql /home/mysqldata \
	&& echo "/usr/local/mysql/lib/mysql\n/usr/local/lib\n" > /etc/ld.so.conf.d/mysql.conf \
	&& ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql \
	&& ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin \
	&& ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump \
	&& ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk \
	&& ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe \
	&& chmod 755 /tmp/setup.sh \
        && rm -rf /usr/local/boost/boost_1_59_0.tar.gz \
        && rm -rf /usr/local/boost/boost_1_59_0 \
	&& yum clean all \
	&& rm -rf /mnt/* \
	&& \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
COPY ./files/my.cnf /usr/local/mysql/conf/

ENTRYPOINT ["/tmp/setup.sh"]
