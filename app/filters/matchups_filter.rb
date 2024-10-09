class MatchupsFilter < ApplicationFilter
  def played_from(played_from)
    relation.where(battle: { played_at: (played_from..) })
  end

  def played_to(played_to)
    relation.where(battle: { played_at: (..played_to) })
  end

  def battle_type(battle_type)
    relation.where(battle: { battle_type: })
  end

  def character(character)
    relation.where(home_challenger: { character: })
  end

  def control_type(control_type)
    relation.where(home_challenger: { control_type: })
  end

  def vs_character(character)
    relation.where(away_challenger: { character: })
  end

  def vs_control_type(control_type)
    relation.where(away_challenger: { control_type: })
  end
end
