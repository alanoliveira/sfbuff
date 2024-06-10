# frozen_string_literal: true

FactoryBot.define do
  factory :challenger do
    player_sid
    character { Buckler::CHARACTERS.keys.sample }
    playing_character { character }
    control_type { Buckler::CONTROL_TYPES.keys.sample }
    master_rating { 0 }
    league_point { -1 }
    side { Challenger.sides.keys.sample }
    name { "Player #{player_sid}" }
    rounds { [1, 1] }
    battle { nil }
    mr_variation { nil }

    factory :p1 do
      side { 'p1' }
    end

    factory :p2 do
      side { 'p2' }
    end
  end
end
