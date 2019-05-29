FROM ubuntu:16.04

MAINTAINER Alexandre Carvalho <alexandrejacarvalho@protonmail.com>

# Environment
ENV APPFOLDER /var/www/html/
ENV PHALCONFOLDER /usr/lib/
ENV PHPFOLDER /etc/php/7.0/fpm/
ENV NGINXFOLDER /etc/nginx/
ENV SETUPLOCALFOLDER /setup/
ENV SHELL /bin/bash

# PACKAGES
RUN apt-get update && apt-get install -y software-properties-common

RUN apt-get update && apt-get install -y \
  git-core \
  vim \
  nginx \
  cron \
  curl \
  php \
  php-fpm \
  php-cli \
  php-common \
  php-mbstring \
  php-gd \
  php-intl \
  php-xml \
  php-mysql \
  php-mcrypt \
  php-zip \
  php-curl \
  php-xdebug \
  php-gmp


RUN curl -s "https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh" | bash

RUN apt-get install php7.0-phalcon


# Devops server test 
RUN rm -rf /var/www/html/
RUN mkdir /var/www/html/
WORKDIR "${APPFOLDER}"
RUN git clone https://github.com/AlexCarvalhoDev/phalcon-raw-app.git .


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
