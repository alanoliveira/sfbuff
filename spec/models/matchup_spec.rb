require 'rails_helper'

RSpec.describe Matchup, type: :model do
  let(:matchup)  { Matchup.new(home_fighter_id: generate(:fighter_id)) }

  before do
    create_match(p1: { fighter_id: matchup.home_fighter_id })
    create_match(p2: { fighter_id: matchup.home_fighter_id })
    create_match
  end

  describe "#home_challengers" do
    it "have the list of 'home' challengers of the matchup" do
      expect(matchup.home_challengers).to have_attributes(size: 2)
        .and all have_attributes(fighter_id: matchup.home_fighter_id)
    end
  end

  describe "#away_challengers" do
    it "have the list of 'away' challengers of the matchup" do
      expect(matchup.away_challengers).to have_attributes(size: 2)
        .and all have_attributes(
          opponent: an_object_having_attributes(fighter_id: matchup.home_fighter_id)
        )
    end
  end

  describe "#battles" do
    it "have the list of battles of the matchup" do
      expect(matchup.battles).to have_attributes(size: 2)
        .and all have_attributes(
          challengers: a_collection_including(an_object_having_attributes(fighter_id: matchup.home_fighter_id))
        )
    end
  end
end
