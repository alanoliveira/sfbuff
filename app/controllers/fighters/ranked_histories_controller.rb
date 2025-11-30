class Fighters::RankedHistoriesController < ApplicationController
  include FighterScoped
  layout "fighter"

  def show
    @ranked_history = RankedHistory.new(
      @fighter,
      played_at: params[:played_from]..params[:played_to],
      character_id: params[:character_id]
    )
  end
end
