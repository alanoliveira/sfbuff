class Players::BattlesFilterForm < BaseForm
  model_name.route_key = "player_battles"
  model_name.param_key = ""

  attr_accessor :player
  attribute :short_id
  attribute :character
  attribute :control_type
  attribute :vs_character
  attribute :vs_control_type
  attribute :battle_type
  attribute :played_from, :date, default: -> { 7.days.ago }
  attribute :played_to, :date, default: -> { Time.zone.now }

  def submit
    battle_rel.joins(:challengers).merge(challenger_rel)
  end

  private

  def battle_rel
    Battle.all.tap do |rel|
      battle_type.presence.try { rel.where!(battle_type: _1) }
      played_from.presence.try { rel.where!(played_at: (_1.beginning_of_day..)) }
      played_to.presence.try { rel.where!(played_at: (.._1.end_of_day)) }
    end
  end

  def challenger_rel
    Challenger.where(short_id: player.short_id).join_vs.tap do |rel|
      character.presence.try { rel.where!(character: _1) }
      control_type.presence.try { rel.where!(control_type: _1) }
      vs_character.presence.try { rel.where!(vs: { character: _1 }) }
      vs_control_type.presence.try { rel.where!(vs: { control_type: _1 }) }
    end
  end
end
