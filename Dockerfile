# Use official PHP 8.2 image with Node and Composer
FROM php:8.2-cli

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libsqlite3-dev pkg-config npm \
    && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy all project files
COPY . .

# Copy .env.example to .env if not exists
RUN cp .env.example .env || true

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Install frontend dependencies and build assets
RUN npm install && npm run build

# Generate Laravel app key
RUN php artisan key:generate

# Ensure SQLite database file exists
RUN mkdir -p database && touch database/database.sqlite

# Run migrations
RUN php artisan migrate --force || true

# Expose port 8000
EXPOSE 8000

# Start the Laravel app
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
