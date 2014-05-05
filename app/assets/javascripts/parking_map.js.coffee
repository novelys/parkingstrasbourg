class ParkingMap
  constructor: (@$, @gm) ->
    @dispatchEvents()

  $container    : -> @_container = @$('#parking-map')
  container     : -> @$container()?[0]
  map           : -> @_map
  shouldDisplay : -> @container()?
  dispatchEvents: -> @gm.event.addDomListener document, 'page:change', @initMap
  latitude      : -> parseFloat @$container().data('lat')
  longitude     : -> parseFloat @$container().data('lng')
  parkingName   : -> @$container().data('name')
  center        : -> new @gm.LatLng @latitude(), @longitude()

  setLocation: (@position, source) ->
    label = if source then @distance_sorter.$addressItem().val() else "lieu actuel"
    link = "http://maps.google.com/?saddr=#{@position.coords.latitude},#{@position.coords.longitude}&daddr=#{@latitude()},#{@longitude()}&dirflg=d"

    @$('.map-link').html("<a href='#{link}''>Itinéraire depuis #{label}</a>")

  marker: ->
    new @gm.Marker
      position: @center()
      map: @map()
      title: @parkingName()
      animation: @gm.Animation.DROP

  initMap: =>
    return false unless @shouldDisplay()

    mapOptions =
      center: @center()
      zoom: 16
      mapTypeId: @gm.MapTypeId.ROADMAP

    @_map = new @gm.Map @container(), mapOptions
    @marker()

window.App ||= {}
window.App.ParkingMap = ParkingMap
