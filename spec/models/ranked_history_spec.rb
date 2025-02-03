require 'rails_helper'

RSpec.describe RankedHistory, type: :model do
  let(:ranked_history) { described_class.new(fighter_id:, character:, played_from:, played_to:) }
  let(:fighter_id)  { generate(:fighter_id) }
  let(:character) { Character[1] }
  let(:played_from) { Time.new(2024, 10, 10, 12, 0, 0) }
  let(:played_to) { Time.new(2025, 10, 10, 12, 0, 0) }

  before do
    played_at_gen = (Time.new(2024, 10, 10, 12, 0, 0)..).step(10.minutes)
    create_match(battle: { battle_type: "custom_room", played_at: played_at_gen.next }, p1: { fighter_id:, character:, master_rating: 1000, league_point: 5000 })
    create_match(battle: { battle_type: "ranked", played_at: played_at_gen.next }, p1: { fighter_id:, character:, master_rating: 1000, league_point: 5000 })
    create_match(battle: { battle_type: "ranked", played_at: played_at_gen.next }, p1: { fighter_id:, character:, master_rating: 1010, league_point: 5050 })
    create_match(battle: { battle_type: "ranked", played_at: played_at_gen.next }, p1: { fighter_id:, character:, master_rating: 1008, league_point: 5010 })
    create_match(battle: { battle_type: "ranked", played_at: played_at_gen.next }, p1: { fighter_id:, character:, master_rating: 0, league_point: 5040 })
    create_match(battle: { battle_type: "ranked", played_at: played_at_gen.next }, p1: { fighter_id:, character:, master_rating: 1510, league_point: 5090 })
  end

  it do
    expect(ranked_history).to include(
      an_object_having_attributes(played_at: Time.new(2024, 10, 10, 12, 10), master_rating: 1000, league_point: 5000, master_rating_variation: 10, league_point_variation: 50),
      an_object_having_attributes(played_at: Time.new(2024, 10, 10, 12, 20), master_rating: 1010, league_point: 5050, master_rating_variation: -2, league_point_variation: -40),
      an_object_having_attributes(played_at: Time.new(2024, 10, 10, 12, 30), master_rating: 1008, league_point: 5010, master_rating_variation: 0, league_point_variation: 30),
      an_object_having_attributes(played_at: Time.new(2024, 10, 10, 12, 40), master_rating: 1008, league_point: 5040, master_rating_variation: 502, league_point_variation: 50),
      an_object_having_attributes(played_at: Time.new(2024, 10, 10, 12, 50), master_rating: 1510, league_point: 5090, master_rating_variation: nil, league_point_variation: nil),
    )
  end
end
