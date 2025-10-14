# Use official PHP 8.2 image with necessary extensions
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev npm \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy app files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Build frontend (Vue + Vite)
RUN npm install && npm run build

# Generate app key and run migrations
RUN php artisan key:generate

# Expose port 8000
EXPOSE 8000

# Start Laravel app
CMD php artisan serve --host=0.0.0.0 --port=8000
