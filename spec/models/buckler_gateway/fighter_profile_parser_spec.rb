require "rails_helper"

RSpec.describe BucklerGateway::FighterProfileParser do
  subject(:fighter_profile) { described_class.parse(replay_data) }

  let(:replay_data) { JSON.parse <<~JSON }
  {
    "favorite_character_id": 1,
    "favorite_character_tool_name": "ryu",
    "last_play_at": 1737967902,
    "home_id": 24,
    "personal_info": {
      "fighter_id": "Player ABC",
      "short_id": 123456789
    },
    "favorite_character_league_info": {
      "master_rating": 123,
      "league_point": 1234
    }
  }
  JSON

  it { expect(fighter_profile.fighter_id).to eq 123_456_789 }
  it { expect(fighter_profile.name).to eq "Player ABC" }
  it { expect(fighter_profile.main_character_id).to eq 1 }
  it { expect(fighter_profile.mr).to eq 123 }
  it { expect(fighter_profile.lp).to eq 1234 }
  it { expect(fighter_profile.last_online_at).to eq Time.at(1737967902) }
  it { expect(fighter_profile.home_id).to eq 24 }
end
