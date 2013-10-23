require 'nokogiri'
require 'open-uri'

class Parking
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  ## Metadata
  ENDPOINTS = {
    config: 'http://jadyn.strasbourg.eu/jadyn/config.xml',
    availabilities: 'http://jadyn.strasbourg.eu/jadyn/dynn.xml',
    coordinates: 'http://parkings.api.strasbourg-data.fr/parkings'
  }

  ## Relationships
  has_many :availabilities do
    def build_from_parking_data(data)
      availability = build
      availability.is_closed = case data["Etat"].to_s
      when "2", "9", "0", "3"
        true
      when "1"
        false
      else
        raise StandardError
      end
      availability.total = data["Total"]
      availability.available = data["Libre"]
      availability.user_info = data["InfoUsager"]
      availability
    end

    def create_from_parking_data(data)
      build_from_parking_data(data).save
    end
  end

  ## Schema
  field :name,          type: String
  field :internal_name, type: String
  field :external_id,   type: Integer
  field :lat,           type: Float
  field :lng,           type: Float
  field :address,       type: String
  reverse_geocoded_by :coordinates

  ## Indexes
  index internal_name: 1

  ## Scopes
  default_scope asc(:internal_name)

  ## Callbacks
  before_save :set_internal_name

  ## Class methods
  # Create/update the list of parkings.
  def self.fetch_all
    doc = Nokogiri::XML open(ENDPOINTS[:config])

    doc.xpath('//TableDesParcsDeStationnement/PRK').each do |parking_data|
      parking = Parking.find_or_create_by name: parking_data["Nom"], external_id: parking_data["Ident"]
    end
  end

  # Fetch parkings current availabilities.
  def self.refresh_all
    doc = Nokogiri::XML open(ENDPOINTS[:availabilities])

    doc.xpath('//TableDonneesParking/PRK').each do |parking_data|
      parking = Parking.find_by(external_id: parking_data["Ident"])

      raise StandardError if parking.nil?

      parking.availabilities.create_from_parking_data(parking_data)
    end
  end

  # Fetch parking coordinates
  def self.fetch_coords
    response = JSON.parse open(ENDPOINTS[:coordinates]).read

    response.each do |parking_data|
      p = where(external_id: parking_data['id']).first

      if p.present?
        p.lat = parking_data['latitude']
        p.lng = parking_data['longitude']
        p.save
      end
    end
  end

  ## Methods
  delegate :total, :available, :user_info, :is_closed?, :is_full?, :last_refresh_at,
    to: :last_availability, allow_nil: true

  def last_availability
    @last_availability ||= availabilities.last
  end

  def previous_availability
    @previous_availability ||= availabilities.where(:created_at.gte => 30.minutes.ago, :created_at.lte => 25.minutes.ago).first
    @previous_availability ||= availabilities.where(:created_at.lte => 30.minutes.ago).first
  end

  def coordinates
    [lng, lat]
  end

  def trend
    @trend ||= Trend.new(self)
  end

  def trend_and_previous_available
    previous = trend.unknown? && "N/A" || previous_availability.available

    [trend, previous]
  end

  def pr?
    name =~ /P\+R/
  end

  def base_name
    pr? && name[4..-1] || name
  end

  def sort_criteria
    is_full? && 1 || is_closed? && 2 || 0
  end

  private

  def set_internal_name
    self.internal_name = name =~ /P\+R/ ? (name.gsub("P+R ", "")+" (P+R)") : name
  end
end
