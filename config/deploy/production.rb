set(:deploy_to) { "/home/#{application}/www/#{application}" }
set :rails_env, "production"
set :branch,    "production"

role :app,      "webapp02.novelys.com", primary: true
role :web,      "webapp02.novelys.com", primary: true
role :db,       "webapp02.novelys.com", primary: true
role :whenever, "webapp02.novelys.com", primary: true
