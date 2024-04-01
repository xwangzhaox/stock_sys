# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "shiyingbi"
set :repo_url, "git@github.com:xwangzhaox/shiyingbi.git"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/packages", "public/system", "public/uploads", "public/downloads", "public/upload_design_image", "vendor/bundle",".bundle"
append :linked_files, "config/database.yml", "config/master.key"

set :rvm_ruby_version, '3.0.0'
set :deploy_to, "/home/wwwroot/www/shiyingbi"
set :bundle_gemfile, -> { release_path.join('Gemfile') } 

set :sidekiq_service_unit_user, :system # :system
SSHKit.config.command_map[:sidekiq] = "bundle exec sidekiq"
SSHKit.config.command_map[:sidekiqctl] = "bundle exec sidekiqctl"

before "deploy:assets:precompile", "deploy:yarn_install"
namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --ignore-engines --silent --no-progress --no-audit --no-optional")
        execute("npm config set strict-ssl false")
        execute("npm install webpack@4.46.0")
        execute("npm install webpack-cli@4.8.0")
      end
    end
  end
end

namespace :deploy do
  namespace :check do
    desc 'Create Directories for Pid, Log and Socket'
    task :make_pid_log_and_socket_dirs do
      on roles(:all) do
        execute "mkdir -p #{shared_path}/tmp/sockets"
        execute "mkdir -p #{shared_path}/tmp/pids"
        execute "mkdir -p #{shared_path}/log"
      end
    end
  end
end

namespace :deploy do
  namespace :check do
    desc 'Create Directories for Pid, Log and Socket'
    task :make_upload_design_image_dir do
      on roles(:all) do
        execute "mkdir -p #{shared_path}/public/upload_design_image"
      end
    end
  end
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
