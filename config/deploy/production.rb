set(:deploy_to) { '/home/parkingstrasbourg/www/parkingstrasbourg' }

server 'webapp02.novelys.com', :app, :web, :db, :whenever, primary: true
