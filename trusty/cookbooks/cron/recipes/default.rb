#
# Cookbook Name:: cron
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cron 'health-check.sh' do
  hour '*/3'
  command '/home/vagrant/scripts/health-check.sh'
  user 'vagrant'
  #only_if {File.exists?('/home/vagrant/scripts/health-check.sh')}
end
