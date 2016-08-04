#!/bin/bash
#
#
#
#
#sudo apt-get install mail
user=`whoami`
sudo apt-get -y install nmap
#sudo echo "192.168.50.3	web" >> /etc/hosts
sudo mkdir /home/$user/scripts
cat <<EOT>> /home/$user/scripts/health-chech.sh
#!/bin/bash
TO_ADDRESS="root@web"
SUBJECT="Nginx serive is down"
BODY="This is a linux mail system. Nginx service is down nginx-web server.."
if (( $(ps -ef | grep -v grep | grep nginx | wc -l) > 0 ))
then
	echo "nginx is running!!!"
else
	echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS}
fi
EOT
sudo chmod +x /home/$user/scripts/health-check.sh
l0="*/5 * * * * /home/$user/scripts/health-check.sh"
sudo (crontab -u $user -l; echo "$l0" ) | crontab -u $user -
