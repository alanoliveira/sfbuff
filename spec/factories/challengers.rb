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
