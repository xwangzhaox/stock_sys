#!/usr/bin/env puma

directory '/home/wwwroot/www/shiyingbi/current'
rackup "/home/wwwroot/www/shiyingbi/current/config.ru"
environment 'production'

tag ''

pidfile "/home/wwwroot/www/shiyingbi/shared/tmp/pids/puma.pid"
state_path "/home/wwwroot/www/shiyingbi/shared/tmp/pids/puma.state"
stdout_redirect '/home/wwwroot/www/shiyingbi/shared/log/puma_access.log', '/home/wwwroot/www/shiyingbi/shared/log/puma_error.log', true


threads 0,16



bind 'unix:///home/wwwroot/www/shiyingbi/shared/tmp/sockets/puma.sock'

workers 0




restart_command 'bundle exec puma'


prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end