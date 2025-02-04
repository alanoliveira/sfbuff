class Fighters::MatchupChartsController < ApplicationController
  include FighterScoped
  include DefaultPlayedAtRange

  layout "fighters"

  def show
    @matchup = Matchup.new(matchup_parameters)
    @matchup_chart = @matchup.matchup_chart
  end

  private

  def matchup_parameters
    params.permit(
      :home_character, :home_input_type,
      :battle_type, :played_from, :played_to
    ).merge(home_fighter_id: params[:fighter_id])
  end
end
