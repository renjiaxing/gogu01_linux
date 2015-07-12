Rails.application.routes.draw do

  resources :userconfig do
    collection do
      get 'show_code', 'update_code'
    end
  end

  # require 'api'

  resources :advices

  resources :stocks

  resources :tests

  resources :pmsgs

  resources :chatmsgs

  resources :mystocks do
    member do
      get 'delete_mystock'
    end
  end

  get 'static_pages/index'
  post 'static_pages/index'

  resources :users do
    collection do
      get 'my_msg', 'unread_msg', 'pre_update_passwd', 'pre_update_inform','myshow','my_info','my_reply',
          'stockinfo','stocknoinfo'
      post 'update_passwd', 'update_inform'
    end
  end

  resources :sessions

  resources :password_resets

  resources :microposts do
    member do
      get 'details', 'add_good', 'cancel_good', 'delete_flag', 'add_good_micropost', 'cancel_good_micropost'
    end
  end

  resources :comments do
    member do
      get 'delete_flag'
    end
  end

  get 'choose_stock', to: 'stocks#choose_stock', as: :choose_stock
  get 'show_stock_microposts', to: 'stocks#show_stock_microposts', as: :show_stock_microposts

  resources :apijson do
    collection do
      get 'version_json', 'forget_password_json', 'microposts_json', 'up_microposts_json', 'down_microposts_json',
          'detail_micropost_json', 'del_micropost_json', 'login_json', 'login_token_json', 'del_comment_json',
          'mystock_json','check_stock_json','main_json','my_push_info_json'
      post 'change_password_json', 'new_advice_json', 'new_micropost_json', "change_micropost_json", 'new_comment_json',
           'reg_json','addstock_json','delstock_json','active_apple_micro_push_json','deactive_apple_micro_push_json',
          'active_apple_reply_push_json','deactive_apple_reply_push_json','active_apple_chat_push_json','deactive_apple_chat_push_json'
    end
  end

  get 'stock_json', to: 'stocks#stock_json'

  get 'get_version', to: 'apijson#version_json'

  get 'login_json', to: 'apijson#login_json'

  get 'login_token_json', to: 'apijson#login_token_json'

  get 'micropost_good_json', to: 'apijson#micropost_good_json'
  get 'micropost_nogood_json', to: 'apijson#micropost_nogood_json'
  get 'micropost_del_json', to: 'apijson#micropost_del_json'
  get 'micropost_change_json', to: 'apijson#micropost_change_json'

  get 'messages_json', to: 'apijson#messages_json'
  get 'new_message_json', to: 'apijson#new_message_json'
  get 'message_user_json', to: 'apijson#message_user_json'
  get 'api_add_chat', to: 'apijson#api_add_chat'
  get 'add_micropost_test_api', to: 'apijson#add_micropost_test_api'
  get 'forgetpwd_json', to: 'apijson#forgetpwd_json'

  post 'add_micropost_test_api', to: 'apijson#add_micropost_test_api'

  get 'account_confirmation', to: 'users#account_confirmation'


  # mount Gogu::API => "/"

  get 'root_page', to: 'users#root_page'
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
