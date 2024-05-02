# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle do
  describe '#challanger' do
    let(:p1) { create(:challanger, side: :p1) }
    let(:p2) { create(:challanger, side: :p2) }
    let(:battle) { create(:battle, :with_challangers, p1:, p2:) }

    it 'returns the player 1' do
      expect(battle.challanger(1)).to eq(p1)
    end

    it 'returns the player 2' do
      expect(battle.challanger(2)).to eq(p2)
    end
  end
end
