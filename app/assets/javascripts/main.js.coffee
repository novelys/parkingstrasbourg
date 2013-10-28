$ ->
  window.parkings = {}
  parkings.default_sorter  = new App.DefaultSorter($, _)
  parkings.name_filter     = new App.NameFilter($, _)
  parkings.distance_sorter = new App.DistanceSorter($, _, google.maps, parkings.default_sorter, )
  parkings.map             = new App.ParkingMap($, google.maps)

  parkings.name_filter.distance_sorter = parkings.distance_sorter
  parkings.map.distance_sorter = parkings.distance_sorter
  parkings.distance_sorter.name_filter = parkings.name_filter
  parkings.distance_sorter.parking_map = parkings.map
