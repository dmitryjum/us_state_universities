Rails.application.routes.draw do

  namespace :api, path: '/', constraints: { subdomain: 'api' } do
    namespace :v1 do
      resources :schools, only: :index do
        collection do
          get :top_twenty_keys
        end
      end
    end
  end
end
