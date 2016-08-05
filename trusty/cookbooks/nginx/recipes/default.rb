#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/var/www/html/index.php" do
	source "index.php"
	mode  "0644"
end

template "/etc/nginx/conf.d/default.conf" do
	source "default.erb"
	owner "root"
	group "root"
	mode  "0644"
	notifies :restart, "service[nginx]"
end

service 'php5-fpm' do
	action :reload
end

service 'nginx' do
	action :restart
end
