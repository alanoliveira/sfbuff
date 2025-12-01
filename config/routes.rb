Rails.application.routes.draw do
  resources :battles, param: :replay_id, only: :show
  resources :fighters, only: :show do
    post :synchronize, on: :member

    collection do
      resource :search, only: :show do
        post "/:query", action: :create, as: "query"
      end
    end

    scope module: :fighters do
      resource :matches, only: :show
      resource :daily_results_chart, only: :show
      resource :rivals, only: :show
      resource :matchup_chart, only: :show
      resource :ranked_history, only: :show
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "/about" => "pages#about"

  # Defines the root path route ("/")
  root "pages#index"
end
