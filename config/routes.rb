Rails.application.routes.draw do

  resources :stocks

  resources :tests

  get 'static_pages/index'

  resources :users

  resources :sessions

  resources :password_resets

  resources :microposts do
    member do
      get 'details','add_good','cancel_good'
    end
  end

  resources :comments

  get 'choose_stock',to: 'stocks#choose_stock',as: :choose_stock
  post 'show_stock_microposts',to: 'stocks#show_stock_microposts',as: :show_stock_microposts

  get 'stock_json', to: 'stocks#stock_json'

  get 'microposts_json', to: 'apijson#microposts_json'
  get 'down_microposts_json', to: 'apijson#down_microposts_json'
  get 'up_microposts_json', to: 'apijson#up_microposts_json'
  get 'new_micropost_json', to: 'apijson#new_micropost_json'

  get 'account_confirmation', to: 'users#account_confirmation'

  get 'root_page' , to:'users#root_page'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#root_page'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
