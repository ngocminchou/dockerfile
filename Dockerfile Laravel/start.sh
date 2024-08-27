#!/bin/sh
cp .env.example .env

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/bootstrap/cache

php artisan key:generate

nginx
php-fpm
