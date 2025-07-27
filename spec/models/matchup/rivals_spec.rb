require 'rails_helper'

RSpec.describe Matchup::Rivals, type: :model do
  subject(:rivals) { matchups.rivals }

  let(:matchups) { Matchup.where(home_fighter_id: 111_111_111) }

  before do
    # | id          | char | ipt | w | l | d | t  | +/- |
    # | 222_222_222 | 1    | 1   | 7 | 1 | 0 | 8  | +6  |
    # | 222_222_222 | 2    | 1   | 1 | 7 | 0 | 8  | -6  |
    # | 333_333_333 | 1    | 1   | 6 | 0 | 0 | 6  | +6  |
    # | 333_333_333 | 1    | 0   | 0 | 6 | 0 | 6  | -6  |
    # | 444_444_444 | 4    | 1   | 5 | 5 | 0 | 10 |  0  |
    create_matchups(wins: 7, losses: 1, home_fighter_id: 111_111_111, away_fighter_id: 222_222_222, away_character_id: 1, away_input_type_id: 1)
    create_matchups(wins: 1, losses: 7, home_fighter_id: 111_111_111, away_fighter_id: 222_222_222, away_character_id: 2, away_input_type_id: 1)
    create_matchups(wins: 6, losses: 0, home_fighter_id: 111_111_111, away_fighter_id: 333_333_333, away_character_id: 1, away_input_type_id: 1)
    create_matchups(wins: 0, losses: 6, home_fighter_id: 111_111_111, away_fighter_id: 333_333_333, away_character_id: 1, away_input_type_id: 0)
    create_matchups(wins: 5, losses: 5, home_fighter_id: 111_111_111, away_fighter_id: 444_444_444, away_character_id: 4, away_input_type_id: 1)
  end

  describe "#favorites" do
    subject(:favorites) { rivals.favorites }

    it do
      expect(favorites).to start_with(
        an_object_having_attributes(
          fighter_id: 444_444_444, character_id: 4, input_type_id: 1, score: an_object_having_attributes(wins: 5, losses: 5, draws: 0),
        ),
        an_object_having_attributes(
          fighter_id: 222_222_222, character_id: 1, input_type_id: 1, score: an_object_having_attributes(wins: 7, losses: 1, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 222_222_222, character_id: 2, input_type_id: 1, score: an_object_having_attributes(wins: 1, losses: 7, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 333_333_333, character_id: 1, input_type_id: 1, score: an_object_having_attributes(wins: 6, losses: 0, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 333_333_333, character_id: 1, input_type_id: 0, score: an_object_having_attributes(wins: 0, losses: 6, draws: 0)
        ),
      )
    end
  end

  describe "#tormentors" do
    subject(:tormentors) { rivals.tormentors }

    it do
      expect(tormentors).to start_with(
        an_object_having_attributes(
          fighter_id: 333_333_333, character_id: 1, input_type_id: 0, score: an_object_having_attributes(wins: 0, losses: 6, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 222_222_222, character_id: 2, input_type_id: 1, score: an_object_having_attributes(wins: 1, losses: 7, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 444_444_444, character_id: 4, input_type_id: 1, score: an_object_having_attributes(wins: 5, losses: 5, draws: 0),
        ),
        an_object_having_attributes(
          fighter_id: 333_333_333, character_id: 1, input_type_id: 1, score: an_object_having_attributes(wins: 6, losses: 0, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 222_222_222, character_id: 1, input_type_id: 1, score: an_object_having_attributes(wins: 7, losses: 1, draws: 0)
        ),
      )
    end
  end

  describe "#victims" do
    subject(:victims) { rivals.victims }

    it do
      expect(victims).to start_with(
        an_object_having_attributes(
          fighter_id: 333_333_333, character_id: 1, input_type_id: 1, score: an_object_having_attributes(wins: 6, losses: 0, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 222_222_222, character_id: 1, input_type_id: 1, score: an_object_having_attributes(wins: 7, losses: 1, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 444_444_444, character_id: 4, input_type_id: 1, score: an_object_having_attributes(wins: 5, losses: 5, draws: 0),
        ),
        an_object_having_attributes(
          fighter_id: 333_333_333, character_id: 1, input_type_id: 0, score: an_object_having_attributes(wins: 0, losses: 6, draws: 0)
        ),
        an_object_having_attributes(
          fighter_id: 222_222_222, character_id: 2, input_type_id: 1, score: an_object_having_attributes(wins: 1, losses: 7, draws: 0)
        ),
      )
    end
  end
end
