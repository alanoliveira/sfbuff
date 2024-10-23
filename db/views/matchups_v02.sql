SELECT "battles"."id" "battle_id",
       "home_challenger"."id" "home_challenger_id",
       "away_challenger"."id" "away_challenger_id"
FROM "battles"
INNER JOIN "challengers" "home_challenger" ON "home_challenger"."battle_id" = "battles"."id"
INNER JOIN "challengers" "away_challenger" ON "away_challenger"."battle_id" = "battles"."id"
                                          AND "away_challenger"."side" = CASE
                                                                         WHEN "home_challenger"."side" = 1 THEN 2
                                                                         ELSE 1
                                                                         END
