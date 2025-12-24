Rails.application.routes.draw do
  resources :fighter_searches, param: :uuid, only: [ :create, :show ]
  resources :battles, param: :replay_id, only: :show
  resources :fighters, only: [], constraints: { id: Patterns::SHORT_ID_REGEXP } do
    get "search" => "fighter_searches#new", on: :collection
    get "/" => redirect("/fighters/search"), on: :collection
    get "/" => redirect("/fighters/%{id}/matches"), on: :member

    scope module: :fighters do
      resource :synchronization, only: [ :create, :show ]
      resource :matches, only: :show
      resource :daily_results_chart, only: :show
      resource :rivals, only: :show
      resource :matchup_chart, only: :show
      resource :ranked_history, only: :show
    end

    match "/*", to: redirect { |params, _req| "/fighters/#{params[:fighter_id]}" }, via: :get
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
