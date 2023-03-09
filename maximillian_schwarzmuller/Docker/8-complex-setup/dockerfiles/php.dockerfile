# required for nginx config we are using
FROM php:8.0-fpm-alpine

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql

# generally container allow read and write
# but the image restrict read and write
# bind mount in docker-compose.yaml file will not have this issue if we are using it
# so we need to give the access rights 
# change ownership recursively
# www-data is the default user
# /var/www/html refers to the source code
RUN chown -R www-data:www-data /var/www/html