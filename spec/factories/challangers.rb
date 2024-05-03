# frozen_string_literal: true

FactoryBot.define do
  factory :challanger do
    player_sid { 1 }
    character { 1 }
    control_type { 1 }
    master_rating { 1 }
    league_point { 1 }
    side { Challanger.sides.keys.sample }
    name { "Player #{player_sid}" }
    rounds { [1, 1] }
    battle { association(:battle) }
  end
end
