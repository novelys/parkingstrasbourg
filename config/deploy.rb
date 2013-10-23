load 'deploy/assets'

set :application, "parkingstrasbourg"
set :repository, "git@github.com:novelys/#{application}"

set :keep_releases, 5

set :scm, "git"
set :repository_cache, "git_cache"
set :copy_exclude, [".svn", ".DS_Store", ".git"]
set :bundle_without,  [:development, :test, :cucumber]
ssh_options[:forward_agent] = true

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :stages, %w(staging production)
set(:deploy_to) { "/home/#{application}/www/#{application}" }

after "deploy:update_code", "db:symlink"
# before "deploy:assets:precompile", "db:symlink"

after "deploy:setup", "db:mkdir"
after "deploy", "deploy:cleanup"

set :whenever_roles, "whenever"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

namespace :db do
  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/mongoid.yml #{current_release}/config/mongoid.yml"
  end

  desc "Create necessary directories"
  task :mkdir do
    run "mkdir -p #{shared_path}/config"
  end
end

set :unicorn_binary, "bundle exec unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

        require 'bundler/setup'
        require 'production_chain/capistrano'

