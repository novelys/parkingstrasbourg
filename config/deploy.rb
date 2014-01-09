require './config/boot'
require 'bundler/setup'
require 'bundler/capistrano'
require 'production_chain/capistrano'
require 'capistrano/ext/multistage'
require 'puma/capistrano'
require "whenever/capistrano"

load 'deploy/assets'

set :application,      "parkingstrasbourg"
set :user,             "parkingstrasbourg"
set :runner,           "parkingstrasbourg"
set :repository,       "git@github.com:novelys/#{application}"
set :keep_releases,    5
set :use_sudo,         false
set :stages,           %w(staging production)
set :scm,              "git"
set :repository_cache, "git_cache"
set :copy_exclude,     [".svn", ".DS_Store", ".git"]
set :bundle_without,   [:development, :test, :cucumber]
set :default_environment, {
  'PATH' => "~/.rbenv/shims:~/.rbenv/bin:$PATH"
}

ssh_options[:forward_agent] = true

## Whenever
set :whenever_roles, "whenever"
set :whenever_command, "bundle exec whenever"

## Hooks
after "deploy:update_code", "db:symlink"
after "deploy:setup", "db:mkdir"
after "deploy", "deploy:cleanup"

## Tasks
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
