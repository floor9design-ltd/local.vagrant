#!/usr/bin/env bash

echo -e "\n# Setting up the server #\n"

echo -e "\n### Adding and updating the repositories ###\n"

yes "" | sudo add-apt-repository ppa:ondrej/php
yes "" | sudo add-apt-repository ppa:ondrej/apache2

sudo apt update -y
sudo apt upgrade -y

echo -e "\n### Setting up a swap file ###\n"
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=2048
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

echo -e "\n### Setting up web requirements ###\n"

# apache
sudo apt install apache2 -y
a2enmod rewrite

# php
sudo apt install php openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip php-intl php-sqlite3 php-xdebug php-gd php-dev php-pear libpcre3-dev php-bcmath -y

# mysql
sudo apt install mysql-server -y

# mssql server drivers
phpversion=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')

sudo su <<EOF
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list
EOF

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18
sudo apt-get install -y unixodbc-dev

sudo pecl install sqlsrv
sudo pecl install pdo_sqlsrv

sudo su <<EOF
printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/$phpversion/mods-available/sqlsrv.ini
printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/$phpversion/mods-available/pdo_sqlsrv.ini
EOF
sudo phpenmod sqlsrv pdo_sqlsrv

# node/npm
sudo apt install nodejs -y
sudo apt install npm -y

# Other system requirements:
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo php -r "unlink('composer-setup.php');"
sudo apt install unzip -y

echo -e "\n### Setting up apache to support your domains ###\n"

# Enable all sites in sites-available
source /var/www/local.vagrant/bootstrap/enable-sites.sh

# Disable the main site to stop issues
a2dissite 000-default.conf

echo -e "\n### Setting up framework assistants ###\n"

# Add the symfony binary
sudo wget https://get.symfony.com/cli/installer -O - | bash
sudo mv /home/vagrant/.symfony/bin/symfony /usr/local/bin/symfony

# Add the laravel composer global
composer global require laravel/installer

# Setup services
sudo apt-get install supervisor
sudo systemctl enable cron

# Setup the database content
echo -e "\nRunning any database imports needed\n"
source /var/www/local.vagrant/bootstrap/setup-database.sh

# Run any site bootstraps
echo -e "\nRunning any site bootstraps\n"
source /var/www/local.vagrant/bootstrap/run-site-bootstraps.sh

# cleanup
echo -e "\nTidying up after installation.\n"
sudo apt-get autoremove -y
sudo service apache2 restart

echo -e "\nVagrant setup complete.\n"