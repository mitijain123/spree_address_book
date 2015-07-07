Spree::Core::Engine.add_routes do
  resources :addresses

  namespace :api, defaults: { format: 'json' } do
  	resources :addresses
 	end


  if Rails.env.test?
    put '/cart', :to => 'orders#update', :as => :put_cart
  end
end