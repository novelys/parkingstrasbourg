class DistanceSorter
  constructor: (@$, @_, @gm, @default_sorter) ->
    @_source = 'geoloc'
    @initAutoComplete()
    @dispatchEvents()

  # Service objects
  completeService: -> @_complete
  geocoderService: -> @_geocoder ||= new @gm.Geocoder()
  distanceService: -> @_distance ||= new @gm.DistanceMatrixService()
  geoloc         : -> navigator.geolocation

  initAutoComplete: ->
    if @isRelevant()
      opts =
        bounds: new @gm.LatLngBounds(new @gm.LatLng(48.53047, 7.62486), new @gm.LatLng(48.62224, 7.81960))
        types: ['geocode']

      @_complete ||= new @gm.places.Autocomplete(@addressItem(), opts)

  # DOM referefences
  currentLocationItem: -> @$('#location-filter')
  $addressItem       : -> @$('#address-filter')
  addressItem        : -> @$addressItem()?[0]
  container          : -> @$('.parkings .thumbnails')
  _nodes             : -> @container().find('.parking')
  nodes              : -> @_(@_nodes())
  sortedNodes        : -> @nodes().sortBy (item) => @$(item).data('duration')

  # Keep state
  isRelevant:   -> @$addressItem().length > 0
  resetFetched: -> @_fetched = 0
  incFetched:   -> @_fetched += 1
  allFetched:   -> @_fetched == @_nodes().length
  enabled:      -> @_enabled
  source:       -> @_source
  noResults:    -> @_no_results = true
  hasNoResults: -> @_no_results

  enable: ->
    @currentLocationItem().attr 'title', @currentLocationItem().data('alt-enabled')
    @_enabled = true

  disable: ->
    @$addressItem().val('')
    @currentLocationItem().attr 'title', @currentLocationItem().data('alt-disabled')
    delete @_enabled

  startSorting: ->
    @currentLocationItem().prop('disabled', true)
    @$addressItem().prop('disabled', true)
    @currentLocationItem().find('.fa-spinner').removeClass('hidden')
    @currentLocationItem().find('.fa-map-marker').addClass('hidden')
    @currentLocationItem().find('.fa-times').addClass('hidden')

  stopSorting: ->
    @currentLocationItem().prop('disabled', false)
    @$addressItem().prop('disabled', false)
    @currentLocationItem().find('.fa-spinner').addClass('hidden')

    if @enabled()
      @currentLocationItem().find('.fa-times').removeClass('hidden')
    else
      @currentLocationItem().find('.fa-map-marker').removeClass('hidden')

  # Events
  supported: -> Modernizr.geolocation

  dispatchEvents: ->
    if @isRelevant()
      @currentLocationItem().on 'click', @toggleSorting
      @$addressItem().on 'keyup', @textFieldKeyWasHit
      @gm.event.addListener @_complete, 'place_changed', @geocodeAddress

  disableSorting: =>
    @unsort()
    @disable()

  enableSorting: =>
    @startSorting()
    @updateLabels('ongoing')

    if @_source == 'geoloc'
      if @supported()
        @$addressItem().val('')
        @geoloc().getCurrentPosition(@fetchDistances);
      else
        @disable()
        @stopSorting()
        return false
    else
      @fetchDistances(@position, 'location')

    @enable()

  toggleSorting: =>
    if @enabled() then @disableSorting() else @enableSorting()
    false

  textFieldKeyWasHit: (event) =>
    if event.keyCode == 13 # Enter
      @$addressItem().trigger 'change'
      return false
    if event.keyCode == 27 # ESC
      @$addressItem().val('')
      @unsort()
      @disable()
      return false

  updateMainParking: (source) -> @parking_map.setLocation(@position, source)

  # Sorting
  unsort: ->
    @disable()
    @startSorting()
    @default_sorter.call()
    @stopSorting()
    @updateLabels("disabled-#{@_source}")

  sort: ->
    @currentLocationItem().addClass 'switched-on'
    @updateLabels('enabled')
    @currentLocationItem().attr 'title', @currentLocationItem().data('alt-enabled')
    @container().html @sortedNodes()
    @stopSorting()

  setAddressSource: (@position) ->
    @_source = 'address'
    @updateLabels("disabled-address") unless @enabled()

  geocodeAddress: =>
    place = @completeService().getPlace()
    address = place.formatted_address || place.name

    @geocoderService().geocode {address}, (results, status) =>
      if status == @gm.GeocoderStatus.OK
        location = results[0].geometry.location
        @setAddressSource {coords: {latitude: location.lat(), longitude: location.lng()}}
        @_source = 'location'
        @disableSorting()
        @enableSorting()
      else
        delete @position
        @_source = 'geoloc'
        @updateLabels("disabled-geoloc") unless @enabled()

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
        return false if @hasNoResults()

        # Update node if OK
        if status == "OK" && (rows = response.rows).length > 0
          if rows[0].elements[0].status == "ZERO_RESULTS"
            @noResults()
            @disable()
            @stopSorting()
          else
            # Keep track of fetched distances
            @incFetched()

            @updateNode(node,  rows[0].elements[0].duration)

        # Sort the parkings if all are fetched
        @sort() if @allFetched()

  updateNode: (node, duration) ->
    node.data 'duration', duration.value
    node.addClass('has-duration')
    text = "<span class='icomoon-car'></span><span class='icomoon-arrow-right'></span><span class='duration'>#{duration.text}</span>"
    node.find('.parking-distance').html(text)

  updateLabels: (selector) ->
    @$('.location-filter-label').addClass('hidden')
    @$(".location-filter-label.#{selector}").removeClass('hidden')

window.App ||= {}
window.App.DistanceSorter = DistanceSorter
