class MapHandler
  config:
    lat: 48.583148
    lng: 7.747882000000004
    zoom: 14
    selector: 'map-canvas'

  constructor: ->
    @mapObject()

  container: ->
    document.getElementById @config.selector

  optionsForGMaps: ->
    center: new google.maps.LatLng(@config.lat, @config.lng)
    zoom: @config.zoom
    mapTypeId: google.maps.MapTypeId.ROADMAP

  mapObject: ->
    @_map ||= new google.maps.Map @container(), @optionsForGMaps()

window.App ||= {}
window.App.MapHandler = MapHandler
