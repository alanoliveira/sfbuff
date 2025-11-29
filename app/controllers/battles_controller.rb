class BattlesController < ApplicationController
  before_action :set_battle
  determine_modal_variant only: "show"

  def show
  end

  private

  def set_battle
    @battle = Battle.find_by!(replay_id: params[:replay_id])
  end
end
