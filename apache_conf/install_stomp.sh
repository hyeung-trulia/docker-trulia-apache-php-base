#!/bin/bash

no '' | pecl install stomp 
cat > /etc/php5/mods-available/stomp.ini << EOF
extension=stomp.so
EOF
ln -s /etc/php5/mods-available/stomp.ini /etc/php5/apache2/conf.d/20-stomp.ini
