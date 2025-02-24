class Matchups::ScoreByDateChartsController < ApplicationController
  include SetMatchup

  def show
    @scoreboard_by_date = @matchup
      .home_challengers
      .group_by_day("played_at")
      .then { it.select("#{it.group_values.last} date") }
      .order("date")
      .scoreboard
  end

  private

  def matchup_parameters
    params.permit(
      :home_fighter_id, :home_character, :home_input_type,
      :away_fighter_id, :away_character, :away_input_type,
      :battle_type, :played_from, :played_to).compact_blank
  end
end
