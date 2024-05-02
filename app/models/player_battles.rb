# frozen_string_literal: true

module PlayerBattles
  def self.fetch(player_sid)
    Battle
      .distinct('battles.id')
      .includes(:challangers)
      .joins('INNER JOIN challangers AS player ON battles.id = player.battle_id')
      .joins('INNER JOIN challangers AS opponent ON battles.id = opponent.battle_id
              AND player.player_sid != opponent.player_sid')
      .reorder(played_at: :desc)
      .where(player: { player_sid: })
      .extending(self)
  end

  def using_character(character)
    character = Challanger.characters[character] if character.is_a?(String)
    character.present? ? where(player: { character: }) : self
  end

  def using_control_type(control_type)
    control_type = Challanger.control_types[control_type] if control_type.is_a?(String)
    control_type.present? ? where(player: { control_type: }) : self
  end

  def vs_character(character)
    character = Challanger.characters[character] if character.is_a?(String)
    character.present? ? where(opponent: { character: }) : self
  end

  def vs_control_type(control_type)
    control_type = Challanger.control_types[control_type] if control_type.is_a?(String)
    control_type.present? ? where(opponent: { control_type: }) : self
  end

  def battle_type(battle_type)
    battle_type.present? ? where(battle_type:) : self
  end

  def played_at(played_at)
    played_at.present? ? where(played_at:) : self
  end
end
