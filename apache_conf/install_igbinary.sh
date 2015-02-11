#!/bin/bash

pecl install igbinary.so
cat > /etc/php5/mods-available/igbinary.ini << EOF
extension=igbinary.so
EOF
ln -s /etc/php5/mods-available/igbinary.ini /etc/php5/apache2/conf.d/20-igbinary.ini
