FROM joseluisq/php-fpm:8.1

ENV SITE_PATH /www/SSPanel-Uim
ENV PHP_VERSION 81

RUN apk update && apk add \
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

# Change owner of the /www/SSPanel-Uim directory
RUN chown -R www-data:www-data ${SITE_PATH} && \
    chmod -R 755 ${SITE_PATH}

RUN mkdir -p ${SITE_PATH}/public && \
    chown -R www-data:www-data ${SITE_PATH}/config/ && \
    chmod -R 755 ${SITE_PATH}/config/ && \

COPY supervisord.conf /etc/supervisord.conf
# COPY start.sh /usr/local/bin/start.sh
COPY firstup.sh ${SITE_PATH}/firstup.sh
COPY crontab /etc/cron.d/sspanel
COPY Caddyfile /etc/caddy/Caddyfile

# RUN echo -e "[www]\nuser = nginx\ngroup = nginx" >> /usr/local/etc/php-fpm.d/www.conf

# RUN usermod -u 1000 nginx
# RUN chmod +x /usr/local/bin/start.sh

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
