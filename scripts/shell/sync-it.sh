#!/bin/bash
#
#
# Author : Shailesh Sutar
#
# Purpose : Shell script to sync Documentroot changes with master server.
#
user=`whoami`
key="/home/$user/scripts/key"
src='ec2-user@172.31.x.x:/var/www/html/'
dst="/var/www/html/"
sudo mv /var/www/html /var/www/html_`date +%d%m%Y`
sudo mkdir /var/www/html
sudo rsync -avrz -e "ssh -i key" $src $dst
sudo chown -R root.devgroup $dst
sudo chmod 775 $dst
