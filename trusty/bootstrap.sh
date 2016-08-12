#!/bin/bash
#
# Author : Shailesh Sutar
# Purpose : Vagrant 14.04 setup nginx with custom php page
#
#

inst_all () {
	sudo sh -c 'echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" >> /etc/apt/sources.list'
	sudo sh -c 'echo "deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx"  >> /etc/apt/sources.list'
	sudo sh -c 'curl http://nginx.org/keys/nginx_signing.key | apt-key add -'
	sudo apt-get update
	sudo sh -c 'apt-get install -y nginx'
	sudo sh -c 'apt-get install -y elinks'
	sudo sh -c 'apt-get install python-software-properties'
	sudo sh -c 'add-apt-repository ppa:ondrej/php5 -y'
	sudo sh -c 'DEBIAN_FRONTEND=noninteractive apt-get install -y php5 php5-fpm'
}

config () {
	sudo sh -c 'mkdir -p /var/www/html'
	sudo sh -c "sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini"
	sudo sh -c "sed -i 's|/var/run/php5-fpm.sock|127.0.0.1:9000|g' /etc/php5/fpm/pool.d/www.conf"
	sudo sh -c "echo 10.0.0.3 test1 >> /etc/hosts"
}

rest_art () { 
	sudo /etc/init.d/nginx restart
	sudo /etc/init.d/php5-fpm restart
}

inst_all
config
rest_art
