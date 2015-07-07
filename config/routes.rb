Spree::Core::Engine.add_routes do
  resources :addresses

  namespace :api, defaults: { format: 'json' } do
    resources :address, only: [:show]
   end
end