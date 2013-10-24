class DistanceSorter
  constructor: (@$, @_, @default_sorter) ->
    @dispatchEvents()

  # DOM referefences
  domItem    : -> @_icon ||= @$('.icon-location')
  container  : -> @_container ||= @$('.parkings')
  nodes      : -> @_(@container().find('.parking'))
  sortedNodes: -> @nodes().sortBy @distanceSorter

  # Keep state
  enabled: -> @_enabled
  enable: ->
    @domItem().addClass('switched-on')
    @domItem().attr 'title', @domItem().data('alt-enabled')
    @_enabled = true
  disable: ->
    @domItem().removeClass('switched-on')
    @domItem().attr 'title', @domItem().data('alt-disabled')
    delete @_enabled

  # Events
  dispatchEvents: ->
    @domItem().on 'click', @iconWasClicked

  iconWasClicked: =>
    return unless navigator.geolocation?

    if @enabled()
      @unsort()
      @disable()
    else
      navigator.geolocation.getCurrentPosition(@sort);
      @enable()

  # Sorting
  unsort: ->
    if @name_filter.hasInput()
      @name_filter.updateUI()
    else
      @default_sorter.call()

  sort: (@position) =>
    @domItem().addClass 'switched-on'
    @domItem().attr 'title', @domItem().data('alt-enabled')
    @container().html @sortedNodes()

  distanceSorter: (item) =>
    node = @$(item)
    # Distance between coords
    distanceBetween = (lat1, lon1, lat2, lon2) ->
      toRad = (num) -> num * Math.PI / 180
      r = 6371;
      dLat = toRad(lat2-lat1)
      dLon = toRad(lon2-lon1)
      lat1 = toRad(lat1)
      lat2 = toRad(lat2)

      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *  Math.sin(dLon/2) * Math.sin(dLon/2);
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

      r * c

    distanceBetween(@position.coords.latitude, @position.coords.longitude, parseFloat(node.data('lat')), parseFloat(node.data('lng')))

window.App ||= {}
window.App.DistanceSorter = DistanceSorter
