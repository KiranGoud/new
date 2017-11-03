#
# Cookbook Name:: copy
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
directory '/etc/mcl/kcl' do

  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/mcl/' do
  source ['/etc/node']
  mode "0644"
  action :create
end
