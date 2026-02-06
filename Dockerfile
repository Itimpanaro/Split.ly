# Etapa PHP-FPM
FROM php:8.4-fpm AS php

RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libonig-dev libxml2-dev zip curl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .
RUN composer install --no-dev --optimize-autoloader
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Etapa Apache
FROM httpd:2.4

# Copiar código desde la etapa PHP
COPY --from=php /var/www/html /var/www/html

# Configuración de Apache para Laravel
RUN echo "<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/public\n\
    <Directory /var/www/html/public>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
    ProxyPassMatch ^/(.*\\.php)$ fcgi://php:9000/var/www/html/public/\$1\n\
</VirtualHost>" > /usr/local/apache2/conf/httpd.conf

EXPOSE 80
CMD ["httpd-foreground"]
