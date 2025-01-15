# Use an official PHP image as the base image
FROM php:8.4-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql \
    && a2enmod rewrite

# Set the working directory in the container
WORKDIR /var/www/html

# Clone the Flarum repository (you can also use a release tarball)
RUN git clone --branch v1.8.1 https://github.com/flarum/flarum.git .

# Install Composer (PHP package manager)
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Install Flarum dependencies
RUN composer install --no-dev --prefer-dist

# Configure the Apache server
COPY ./apache-config.conf /etc/apache2/sites-available/000-default.conf

# Expose the HTTP port
EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]
