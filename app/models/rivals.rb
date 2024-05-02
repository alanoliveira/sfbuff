# frozen_string_literal: true

module Rivals
  SELECT_STATEMENT = %{
    opponent.player_sid as opponent_sid,
    ANY_VALUE(opponent.name) as opponent_name,
    opponent.character as opponent_character,
    opponent.control_type as opponent_control_type,
    SUM(1) as total,
    SUM ((
      WITH player_wins as (SELECT COUNT(*) FROM UNNEST(player.rounds) AS r WHERE r != 0),
         opponent_wins as (SELECT COUNT(*) FROM UNNEST(opponent.rounds) AS r WHERE r != 0)
      SELECT CASE
        WHEN player_wins > opponent_wins THEN 1
        WHEN player_wins < opponent_wins THEN -1
        ELSE 0
      END
      FROM player_wins, opponent_wins
    )) AS score
  }

  def self.fetch(battle_relation)
    battle_relation
      .reselect(SELECT_STATEMENT)
      .group('opponent.player_sid', 'opponent.character', 'opponent.control_type')
      .reorder(nil)
      .extending(self)
  end

  def favorites(top = 5)
    order('total DESC').limit(top)
  end

  def tormentors(top = 5)
    order('score ASC').limit(top)
  end

  def victims(top = 5)
    order('score DESC').limit(top)
  end
end
