class Players::BattlesController < Players::BaseController
  include ParamsWithDefaultPlayedAtRange
  include Pagyable

  def show
    battles = MatchupsFilter.filter(Matchup, filter_params)
    @pagy, @battles = pagy(battles.includes(:p1, :p2).ordered.reverse_order)
    @score = cache([ battles.cache_key, "score" ]) { battles.performance.sum }
  end

  def rivals
    performance = MatchupsFilter.filter(Matchup, filter_params)
      .performance
      .group_by_rival
      .limit(8)
    @rivals = [ :favorites, :tormentors, :victims ].index_with do |name|
      performance.public_send(name)
    end
  end

  private

  def filter_params
    params.permit(:short_id, :character, :control_type, :vs_character,
      :vs_control_type, :played_from, :played_to, :battle_type)
  end
end
