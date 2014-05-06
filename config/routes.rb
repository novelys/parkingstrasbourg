Parkingstrasbourg::Application.routes.draw do
  root :to => 'parkings#index'

  get 'embed' => 'parkings#embed'
  get 'faq'   => 'parkings#faq'
  get 'ideal' => 'parkings#ideal'

  resources :parkings, only: [:index, :show]
end
