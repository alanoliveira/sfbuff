require "rails_helper"

RSpec.describe RankedHistory do
  let(:ranked_history) { described_class.new(fighter, character_id:, played_at: played_from..played_to) }
  let(:fighter) { create(:fighter) }
  let(:character_id) { 2 }
  let(:played_from) { Date.parse("2020-01-02").beginning_of_day }
  let(:played_to) { Date.parse("2020-01-09").end_of_day }

  before do
    create(:battle, :ranked, replay_id: "DDD", p1_fighter_id: fighter.id, p1_character_id: 2, played_at: "2020-01-01 23:59:59")
    create(:battle, :ranked, replay_id: "AAA", p1_fighter_id: fighter.id, p1_character_id: 2, played_at: "2020-01-02 00:00:00", p1_mr: 10, p1_lp: 100)
    create(:battle, :ranked, replay_id: "BBB", p2_fighter_id: fighter.id, p2_character_id: 2, played_at: "2020-01-05 00:00:00", p2_mr: 15, p2_lp: 130)
    create(:battle, :ranked, replay_id: "CCC", p2_fighter_id: fighter.id, p2_character_id: 2, played_at: "2020-01-09 11:59:59", p2_mr: 12, p2_lp: 120)
    create(:battle, :ranked, replay_id: "OTHER_FIGHTER", p1_fighter_id: generate(:short_id), p1_character_id: 2, played_at: "2020-01-02 00:00:00")
    create(:battle, :ranked, replay_id: "OTHER_CHARACTER", p1_fighter_id: fighter.id, p1_character_id: 1, played_at: "2020-01-02 00:00:00")
    create(:battle, :casual_match, replay_id: "NON_RANKED", p1_fighter_id: fighter.id, p1_character_id: 2, played_at: "2020-01-02 00:00:00")
  end

  context "when there is a match after the 'played_to'" do
    before do
      create(:battle, :ranked, replay_id: "EEE", p1_fighter_id: fighter.id, p1_character_id: 2, p1_mr: 14, p1_lp: 128, played_at: "2020-01-10 00:00:00")
    end

    it "uses the 'next match' to calculate the last item variations" do
      expect(ranked_history).to include(
        an_object_having_attributes(replay_id: "AAA", mr: 10, lp: 100, mr_variation: 5, lp_variation: 30),
        an_object_having_attributes(replay_id: "BBB", mr: 15, lp: 130, mr_variation: -3, lp_variation: -10),
        an_object_having_attributes(replay_id: "CCC", mr: 12, lp: 120, mr_variation: 2, lp_variation: 8)
      )
    end
  end

  context "when there no match after 'played_to' but there is a current_league_info" do
    before do
      create(:current_league_info, fighter_id: fighter.id, character_id:, mr: 15, lp: 129)
    end

    it "uses this current_league_info to calculate the last item variations" do
      expect(ranked_history).to include(
        an_object_having_attributes(replay_id: "AAA", mr: 10, lp: 100, mr_variation: 5, lp_variation: 30),
        an_object_having_attributes(replay_id: "BBB", mr: 15, lp: 130, mr_variation: -3, lp_variation: -10),
        an_object_having_attributes(replay_id: "CCC", mr: 12, lp: 120, mr_variation: 3, lp_variation: 9)
      )
    end
  end

  context "when there no match after 'played_to' or current_league_info" do
    it "does not calculates the last item variations" do
      expect(ranked_history).to include(
        an_object_having_attributes(replay_id: "AAA", mr: 10, lp: 100, mr_variation: 5, lp_variation: 30),
        an_object_having_attributes(replay_id: "BBB", mr: 15, lp: 130, mr_variation: -3, lp_variation: -10),
        an_object_having_attributes(replay_id: "CCC", mr: 12, lp: 120, mr_variation: nil, lp_variation: nil)
      )
    end
  end

  context "when the 'next match' mr and/or lp values are not positive" do
    before do
      create(:current_league_info, fighter_id: fighter.id, character_id:, mr: 0, lp: -1)
    end

    it "does not calculate the variation" do
      expect(ranked_history.to_a.last).to have_attributes(mr_variation: nil, lp_variation: nil)
    end
  end
end
