class Players::BattlesFilterForm < BaseForm
  model_name.route_key = "player_battles"
  model_name.param_key = ""

  attr_accessor :player
  attribute :character
  attribute :control_type
  attribute :vs_character
  attribute :vs_control_type
  attribute :battle_type
  attribute :played_from, :date
  attribute :played_to, :date

  delegate :cache_key, to: :relation

  def submit
    relation
  end

  def played_from
    super.presence || 7.days.ago.to_date
  end

  def played_to
    super.presence || Time.zone.now.to_date
  end

  def character
    super.presence || player.main_character
  end

  private

  def relation
    battle_rel.with_scores.joins(:challengers).merge(challenger_rel)
  end

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
