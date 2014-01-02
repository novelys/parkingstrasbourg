set :default_environment, {
  'PATH' => "/home/parkingstrasbourg/.rbenv/shims:/home/parkingstrasbourg/.rbenv/bin:$PATH"
}
set(:deploy_to) { "/home/parkingstrasbourg/www/#{application}" }

set :user, "parkingstrasbourg"
set :runner, "parkingstrasbourg"
set :use_sudo, false
set :rails_env, "staging"

set :branch, "staging"

role :app, "staging.novelys.com", :primary => true
role :web, "staging.novelys.com", :primary => true
role :indexer, "staging.novelys.com"
role :db, "staging.novelys.com", :primary => true
