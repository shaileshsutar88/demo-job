#!/bin/bash
apt-get update
apt-get install -y nginx
apt-get install -y php5
apt-get remove -y apache2
apt-get install -y php5-fpm
if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  ln -fs /vagrant /var/www/html
fi
rm -rf /var/www/html/index.php
cat <<EOT>> /var/www/html/index.php
<?php
$dt = new DateTime();
echo "Today is ". date("l"). " " . date("d-m-Y") . "<br>";
echo "And time now is ". $dt->format('H:i:s');
?>
EOT
rm -rf /etc/nginx/sites-available/default
cat <<EOT>> /etc/nginx/sites-available/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                try_files $uri $uri/ =404;
        }


        location ~ \.php$ {

                #auth_basic "Restricted";
                #auth_basic_user_file /var/www/html/.htpasswd;
                #index index.php;
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php5-fpm.sock;
                include fastcgi_params;
        }
}
EOT
sudo /etc/init.d/nginx restart
