Rails.application.routes.draw do
  root 'dashboard#index'

  resources :photos, only: [:index, :create]


  get  'search'   => 'search#show'                    # Search by hex color code
  get  'info'     => 'info#index', as: 'information'  # More information

  # Temporary testing routes
  get  'test'     => 'photos#test'                    
  get  'kmeans'   => 'photos#kmeans' 

end
