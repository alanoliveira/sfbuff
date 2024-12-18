require 'rails_helper'

RSpec.describe Parsers::FighterBannerParser do
  describe '.parse' do
    subject(:parsed_fighter_banner) { described_class.parse(raw_data:) }

    let(:raw_data) do
      {
        'favorite_character_id' => 3,
        'favorite_character_league_info' => {
          'master_rating' => 2000,
          'league_point' => 30_000
        },
        'personal_info' => {
          'fighter_id' => 'Player ABC',
          'short_id' => 123456789
        },
        'home_id' => 24,
        'last_play_at' => Time.parse("2020-01-01T00:00:00.000Z").to_i
      }
    end

    it "returns a hash with the expected structure" do
      expect(parsed_fighter_banner.short_id).to eq(123456789)
      expect(parsed_fighter_banner.name).to eq('Player ABC')
      expect(parsed_fighter_banner.main_character).to eq(3)
      expect(parsed_fighter_banner.master_rating).to eq(2000)
      expect(parsed_fighter_banner.league_point).to eq(30_000)
      expect(parsed_fighter_banner.home_id).to eq(24)
      expect(parsed_fighter_banner.last_play_at).to eq Time.utc(2020, 1, 1, 0, 0, 0)
    end
  end
end
