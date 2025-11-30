FactoryBot.define do
  factory :battle do
    replay_id
    battle_type_id { 1 }
    played_at { "2024-10-10 12:00:00" }

    p1_fighter_id { 1 }
    p1_name { "Challenger1##{p1_fighter_id}" }
    p1_character_id { 1 }
    p1_playing_character_id { 1 }
    p1_input_type_id { 1 }
    p1_mr { 1 }
    p1_lp { 1 }
    p1_rounds { [] }

    p2_fighter_id { 1 }
    p2_name { "Challenger2##{p2_fighter_id}" }
    p2_character_id { 1 }
    p2_playing_character_id { 1 }
    p2_input_type_id { 1 }
    p2_mr { 1 }
    p2_lp { 1 }
    p2_rounds { [] }

    traits_for_enum :battle_type_id, BattleType.all.to_h { [ it.name, it.id ] }

    trait :p1_win do
      p1_rounds { [ Round::V ] }
      p2_rounds { [ Round::L ] }
    end

    trait :p2_win do
      p1_rounds { [ Round::L ] }
      p2_rounds { [ Round::V ] }
    end

    trait :draw do
      p1_rounds { [ Round::D ] }
      p2_rounds { [ Round::D ] }
    end
  end
end
