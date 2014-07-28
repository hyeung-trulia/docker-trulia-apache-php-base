#!/bin/bash

yes '' | pecl install ZendOpcache-7.0.3
cat > /etc/php5/mods-available/opcache.ini << EOF
zend_extension=/usr/lib/php5/20121212/opcache.so
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=1
EOF
ln -s /etc/php5/mods-available/opcache.ini /etc/php5/apache2/conf.d/20-opcache.ini
yes '' | pecl install APCu-4.0.6
echo "extension=apcu.so" > /etc/php5/mods-available/apcu.ini
ln -s /etc/php5/mods-available/apcu.ini /etc/php5/apache2/conf.d/20-apcu.ini
# install couchbase with php5.5
wget -O/etc/apt/sources.list.d/couchbase.list http://packages.couchbase.com/ubuntu/couchbase-ubuntu1404.list
wget -O- http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -
apt-get update
apt-get install libcouchbase2-libevent libcouchbase-dev
pecl install couchbase
echo "extension=couchbase.so" > /etc/php5/mods-available/couchbase.ini
ln -s /etc/php5/mods-available/couchbase.ini /etc/php5/apache2/conf.d/20-couchbase.ini
