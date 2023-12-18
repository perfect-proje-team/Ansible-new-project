#!/bin/bash
# Update system packages
sudo yum update -y

# Install MariaDB Server
sudo yum install -y mariadb-server

# Start MariaDB service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
# NOTE: The following commands automate the mysql_secure_installation script.
# Be sure to replace 'your_mariadb_root_password' with a strong password of your choosing.
MYSQL_ROOT_PASSWORD='abcd1234'
sudo mysql -e "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root'"
sudo mysql -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -e "DROP DATABASE IF EXISTS test"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
sudo mysql -e "FLUSH PRIVILEGES"

