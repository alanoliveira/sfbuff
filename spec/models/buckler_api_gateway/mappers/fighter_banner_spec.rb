require "rails_helper"

RSpec.describe BucklerApiGateway::Mappers::FighterBanner do
  subject(:buckler_fighter_banner) { described_class.new(raw_data) }

  let(:raw_data) do
    {
      "favorite_character_id" => 1,
      "favorite_character_tool_name" => "ryu",
      "last_play_at" => 1737967902,
      "home_id" => 24,
      "personal_info" => {
        "fighter_id" => "Player ABC",
        "short_id" => 123456789
      },
      "favorite_character_league_info" => {
        "master_rating" => 123,
        "league_point" => 1234
      }
    }
  end

  it { expect(buckler_fighter_banner.short_id).to eq(123456789) }
  it { expect(buckler_fighter_banner.fighter_id).to eq("Player ABC") }
  it { expect(buckler_fighter_banner.favorite_character_id).to eq(1) }
  it { expect(buckler_fighter_banner.master_rating).to eq(123) }
  it { expect(buckler_fighter_banner.league_point).to eq(1234) }
  it { expect(buckler_fighter_banner.home_id).to eq(24) }
  it { expect(buckler_fighter_banner.last_play_at).to eq(Time.zone.at(1737967902)) }
end
