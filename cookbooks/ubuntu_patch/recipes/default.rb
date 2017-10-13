#
# Cookbook Name:: ubuntu_patch
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "apt update" do
 command "apt-get update"
 action :run
end
execute "apt dist-upgrade" do
 command "apt-get dist-upgrade -y"
 action :run
end


