class Parking
  constructor: (@attributes) ->
  get: (name) -> @attributes[name]
  set: (name, value) -> @attributes[name] = value

  location: ->
    @_location ||= new google.maps.LatLng @get('lat'), @get('lng')

  marker: -> @_marker
  setMarker: (@_marker) ->

  addMarker: (@map) ->
    @setMarker new google.maps.Marker
      position: @location()
      map: @map
      title:"Hello World!"
    google.maps.event.addListener @marker(), 'click', @toggleInfoWindow

  contentNode: ->
    $("[data-parking-id=#{@get('id')}]")[0]

  infoWindow: ->
    @_info ||= new google.maps.InfoWindow
      content: @contentNode()

  infoWindowDisplayed: ->
    @_info_displayed || false

  openInfoWindow: ->
    @closeAllInfoWindows()
    @infoWindow().open @map, @marker()
    @_info_displayed = true
    google.maps.event.addListener @infoWindow(), 'closeclick', =>
      delete @_info_displayed

  closeInfoWindow: ->
    @infoWindow().close()
    delete @_info_displayed

  closeAllInfoWindows: ->
    @collection.each (i, item) -> item.closeInfoWindow()

  toggleInfoWindow: =>
    if @infoWindowDisplayed()
      @closeInfoWindow()
    else
      @openInfoWindow()

class ParkingCollection
  constructor: (models)->
    @models = []
    @reset(models) if models

  reset: (models) ->
    $.each models, (index, model) =>
      @models.push new Parking(model.parking)

  add: (model) ->
    @models.push model

  get: (i) ->
    @models[i]

  each: (callback) ->
    $.each @models, callback

window.App ||= {}
window.App.Parking = Parking
window.App.ParkingCollection = ParkingCollection
