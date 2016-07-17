#!/bin/bash
#
# Shell script for setting up the Mongo server configurations.
#
# Author: Shailesh Sutar
#
set -x
fname=`basename $0`
sudo yum install -y xfsprogs
hdd="/dev/xvdh /dev/xvdg"
fs="xfs"
mkdir /home/ec2-user/logs
mkdir /home/ec2-user/scripts
cat <<EOT>> /home/ec2-user/scripts/run-config.sh
#!/bin/bash
#
# Purpose :: Run config for mongo servers.
# Author :: Shailesh Sutar 
#
sudo blockdev --setra 32 /dev/xvdh1
sudo blockdev --setra 32 /dev/xvdg1
sudo bash -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag"
sudo bash -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled"
EOT
echo `date`" run-config script created" >> /home/ec2-user/logs/$fname.log
echo `date`" Pulling Device Block report" >> /home/ec2-user/logs/$fname.log
echo "##############################" >> /home/ec2-user/logs/$fname.log
sudo blockdev --report >> /home/ec2-user/logs/$fname.log
echo "##############################" >> /home/ec2-user/logs/$fname.log
echo `date`" Formatting EBS Volumes " >> /home/ec2-user/logs/$fname.log
for i in $hdd;do
echo "n
p
1


w
"|sudo fdisk $i;sudo partprobe "$i1";sudo mkfs.xfs -f "${i}1"; sudo blockdev --setra 32 "${i}1";done
echo `date`" Formatting of EBS Volume is complete " >> /home/ec2-user/logs/$fname.log
echo `date`" Creating Mount point for EBS Volumes and mounting them " >> /home/ec2-user/logs/$fname.log
	sudo mkdir /mondba
	sudo mkdir /monbackup
	sudo mount -t $fs /dev/xvdh1 /mondba
	sudo mount -t $fs /dev/xvdg1 /monbackup
	sudo df -Th
echo `date`" Mount point  creation complete" >> /home/ec2-user/logs/$fname.log
echo `date`"Creating mount point entries in /etc/fstab file" >> /home/ec2-user/logs/$fname.log
	sudo echo "/dev/xvdh1  /mondba     xfs     defaults        0   0" >> /etc/fstab
	sudo echo "/dev/xvdg1  /monbackup  xfs     defaults        0   0" >> /etc/fstab
echo `date`"Creating mount point entries in /etc/fstab file complete" >> /home/ec2-user/logs/$fname.log
echo `date`" Adding new limits /etc/security/limits.conf file " >> /home/ec2-user/logs/$fname.log
	sudo echo "*                soft    nofile          64000" >> /etc/security/limits.conf
	sudo echo "*                hard    nofile          64000" >> /etc/security/limits.conf
	sudo echo "*                hard    nproc          64000" >> /etc/security/limits.conf
	sudo echo "*                soft    nproc          64000" >> /etc/security/limits.conf
echo `date`" Setting up crontab for blockdev and transparent_hugepage parameters" >> /home/ec2-user/logs/$fname.log
l0="@reboot /home/ec2-user/scripts/run-config.sh"
(crontab -u ec2-user -l; echo "$l0" ) | crontab -u ec2-user -
chmod +x /home/ec2-user/scripts/run-config.sh
echo `date`" Rebooting server for effects " >> /home/ec2-user/logs/$fname.log
sudo reboot
