class Fighters::MatchesController < Matchups::MatchesController
  include FighterScoped

  layout "fighters"

  before_action { fresh_when @fighter }

  private

  def matchup_parameters
    super.merge(home_fighter_id: params[:fighter_id])
  end
end
