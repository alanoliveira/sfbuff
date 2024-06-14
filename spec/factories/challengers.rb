# frozen_string_literal: true

FactoryBot.define do
  factory :challenger do
    player_sid
    playing_character { Buckler::CHARACTERS.values.sample }
    traits_for_enum :playing_character, Buckler::CONTROL_TYPES
    character { playing_character }
    control_type { Buckler::CONTROL_TYPES.values.sample }
    traits_for_enum :control_type, Buckler::CONTROL_TYPES
    master_rating { 0 }
    league_point { -1 }
    side { Challenger.sides.keys.sample }
    name { "Player #{player_sid}" }
    rounds { [1, 1] }
    battle { nil }
    mr_variation { nil }

    trait :random do
      character { Buckler::CHARACTERS[:random] }
    end

    factory :p1 do
      side { :p1 }
    end

    factory :p2 do
      side { :p2 }
    end
  end
end
