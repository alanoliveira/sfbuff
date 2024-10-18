Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :battles, only: [ :show ], param: :replay_id

  scope "players/:short_id", module: :players, as: :player do
    get "/", to: redirect("/players/%{short_id}/battles")
    get "battles" => "battles#show"
    get "battles/rivals" => "battles#rivals"
    get "matchup_chart" => "matchup_charts#show"
    get "ranked" => "rankeds#show"
  end

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
