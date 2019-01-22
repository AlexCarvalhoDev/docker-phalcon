FROM ubuntu:14.04

MAINTAINER Antonio Santos <antonio.santos@mobipium.com>

# Environment
ENV APPFOLDER /var/www/html/
ENV PHALCONFOLDER /usr/lib/
ENV PHPFOLDER /etc/php/7.0/fpm/
ENV NGINXFOLDER /etc/nginx/
ENV SETUPLOCALFOLDER /setup/
ENV SHELL /bin/bash

# PACKAGES
RUN apt-get update && apt-get install -y --force-yes software-properties-common

RUN apt-add-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y --force-yes \
  git-core \
  vim \
  nginx \
  cron \
  curl \
  php7.0 \
  php7.0-fpm \
  php7.0-cli \
  php7.0-common \
  php7.0-mbstring \
  php7.0-gd \
  php7.0-intl \
  php7.0-xml \
  php7.0-mysql \
  php7.0-mcrypt \
  php7.0-zip \
  php7.0-curl \
  php-xdebug \
  php-gmp


RUN curl -s "https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh" | bash

RUN apt-get install php7.0-phalcon


# Devops server test 
WORKDIR "${APPFOLDER}"
RUN git clone https://github.com/andrevieiralx/devopsteste.git .


# Phalcon config
RUN chmod -R a+w ${APPFOLDER}app/cache


# php.ini
COPY ${SETUPLOCALFOLDER}php.ini ${PHPFOLDER}

# nginx.conf
COPY ${SETUPLOCALFOLDER}nginx.conf ${NGINXFOLDER}

# fastcgi-php.conf
COPY ${SETUPLOCALFOLDER}snippets ${NGINXFOLDER}
COPY ${SETUPLOCALFOLDER}fastcgi.conf ${NGINXFOLDER}

# Linux config
RUN chown -R www-data:www-data ${APPFOLDER}

# Volumes
VOLUME ${APPFOLDER}

# Ports 80, 443
EXPOSE 443 80

# Start nginx and php7
CMD service php7.0-fpm start; service nginx start ; tail -f /dev/null