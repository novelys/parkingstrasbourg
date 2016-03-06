require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

module Clockwork
  error_handler do |error|
    Rollbar.error(error)
  end

  configure do |config|
    config[:tz] = 'Paris'
  end

  handler do |job, time|
    puts "Running #{job}, at #{time}"
  end

  delay = ENV['CLOCK_DELAY'].present?? ENV['CLOCK_DELAY'].to_i : 5
  every(delay.minutes, "Fetching parking availabilities (every #{delay}mn)") { ParkingService.perform }
end
