# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rivals do
  subject(:rivals) { described_class.fetch(PlayerBattles.fetch(player_sid)) }

  let(:player_sid) { 111 }

  before do
    def create_battle(opponent_sid, opponent_char, opponent_ctrl, win)
      player_rounds, opponent_rounds = win ? [[1, 1], [0, 0]] : [[0, 0], [1, 1]]
      player = build(:challanger, player_sid:, rounds: player_rounds)
      opponent = build(:challanger,
                       player_sid: opponent_sid, character: opponent_char,
                       control_type: opponent_ctrl, rounds: opponent_rounds)
      create(:battle, :with_challangers, p1: player, p2: opponent)
    end

    10.times { create_battle(222, 1, 0, true) }
    6.times { create_battle(222, 4, 0, false) }
    3.times { create_battle(222, 1, 0, false) }
    7.times { create_battle(333, 3, 1, true) }
    2.times { create_battle(333, 3, 1, false) }
    8.times { create_battle(444, 2, 0, true) }
  end

  RSpec::Matchers.define :a_rival do |opponent_sid, opponent_character, opponent_control_type, total, score|
    match do |actual|
      actual.opponent_sid == opponent_sid &&
        actual.opponent_character == opponent_character &&
        actual.opponent_control_type == opponent_control_type &&
        actual.total == total &&
        actual.score == score
    end
  end

  describe '#favorites' do
    it 'returns the most played opponents' do
      expect(rivals.favorites(3)).to contain_exactly(
        a_rival(222, 1, 0, 13, 7),
        a_rival(333, 3, 1, 9, 5),
        a_rival(444, 2, 0, 8, 8)
      )
    end
  end

  describe '#tormentors' do
    it 'returns the opponents that won the most' do
      expect(rivals.tormentors(3)).to contain_exactly(
        a_rival(222, 4, 0, 6, -6),
        a_rival(333, 3, 1, 9, 5),
        a_rival(222, 1, 0, 13, 7)
      )
    end
  end

  describe '#victims' do
    it 'returns the opponents that lost the most' do
      expect(rivals.victims(3)).to contain_exactly(
        a_rival(444, 2, 0, 8, 8),
        a_rival(333, 3, 1, 9, 5),
        a_rival(222, 1, 0, 13, 7)
      )
    end
  end
end
