#!/bin/bash
yum update
yum install -y nginx
service nginx start
chkconfig nginx on
chkconfig --level 345 nginx on
