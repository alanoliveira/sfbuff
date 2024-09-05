class Players::MatchupChartFilterForm < BaseForm
  model_name.route_key = "player_matchup_chart"
  model_name.param_key = ""

  attr_accessor :player
  attribute :character
  attribute :battle_type
  attribute :played_from, :date, default: -> { 7.days.ago }
  attribute :played_to, :date, default: -> { Time.zone.now }

  def submit
    battles = battle_rel.joins(:challengers).merge(challenger_rel.join_vs)
    MatchupChart.new(battles)
  end

  private

  def default_attributes
    { character: player.main_character }
  end

  def battle_rel
    Battle.all.tap do |rel|
      battle_type.presence.try { rel.where!(battle_type: _1) }
      played_from.presence.try { rel.where!(played_at: (_1.beginning_of_day..)) }
      played_to.presence.try { rel.where!(played_at: (.._1.end_of_day)) }
    end
  end

  def challenger_rel
    Challenger.where(short_id: player.short_id, character:)
  end
end
