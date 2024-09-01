require 'rails_helper'

RSpec.describe Parsers::BattleParser do
  describe '.parse' do
    subject(:parsed_battle) { described_class.parse(raw_data:) }

    let(:raw_data) do
      {
        'replay_id' => 'TESTAAABBB',
        'replay_battle_type' => 4,
        'uploaded_at' => 1_712_537_824,
        'player1_info' => {
          'player' => {
            'short_id' => 123_456,
            'fighter_id' => 'TEST_FIGHTER_1'
          },
          'round_results' => [ 1, 1 ],
          'character_id' => 254,
          'playing_character_id' => 3,
          'battle_input_type' => 0,
          'master_rating' => 2000,
          'league_point' => 30_000
        },
        'player2_info' => {
          'player' => {
            'short_id' => 123_457,
            'fighter_id' => 'TEST_FIGHTER_2'
          },
          'round_results' => [ 0, 0 ],
          'character_id' => 4,
          'playing_character_id' => 4,
          'battle_input_type' => 1,
          'master_rating' => 2001,
          'league_point' => 30_001
        }
      }
    end

    it "returns the parsed battle" do
      expect(parsed_battle.replay_id).to eq('TESTAAABBB')
      expect(parsed_battle.battle_type).to eq(4)
      expect(parsed_battle.played_at).to eq(Time.zone.at(1_712_537_824))

      expect(parsed_battle.p1.short_id).to eq(123_456)
      expect(parsed_battle.p1.name).to eq('TEST_FIGHTER_1')
      expect(parsed_battle.p1.rounds).to eq [ 1, 1 ]
      expect(parsed_battle.p1.character).to eq(254)
      expect(parsed_battle.p1.playing_character).to eq(3)
      expect(parsed_battle.p1.control_type).to eq(0)
      expect(parsed_battle.p1.master_rating).to eq(2000)
      expect(parsed_battle.p1.league_point).to eq(30_000)

      expect(parsed_battle.p2.short_id).to eq(123_457)
      expect(parsed_battle.p2.name).to eq('TEST_FIGHTER_2')
      expect(parsed_battle.p2.rounds).to eq [ 0, 0 ]
      expect(parsed_battle.p2.character).to eq(4)
      expect(parsed_battle.p2.playing_character).to eq(4)
      expect(parsed_battle.p2.control_type).to eq(1)
      expect(parsed_battle.p2.master_rating).to eq(2001)
      expect(parsed_battle.p2.league_point).to eq(30_001)
    end
  end
end
