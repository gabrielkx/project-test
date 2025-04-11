Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :menus, only: %i[create update destroy index]
    resources :menu_items, only: %i[create update destroy index]
    resources :restaurants, only: %i[create update destroy index]

    post "/importers/restaurant", to: "importers#restaurant"
  end
end
