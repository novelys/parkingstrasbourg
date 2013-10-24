class NameFilter
  constructor: (@$, @_) ->
    @dispatchEvents()

  input      : -> @_input ||= @$('#name-filter')
  container  : -> @_container ||= @$('.parkings')
  nodes      : -> @_(@container().find('.parking'))
  orderSorter: (item) => @$(item).data('index')
  sortedNodes: (nodes) -> @_(nodes).sortBy @orderSorter
  call       : => @container().html @filteredNodes()

  dispatchEvents: ->
    @input().on 'keyup', @_.throttle(@call, 300)

  filteredNodes: =>
    input = @input().val().toLowerCase()
    priority = []
    others   = []

    @nodes().each (item) =>
      node = @$(item)
      name = node.find('.parking-name').data('clean').toLowerCase()

      if name.indexOf(input) != -1
        priority.push(node)
        node.removeClass('veiled')
      else
        others.push(node)
        node.addClass('veiled')

    @sortedNodes(priority).concat(@sortedNodes(others))

window.App ||= {}
window.App.NameFilter = NameFilter
