class IdealFinder
  constructor: (@$) ->
    @dispatchEvents()

  # Service objects
  geoloc: -> navigator.geolocation

  # DOM referefences
  $linkItem: -> @_link ||= @$('.ideal a')
  enable: ->
    @$('.disabled').addClass('hidden')
    @$(".enabled-#{@source()}").removeClass('hidden')
    @$('.filters').addClass('hidden')

  # Events
  supported: -> Modernizr.geolocation

  dispatchEvents: ->
    if @supported()
      @$linkItem().on 'click', @linkWasClicked

  source: ->
    @distance_sorter.source() || 'geoloc'

  linkWasClicked: (event) =>
    @enable()
    @href = @$(event.currentTarget).attr('href')

    if @source() == 'geoloc'
      @geoloc().getCurrentPosition(@redirectToIdeal)
    else
      @redirectToIdeal(@distance_sorter.position)

    false

  redirectToIdeal: (@position) =>
    params = "lat=#{position.coords.latitude}&lng=#{position.coords.longitude}"

    if @href.indexOf('?') != -1
      @href = "#{@href}&#{params}"
    else
      @href = "#{@href}?#{params}"

    window.location = @href


window.App ||= {}
window.App.IdealFinder = IdealFinder
