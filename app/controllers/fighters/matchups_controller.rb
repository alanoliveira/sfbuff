class Fighters::MatchupsController < MatchupsController
  include FighterScoped

  layout :fighter_layout

  private

  def matchups_search_params
    super.merge(home_fighter_id: params[:fighter_id])
  end
end
