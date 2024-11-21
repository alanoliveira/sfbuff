class Players::RankedsController < Players::BaseController
  include ParamsWithDefaultPlayedAtRange

  def show
    @ranked_history = RankedHistory.new(
      short_id: params[:short_id], character: params[:character],
      played_at: (params[:played_from].beginning_of_day..params[:played_to].end_of_day)
    )
  end

  def params
    super.with_defaults(character: @player&.main_character)
  end
end
