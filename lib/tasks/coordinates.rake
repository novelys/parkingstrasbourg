namespace :coordinates do
  desc 'Setup parking coordinates'
  task refresh:  :environment do
    Parking.fetch_coords
  end

  desc 'Setup geocoding'
  task reverse_geocode:  :environment do
    Parking.all.each { |parking| parking.reverse_geocode; parking.save }
  end
end
