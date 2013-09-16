Parkingstrasbourg::Application.routes.draw do
  root to: 'parkings#index'

  get 'embed' => 'parkings#embed'
  get 'list'  => 'parkings#index'
  get 'map'   => 'parkings#map'
end
