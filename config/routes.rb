Rails.application.routes.draw do
  resources :battles, only: :show, param: :replay_id

  resources :players, param: :short_id, only: :index do
    member do
      get "/" => redirect("/players/%{short_id}/battles")
      get "/ranked" => redirect("/players/%{short_id}/ranked_history")
      scope module: :players do
        resource :battles, only: :show
        resource :ranked_history, only: :show
        resource :matchup_chart, only: :show
      end
    end
  end
  scope "players/:home_short_id" do
    resource :rivals, only: :show
  end

  get "characters" => "characters#index", as: :characters
  scope "characters/:home_character/:home_control_type" do
    get "/" => redirect("/characters/%{home_character}/%{home_control_type}/matchup_chart")
    resource :matchup_chart, only: :show, module: :characters
  end

  resource :performance_by_date_chart, only: :show

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
