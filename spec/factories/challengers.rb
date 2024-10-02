FactoryBot.define do
  factory :challenger do
    short_id
    playing_character { 1 }
    character { playing_character }
    control_type { 1 }
    master_rating { 0 }
    league_point { -1 }
    name { "Player #{short_id}" }
    rounds { [ 1, 1 ] }
    side { nil }
    battle

    Challenger::LEAGUE_THRESHOLD.each do |lp, name|
      trait name.to_sym do
        league_point { lp }
        master_rating { name == "master" ? 1500 : -1 }
      end
    end

    trait :win do
      rounds { [ 1, 1 ] }
    end

    trait :lose do
      rounds { [ 0, 0 ] }
    end

    trait :draw do
      rounds { [ 4, 4 ] }
    end

    trait :random do
      character { 254 }
    end

    factory :p1 do
      side { 1 }
    end

    factory :p2 do
      side { 2 }
    end
  end
end
