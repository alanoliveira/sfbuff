RSpec.describe Matchup::MatchupChart do
  subject(:matchup_chart) { matchups.matchup_chart }

  let(:matchups) { Matchup.where(home_fighter_id: 111_111_111) }

  before do
    create_matchups(wins: 1, losses: 2, home_fighter_id: 111_111_111, away_character_id: 1, away_input_type_id: 0)
    create_matchups(wins: 2, losses: 4, home_fighter_id: 111_111_111, away_character_id: 1, away_input_type_id: 1)
    create_matchups(wins: 3, losses: 6, home_fighter_id: 111_111_111, away_character_id: 2, away_input_type_id: 0)
    create_matchups(wins: 4, losses: 8, home_fighter_id: 111_111_111, away_character_id: 2, away_input_type_id: 1)
  end

  # rubocop: disable RSpec/ExampleLength
  it do
    expect(matchup_chart).to include(
      an_object_having_attributes(character_id: 1, input_type_id: 0, score: an_object_having_attributes(wins: 1, losses: 2, draws: 0)),
      an_object_having_attributes(character_id: 1, input_type_id: 1, score: an_object_having_attributes(wins: 2, losses: 4, draws: 0)),
      an_object_having_attributes(character_id: 2, input_type_id: 0, score: an_object_having_attributes(wins: 3, losses: 6, draws: 0)),
      an_object_having_attributes(character_id: 2, input_type_id: 1, score: an_object_having_attributes(wins: 4, losses: 8, draws: 0)),
    )
  end

  describe "#total" do
    subject(:total) { matchup_chart.total }

    it do
      expect(total).to have_attributes(wins: 10, losses: 20, draws: 0,)
    end
  end
end
