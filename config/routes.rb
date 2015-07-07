Spree::Core::Engine.add_routes do
  resources :addresses

  namespace :api, defaults: { format: 'json' } do
    resources :addresses
   end
end