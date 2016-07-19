#!/bin/bash

mkdir /home/vagrant/scripts
cat <<EOT>> /home/vagrant/scripts/health-chech.sh
#!/bin/bash

TO_ADDRESS="root@localhost"
SUBJECT="Nginx serive is down"
BODY="This is a linux mail system. Nginx service is down nginx-web server.."
if (( $(ps -ef | grep -v grep | grep nginx | wc -l) > 0 ))
then
	echo "nginx is running!!!"
else
	echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS}
fi
EOT
chmod +x /home/vagrant/scripts/health-check.sh
l0="*/5 * * * * /home/vagrant/scripts/health-check.sh"
(crontab -u vagrant -l; echo "$l0" ) | crontab -u vagrant -
