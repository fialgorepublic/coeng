Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'login', to: 'auth#authenticate'
      resources :users do
        collection do
          post :logout
          get :user_details
          get :check_user_token
          get :verify_pin
        end
      end
      resources :password, only: [] do
        collection do
          post :reset_password
          post :forgot_password
          put  :update_password
          put  :client_update_password
        end
      end
    end
  end
end
