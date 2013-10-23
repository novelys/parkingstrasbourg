$ ->
  filter = ->
    field = $(this)
    collection = $('.parking').each (index, item) =>
      name = $(item).find('.parking-name').data('clean')
      console.log  name.toLowerCase(), field.val().toLowerCase()
      if name.toLowerCase().indexOf(field.val().toLowerCase()) != -1
        $(item).removeClass('veiled')
      else
        $(item).addClass('veiled')

  $('#name-filter').on('keyup', _.throttle(filter, 300))
