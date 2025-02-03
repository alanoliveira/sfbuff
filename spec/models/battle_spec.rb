require 'rails_helper'

RSpec.describe Battle, type: :model do
  describe ".by_matchup" do
    let(:battles) { Battle.by_matchup(home: Challenger.where(character_id: 1), away: Challenger.where(character_id: 2)) }

    before do
      create_match(p1: { character_id: 1 }, p2: { character_id: 2 })
      create_match(p1: { character_id: 2 }, p2: { character_id: 1 })
      create_match(p1: { character_id: 1 }, p2: { character_id: 3 })
      create_match(p1: { character_id: 2 }, p2: { character_id: 3 })
    end

    it "returns battles where home is facing away" do
      expect(battles).to have_attributes(count: 2)
      .and all(have_attributes(challengers: a_collection_including(
          an_object_having_attributes(character_id: 1),
          an_object_having_attributes(character_id: 2),
        )))
    end
  end
end
