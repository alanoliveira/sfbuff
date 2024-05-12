# frozen_string_literal: true

class PlayerBattlesFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :player_character, :integer
  attribute :player_control_type, :integer
  attribute :opponent_character, :integer
  attribute :opponent_control_type, :integer
  attribute :battle_type, :integer
  attribute :played_at_from, :date, default: 7.days.ago
  attribute :played_at_to, :date

  def inject(battles_pov)
    battles_pov.where(
      {
        player: player_cond,
        opponent: opponent_cond,
        **battle_cond
      }.compact_blank
    )
  end

  def played_at
    from = played_at_from.try(:beginning_of_day)
    to = played_at_to.try(:end_of_day)
    return if [from, to].all?(:nil?)

    from..to
  end

  private

  def player_cond
    {
      character: player_character,
      control_type: player_control_type
    }.compact_blank
  end

  def opponent_cond
    {
      character: opponent_character,
      control_type: opponent_control_type
    }.compact_blank
  end

  def battle_cond
    {
      played_at:,
      battle_type:
    }.compact_blank
  end
end
