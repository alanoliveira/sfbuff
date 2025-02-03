Rails.application.routes.draw do
  resources :battles, only: :show, param: :replay_id

  scope "fighters/:home_fighter_id" do
    namespace :matchups do
      get "matches" => "matches#show", as: nil
      get "score_by_date_chart" => "score_by_date_charts#show", as: nil
      get "rivals" => "rivals#show", as: nil
    end
  end

  direct :matchups_matches do |matchup, **opts|
    url_for(controller: "matchups/matches", action: "show", **matchup.attributes)
  end

  direct :matchups_score_by_date_chart do |matchup, **opts|
    url_for(controller: "matchups/score_by_date_charts", action: "show", **matchup.attributes)
  end

  direct :matchups_rivals do |matchup, **opts|
    url_for(controller: "matchups/rivals", action: "show", **matchup.attributes)
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
