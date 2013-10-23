set :default_environment, {
  'PATH' => "/home/rails19/.rbenv/shims:/home/rails19/.rbenv/bin:$PATH"
}
set(:deploy_to) { "/home/rails19/www/#{application}" }

set :user, "rails19"
set :runner, "rails19"
set :use_sudo, false
set :rails_env, "staging"

set :branch, "staging"

role :app, "staging.novelys.com", :primary => true
role :web, "staging.novelys.com", :primary => true
role :indexer, "staging.novelys.com"
role :db, "staging.novelys.com", :primary => true
