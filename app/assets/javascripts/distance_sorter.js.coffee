class DistanceSorter
  constructor: (@$, @_, @default_sorter) ->
    @dispatchEvents()

  # Service objects
  distanceService: -> @_service ||= new google.maps.DistanceMatrixService()
  geoloc         : -> navigator.geolocation

  # DOM referefences
  domItem    : -> @_icon ||= @$('.icon-location')
  container  : -> @_container ||= @$('.parkings')
  _nodes     : -> @container().find('.parking')
  nodes      : -> @_(@_nodes())
  sortedNodes: -> @nodes().sortBy (item) => @$(item).data('duration')

  # Keep state
  resetFetched: -> @_fetched = 0
  incFetched:   -> @_fetched += 1
  allFetched:   -> @_fetched == @_nodes().length
  enabled:      -> @_enabled

  enable: ->
    @domItem().addClass('switched-on')
    @domItem().attr 'title', @domItem().data('alt-enabled')
    @_enabled = true

  disable: ->
    @domItem().removeClass('switched-on')
    @domItem().attr 'title', @domItem().data('alt-disabled')
    delete @_enabled

  # Events
  supported: -> Modernizr.geolocation

  dispatchEvents: ->
    @domItem().on 'click', @iconWasClicked

  iconWasClicked: =>
    return unless navigator.geolocation?

    if @enabled()
      @unsort()
      @disable()
    else
      @geoloc().getCurrentPosition(@fetchDistances);
      @enable()

  # Sorting
  unsort: ->
    if @name_filter.hasInput()
      @name_filter.updateUI()
    else
      @default_sorter.call()

  sort: ->
    @domItem().addClass 'switched-on'
    @domItem().attr 'title', @domItem().data('alt-enabled')
    @container().html @sortedNodes()

  fetchDistances: (@position) =>
    origin = new google.maps.LatLng @position.coords.latitude, @position.coords.longitude
    @resetFetched()

    @nodes().each (item, index, collection) =>
      node = @$(item)
      dest = new google.maps.LatLng parseFloat(node.data('lat')), parseFloat(node.data('lng'))

      opts =
        origins: [origin]
        destinations: [dest]
        travelMode: google.maps.TravelMode.DRIVING
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

window.App ||= {}
window.App.DistanceSorter = DistanceSorter
