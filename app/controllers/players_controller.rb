class PlayersController < ApplicationController
  layout "application", only: :index
  def index
    if query = params["q"]
      return render status: :unprocessable_entity if query.length < 4
      @job = PlayerSearchJob.perform_later(query)
    end
  end
end
