$ ->
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
