class BattlesController < ApplicationController
  layout "with_header_footer"

  before_action :set_battle

  def show
  end

  private

  def set_battle
    @battle = Battle.find_by!(replay_id: params[:replay_id])
  end
end
