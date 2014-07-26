#!/bin/bash

function up_start {
	service apache2 stop && service memcached start
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