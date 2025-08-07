require 'rails_helper'

RSpec.describe BucklerGateway::ChallengerParser do
  subject(:parsed_challenger) { described_class.parse(player_data) }

  let(:player_data) { JSON.parse <<~JSON }
  {
    "player": {
      "short_id": 123456789,
      "fighter_id": "TEST_FIGHTER_1"
    },
    "round_results": [ 1, 1 ],
    "character_id": 254,
    "character_tool_name": "random",
    "playing_character_id": 3,
    "playing_character_tool_name": "kimberly",
    "battle_input_type": 0,
    "master_rating": 2000,
    "league_point": 30000
  }
  JSON

  it { expect(parsed_challenger[:fighter_id]).to eq 123_456_789 }
  it { expect(parsed_challenger[:name]).to eq "TEST_FIGHTER_1" }
  it { expect(parsed_challenger[:character_id]).to eq 254 }
  it { expect(parsed_challenger[:playing_character_id]).to eq 3 }
  it { expect(parsed_challenger[:input_type_id]).to eq 0 }
  it { expect(parsed_challenger[:mr]).to eq 2000 }
  it { expect(parsed_challenger[:lp]).to eq 30_000 }
  it { expect(parsed_challenger[:round_ids]).to eq [ 1, 1 ] }
end
