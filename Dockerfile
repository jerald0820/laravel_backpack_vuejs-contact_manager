# Stage 1: Build dependencies using Composer and Node
FROM composer:2.7 AS vendor

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Stage 2: Build frontend assets using Node
FROM node:18 AS frontend

WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install
COPY . .
RUN npm run build

# Stage 3: Production image with PHP + Nginx
FROM php:8.2-apache

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libsqlite3-dev pkg-config \
    && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy Laravel source code
COPY . .

# Copy vendor files and build assets from earlier stages
COPY --from=vendor /app/vendor ./vendor
COPY --from=frontend /app/public ./public

# Copy .env.example to .env (Render will override ENV vars)
RUN cp .env.example .env || true

# Laravel setup
RUN php artisan key:generate || true
RUN mkdir -p database && touch database/database.sqlite
RUN php artisan migrate --force || true

# Configure Apache
RUN echo "<Directory /var/www/html>\n\
    AllowOverride All\n\
</Directory>" > /etc/apache2/conf-available/laravel.conf \
    && a2enconf laravel

EXPOSE 80

CMD ["apache2-foreground"]
