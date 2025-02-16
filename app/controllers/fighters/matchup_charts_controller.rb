class Fighters::MatchupChartsController < Matchups::MatchupChartsController
  include FighterScoped

  layout :fighter_layout
  fresh_when_unsynchronized

  private

  def matchup_parameters
    super.merge(home_fighter_id: params[:fighter_id])
  end
end
