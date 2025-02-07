class BattlesController < ApplicationController
  def show
    http_cache_forever do
      @battle = Battle.find_by(replay_id: params[:replay_id])
    end
  end
end
