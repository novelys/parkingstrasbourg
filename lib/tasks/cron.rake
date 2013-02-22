namespace :cron do
  desc ''
  task :fetch_parkings => :environment do
    Parking.fetch_all
  end
end