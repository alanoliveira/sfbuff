require "rails_helper"

RSpec.describe Rivals do
  let(:rivals) { described_class.new(matches) }
  let(:matches) { Match.where(home_fighter_id: 111222333) }

  def create_match(fighter_id:, character_id:, input_type_id:, wins: 0, losses: 0, draws: 0)
    wins.times { create(:battle, :p1_win, p1_fighter_id: 111222333, p2_fighter_id: fighter_id, p2_character_id: character_id, p2_input_type_id: input_type_id) }
    losses.times { create(:battle, :p2_win, p1_fighter_id: 111222333, p2_fighter_id: fighter_id, p2_character_id: character_id, p2_input_type_id: input_type_id) }
    draws.times { create(:battle, :draw, p1_fighter_id: 111222333, p2_fighter_id: fighter_id, p2_character_id: character_id, p2_input_type_id: input_type_id) }
  end

  before do
    create_match(fighter_id: 111222444, character_id: 1, input_type_id: 1, wins: 3, losses: 3, draws: 1)
    create_match(fighter_id: 111222444, character_id: 2, input_type_id: 1, wins: 2, losses: 0, draws: 2)
    create_match(fighter_id: 111222555, character_id: 1, input_type_id: 1, wins: 0, losses: 3, draws: 0)
  end

  describe "#favorites" do
    it "returns the rivals ordered by most played opponent" do
      expect(rivals.favorites.to_a).to match([
        an_object_having_attributes(fighter_id: 111222444, character_id: 1, input_type_id: 1, score: Score.new(wins: 3, losses: 3, draws: 1)),
        an_object_having_attributes(fighter_id: 111222444, character_id: 2, input_type_id: 1, score: Score.new(wins: 2, losses: 0, draws: 2)),
        an_object_having_attributes(fighter_id: 111222555, character_id: 1, input_type_id: 1, score: Score.new(wins: 0, losses: 3, draws: 0))
      ])
    end
  end

  describe "#tormentors" do
    it "returns the rivals ordered by most 'beat by' opponent" do
      expect(rivals.tormentors.to_a).to match([
        an_object_having_attributes(fighter_id: 111222555, character_id: 1, input_type_id: 1, score: Score.new(wins: 0, losses: 3, draws: 0)),
        an_object_having_attributes(fighter_id: 111222444, character_id: 1, input_type_id: 1, score: Score.new(wins: 3, losses: 3, draws: 1)),
        an_object_having_attributes(fighter_id: 111222444, character_id: 2, input_type_id: 1, score: Score.new(wins: 2, losses: 0, draws: 2))
      ])
    end
  end

  describe "#victims" do
    it "returns the rivals ordered by most beaten opponent" do
      expect(rivals.victims.to_a).to match([
        an_object_having_attributes(fighter_id: 111222444, character_id: 2, input_type_id: 1, score: Score.new(wins: 2, losses: 0, draws: 2)),
        an_object_having_attributes(fighter_id: 111222444, character_id: 1, input_type_id: 1, score: Score.new(wins: 3, losses: 3, draws: 1)),
        an_object_having_attributes(fighter_id: 111222555, character_id: 1, input_type_id: 1, score: Score.new(wins: 0, losses: 3, draws: 0))
      ])
    end
  end
end
