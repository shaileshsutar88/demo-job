#!/bin/bash
#
#
#
#
#
sudo mkdir /home/vagrant/scripts
#cat <<EOT>> /home/vagrant/scripts/health-chech.sh
TO_ADDRESS="root@test"
SUBJECT="Nginx serive is down"
BODY="This is a linux mail system. Nginx service is down nginx-web server.."
result=`curl -s 10.0.0.2:80 >/dev/null && echo Connected. || echo Fail.`
if [ $result == "Fail" ]
then
	echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS}
fi
#EOT
#sudo chmod +x /home/vagrant/scripts/health-check.sh
#l0="*/5 * * * * /home/vagrant/scripts/health-check.sh"
#sudo (crontab -u $vagrant -l; echo `"$l0"` ) | crontab -u vagrant -

