#!/usr/bin/env bash

echo -e "\nLoading root mysql details.\n"

echo -e "\nSetting up root user\n"

source /var/www/local.vagrant/bootstrap/database-logins.sh
sudo mysql -Bse "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_root_password';"

# Enable all sites in sites-available
for file in /var/www/local.vagrant/database/*; do
    if [ -f "$file" ]; then
        if [[ $file == *.sh ]]; then
          source $file
        fi
    fi
done

mysql -u root -p$mysql_root_password -Bse "FLUSH PRIVILEGES;"
