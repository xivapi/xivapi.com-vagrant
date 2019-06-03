#!/usr/bin/env bash

#
# Setup
#
echo "Setting up"
cd /vagrant
USER=vagrant
sudo locale-gen en_GB.UTF-8
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y unzip curl git dos2unix

#
# NGINX
#
echo "Installing: NGINX"
sudo add-apt-repository ppa:nginx/stable -y
sudo apt-get update
sudo apt-get install -y nginx
sudo cp /stack/stack/nginx/default /etc/nginx/sites-available/default
sudo cp /stack/stack/nginx/nginx.conf /etc/nginx/nginx.conf

#
# PHP
#
echo "Installing: PHP + Composer"
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y
sudo apt-get install -y php7.3-fpm php-apcu php-imagick php7.3-dev php7.3-cli php7.3-tidy php7.3-json
sudo apt-get install -y php7.3-intl php7.3-mysql php7.3-sqlite php7.3-curl php7.3-gd
sudo apt-get install -y php7.3-mbstring php7.3-dom php7.3-xml php7.3-zip php7.3-bcmath
sudo sed -i 's|display_errors = Off|display_errors = On|' /etc/php/7.3/fpm/php.ini
sudo sed -i 's|memory_limit = 128M|memory_limit = -1|' /etc/php/7.3/fpm/php.ini
sudo sed -i "s|www-data|$USER|" /etc/php/7.3/fpm/pool.d/www.conf

#
# MySQL
#
echo "Installing: MySQL"
echo "mysql-server mysql-server/root_password password tester" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password tester" | debconf-set-selections
sudo apt install mysql-server -y
mysql -uroot -ptester < ./mysql/db.sql

#
# Redis
#
echo "Installing: Redis"
sudo apt-get install redis-server -y
git clone https://github.com/phpredis/phpredis.git
cd phpredis && phpize && ./configure && make && sudo make install
cd /vagrant
rm -rf /vagrant/phpredis
sudo echo "extension=redis.so" > /etc/php/7.3/mods-available/redis.ini
sudo ln -sf /etc/php/7.3/mods-available/redis.ini /etc/php/7.3/fpm/conf.d/20-redis.ini
sudo ln -sf /etc/php/7.3/mods-available/redis.ini /etc/php/7.3/cli/conf.d/20-redis.ini
sudo service php7.3-fpm restart

#
# Install JAVA + ElasticSearch
#
echo "Installing: Java + ElasticSearch"
export _JAVA_OPTIONS="-Xmx4g -Xms4g"
sudo apt install -y openjdk-8-jre apt-transport-https
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo bash -c 'sudo echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" > /etc/apt/sources.list.d/elastic.list'
sudo apt update
sudo apt install -y elasticsearch
sudo sed -i 's|#network.host: 192.168.0.1|network.host: 0.0.0.0|g' /etc/elasticsearch/elasticsearch.yml
sudo systemctl start elasticsearch

#
# This is more Symfony specific...
# Create folders outside the sync folder for better performance
#
echo "Creating symfony dictories"
sudo mkdir -p /xivapi_vagrant /mogboard_vagrant
sudo chown vagrant:vagrant /xivapi_vagrant /mogboard_vagrant
sudo chmod -R 777 /xivapi_vagrant /mogboard_vagrant

#
# Build ssh keys
#
echo "Generating SSL Certificates"
openssl req -x509 -out /home/vagrant/localhost.crt -keyout /home/vagrant/localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

#
# Finish
#
echo "Finishing up ..."
sudo service nginx restart
sudo service php7.3-fpm restart
sudo apt-get autoremove -y
sudo apt-get update -y
sudo apt-get upgrade -y

#
# Test ES
#
echo "- Testing ElasticSearch in 10 seconds ..."
sleep 10
curl -X GET 'http://localhost:9200'


#
# Goodbye!
#
echo "All finished"
echo "Enjoy!"
