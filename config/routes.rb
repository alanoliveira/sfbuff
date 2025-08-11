Rails.application.routes.draw do
  resource :fighter_search, only: :create
  resources :fighter_search_processes, only: :create
  resources :battles, only: :show, param: :replay_id

  resources :fighters, only: [ :index, :update ], constraints: { id: Fighter::FIGHTER_ID_REGEXP } do
    get "/" => redirect("/fighters/%{fighter_id}/matchups")
    scope module: :fighters do
      resource :matchups, only: :show
      resource :matchup_chart, only: :show
      resource :ranked_history, only: :show
    end
  end

  scope "fighters/:home_fighter_id", as: "fighter_matchups", module: :matchups do
    resource :rivals, only: :show
    resource :daily_performance_chart, only: :show
  end

  direct :daily_performance_chart do |query_params|
    if request.path.start_with?("/fighters/")
      fighter_id = params["fighter_id"] || params["home_fighter_id"]
      fighter_matchups_daily_performance_chart_path(fighter_id, request.query_parameters.merge(query_params))
    end
  end

  match "/fighters(/:fighter_id)(*)", constraints: { fighter_id: Fighter::FIGHTER_ID_REGEXP }, to: redirect { |params, _req|
    "/fighters/#{params[:fighter_id]}"
  }, via: :get

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
