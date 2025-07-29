class MatchupsController < ApplicationController
  include SetMatchups

 def show
    @matchups = @matchups.order(played_at: :desc).page(params[:page])
  end
end
