require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

delay = ENV['CLOCK_DELAY'] && ENV['CLOCK_DELAY'].to_i || 5

every(delay.minutes, "Fetching parking availabilities (every #{delay}mn)") { ParkingService.perform }
