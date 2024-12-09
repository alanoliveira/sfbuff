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
            'short_id' => 123_456_789,
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
            'short_id' => 123_987_654,
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

    it "returns a battle with the parsed attributes" do
      expect(parsed_battle.attributes_for_database).to include(
        "replay_id" => "TESTAAABBB",
        "battle_type" => 4,
        "played_at" => Time.zone.at(1_712_537_824),
      )

      expect(parsed_battle.p1.attributes_for_database).to include(
        "short_id" => 123_456_789,
        "name" => 'TEST_FIGHTER_1',
        "character" => 254,
        "playing_character" => 3,
        "control_type" => 0,
        "master_rating" => 2000,
        "league_point" => 30_000,
        "rounds"=> [ 1, 1 ].to_json
      )

      expect(parsed_battle.p2.attributes_for_database).to include(
        "short_id" => 123_987_654,
        "name" => 'TEST_FIGHTER_2',
        "character" => 4,
        "playing_character" => 4,
        "control_type" => 1,
        "master_rating" => 2001,
        "league_point" => 30_001,
        "rounds"=> [ 0, 0 ].to_json
      )
    end
  end
end
