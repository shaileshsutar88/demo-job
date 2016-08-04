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

