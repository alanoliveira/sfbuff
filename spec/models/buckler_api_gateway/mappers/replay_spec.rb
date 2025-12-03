require "rails_helper"

RSpec.describe BucklerApiGateway::Mappers::Replay do
  subject(:buckler_replay) { described_class.new(raw_data) }

  let(:raw_data) do
    {
      "replay_id" => "TESTAAABBB",
      "replay_battle_type" => 4,
      "uploaded_at" => 1712537824,
      "player1_info" => "p1_info",
      "player2_info" => "p2_info"
    }
  end

  it { expect(buckler_replay.replay_id).to eq("TESTAAABBB") }
  it { expect(buckler_replay.replay_battle_type).to eq(4) }
  it { expect(buckler_replay.uploaded_at).to eq(Time.zone.at(1712537824)) }
  it { expect(buckler_replay.player1_info.data).to eq("p1_info") }
  it { expect(buckler_replay.player2_info.data).to eq("p2_info") }
end
