class Fighters::MatchupChartsController < ApplicationController
  include AdsenseEligible
  include FighterScoped
  include SetMatchesFilter
  fresh_when_synchronized_at_changed
  layout "fighter"

  def show
    @matchup_chart = MatchupChart.new(@matches_filter.filter(@fighter.matches))
  end

  private

  def matches_filter_params
    super.without(:away_fighter_id, :away_character_id, :away_input_type_id)
  end
end
