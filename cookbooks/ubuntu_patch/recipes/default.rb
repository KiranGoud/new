directory "/mnt/my-backup" do
  owner 'root'
  group 'root'
  recursive true
  action :create
  mode '0755'

end
execute "copy_core" do
command "cp -a /etc/* /mnt/my-back-up"
user "root"
end

execute "apt update" do
command "apt-get update -y"
action :run
end

execute "apt dist-upgrade" do
command "apt-get dist-upgrade -y"
action :run
end

execute "apt update-manager-core" do
command "apt-get update-manager-core"
action :run
end

execute "do-release-upgrade" do
command "do-release-upgrade "
action :run
end
execute "do-release-upgrade" do
command "do-release-upgrade -d"
end


