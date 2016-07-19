#!/bin/bash
#
# Shell script for setting up the Mongo server configurations.
#
# Author: Shailesh Sutar
#
set -x                            # to log output to screen.
fname=`basename $0`               # sets filename to variable fname.1
sudo yum install -y xfsprogs      # Installs xfs filesystem support utilities on system.
hdd="/dev/xvdh /dev/xvdg"          
fs="xfs"
# Creating logs and scripts directory
mkdir /home/ec2-user/logs
mkdir /home/ec2-user/scripts
### Below command till line starting with EOT, is shell script which will be deployed on each mongo server for configuring kernel
### Parameters and Block readhead to set to 32 
cat <<EOT>> /home/ec2-user/scripts/run-config.sh                        
#!/bin/bash
#
# Purpose :: Run config for mongo servers.
# Author :: Shailesh Sutar 
#
# Setting readhead to 32 on /dev/xvdh1 and /dev/xvdg1
sudo blockdev --setra 32 /dev/xvdh1
sudo blockdev --setra 32 /dev/xvdg1
# setting transparent_hugepage/defrag and transparent_hugepage/enabled to never
sudo bash -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag"
sudo bash -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled"
EOT

echo `date`" run-config script created" >> /home/ec2-user/logs/$fname.log    # Making a log of ongoing activity to file.
echo `date`" Pulling Device Block report" >> /home/ec2-user/logs/$fname.log  # Making a log of ongoing activity to file.
echo "##############################" >> /home/ec2-user/logs/$fname.log      # Making a log of ongoing activity to file.
sudo blockdev --report >> /home/ec2-user/logs/$fname.log                     # Logging Device block report to file.
echo "##############################" >> /home/ec2-user/logs/$fname.log      # Making a log of ongoing activity to file.
echo `date`" Formatting EBS Volumes " >> /home/ec2-user/logs/$fname.log      # logging formatting activity to file. 
for i in $hdd;do
echo "n
p
1


w
"|sudo fdisk $i;sudo partprobe "$i1";sudo mkfs.xfs -f "${i}1";done
echo `date`" Formatting of EBS Volume is complete " >> /home/ec2-user/logs/$fname.log
echo `date`" Creating Mount point for EBS Volumes and mounting them " >> /home/ec2-user/logs/$fname.log
	sudo mkdir /mondba                         # Creating mount point for /dev/xvdh1
	sudo mkdir /monbackup                      # Creating mount point for /dev/xvdg1
	sudo mount -t $fs /dev/xvdh1 /mondba       # Mounting /dev/xvdh1 on /mondba/
	sudo mount -t $fs /dev/xvdg1 /monbackup    # Mounting /dev/xvdg1 on /monbackup/
	sudo df -Th
echo `date`" Mount point  creation complete" >> /home/ec2-user/logs/$fname.log
echo `date`"Creating mount point entries in /etc/fstab file" >> /home/ec2-user/logs/$fname.log
	sudo echo "/dev/xvdh1  /mondba     xfs     defaults,noatime,nodiratime        0   0" >> /etc/fstab
	sudo echo "/dev/xvdg1  /monbackup  xfs     defaults,noatime,nodiratime        0   0" >> /etc/fstab
echo `date`"Creating mount point entries in /etc/fstab file complete" >> /home/ec2-user/logs/$fname.log

# Setting up new limits for system in /etc/security/limits.conf
echo `date`" Adding new limits /etc/security/limits.conf file " >> /home/ec2-user/logs/$fname.log
	sudo echo "*                soft    nofile          64000" >> /etc/security/limits.conf
	sudo echo "*                hard    nofile          64000" >> /etc/security/limits.conf
	sudo echo "*                hard    nproc          64000" >> /etc/security/limits.conf
	sudo echo "*                soft    nproc          64000" >> /etc/security/limits.conf
echo `date`" Setting up crontab for blockdev and transparent_hugepage parameters" >> /home/ec2-user/logs/$fname.log
# Setting up crontab on system at startup
l0="@reboot /home/ec2-user/scripts/run-config.sh"
(crontab -u ec2-user -l; echo "$l0" ) | crontab -u ec2-user -
# Assigning permission on run-config script
chmod +x /home/ec2-user/scripts/run-config.sh
echo `date`" Rebooting server for effects " >> /home/ec2-user/logs/$fname.log
# Finally, Server reboot for new values to take effect.
sudo reboot
