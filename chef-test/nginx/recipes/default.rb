#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Author : Shailesh Sutar

package 'nginx' do
   action :install
end

package 'php-fpm' do
   action :install
end
