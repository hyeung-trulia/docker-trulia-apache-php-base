# FE apache php base container
# base off of ubuntu for now
FROM ubuntu

MAINTAINER Hinling Yeung

# Make DEBIAN_FRONTEND less chatty
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_FRONTEND newt

# Update the default application repository sources list
RUN apt-get update

# Install apache 2
RUN apt-get -y install apache2

# Install php5
RUN apt-get -y install php5 libapache2-mod-php5 php5-dev

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
RUN apt-get -y install libmemcached-dev
RUN apt-get -y install memcached php5-memcached

# helper tools
RUN apt-get -y install telnet

# config changes
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]

ENV MEMCACHED_LOG_DIR /var/log/memcached.log

EXPOSE 11211

ENTRYPOINT ["/usr/bin/memcached"]
CMD ["-D", "FOREGROUND"]
