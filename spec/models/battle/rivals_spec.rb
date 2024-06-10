# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle::Rivals do
  subject(:rivals) { Battle.pov.where(player: { player_sid: mic[:player_sid] }).rivals }

  let(:leo) { { player_sid: generate(:player_sid), name: 'leo' } }
  let(:don) { { player_sid: generate(:player_sid), name: 'don' } }
  let(:mic) { { player_sid: generate(:player_sid), name: 'mic' } }
  let(:raf) { { player_sid: generate(:player_sid), name: 'raf' } }

  before do
    create_list(:battle, 5, winner_side: 1,
                            p1: mic.merge({ character: 1, control_type: 0 }),
                            p2: don.merge({ character: 2, control_type: 1 }))
    create_list(:battle, 4, winner_side: 2,
                            p1: mic.merge({ character: 1, control_type: 0 }),
                            p2: don.merge({ character: 2, control_type: 1 }))
    create_list(:battle, 6, winner_side: 2,
                            p1: raf.merge({ character: 4, control_type: 1 }),
                            p2: mic.merge({ character: 1, control_type: 0 }))
    create_list(:battle, 1, winner_side: nil,
                            p1: raf.merge({ character: 4, control_type: 1 }),
                            p2: mic.merge({ character: 1, control_type: 0 }))
    create_list(:battle, 4, winner_side: 2,
                            p1: mic.merge({ character: 1, control_type: 0 }),
                            p2: leo.merge({ character: 5, control_type: 0 }))
    create_list(:battle, 1, winner_side: 1,
                            p1: mic.merge({ character: 1, control_type: 0 }),
                            p2: leo.merge({ character: 6, control_type: 0 }))

    # |       | w | l | d | t |
    # | d_2_1 | 5 | 5 | 0 | 9 |
    # | r_4_1 | 0 | 6 | 1 | 7 |
    # | l_5_0 | 0 | 4 | 0 | 4 |
    # | l_6_0 | 1 | 0 | 0 | 0 |
  end

  describe '#favorites' do
    it 'returns the most played matches' do
      expect(rivals.favorites).to start_with(
        an_object_having_attributes(don.merge(character: 2, control_type: 1, wins: 5, loses: 4, diff: 1, total: 9)),
        an_object_having_attributes(raf.merge(character: 4, control_type: 1, wins: 6, loses: 0, diff: 6, total: 7)),
        an_object_having_attributes(leo.merge(character: 5, control_type: 0, wins: 0, loses: 4, diff: -4, total: 4))
      )
    end
  end

  describe '#tormentors' do
    it 'returns the opponents that won the most' do
      expect(rivals.tormentors).to start_with(
        an_object_having_attributes(leo.merge(character: 5, control_type: 0, wins: 0, loses: 4, diff: -4, total: 4)),
        an_object_having_attributes(don.merge(character: 2, control_type: 1, wins: 5, loses: 4, diff: 1, total: 9)),
        an_object_having_attributes(leo.merge(character: 6, control_type: 0, wins: 1, loses: 0, diff: 1, total: 1))
      )
    end
  end

  describe '#victims' do
    it 'returns the opponents that lost the most' do
      expect(rivals.victims).to start_with(
        an_object_having_attributes(raf.merge(character: 4, control_type: 1, wins: 6, loses: 0, diff: 6, total: 7)),
        an_object_having_attributes(don.merge(character: 2, control_type: 1, wins: 5, loses: 4, diff: 1, total: 9)),
        an_object_having_attributes(leo.merge(character: 6, control_type: 0, wins: 1, loses: 0, diff: 1, total: 1))
      )
    end
  end
end
