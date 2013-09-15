class Trend
  attr_reader :parking

  def initialize(parking)
    @parking = parking
  end

  # Trend of parking availability
  def value
    if previous_availability.nil?
      :unknown
    elsif current_availability > previous_availability.available
      :up
    elsif current_availability < previous_availability.available
      :down
    else
      :flat
    end
  end

  # Methods to check against a specific value
  %w(unknown up down flat).each do |trend|
    define_method "#{trend}?".to_sym do
      self.value.to_sym == trend.to_sym
    end
  end

  # CSS Class(es) associated with trend
  def css_class
    case value
    when :down
      "trend icon-arrow-down-right"
    when :up
      "trend icon-arrow-up-right"
    when :flat
      "trend icon-arrow-right"
    when :unknown
      "trend icon-question-mark"
    end
  end

  private

  def current_availability
    parking.available
  end

  def previous_availability
    parking.previous_availability
  end
end
