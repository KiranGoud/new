environment = "#{node.chef_environment}"
app_user = "#{node[:app_user]}"
app_user_group =  "#{node[:app_user_group]}"
path =  "#{node[:path]}"
wgcart_repository = "#{node[:cartRepository]}"
ruby_version = "#{node[:ruby_version]}"
unicorn_pid = "#{node[:unicorn_pid]}"
err_log = "#{node[:err_log]}"
out_log = "#{node[:out_log]}"
send_quit = "#{node[:send_quit]}"
socket_path = "#{node[:socket]}"
before_exec = "#{node[:before_exec]}"
unicorn_command_line = "#{node[:unicorn_command_line]}"
api_deploy_key = data_bag_item('deploy', 'wgcart')["deploy_key"]
socket = Hash.new
socket[socket_path]= ""



include_recipe "rbenv"
include_recipe "rbenv::rbenv_vars"
include_recipe "rbenv::ruby_build"

rbenv_ruby ruby_version do
  ruby_version ruby_version
  global true
end

rbenv_gem "bundler" do
  ruby_version ruby_version
end

directory "#{path}/wgcart/shared/log" do
  owner app_user
  group app_user
  mode 0755
  action :create
  recursive true
end

application "wgcart" do
  path "#{path}/wgcart"
  owner app_user
  group app_user_group
  repository wgcart_repository

  deploy_key api_deploy_key
  environment  'RAILS_ENV' => environment,
               'HOME' => "/root"
  revision environment
  shallow_clone true
  rails do
    bundler true
    precompile_assets true
    environment  'RAILS_ENV' => environment,
                 'HOME' => "/root"
  end
  unicorn do
    bundler true
    listen socket
    preload_app true
    pid unicorn_pid
    stderr_path  err_log
    stdout_path  out_log
    before_exec before_exec
    before_fork send_quit
    unicorn_command_line unicorn_command_line
    if File.exists?(unicorn_pid)
    restart_command "sv 2 wgcart"
    end
  end

  nginx_load_balancer do
    template "balancer.conf.erb"
    set_host_header true
    application_socket ["/var/run/wgcart.sock fail_timeout=0"]
  end
end

