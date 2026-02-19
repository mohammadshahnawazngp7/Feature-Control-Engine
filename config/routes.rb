# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :features do
        get :evaluate, on: :member
        resources :feature_overrides, path: "overrides", only: [ :create, :update, :destroy ]
      end
    end
  end
end
