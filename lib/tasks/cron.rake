namespace :cron do
  desc 'refresh parking availabilities'
  task :refresh_parkings => :environment do
    Parking.refresh_all
  end
end