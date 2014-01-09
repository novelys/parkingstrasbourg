set(:deploy_to) { "/home/#{application}/www" }
set :rails_env, "staging"
set :branch,    fetch(:branch, "staging")

role :app,      "staging.novelys.com", primary: true
role :web,      "staging.novelys.com", primary: true
role :db,       "staging.novelys.com", primary: true
