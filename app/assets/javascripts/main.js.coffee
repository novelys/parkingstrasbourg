$ ->
  window.parkings = {}
  window.parkings.name_filter     = new App.NameFilter($, _)
  window.parkings.default_sorter  = new App.DefaultSorter($, _)
  window.parkings.distance_sorter = new App.DistanceSorter($, _, window.parkings.default_sorter)
