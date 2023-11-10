FROM php:apache

# prepare install
RUN apt-get update --fix-missing
#RUN apt-get install -y build-essential libssl-dev zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev
RUN apt-get --yes install libfreetype6-dev \
                          libjpeg62-turbo-dev \
                          libpng-dev \
                          libwebp-dev 
# install zip extension
RUN apt-get install -y libzip-dev && docker-php-ext-install zip

# install mysql extension
RUN docker-php-ext-install mysqli pdo pdo_mysql

# install gd extension
#RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

#RUN docker-php-ext-configure gd --with-png=/usr/include/ --with-jpeg=/usr/include/ --with-freetype=/usr/include/
#RUN docker-php-ext-install gd

RUN set -e; \
    docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype; \
    docker-php-ext-install -j$(nproc) gd

RUN a2enmod rewrite
RUN a2enmod headers

# Copia los archivos del proyecto al directorio de trabajo en el contenedor
COPY ./www /var/www/html

# Configura el servidor Apache para servir el sitio desde /var/www/html
#RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html

# Configura la base de datos MySQL usando variables de entorno del Docker Compose
ENV DB_HOST=${DB_HOST}
ENV DB_USERNAME=${DB_USERNAME}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV DB_DATABASE=${DB_DATABASE}

# Expone el puerto 80 para que el servidor web sea accesible desde fuera del contenedor
EXPOSE 80

# Comando para iniciar el servidor Apache al ejecutar el contenedor
CMD ["apache2-foreground"]
