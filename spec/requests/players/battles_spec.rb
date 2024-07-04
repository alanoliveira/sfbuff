# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/players/:sid/battles' do
  let(:player) { create(:player, name: 'Player Name', main_character: 10) }

  describe 'GET /players/:sid/battles' do
    it_behaves_like 'a layout/players page' do
      before { get player_battles_url(player) }
    end

    it 'renders a successful response' do
      get player_battles_url(player)
      expect(response).to be_successful
    end

    context 'when the player have battles' do
      before do
        create_list(:battle, 10, p1: { player_sid: player.sid })
      end

      it 'renders the battles' do
        get player_battles_url(player)
        expect(response).to have_rendered('players/battles/_battles')
      end

      it 'renders the rivals' do
        get player_battles_url(player)
        expect(response).to have_rendered('players/battles/_rivals')
      end
    end

    context 'when the player have no battle' do
      it 'does not renders battles' do
        get player_battles_url(player)
        expect(response).not_to have_rendered('players/battles/_battles')
      end

      it 'does not renders rivals' do
        get player_battles_url(player)
        expect(response).not_to have_rendered('players/battles/_rivals')
      end
    end
  end
end
