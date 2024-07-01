# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle::Statistics do
  subject(:statistics) do
    described_class.new relation
  end

  let(:relation) do
    Battle.pov
          .where(player: { player_sid: mic[:player_sid] })
          .group('opponent.player_sid')
  end

  let(:leo) { { player_sid: generate(:player_sid), name: 'leo', character: 1 } }
  let(:don) { { player_sid: generate(:player_sid), name: 'don', character: 2 } }
  let(:mic) { { player_sid: generate(:player_sid), name: 'mic', character: 1 } }
  let(:raf) { { player_sid: generate(:player_sid), name: 'raf', character: 2 } }

  before do
    create_list(:battle, 5, winner_side: 1, p1: mic, p2: don)
    create_list(:battle, 4, winner_side: 2, p1: mic, p2: don)

    create_list(:battle, 6, winner_side: 2, p1: raf, p2: mic)
    create_list(:battle, 1, winner_side: nil, p1: raf, p2: mic)

    create_list(:battle, 4, winner_side: 2, p1: mic, p2: leo)
    create_list(:battle, 1, winner_side: 1, p1: mic, p2: leo)
  end

  describe '#favorites' do
    it 'returns the most played matches' do
      expect(statistics.favorites).to start_with(
        a_battle_statistic(w: 5, l: 4, d: 0).with_group(player_sid: don[:player_sid]),
        a_battle_statistic(w: 6, l: 0, d: 1).with_group(player_sid: raf[:player_sid]),
        a_battle_statistic(w: 1, l: 4, d: 0).with_group(player_sid: leo[:player_sid])
      )
    end
  end

  describe '#tormentors' do
    it 'returns the opponents that won the most' do
      expect(statistics.tormentors).to start_with(
        a_battle_statistic(w: 1, l: 4, d: 0).with_group(player_sid: leo[:player_sid]),
        a_battle_statistic(w: 5, l: 4, d: 0).with_group(player_sid: don[:player_sid]),
        a_battle_statistic(w: 6, l: 0, d: 1).with_group(player_sid: raf[:player_sid])
      )
    end
  end

  describe '#victims' do
    it 'returns the opponents that lost the most' do
      expect(statistics.victims).to start_with(
        a_battle_statistic(w: 6, l: 0, d: 1).with_group(player_sid: raf[:player_sid]),
        a_battle_statistic(w: 5, l: 4, d: 0).with_group(player_sid: don[:player_sid]),
        a_battle_statistic(w: 1, l: 4, d: 0).with_group(player_sid: leo[:player_sid])
      )
    end
  end
end
