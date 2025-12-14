class Fighters::RankedHistoriesController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  fresh_when_synchronized_at_changed
  layout "fighter"

  def show
    @ranked_history = RankedHistory.new(
      @fighter,
      character_id: @matches_filter.home_character_id,
      from_date: @matches_filter.played_from,
      to_date: @matches_filter.played_to,
    )
  end

  private

  def matches_filter_params
    super.with_defaults("home_character_id" => @fighter.main_character_id)
  end
end
