class Fighters::MatchesController < Matchups::MatchesController
  include FighterScoped

  layout "fighters"

  before_action { fresh_when @fighter }

  def pagy_get_count(collection, vars)
    cache([ collection.cache_key, @fighter.cache_version, "pagy-count" ]) { collection.count }
  end

  private

  def matchup_parameters
    super.merge(home_fighter_id: params[:fighter_id])
  end
end
