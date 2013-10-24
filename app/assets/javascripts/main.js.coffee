$ ->
  window.parkings = {}
  window.parkings.default_sorter  = new App.DefaultSorter($, _)
  window.parkings.name_filter     = new App.NameFilter($, _)
  window.parkings.distance_sorter = new App.DistanceSorter($, _, window.parkings.default_sorter)

  window.parkings.name_filter.distance_sorter = parkings.distance_sorter
  window.parkings.distance_sorter.name_filter = parkings.name_filter
