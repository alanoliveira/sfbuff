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

    trait :win do
      round_ids { [ 1, 0, 1 ] }
    end

    trait :lose do
      round_ids { [ 1, 0, 0 ] }
    end

    trait :draw do
      round_ids { [ 1, 0, 4 ] }
    end

    factory :p1, class: Challengers::P1 do
      trait :with_battle do
        battle { build(:battle, p2: build(:p2)) }
      end
    end

    factory :p2, class: Challengers::P2 do
      trait :with_battle do
        battle { build(:battle, p1: build(:p1)) }
      end
    end
  end
end
