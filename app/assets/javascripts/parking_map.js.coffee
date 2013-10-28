class ParkingMap
  constructor: (@$, @gm) ->
    @dispatchEvents()

  $container   : -> @_container ||= @$('#parking-map')
  container    : -> @$container()?[0]
  map          : -> @_map
  shouldDisplay: -> @container?

  dispatchEvents: ->
    return false unless @shouldDisplay()
    @gm.event.addDomListener window, 'load', @initMap


  latitude : -> parseFloat @$container().data('lat')
  longitude: -> parseFloat @$container().data('lng')

  parkingName: ->
    @_name ||= @$container().data('name')

  center: ->
    @_center ||= new @gm.LatLng @latitude(), @longitude()

  marker: ->
    @_marker ||= new @gm.Marker
      position: @center()
      map: @map()
      title: @parkingName()
      animation: @gm.Animation.DROP

  initMap: =>
    mapOptions =
      center: @center()
      zoom: 16
      mapTypeId: @gm.MapTypeId.ROADMAP

    @_map = new @gm.Map @container(), mapOptions
    @marker()

window.App ||= {}
window.App.ParkingMap = ParkingMap
