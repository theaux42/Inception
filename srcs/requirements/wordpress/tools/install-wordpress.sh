#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysql -h"${WP_DB_HOST%:*}" -u"${WP_DB_USER}" -p"${WP_DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do
    sleep 2
    echo "Still waiting for MariaDB..."
done

echo "MariaDB is ready! Setting up WordPress..."

# Setup folders for the installation
mkdir -p /var/www/html
cd /var/www/html

# Check if WordPress is already installed
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Installing WordPress..."

    # Download and installation of WordPress CLI
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    # Download of WordPress and moving of the configuration file
    wp core download --allow-root

    # Copy and configure wp-config.php
    cp /tmp/wp-config.php /var/www/html/wp-config.php

    # Replacing placeholders in wp-config.php with environment variables
    sed -i "s/database_name_here/${WP_DB_NAME}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${WP_DB_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${WP_DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${WP_DB_HOST}/" /var/www/html/wp-config.php

    # Set proper permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html

    echo "WordPress setup completed!"
else
    echo "WordPress already installed, skipping installation."
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."

wp core install --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN} --admin_password=${WP_ADMIN_PWD} --admin_email=${WP_ADMIN_EMAIL} --skip-email --allow-root
wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PWD} --role=author --allow-root

exec php-fpm8.2 -F
