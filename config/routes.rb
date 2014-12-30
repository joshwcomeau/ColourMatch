Rails.application.routes.draw do
  root 'dashboard#index'

  resources :photos, only: :index

  get  'test'           => 'photos#test'      # Temporary testing route
  get  'search'         => 'search#show'      # Search by hex color code
  post 'search/upload'  => 'search#upload'    # Search by uploaded image

end
