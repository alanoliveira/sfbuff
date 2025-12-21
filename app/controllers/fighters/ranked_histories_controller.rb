class Fighters::RankedHistoriesController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  fresh_when_synchronized_at_changed
  layout "fighter"

  def show
    @current_league = @fighter.current_leagues[@matches_filter.home_character_id]
    @ranked_history = RankedHistory.new(
      @fighter,
      character_id: @matches_filter.home_character_id,
      played_from: @matches_filter.played_from,
      played_to: @matches_filter.played_to,
    )
  end

  private

  def matches_filter_params
    super.with_defaults("home_character_id" => @fighter.main_character_id)
  end
end
