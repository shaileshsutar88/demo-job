#!/bin/bash
#
#
#
#
#
inst_alll () {

	sudo sh -c 'apt-get install -y mailutils'
	sudo sh -c 'DEBIAN_FRONTEND=noninteractive apt-get install -y mailutils'
}

config () {

	sudo mkdir /home/vagrant/scripts
	cat <<EOT>> /home/vagrant/scripts/health-chech.sh
	#!/bin/bash
	#
	# Cron for checking service status
	TO_ADDRESS="root@web"
	SUBJECT="Nginx serive is down"
	BODY="This is a linux mail system. Nginx service is down nginx-web server.."
	result=`curl -s 10.0.0.2:80 >/dev/null && echo Connected. || echo Fail.`
	if [ $result == "Fail" ]
	then
		echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS}
	fi
	EOT

	sudo sh -c "echo 10.0.0.2 test >> /etc/hosts"
	sudo chmod +x /home/vagrant/scripts/health-check.sh
}

cronjob () {
	l0="*/5 * * * * /home/vagrant/scripts/health-check.sh"
	sudo (crontab -u $vagrant -l; echo `"$l0"` ) | crontab -u vagrant -
}

inst_all
config
cronjob
