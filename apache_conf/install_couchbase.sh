#!/bin/bash
# install couchbase with php5.5
wget -O/etc/apt/sources.list.d/couchbase.list http://packages.couchbase.com/ubuntu/couchbase-ubuntu1404.list
wget -O- http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -
apt-get update
apt-get -y install libcouchbase2-libevent libcouchbase-dev
pecl install couchbase-1.2.2
echo "extension=couchbase.so" > /etc/php5/mods-available/couchbase.ini
ln -s /etc/php5/mods-available/couchbase.ini /etc/php5/apache2/conf.d/90-couchbase.ini
php5enmod couchbase
