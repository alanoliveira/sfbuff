# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parsers::BattlelogParser do
  describe '.parse' do
    subject(:parsed_battle) { described_class.parse(raw_battle_data) }

    let(:raw_battle_data) do
      {
        'replay_id' => 'TESTAAABBB',
        'replay_battle_type' => battle_type,
        'replay_battle_sub_type' => 1,
        'uploaded_at' => 1_712_537_824,
        'player1_info' => {
          'player' => {
            'short_id' => 123_456,
            'fighter_id' => 'TEST_FIGHTER_1'
          },
          'round_results' => [1, 1],
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
          'round_results' => [0, 0],
          'character_id' => 4,
          'playing_character_id' => 4,
          'battle_input_type' => 1,
          'master_rating' => 2001,
          'league_point' => 30_001
        }
      }
    end
    let(:battle_type) { 4 }

    it 'parses the replay_id' do
      expect(parsed_battle.replay_id).to eq('TESTAAABBB')
    end

    it 'parses the battle_type' do
      expect(parsed_battle.battle_type).to eq(4)
    end

    it 'parses the battle_sub_type' do
      expect(parsed_battle.battle_subtype).to eq(1)
    end

    it 'parses the uploaded_at' do
      expect(parsed_battle.played_at).to eq(Time.zone.at(1_712_537_824))
    end

    it 'parses the player1 short_id' do
      expect(parsed_battle.p1.player_sid).to eq(123_456)
    end

    it 'parses the player1 fighter_id' do
      expect(parsed_battle.p1.name).to eq('TEST_FIGHTER_1')
    end

    it 'parses the player1 round_results' do
      expect(parsed_battle.p1.rounds)
        .to match([an_object_having_attributes(raw: 1), an_object_having_attributes(raw: 1)])
    end

    it 'parses the player1 character_id' do
      expect(parsed_battle.p1.character).to eq(254)
    end

    it 'parses the player1 playing_character_id' do
      expect(parsed_battle.p1.playing_character).to eq(3)
    end

    it 'parses the player1 battle_input_type' do
      expect(parsed_battle.p1.control_type).to eq(0)
    end

    it 'parses the player1 master_rating' do
      expect(parsed_battle.p1.master_rating).to eq(2000)
    end

    it 'parses the player1 league_point' do
      expect(parsed_battle.p1.league_point).to eq(30_000)
    end

    it 'parses the player2 short_id' do
      expect(parsed_battle.p2.player_sid).to eq(123_457)
    end

    it 'parses the player2 fighter_id' do
      expect(parsed_battle.p2.name).to eq('TEST_FIGHTER_2')
    end

    it 'parses the player2 round_results' do
      expect(parsed_battle.p2.rounds)
        .to match([an_object_having_attributes(raw: 0), an_object_having_attributes(raw: 0)])
    end

    it 'parses the player2 character_id' do
      expect(parsed_battle.p2.character).to eq(4)
    end

    it 'parses the player2 playing_character_id' do
      expect(parsed_battle.p2.playing_character).to eq(4)
    end

    it 'parses the player2 battle_input_type' do
      expect(parsed_battle.p2.control_type).to eq(1)
    end

    it 'parses the player2 master_rating' do
      expect(parsed_battle.p2.master_rating).to eq(2001)
    end

    it 'parses the player2 league_point' do
      expect(parsed_battle.p2.league_point).to eq(30_001)
    end

    it 'sets the winner_side' do
      expect(parsed_battle.winner_side).to eq(1)
    end

    context 'when it is a ranked match' do
      let(:battle_type) { 1 }

      before do
        allow(Parsers::MasterRatingCalculator).to receive(:new).and_return(
          instance_double(
            Parsers::MasterRatingCalculator,
            {
              p1_variation: 111,
              p2_variation: 222
            }
          )
        )
      end

      it 'sets the player1 mr_variation' do
        expect(parsed_battle.p1.mr_variation).to eq(111)
      end

      it 'sets the player2 mr_variation' do
        expect(parsed_battle.p2.mr_variation).to eq(222)
      end
    end
  end
end
