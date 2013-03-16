set :default_environment, {
  'PATH' => "~/.rbenv/shims:~/.rbenv/bin:$PATH"
}

set :user, "parkingstrasbourg"
set :runner, "parkingstrasbourg"
set :use_sudo, false
set :rails_env, "production"

set :branch, "production"

#role :app, "webapp01.novelys.com", :primary => true
role :app, "webapp02.novelys.com"
#role :web, "webapp01.novelys.com", :primary => true
role :web, "webapp02.novelys.com"
#role :db, "webapp01.novelys.com", :primary => true
role :db, "webapp02.novelys.com"
role :whenever, "webapp02.novelys.com", :primary => true

