#! /usr/bin/env bash

sudo composer self-update

sudo apt update;
sudo apt --assume-yes upgrade;
sudo apt --assume-yes install php7.0-xml liblocale-po-perl gettext;

cd /var/www/;
wget https://download.owncloud.org/community/owncloud-10.0.4.zip;
unzip owncloud-10.0.4.zip;

if [ ! -d /var/www/owncloud/data ]
then
    sudo mkdir /var/www/owncloud/data;
fi

sudo touch /etc/apache2/sites-available/owncloud.conf;

sudo tee /etc/apache2/sites-available/owncloud.conf > /dev/null <<'TXT'
<VirtualHost *:80>
	ServerName      dev.earth.iem.thm.de
	ServerAlias     www.dev.earth.iem.thm.de
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