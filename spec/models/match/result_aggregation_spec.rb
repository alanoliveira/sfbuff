require "rails_helper"

RSpec.describe Match::ResultAggregation do
  let(:result_aggregation) { match_relation.aggregate_results }

  before do
    create_list(:battle, 4, :p1_win, p1_fighter_id: 111111111, p1_character_id: 1)
    create_list(:battle, 2, :p2_win, p1_fighter_id: 111111111, p1_character_id: 1)
    create_list(:battle, 1, :p1_win, p1_fighter_id: 111111111, p1_character_id: 2)
  end

  context "without grouping condition" do
    let(:match_relation) { Match.where(home_fighter_id: 111111111) }

    it { expect(result_aggregation.to_h).to match({ {} => Score.new(wins: 5, losses: 2, draws: 0) }) }
  end

  context "with grouping condition" do
    let(:match_relation) { Match.where(home_fighter_id: 111111111).select(:home_character_id).group(:home_character_id) }

    it do
      expect(result_aggregation.to_h).to match({
        { "home_character_id" => 1 } => Score.new(wins: 4, losses: 2, draws: 0),
        { "home_character_id" => 2 } => Score.new(wins: 1, losses: 0, draws: 0)
      })
    end
  end
end
