set :default_environment, {
  'PATH' => "/home/rails19/.rbenv/shims:/home/rails19/.rbenv/bin:$PATH"
}

set :user, "rails19"
set :runner, "rails19"
set :use_sudo, false
set :rails_env, "production"

set :branch, "production"

role :app, "webapp01.novelys.com", :primary => true
role :app, "webapp02.novelys.com"
role :web, "webapp01.novelys.com", :primary => true
role :web, "webapp02.novelys.com"
role :db, "webapp01.novelys.com", :primary => true
role :db, "webapp02.novelys.com"
role :indexer, "webapp01.novelys.com"

