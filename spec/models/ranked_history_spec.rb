require "rails_helper"

RSpec.describe RankedHistory, type: :model do
  let(:ranked_history) { described_class.new(short_id, character) }
  let(:short_id) { generate(:short_id) }
  let(:character) { Character["ryu"] }

  before do
    create(:battle, :ranked, replay_id: "TESTRANK1", played_at: "2020-01-15 13:10:00".to_time, p1:
      build(:p1, short_id:, character:, master_rating: 1030, league_point: 2030,
        ranked_variation: { master_rating_variation: 5, league_point_variation: 50 }))

    create(:battle, :battle_hub, replay_id: "TESTRANK2", played_at: "2020-01-15 13:05:00".to_time, p1:
      build(:p1, short_id:, character:, master_rating: 1000, league_point: 2000))

    create(:battle, :ranked, replay_id: "TESTRANK3", played_at: "2020-01-15 13:00:00".to_time, p1:
      build(:p1, short_id:, character:, master_rating: 1000, league_point: 2000,
        ranked_variation: { master_rating_variation: 8, league_point_variation: 90 }))
  end

  it do
    expect(ranked_history).to match([
      { replay_id: "TESTRANK3", played_at: "2020-01-15 13:00:00".to_time, master_rating: 1000, league_point: 2000, mr_variation: 8, lp_variation: 90 },
      { replay_id: "TESTRANK1", played_at: "2020-01-15 13:10:00".to_time, master_rating: 1030, league_point: 2030, mr_variation: 5, lp_variation: 50 }
    ])
  end
end
