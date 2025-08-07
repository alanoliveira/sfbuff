require "rails_helper"

RSpec.describe BucklerGateway::CharacterLeagueInfoParser do
  subject(:league_info) { described_class.parse(league_info_data) }

  let(:league_info_data) { JSON.parse <<~JSON }
    {
      "character_id": 1,
      "is_played": true,
      "league_info": {
        "league_point": 11,
        "master_rating": 22
      }
    }
  JSON

  it { expect(league_info[:character_id]).to eq 1 }
  it { expect(league_info[:lp]).to eq 11 }
  it { expect(league_info[:mr]).to eq 22 }
end
