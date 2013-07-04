namespace :coordinates do
  desc 'Setup parking coordinates'
  task refresh:  :environment do
    Parking.fetch_coords
  end
end
