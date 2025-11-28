require "rails_helper"

RSpec.describe BucklerApiGateway::Mappers::CharacterLeagueInfo do
  subject(:buckler_character_league_info) { described_class.new(raw_data) }

  let(:raw_data) do
    {
      "character_id" => 1,
      "league_info" => {
        "league_point" => 30000,
        "master_rating" => 2000
      }
    }
  end

  it { expect(buckler_character_league_info.character_id).to eq(1) }
  it { expect(buckler_character_league_info.league_point).to eq(30000) }
  it { expect(buckler_character_league_info.master_rating).to eq(2000) }
end
