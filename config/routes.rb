Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :players, only: [:show], param: :sid, constraints: { sid: Buckler::Api::SHORT_ID_REGEX } do

    scope module: :players, only: [:show] do
      resource :battles
      resource :ranked
      resource :matchup_chart
    end
  end

  resources :battles, only: [:show], param: :replay_id

  get "buckler/player_search"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "homepage#index"
end
