jQuery ->
  if $('[data-behavior=map]').length > 0
    window.map_handler = new App.MapHandler
    window.parkings.each (i, item) ->
      item.collection = window.parkings
      item.addMarker(map_handler.mapObject())
