SELECT * FROM
(
  SELECT "battles"."replay_id",
         "battles"."played_at",
         "battles"."battle_type_id",
         "battles"."p1_fighter_id"           home_fighter_id,
         "battles"."p1_character_id"         home_character_id,
         "battles"."p1_playing_character_id" home_playing_character_id,
         "battles"."p1_input_type_id"        home_input_type_id,
         "battles"."p1_mr"                   home_mr,
         "battles"."p1_lp"                   home_lp,
         "battles"."p1_round_ids"            home_round_ids,
         "battles"."p1_name"                 home_name,
         "battles"."p2_fighter_id"           away_fighter_id,
         "battles"."p2_character_id"         away_character_id,
         "battles"."p2_playing_character_id" away_playing_character_id,
         "battles"."p2_input_type_id"        away_input_type_id,
         "battles"."p2_mr"                   away_mr,
         "battles"."p2_lp"                   away_lp,
         "battles"."p2_round_ids"            away_round_ids,
         "battles"."p2_name"                 away_name,
         CASE "battles"."winner_side"
         WHEN 1 THEN 1
         WHEN 2 THEN -1
         ELSE 0
         END result
  FROM "battles"
)
UNION ALL
(
  SELECT "battles"."replay_id",
         "battles"."played_at",
         "battles"."battle_type_id",
         "battles"."p2_fighter_id"           home_fighter_id,
         "battles"."p2_character_id"         home_character_id,
         "battles"."p2_playing_character_id" home_playing_character_id,
         "battles"."p2_input_type_id"        home_input_type_id,
         "battles"."p2_mr"                   home_mr,
         "battles"."p2_lp"                   home_lp,
         "battles"."p2_round_ids"            home_round_ids,
         "battles"."p2_name"                 home_name,
         "battles"."p1_fighter_id"           away_fighter_id,
         "battles"."p1_character_id"         away_character_id,
         "battles"."p1_playing_character_id" away_playing_character_id,
         "battles"."p1_input_type_id"        away_input_type_id,
         "battles"."p1_mr"                   away_mr,
         "battles"."p1_lp"                   away_lp,
         "battles"."p1_round_ids"            away_round_ids,
         "battles"."p1_name"                 away_name,
         CASE "battles"."winner_side"
         WHEN 2 THEN 1
         WHEN 1 THEN -1
         ELSE 0
         END result
  FROM "battles"
)
