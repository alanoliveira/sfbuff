require "rails_helper"

RSpec.describe RankedHistory do
  let(:ranked_history) { described_class.new(fighter, character_id:, from_date:, to_date:) }
  let(:fighter) { create(:fighter) }
  let(:character_id) { 2 }
  let(:from_date) { Date.parse("2020-01-02").beginning_of_day }
  let(:to_date) { Date.parse("2020-01-09").end_of_day }

  before do
    create(:battle, :ranked, replay_id: "DDD", p1_fighter_id: fighter.id, p1_character_id: 2, played_at: "2020-01-01 23:59:59")
    create(:battle, :ranked, replay_id: "AAA", p1_fighter_id: fighter.id, p1_character_id: 2, played_at: "2020-01-02 00:00:00", p1_mr: 10, p1_lp: 100)
    create(:battle, :ranked, replay_id: "BBB", p2_fighter_id: fighter.id, p2_character_id: 2, played_at: "2020-01-05 00:00:00", p2_mr: 15, p2_lp: 130)
    create(:battle, :ranked, replay_id: "CCC", p2_fighter_id: fighter.id, p2_character_id: 2, played_at: "2020-01-09 11:59:59", p2_mr: 12, p2_lp: 120)
    create(:battle, :ranked, replay_id: "OTHER_FIGHTER", p1_fighter_id: generate(:short_id), p1_character_id: 2, played_at: "2020-01-02 00:00:00")
    create(:battle, :ranked, replay_id: "OTHER_CHARACTER", p1_fighter_id: fighter.id, p1_character_id: 1, played_at: "2020-01-02 00:00:00")
    create(:battle, :casual_match, replay_id: "NON_RANKED", p1_fighter_id: fighter.id, p1_character_id: 2, played_at: "2020-01-02 00:00:00")
  end

  define :a_ranked_history_item_for_match do |expected|
    match do |actual|
      have_attributes(
        replay_id: expected.replay_id,
        played_at: expected.played_at,
        mr: expected.home_mr,
        lp: expected.home_lp,
        mr_variation: expected.home_mr_variation,
        lp_variation: nil
      ).matches?(actual)
    end
  end

  it "uses the 'next match' to calculate the last item variations" do
    expect(ranked_history).to match([
      a_ranked_history_item_for_match(fighter.matches.find_by replay_id: "AAA"),
      a_ranked_history_item_for_match(fighter.matches.find_by replay_id: "BBB"),
      a_ranked_history_item_for_match(fighter.matches.find_by replay_id: "CCC")
    ])
  end
end
