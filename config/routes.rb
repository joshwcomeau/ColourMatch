Rails.application.routes.draw do
  root 'dashboard#index'

  resources :photos, only: :index

  get  'search'         => 'search#show'      # Search by hex color code
  post 'search/upload'  => 'search#upload'    # Search by uploaded image

  get  'test'           => 'photos#test'      # Temporary testing route
  get  'kmeans'         => 'photos#kmeans'    # Temporary testing route

end
