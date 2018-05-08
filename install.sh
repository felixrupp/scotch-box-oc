#! /usr/bin/env bash

sudo composer self-update

#sudo apt update;
#sudo apt --assume-yes purge 'php*';
#sudo apt --assume-yes install php7.1 php7.1-xml php7.1-soap php7.1-curl php7.1-zip php7.1-mbstring php7.1-intl php7.1-gd  php7.1-mysql php7.1-sqlite;
#sudo apt --assume-yes upgrade;

cd /var/www/;
wget -O owncloud.zip https://download.owncloud.org/community/owncloud-10.0.7.zip;
unzip owncloud.zip;

yes | rm -f owncloud.zip;

if [ ! -d /var/www/owncloud/data ]
then
    sudo mkdir /var/www/owncloud/data;
fi

sudo touch /etc/apache2/sites-available/owncloud.conf;

sudo tee /etc/apache2/sites-available/owncloud.conf > /dev/null <<'TXT'
<VirtualHost *:80>
	ServerName      oc10.earth.iem.thm.de
	ServerAlias     www.oc10.earth.iem.thm.de
	DocumentRoot    "/var/www/owncloud"
	
	<Directory /var/www/owncloud/>
		Options +FollowSymlinks
		AllowOverride All

		<IfModule mod_dav.c>
			Dav off
		</IfModule>

		SetEnv HOME /var/www/owncloud
		SetEnv HTTP_HOME /var/www/owncloud
	</Directory>
</VirtualHost>
TXT

cd /etc/apache2/sites-enabled/;
sudo ln -s ../sites-available/owncloud.conf;

sudo service apache2 restart;