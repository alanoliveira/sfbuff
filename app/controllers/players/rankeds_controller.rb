class Players::RankedsController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def show
    @ranked_history = RankedHistory.new(
      short_id: params[:short_id], character: params[:character],
      played_at: (params[:played_from]..params[:played_to])
    )
  end

  private

  def default_params
    {
      played_from: (Date.today - 1.week).to_s,
      played_to: (Date.today).to_s,
      character: @player.main_character
    }
  end
end
