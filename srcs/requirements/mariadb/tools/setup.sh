#!/bin/bash

set -e

# 1. Ensure the runtime directory exists and has the right owner
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# 2. Initialize the database directory if it's empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    chown -R mysql:mysql /var/lib/mysql
    #mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm > /dev/null
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# 3. Create a temporary "Configuration Plan" (SQL script)
# This is the "Key" that sets everything up without needing a login
# Creating the plan (Remove the \ before the $)
cat << EOF > /tmp/init_db.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

#USE mysql;
#FLUSH PRIVILEGES;
#DELETE FROM mysql.user WHERE User='';
#DROP DATABASE IF EXISTS test;
#DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
#CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
#CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
#GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
#ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
#FLUSH PRIVILEGES;
#EOF

# 4. Execute the plan using "Bootstrap" mode
# This talks directly to the files, no networking or socket needed!
echo "Bootstrapping MariaDB..."
mysqld --user=mysql --bootstrap < /tmp/init_db.sql
rm -f /tmp/init_db.sql

# 5. Start the engine for real!
echo "MariaDB is ready. Launching daemon..."
exec mysqld --user=mysql --console
