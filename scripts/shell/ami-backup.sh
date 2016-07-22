#!/bin/bash
#
#
#  Author :: Shailesh Sutar
#
#  Purpose :: Shell script to create AMI of master server and update launch config on auto scaling group.
#
#
inst="i-xxxxxxxxxxxx"
name="server-namev1-`date +%d%m%Y`"
desc="Ami created from master server on `date +%d%m%Y`"
ami=`aws ec2 create-image --instance-id $inst --name $name --description $desc | grep ami | awk ' { print $2 }'`
