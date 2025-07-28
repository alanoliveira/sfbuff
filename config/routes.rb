Rails.application.routes.draw do
  resource :fighter_search, only: :create
  resources :battles, only: :show, param: :replay_id

  resources :fighters, only: [ :index, :update ], constraints: { id: Fighter::FIGHTER_ID_REGEXP } do
    get "matches" => "fighters/matchups#show"
    get "matchup_chart" => "fighters/matchup_charts#show"
  end

  scope "fighters/:home_fighter_id", as: "fighter" do
    get "rivals" => "matchups/rivals#show"
    get "daily_performance_chart" => "matchups/daily_performance_charts#show"
  end

  resource :matchups, only: :show do
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest.json" => "rails/pwa#manifest", as: :pwa_manifest, format: false

  get "about" => "homepage#about", as: :about

  # Defines the root path route ("/")
  root "homepage#index"
end
