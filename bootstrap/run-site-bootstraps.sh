#!/usr/bin/env bash

# Run all bootstraps in site-bootsraps
for file in /var/www/local.vagrant/site-bootstraps/*; do
  if [ -f "$file" ]; then
    pathless="${file##*/}"

    if [[ $pathless = *.sh ]]; then

    domain="${pathless%.sh}"

    echo "Setting up bootstrap for $domain"
    sudo -u vagrant crontab -e
    sudo -u vagrant $file

    fi
  fi
done
