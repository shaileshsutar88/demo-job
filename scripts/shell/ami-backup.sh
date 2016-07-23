#!/bin/bash
#
#
#  Author :: Shailesh Sutar
#
#  Purpose :: Shell script to create AMI of master server and update launch config on auto scaling group.
#
#  Note :: Put values according to your setup wherever it is mentioned as "xxxxxxx" 
inst="i-xxxxxxxxxxxx"
name="server-namev1-`date +%d%m%Y`"
desc="ami-created-from-master-server-on-`date +%d%m%Y`"
config="launchconfig-xxxxxapps-`date +%d%m%Y`"
key="test-key"
sg="sg-xxxxxxx"
asg="xxxxxxxxxx"
ami=`aws ec2 create-image --instance-id $inst --name $name --description $desc | grep ami | awk ' { print $2 }'`
ami=`echo $image | cut -d "|" -f 2`
echo $ami
sleep 300
aws autoscaling create-launch-configuration --launch-configuration-name $config --key-name $key --image-id $ami --security-groups $sg --instance-type t2.micro
sleep 300
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $config --min-size 2 --max-size 10
