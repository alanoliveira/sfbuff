Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :players, only: [ :show ], param: :short_id do
    get "/", to: redirect("/players/%{player_short_id}/battles")
    resource :battles, only: [ :show ], module: :players do
      get "rivals"
    end
    resource :matchup_chart, only: [ :show ], module: :players
    resource :ranked, only: [ :show ], module: :players
  end
  resources :battles, only: [ :show ], param: :replay_id

  get "buckler/player_search"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "homepage#index"
end
