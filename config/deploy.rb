# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'kalibro_gatekeeper'
set :repo_url, 'https://github.com/mezuro/kalibro_gatekeeper.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/gatekeeper/app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# User info
set :user, 'gatekeeper'

# RVM
set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs
set :rvm_type, :system
set :rvm_install_with_sudo, true

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "touch #{File.join(current_path,'tmp','restart.txt')}"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  before :compile_assets, :config_symlinks do
    on roles(:web) do
      execute "ln -s #{File.join(deploy_to, 'shared', 'config/database.yml')} #{File.join(release_path, 'config/database.yml')}"
      execute "ln -s #{File.join(deploy_to, 'shared', 'config/kalibro.yml')} #{File.join(release_path, 'config/kalibro.yml')}"
    end
  end

  after :finishing, 'deploy:cleanup'
end
