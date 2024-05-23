# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle::Rivals do
  subject(:rivals) { described_class.new(pov, *grouping_by) }

  let(:pov) { Battle.pov.where(player: { player_sid: player.sid }) }
  let(:grouping_by) { [:character] }
  let(:player) { create(:player) }

  before do
    me = { player_sid: player.sid }
    create_list(:battle, 8, winner_side: 1, p1: me, p2: { player_sid: 222, character: 1, control_type: 0 })
    create_list(:battle, 2, winner_side: 2, p1: me, p2: { player_sid: 222, character: 1, control_type: 0 })
    create_list(:battle, 1, winner_side: 1, p1: me, p2: { player_sid: 222, character: 2, control_type: 0 })
    create_list(:battle, 7, winner_side: 1, p1: me, p2: { player_sid: 333, character: 2, control_type: 1 })
    create_list(:battle, 9, winner_side: 1, p1: me, p2: { player_sid: 444, character: 3, control_type: 1 })
    create_list(:battle, 9, winner_side: 2, p1: me, p2: { player_sid: 444, character: 3, control_type: 1 })
    create_list(:battle, 2, winner_side: nil, p1: me, p2: { player_sid: 444, character: 3, control_type: 1 })
    create_list(:battle, 4, winner_side: 1, p1: me, p2: { player_sid: 555, character: 4, control_type: 0 })
    create_list(:battle, 4, winner_side: 2, p1: me, p2: { player_sid: 555, character: 4, control_type: 0 })
    create_list(:battle, 8, winner_side: 2, p1: me, p2: { player_sid: 666, character: 3, control_type: 0 })
    create_list(:battle, 6, winner_side: 2, p1: me, p2: { player_sid: 777, character: 2, control_type: 0 })
    create_list(:battle, 1, winner_side: 1, p1: me, p2: { player_sid: 777, character: 2, control_type: 0 })
    create_list(:battle, 1, winner_side: 1, p1: me, p2: { player_sid: 888, character: 3, control_type: 0 })
    create_list(:battle, 9, winner_side: 1, p1: me, p2: { player_sid: 999, character: 1, control_type: 0 })
    create_list(:battle, 9, winner_side: 1, p1: me, p2: { player_sid: 999, character: 1, control_type: 0 })
  end

  describe '#favorites' do
    it 'returns the most played matches' do
      expect(rivals.favorites(3)).to contain_exactly(
        a_hash_including(wins: 10, loses: 17, diff: -7, total: 29, character: 3),
        a_hash_including(wins: 26, loses: 2, diff: 24, total: 28, character: 1),
        a_hash_including(wins: 9, loses: 6, diff: 3, total: 15, character: 2)
      )
    end
  end

  describe '#tormentors' do
    it 'returns the opponents that won the most' do
      expect(rivals.tormentors(3)).to contain_exactly(
        a_hash_including(wins: 10, loses: 17, diff: -7, total: 29, character: 3),
        a_hash_including(wins: 4, loses: 4, diff: 0, total: 8, character: 4),
        a_hash_including(wins: 9, loses: 6, diff: 3, total: 15, character: 2)
      )
    end
  end

  describe '#victims' do
    it 'returns the opponents that lost the most' do
      expect(rivals.victims(3)).to contain_exactly(
        a_hash_including(wins: 26, loses: 2, diff: 24, total: 28, character: 1),
        a_hash_including(wins: 9, loses: 6, diff: 3, total: 15, character: 2),
        a_hash_including(wins: 4, loses: 4, diff: 0, total: 8, character: 4)
      )
    end
  end
end
