#
# Cookbook Name:: sap
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
app_user = "#{node[:app_user]}"
app_user_group =  "#{node[:app_user_group]}"
path =  "#{node[:directory]}"

user app_user do
  uid '1234'
  gid '1234'
  home '/home/sap'
  shell '/bin/bash'
  password 'sap123'
end

directory path do
  owner  app_user
  group  app_user_group
  mode '0755'
  action :create
end

mount "/var/mnt" do
 #device xvdf
 #fstype 'ext4'
 #action :mount
#nd

filesystem "label" do
  fstype "ext4"
  device "/dev/xvdf"
  mount "/var/mnt"
  action [:create, :enable, :mount]
end


#
