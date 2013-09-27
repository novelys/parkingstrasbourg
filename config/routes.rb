Parkingstrasbourg::Application.routes.draw do
  root to: 'parkings#index'

  get 'embed' => 'embed#index'
  get 'list'  => 'parkings#index'
  get 'map'   => 'parkings#map'
end
