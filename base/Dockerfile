FROM ubuntu:16.04

MAINTAINER Maksim Kotliar <kotlyar.maksim@gmail.com>

ENV LC_ALL=C.UTF-8

RUN apt-get update && \
    apt-get -y --no-install-recommends --no-install-suggests install software-properties-common python-software-properties && \
    add-apt-repository ppa:ondrej/php && \
    add-apt-repository ppa:ondrej/pkg-gearman && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get remove php7.0 && \
    apt-get install -y --no-install-recommends \
    php5.6-bcmath \
    php5.6-cgi \
    php5.6-cli \
    php5.6-common \
    php5.6-fpm \
    php5.6-gd \
    php5.6-json \
    php5.6-mbstring \
    php5.6-mcrypt \
    php5.6-mysql \
    php5.6-opcache \
    php5.6-readline \
    php5.6-xcache \
    php5.6-xml \
    nginx \
    ca-certificates gettext && \
    rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /var/log/php5.6-fpm.log \
	&& ln -sf /dev/stderr /var/log/php-fpm.log

RUN rm -f /etc/nginx/sites-enabled/*

COPY nginx.conf.tpl /tmp/nginx.conf.tpl
COPY php-fpm.conf.tpl /tmp/php-fpm.conf.tpl
COPY defaults.ini /etc/php/5.6/cli/conf.d/defaults.ini
COPY defaults.ini /etc/php/5.6/fpm/conf.d/defaults.ini

RUN mkdir -p /run/php && touch /run/php/php5.6-fpm.sock && touch /run/php/php5.6-fpm.pid

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 80

CMD ["/entrypoint.sh"]
