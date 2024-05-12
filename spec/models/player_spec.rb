# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player do
  describe '#synchronized?' do
    pending "implement after decide the rule #{__FILE__}"
  end

  describe '#battles' do
    subject(:player_battles) { player.battles }

    let(:player) { create(:player) }

    before do
      create_list(:battle, 3, p1: { player_sid: player.sid })
      create_list(:battle, 4, p2: { player_sid: player.sid })
      create_list(:battle, 5)
    end

    it 'return player battles' do
      expect(player_battles).to have_attributes(count: 7)
    end
  end
end
