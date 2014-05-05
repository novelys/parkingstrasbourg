$(document).on 'ready', ->
  window.parkings = {}
  parkings.default_sorter  = new App.DefaultSorter($, _)
  parkings.distance_sorter = new App.DistanceSorter($, _, google.maps, parkings.default_sorter)
  parkings.map             = new App.ParkingMap($, google.maps)
  # parkings.ideal_finder    = new App.IdealFinder($)

  parkings.map.distance_sorter = parkings.distance_sorter
  parkings.distance_sorter.parking_map = parkings.map
  # parkings.ideal_finder.distance_sorter = parkings.distance_sorter
