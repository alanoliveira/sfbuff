# frozen_string_literal: true

FactoryBot.define do
  factory :challanger do
    player_sid { 1 }
    character { Challanger.characters.keys.sample }
    control_type { Challanger.control_types.keys.sample }
    master_rating { 1 }
    league_point { 1 }
    side { Challanger.sides.keys.sample }
    name { "Player #{player_sid}" }
    rounds { 2.times.map { Challanger.rounds.keys.sample } }
    battle { association(:battle) }
  end
end
