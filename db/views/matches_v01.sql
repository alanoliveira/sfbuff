SELECT * FROM
(
  SELECT "p1_home_p2_away"."replay_id",
         "p1_home_p2_away"."played_at",
         "p1_home_p2_away"."battle_type_id",
         "p1_home_p2_away"."p1_fighter_id"           home_fighter_id,
         "p1_home_p2_away"."p1_character_id"         home_character_id,
         "p1_home_p2_away"."p1_playing_character_id" home_playing_character_id,
         "p1_home_p2_away"."p1_input_type_id"        home_input_type_id,
         "p1_home_p2_away"."p1_mr"                   home_mr,
         "p1_home_p2_away"."p1_lp"                   home_lp,
         "p1_home_p2_away"."p1_rounds"               home_rounds,
         "p1_home_p2_away"."p1_name"                 home_name,
         "p1_home_p2_away"."p2_fighter_id"           away_fighter_id,
         "p1_home_p2_away"."p2_character_id"         away_character_id,
         "p1_home_p2_away"."p2_playing_character_id" away_playing_character_id,
         "p1_home_p2_away"."p2_input_type_id"        away_input_type_id,
         "p1_home_p2_away"."p2_mr"                   away_mr,
         "p1_home_p2_away"."p2_lp"                   away_lp,
         "p1_home_p2_away"."p2_rounds"               away_rounds,
         "p1_home_p2_away"."p2_name"                 away_name,
         CASE "p1_home_p2_away"."winner_side"
         WHEN 1 THEN 1
         WHEN 2 THEN -1
         ELSE 0
         END result
  FROM "battles" "p1_home_p2_away"
  UNION ALL
  SELECT "p2_home_p1_away"."replay_id",
         "p2_home_p1_away"."played_at",
         "p2_home_p1_away"."battle_type_id",
         "p2_home_p1_away"."p2_fighter_id"           home_fighter_id,
         "p2_home_p1_away"."p2_character_id"         home_character_id,
         "p2_home_p1_away"."p2_playing_character_id" home_playing_character_id,
         "p2_home_p1_away"."p2_input_type_id"        home_input_type_id,
         "p2_home_p1_away"."p2_mr"                   home_mr,
         "p2_home_p1_away"."p2_lp"                   home_lp,
         "p2_home_p1_away"."p2_rounds"               home_rounds,
         "p2_home_p1_away"."p2_name"                 home_name,
         "p2_home_p1_away"."p1_fighter_id"           away_fighter_id,
         "p2_home_p1_away"."p1_character_id"         away_character_id,
         "p2_home_p1_away"."p1_playing_character_id" away_playing_character_id,
         "p2_home_p1_away"."p1_input_type_id"        away_input_type_id,
         "p2_home_p1_away"."p1_mr"                   away_mr,
         "p2_home_p1_away"."p1_lp"                   away_lp,
         "p2_home_p1_away"."p1_rounds"               away_rounds,
         "p2_home_p1_away"."p1_name"                 away_name,
         CASE "p2_home_p1_away"."winner_side"
         WHEN 2 THEN 1
         WHEN 1 THEN -1
         ELSE 0
         END result
  FROM "battles" "p2_home_p1_away"
) AS matches
