# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/players' do
  let(:player) { create(:player, name: 'Player Name', main_character: 10) }

  describe 'GET /players/:sid' do
    it_behaves_like 'a layout/players page' do
      before { get player_url(player) }
    end

    it do
      get player_url(player)
      expect(response).to redirect_to(player_battles_url(player))
    end
  end
end
