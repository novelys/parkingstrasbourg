class DefaultSorter
  constructor: (@$, @_) ->
  container  : -> @_container = @$('.parkings .thumbnails')
  nodes      : -> @_(@container().find('.parking'))
  sortedNodes: -> @nodes().sortBy (item) => @$(item).data('index')
  call       : -> @container().html @sortedNodes()

window.App ||= {}
window.App.DefaultSorter = DefaultSorter
