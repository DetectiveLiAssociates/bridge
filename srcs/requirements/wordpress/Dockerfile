FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y wget php7.4 php-fpm php-mysql mariadb-client

# Install WP-CLI (the WordPress command line tool)
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy our custom PHP config
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Set up the working directory
WORKDIR /var/www/html

# Copy the script and give permissions
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

# Start the auto-config script
ENTRYPOINT ["bash", "/usr/local/bin/auto_config.sh"]
