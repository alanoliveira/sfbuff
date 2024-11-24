Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :battles, only: [ :show ], param: :replay_id

  resources :players, only: [ :index ], param: :short_id do
    get "/" => redirect("/players/%{short_id}/battles"), on: :member
  end

  scope "players/:short_id", as: :player do
    get "/", to: redirect("/players/%{short_id}/battles")
    get "battles" => "players#battles"
    get "rivals" => "players#rivals"
    get "matchup_chart" => "players#matchup_chart"
    get "ranked" => "players#ranked"
  end

  get "characters" => "characters#index", as: :characters
  scope "characters/:character/:control_type", as: :character do
    get "matchup_chart" => "players#matchup_chart"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "homepage#index"
end
