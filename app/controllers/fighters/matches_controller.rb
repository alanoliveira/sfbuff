class Fighters::MatchesController < Matchups::MatchesController
  include FighterScoped

  layout :fighter_layout
  fresh_when_unsynchronized

  def pagy_get_count(collection, vars)
    cache([ collection.cache_key, @fighter.cache_version, "pagy-count" ]) { collection.count }
  end

  private

  def matchup_parameters
    super.merge(home_fighter_id: params[:fighter_id])
  end
end
