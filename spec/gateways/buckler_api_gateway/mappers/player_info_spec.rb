require "rails_helper"

RSpec.describe BucklerApiGateway::Mappers::PlayerInfo do
  subject(:buckler_player_info) { described_class.new(raw_data) }

  let(:raw_data) do
    {
      "player" => {
        "short_id" => 123456789,
        "fighter_id" => "TEST_FIGHTER_1"
      },
      "round_results" => [ 1, 1 ],
      "character_id" => 254,
      "playing_character_id" => 3,
      "battle_input_type" => 0,
      "master_rating" => 2000,
      "league_point" => 30000
    }
  end

  it { expect(buckler_player_info.short_id).to eq(123456789) }
  it { expect(buckler_player_info.fighter_id).to eq("TEST_FIGHTER_1") }
  it { expect(buckler_player_info.character_id).to eq(254) }
  it { expect(buckler_player_info.playing_character_id).to eq(3) }
  it { expect(buckler_player_info.battle_input_type).to eq(0) }
  it { expect(buckler_player_info.master_rating).to eq(2000) }
  it { expect(buckler_player_info.league_point).to eq(30000) }
  it { expect(buckler_player_info.round_results).to eq([ 1, 1 ]) }
end
