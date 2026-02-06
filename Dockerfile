# Etapa PHP-FPM
FROM php:8.4-fpm AS php

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libonig-dev libxml2-dev zip curl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Etapa Nginx
FROM nginx:stable

# Copiar configuración de Nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Copiar código desde la etapa PHP
COPY --from=php /var/www/html /var/www/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
