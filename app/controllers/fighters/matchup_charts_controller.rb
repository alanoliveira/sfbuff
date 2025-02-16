class Fighters::MatchupChartsController < Matchups::MatchupChartsController
  include FighterScoped

  layout :fighter_layout
  fresh_when_unsynchronized
  fragment_cache_key { @fighter.last_synchronized_replay_id }

  private

  def matchup_parameters
    super.merge(home_fighter_id: params[:fighter_id])
  end
end
