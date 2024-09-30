class Players::RankedsController < Players::BaseController
  before_action :set_default_params

  def show
    @filter_form = Players::RankedFilterForm.new.fill(params)
    @history = @filter_form
      .submit
      .where(battle: Battle.ranked)
      .includes(battle: :challengers)
      .ordered
  end

  private

  def set_default_params
    params.compact_blank!.with_defaults!(
      "played_from" => 7.days.ago.to_date,
      "played_to" => Time.zone.now.to_date,
      "character" => @player.main_character
    )
  end
end
