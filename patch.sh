#!/bin/bash
if (($EUID !=0)); then
     echo Script must be run by root.
     exit
fi
echo 'WARNING! Recomend path on new install. If you continue all your marzban data will be lost'
echo 'Press Enter to contunue or CTRL+C to exit'
read cnf
cp Caddyfile Caddyfile.default
cp index.html index.html.default
cp .env env

echo 'Enter your domain and login deitals. If login deitals empty, they will be random generated.'
read -p "Enter your domain name: " domain
if [ -z "$domain" ]; then
    echo 'Domain can not be empty!'
    exit
fi
read -p "Enter your admin username: " admname
read -p "Enter your admin password: " passw
read -p "Enter your webpath: " webpath

if [ -z "$admname" ]; then
    admname=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 10)
fi

if [ -z "$passw" ]; then
    passw=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 10)
fi

if [ -z "$webpath" ]; then
    webpath=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 10)
fi


sed -i "s/yourdomain.com/$domain/g" Caddyfile
sed -i "s/yourdomain.com/$domain/g" index.html
sed -i "s/adminname/$admname/g" .env
sed -i "s/adminpassword/$passw/g" .env
sed -i "s/dashboardpath/$webpath/g" .env

echo 'Your login deitals:'
echo "admin: $admname"
echo "password: $passw"
echo "path: $webpath"

mkdir /var/lib/marzban/templates && mkdir /var/lib/marzban/templates/home
cp index.html /var/lib/marzban/templates/home/
cp Caddyfile /opt/marzban/
cp docker-compose.yml /opt/marzban/
cp .env /opt/marzban/
cp xray_config.json /var/lib/marzban/xray_config.json

#Running patch

marzban update
marzban restart
