namespace :coordinates do
  desc 'Setup geocoding'
  task reverse_geocode:  :environment do
    Parking.all.each { |parking| parking.reverse_geocode; parking.save }
  end
end
