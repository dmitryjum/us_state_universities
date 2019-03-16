Rails.application.routes.draw do
  root to: 'apipie/apipies#index'
  apipie
  namespace :api do
    namespace :v1 do
      resources :users, only: :create do
        collection do
          post :login
        end
      end
      resources :schools, only: [:index, :create, :update] do
        collection do
          get :top_twenty_keys
          get :search
        end
      end
    end
  end
end
