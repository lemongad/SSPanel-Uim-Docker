FROM joseluisq/php-fpm:8.1

ENV SITE_PATH /www/SSPanel-Uim
ENV PHP_VERSION 81

RUN apk update && apk add \
    shadow \
    caddy \
    supervisor \
    curl \
    git \
    dcron \
    bash \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-mysqlnd \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-fileinfo \
    && rm -rf /var/cache/apk/*

COPY ./SSPanel-Uim ${SITE_PATH}

WORKDIR ${SITE_PATH}

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --no-interaction --no-plugins --no-scripts && \
    rm -rf /root/.composer

RUN usermod -u 1000 www-data

RUN chown -R www-data:www-data ${SITE_PATH} && \
    chmod -R 755 ${SITE_PATH}

COPY supervisord.conf /etc/supervisord.conf
# COPY start.sh /usr/local/bin/start.sh
COPY firstup.sh ${SITE_PATH}/firstup.sh
COPY crontab /etc/cron.d/sspanel
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
