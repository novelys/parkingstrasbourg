require 'open-uri'

class ParkingService
  ENDPOINTS = {
    location:   'http://carto.strasmap.eu/remote.amf.json/Parking.geometry',
    occupation: 'http://carto.strasmap.eu/remote.amf.json/Parking.status'
  }

  @queue = :availabilities

  def self.perform
    service = self.new
    service.update_locations
    service.update_occupations
  end

  def update_locations
    json_data = JSON.parse open(ENDPOINTS[:location]).string
    parkings = json_data['s']

    parkings.each do |json|
      parking = Parking.where(external_id: json['id']).first_or_initialize
      parking.name = json['ln']
      parking.lat = json['go']['y']
      parking.lng = json['go']['x']
      parking.save
    end
  end

  def update_occupations
    json_data = JSON.parse open(ENDPOINTS[:occupation]).string
    parkings = json_data['s']

    parkings.each do |json|
      parking = Parking.where(external_id: json['id']).first
      availability = parking.availabilities.build# create_from_parking_data(parking_data)
      availability.is_closed = ['status_3', 'status_4'].include?(json['ds'])
      availability.total = json['dt']
      availability.available = json['df']
      availability.save
      parking.update_attribute :last_refresh_at, Time.now
    end
  end
end
