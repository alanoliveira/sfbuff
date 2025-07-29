SELECT * FROM
(
  SELECT replay_id,
         played_at,
         p1_fighter_id fighter_id,
         p1_character_id character_id,
         p1_mr mr,
         p1_lp lp
  FROM battles
  WHERE battle_type_id = 1
)
UNION ALL
(
  SELECT replay_id,
         played_at,
         p2_fighter_id fighter_id,
         p2_character_id character_id,
         p2_mr mr,
         p2_lp lp
  FROM battles
  WHERE battle_type_id = 1
)
