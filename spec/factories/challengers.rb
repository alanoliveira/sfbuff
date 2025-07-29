FactoryBot.define do
  factory :challenger, class: Battle::Challenger do
    fighter_id { generate(:fighter_id) }
    name { "Challenger##{fighter_id}" }
    character_id { 1 }
    playing_character_id { 1 }
    input_type_id { 1 }
    mr { 1 }
    lp { 1 }
    round_ids { [] }

    trait :win do
      round_ids { [ 1, 0, 1 ] }
    end

    trait :loss do
      round_ids { [ 1, 0, 0 ] }
    end

    trait :draw do
      round_ids { [ 1, 0, 4 ] }
    end
  end
end
