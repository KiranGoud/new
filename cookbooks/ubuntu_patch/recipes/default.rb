directory "/mnt/my-backup" do
  owner 'root'
  group 'root'
  recursive true
  action :create
  mode '0755'
end

mount '/mnt/my-backup' do
  device '/dev/xvda1'
  fstype 'ext4'
end

bash "copy back up" do
  code <<-EOL
  cp -a /etc/* /mnt/my-backup
  EOL
end

execute "apt update" do
command "apt-get update -y"
action :run
end

execute "apt dist-upgrade" do
command "apt-get dist-upgrade -y"
action :run
end




