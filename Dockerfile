FROM php:8.1.12-fpm-alpine

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apk --no-cache upgrade && \
    apk --no-cache add bash git sudo openssh  libxml2-dev oniguruma-dev autoconf gcc g++ make npm freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev

RUN pecl channel-update pecl.php.net
RUN pecl install pcov ssh2 swoole
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install mbstring xml  pcntl gd zip sockets pdo pdo_mysql bcmath soap
RUN docker-php-ext-enable mbstring xml gd  zip pcov pcntl sockets bcmath pdo  pdo_mysql soap swoole


RUN docker-php-ext-install pdo pdo_mysql sockets
RUN curl -sS https://getcomposer.org/installer​ | php -- \
     --install-dir=/usr/local/bin --filename=composer

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=spiralscout/roadrunner:latest /usr/bin/rr /usr/bin/rr

WORKDIR /var/www/html
COPY . .

RUN composer install --optimize-autoloader --no-dev
RUN composer require laravel/octane spiral/roadrunner

RUN php artisan key:generate
RUN php artisan octane:install --server="swoole"

EXPOSE 8000