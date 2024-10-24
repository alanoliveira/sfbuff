class Players::BattlesController < Players::BaseController
  include DefaultParams
  include Pagyable

  before_action :set_default_params

  def show
    matchups = MatchupsFilter.filter(@player.matchups, filter_params)
    @pagy, @matchups = pagy(matchups.includes(battle: [ :p1, :p2 ]).ordered.reverse_order)
    @score = cache([ matchups.cache_key, "score" ]) { matchups.score }
  end

  def rivals
    matchups = MatchupsFilter.filter(@player.matchups, filter_params)
      .group(away_challenger: [ :short_id, :character, :control_type ])
      .select(Arel.sql("ANY_VALUE(away_challenger.name)").as("name"))
      .limit(8)
    @rivals = [ :favorites, :tormentors, :victims ].index_with do |name|
      matchups.public_send(name)
    end
  end

  private

  def default_params
    {
      played_from: (Date.today - 1.week).to_s,
      played_to: (Date.today).to_s
    }
  end

  def filter_params
    params.permit(:character, :control_type, :vs_character, :vs_control_type,
        :played_from, :played_to, :battle_type)
  end
end
