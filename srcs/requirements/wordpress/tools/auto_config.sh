#!/bin/bash

sleep 10 # Give MariaDB time to start up

if [ ! -f /var/www/html/wp-config.php ]; then
    # Download WordPress
    wp core download --allow-root

    # Create wp-config.php
    wp config create --dbname=$SQL_DATABASE --dbuser=$SQL_USER --dbpass=$SQL_PASSWORD --dbhost=mariadb --allow-root

    # Install WordPress
    wp core install --url=https://$DOMAIN_NAME:443 --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root

    # Create the second user (guest_who)
    wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root
fi

# Ensure the directory exists for the PHP socket
mkdir -p /run/php

# Start PHP-FPM in the foreground
exec /usr/sbin/php-fpm7.4 -F
