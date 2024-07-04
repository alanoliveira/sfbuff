# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/players/:sid/ranked' do
  let(:player) { create(:player, name: 'Player Name', main_character: 10) }

  describe 'GET /players/:sid/ranked' do
    it_behaves_like 'a layout/players page' do
      before { get player_matchup_chart_url(player) }
    end

    it 'renders a successful response' do
      get player_ranked_url(player)
      expect(response).to be_successful
    end

    context 'when the player has ranked mr battles' do
      before do
        create_list(:battle, 5, :ranked,
                    played_at: Time.zone.now,
                    p1: { player_sid: player.sid, character: player.main_character, mr_variation: 1 },
                    p2: { mr_variation: -1 })
      end

      it 'renders the master rating chart' do
        get player_ranked_url(player)
        assert_select 'h4', text: 'Master Rating'
      end
    end

    context 'when the player has ranked not mr battles' do
      before do
        create_list(:battle, 5, :ranked,
                    played_at: Time.zone.now,
                    p1: { player_sid: player.sid, character: player.main_character,
                          mr_variation: nil, league_point: 100 },
                    p2: { mr_variation: nil })
      end

      it 'renders the league point chart' do
        get player_ranked_url(player)
        assert_select 'h4', text: 'League Point'
      end
    end

    context 'when the player has no ranked battles' do
      before do
        create_list(:battle, 5, :battle_hub, played_at: Time.zone.now, p1: { player_sid: player.sid })
      end

      it 'render no match alert' do
        get player_ranked_url(player)
        expect(response.body).to include('No match found')
      end
    end
  end
end
