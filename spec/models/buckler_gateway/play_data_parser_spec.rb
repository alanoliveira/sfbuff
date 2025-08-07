require "rails_helper"

RSpec.describe BucklerGateway::PlayDataParser do
  subject(:play_data) { described_class.parse(play_data_data) }

  before do
    allow(BucklerGateway::CharacterLeagueInfoParser).to receive(:parse, &:upcase)
  end

  let(:play_data_data) { JSON.parse <<~JSON }
  {
    "character_league_infos": [ "a", "b" ]
  }
  JSON

  it "parses the character_league_infos" do
    expect(play_data[:character_league_infos]).to eq [ "A", "B" ]
  end
end
