SELECT
      battles.battle_type,
      battles.played_at,
      home.fighter_id home_fighter_id,
      home.character_id home_character_id,
      home.input_type_id home_input_type_id,
      away.fighter_id away_fighter_id,
      away.character_id away_character_id,
      away.input_type_id away_input_type_id,
      home.id home_challenger_id,
      away.id away_challenger_id,
      battles.id battle_id
FROM battles
INNER JOIN challengers home ON home.battle_id = battles.id
INNER JOIN challengers away ON away.battle_id = battles.id AND home.id != away.id
