require 'nokogiri'
require 'open-uri'

class UnknownTrend < StandardError; end;

class Parking
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :availabilities

  field :name, type: String
  field :internal_name, type: String
  field :external_id, type: Integer

  cattr_accessor :name_and_identifier_flux
  @@name_and_identifier_flux = 'http://jadyn.strasbourg.eu/jadyn/config.xml'

  cattr_accessor :availabilities_flux
  @@availabilities_flux = 'http://jadyn.strasbourg.eu/jadyn/dynn.xml'

  delegate :total,
    :available,
    :user_info,
    :is_closed?,
    :last_refresh_at,
    :to => :last_availability,
    :allow_nil => true

  default_scope asc(:internal_name)

  index internal_name: 1

  before_save :set_internal_name

  def set_internal_name
    self.internal_name = name =~ /P\+R/ ? (name.gsub("P+R ", "")+" (P+R)") : name
  end

  def last_availability
    @last_availability ||= availabilities.last
  end

  def previous_availability
    @previous_availability ||= availabilities.where(:created_at.gte => 30.minutes.ago, :created_at.lte => 25.minutes.ago).first || availabilities.where(:created_at.lte => 30.minutes.ago).first
  end

  def trend_and_previous_available
    current_available = self.available
    raise UnknownTrend if previous_availability.nil?
    previous_available = previous_availability.available

    trend = if current_available > previous_available
      :up
    elsif current_available < previous_available
      :down
    else
      :flat
    end

    [trend, previous_available]
  rescue UnknownTrend
    [:unknown, "N/A"]
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
        when "2", "9", "0", "3"
          true
        when "1"
          false
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
