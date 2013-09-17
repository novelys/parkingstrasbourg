set(:deploy_to) { '/home/rails19/www/parkingstrasbourg' }
set(:user) { "rails19" }
set(:runner) { "rails19" }

server 'staging.novelys.com', :app, :web, :db, primary: true
