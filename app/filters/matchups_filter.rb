class MatchupsFilter < ApplicationFilter
  def played_from(played_from)
    played_from = Time.zone.parse(played_from).beginning_of_day
    relation.where(played_at: (played_from..))
  rescue ArgumentError
    relation.none
  end

  def played_to(played_to)
    played_to = Time.zone.parse(played_to).end_of_day
    relation.where(played_at: (..played_to))
  rescue ArgumentError
    relation.none
  end

  def battle_type(battle_type)
    relation.where(battle_type:)
  end

  def short_id(sid)
    relation.where_home(short_id: sid)
  end

  def character(character)
    relation.where_home(character:)
  end

  def control_type(control_type)
    relation.where_home(control_type:)
  end

  def vs_short_id(sid)
    relation.where_away(short_id: sid)
  end

  def vs_character(character)
    relation.where_away(character:)
  end

  def vs_control_type(control_type)
    relation.where_away(control_type:)
  end
end
