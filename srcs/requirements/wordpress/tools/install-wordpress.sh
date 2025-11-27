#!/bin/bash

# Wait for MariaDB to be ready
while ! mysql -h"${WP_DB_HOST%:*}" -u"${WP_DB_USER}" -p"${WP_DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do
    sleep 2
done

# Setup folders for the installation
mkdir -p /var/www/html
cd /var/www/html

# Determine the URL WordPress should use
WP_INSTALL_URL="${WP_URL:-}"
if [ -z "${WP_INSTALL_URL}" ] && [ -n "${DOMAIN_NAME}" ]; then
    if [[ "${DOMAIN_NAME}" =~ ^https?:// ]]; then
        WP_INSTALL_URL="${DOMAIN_NAME}"
    else
        WP_INSTALL_URL="https://${DOMAIN_NAME}"
    fi
fi

if [ -z "${WP_INSTALL_URL}" ]; then
    echo "Warning: WP_URL not provided; WordPress will default to https://example.com."
    WP_INSTALL_URL="https://example.com"
fi

# Check if WordPress is already installed
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Installing WordPress..."

    # Download and installation of WordPress CLI
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    # Download of WordPress and moving of the configuration file
    wp core download --allow-root
    wp core config --dbhost="$WP_DB_HOST" --dbname="$WP_DB_NAME" --dbuser="$WP_DB_USER" --dbpass="$WP_DB_PASSWORD" --allow-root
    wp core install --url="${WP_INSTALL_URL}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN}" --admin_password="${WP_ADMIN_PWD}" --admin_email="${WP_ADMIN_MAIL}" --skip-email --allow-root
    wp user create "${WP_USER}" "${WP_USER_MAIL}" --user_pass="${WP_USER_PWD}" --role=author --allow-root

    # Copy and configure wp-config.php
    cp /tmp/wp-config.php /var/www/html/wp-config.php

    # Replacing placeholders in wp-config.php with environment variables
    sed -i "s/database_name_here/${WP_DB_NAME}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${WP_DB_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${WP_DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${WP_DB_HOST}/" /var/www/html/wp-config.php

    if command -v wp >/dev/null 2>&1; then
        wp option update siteurl "${WP_INSTALL_URL}" --allow-root
        wp option update home "${WP_INSTALL_URL}" --allow-root
    fi

    # Set proper permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html

    echo "WordPress setup completed!"
else
    echo "WordPress already installed, skipping installation."
    if command -v wp >/dev/null 2>&1 && [ -n "${WP_INSTALL_URL}" ]; then
        echo "Updating WordPress URL to ${WP_INSTALL_URL}..."
        wp option update siteurl "${WP_INSTALL_URL}" --allow-root
        wp option update home "${WP_INSTALL_URL}" --allow-root
    fi
fi

exec php-fpm8.2 -F
