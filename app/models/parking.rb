require 'nokogiri'
require 'open-uri'

class Parking
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :availabilities

  field :name, type: String
  field :external_id, type: Integer

  cattr_accessor :name_and_identifier_flux
  @@name_and_identifier_flux = 'http://jadyn.strasbourg.eu/jadyn/config.xml'

  cattr_accessor :availabilities_flux
  @@availabilities_flux = 'http://jadyn.strasbourg.eu/jadyn/dynn.xml'

  delegate :total,
    :available,
    :user_info,
    :to => :last_availability

  def last_availability
    @last_availability ||= availabilities.last
  end

  def self.fetch_all
    doc = Nokogiri::XML(open(name_and_identifier_flux))

    doc.xpath('//TableDesParcsDeStationnement/PRK').each do |parking_data|
      parking = Parking.find_or_create_by name: parking_data["Nom"], external_id: parking_data["Ident"]
    end
  end

  def self.refresh_all
    doc = Nokogiri::XML(open(availabilities_flux))

    doc.xpath('//TableDonneesParking/PRK').each do |parking_data|
      parking = Parking.find_by(external_id: parking_data["Ident"])
      if parking
        availability = parking.availabilities.build
        availability.is_closed = case parking_data["Etat"].to_s
        when "2"
          false
        when "1"
          true
        else
          raise StandardError
        end
        availability.total = parking_data["Total"]
        availability.available = parking_data["Libre"]
        availability.user_info = parking_data["InfoUsager"]
        availability.save
      else
        raise StandardError
      end
    end
  end
end
