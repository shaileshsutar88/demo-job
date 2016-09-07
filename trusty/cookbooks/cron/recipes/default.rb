#
# Cookbook Name:: cron
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{sendmail mailutils}.each do |pkg|
   package pkg do
      action :install
   end
end

directory '/home/vagrant/scripts' do
  owner 'vagrant'
  group 'vagrant'
  mode  '0755'
  action :create
end

cookbook_file '/home/vagrant/scripts/health-check.sh' do
  source 'monitor.sh'
  owner 'vagrant'
  group 'vagrant'
  mode '755'
end

cron 'health-check.sh' do
  action :create
  hour '*/3'
  command '/home/vagrant/scripts/health-check.sh'
  user 'vagrant'
  only_if {File.exists?('/home/vagrant/scripts/health-check.sh')}
end
