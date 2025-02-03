class BattlesController < ApplicationController
  def show
    @battle = Battle.find_by(replay_id: params[:replay_id])
  end
end
