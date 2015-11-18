Rails.application.routes.draw do
  root to: 'apipie/apipies#index'
  apipie
  namespace :api do
    namespace :v1 do
      resources :schools, only: :index do
        collection do
          get :top_twenty_keys
        end
      end
    end
  end
end
