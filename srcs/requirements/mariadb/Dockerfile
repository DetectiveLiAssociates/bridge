FROM debian:bullseye

# Install MariaDB
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install mariadb-server -y

# Copy our custom configuration
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld

# Copy the initialization script
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# MariaDB default port
EXPOSE 3306

# Start the script
ENTRYPOINT ["bash", "/usr/local/bin/setup.sh"]
