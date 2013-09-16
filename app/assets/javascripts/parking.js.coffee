class Parking
  constructor: (@attributes) ->
  get: (name) -> @attributes[name]
  set: (name, value) -> @attributes[name] = value

  location: ->
    @_location ||= new google.maps.LatLng @get('lat'), @get('lng')

  addMarker: (@map) ->
    @_marker ||= new google.maps.Marker
      position: @location()
      map: @map
      title:"Hello World!"

class ParkingCollection
  constructor: (models)->
    @models = []
    @reset(models) if models

  reset: (models) ->
    $.each models, (index, model) =>
      @models.push new Parking(model)

  add: (model) ->
    @models.push model

  get: (i) ->
    @models[i]

  each: (callback) ->
    $.each @models, callback

window.App ||= {}
window.App.Parking = Parking
window.App.ParkingCollection = ParkingCollection
