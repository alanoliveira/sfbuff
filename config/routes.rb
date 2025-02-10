Rails.application.routes.draw do
  resource :fighter_search, only: :create
  resources :battles, only: :show, param: :replay_id

  resources :fighters, only: [ :index, :update ], constraints: { id: Fighter::FIGHTER_ID_REGEXP } do
    get "/" => redirect("/fighters/%{fighter_id}/matches")
    scope module: :fighters do
      get "matches" => "matches#show"
      get "matchup_chart" => "matchup_charts#show"
      get "score_by_date_chart" => "score_by_date_charts#show"
      get "rivals" => "rivals#show"
    end
    get "ranked" => "ranked_histories#show"
  end

  direct :matchups_score_by_date_chart do |matchup, **opts|
    if matchup.home_fighter_id.present?
      url_for(controller: "fighters/score_by_date_charts", action: "show", **matchup.attributes)
    else
      url_for(controller: "matchups/score_by_date_charts", action: "show", **matchup.attributes)
    end
  end

  direct :matchups_rivals do |matchup, **opts|
    if matchup.home_fighter_id.present?
      url_for(controller: "fighters/rivals", action: "show", **matchup.attributes)
    else
      url_for(controller: "matchups/rivals", action: "show", **matchup.attributes)
    end
  end

  # for backward compatibility
  match "/players(/:fighter_id)(*)", constraints: { fighter_id: Fighter::FIGHTER_ID_REGEXP }, to: redirect { |params, _req|
    fighter_id = params[:fighter_id]
    if fighter_id
      "/fighters/#{fighter_id}/matches"
    else
      "/fighters"
    end
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
