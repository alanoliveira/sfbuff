require 'rails_helper'

RSpec.describe RankedHistory::ExtraStep do
  subject(:extra_step) { described_class.new(fighter_id: fighter.id, character_id:, date:) }

  let(:fighter) { create(:fighter) }
  let(:character_id) { 2 }

  context "when date >= today and CharacterLeagueInfo exists" do
    let(:date) { Date.today }

    before do
      create(:character_league_info, fighter_id: fighter.id, character_id:, mr: 20, lp: 150)
    end

    it "uses the CharacterLeagueInfo to set the mr and lp" do
      expect(extra_step).to have_attributes(mr: 20, lp: 150)
    end
  end

  context "when date >= today and CharacterLeagueInfo does not exist" do
    let(:date) { Date.today }

    it "sets the mr and lp to nil" do
      expect(extra_step).to have_attributes(mr: nil, lp: nil)
    end
  end

  context "when to_date < today and a following RankedStep exists" do
    let(:date) { Date.yesterday }

    before do
      create(:battle, :ranked, p1_fighter_id: fighter.id, p1_character_id: character_id, played_at: (date + 25.hours).to_time, p1_mr: 10, p1_lp: 100)
      create(:battle, :ranked, p1_fighter_id: fighter.id, p1_character_id: character_id, played_at: (date + 26.hours).to_time, p1_mr: 30, p1_lp: 300)
    end

    it "uses the first RankedStep after date to set the mr and lp" do
      expect(extra_step).to have_attributes(mr: 10, lp: 100)
    end
  end

  context "when to_date < today, a following RankedStep does not exist and CharacterLeagueInfo exists" do
    let(:date) { Date.yesterday }

    before do
      create(:character_league_info, fighter_id: fighter.id, character_id:, mr: 20, lp: 150)
    end

    it "uses the CharacterLeagueInfo to set the mr and lp" do
      expect(extra_step).to have_attributes(mr: 20, lp: 150)
    end
  end
end
