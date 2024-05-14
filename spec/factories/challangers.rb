# frozen_string_literal: true

FactoryBot.define do
  factory :challanger do
    sequence(:player_sid, 123_456_001)
    character { Buckler::CHARACTERS.keys.sample }
    playing_character { character }
    control_type { Buckler::CONTROL_TYPES.keys.sample }
    master_rating { 1 }
    league_point { 1 }
    side { Challanger.sides.keys.sample }
    name { "Player #{player_sid}" }
    rounds { [1, 1] }
    battle { nil }

    factory :p1 do
      side { 'p1' }
    end

    factory :p2 do
      side { 'p2' }
    end
  end
end
