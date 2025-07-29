require 'rails_helper'

RSpec.describe RankedHistory do
  let(:ranked_history) { described_class.new(
    fighter_id:,
    character_id: 2,
    from_date: Date.parse("2020-01-02"),
    to_date: Date.parse("2020-01-09"))
  }
  let(:fighter_id) { generate(:fighter_id) }

  before do
    create(:battle, :ranked, replay_id: "OK1", p1_fighter_id: fighter_id, p1_character_id: 2, played_at: "2020-01-02 00:00:00", p1_mr: 10, p1_lp: 100)
    create(:battle, :ranked, replay_id: "OK2", p2_fighter_id: fighter_id, p2_character_id: 2, played_at: "2020-01-05 00:00:00", p2_mr: 15, p2_lp: 130)
    create(:battle, :ranked, replay_id: "OK3", p2_fighter_id: fighter_id, p2_character_id: 2, played_at: "2020-01-09 11:59:59", p2_mr: 12, p2_lp: 120)
    create(:battle, :ranked, replay_id: "OTHER_FIGHTER", p1_fighter_id: generate(:fighter_id), p1_character_id: 2, played_at: "2020-01-02 00:00:00")
    create(:battle, :ranked, replay_id: "OTHER_CHARACTER", p1_fighter_id: fighter_id, p1_character_id: 1, played_at: "2020-01-02 00:00:00")
    create(:battle, :casual_match, replay_id: "NON_RANKED", p1_fighter_id: fighter_id, p1_character_id: 2, played_at: "2020-01-02 00:00:00")
    create(:battle, :ranked, replay_id: "LT_DATE_RANGE", p1_fighter_id: fighter_id, p1_character_id: 2, played_at: "2020-01-01 23:59:59")
    create(:battle, :ranked, replay_id: "GT_DATE_RANGE", p1_fighter_id: fighter_id, p1_character_id: 2, played_at: "2020-01-10 00:00:00")
  end

  it do
    expect(ranked_history).to match([
      an_object_having_attributes(replay_id: "OK1", mr: 10, lp: 100, mr_variation: 5, lp_variation: 30),
      an_object_having_attributes(replay_id: "OK2", mr: 15, lp: 130, mr_variation: -3, lp_variation: -10),
      an_object_having_attributes(replay_id: "OK3", mr: 12, lp: 120, mr_variation: nil, lp_variation: nil)
    ])
  end
end
