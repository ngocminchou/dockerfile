# deploy/Dockerfile

# stage 1: build stage
FROM php:8.3-fpm-alpine as build

# installing system dependencies and php extensions
RUN apk add --no-cache \
    zip \
    libzip-dev \
    freetype \
    libjpeg-turbo \
    libpng \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd

# install composer
COPY --from=composer:2.7.6 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# copy necessary files and change permissions
COPY . .

# install php and node.js dependencies
RUN composer install --no-dev --prefer-dist

RUN chown -R www-data:www-data /var/www/html/vendor \
    && chmod -R 775 /var/www/html/vendor

# stage 2: production stage
FROM php:8.3-fpm-alpine

# install nginx
RUN apk add --no-cache \
    zip \
    libzip-dev \
    freetype \
    libjpeg-turbo \
    libpng \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    oniguruma-dev \
    gettext-dev \
    freetype-dev \
    nginx \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && docker-php-ext-install bcmath \
    && docker-php-ext-enable bcmath \
    && docker-php-ext-install exif \
    && docker-php-ext-enable exif \
    && docker-php-ext-install gettext \
    && docker-php-ext-enable gettext \
    && docker-php-ext-install opcache \
    && docker-php-ext-enable opcache \
    && rm -rf /var/cache/apk/*

# copy files from the build stage
COPY --from=build /var/www/html /var/www/html
COPY ./deploy/nginx.conf /etc/nginx/http.d/default.conf
COPY ./deploy/php.ini "$PHP_INI_DIR/conf.d/app.ini"

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR /var/www/html

# add all folders where files are being stored that require persistence. if needed, otherwise remove this line.
# VOLUME ["/var/www/html/storage/app"]
# CMD ["sh", "-c", "nginx && php-fpm"]


