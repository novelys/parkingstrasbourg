module MapsHelper
  def google_maps_url
    key = ENV['GMAPS_API_KEY']
    "https://maps.googleapis.com/maps/api/js?key=#{key}&sensor=true"
  end

  def google_maps_tag
    javascript_include_tag google_maps_url
  end
end
