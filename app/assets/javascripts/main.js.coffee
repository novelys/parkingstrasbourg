$ ->
  window.map_handler = new App.MapHandler
  window.parkings.each (i, item) -> item.addMarker(map_handler.mapObject())
