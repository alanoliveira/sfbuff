# frozen_string_literal: true

class Rivals
  SELECT_STATEMENT = %{
    opponent.player_sid as opponent_sid,
    ANY_VALUE(opponent.name) as opponent_name,
    opponent.character as opponent_character,
    opponent.control_type as opponent_control_type,
    COUNT(1) as total,
    (
      COUNT(CASE WHEN player.side = battles.winner_side THEN 1 END) -
      COUNT(CASE WHEN opponent.side = battles.winner_side THEN 1 END)
    ) AS score
  }

  def initialize(battle_pov)
    @rel = battle_pov
           .reselect(SELECT_STATEMENT)
           .group('opponent.player_sid', 'opponent.character', 'opponent.control_type')
           .reorder(nil)
  end

  def favorites(top = 5)
    @rel.order('total DESC').limit(top)
  end

  def tormentors(top = 5)
    @rel.order('score ASC').limit(top)
  end

  def victims(top = 5)
    @rel.order('score DESC').limit(top)
  end
end
