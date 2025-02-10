class BattlesController < ApplicationController
  before_action { fresh_when etag: params[:replay_id] }

  def show
    @battle = Battle.find_by!(replay_id: params[:replay_id])
  end
end
