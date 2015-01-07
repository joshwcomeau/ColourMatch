Rails.application.routes.draw do
  root 'dashboard#index'

  resources :photos, only: [:index, :create]

  get  'search'         => 'search#show'      # Search by hex color code

  get  'test'           => 'photos#test'      # Temporary testing route
  get  'kmeans'         => 'photos#kmeans'    # Temporary testing route

end
