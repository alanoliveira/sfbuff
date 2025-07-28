class Fighters::MatchupChartsController < Matchups::MatchupChartsController
  include FighterScoped

  layout :fighter_layout
  fresh_when_unsynchronized

  private

  def matchups_search_params
    super.merge(home_fighter_id: params[:fighter_id])
  end
end
