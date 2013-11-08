class Trend
  attr_reader :parking

  def initialize(parking)
    @parking = parking
  end

  # Trend of parking availability
  def value
    if current_availability == 0
      :full
    elsif previous_availability.nil?
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
  %w(unknown up down flat full).each do |trend|
    define_method "#{trend}?".to_sym do
      self.value.to_sym == trend.to_sym
    end
  end

  # CSS Class(es) associated with trend
  def css_class
    case value
    when :down
      "trend icomoon-arrow-down-right"
    when :up
      "trend icomoon-arrow-up-right"
    when :flat
      "trend icomoon-arrow-right"
    when :full
      "trend icomoon-confused"
    when :unknown
      "trend icomoon-question-mark"
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
