#
# Cookbook Name:: backup-manager
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
package "update-manager-core" do
 action :install
end

#service "update-manager-core" do
 # action :start
#end

execute "apt update" do
    command "apt-get update -y"
end

execute "apt dist-upgrade" do
    command "apt-get dist-upgrade -y"
end
apt_update "all platforms" do
  frequency 86400
  action :periodic
end
