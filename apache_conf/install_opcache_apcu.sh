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

function up_start {
	service apache2 start && service memcached start
}

function configure_apache {
	a2enmod rewrite

	# Create smarty dir
	mkdir -p /data/smarty
	chgrp -R www-data /data/smarty
	chmod -R 770 /data/smarty

	# Grant permisson for writing session info
	chgrp -R www-data /var/lib/php5
	chmod -R 770 /var/lib/php5
	up_start
}

configure_apache