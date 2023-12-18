#!/bin/bash
# Update system packages
sudo yum update -y

# Install MariaDB Server
sudo yum install -y mariadb-server

# Start MariaDB service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
MYSQL_ROOT_PASSWORD='abcd1234' # Güvenlik için güçlü bir şifre ile değiştirin
sudo mysql -e "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root'"
sudo mysql -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -e "DROP DATABASE IF EXISTS test"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
sudo mysql -e "FLUSH PRIVILEGES"

# Veritabanı ve tablo oluşturma
sudo mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE my_database;
USE my_database;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    country VARCHAR(100)
);
EOF

# Flask uygulaması için veritabanı kullanıcısı ve izinler
FLASK_DB_PASSWORD='my_password' # Güvenlik için güçlü bir şifre ile değiştirin
sudo mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE USER 'flask_user'@'%' IDENTIFIED BY '$FLASK_DB_PASSWORD';
GRANT ALL PRIVILEGES ON my_database.* TO 'flask_user'@'%';
FLUSH PRIVILEGES;
EOF
