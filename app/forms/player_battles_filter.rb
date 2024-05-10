# frozen_string_literal: true

class PlayerBattlesFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :using_character, :integer
  attribute :using_control_type, :integer
  attribute :vs_character, :integer
  attribute :vs_control_type, :integer
  attribute :battle_type, :integer
  attribute :played_at_from, :date, default: 7.days.ago
  attribute :played_at_to, :date

  FILTER_ATTR = %i[using_character using_control_type
                   vs_character vs_control_type battle_type
                   played_at].freeze

  def inject(player_battles)
    FILTER_ATTR.inject(player_battles) do |battles, filter|
      battles.public_send(filter, send(filter))
    end
  end

  def played_at
    from = played_at_from.try(:beginning_of_day)
    to = played_at_to.try(:end_of_day)
    return if [from, to].all?(:nil?)

    from..to
  end
end
