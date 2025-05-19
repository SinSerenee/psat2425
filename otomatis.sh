#!/bin/bash
apt update -y
apt install -y apache2 php php-mysql libapache2-mod-php mysql-client
rm -rf /var/www/html/{*,.*}
git clone https://github.com/paknux/crudsiswa.git /var/www/html
chmod -R 777 /var/www/html
echo DB_USER=admin > /var/www/html/.env
echo DB_PASS=MyP4ssw0rd12345 >> /var/www/html/.env
echo DB_NAME=crudsiswa  >> /var/www/html/.env
echo DB_HOST=https://database-1.cgxshlk266oq.us-east-1.rds.amazonaws.com >> /var/www/html/.env
apt install openssl
a2enmod ssl
a2ensite default-ssl.conf
systemctl reload apache2