FactoryBot.define do
  factory :challenger do
    fighter_id { generate(:fighter_id) }
    name { "Challenger##{fighter_id}" }
    character_id { 1 }
    playing_character_id { 1 }
    input_type_id { 1 }
    master_rating { 1 }
    league_point { 1 }
    round_ids { [] }

    trait :with_battle do
      battle
    end

    factory :p1, class: Challengers::P1
    factory :p2, class: Challengers::P2
  end
end
