class Players::RankedsController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def show
    @ranked_history = RankedHistory.new(
      short_id: params[:short_id], character: params[:character],
      played_at: (played_from..played_to)
    )
  end

  private

  def played_from
    Time.zone.parse(params[:played_from]).beginning_of_day
  rescue ArgumentError
    Time.zone.now.beginning_of_day
  end

  def played_to
    Time.zone.parse(params[:played_to]).end_of_day
  rescue ArgumentError
    Time.zone.now.end_of_day
  end

  def default_params
    {
      played_from: (Date.today - 1.week).to_s,
      played_to: (Date.today).to_s,
      character: @player.main_character
    }
  end
end
