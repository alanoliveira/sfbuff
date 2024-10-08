class Players::RankedsController < Players::BaseController
  include PlayedAtRememberable

  def show
    @filter_form = Players::MatchupsFilterForm.new(filter_form_params)
    @history = @player.matchups
      .merge(@filter_form.submit)
      .where(battle: Battle.ranked)
      .includes(battle: :challengers)
      .ordered
  end

  private

  def filter_form_params
    params
      .compact_blank
      .with_defaults(character: @player.main_character)
      .permit(:character, :control_type, :played_from, :played_to)
  end
end
