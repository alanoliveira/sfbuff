class Matchups::MatchupChartsController < ApplicationController
  def show
    @matchup_chart = Matchup.new(matchup_parameters).matchup_chart
  end

  private

  def matchup_parameters
    params.permit(
      :home_fighter_id, :home_character, :home_input_type,
      :away_fighter_id,
      :battle_type, :played_from, :played_to).compact_blank
  end
end
