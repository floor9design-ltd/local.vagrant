#!/usr/bin/env bash

# Enable all sites in sites-available
for file in /var/www/local.vagrant/sites-available/*; do
  if [ -f "$file" ]; then
    pathless="${file##*/}"

    if [[ $pathless = *.conf ]]; then

    domain="${pathless%.conf}"

    echo "Setting up site $domain"
    sudo cp /var/www/local.vagrant/sites-available/$pathless /etc/apache2/sites-available/$pathless

    sudo rm -rf /var/log/"$domain"
    sudo mkdir /var/log/"$domain"

    sudo echo "192.168.56.40 $domain" >>/etc/hosts

    sudo a2ensite $pathless
    fi
  fi
done
