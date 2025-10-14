# Stage 1: Build dependencies using Composer and Node
FROM composer:2.7 AS vendor

WORKDIR /app
# Copy composer files first (for caching)
COPY composer.json composer.lock ./

# Copy the rest of the Laravel app (including artisan)
COPY . .

# Now run composer install — artisan exists now
RUN composer install --no-dev --optimize-autoloader

# Stage 2: Build frontend assets using Node
FROM node:20 AS frontend

WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install
COPY . .
RUN npm run build

# Stage 3: Production image
FROM php:8.2-apache

# Install PHP extensions and system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libsqlite3-dev pkg-config \
    && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite (Laravel needs this)
RUN a2enmod rewrite

# Copy Laravel app from build stage
COPY --from=vendor /app /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libsqlite3-dev pkg-config \
    && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Fix permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Set up Apache to serve Laravel from the 'public' folder
COPY ./apache/laravel.conf /etc/apache2/sites-available/000-default.conf

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
