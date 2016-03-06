module CacheHelper
  def parkings_index_cache_key
    count          = Parking.count
    max_updated_at = Parking.max(:updated_at).try(:utc).try(:to_s, :number)
    "parkings/all-#{count}-#{max_updated_at}"
  end

  def parkings_meta_cache_key
    count          = Parking.count
    max_updated_at = Parking.max(:updated_at).try(:utc).try(:to_s, :number)
    "parkings/meta-#{count}-#{max_updated_at}"
  end

  def parking_index_cache_key(parking)
    [parking, parking.last_refresh_at]
  end

  def parking_meta_cache_key(parking)
    [parking, 'meta']
  end

  def parking_forecast_cache_key(parking, delay)
    key = (Time.now + delay.minutes).strftime('%Y-%m-%d-%H-%M')
    [parking.cache_key, "delay-#{key}"]
  end

  def parking_show_cache_key(parking)
    fragments = parking_forecast_cache_key(parking, 0)
    fragments << "refreshed_at-#{parking.last_refresh_at}"
    fragments
  end

  def navbar_cache_key(parking)
    parking && [parking, 'navbar'] || 'navbar'
  end

  def faq_meta_cache_key
    ['faq', 'meta']
  end

  def faq_cache_key
    ['faq', embedded?]
  end
end
