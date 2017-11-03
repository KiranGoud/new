#
# Cookbook:: sap_conf
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
template "/etc/systemd/logind.conf.d/sap.conf" do
source "sap.conf.erb"
owner 'sap'
group 'sap'
mode '0755'
end
execute "install sapconf" do
command "zypper install sapconf"
action :run
end
execute "tuned" do
command "tuned-adm profile sap-hana"
action :run
end
execute "start the tune" do
command "systemctl start tuned"
action :run
end
execute "enable tuned" do
command "systemctl enable tuned"
action :run
end
execute 'reload grub' do
 command 'grub2-mkconfig -o /boot/grub2/grub.cfg'
 action :nothing
end
=begin
bash 'install_something' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  zypper install sapconf
  tuned-adm profile sap-hana
  systemctl start tuned
  systemctl enable tuned
  EOH
end
=end

ruby_block 'turn off autoNUMA balancing' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/default/grub')
    rc.search_file_replace_line('numa_balancing=disable',
       'numa_balancing=disable')
    rc.write_file
  end
 notifies :run, 'execute[reload grub]', :immediately
end
bash 'enable kernel' do
  user 'sap'
  code <<-EOH
echo never > /sys/kernel/mm/transparent_hugepage/enabled
  EOH
end

ruby_block 'Disable transparent hugepages' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/default/grub')
    rc.search_file_replace_line('numa_balancing=disable',
       'numa_balancing=disable')
    rc.write_file
  end
 notifies :run, 'execute[reload grub]', :immediately
end
ruby_block 'Configure C-States' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/default/grub')
    rc.search_file_replace_line('numa_balancing=disable',
       'numa_balancing=disable')
    rc.write_file
  end
 notifies :run, 'execute[reload grub]', :immediately
end
ruby_block 'Configure CPU Frequency' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/init.d/boot.local')
    rc.insert_line_if_no_match('cpupower frequency-set -g performance',
       'cpupower frequency-set -g performance')
    rc.write_file
  end
 notifies :run, 'execute[reload grub]', :immediately
end
