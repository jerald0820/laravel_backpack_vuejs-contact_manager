# ============================
# Stage 1: Composer Dependencies
# ============================
FROM composer:2.7 AS vendor

WORKDIR /app
COPY composer.json composer.lock ./
COPY . .

RUN composer install --no-dev --optimize-autoloader


# ============================
# Stage 2: Frontend Build
# ============================
FROM node:20 AS frontend

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build


# ============================
# Stage 3: Production (PHP + Apache)
# ============================
FROM php:8.2-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libsqlite3-dev pkg-config \
    && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Laravel-required modules
RUN a2enmod rewrite

WORKDIR /var/www/html

# Copy Laravel app
COPY --from=vendor /app /var/www/html
COPY --from=frontend /app/public/build ./public/build

# Apache config
COPY ./apache/laravel.conf /etc/apache2/sites-available/000-default.conf

# SQLite database setup
RUN mkdir -p database && touch database/database.sqlite && chmod 777 database/database.sqlite

# Fix permissions
RUN chown -R www-data:www-data storage bootstrap/cache database && chmod -R 775 storage bootstrap/cache database

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_URL=https://laravel-contact-manager.onrender.com
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/var/www/html/database/database.sqlite

# Cache configs (don’t run artisan key:generate yet)
RUN php artisan config:clear || true && php artisan route:clear || true && php artisan view:clear || true

# Expose port
EXPOSE 80

# On container start: generate key if missing, then start Apache
CMD ["/bin/sh", "-c", "php artisan key:generate --force || true && php artisan migrate --force || true && apache2-foreground"]
