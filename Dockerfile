# FE apache php base container
# base off of ubuntu for now
FROM ubuntu

MAINTAINER Hinling Yeung

# Make DEBIAN_FRONTEND less chatty
ENV DEBIAN_FRONTEND noninteractive

# Update the default application repository sources list
RUN apt-get update

RUN apt-get -y install memcached

# Install apache 2
RUN apt-get -y install apache2

# Install php5
RUN apt-get -y install php5 libapache2-mod-php5 php5-dev

# Install memcached
## RUN apt-get -y install memcached

# Install mysql client
RUN apt-get -y install libapache2-mod-auth-mysql php5-mysql mysql-client

# Install PEAR
RUN apt-get -y install php-pear

# Install phpmods
RUN pear upgrade --force pear
RUN printf "no\n" | pecl install stomp-1.0.5
RUN apt-get -y install libpcre3-dev
RUN apt-get -y install pkg-config
# RUN pecl install APC -- no APC for php5.5
RUN pecl install xdebug
# RUN pecl install memcached

# Install apache libs
RUN apt-get -y install apache2-dev apache2-doc

# Install all the php libraries
RUN apt-get -y install php5-common libapache2-mod-php5 php5-cli
#RUN apt-get -y install php-gd
RUN apt-get -y install php5-mcrypt
RUN apt-get -y install php5-curl
RUN apt-get -y install memcached
RUN apt-get -y install libmemcached-dev
RUN apt-get -y install php5-memcached
## RUN apt-get -y install memcached

# helper tools
RUN apt-get -y install telnet
RUN apt-get -y install wget

# configure apache
RUN a2enmod rewrite
ADD apache_conf/apache2.conf /etc/apache2/apache2.conf
ADD apache_conf/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Install Opcache and APCu
ADD apache_conf/install_opcache_apcu.sh .
RUN ./install_opcache_apcu.sh

# Create smarty dir
RUN mkdir -p /data/smarty
RUN chgrp -R www-data /data/smarty
RUN chmod -R 770 /data/smarty

# Grant permisson for writing session info
RUN chgrp -R www-data /var/lib/php5
RUN chmod -R 770 /var/lib/php5

ENV DEBIAN_FRONTEND newt
