require 'rails_helper'

RSpec.describe Matchup, type: :model do
  describe ".scoreboard_by_day" do
    subject(:scoreboard_by_day) { described_class.where(home_fighter_id: 111_111_111).scoreboard_by_day }

    before do
      create_matchup(:win,  home_fighter_id: 111_111_111, played_at: "2020-01-01 12:00:00")
      create_matchup(:win,  home_fighter_id: 111_111_111, played_at: "2020-01-01 12:10:00")
      create_matchup(:draw, home_fighter_id: 111_111_111, played_at: "2020-01-01 12:20:00")
      create_matchup(:loss, home_fighter_id: 111_111_111, played_at: "2020-01-02 12:00:00")
      create_matchup(:loss, home_fighter_id: 111_111_111, played_at: "2020-01-02 12:10:00")
      create_matchup(:win,  home_fighter_id: 111_111_111, played_at: "2020-01-02 12:20:00")
    end

    it do
      expect(scoreboard_by_day).to match(
        Date.parse('2020-01-01') => an_object_having_attributes(wins: 2, losses: 0, draws: 1),
        Date.parse('2020-01-02') => an_object_having_attributes(wins: 1, losses: 2, draws: 0),
      )
    end
  end
end
