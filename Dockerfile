FROM ubuntu:17.04
MAINTAINER Jonathon Moore <digia.io>

# Suppress
ENV DEBIAN_FRONTEND noninteractive

# init. apt update & install common
RUN apt-get update && apt-get install -y \
  apt-utils \
  curl \
  zip \
  unzip \
  vim \
  locales \
  software-properties-common \
  python-software-properties

# Set up locales
RUN locale-gen en_US.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
RUN /usr/sbin/update-locale

RUN apt-get install -y \
  --no-install-recommends --allow-remove-essential --allow-change-held-packages \
  libmysqlclient-dev \
  mariadb-client \
  nginx \
  php7.0-cli \
  php7.0-common \
  php7.0-curl \
  php7.0-dev \
  php7.0-fpm \
  php7.0-gd \
  php7.0-gmp \
  php7.0-imap \
  php7.0-intl \
  php7.0-json \
  php7.0-ldap \
  php7.0-mbstring \
  php7.0-mcrypt \
  php7.0-mysql \
  php7.0-odbc \
  php7.0-opcache \
  php7.0-pspell \
  php7.0-readline \
  php7.0-recode \
  php7.0-soap \
  php7.0-tidy \
  php7.0-xdebug \
  php7.0-xml \
  php7.0-xmlrpc \
  php7.0-xsl \
  php7.0-zip \
  supervisor

# Confirgure nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

# Ensure /run/php exists
RUN mkdir /run/php

# Clean-up, clean-up, everyone do your share...
RUN apt-get autoclean && apt-get -y autoremove

VOLUME ["/var/www"]
EXPOSE 80

CMD ["/var/www/docker-entrypoint.sh"]
