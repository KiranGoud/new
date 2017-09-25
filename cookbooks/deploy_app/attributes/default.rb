gems_version = `gem which rubygems`
version = gems_version.split("/")[-2]
## Application attributes
default['app_user'] = "root"
default['app_user_group'] = "root"
default[:path] = "/opt/usr/apps"
default['ruby_version'] = "2.2.2"
default['unicorn_pid'] = "/opt/usr/apps/wgcart/shared/unicorn.pid"
default['err_log'] = "/opt/usr/apps/wgcart/shared/log/stderr.log"
default['out_log'] = "/opt/usr/apps/wgcart/shared/log/stdout.log"
default['socket'] = "/var/run/wgcart.sock"
default['before_exec'] = "ENV['BUNDLE_GEMFILE'] = '/opt/usr/apps/wgcart/current/Gemfile'"
default['unicorn_command_line'] = "/opt/usr/apps/wgcart/current/vendor/bundle/ruby/#{version}/bin/unicorn"
## attribute for sending the quit signal
default['send_quit'] = "old_pid = '/opt/usr/apps/wgcart/shared/unicorn.pid.oldbin'
      puts 'before fork Initialize'
      if File.exists?(old_pid) && server.pid != old_pid
       puts 'We have got an old pid and server pid is not the old pid'
        begin
          Process.kill('QUIT', File.read(old_pid).to_i)
         puts 'killing master process'
          rescue Errno::ENOENT, Errno::ESRCH
           puts 'unicorn master already killed'
          end
        end
        sleep 1"
## Hosting attributes

## Application repository attributes
default['cartRepository'] = '.........'
