require 'bundler/setup'
require 'bundler/capistrano'
require 'production_chain/capistrano'
require 'capistrano/ext/multistage'
require './config/boot'
require 'airbrake/capistrano'
require 'puma/capistrano'

load 'deploy/assets'

set :application, "parkingstrasbourg"
set :repository, "git@github.com:novelys/#{application}"

set :keep_releases, 5

set :scm, "git"
set :repository_cache, "git_cache"
set :copy_exclude, [".svn", ".DS_Store", ".git"]
set :bundle_without,  [:development, :test, :cucumber]
ssh_options[:forward_agent] = true

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
