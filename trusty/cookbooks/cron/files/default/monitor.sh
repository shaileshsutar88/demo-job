#!/bin/bash
#
#
#
#
#
sudo mkdir /home/vagrant/scripts
ip="10.0.0.2"
TO_ADDRESS="root@$ip"
SUBJECT="Nginx serive is down"
BODY="This is a linux mail system. Nginx service is down nginx-web server.."
result=`curl -s $ip:80 >/dev/null && echo Connected. || echo Fail.`
if [ $result == "Fail" ]
then
	echo ${BODY}| mail -s ${SUBJECT} ${TO_ADDRESS}
fi
