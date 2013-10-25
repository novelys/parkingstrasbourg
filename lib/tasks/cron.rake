namespace :cron do
  desc 'Refresh parkings and availabilities'
  task refresh_parkings: :environment do
    service = ParkingService.new
    service.update_locations
    service.update_occupations
  end
end
