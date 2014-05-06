class Parking
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  include Mongoid::Slug

  ## Relationships
  has_many :availabilities

  ## Schema
  field :name,          type: String
  field :internal_name, type: String
  field :external_id,   type: Integer
  field :lat,           type: Float
  field :lng,           type: Float
  field :address,       type: String
  reverse_geocoded_by :coordinates

  slug :base_name

  ## Indexes
  index internal_name: 1

  ## Scopes
  default_scope -> { asc(:internal_name) }

  ## Callbacks
  before_save :set_internal_name

  ## Methods
  delegate :total, :available, :is_closed?, :is_full?, :last_refresh_at, :fullish?,
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

  # Returns an array of forecasted availabilities
  def forecast(delay)
    time = delay.minutes.since
    steps = (0..30).to_a.map { |num| time - num.weeks}
    ary = steps.map { |time| self.availabilities.around(time) }.flatten
    ary.reject! &:is_closed?
    ary.sort_by! &:available

    # Removes the lower 10% and the upper 10% in case there is some exterme values
    to_trim = ary.size / 20
    to_trim.times { ary.shift; ary.pop; }

    if block_given?
      yield ary.first.try(:available), ary.last.try(:available)
    else
      [ary.first.try(:available), ary.last.try(:available)]
    end
  end

  def method_missing(name, *args, &block)
    if name.to_s.starts_with?('fullish_')
      delay = name.to_s.split('_').last.to_i

      if (lowest = forecast(delay).first)
        lowest < (total / (10.0))
      else
        true
      end
    else
      super
    end
  end

  private

  def set_internal_name
    self.internal_name = name =~ /P\+R/ ? (name.gsub("P+R ", "")+" (P+R)") : name
  end
end
