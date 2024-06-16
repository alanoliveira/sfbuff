Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :players, only: [:index, :show], param: :sid, constraints: { sid: Buckler::Api::SHORT_ID_REGEX } do
    get :battles, on: :member
    get :ranked, on: :member
    get :matchup_chart, on: :member
  end

  resources :battles, only: [:show], param: :replay_id

  scope "/buckler" do
    resources :player_searches, only: [:create, :show]
    resources :player_syncs, only: [:create, :show]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "homepage#index"
end
