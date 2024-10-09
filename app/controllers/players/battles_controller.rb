class Players::BattlesController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def show
    matchups = MatchupsFilter.filter(@player.matchups, filter_params)
    @matchups = matchups.includes(battle: :challengers)
      .ordered.reverse_order
      .page(params[:page])
    @total_pages = cache([ matchups.cache_key, "total_pages" ]) { @matchups.total_pages }
    @score = cache([ matchups.cache_key, "score" ]) { matchups.score }
  end

  def rivals
    @matchups = MatchupsFilter.filter(@player.matchups, filter_params)
      .group(away_challenger: [ :short_id, :character, :control_type ])
      .select(Arel.sql("ANY_VALUE(away_challenger.name)").as("name"), away_challenger: [ :short_id, :character, :control_type ])
      .limit(8)
  end

  private

  def default_params
    {
      played_from:  7.days.ago.to_date,
      played_to: Time.zone.now.to_date
    }
  end

  def filter_params
    params.permit(:character, :control_type, :vs_character, :vs_control_type,
        :played_from, :played_to, :battle_type)
  end
end
