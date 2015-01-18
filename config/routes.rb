Rails.application.routes.draw do
  root 'dashboard#index'

  resources :photos, only: [:index, :create]


  get  'search'   => 'search#show'                    # Search by hex color code
  get  'privacy'  => 'privacy#index', as: 'privacy'   

  # Temp testing route
  get 'recent' => 'photos#recent'
end
