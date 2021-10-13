#!bin/bash

sudo su-
yum -y update
amazon-linux-extras -y install nginx1
	systemctl start nginx.service
	systemctl enable nginx.service
	amazon-linux-extras -y install php8
	yum install -y php-mbstring php-devel php-xml
	systemctl start php-fpm.service
	systemctl enable php-fpm.service
	systemctl restart nginx.service
	systemctl restart php-fpm.service
	sudo service nginx start
cd cd /usr/share/nginx/html
git clone https://github.com/WordPress/WordPress.git wordpress
sudo chmod 777 -R wordpress
sudo echo "server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/wordpress;
        index index.html index.htm index.php index.nginx-debian.html;
        server_name _;
        location / {
                try_files $uri $uri/ =404;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        }
}" > /etc/nginx/sites-available/default
systemctl restart nginx.service