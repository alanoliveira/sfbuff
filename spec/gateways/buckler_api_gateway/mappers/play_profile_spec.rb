require "rails_helper"

RSpec.describe BucklerApiGateway::Mappers::PlayProfile do
  subject(:buckler_play_profile) { described_class.new(raw_data) }

  let(:raw_data) do
    {
      "fighter_banner_info" => "ok1",
      "play" => {
        "character_league_infos" => [ "ok2", "ok3" ]
      }
    }
  end

  it { expect(buckler_play_profile.fighter_banner.data).to eq("ok1") }
  it { expect(buckler_play_profile.character_league_infos[0].data).to eq("ok2") }
  it { expect(buckler_play_profile.character_league_infos[1].data).to eq("ok3") }
end
