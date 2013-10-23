$ ->
  ## Default sorting
  defaultSort = ->
    nodes = $('.parking')
    nodes = _(nodes).sortBy (item) ->
      $(item).data('index')
    $('.parkings').html(nodes)


  ## Filter by name
  filter = ->
    user_input = $(this).val().toLowerCase()
    priority = []
    others   = []
    sorter   = (a, b) ->
      parseInt(a.data('index'), 10) - parseInt(b.data('index'), 10)

    collection = $('.parking').each (index, item) =>
      node     = $(item)
      name     = node.find('.parking-name').data('clean').toLowerCase()


      if name.indexOf(user_input) != -1
        priority.push(node)
        node.removeClass('veiled')
      else
        others.push(node)
        node.addClass('veiled')

    items = priority.sort(sorter).concat(others.sort(sorter))
    $('.parkings').html(items)

  $('#name-filter').on('keyup', _.throttle(filter, 300))

  ## Filter by distance
  sortByPosition = (position) ->
    distanceBetween = (coords, lat2, lon2) ->
      toRad = (num) -> num * Math.PI / 180
      lat1 = coords.latitude
      lon1 = coords.longitude

      r = 6371;
      dLat = toRad(lat2-lat1)
      dLon = toRad(lon2-lon1)
      lat1 = toRad(lat1)
      lat2 = toRad(lat2)

      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *  Math.sin(dLon/2) * Math.sin(dLon/2);
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

      r * c

    nodes = $('.parking')
    nodes = _(nodes).sortBy (item) ->
      distanceBetween(position.coords, parseFloat($(item).data('lat')), parseFloat($(item).data('lng')))

    $('.parkings').html(nodes)

  $('.icon-location').on 'click', ->
    node = $(this)
    if node.hasClass('switched-on')
      node.removeClass('switched-on')
      node.attr 'title', node.data('alt-disabled')
      defaultSort()
    else
      node.addClass('switched-on')
      node.attr 'title', node.data('alt-enabled')
      navigator.geolocation.getCurrentPosition(sortByPosition);
    false
