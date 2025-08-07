require 'rails_helper'

RSpec.describe BucklerGateway::BattleParser do
  subject(:parsed_battle) { described_class.parse(replay_data) }

  let(:replay_data) { JSON.parse <<~JSON }
  {
    "replay_id": "TESTAAABBB",
    "replay_battle_type": 4,
    "uploaded_at": 1712537824,
    "player1_info": "p1_info",
    "player2_info": "p2_info"
  }
  JSON

  before do
    allow(BucklerGateway::ChallengerParser).to receive(:parse).with("p1_info").and_return({ name: "parsed_p1", round_ids: [ 1 ] })
    allow(BucklerGateway::ChallengerParser).to receive(:parse).with("p2_info").and_return({ name: "parsed_p2", round_ids: [ 0 ] })
  end

  it { expect(parsed_battle[:replay_id]).to eq "TESTAAABBB" }
  it { expect(parsed_battle[:battle_type_id]).to eq 4 }
  it { expect(parsed_battle[:p1]).to match(name: "parsed_p1", round_ids: [ 1 ]) }
  it { expect(parsed_battle[:p2]).to match(name: "parsed_p2", round_ids: [ 0 ]) }
end
