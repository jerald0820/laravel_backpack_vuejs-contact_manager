# Use official PHP 8.2 image with Node installed
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev npm sqlite3 \
    && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy app files
COPY . .

# Create .env file if not exists
RUN cp .env.example .env || true

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Install and build frontend (Vite + Vue)
RUN npm install && npm run build

# Generate Laravel app key
RUN php artisan key:generate

# Ensure SQLite DB exists
RUN mkdir -p database && touch database/database.sqlite

# Run migrations
RUN php artisan migrate --force || true

# Expose port 8000
EXPOSE 8000

# Start Laravel app
CMD php artisan serve --host=0.0.0.0 --port=8000
