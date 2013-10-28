class DistanceSorter
  constructor: (@$, @_, @gm, @default_sorter) ->
    @dispatchEvents()

  # Service objects
  geocoderService: -> @_geocoder ||= new @gm.Geocoder();
  distanceService: -> @_distance ||= new @gm.DistanceMatrixService()
  geoloc         : -> navigator.geolocation

  # DOM referefences
  currentLocationItem: -> @_icon ||= @$('#location-filter')
  addressItem        : -> @_address ||= @$('#address-filter')
  container          : -> @_container ||= @$('.parkings')
  _nodes             : -> @container().find('.parking')
  nodes              : -> @_(@_nodes())
  sortedNodes        : -> @nodes().sortBy (item) => @$(item).data('duration')

  # Keep state
  resetFetched: -> @_fetched = 0
  incFetched:   -> @_fetched += 1
  allFetched:   -> @_fetched == @_nodes().length
  enabled:      -> @_enabled

  enable: ->
    @currentLocationItem().addClass('switched-on')
    @currentLocationItem().attr 'title', @currentLocationItem().data('alt-enabled')
    @_enabled = true

  disable: ->
    @currentLocationItem().removeClass('switched-on')
    @currentLocationItem().attr 'title', @currentLocationItem().data('alt-disabled')
    delete @_enabled

  # Events
  supported: -> Modernizr.geolocation

  dispatchEvents: ->
    @currentLocationItem().on 'click', @iconWasClicked
    @addressItem().on 'change', @textFieldWasFilled
    @addressItem().on 'keyup', @textFieldKeyWasHit

  iconWasClicked: =>
    return false unless navigator.geolocation?

    if @enabled()
      @unsort()
      @disable()
    else
      @updateLabels('ongoing')
      @geoloc().getCurrentPosition(@fetchDistances);
      @enable()

    false

  textFieldKeyWasHit: (event) =>
    if event.keyCode == 13 # Enter
      @addressItem().trigger 'change'
      return false
    if event.keyCode == 27 # ESC
      @addressItem().val('')
      @unsort()
      @disable()
      return false

  textFieldWasFilled: (event) =>
    if @enabled()
      @unsort()
      @disable()
    else
      @updateLabels('ongoing')
      @geocodeAddress @$(event.target).val()
      @enable()
    false

  updateMainParking: (source) -> @parking_map.setLocation(@position, source)

  # Sorting
  unsort: ->
    if @name_filter.hasInput()
      @name_filter.updateUI()
    else
      @default_sorter.call()
    @updateLabels('disabled')

  sort: ->
    @currentLocationItem().addClass 'switched-on'
    @updateLabels('enabled')
    @currentLocationItem().attr 'title', @currentLocationItem().data('alt-enabled')
    @container().html @sortedNodes()

  geocodeAddress: (address) =>
    @geocoderService().geocode {address}, (results, status) =>
      return false unless status == @gm.GeocoderStatus.OK
      location = results[0].geometry.location
      position = {coords: {latitude: location.lb, longitude: location.mb}}
      @fetchDistances(position, 'geocoder')

  fetchDistances: (@position, source) =>
    @updateMainParking(source)
    origin = new @gm.LatLng @position.coords.latitude, @position.coords.longitude
    @resetFetched()

    @nodes().each (item, index, collection) =>
      node = @$(item)
      dest = new @gm.LatLng parseFloat(node.data('lat')), parseFloat(node.data('lng'))

      opts =
        origins: [origin]
        destinations: [dest]
        travelMode: @gm.TravelMode.DRIVING
        durationInTraffic: true

      @distanceService().getDistanceMatrix opts, (response, status) =>
        # Keep track of fetched distances
        @incFetched()

        # Update node if OK
        if status == "OK" && (rows = response.rows).length > 0
          @updateNode(node,  rows[0].elements[0].duration)

        # Sort the parkings if all are fetched
        @sort() if @allFetched()

  updateNode: (node, duration) ->
    node.data 'duration', duration.value
    node.addClass('has-duration')
    text = "<span class='icon-car'></span><span class='icon-arrow-right'></span><span class='duration'>#{duration.text}</span>"
    node.find('.parking-distance').html(text)

  updateLabels: (selector) ->
    @$('.location-filter-label').addClass('hidden')
    @$(".location-filter-label.#{selector}").removeClass('hidden')

window.App ||= {}
window.App.DistanceSorter = DistanceSorter
